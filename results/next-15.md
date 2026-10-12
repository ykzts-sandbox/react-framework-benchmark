# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T03:20:15Z
- Scope: next-15
- OS: Debian GNU/Linux 13 (trixie) (Linux 7.0.12-linuxkit aarch64)
- CPU: 8 cores; CPU implementer=0x61 CPU part=0x000 
- Memory: 11.7 GiB
- Docker: 29.9.0
- Node.js image: node:24.21.0-alpine (v24.21.0)
- npm in image: 11.19.0
- Base image size: 237469016 bytes (226.5 MiB)
- Static route modules: 500
- Image size metric: `docker image inspect --format '{{.Size}}'`, the local uncompressed image size, including the shared base image
- Added size: image size minus the base image size
- Compressed size: config blob plus layer blobs of the linux platform manifest after `docker push` to a temporary registry. This is the `docker pull` transfer size. Attestation manifests are excluded.
- Compressed added size: compressed size minus the base image compressed size
- Build output: `.next` excluding `.next/cache` for Next.js, `build/` for React Router Framework Mode, and `dist/` for React Router Data Mode and Declarative Mode
- Build time: wall-clock time of the production build command inside a fresh builder container. Dependency installation is not included.
- These builds are cold application builds. Docker may reuse the `npm ci` layer when the lockfile is unchanged.

## Versions

```text
next-15-benchmark@ /app
+-- next@15.5.27
+-- react-dom@19.3.0
`-- react@19.3.0


next-pages-15-benchmark@ /app
+-- next@15.5.27
+-- react-dom@19.3.0
`-- react@19.3.0


```

## Route comparison

| Framework / Bundler | Build time (s) | Image size (bytes) | Added size (bytes) | Build output (bytes) |
| --- | ---: | ---: | ---: | ---: |
| Next.js 15 App Router / webpack / sharp | 34.148 | 344702657 | 107233641 | 91620086 |
| Next.js 15 App Router / webpack / no sharp | 33.040 | 316187206 | 78718190 | 72216077 |
| Next.js 15 App Router / Turbopack / sharp | 53.546 | 361348475 | 123879459 | 127996686 |
| Next.js 15 App Router / Turbopack / no sharp | 51.683 | 332839449 | 95370433 | 108592742 |
| Next.js 15 App Router / Rspack / sharp | 23.832 | 344647724 | 107178708 | 89775634 |
| Next.js 15 App Router / Rspack / no sharp | 23.864 | 316132765 | 78663749 | 70371748 |
| Next.js 15 Pages Router / webpack / sharp | 17.530 | 329337016 | 91868000 | 69608555 |
| Next.js 15 Pages Router / webpack / no sharp | 17.890 | 300820523 | 63351507 | 50204609 |
| Next.js 15 Pages Router / Turbopack / sharp | 30.722 | 360426864 | 122957848 | 83486597 |
| Next.js 15 Pages Router / Turbopack / no sharp | 29.306 | 331919986 | 94450970 | 64084695 |
| Next.js 15 Pages Router / Rspack / sharp | 15.078 | 329389665 | 91920649 | 69333030 |
| Next.js 15 Pages Router / Rspack / no sharp | 15.349 | 300869458 | 63400442 | 49927546 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 15 App Router / webpack / sharp | 79431596 | 17371406 |
| Next.js 15 App Router / webpack / no sharp | 70601522 | 8541332 |
| Next.js 15 App Router / Turbopack / sharp | 79504998 | 17444808 |
| Next.js 15 App Router / Turbopack / no sharp | 70677253 | 8617063 |
| Next.js 15 App Router / Rspack / sharp | 79397143 | 17336953 |
| Next.js 15 App Router / Rspack / no sharp | 70567561 | 8507371 |
| Next.js 15 Pages Router / webpack / sharp | 79102371 | 17042181 |
| Next.js 15 Pages Router / webpack / no sharp | 70271255 | 8211065 |
| Next.js 15 Pages Router / Turbopack / sharp | 79316571 | 17256381 |
| Next.js 15 Pages Router / Turbopack / no sharp | 70486878 | 8426688 |
| Next.js 15 Pages Router / Rspack / sharp | 79101772 | 17041582 |
| Next.js 15 Pages Router / Rspack / no sharp | 70271038 | 8210848 |

## Build details

### results/next-15-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=34.148
BENCH_METRIC output_bytes=91620086
BENCH_METRIC cache_bytes=396597459
BENCH_METRIC standalone_bytes=71972248
BENCH_METRIC static_bytes=2393670
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=74365919
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3959
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 13473159	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 2393670	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 150463	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9220	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 997	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-15-webpack-no-sharp.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=33.040
BENCH_METRIC output_bytes=72216077
BENCH_METRIC cache_bytes=396597050
BENCH_METRIC standalone_bytes=52571552
BENCH_METRIC static_bytes=2393670
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 363260	.next/standalone/.next/server/chunks/80571.js

# runtime image
BENCH_METRIC app_bytes=54965223
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3884
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 13473159	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 2393670	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 150463	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9358	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 997	.next/build-manifest.json
BENCH_DIR 598	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 363260	.next/server/chunks/80571.js
BENCH_NATIVE
```

### results/next-15-turbopack.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=53.546
BENCH_METRIC output_bytes=127996686
BENCH_METRIC cache_bytes=181994
BENCH_METRIC standalone_bytes=74181115
BENCH_METRIC static_bytes=922228
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=75103344
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=8020
BENCH_DIRS
BENCH_DIR 26214710	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 15747319	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 922228	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 129173	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9120	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 802	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-15-turbopack-no-sharp.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=51.683
BENCH_METRIC output_bytes=108592742
BENCH_METRIC cache_bytes=181994
BENCH_METRIC standalone_bytes=54780419
BENCH_METRIC static_bytes=922228
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js

# runtime image
BENCH_METRIC app_bytes=55702648
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=7945
BENCH_DIRS
BENCH_DIR 26214710	node_modules/next
BENCH_DIR 15747319	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 922228	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 129173	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9258	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 802	.next/build-manifest.json
BENCH_DIR 598	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 24	.next/package.json
BENCH_DIR 21	.next/BUILD_ID
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 348452	.next/static/chunks/fcc261bdc7324589.js
BENCH_NATIVE
```

### results/next-15-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=23.832
BENCH_METRIC output_bytes=89775634
BENCH_METRIC cache_bytes=269949
BENCH_METRIC standalone_bytes=72094552
BENCH_METRIC static_bytes=918697
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=73013250
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3958
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 13622637	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 918697	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 123247	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9220	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 1039	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 480955	.next/static/chunks/lib-05c2acca7eff90c4.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-15-rspack-no-sharp.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=23.864
BENCH_METRIC output_bytes=70371748
BENCH_METRIC cache_bytes=269949
BENCH_METRIC standalone_bytes=52693860
BENCH_METRIC static_bytes=918697
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 362550	.next/standalone/.next/server/chunks/73321.js

# runtime image
BENCH_METRIC app_bytes=53612558
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3883
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 13622641	.next/server
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 918697	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 123247	.next/app-build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 18380	.next/app-path-routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9358	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 1039	.next/build-manifest.json
BENCH_DIR 598	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 480955	.next/static/chunks/lib-05c2acca7eff90c4.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
```

### results/next-pages-15-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=17.530
BENCH_METRIC output_bytes=69608555
BENCH_METRIC cache_bytes=91352553
BENCH_METRIC standalone_bytes=62643302
BENCH_METRIC static_bytes=731779
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=63375082
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3438
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4136603	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 731779	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 134622	.next/routes-manifest.json
BENCH_DIR 120550	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9079	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-15-webpack-no-sharp.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=17.890
BENCH_METRIC output_bytes=50204609
BENCH_METRIC cache_bytes=91352802
BENCH_METRIC standalone_bytes=43242606
BENCH_METRIC static_bytes=731779
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js

# runtime image
BENCH_METRIC app_bytes=43974386
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3363
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4136603	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 731779	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 134622	.next/routes-manifest.json
BENCH_DIR 120550	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9217	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 249	pages/_app.tsx
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/dynamic-css-manifest.json
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_NATIVE
```

### results/next-pages-15-turbopack.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=30.722
BENCH_METRIC output_bytes=83486597
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=62902395
BENCH_METRIC static_bytes=12719421
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=75621817
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=7975
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 12719421	.next/static
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4475035	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 134622	.next/routes-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 83799	.next/build-manifest.json
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 8896	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-15-turbopack-no-sharp.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=29.306
BENCH_METRIC output_bytes=64084695
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=43502703
BENCH_METRIC static_bytes=12719421
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js

# runtime image
BENCH_METRIC app_bytes=56222125
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=7900
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 12719421	.next/static
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4475035	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 135626	.next/routes-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 83799	.next/build-manifest.json
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9034	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 24	.next/package.json
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 1	public/.gitkeep
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329156	.next/static/chunks/64ffac2fafd641c0.js
BENCH_NATIVE
```

### results/next-pages-15-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=15.078
BENCH_METRIC output_bytes=69333030
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=62757518
BENCH_METRIC static_bytes=799154
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=63556673
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3439
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4226127	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 799154	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 144238	.next/build-manifest.json
BENCH_DIR 135626	.next/routes-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9079	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-15-rspack-no-sharp.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=15.349
BENCH_METRIC output_bytes=49927546
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=43355818
BENCH_METRIC static_bytes=799154
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 9112572	.next/standalone/node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	.next/standalone/node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js

# runtime image
BENCH_METRIC app_bytes=44154973
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3364
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4226127	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 799154	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 144238	.next/build-manifest.json
BENCH_DIR 134622	.next/routes-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9217	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 604	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 249	pages/_app.tsx
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/dynamic-css-manifest.json
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1359783	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 822498	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815117	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 551528	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 551519	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 526518	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 526509	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 525805	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 449613	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 384015	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 363603	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_NATIVE
```

