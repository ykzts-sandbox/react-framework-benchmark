// Render the README charts. Build time is the median from
// results/build-times.md. Image size comes from results/benchmark.md and
// results/no-standalone.md. Writes results/build-time.svg and
// results/image-size.svg.
import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

const root = path.join(import.meta.dirname, "..");
const results = path.join(root, "results");
const mib = 1_048_576;

const read = (file) => readFileSync(path.join(results, file), "utf-8");

const tableRows = (markdown, columns) => {
  const rows = new Map();
  const pattern = new RegExp(
    String.raw`^\| ((?:Next\.js|React Router)[^|]*?) \|${String.raw` ([\d.]+) \|`.repeat(columns)}$`,
    "gmu"
  );

  for (const match of markdown.matchAll(pattern)) {
    rows.set(match[1], match.slice(2).map(Number));
  }

  return rows;
};

const benchmark = read("benchmark.md");
const noStandalone = read("no-standalone.md");
// Runs, median, mean, stdev, min, P25, P75, max. Keep the median.
const repeated = tableRows(read("build-times.md"), 8);
const buildRows = new Map(
  [...repeated].map(([label, values]) => [label, [values[1]]])
);
const runs = Math.min(...[...repeated.values()].map((values) => values[0]));
const compressedRows = new Map([
  ...tableRows(benchmark, 2),
  ...tableRows(noStandalone, 2),
]);
const baseCompressed = Number(
  /Base image compressed size: (?<bytes>\d+) bytes/u.exec(benchmark)?.groups
    ?.bytes
);

const lookup = (rows, label) => {
  const row = rows.get(label);

  if (row === undefined) {
    throw new Error(`missing row: ${label}`);
  }

  return row[0];
};

const series = [
  ["next16", "Next.js 16"],
  ["next15", "Next.js 15"],
  ["router", "React Router"],
];

const nextGroups = [
  ["next16", "Next.js 16", "App Router"],
  ["next16", "Next.js 16", "Pages Router"],
  ["next15", "Next.js 15", "App Router"],
  ["next15", "Next.js 15", "Pages Router"],
];

const routerRows = ["Framework", "Data", "Declarative"].map((mode) => ({
  key: "router",
  label: `React Router ${mode}`,
  source: `React Router ${mode} / Vite + Rolldown`,
}));

const buildChart = {
  file: "build-time.svg",
  format: (seconds) => `${seconds.toFixed(1)}秒`,
  groups: [
    ...nextGroups.map(([key, version, router]) =>
      ["webpack", "Turbopack", "Rspack"].map((bundler) => ({
        key,
        label: `${version} ${router} (${bundler})`,
        source: `${version} ${router} / ${bundler} / sharp`,
      }))
    ),
    routerRows,
  ],
  note: `依存のインストールを除いた本番ビルドのコマンドの時間を${runs}回ずつ計った中央値です`,
  rows: buildRows,
  tick: (seconds) => `${seconds}秒`,
  title: "ビルドの時間",
};

const sizeChart = {
  file: "image-size.svg",
  format: (size) => `${size.toFixed(1)} MiB`,
  groups: [
    ...nextGroups.map(([key, version, router]) => [
      {
        key,
        label: `${version} ${router}`,
        source: `${version} ${router} / webpack / sharp`,
      },
      {
        key,
        label: `${version} ${router} (sharpなし)`,
        source: `${version} ${router} / webpack / no sharp`,
      },
      {
        key,
        label: `${version} ${router} (standaloneなし)`,
        source: `${version} ${router} / webpack / sharp / no standalone`,
      },
    ]),
    routerRows,
  ],
  note: "docker pullで送られる圧縮後の大きさでNext.jsはwebpackでビルドしたものです",
  reference: { label: "ベースのnode:24.21.0-alpine", value: baseCompressed },
  rows: compressedRows,
  tick: (size) => `${size} MiB`,
  title: "Dockerイメージの大きさ",
  unit: mib,
};

const escape = (text) =>
  text.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

// Rough advance widths for the label column. CJK glyphs are one em and
// Latin glyphs about 0.58 em in the system sans-serif fonts.
const textWidth = (text, size) =>
  [...text].reduce(
    (sum, char) => sum + (/[　-鿿]/u.test(char) ? size : size * 0.58),
    0
  );

const niceStep = (max) => {
  const raw = max / 5;
  const power = 10 ** Math.floor(Math.log10(raw));

  for (const factor of [1, 2, 2.5, 5, 10]) {
    if (raw <= factor * power) {
      return factor * power;
    }
  }

  return 10 * power;
};

const style = `
  .surface { fill: #fcfcfb; }
  .title { fill: #0b0b0b; font-size: 18px; font-weight: 600; }
  .note, .tick, .reference-label { fill: #52514e; font-size: 12px; }
  .label { fill: #0b0b0b; font-size: 13px; }
  .value { fill: #52514e; font-size: 12px; }
  .legend { fill: #0b0b0b; font-size: 12px; }
  .grid { stroke: #e1e0d9; stroke-width: 1; }
  .baseline { stroke: #c3c2b7; stroke-width: 1; }
  .reference { stroke: #52514e; stroke-width: 1; stroke-dasharray: 4 3; }
  .next16 { fill: #2a78d6; }
  .next15 { fill: #eb6834; }
  .router { fill: #1baf7a; }
  @media (prefers-color-scheme: dark) {
    .surface { fill: #1a1a19; }
    .title, .label, .legend { fill: #f0efec; }
    .note, .tick, .value, .reference-label { fill: #c3c2b7; }
    .grid { stroke: #2c2c2a; }
    .baseline { stroke: #383835; }
    .reference { stroke: #c3c2b7; }
    .next16 { fill: #3987e5; }
    .next15 { fill: #d95926; }
    .router { fill: #199e70; }
  }
`;

// Square at the baseline, 4px rounded at the data end.
const barPath = (x, y, width, height) => {
  const radius = Math.min(4, width / 2, height / 2);

  return [
    `M${x},${y}`,
    `H${x + width - radius}`,
    `Q${x + width},${y} ${x + width},${y + radius}`,
    `V${y + height - radius}`,
    `Q${x + width},${y + height} ${x + width - radius},${y + height}`,
    `H${x}`,
    "Z",
  ].join(" ");
};

const render = (chart) => {
  const rows = chart.groups.map((group) =>
    group.map((row) => ({
      ...row,
      value: lookup(chart.rows, row.source) / (chart.unit ?? 1),
    }))
  );
  const flat = rows.flat();
  const max = Math.max(...flat.map((row) => row.value));
  const step = niceStep(max);
  const axisMax = Math.ceil(max / step) * step;

  const padding = 24;
  const barHeight = 16;
  const rowGap = 6;
  const groupGap = 14;
  const labelWidth = Math.ceil(
    Math.max(...flat.map((row) => textWidth(row.label, 13)))
  );
  const plotLeft = padding + labelWidth + 12;
  const plotWidth = 520;
  const valueRoom = 72;
  const width = plotLeft + plotWidth + valueRoom + padding;
  const top = 96;
  const scale = (value) => (value / axisMax) * plotWidth;

  const parts = [];
  let y = top;

  for (const group of rows) {
    for (const row of group) {
      const barWidth = scale(row.value);
      const text = chart.format(row.value);
      parts.push(
        `<g><title>${escape(`${row.label}: ${text}`)}</title>`,
        `<text class="label" x="${plotLeft - 12}" y="${y + barHeight - 4}" text-anchor="end">${escape(row.label)}</text>`,
        `<path class="${row.key}" d="${barPath(plotLeft, y, barWidth, barHeight)}"/>`,
        `<text class="value" x="${plotLeft + barWidth + 6}" y="${y + barHeight - 4}">${escape(text)}</text>`,
        "</g>"
      );
      y += barHeight + rowGap;
    }

    y += groupGap - rowGap;
  }

  const plotBottom = y - groupGap + rowGap;
  const grid = [];

  for (let tick = 0; tick <= axisMax; tick += step) {
    const x = plotLeft + scale(tick);
    grid.push(
      `<line class="${tick === 0 ? "baseline" : "grid"}" x1="${x}" y1="${top - 6}" x2="${x}" y2="${plotBottom}"/>`,
      `<text class="tick" x="${x}" y="${plotBottom + 16}" text-anchor="middle">${escape(chart.tick(tick))}</text>`
    );
  }

  if (chart.reference !== undefined) {
    const value = chart.reference.value / (chart.unit ?? 1);
    const x = plotLeft + scale(value);
    grid.push(
      `<line class="reference" x1="${x}" y1="${top - 6}" x2="${x}" y2="${plotBottom}"/>`,
      `<text class="reference-label" x="${x + 4}" y="${top - 10}">${escape(`${chart.reference.label} ${chart.format(value)}`)}</text>`
    );
  }

  const legend = [];
  let legendX = padding;

  for (const [key, label] of series) {
    legend.push(
      `<rect class="${key}" x="${legendX}" y="58" width="12" height="12" rx="2"/>`,
      `<text class="legend" x="${legendX + 18}" y="68">${escape(label)}</text>`
    );
    legendX += 18 + textWidth(label, 12) + 20;
  }

  const height = plotBottom + 40;
  const font =
    'system-ui, -apple-system, "Hiragino Sans", "Noto Sans JP", "Noto Sans CJK JP", "Yu Gothic", sans-serif';

  return `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" font-family='${font}' role="img" aria-label="${escape(chart.title)}">
<style>${style}</style>
<rect class="surface" width="100%" height="100%" rx="8"/>
<text class="title" x="${padding}" y="32">${escape(chart.title)}</text>
<text class="note" x="${padding}" y="50">${escape(chart.note)}</text>
${legend.join("\n")}
${grid.join("\n")}
${parts.join("\n")}
</svg>
`;
};

for (const chart of [buildChart, sizeChart]) {
  writeFileSync(path.join(results, chart.file), render(chart));
  console.log(`wrote results/${chart.file}`);
}
