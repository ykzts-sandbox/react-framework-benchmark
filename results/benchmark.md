# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-11T19:53:24Z
- Scope: all
- OS: Debian GNU/Linux 13 (trixie) (Linux 7.0.12-linuxkit aarch64)
- CPU: 8 cores; CPU implementer	=0x61 CPU part	=0x000 
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
| Next.js 16 App Router / webpack / sharp | 31.153 | 327526412 | 90057396 | 91605387 |
| Next.js 16 App Router / webpack / no sharp | 29.490 | 299009867 | 61540851 | 72201396 |
| Next.js 16 App Router / Turbopack / sharp | 8.378 | 326809982 | 89340966 | 73421749 |
| Next.js 16 App Router / Turbopack / no sharp | 9.131 | 297759848 | 60290832 | 53600947 |
| Next.js 16 App Router / Rspack / sharp | 25.811 | 327490742 | 90021726 | 79785490 |
| Next.js 16 App Router / Rspack / no sharp | 27.798 | 298973590 | 61504574 | 60381670 |
| Next.js 16 Pages Router / webpack / sharp | 18.161 | 315554260 | 78085244 | 53083432 |
| Next.js 16 Pages Router / webpack / no sharp | 16.892 | 287037585 | 49568569 | 33679700 |
| Next.js 16 Pages Router / Turbopack / sharp | 6.746 | 321447549 | 83978533 | 59624772 |
| Next.js 16 Pages Router / Turbopack / no sharp | 6.581 | 292391724 | 54922708 | 39803986 |
| Next.js 16 Pages Router / Rspack / sharp | 15.126 | 315601901 | 78132885 | 52681319 |
| Next.js 16 Pages Router / Rspack / no sharp | 14.815 | 287084987 | 49615971 | 33277172 |
| Next.js 15 App Router / webpack / sharp | 37.955 | 344702634 | 107233618 | 91625121 |
| Next.js 15 App Router / webpack / no sharp | 36.125 | 316187213 | 78718197 | 72221218 |
| Next.js 15 App Router / Turbopack / sharp | 57.250 | 361348393 | 123879377 | 127997745 |
| Next.js 15 App Router / Turbopack / no sharp | 56.114 | 332835280 | 95366264 | 108593808 |
| Next.js 15 App Router / Rspack / sharp | 27.220 | 344647596 | 107178580 | 89778584 |
| Next.js 15 App Router / Rspack / no sharp | 27.451 | 316132814 | 78663798 | 70374561 |
| Next.js 15 Pages Router / webpack / sharp | 19.503 | 327201634 | 89732618 | 63267902 |
| Next.js 15 Pages Router / webpack / no sharp | 19.823 | 298693390 | 61224374 | 43864164 |
| Next.js 15 Pages Router / Turbopack / sharp | 33.520 | 358247911 | 120778895 | 83060010 |
| Next.js 15 Pages Router / Turbopack / no sharp | 34.224 | 329719642 | 92250626 | 63656156 |
| Next.js 15 Pages Router / Rspack / sharp | 17.068 | 327248967 | 89779951 | 62928323 |
| Next.js 15 Pages Router / Rspack / no sharp | 16.113 | 298734488 | 61265472 | 43524635 |
| React Router Framework / Vite + Rolldown | 2.676 | 292142623 | 54673607 | 1186102 |
| React Router Data / Vite + Rolldown | 0.442 | 240049232 | 2580216 | 444159 |
| React Router Declarative / Vite + Rolldown | 0.547 | 239975945 | 2506929 | 389649 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 77402359 | 15342169 |
| Next.js 16 App Router / webpack / no sharp | 68567095 | 6506905 |
| Next.js 16 App Router / Turbopack / sharp | 74687081 | 12626891 |
| Next.js 16 App Router / Turbopack / no sharp | 65785172 | 3724982 |
| Next.js 16 App Router / Rspack / sharp | 77378977 | 15318787 |
| Next.js 16 App Router / Rspack / no sharp | 68547202 | 6487012 |
| Next.js 16 Pages Router / webpack / sharp | 77267647 | 15207457 |
| Next.js 16 Pages Router / webpack / no sharp | 68436349 | 6376159 |
| Next.js 16 Pages Router / Turbopack / sharp | 74702696 | 12642506 |
| Next.js 16 Pages Router / Turbopack / no sharp | 65799192 | 3739002 |
| Next.js 16 Pages Router / Rspack / sharp | 77266136 | 15205946 |
| Next.js 16 Pages Router / Rspack / no sharp | 68434599 | 6374409 |
| Next.js 15 App Router / webpack / sharp | 79431573 | 17371383 |
| Next.js 15 App Router / webpack / no sharp | 70601529 | 8541339 |
| Next.js 15 App Router / Turbopack / sharp | 79504916 | 17444726 |
| Next.js 15 App Router / Turbopack / no sharp | 70677180 | 8616990 |
| Next.js 15 App Router / Rspack / sharp | 79397015 | 17336825 |
| Next.js 15 App Router / Rspack / no sharp | 70567610 | 8507420 |
| Next.js 15 Pages Router / webpack / sharp | 79064141 | 17003951 |
| Next.js 15 Pages Router / webpack / no sharp | 70233082 | 8172892 |
| Next.js 15 Pages Router / Turbopack / sharp | 79283922 | 17223732 |
| Next.js 15 Pages Router / Turbopack / no sharp | 70449222 | 8389032 |
| Next.js 15 Pages Router / Rspack / sharp | 79066418 | 17006228 |
| Next.js 15 Pages Router / Rspack / no sharp | 70237316 | 8177126 |
| React Router Framework / Vite + Rolldown | 69887567 | 7827377 |
| React Router Data / Vite + Rolldown | 62182907 | 122717 |
| React Router Declarative / Vite + Rolldown | 62166964 | 106774 |

## Build details

### results/next-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=31.153
BENCH_METRIC output_bytes=91605387
BENCH_METRIC cache_bytes=218113351
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
BENCH_METRIC build_seconds=29.490
BENCH_METRIC output_bytes=72201396
BENCH_METRIC cache_bytes=218126960
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
BENCH_METRIC build_seconds=8.378
BENCH_METRIC output_bytes=73421749
BENCH_METRIC cache_bytes=94150891
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
BENCH_METRIC build_seconds=9.131
BENCH_METRIC output_bytes=53600947
BENCH_METRIC cache_bytes=94100018
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
BENCH_METRIC build_seconds=25.811
BENCH_METRIC output_bytes=79785490
BENCH_METRIC cache_bytes=645258413
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
BENCH_METRIC build_seconds=27.798
BENCH_METRIC output_bytes=60381670
BENCH_METRIC cache_bytes=645258003
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
BENCH_METRIC build_seconds=18.161
BENCH_METRIC output_bytes=53083432
BENCH_METRIC cache_bytes=86566479
BENCH_METRIC standalone_bytes=49268625
BENCH_METRIC static_bytes=730998
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=49999624
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3551
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1013456	.next/server
BENCH_DIR 730998	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 120506	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73936	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=16.892
BENCH_METRIC output_bytes=33679700
BENCH_METRIC cache_bytes=86566469
BENCH_METRIC standalone_bytes=29867929
BENCH_METRIC static_bytes=730998
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=30598928
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3476
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1013456	.next/server
BENCH_DIR 730998	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 120506	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73936	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=6.746
BENCH_METRIC output_bytes=59624772
BENCH_METRIC cache_bytes=61941001
BENCH_METRIC standalone_bytes=46118223
BENCH_METRIC static_bytes=754888
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=46873112
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=6203
BENCH_DIRS
BENCH_DIR 19102200	node_modules/@img
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 8626593	.next/server
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 754888	.next/static
BENCH_DIR 631459	node_modules/sharp
BENCH_DIR 142782	.next/build-manifest.json
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73936	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=6.581
BENCH_METRIC output_bytes=39803986
BENCH_METRIC cache_bytes=61860469
BENCH_METRIC standalone_bytes=26304629
BENCH_METRIC static_bytes=754888
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=27059518
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=6110
BENCH_DIRS
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 8626593	.next/server
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 754888	.next/static
BENCH_DIR 142782	.next/build-manifest.json
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73936	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=15.126
BENCH_METRIC output_bytes=52681319
BENCH_METRIC cache_bytes=52589566
BENCH_METRIC standalone_bytes=49349670
BENCH_METRIC static_bytes=739632
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=50089303
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3552
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1070879	.next/server
BENCH_DIR 739632	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 144194	.next/build-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73940	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=14.815
BENCH_METRIC output_bytes=33277172
BENCH_METRIC cache_bytes=52589612
BENCH_METRIC standalone_bytes=29948970
BENCH_METRIC static_bytes=739632
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=30688603
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3477
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1070879	.next/server
BENCH_DIR 739632	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 144194	.next/build-manifest.json
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73936	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=37.955
BENCH_METRIC output_bytes=91625121
BENCH_METRIC cache_bytes=396594787
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
BENCH_METRIC build_seconds=36.125
BENCH_METRIC output_bytes=72221218
BENCH_METRIC cache_bytes=396595059
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
BENCH_METRIC build_seconds=57.250
BENCH_METRIC output_bytes=127997745
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
BENCH_METRIC build_seconds=56.114
BENCH_METRIC output_bytes=108593808
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
BENCH_METRIC build_seconds=27.220
BENCH_METRIC output_bytes=89778584
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
BENCH_METRIC build_seconds=27.451
BENCH_METRIC output_bytes=70374561
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
BENCH_METRIC build_seconds=19.503
BENCH_METRIC output_bytes=63267902
BENCH_METRIC cache_bytes=85847384
BENCH_METRIC standalone_bytes=59434346
BENCH_METRIC static_bytes=722279
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=60156626
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3438
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 988431	.next/server
BENCH_DIR 722279	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 120550	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73838	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=19.823
BENCH_METRIC output_bytes=43864164
BENCH_METRIC cache_bytes=85847565
BENCH_METRIC standalone_bytes=40033650
BENCH_METRIC static_bytes=722279
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=40755930
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3363
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 988431	.next/server
BENCH_DIR 722279	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 120550	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73838	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=33.520
BENCH_METRIC output_bytes=83060010
BENCH_METRIC cache_bytes=180551
BENCH_METRIC standalone_bytes=62356271
BENCH_METRIC static_bytes=12708921
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=75065193
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=7475
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 12708921	.next/static
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 3989695	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 83799	.next/build-manifest.json
BENCH_DIR 73838	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=34.224
BENCH_METRIC output_bytes=63656156
BENCH_METRIC cache_bytes=180551
BENCH_METRIC standalone_bytes=42955583
BENCH_METRIC static_bytes=12708921
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=55664505
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=7400
BENCH_DIRS
BENCH_DIR 26213792	node_modules/next
BENCH_DIR 12708921	.next/static
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 3989695	.next/server
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 83799	.next/build-manifest.json
BENCH_DIR 73846	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=17.068
BENCH_METRIC output_bytes=62928323
BENCH_METRIC cache_bytes=180551
BENCH_METRIC standalone_bytes=59518023
BENCH_METRIC static_bytes=789654
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=60307678
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=3439
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1048416	.next/server
BENCH_DIR 789654	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 144238	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73842	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=16.113
BENCH_METRIC output_bytes=43524635
BENCH_METRIC cache_bytes=180551
BENCH_METRIC standalone_bytes=40117323
BENCH_METRIC static_bytes=789654
BENCH_METRIC static_html_count=500
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
BENCH_METRIC app_bytes=40906978
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=3364
BENCH_DIRS
BENCH_DIR 26255948	node_modules/next
BENCH_DIR 9116192	node_modules/typescript
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 1048416	.next/server
BENCH_DIR 789654	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 144238	.next/build-manifest.json
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 105233	node_modules/postcss
BENCH_DIR 84331	node_modules/react
BENCH_DIR 73838	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=2.676
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
BENCH_METRIC build_seconds=0.442
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
BENCH_METRIC build_seconds=0.547
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

