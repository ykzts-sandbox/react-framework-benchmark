import { readdirSync, realpathSync, statSync } from "node:fs";
import path from "node:path";

const root = "/app";
const seen = new Set();
const files = [];

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
    files.push({ path: full, size });
  }
};

visit(root);

const total = (selected) => selected.reduce((sum, file) => sum + file.size, 0);

const isNative = (file) =>
  file.endsWith(".node") ||
  file.endsWith(".wasm") ||
  /\.so(?:\.|$)/u.test(file);

const native = files.filter((file) => isNative(file.path));
const directories = new Map();

for (const file of files) {
  const relative = path.relative(root, file.path);
  const parts = relative.split(path.sep);
  const key = parts.slice(0, Math.min(2, parts.length)).join("/");
  directories.set(key, (directories.get(key) ?? 0) + file.size);
}

const bySize = (left, right) => right.size - left.size;

console.log(`BENCH_METRIC app_bytes=${total(files)}`);
console.log(`BENCH_METRIC native_bytes=${total(native)}`);
console.log(`BENCH_METRIC file_count=${files.length}`);
console.log("BENCH_DIRS");

for (const [directory, size] of [...directories.entries()]
  .toSorted((left, right) => right[1] - left[1])
  .slice(0, 25)) {
  console.log(`BENCH_DIR ${size}\t${directory}`);
}

console.log("BENCH_LARGEST");

for (const file of files.toSorted(bySize).slice(0, 20)) {
  console.log(`BENCH_FILE ${file.size}\t${path.relative(root, file.path)}`);
}

console.log("BENCH_NATIVE");

for (const file of native.toSorted(bySize)) {
  console.log(`BENCH_FILE ${file.size}\t${path.relative(root, file.path)}`);
}
