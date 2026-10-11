import { spawnSync } from "node:child_process";
import {
  existsSync,
  readdirSync,
  realpathSync,
  statSync,
  writeFileSync,
} from "node:fs";
import path from "node:path";

const appRoot = "/app";
const bundler = process.env.BUNDLER ?? "turbopack";
const lines = [];

const metric = (key, value) => {
  const line = `BENCH_METRIC ${key}=${value}`;
  lines.push(line);
  console.log(line);
};

const note = (size, file) => {
  const line = `BENCH_FILE ${size}\t${file}`;
  lines.push(line);
  console.log(line);
};

const collect = (root, { skipNames = new Set() } = {}) => {
  const seen = new Set();
  const files = [];
  let total = 0;

  const visit = (directory) => {
    let entries;
    try {
      entries = readdirSync(directory, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      if (directory === root && skipNames.has(entry.name)) {
        continue;
      }

      const full = path.join(directory, entry.name);
      let resolved;
      try {
        resolved = realpathSync(full);
      } catch {
        continue;
      }

      if (entry.isDirectory()) {
        visit(full);
        continue;
      }

      if (!(entry.isFile() || entry.isSymbolicLink()) || seen.has(resolved)) {
        continue;
      }

      seen.add(resolved);
      const { size } = statSync(resolved);
      total += size;
      files.push({ path: full, size });
    }
  };

  if (existsSync(root)) {
    visit(root);
  }

  return { files, total };
};

const countHtml = (root) => {
  if (!existsSync(root)) {
    return 0;
  }

  return collect(root).files.filter((file) => file.path.endsWith(".html"))
    .length;
};

const isNativeArtifact = (file) =>
  file.endsWith(".node") ||
  file.endsWith(".wasm") ||
  /\.so(?:\.|$)/u.test(file);

const buildArgumentsFor = (name) => {
  if (name === "webpack") {
    return ["build"];
  }

  if (name === "turbopack") {
    return ["build", "--turbopack"];
  }

  if (name === "rspack") {
    return ["build"];
  }

  return null;
};

const buildArguments = buildArgumentsFor(bundler);

if (buildArguments === null) {
  console.error(`unsupported BUNDLER: ${bundler}`);
  process.exit(1);
}

const started = process.hrtime.bigint();
const result = spawnSync(
  path.join(appRoot, "node_modules/.bin/next"),
  buildArguments,
  {
    cwd: appRoot,
    env: process.env,
    stdio: "inherit",
  }
);
const elapsed = Number(process.hrtime.bigint() - started) / 1e9;

if (result.status !== 0) {
  process.exit(result.status ?? 1);
}

const output = collect(path.join(appRoot, ".next"), {
  skipNames: new Set(["cache"]),
});
const cache = collect(path.join(appRoot, ".next", "cache"));
const standalone = collect(path.join(appRoot, ".next", "standalone"));
const staticAssets = collect(path.join(appRoot, ".next", "static"));
const native = standalone.files.filter((file) => isNativeArtifact(file.path));
const bySize = (left, right) => right.size - left.size;

const router = existsSync(path.join(appRoot, "pages")) ? "pages" : "app";
const serverRoutes = path.join(
  appRoot,
  ".next",
  "server",
  router === "pages" ? "pages" : "app"
);

metric("bundler", bundler);
metric("router", router);
metric("build_seconds", elapsed.toFixed(3));
metric("output_bytes", output.total);
metric("cache_bytes", cache.total);
metric("standalone_bytes", standalone.total);
metric("static_bytes", staticAssets.total);
metric("static_html_count", countHtml(path.join(serverRoutes, "static")));
metric("dynamic_html_count", countHtml(path.join(serverRoutes, "dynamic")));
metric(
  "standalone_server",
  existsSync(path.join(appRoot, ".next", "standalone", "server.js"))
    ? "standalone/server.js"
    : "missing"
);
metric(
  "native_bytes",
  native.reduce((sum, file) => sum + file.size, 0)
);

console.log("BENCH_LARGEST standalone");

for (const file of standalone.files.toSorted(bySize).slice(0, 20)) {
  note(file.size, path.relative(appRoot, file.path));
}

console.log("BENCH_NATIVE standalone");

for (const file of native.toSorted(bySize)) {
  note(file.size, path.relative(appRoot, file.path));
}

writeFileSync("/tmp/bench-metrics.txt", `${lines.join("\n")}\n`);
