# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T07:34:13Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker
- Scope: next-15
- OS: Debian GNU/Linux 13 (trixie) (Linux 7.0.12-linuxkit aarch64)
- CPU: 8 cores; CPU implementer=0x61 CPU part=0x000 
- Memory: 11.7 GiB
- Docker: 29.9.0
- Node.js image: node:24.21.0-alpine (v24.21.0)
- npm in image: 11.19.0
- Base image size: 237469016 bytes (226.5 MiB)
- Static route modules: 20
- Dynamic route modules: 30, each reading ids 1 to 1000 of its own kind from Laravel
- Image size metric: `docker image inspect --format '{{.Size}}'`, the local uncompressed image size, including the shared base image
- Added size: image size minus the base image size
- Compressed size: config blob plus layer blobs of the linux platform manifest after `docker push` to a temporary registry. This is the `docker pull` transfer size. Attestation manifests are excluded.
- Compressed added size: compressed size minus the base image compressed size
- Build output: `.next` excluding `.next/cache` for Next.js, `build/` for React Router Framework Mode, and `dist/` for React Router Data Mode and Declarative Mode
- No standalone: built with `STANDALONE=0`, which leaves `output` unset, and run from the `runner-full` stage. It has the production `node_modules` and `.next` without `cache`, and runs `next start`.
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
| Next.js 15 App Router / webpack / sharp | 15.928 | 324030002 | 86560986 | 63561456 |
| Next.js 15 App Router / webpack / no sharp | 14.495 | 295514021 | 58045005 | 44157489 |
| Next.js 15 App Router / Turbopack / sharp | 17.581 | 325793712 | 88324696 | 69095340 |
| Next.js 15 App Router / Turbopack / no sharp | 16.944 | 297279471 | 59810455 | 49691411 |
| Next.js 15 App Router / Rspack / sharp | 12.962 | 324028376 | 86559360 | 63489776 |
| Next.js 15 App Router / Rspack / no sharp | 13.257 | 295507817 | 58038801 | 44085980 |
| Next.js 15 Pages Router / webpack / sharp | 12.639 | 321663617 | 84194601 | 60409759 |
| Next.js 15 Pages Router / webpack / no sharp | 12.357 | 293154334 | 55685318 | 41005526 |
| Next.js 15 Pages Router / Turbopack / sharp | 13.095 | 324632979 | 87163963 | 62291498 |
| Next.js 15 Pages Router / Turbopack / no sharp | 13.544 | 296121995 | 58652979 | 42887561 |
| Next.js 15 Pages Router / Rspack / sharp | 11.641 | 321671962 | 84202946 | 60366212 |
| Next.js 15 Pages Router / Rspack / no sharp | 11.539 | 293158609 | 55689593 | 40962273 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 15 App Router / webpack / sharp | 79222557 | 17162367 |
| Next.js 15 App Router / webpack / no sharp | 70391953 | 8331763 |
| Next.js 15 App Router / Turbopack / sharp | 79216795 | 17156605 |
| Next.js 15 App Router / Turbopack / no sharp | 70387931 | 8327741 |
| Next.js 15 App Router / Rspack / sharp | 79216835 | 17156645 |
| Next.js 15 App Router / Rspack / no sharp | 70381653 | 8321463 |
| Next.js 15 Pages Router / webpack / sharp | 78986092 | 16925902 |
| Next.js 15 Pages Router / webpack / no sharp | 70158090 | 8097900 |
| Next.js 15 Pages Router / Turbopack / sharp | 78981758 | 16921568 |
| Next.js 15 Pages Router / Turbopack / no sharp | 70152055 | 8091865 |
| Next.js 15 Pages Router / Rspack / sharp | 78986245 | 16926055 |
| Next.js 15 Pages Router / Rspack / no sharp | 70158269 | 8098079 |

## Build details

### results/next-15-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=15.928
BENCH_METRIC output_bytes=63561456
BENCH_METRIC cache_bytes=80455782
BENCH_METRIC standalone_bytes=60150785
BENCH_METRIC static_bytes=836468
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
BENCH_METRIC app_bytes=60987254
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2156
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1865657	.next/server
BENCH_DIR 836468	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 15997	.next/app-build-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9220	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 996	.next/build-manifest.json
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
BENCH_METRIC build_seconds=14.495
BENCH_METRIC output_bytes=44157489
BENCH_METRIC cache_bytes=80455553
BENCH_METRIC standalone_bytes=40750089
BENCH_METRIC static_bytes=836468
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
BENCH_FILE 362550	.next/standalone/.next/server/chunks/571.js

# runtime image
BENCH_METRIC app_bytes=41586558
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2081
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1865657	.next/server
BENCH_DIR 836468	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 15997	.next/app-build-manifest.json
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9358	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
BENCH_DIR 1587	.next/prerender-manifest.json
BENCH_DIR 996	.next/build-manifest.json
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
BENCH_FILE 362550	.next/server/chunks/571.js
BENCH_NATIVE
```

### results/next-15-turbopack.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=17.581
BENCH_METRIC output_bytes=69095340
BENCH_METRIC cache_bytes=116909
BENCH_METRIC standalone_bytes=60292919
BENCH_METRIC static_bytes=904944
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
BENCH_METRIC app_bytes=61197864
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2608
BENCH_DIRS
BENCH_DIR 26214710	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 2054306	.next/server
BENCH_DIR 904944	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13484	.next/app-build-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9120	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
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
BENCH_METRIC build_seconds=16.944
BENCH_METRIC output_bytes=49691411
BENCH_METRIC cache_bytes=116909
BENCH_METRIC standalone_bytes=40892223
BENCH_METRIC static_bytes=904944
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
BENCH_METRIC app_bytes=41797168
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2533
BENCH_DIRS
BENCH_DIR 26214710	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 2054306	.next/server
BENCH_DIR 904944	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13484	.next/app-build-manifest.json
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9258	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
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
BENCH_FILE 331168	.next/static/chunks/4f03a8fa7154b252.js
BENCH_NATIVE
```

### results/next-15-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=12.962
BENCH_METRIC output_bytes=63489776
BENCH_METRIC cache_bytes=126236
BENCH_METRIC standalone_bytes=60161920
BENCH_METRIC static_bytes=825505
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
BENCH_METRIC app_bytes=60987426
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2155
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1879558	.next/server
BENCH_DIR 825505	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13188	.next/app-build-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9220	.next/required-server-files.json
BENCH_DIR 6834	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
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
BENCH_FILE 480954	.next/static/chunks/lib-4c1934ae3bc43c46.js
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
BENCH_METRIC build_seconds=13.257
BENCH_METRIC output_bytes=44085980
BENCH_METRIC cache_bytes=126236
BENCH_METRIC standalone_bytes=40761224
BENCH_METRIC static_bytes=825505
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
BENCH_FILE 361847	.next/standalone/.next/server/chunks/3321.js

# runtime image
BENCH_METRIC app_bytes=41586730
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2080
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1879558	.next/server
BENCH_DIR 825505	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13188	.next/app-build-manifest.json
BENCH_DIR 10890	.next/routes-manifest.json
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9358	.next/required-server-files.json
BENCH_DIR 6936	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2129	.next/app-path-routes-manifest.json
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
BENCH_FILE 480954	.next/static/chunks/lib-4c1934ae3bc43c46.js
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
BENCH_METRIC build_seconds=12.639
BENCH_METRIC output_bytes=60409759
BENCH_METRIC cache_bytes=24244186
BENCH_METRIC standalone_bytes=58890510
BENCH_METRIC static_bytes=490025
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
BENCH_METRIC app_bytes=59380536
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2085
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 604073	.next/server
BENCH_DIR 490025	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21713	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13197	.next/build-manifest.json
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
BENCH_METRIC build_seconds=12.357
BENCH_METRIC output_bytes=41005526
BENCH_METRIC cache_bytes=24247651
BENCH_METRIC standalone_bytes=39489654
BENCH_METRIC static_bytes=490025
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
BENCH_METRIC app_bytes=39979680
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2010
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 604073	.next/server
BENCH_DIR 490025	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 13197	.next/build-manifest.json
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
BENCH_METRIC build_seconds=13.095
BENCH_METRIC output_bytes=62291498
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=58874678
BENCH_METRIC static_bytes=1648469
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
BENCH_METRIC app_bytes=60523148
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2563
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1648469	.next/static
BENCH_DIR 635035	.next/server
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9151	.next/build-manifest.json
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
BENCH_METRIC build_seconds=13.544
BENCH_METRIC output_bytes=42887561
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=39473982
BENCH_METRIC static_bytes=1648469
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
BENCH_METRIC app_bytes=41122452
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2488
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1648469	.next/static
BENCH_DIR 635035	.next/server
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 10847	node_modules/@next
BENCH_DIR 9151	.next/build-manifest.json
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
BENCH_FILE 328821	.next/static/chunks/6c7faa6b4adb92ac.js
BENCH_NATIVE
```

### results/next-pages-15-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=11.641
BENCH_METRIC output_bytes=60366212
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=58901517
BENCH_METRIC static_bytes=497068
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
BENCH_METRIC app_bytes=59398586
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2086
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 612749	.next/server
BENCH_DIR 497068	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 15688	.next/build-manifest.json
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
BENCH_METRIC build_seconds=11.539
BENCH_METRIC output_bytes=40962273
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=39500821
BENCH_METRIC static_bytes=497068
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
BENCH_METRIC app_bytes=39997890
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2011
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 612749	.next/server
BENCH_DIR 497068	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 20531	node_modules/@swc
BENCH_DIR 15688	.next/build-manifest.json
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

