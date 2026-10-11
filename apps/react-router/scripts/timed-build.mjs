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

const collect = (root) => {
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

const isNativeArtifact = (file) =>
  file.endsWith(".node") ||
  file.endsWith(".wasm") ||
  /\.so(?:\.|$)/u.test(file);

const started = process.hrtime.bigint();
const result = spawnSync(
  path.join(appRoot, "node_modules/.bin/react-router"),
  ["build"],
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

const output = collect(path.join(appRoot, "build"));
const client = collect(path.join(appRoot, "build", "client"));
const server = collect(path.join(appRoot, "build", "server"));
const native = output.files.filter((file) => isNativeArtifact(file.path));
const bySize = (left, right) => right.size - left.size;

metric("bundler", "vite-rolldown");
metric("build_seconds", elapsed.toFixed(3));
metric("output_bytes", output.total);
metric("client_bytes", client.total);
metric("server_bytes", server.total);
metric(
  "client_html_count",
  client.files.filter((file) => file.path.endsWith(".html")).length
);
metric(
  "native_bytes",
  native.reduce((sum, file) => sum + file.size, 0)
);

console.log("BENCH_LARGEST build");

for (const file of output.files.toSorted(bySize).slice(0, 20)) {
  note(file.size, path.relative(appRoot, file.path));
}

console.log("BENCH_NATIVE build");

for (const file of native.toSorted(bySize)) {
  note(file.size, path.relative(appRoot, file.path));
}

writeFileSync("/tmp/bench-metrics.txt", `${lines.join("\n")}\n`);
