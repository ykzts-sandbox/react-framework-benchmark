import { createReadStream, existsSync, statSync } from "node:fs";
import { request as httpRequest, createServer } from "node:http";
import { request as httpsRequest } from "node:https";
import path from "node:path";

const root = path.join(import.meta.dirname, "dist");
const port = Number(process.env.PORT ?? 3000);
const laravelOrigin = new URL(
  process.env.LARAVEL_ORIGIN ?? "http://laravel:8000"
);
const laravelRequest =
  laravelOrigin.protocol === "https:" ? httpsRequest : httpRequest;

const types = {
  ".css": "text/css; charset=utf-8",
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".json": "application/json",
  ".map": "application/json",
  ".svg": "image/svg+xml",
};

const insideRoot = (candidate) => {
  const relative = path.relative(root, candidate);
  return (
    relative !== "" && !relative.startsWith("..") && !path.isAbsolute(relative)
  );
};

const contentType = (file) =>
  types[path.extname(file)] ?? "application/octet-stream";

const send = (response, file) => {
  if (!existsSync(file)) {
    response.writeHead(404);
    response.end();
    return;
  }

  response.writeHead(200, { "Content-Type": contentType(file) });
  createReadStream(file).pipe(response);
};

const proxyApi = (request, response) => {
  const target = new URL(request.url ?? "/", laravelOrigin);
  const upstream = laravelRequest(
    target,
    {
      headers: { ...request.headers, host: target.host },
      method: request.method,
    },
    (upstreamResponse) => {
      const responseHeaders = {};
      const cacheControl = upstreamResponse.headers["cache-control"];
      const type = upstreamResponse.headers["content-type"];

      if (typeof cacheControl === "string") {
        responseHeaders["Cache-Control"] = cacheControl;
      }

      if (typeof type === "string") {
        responseHeaders["Content-Type"] = type;
      }

      response.writeHead(upstreamResponse.statusCode ?? 502, responseHeaders);
      upstreamResponse.pipe(response);
    }
  );

  upstream.on("error", () => {
    if (response.headersSent) {
      response.destroy();
      return;
    }

    response.writeHead(502);
    response.end();
  });
  request.pipe(upstream);
};

const server = createServer((request, response) => {
  const url = new URL(request.url ?? "/", "http://127.0.0.1");

  if (url.pathname === "/api" || url.pathname.startsWith("/api/")) {
    proxyApi(request, response);
    return;
  }

  const candidate = path.resolve(root, `.${url.pathname}`);
  const index = path.join(root, "index.html");

  if (candidate === root) {
    send(response, index);
    return;
  }

  if (!insideRoot(candidate)) {
    response.writeHead(400);
    response.end();
    return;
  }

  if (existsSync(candidate) && statSync(candidate).isFile()) {
    send(response, candidate);
    return;
  }

  if (path.extname(url.pathname) !== "") {
    response.writeHead(404);
    response.end();
    return;
  }

  send(response, index);
});

server.listen(port, "0.0.0.0");
