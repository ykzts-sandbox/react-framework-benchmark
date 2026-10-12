// Summarize results/build-times.csv into results/build-times.md.
import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const results = path.join(import.meta.dirname, "..", "results");
// List the variants in the order of scripts/bench-repeat.sh.
const order = [
  ...readFileSync(
    path.join(import.meta.dirname, "bench-repeat.sh"),
    "utf-8"
  ).matchAll(/^(?<label>(?:Next\.js|React Router)[^|]+)\|/gmu),
].map((match) => match.groups.label);
const lines = readFileSync(path.join(results, "build-times.csv"), "utf-8")
  .trim()
  .split("\n")
  .slice(1);

const samples = new Map();
const finished = [];

for (const line of lines) {
  const [, label, seconds, finishedAt] = line.split(",");
  const values = samples.get(label) ?? [];
  values.push(Number(seconds));
  samples.set(label, values);
  finished.push(finishedAt);
}

const quantile = (sorted, q) => {
  const position = (sorted.length - 1) * q;
  const lower = Math.floor(position);
  const upper = Math.ceil(position);

  return sorted[lower] + (sorted[upper] - sorted[lower]) * (position - lower);
};

const format = (value) => value.toFixed(3);
const rows = [];

const labels = [...samples.keys()].toSorted(
  (left, right) => order.indexOf(left) - order.indexOf(right)
);

for (const label of labels) {
  const values = samples.get(label);
  const sorted = values.toSorted((left, right) => left - right);
  const mean = sorted.reduce((sum, value) => sum + value, 0) / sorted.length;
  const variance =
    sorted.reduce((sum, value) => sum + (value - mean) ** 2, 0) /
    Math.max(sorted.length - 1, 1);

  rows.push(
    `| ${label} | ${sorted.length} | ${format(quantile(sorted, 0.5))} | ${format(mean)} | ${format(Math.sqrt(variance))} | ${format(sorted[0])} | ${format(quantile(sorted, 0.25))} | ${format(quantile(sorted, 0.75))} | ${format(sorted.at(-1))} |`
  );
}

finished.sort();

const report = `# Repeated build times

Measured by \`scripts/bench-repeat.sh\`. Each run starts a fresh container from the variant's \`source\` stage and runs the same timed build as \`scripts/bench.sh\`. Variants run round-robin. Raw runs are in \`results/build-times.csv\`.

- First run finished: ${finished[0]}
- Last run finished: ${finished.at(-1)}
${process.env.BENCH_HOST === undefined ? "" : `- Host: ${process.env.BENCH_HOST}\n`}
| Framework / Bundler | Runs | Median (s) | Mean (s) | Stdev (s) | Min (s) | P25 (s) | P75 (s) | Max (s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
${rows.join("\n")}
`;

writeFileSync(path.join(results, "build-times.md"), report);
console.log("wrote results/build-times.md");
