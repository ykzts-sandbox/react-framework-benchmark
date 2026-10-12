# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T03:07:31Z
- Scope: all
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
next-benchmark@ /app
+-- next@16.4.0
+-- react-dom@19.3.0
`-- react@19.3.0


next-pages-benchmark@ /app
+-- next@16.4.0
+-- react-dom@19.3.0
`-- react@19.3.0


next-15-benchmark@ /app
+-- next@15.5.27
+-- react-dom@19.3.0
`-- react@19.3.0


next-pages-15-benchmark@ /app
+-- next@15.5.27
+-- react-dom@19.3.0
`-- react@19.3.0


react-router-benchmark@ /app
+-- @react-router/node@8.4.0
+-- @react-router/serve@8.4.0
+-- isbot@5.2.2
+-- react-dom@19.3.0
+-- react-router@8.4.0
`-- react@19.3.0


1.2.13

react-router-data-benchmark@ /app
+-- react-dom@19.3.0
+-- react-router@8.4.0
`-- react@19.3.0


1.2.13

```

## Route comparison

| Framework / Bundler | Build time (s) | Image size (bytes) | Added size (bytes) | Build output (bytes) |
| --- | ---: | ---: | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 28.112 | 327526490 | 90057474 | 91600293 |
| Next.js 16 App Router / webpack / no sharp | 26.982 | 299010801 | 61541785 | 72196434 |
| Next.js 16 App Router / Turbopack / sharp | 7.179 | 326810909 | 89341893 | 73420696 |
| Next.js 16 App Router / Turbopack / no sharp | 6.485 | 297759776 | 60290760 | 53599909 |
| Next.js 16 App Router / Rspack / sharp | 22.661 | 327490238 | 90021222 | 79782362 |
| Next.js 16 App Router / Rspack / no sharp | 25.526 | 298974354 | 61505338 | 60378735 |
| Next.js 16 Pages Router / webpack / sharp | 16.742 | 319758173 | 82289157 | 63339350 |
| Next.js 16 Pages Router / webpack / no sharp | 16.127 | 291239457 | 53770441 | 43933612 |
| Next.js 16 Pages Router / Turbopack / sharp | 5.579 | 323654347 | 86185331 | 59780351 |
| Next.js 16 Pages Router / Turbopack / no sharp | 5.777 | 294611616 | 57142600 | 39961594 |
| Next.js 16 Pages Router / Rspack / sharp | 14.469 | 319799848 | 82330832 | 62861646 |
| Next.js 16 Pages Router / Rspack / no sharp | 13.431 | 291286808 | 53817792 | 43459839 |
| Next.js 15 App Router / webpack / sharp | 32.709 | 344703080 | 107234064 | 91620203 |
| Next.js 15 App Router / webpack / no sharp | 30.748 | 316187396 | 78718380 | 72215916 |
| Next.js 15 App Router / Turbopack / sharp | 51.515 | 361348812 | 123879796 | 127996693 |
| Next.js 15 App Router / Turbopack / no sharp | 54.773 | 332835378 | 95366362 | 108592752 |
| Next.js 15 App Router / Rspack / sharp | 25.388 | 344646542 | 107177526 | 89775669 |
| Next.js 15 App Router / Rspack / no sharp | 25.112 | 316132586 | 78663570 | 70371749 |
| Next.js 15 Pages Router / webpack / sharp | 18.023 | 329337542 | 91868526 | 69608561 |
| Next.js 15 Pages Router / webpack / no sharp | 17.499 | 300821045 | 63352029 | 50204691 |
| Next.js 15 Pages Router / Turbopack / sharp | 29.858 | 360432411 | 122963395 | 83490631 |
| Next.js 15 Pages Router / Turbopack / no sharp | 30.134 | 331911705 | 94442689 | 64082650 |
| Next.js 15 Pages Router / Rspack / sharp | 15.537 | 329385547 | 91916531 | 69331024 |
| Next.js 15 Pages Router / Rspack / no sharp | 14.881 | 300869414 | 63400398 | 49927036 |
| React Router Framework / Vite + Rolldown | 2.135 | 292142623 | 54673607 | 1186102 |
| React Router Data / Vite + Rolldown | 0.323 | 240049232 | 2580216 | 444159 |
| React Router Declarative / Vite + Rolldown | 0.380 | 239975945 | 2506929 | 389649 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 77402437 | 15342247 |
| Next.js 16 App Router / webpack / no sharp | 68568029 | 6507839 |
| Next.js 16 App Router / Turbopack / sharp | 74688008 | 12627818 |
| Next.js 16 App Router / Turbopack / no sharp | 65785100 | 3724910 |
| Next.js 16 App Router / Rspack / sharp | 77378473 | 15318283 |
| Next.js 16 App Router / Rspack / no sharp | 68547966 | 6487776 |
| Next.js 16 Pages Router / webpack / sharp | 77322312 | 15262122 |
| Next.js 16 Pages Router / webpack / no sharp | 68488973 | 6428783 |
| Next.js 16 Pages Router / Turbopack / sharp | 74746806 | 12686616 |
| Next.js 16 Pages Router / Turbopack / no sharp | 65844108 | 3783918 |
| Next.js 16 Pages Router / Rspack / sharp | 77314835 | 15254645 |
| Next.js 16 Pages Router / Rspack / no sharp | 68483076 | 6422886 |
| Next.js 15 App Router / webpack / sharp | 79432019 | 17371829 |
| Next.js 15 App Router / webpack / no sharp | 70601712 | 8541522 |
| Next.js 15 App Router / Turbopack / sharp | 79505335 | 17445145 |
| Next.js 15 App Router / Turbopack / no sharp | 70677278 | 8617088 |
| Next.js 15 App Router / Rspack / sharp | 79395961 | 17335771 |
| Next.js 15 App Router / Rspack / no sharp | 70567382 | 8507192 |
| Next.js 15 Pages Router / webpack / sharp | 79102897 | 17042707 |
| Next.js 15 Pages Router / webpack / no sharp | 70271777 | 8211587 |
| Next.js 15 Pages Router / Turbopack / sharp | 79318022 | 17257832 |
| Next.js 15 Pages Router / Turbopack / no sharp | 70486789 | 8426599 |
| Next.js 15 Pages Router / Rspack / sharp | 79101750 | 17041560 |
| Next.js 15 Pages Router / Rspack / no sharp | 70270994 | 8210804 |
| React Router Framework / Vite + Rolldown | 69887567 | 7827377 |
| React Router Data / Vite + Rolldown | 62182907 | 122717 |
| React Router Declarative / Vite + Rolldown | 62166964 | 106774 |

## Build details

### results/next-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=28.112
BENCH_METRIC output_bytes=91600293
BENCH_METRIC cache_bytes=218124627
BENCH_METRIC standalone_bytes=56202889
BENCH_METRIC static_bytes=2531883
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 695393	.next/standalone/.next/server/chunks/22430.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=58734773
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=4077
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9436565	.next/server
BENCH_DIR 2531883	.next/static
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10819	.next/required-server-files.json
BENCH_DIR 8108	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 512	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 695393	.next/server/chunks/22430.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-webpack-no-sharp.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=26.982
BENCH_METRIC output_bytes=72196434
BENCH_METRIC cache_bytes=218109083
BENCH_METRIC standalone_bytes=36802193
BENCH_METRIC static_bytes=2531883
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 695393	.next/standalone/.next/server/chunks/22430.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 291121	.next/standalone/node_modules/next/dist/compiled/raw-body/index.js

# runtime image
BENCH_METRIC app_bytes=39334077
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=4002
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 9436565	.next/server
BENCH_DIR 2531883	.next/static
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10957	.next/required-server-files.json
BENCH_DIR 8210	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 512	.next/build-manifest.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/react-loadable-manifest.json
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 695393	.next/server/chunks/22430.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 291121	node_modules/next/dist/compiled/raw-body/index.js
BENCH_NATIVE
```

### results/next-turbopack.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=7.179
BENCH_METRIC output_bytes=73420696
BENCH_METRIC cache_bytes=94157297
BENCH_METRIC standalone_bytes=50023458
BENCH_METRIC static_bytes=568796
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 217760	.next/standalone/.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	.next/standalone/node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 126913	.next/standalone/node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=50592255
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=7230
BENCH_DIRS
BENCH_DIR 19102200	node_modules/@img
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 13888898	.next/server
BENCH_DIR 1416698	node_modules/react-dom
BENCH_DIR 631459	node_modules/sharp
BENCH_DIR 568796	.next/static
BENCH_DIR 121455	.next/build-manifest.json
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68746	node_modules/semver
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10681	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 1	public/.gitkeep
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 229820	.next/static/chunks/0rc4o-n058wwa.js
BENCH_FILE 217760	.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 185237	.next/static/chunks/0q7dcktmi0kta.js
BENCH_FILE 159969	node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-turbopack-no-sharp.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=6.485
BENCH_METRIC output_bytes=53599909
BENCH_METRIC cache_bytes=94019313
BENCH_METRIC standalone_bytes=30209864
BENCH_METRIC static_bytes=568796
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 217760	.next/standalone/.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	.next/standalone/node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 126913	.next/standalone/node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js
BENCH_FILE 122961	.next/standalone/node_modules/next/dist/server/base-server.js
BENCH_FILE 121487	.next/standalone/.next/server/middleware-build-manifest.js

# runtime image
BENCH_METRIC app_bytes=30778661
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=7137
BENCH_DIRS
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 13888898	.next/server
BENCH_DIR 1416698	node_modules/react-dom
BENCH_DIR 568796	.next/static
BENCH_DIR 121455	.next/build-manifest.json
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10819	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 1	public/.gitkeep
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 229820	.next/static/chunks/0rc4o-n058wwa.js
BENCH_FILE 217760	.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 185237	.next/static/chunks/0q7dcktmi0kta.js
BENCH_FILE 159969	node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 126913	node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js
BENCH_NATIVE
```

### results/next-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=22.661
BENCH_METRIC output_bytes=79782362
BENCH_METRIC cache_bytes=645257788
BENCH_METRIC standalone_bytes=56181707
BENCH_METRIC static_bytes=1014717
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 687833	.next/standalone/.next/server/chunks/9683.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=57196425
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=4076
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9415505	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 1014717	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10781	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 687833	.next/server/chunks/9683.js
BENCH_FILE 582396	.next/static/chunks/lib-ffaae90e3ca5fba5.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-rspack-no-sharp.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=25.526
BENCH_METRIC output_bytes=60378735
BENCH_METRIC cache_bytes=645259342
BENCH_METRIC standalone_bytes=36781011
BENCH_METRIC static_bytes=1014717
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 687833	.next/standalone/.next/server/chunks/9683.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 291121	.next/standalone/node_modules/next/dist/compiled/raw-body/index.js

# runtime image
BENCH_METRIC app_bytes=37795729
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=4001
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 9415505	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 1014717	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 71299	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10919	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 460	.next/build-manifest.json
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/react-loadable-manifest.json
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 687833	.next/server/chunks/9683.js
BENCH_FILE 582396	.next/static/chunks/lib-ffaae90e3ca5fba5.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_NATIVE
```

### results/next-pages-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=16.742
BENCH_METRIC output_bytes=63339350
BENCH_METRIC cache_bytes=92070602
BENCH_METRIC standalone_bytes=54395099
BENCH_METRIC static_bytes=740498
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=55135598
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3551
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 6078142	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 740498	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 135724	.next/routes-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 120506	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10675	.next/required-server-files.json
BENCH_DIR 8108	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-webpack-no-sharp.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=16.127
BENCH_METRIC output_bytes=43933612
BENCH_METRIC cache_bytes=92070660
BENCH_METRIC standalone_bytes=34993399
BENCH_METRIC static_bytes=740498
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js

# runtime image
BENCH_METRIC app_bytes=35733898
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3476
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 6078142	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 740498	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 134720	.next/routes-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 120506	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10813	.next/required-server-files.json
BENCH_DIR 8210	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 249	pages/_app.tsx
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/dynamic-css-manifest.json
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_NATIVE
```

### results/next-pages-turbopack.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=5.579
BENCH_METRIC output_bytes=59780351
BENCH_METRIC cache_bytes=62355961
BENCH_METRIC standalone_bytes=46453415
BENCH_METRIC static_bytes=762388
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=47215804
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=6703
BENCH_DIRS
BENCH_DIR 19102200	node_modules/@img
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 8901001	.next/server
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 762388	.next/static
BENCH_DIR 631459	node_modules/sharp
BENCH_DIR 142782	.next/build-manifest.json
BENCH_DIR 134720	.next/routes-manifest.json
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68746	node_modules/semver
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10454	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 1	public/.gitkeep
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 336977	.next/static/chunks/3m4kzwpxzeecz.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 159969	node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	node_modules/next/dist/compiled/comment-json/index.js
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-turbopack-no-sharp.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=5.777
BENCH_METRIC output_bytes=39961594
BENCH_METRIC cache_bytes=62411720
BENCH_METRIC standalone_bytes=26640825
BENCH_METRIC static_bytes=762388
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	.next/standalone/node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 142814	.next/standalone/.next/server/middleware-build-manifest.js

# runtime image
BENCH_METRIC app_bytes=27403214
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=6610
BENCH_DIRS
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 8901001	.next/server
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 762388	.next/static
BENCH_DIR 142782	.next/build-manifest.json
BENCH_DIR 135724	.next/routes-manifest.json
BENCH_DIR 84331	node_modules/react
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10592	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 1	public/.gitkeep
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 336977	.next/static/chunks/3m4kzwpxzeecz.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_FILE 292617	node_modules/react-dom/cjs/react-dom-server.edge.production.js
BENCH_FILE 286554	node_modules/react-dom/cjs/react-dom-server.browser.production.js
BENCH_FILE 264184	node_modules/react-dom/cjs/react-dom-server-legacy.node.production.js
BENCH_FILE 258822	node_modules/react-dom/cjs/react-dom-server-legacy.browser.production.js
BENCH_FILE 159969	node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	node_modules/next/dist/compiled/conf/index.js
BENCH_NATIVE
```

### results/next-pages-rspack.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=14.469
BENCH_METRIC output_bytes=62861646
BENCH_METRIC cache_bytes=53004791
BENCH_METRIC standalone_bytes=54437171
BENCH_METRIC static_bytes=749132
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=19042592
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=55186304
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3552
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 6097600	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 749132	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 144194	.next/build-manifest.json
BENCH_DIR 134720	.next/routes-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10637	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_LARGEST
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_NATIVE
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
```

### results/next-pages-rspack-no-sharp.metrics

```text
BENCH_METRIC bundler=rspack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=13.431
BENCH_METRIC output_bytes=43459839
BENCH_METRIC cache_bytes=53004913
BENCH_METRIC standalone_bytes=35037479
BENCH_METRIC static_bytes=749132
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=standalone/server.js
BENCH_METRIC native_bytes=0
BENCH_FILE 4301622	.next/standalone/node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	.next/standalone/node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	.next/standalone/node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	.next/standalone/node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	.next/standalone/node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	.next/standalone/node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	.next/standalone/node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	.next/standalone/node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	.next/standalone/node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	.next/standalone/node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	.next/standalone/node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	.next/standalone/node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	.next/standalone/node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	.next/standalone/node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	.next/standalone/node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	.next/standalone/node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	.next/standalone/node_modules/react-dom/cjs/react-dom-server.node.production.js

# runtime image
BENCH_METRIC app_bytes=35786612
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3477
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 6097600	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 749132	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 144194	.next/build-manifest.json
BENCH_DIR 135724	.next/routes-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10775	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 621	package.json
BENCH_DIR 467	node_modules/client-only
BENCH_DIR 354	.next/prerender-manifest.json
BENCH_DIR 249	pages/_app.tsx
BENCH_DIR 21	.next/BUILD_ID
BENCH_DIR 20	.next/package.json
BENCH_DIR 2	.next/dynamic-css-manifest.json
BENCH_LARGEST
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 1540081	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1364777	node_modules/next/dist/compiled/babel/bundle.js
BENCH_FILE 885783	node_modules/next/dist/compiled/next-devtools/index.js
BENCH_FILE 815049	node_modules/next/dist/compiled/@next/font/dist/fontkit/index.js
BENCH_FILE 800754	node_modules/next/dist/compiled/@edge-runtime/primitives/load.js
BENCH_FILE 715920	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js
BENCH_FILE 715762	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js
BENCH_FILE 704560	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js
BENCH_FILE 704400	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js
BENCH_FILE 525791	node_modules/next/dist/compiled/edge-runtime/index.js
BENCH_FILE 488742	node_modules/next/dist/compiled/@next/font/dist/google/font-data.json
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 387574	node_modules/next/dist/compiled/postcss-preset-env/index.cjs
BENCH_FILE 386098	node_modules/next/dist/server/app-render/app-render.js
BENCH_FILE 363591	node_modules/next/dist/compiled/crypto-browserify/index.js
BENCH_FILE 308356	node_modules/next/dist/compiled/compression/index.js
BENCH_FILE 300544	node_modules/react-dom/cjs/react-dom-server.node.production.js
BENCH_NATIVE
```

### results/next-15-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=32.709
BENCH_METRIC output_bytes=91620203
BENCH_METRIC cache_bytes=396597814
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
BENCH_METRIC build_seconds=30.748
BENCH_METRIC output_bytes=72215916
BENCH_METRIC cache_bytes=396598178
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
BENCH_METRIC build_seconds=51.515
BENCH_METRIC output_bytes=127996693
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
BENCH_METRIC build_seconds=54.773
BENCH_METRIC output_bytes=108592752
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
BENCH_METRIC build_seconds=25.388
BENCH_METRIC output_bytes=89775669
BENCH_METRIC cache_bytes=269949
BENCH_METRIC standalone_bytes=72094556
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
BENCH_METRIC app_bytes=73013254
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3958
BENCH_DIRS
BENCH_DIR 26258420	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 13622641	.next/server
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
BENCH_METRIC build_seconds=25.112
BENCH_METRIC output_bytes=70371749
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
BENCH_METRIC build_seconds=18.023
BENCH_METRIC output_bytes=69608561
BENCH_METRIC cache_bytes=91352681
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
BENCH_METRIC build_seconds=17.499
BENCH_METRIC output_bytes=50204691
BENCH_METRIC cache_bytes=91352637
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
BENCH_METRIC build_seconds=29.858
BENCH_METRIC output_bytes=83490631
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=62904403
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
BENCH_METRIC app_bytes=75623825
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
BENCH_DIR 136630	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=30.134
BENCH_METRIC output_bytes=64082650
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=43501699
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
BENCH_METRIC app_bytes=56221121
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=7900
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 12719421	.next/static
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 4475035	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 134622	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=15.537
BENCH_METRIC output_bytes=69331024
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=62756514
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
BENCH_METRIC app_bytes=63555669
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
BENCH_DIR 134622	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=14.881
BENCH_METRIC output_bytes=49927036
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

### results/react-router.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC build_seconds=2.135
BENCH_METRIC output_bytes=1186102
BENCH_METRIC client_bytes=617250
BENCH_METRIC server_bytes=568852
BENCH_METRIC client_html_count=0
BENCH_METRIC native_bytes=0
BENCH_FILE 568852	build/server/index.js
BENCH_FILE 214705	build/client/assets/entry.client-DF8hY4KR.js
BENCH_FILE 168788	build/client/assets/manifest-df46e402.js
BENCH_FILE 86979	build/client/assets/jsx-runtime-Bbntekxr.js
BENCH_FILE 33652	build/client/assets/errorBoundaries-Doolcmyu.js
BENCH_FILE 10430	build/client/assets/root-CCZxrRf8.js
BENCH_FILE 209	build/client/assets/home-MhivSL-j.js
BENCH_FILE 205	build/client/assets/100-BAQz5-I2.js
BENCH_FILE 205	build/client/assets/101-Cw_zcb8p.js
BENCH_FILE 205	build/client/assets/102-DwKJBT68.js
BENCH_FILE 205	build/client/assets/103-DMIEb94K.js
BENCH_FILE 205	build/client/assets/104-Dbfe5T_H.js
BENCH_FILE 205	build/client/assets/105-ChTV4ucI.js
BENCH_FILE 205	build/client/assets/106-DEAvbDt6.js
BENCH_FILE 205	build/client/assets/107-DCDzO10p.js
BENCH_FILE 205	build/client/assets/108-Drs6GBiu.js
BENCH_FILE 205	build/client/assets/109-aJmpca09.js
BENCH_FILE 205	build/client/assets/110-CJ651zQr.js
BENCH_FILE 205	build/client/assets/111-DL82Fkkk.js
BENCH_FILE 205	build/client/assets/112-D0RLxfgE.js

# runtime image
BENCH_METRIC app_bytes=39888022
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=1941
BENCH_DIRS
BENCH_DIR 23624971	node_modules/typescript
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 2856262	node_modules/react-router
BENCH_DIR 805224	node_modules/source-map
BENCH_DIR 617250	build/client
BENCH_DIR 568852	build/server
BENCH_DIR 374851	node_modules/qs
BENCH_DIR 344185	node_modules/iconv-lite
BENCH_DIR 300044	node_modules/@remix-run
BENCH_DIR 225566	node_modules/mime-db
BENCH_DIR 178663	node_modules/react
BENCH_DIR 102920	node_modules/object-inspect
BENCH_DIR 102370	node_modules/@react-router
BENCH_DIR 85285	node_modules/morgan
BENCH_DIR 85177	node_modules/source-map-support
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 78135	node_modules/compression
BENCH_DIR 76638	node_modules/express
BENCH_DIR 59680	node_modules/path-to-regexp
BENCH_DIR 48820	node_modules/isbot
BENCH_DIR 48581	node_modules/content-disposition
BENCH_DIR 46851	node_modules/router
BENCH_DIR 46542	node_modules/get-intrinsic
BENCH_DIR 42793	node_modules/debug
BENCH_DIR 42536	node_modules/body-parser
BENCH_LARGEST
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 6213092	node_modules/typescript/lib/_tsc.js
BENCH_FILE 1874901	node_modules/typescript/lib/lib.dom.d.ts
BENCH_FILE 1199917	node_modules/react-dom/cjs/react-dom-profiling.development.js
BENCH_FILE 1182785	node_modules/react-dom/cjs/react-dom-client.development.js
BENCH_FILE 699916	node_modules/react-dom/cjs/react-dom-profiling.profiling.js
BENCH_FILE 625168	node_modules/react-dom/cjs/react-dom-client.production.js
BENCH_FILE 609557	node_modules/typescript/lib/lib.webworker.d.ts
BENCH_FILE 588085	node_modules/typescript/lib/typescript.d.ts
BENCH_FILE 568852	build/server/index.js
BENCH_FILE 458095	node_modules/react-dom/cjs/react-dom-server.node.development.js
BENCH_FILE 452252	node_modules/react-dom/cjs/react-dom-server.edge.development.js
BENCH_FILE 451470	node_modules/react-dom/cjs/react-dom-server.browser.development.js
BENCH_FILE 443587	node_modules/typescript/lib/ru/diagnosticMessages.generated.json
BENCH_FILE 421786	node_modules/react-dom/cjs/react-dom-server-legacy.browser.development.js
BENCH_FILE 421783	node_modules/react-dom/cjs/react-dom-server-legacy.node.development.js
BENCH_FILE 399427	node_modules/react-dom/cjs/react-dom-server.bun.development.js
BENCH_FILE 381398	node_modules/typescript/lib/ja/diagnosticMessages.generated.json
BENCH_FILE 346139	node_modules/typescript/lib/ko/diagnosticMessages.generated.json
BENCH_FILE 346016	node_modules/typescript/lib/fr/diagnosticMessages.generated.json
BENCH_NATIVE
```

### results/react-router-data.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC mode=data
BENCH_METRIC build_seconds=0.323
BENCH_METRIC output_bytes=444159
BENCH_METRIC client_html_count=1
BENCH_METRIC client_js_count=501
BENCH_METRIC native_bytes=0
BENCH_FILE 347057	dist/assets/index-D4UIPt5F.js
BENCH_FILE 318	dist/index.html
BENCH_FILE 194	dist/assets/100-B1CpoSGF.js
BENCH_FILE 194	dist/assets/101-BSLXCMr5.js
BENCH_FILE 194	dist/assets/102-DpIBsUwL.js
BENCH_FILE 194	dist/assets/103-kL167K-m.js
BENCH_FILE 194	dist/assets/104-C3wrjrxw.js
BENCH_FILE 194	dist/assets/105-Dc607s9N.js
BENCH_FILE 194	dist/assets/106-DGsycrNy.js
BENCH_FILE 194	dist/assets/107-f5h7jGZt.js
BENCH_FILE 194	dist/assets/108-hnd8bukC.js
BENCH_FILE 194	dist/assets/109-G_gmX5Yy.js
BENCH_FILE 194	dist/assets/110-BXIeWdVZ.js
BENCH_FILE 194	dist/assets/111-CxgsM5cM.js
BENCH_FILE 194	dist/assets/112-DjBuqeVN.js
BENCH_FILE 194	dist/assets/113-B_-JoxMH.js
BENCH_FILE 194	dist/assets/114-DwXWUcoE.js
BENCH_FILE 194	dist/assets/115-Dgvp9-9m.js
BENCH_FILE 194	dist/assets/116-CoJBMTlA.js
BENCH_FILE 194	dist/assets/117-DId8dga1.js

# runtime image
BENCH_METRIC app_bytes=447172
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=503
BENCH_DIRS
BENCH_DIR 443841	dist/assets
BENCH_DIR 3013	server.mjs
BENCH_DIR 318	dist/index.html
BENCH_LARGEST
BENCH_FILE 347057	dist/assets/index-D4UIPt5F.js
BENCH_FILE 3013	server.mjs
BENCH_FILE 318	dist/index.html
BENCH_FILE 194	dist/assets/100-B1CpoSGF.js
BENCH_FILE 194	dist/assets/101-BSLXCMr5.js
BENCH_FILE 194	dist/assets/102-DpIBsUwL.js
BENCH_FILE 194	dist/assets/103-kL167K-m.js
BENCH_FILE 194	dist/assets/104-C3wrjrxw.js
BENCH_FILE 194	dist/assets/105-Dc607s9N.js
BENCH_FILE 194	dist/assets/106-DGsycrNy.js
BENCH_FILE 194	dist/assets/107-f5h7jGZt.js
BENCH_FILE 194	dist/assets/108-hnd8bukC.js
BENCH_FILE 194	dist/assets/109-G_gmX5Yy.js
BENCH_FILE 194	dist/assets/110-BXIeWdVZ.js
BENCH_FILE 194	dist/assets/111-CxgsM5cM.js
BENCH_FILE 194	dist/assets/112-DjBuqeVN.js
BENCH_FILE 194	dist/assets/113-B_-JoxMH.js
BENCH_FILE 194	dist/assets/114-DwXWUcoE.js
BENCH_FILE 194	dist/assets/115-Dgvp9-9m.js
BENCH_FILE 194	dist/assets/116-CoJBMTlA.js
BENCH_NATIVE
```

### results/react-router-declarative.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC mode=declarative
BENCH_METRIC build_seconds=0.380
BENCH_METRIC output_bytes=389649
BENCH_METRIC client_html_count=1
BENCH_METRIC client_js_count=501
BENCH_METRIC native_bytes=0
BENCH_FILE 292547	dist/assets/index-LJspFeen.js
BENCH_FILE 318	dist/index.html
BENCH_FILE 194	dist/assets/100-CQN-W6c6.js
BENCH_FILE 194	dist/assets/101-m_jS8e_2.js
BENCH_FILE 194	dist/assets/102-9UJCQOrD.js
BENCH_FILE 194	dist/assets/103-B6AWDfz7.js
BENCH_FILE 194	dist/assets/104-CE0Vol44.js
BENCH_FILE 194	dist/assets/105-DqFsojg6.js
BENCH_FILE 194	dist/assets/106-D451DUfK.js
BENCH_FILE 194	dist/assets/107-Cz7HbwYF.js
BENCH_FILE 194	dist/assets/108-BAvDPkCr.js
BENCH_FILE 194	dist/assets/109-CXDCT3nT.js
BENCH_FILE 194	dist/assets/110-DDBLg5nJ.js
BENCH_FILE 194	dist/assets/111-C1lrzz7K.js
BENCH_FILE 194	dist/assets/112-Blgqc-3p.js
BENCH_FILE 194	dist/assets/113-BnNBSzTc.js
BENCH_FILE 194	dist/assets/114-DvFWURaR.js
BENCH_FILE 194	dist/assets/115-BTXjWh1x.js
BENCH_FILE 194	dist/assets/116-BMmV7Ffy.js
BENCH_FILE 194	dist/assets/117-B4TRC0T4.js

# runtime image
BENCH_METRIC app_bytes=392662
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=503
BENCH_DIRS
BENCH_DIR 389331	dist/assets
BENCH_DIR 3013	server.mjs
BENCH_DIR 318	dist/index.html
BENCH_LARGEST
BENCH_FILE 292547	dist/assets/index-LJspFeen.js
BENCH_FILE 3013	server.mjs
BENCH_FILE 318	dist/index.html
BENCH_FILE 194	dist/assets/100-CQN-W6c6.js
BENCH_FILE 194	dist/assets/101-m_jS8e_2.js
BENCH_FILE 194	dist/assets/102-9UJCQOrD.js
BENCH_FILE 194	dist/assets/103-B6AWDfz7.js
BENCH_FILE 194	dist/assets/104-CE0Vol44.js
BENCH_FILE 194	dist/assets/105-DqFsojg6.js
BENCH_FILE 194	dist/assets/106-D451DUfK.js
BENCH_FILE 194	dist/assets/107-Cz7HbwYF.js
BENCH_FILE 194	dist/assets/108-BAvDPkCr.js
BENCH_FILE 194	dist/assets/109-CXDCT3nT.js
BENCH_FILE 194	dist/assets/110-DDBLg5nJ.js
BENCH_FILE 194	dist/assets/111-C1lrzz7K.js
BENCH_FILE 194	dist/assets/112-Blgqc-3p.js
BENCH_FILE 194	dist/assets/113-BnNBSzTc.js
BENCH_FILE 194	dist/assets/114-DvFWURaR.js
BENCH_FILE 194	dist/assets/115-BTXjWh1x.js
BENCH_FILE 194	dist/assets/116-BMmV7Ffy.js
BENCH_NATIVE
```

