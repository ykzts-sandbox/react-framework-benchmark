import { createRequire } from "node:module";

import type { NextConfig } from "next";

const appDirectory = import.meta.dirname;
const require = createRequire(import.meta.url);
const sharpExcludes =
  process.env.EXCLUDE_SHARP === "1"
    ? ["node_modules/@img/**/*", "node_modules/sharp/**/*"]
    : [];
const tracingExcludes = [
  ...sharpExcludes,
  "node_modules/@next/rspack-*/**/*",
  "node_modules/@rspack/**/*",
  "node_modules/next-rspack/**/*",
];

const nextConfig: NextConfig = {
  // Varnish stores these responses. The headers are set before Next
  // writes its own Cache-Control for a dynamic request.
  headers() {
    return [
      {
        headers: [
          {
            key: "Cache-Control",
            value: "public, s-maxage=60",
          },
        ],
        source: "/dynamic/:id",
      },
      {
        headers: [
          {
            key: "Cache-Control",
            value: "public, s-maxage=31536000",
          },
        ],
        source: "/static/:id",
      },
    ];
  },
  // STANDALONE=0 builds the image that runs next start with the whole
  // node_modules. See the runner-full stage in the Dockerfile.
  output: process.env.STANDALONE === "0" ? undefined : "standalone",
  // Standalone tracing follows require("next-rspack") below. That package
  // only runs during the build.
  outputFileTracingExcludes: {
    "*": tracingExcludes,
    "/*": tracingExcludes,
  },
  // The repository root has its own lockfile for the lint tools. Keep file
  // tracing inside this app so the standalone server is not nested in a
  // monorepo layout.
  outputFileTracingRoot: appDirectory,
};

// next-rspack only switches the bundler when Turbopack is still on its
// default "auto" setting. Do not wrap the config for webpack or Turbopack.
const config =
  process.env.BUNDLER === "rspack"
    ? (require("next-rspack") as (config: NextConfig) => NextConfig)(nextConfig)
    : nextConfig;

export default config;
