# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T07:23:55Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker
- Scope: all
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
| Next.js 16 App Router / webpack / sharp | 16.016 | 310730102 | 73261086 | 51951040 |
| Next.js 16 App Router / webpack / no sharp | 14.589 | 282217891 | 44748875 | 32547140 |
| Next.js 16 App Router / Turbopack / sharp | 3.858 | 294736247 | 57267231 | 44112295 |
| Next.js 16 App Router / Turbopack / no sharp | 4.526 | 265685158 | 28216142 | 24291496 |
| Next.js 16 App Router / Rspack / sharp | 12.334 | 310696542 | 73227526 | 51704832 |
| Next.js 16 App Router / Rspack / no sharp | 12.197 | 282178535 | 44709519 | 32301045 |
| Next.js 16 Pages Router / webpack / sharp | 12.005 | 310219221 | 72750205 | 50686889 |
| Next.js 16 Pages Router / webpack / no sharp | 11.404 | 281704646 | 44235630 | 31283439 |
| Next.js 16 Pages Router / Turbopack / sharp | 3.330 | 295151268 | 57682252 | 41088046 |
| Next.js 16 Pages Router / Turbopack / no sharp | 3.304 | 266098713 | 28629697 | 21267203 |
| Next.js 16 Pages Router / Rspack / sharp | 10.980 | 310225824 | 72756808 | 50619187 |
| Next.js 16 Pages Router / Rspack / no sharp | 10.969 | 281707036 | 44238020 | 31215104 |
| Next.js 15 App Router / webpack / sharp | 15.926 | 324029998 | 86560982 | 63561473 |
| Next.js 15 App Router / webpack / no sharp | 14.667 | 295513622 | 58044606 | 44157551 |
| Next.js 15 App Router / Turbopack / sharp | 18.308 | 325793572 | 88324556 | 69095341 |
| Next.js 15 App Router / Turbopack / no sharp | 17.373 | 297279409 | 59810393 | 49691410 |
| Next.js 15 App Router / Rspack / sharp | 13.062 | 324027984 | 86558968 | 63489925 |
| Next.js 15 App Router / Rspack / no sharp | 12.811 | 295508340 | 58039324 | 44085950 |
| Next.js 15 Pages Router / webpack / sharp | 13.308 | 321663206 | 84194190 | 60409468 |
| Next.js 15 Pages Router / webpack / no sharp | 12.637 | 293150262 | 55681246 | 41005517 |
| Next.js 15 Pages Router / Turbopack / sharp | 13.532 | 324636565 | 87167549 | 62291556 |
| Next.js 15 Pages Router / Turbopack / no sharp | 13.607 | 296117831 | 58648815 | 42887579 |
| Next.js 15 Pages Router / Rspack / sharp | 11.640 | 321672090 | 84203074 | 60366468 |
| Next.js 15 Pages Router / Rspack / no sharp | 11.471 | 293158300 | 55689284 | 40962245 |
| Next.js 16 App Router / webpack / sharp / no standalone | 10.880 | 679746919 | 442277903 | 3535575 |
| Next.js 15 App Router / webpack / sharp / no standalone | 10.765 | 697638579 | 460169563 | 3331704 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 8.302 | 676425313 | 438956297 | 1689385 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 7.878 | 694607357 | 457138341 | 1441170 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 3.508 | 684323153 | 446854137 | 6228227 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 12.729 | 706146964 | 468677948 | 8724488 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 3.140 | 679554700 | 442085684 | 2645839 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 8.802 | 698684944 | 461215928 | 3338864 |
| React Router Framework / Vite + Rolldown | 1.292 | 289584647 | 52115631 | 448445 |
| React Router Data / Vite + Rolldown | 0.268 | 238142638 | 673622 | 335465 |
| React Router Declarative / Vite + Rolldown | 0.327 | 238072903 | 603887 | 278589 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 77239905 | 15179715 |
| Next.js 16 App Router / webpack / no sharp | 68408975 | 6348785 |
| Next.js 16 App Router / Turbopack / sharp | 74353250 | 12293060 |
| Next.js 16 App Router / Turbopack / no sharp | 65450386 | 3390196 |
| Next.js 16 App Router / Rspack / sharp | 77222729 | 15162539 |
| Next.js 16 App Router / Rspack / no sharp | 68390099 | 6329909 |
| Next.js 16 Pages Router / webpack / sharp | 77191872 | 15131682 |
| Next.js 16 Pages Router / webpack / no sharp | 68358578 | 6298388 |
| Next.js 16 Pages Router / Turbopack / sharp | 74432399 | 12372209 |
| Next.js 16 Pages Router / Turbopack / no sharp | 65528069 | 3467879 |
| Next.js 16 Pages Router / Rspack / sharp | 77190283 | 15130093 |
| Next.js 16 Pages Router / Rspack / no sharp | 68356872 | 6296682 |
| Next.js 15 App Router / webpack / sharp | 79222553 | 17162363 |
| Next.js 15 App Router / webpack / no sharp | 70391554 | 8331364 |
| Next.js 15 App Router / Turbopack / sharp | 79216655 | 17156465 |
| Next.js 15 App Router / Turbopack / no sharp | 70387869 | 8327679 |
| Next.js 15 App Router / Rspack / sharp | 79216443 | 17156253 |
| Next.js 15 App Router / Rspack / no sharp | 70382176 | 8321986 |
| Next.js 15 Pages Router / webpack / sharp | 78985681 | 16925491 |
| Next.js 15 Pages Router / webpack / no sharp | 70158114 | 8097924 |
| Next.js 15 Pages Router / Turbopack / sharp | 78981248 | 16921058 |
| Next.js 15 Pages Router / Turbopack / no sharp | 70151987 | 8091797 |
| Next.js 15 Pages Router / Rspack / sharp | 78986373 | 16926183 |
| Next.js 15 Pages Router / Rspack / no sharp | 70157960 | 8097770 |
| Next.js 16 App Router / webpack / sharp / no standalone | 150951317 | 88891127 |
| Next.js 15 App Router / webpack / sharp / no standalone | 154166817 | 92106627 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 150636175 | 88575985 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 153916779 | 91856589 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 151542142 | 89481952 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 155761153 | 93700963 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 150816442 | 88756252 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 154078590 | 92018400 |
| React Router Framework / Vite + Rolldown | 69836343 | 7776153 |
| React Router Data / Vite + Rolldown | 62164569 | 104379 |
| React Router Declarative / Vite + Rolldown | 62148083 | 87893 |

## Build details

### results/next-webpack.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=16.016
BENCH_METRIC output_bytes=51951040
BENCH_METRIC cache_bytes=69819973
BENCH_METRIC standalone_bytes=48332495
BENCH_METRIC static_bytes=947281
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
BENCH_FILE 694196	.next/standalone/.next/server/chunks/2430.js
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
BENCH_METRIC app_bytes=49279777
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2274
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 1645666	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 947281	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10819	.next/required-server-files.json
BENCH_DIR 8108	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 511	.next/build-manifest.json
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
BENCH_FILE 694196	.next/server/chunks/2430.js
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
BENCH_METRIC build_seconds=14.589
BENCH_METRIC output_bytes=32547140
BENCH_METRIC cache_bytes=69820458
BENCH_METRIC standalone_bytes=28931799
BENCH_METRIC static_bytes=947281
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
BENCH_FILE 694196	.next/standalone/.next/server/chunks/2430.js
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
BENCH_METRIC app_bytes=29879081
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2199
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 1645666	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 947281	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 71299	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10957	.next/required-server-files.json
BENCH_DIR 8210	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
BENCH_DIR 618	package.json
BENCH_DIR 511	.next/build-manifest.json
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
BENCH_FILE 694196	.next/server/chunks/2430.js
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
BENCH_METRIC build_seconds=3.858
BENCH_METRIC output_bytes=44112295
BENCH_METRIC cache_bytes=30133581
BENCH_METRIC standalone_bytes=37863420
BENCH_METRIC static_bytes=568792
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
BENCH_FILE 217761	.next/standalone/.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	.next/standalone/node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 126913	.next/standalone/node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js
BENCH_FILE 18712760	.next/standalone/node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 329832	.next/standalone/node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node

# runtime image
BENCH_METRIC app_bytes=38432213
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=1818
BENCH_DIRS
BENCH_DIR 19102200	node_modules/@img
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 1916376	.next/server
BENCH_DIR 1416698	node_modules/react-dom
BENCH_DIR 631459	node_modules/sharp
BENCH_DIR 568792	.next/static
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68746	node_modules/semver
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 13433	.next/build-manifest.json
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10681	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
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
BENCH_FILE 229820	.next/static/chunks/3dmm3v_fq28gc.js
BENCH_FILE 217761	.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 185233	.next/static/chunks/3c4xol65z2da2.js
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
BENCH_METRIC build_seconds=4.526
BENCH_METRIC output_bytes=24291496
BENCH_METRIC cache_bytes=30110799
BENCH_METRIC standalone_bytes=18049826
BENCH_METRIC static_bytes=568792
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
BENCH_FILE 217761	.next/standalone/.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 159969	.next/standalone/node_modules/next/dist/server/use-cache/use-cache-wrapper.js
BENCH_FILE 157171	.next/standalone/node_modules/next/dist/compiled/comment-json/index.js
BENCH_FILE 150256	.next/standalone/node_modules/next/dist/client/components/segment-cache/cache.js
BENCH_FILE 143364	.next/standalone/node_modules/next/dist/compiled/conf/index.js
BENCH_FILE 126913	.next/standalone/node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js
BENCH_FILE 122961	.next/standalone/node_modules/next/dist/server/base-server.js
BENCH_FILE 121051	.next/standalone/node_modules/next/dist/compiled/jsonwebtoken/index.js

# runtime image
BENCH_METRIC app_bytes=18618619
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=1725
BENCH_DIRS
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 1916376	.next/server
BENCH_DIR 1416698	node_modules/react-dom
BENCH_DIR 568792	.next/static
BENCH_DIR 71299	node_modules/react
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 13433	.next/build-manifest.json
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10819	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
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
BENCH_FILE 229820	.next/static/chunks/3dmm3v_fq28gc.js
BENCH_FILE 217761	.next/server/chunks/ssr/[root-of-the-server]__07irjv8er3ezd._.js
BENCH_FILE 185233	.next/static/chunks/3c4xol65z2da2.js
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
BENCH_METRIC build_seconds=12.334
BENCH_METRIC output_bytes=51704832
BENCH_METRIC cache_bytes=38547671
BENCH_METRIC standalone_bytes=48323844
BENCH_METRIC static_bytes=929119
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
BENCH_FILE 686638	.next/standalone/.next/server/chunks/9683.js
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
BENCH_METRIC app_bytes=49252964
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2273
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 1637136	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 929119	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 71299	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11429	node_modules/detect-libc
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10781	.next/required-server-files.json
BENCH_DIR 8076	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
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
BENCH_FILE 686638	.next/server/chunks/9683.js
BENCH_FILE 582394	.next/static/chunks/lib-32168cb3e2dca12d.js
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
BENCH_METRIC build_seconds=12.197
BENCH_METRIC output_bytes=32301045
BENCH_METRIC cache_bytes=38547780
BENCH_METRIC standalone_bytes=28923148
BENCH_METRIC static_bytes=929119
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
BENCH_FILE 686638	.next/standalone/.next/server/chunks/9683.js
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
BENCH_METRIC app_bytes=29852268
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2198
BENCH_DIRS
BENCH_DIR 25071931	node_modules/next
BENCH_DIR 1637136	.next/server
BENCH_DIR 1416814	node_modules/react-dom
BENCH_DIR 929119	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 71299	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_DIR 11000	node_modules/@next
BENCH_DIR 10919	.next/required-server-files.json
BENCH_DIR 8178	server.js
BENCH_DIR 3215	node_modules/picocolors
BENCH_DIR 2912	node_modules/nanoid
BENCH_DIR 2534	.next/prerender-manifest.json
BENCH_DIR 2172	.next/app-path-routes-manifest.json
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
BENCH_FILE 686638	.next/server/chunks/9683.js
BENCH_FILE 582394	.next/static/chunks/lib-32168cb3e2dca12d.js
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
BENCH_METRIC build_seconds=12.005
BENCH_METRIC output_bytes=50686889
BENCH_METRIC cache_bytes=24914613
BENCH_METRIC standalone_bytes=48915910
BENCH_METRIC static_bytes=498358
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
BENCH_METRIC app_bytes=49414269
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2198
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 820379	.next/server
BENCH_DIR 498358	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21651	.next/routes-manifest.json
BENCH_DIR 13153	.next/build-manifest.json
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
BENCH_METRIC build_seconds=11.404
BENCH_METRIC output_bytes=31283439
BENCH_METRIC cache_bytes=24918481
BENCH_METRIC standalone_bytes=29515374
BENCH_METRIC static_bytes=498358
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
BENCH_METRIC app_bytes=30013733
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2123
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 820379	.next/server
BENCH_DIR 498358	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21811	.next/routes-manifest.json
BENCH_DIR 13153	.next/build-manifest.json
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
BENCH_METRIC build_seconds=3.330
BENCH_METRIC output_bytes=41088046
BENCH_METRIC cache_bytes=17377274
BENCH_METRIC standalone_bytes=38421699
BENCH_METRIC static_bytes=410895
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
BENCH_METRIC app_bytes=38832595
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=1743
BENCH_DIRS
BENCH_DIR 19102200	node_modules/@img
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 1109649	.next/server
BENCH_DIR 631459	node_modules/sharp
BENCH_DIR 410895	.next/static
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68746	node_modules/semver
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21651	.next/routes-manifest.json
BENCH_DIR 15487	.next/build-manifest.json
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
BENCH_FILE 336558	.next/static/chunks/233hddxuiajsp.js
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
BENCH_METRIC build_seconds=3.304
BENCH_METRIC output_bytes=21267203
BENCH_METRIC cache_bytes=17357843
BENCH_METRIC standalone_bytes=18608105
BENCH_METRIC static_bytes=410895
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
BENCH_FILE 126913	.next/standalone/node_modules/next/dist/compiled/next-server/pages-turbo.runtime.prod.js

# runtime image
BENCH_METRIC app_bytes=19019001
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=1650
BENCH_DIRS
BENCH_DIR 14532101	node_modules/next
BENCH_DIR 2760687	node_modules/react-dom
BENCH_DIR 1109649	.next/server
BENCH_DIR 410895	.next/static
BENCH_DIR 84331	node_modules/react
BENCH_DIR 30691	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21651	.next/routes-manifest.json
BENCH_DIR 15487	.next/build-manifest.json
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
BENCH_FILE 336558	.next/static/chunks/233hddxuiajsp.js
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
BENCH_METRIC build_seconds=10.980
BENCH_METRIC output_bytes=50619187
BENCH_METRIC cache_bytes=10114202
BENCH_METRIC standalone_bytes=48918873
BENCH_METRIC static_bytes=497346
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
BENCH_METRIC app_bytes=49416220
BENCH_METRIC native_bytes=19042592
BENCH_METRIC file_count=2199
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 19091339	node_modules/@img
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 820761	.next/server
BENCH_DIR 497346	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 229339	node_modules/sharp
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 68829	node_modules/semver
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21811	.next/routes-manifest.json
BENCH_DIR 15644	.next/build-manifest.json
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
BENCH_METRIC build_seconds=10.969
BENCH_METRIC output_bytes=31215104
BENCH_METRIC cache_bytes=10114088
BENCH_METRIC standalone_bytes=29518017
BENCH_METRIC static_bytes=497346
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
BENCH_METRIC app_bytes=30015364
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=2124
BENCH_DIRS
BENCH_DIR 25104705	node_modules/next
BENCH_DIR 2760803	node_modules/react-dom
BENCH_DIR 820761	.next/server
BENCH_DIR 497346	.next/static
BENCH_DIR 339057	node_modules/caniuse-lite
BENCH_DIR 121917	node_modules/postcss
BENCH_DIR 111635	node_modules/source-map-js
BENCH_DIR 84331	node_modules/react
BENCH_DIR 46525	node_modules/baseline-browser-mapping
BENCH_DIR 30917	node_modules/@swc
BENCH_DIR 22255	node_modules/styled-jsx
BENCH_DIR 21651	.next/routes-manifest.json
BENCH_DIR 15644	.next/build-manifest.json
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
BENCH_METRIC build_seconds=15.926
BENCH_METRIC output_bytes=63561473
BENCH_METRIC cache_bytes=80455624
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
BENCH_METRIC build_seconds=14.667
BENCH_METRIC output_bytes=44157551
BENCH_METRIC cache_bytes=80456355
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
BENCH_METRIC build_seconds=18.308
BENCH_METRIC output_bytes=69095341
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
BENCH_METRIC build_seconds=17.373
BENCH_METRIC output_bytes=49691410
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
BENCH_METRIC build_seconds=13.062
BENCH_METRIC output_bytes=63489925
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
BENCH_METRIC build_seconds=12.811
BENCH_METRIC output_bytes=44085950
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
BENCH_METRIC build_seconds=13.308
BENCH_METRIC output_bytes=60409468
BENCH_METRIC cache_bytes=24243825
BENCH_METRIC standalone_bytes=58890350
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
BENCH_METRIC app_bytes=59380376
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
BENCH_DIR 21553	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=12.637
BENCH_METRIC output_bytes=41005517
BENCH_METRIC cache_bytes=24247478
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
BENCH_METRIC build_seconds=13.532
BENCH_METRIC output_bytes=62291556
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
BENCH_METRIC build_seconds=13.607
BENCH_METRIC output_bytes=42887579
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
BENCH_METRIC build_seconds=11.640
BENCH_METRIC output_bytes=60366468
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=58901677
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
BENCH_METRIC app_bytes=59398746
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
BENCH_DIR 21713	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=11.471
BENCH_METRIC output_bytes=40962245
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

### results/next-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=10.880
BENCH_METRIC output_bytes=3535575
BENCH_METRIC cache_bytes=69816651
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=947281
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=318342623
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=10677
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1645714	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 947281	.next/static
BENCH_DIR 578714	.next/trace
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 269157	.next/types
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 46572	.next/next-server.js.nft.json
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 12787	node_modules/.package-lock.json
BENCH_DIR 11144	.next/routes-manifest.json
BENCH_LARGEST
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 5494329	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 5486978	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 5434909	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 5427545	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4262490	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 4261859	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 4219001	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 4218348	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 3036901	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 2582707	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 1811707	node_modules/next/dist/compiled/next-server/dev-validation-worker-experimental.runtime.dev.js.map
BENCH_FILE 1811428	node_modules/next/dist/compiled/next-server/dev-validation-worker-turbo-experimental.runtime.dev.js.map
BENCH_FILE 1809280	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js
BENCH_FILE 1808820	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_FILE 1782981	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js
BENCH_FILE 1782547	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js
BENCH_FILE 1776319	node_modules/next/dist/compiled/next-server/dev-validation-worker.runtime.dev.js.map
BENCH_NATIVE
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 71736	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 61045	node_modules/next/dist/compiled/@mswjs/interceptors/ClientRequest/llhttp/llhttp.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-15-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=10.765
BENCH_METRIC output_bytes=3331704
BENCH_METRIC cache_bytes=80454117
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=836468
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=336769832
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=9358
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1865711	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 836468	.next/static
BENCH_DIR 317294	.next/trace
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 219431	.next/types
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 19538	node_modules/.bin
BENCH_DIR 15997	.next/app-build-manifest.json
BENCH_DIR 12321	node_modules/.package-lock.json
BENCH_LARGEST
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 6213092	node_modules/typescript/lib/_tsc.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 3855182	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 3849983	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 3687144	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 3681955	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 2841395	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 2840792	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 2755348	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 2754762	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 2582639	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 2449181	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 1874901	node_modules/typescript/lib/lib.dom.d.ts
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 1364845	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_NATIVE
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 88658	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-pages-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=8.302
BENCH_METRIC output_bytes=1689385
BENCH_METRIC cache_bytes=24918278
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=498358
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=316495906
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=10543
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 820427	.next/server
BENCH_DIR 498358	.next/static
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 233993	.next/trace
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 46572	.next/next-server.js.nft.json
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 23234	.next/types
BENCH_DIR 21811	.next/routes-manifest.json
BENCH_DIR 13153	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 5494329	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 5486978	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 5434909	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 5427545	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4262490	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 4261859	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 4219001	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 4218348	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 3036901	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 2582707	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 1811707	node_modules/next/dist/compiled/next-server/dev-validation-worker-experimental.runtime.dev.js.map
BENCH_FILE 1811428	node_modules/next/dist/compiled/next-server/dev-validation-worker-turbo-experimental.runtime.dev.js.map
BENCH_FILE 1809280	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js
BENCH_FILE 1808820	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_FILE 1782981	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js
BENCH_FILE 1782547	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js
BENCH_FILE 1776319	node_modules/next/dist/compiled/next-server/dev-validation-worker.runtime.dev.js.map
BENCH_NATIVE
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 71736	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 61045	node_modules/next/dist/compiled/@mswjs/interceptors/ClientRequest/llhttp/llhttp.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-pages-15-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=7.878
BENCH_METRIC output_bytes=1441170
BENCH_METRIC cache_bytes=24247711
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=490025
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=334878757
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=9235
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 604121	.next/server
BENCH_DIR 490025	.next/static
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 232417	.next/trace
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 19538	node_modules/.bin
BENCH_DIR 18441	.next/types
BENCH_DIR 13197	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 6213092	node_modules/typescript/lib/_tsc.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 3855182	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 3849983	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 3687144	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 3681955	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 2841395	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 2840792	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 2755348	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 2754762	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 2582639	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 2449181	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 1874901	node_modules/typescript/lib/lib.dom.d.ts
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 1364845	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_NATIVE
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 88658	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-turbopack-full.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=3.508
BENCH_METRIC output_bytes=6228227
BENCH_METRIC cache_bytes=28057101
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=568792
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=321035275
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=11227
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 5409335	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 568792	.next/static
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 90042	.next/next-server.js.nft.json
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 55033	.next/types
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 22396	.next/trace
BENCH_DIR 18694	.next/diagnostics
BENCH_DIR 13433	.next/build-manifest.json
BENCH_LARGEST
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 5494329	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 5486978	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 5434909	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 5427545	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4262490	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 4261859	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 4219001	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 4218348	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 3036901	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 2582707	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 1811707	node_modules/next/dist/compiled/next-server/dev-validation-worker-experimental.runtime.dev.js.map
BENCH_FILE 1811428	node_modules/next/dist/compiled/next-server/dev-validation-worker-turbo-experimental.runtime.dev.js.map
BENCH_FILE 1809280	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js
BENCH_FILE 1808820	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_FILE 1782981	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js
BENCH_FILE 1782547	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js
BENCH_FILE 1776319	node_modules/next/dist/compiled/next-server/dev-validation-worker.runtime.dev.js.map
BENCH_NATIVE
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 71736	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 61045	node_modules/next/dist/compiled/@mswjs/interceptors/ClientRequest/llhttp/llhttp.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-15-turbopack-full.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=12.729
BENCH_METRIC output_bytes=8724488
BENCH_METRIC cache_bytes=116909
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=904944
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=342162616
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=9886
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 7686069	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 904944	.next/static
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 22445	.next/trace
BENCH_DIR 20452	.next/types
BENCH_DIR 19538	node_modules/.bin
BENCH_DIR 13484	.next/app-build-manifest.json
BENCH_DIR 12321	node_modules/.package-lock.json
BENCH_LARGEST
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 6213092	node_modules/typescript/lib/_tsc.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 3855182	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 3849983	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 3687144	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 3681955	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 2841395	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 2840792	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 2755348	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 2754762	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 2582639	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 2449181	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 1874901	node_modules/typescript/lib/lib.dom.d.ts
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 1364845	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_NATIVE
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 88658	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-pages-turbopack-full.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=3.140
BENCH_METRIC output_bytes=2645839
BENCH_METRIC cache_bytes=15393502
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=410895
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=317452360
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=11036
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 2011011	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 410895	.next/static
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 90042	.next/next-server.js.nft.json
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 23234	.next/types
BENCH_DIR 21907	.next/trace
BENCH_DIR 21811	.next/routes-manifest.json
BENCH_DIR 16249	.next/diagnostics
BENCH_LARGEST
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 5494329	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 5486978	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 5434909	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 5427545	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4262490	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 4261859	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 4219001	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 4218348	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 3036901	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 2582707	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 1811707	node_modules/next/dist/compiled/next-server/dev-validation-worker-experimental.runtime.dev.js.map
BENCH_FILE 1811428	node_modules/next/dist/compiled/next-server/dev-validation-worker-turbo-experimental.runtime.dev.js.map
BENCH_FILE 1809280	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js
BENCH_FILE 1808820	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_FILE 1782981	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js
BENCH_FILE 1782547	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js
BENCH_FILE 1776319	node_modules/next/dist/compiled/next-server/dev-validation-worker.runtime.dev.js.map
BENCH_NATIVE
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 71736	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 61045	node_modules/next/dist/compiled/@mswjs/interceptors/ClientRequest/llhttp/llhttp.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/next-pages-15-turbopack-full.metrics

```text
BENCH_METRIC bundler=turbopack
BENCH_METRIC router=pages
BENCH_METRIC build_seconds=8.802
BENCH_METRIC output_bytes=3338864
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=1648469
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=336776451
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=9779
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1648469	.next/static
BENCH_DIR 1557715	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 21702	.next/trace
BENCH_DIR 21553	.next/routes-manifest.json
BENCH_DIR 19538	node_modules/.bin
BENCH_DIR 18441	.next/types
BENCH_DIR 12327	node_modules/.package-lock.json
BENCH_LARGEST
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 9112572	node_modules/typescript/lib/typescript.js
BENCH_FILE 6213092	node_modules/typescript/lib/_tsc.js
BENCH_FILE 4301622	node_modules/next/dist/server/capsize-font-metrics.json
BENCH_FILE 4012235	node_modules/next/dist/compiled/amphtml-validator/validator_wasm.js
BENCH_FILE 3855182	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js.map
BENCH_FILE 3849983	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.dev.js.map
BENCH_FILE 3687144	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.dev.js.map
BENCH_FILE 3681955	node_modules/next/dist/compiled/next-server/app-page.runtime.dev.js.map
BENCH_FILE 2841395	node_modules/next/dist/compiled/next-server/app-page-experimental.runtime.prod.js.map
BENCH_FILE 2840792	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.prod.js.map
BENCH_FILE 2755348	node_modules/next/dist/compiled/next-server/app-page.runtime.prod.js.map
BENCH_FILE 2754762	node_modules/next/dist/compiled/next-server/app-page-turbo.runtime.prod.js.map
BENCH_FILE 2582639	node_modules/next/dist/compiled/webpack/bundle5.js
BENCH_FILE 2449181	node_modules/next/dist/compiled/next-devtools/index.js.map
BENCH_FILE 1874901	node_modules/typescript/lib/lib.dom.d.ts
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 1364845	node_modules/next/dist/compiled/next-server/app-page-turbo-experimental.runtime.dev.js
BENCH_NATIVE
BENCH_FILE 137079728	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 18712760	node_modules/@img/sharp-libvips-linuxmusl-arm64/lib/libvips-cpp.so.8.18.7
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
BENCH_FILE 329832	node_modules/@img/sharp-linuxmusl-arm64/lib/sharp-linuxmusl-arm64-0.35.5.node
BENCH_FILE 88658	node_modules/next/dist/compiled/@vercel/og/yoga.wasm
BENCH_FILE 48693	node_modules/next/dist/compiled/source-map08/mappings.wasm
```

### results/react-router.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC build_seconds=1.292
BENCH_METRIC output_bytes=448445
BENCH_METRIC client_bytes=373672
BENCH_METRIC server_bytes=74773
BENCH_METRIC client_html_count=0
BENCH_METRIC native_bytes=0
BENCH_FILE 214705	build/client/assets/entry.client-DF8hY4KR.js
BENCH_FILE 86979	build/client/assets/jsx-runtime-Bbntekxr.js
BENCH_FILE 74773	build/server/index.js
BENCH_FILE 33652	build/client/assets/errorBoundaries-Doolcmyu.js
BENCH_FILE 17594	build/client/assets/manifest-d45a9b02.js
BENCH_FILE 10430	build/client/assets/root-CCZxrRf8.js
BENCH_FILE 209	build/client/assets/home-MhivSL-j.js
BENCH_FILE 203	build/client/assets/10-DNshUo4R.js
BENCH_FILE 203	build/client/assets/11-DWgch4iu.js
BENCH_FILE 203	build/client/assets/12-CqTMkkjb.js
BENCH_FILE 203	build/client/assets/13-CvHTbaFH.js
BENCH_FILE 203	build/client/assets/14-nWTvJX5U.js
BENCH_FILE 203	build/client/assets/15-Dc6wWqDT.js
BENCH_FILE 203	build/client/assets/16-BJpErL1B.js
BENCH_FILE 203	build/client/assets/17-DQheSYY2.js
BENCH_FILE 203	build/client/assets/18-Cx5ntWqT.js
BENCH_FILE 203	build/client/assets/19-Bl5-vf_L.js
BENCH_FILE 203	build/client/assets/20-OwaLc5xW.js
BENCH_FILE 202	build/client/assets/1-CJz_wI1h.js
BENCH_FILE 202	build/client/assets/10-CJz_wI1h.js

# runtime image
BENCH_METRIC app_bytes=39150365
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=1490
BENCH_DIRS
BENCH_DIR 23624971	node_modules/typescript
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 2856262	node_modules/react-router
BENCH_DIR 805224	node_modules/source-map
BENCH_DIR 374851	node_modules/qs
BENCH_DIR 373672	build/client
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
BENCH_DIR 74773	build/server
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
BENCH_FILE 344426	node_modules/typescript/lib/de/diagnosticMessages.generated.json
BENCH_NATIVE
```

### results/react-router-data.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC mode=data
BENCH_METRIC build_seconds=0.268
BENCH_METRIC output_bytes=335465
BENCH_METRIC client_html_count=1
BENCH_METRIC client_js_count=52
BENCH_METRIC native_bytes=0
BENCH_FILE 317451	dist/assets/index-B_K17LKS.js
BENCH_FILE 473	dist/assets/pages-Cf-otGHB.js
BENCH_FILE 447	dist/assets/10-mU6YZODi.js
BENCH_FILE 447	dist/assets/11-QkArALAv.js
BENCH_FILE 447	dist/assets/12-DLWEmel0.js
BENCH_FILE 447	dist/assets/13-Dx1bU9D1.js
BENCH_FILE 447	dist/assets/14-DLK5lEvt.js
BENCH_FILE 447	dist/assets/15-Di7R08D8.js
BENCH_FILE 447	dist/assets/16-DY1pOqR5.js
BENCH_FILE 447	dist/assets/17-CKHXdqaj.js
BENCH_FILE 447	dist/assets/18-DAdfgVMQ.js
BENCH_FILE 447	dist/assets/19-B8hYuWYf.js
BENCH_FILE 447	dist/assets/20-BL6njNMn.js
BENCH_FILE 447	dist/assets/21-DOURriS3.js
BENCH_FILE 447	dist/assets/22-CaqiW3lh.js
BENCH_FILE 447	dist/assets/23-rjgZOdPI.js
BENCH_FILE 447	dist/assets/24-0qyjfBXT.js
BENCH_FILE 447	dist/assets/25-C6eNMF3b.js
BENCH_FILE 447	dist/assets/26-C4nD4X20.js
BENCH_FILE 447	dist/assets/27-Bji2RdI4.js

# runtime image
BENCH_METRIC app_bytes=338478
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=54
BENCH_DIRS
BENCH_DIR 335147	dist/assets
BENCH_DIR 3013	server.mjs
BENCH_DIR 318	dist/index.html
BENCH_LARGEST
BENCH_FILE 317451	dist/assets/index-B_K17LKS.js
BENCH_FILE 3013	server.mjs
BENCH_FILE 473	dist/assets/pages-Cf-otGHB.js
BENCH_FILE 447	dist/assets/10-mU6YZODi.js
BENCH_FILE 447	dist/assets/11-QkArALAv.js
BENCH_FILE 447	dist/assets/12-DLWEmel0.js
BENCH_FILE 447	dist/assets/13-Dx1bU9D1.js
BENCH_FILE 447	dist/assets/14-DLK5lEvt.js
BENCH_FILE 447	dist/assets/15-Di7R08D8.js
BENCH_FILE 447	dist/assets/16-DY1pOqR5.js
BENCH_FILE 447	dist/assets/17-CKHXdqaj.js
BENCH_FILE 447	dist/assets/18-DAdfgVMQ.js
BENCH_FILE 447	dist/assets/19-B8hYuWYf.js
BENCH_FILE 447	dist/assets/20-BL6njNMn.js
BENCH_FILE 447	dist/assets/21-DOURriS3.js
BENCH_FILE 447	dist/assets/22-CaqiW3lh.js
BENCH_FILE 447	dist/assets/23-rjgZOdPI.js
BENCH_FILE 447	dist/assets/24-0qyjfBXT.js
BENCH_FILE 447	dist/assets/25-C6eNMF3b.js
BENCH_FILE 447	dist/assets/26-C4nD4X20.js
BENCH_NATIVE
```

### results/react-router-declarative.metrics

```text
BENCH_METRIC bundler=vite-rolldown
BENCH_METRIC mode=declarative
BENCH_METRIC build_seconds=0.327
BENCH_METRIC output_bytes=278589
BENCH_METRIC client_html_count=1
BENCH_METRIC client_js_count=52
BENCH_METRIC native_bytes=0
BENCH_FILE 262771	dist/assets/index-CGl0XLD4.js
BENCH_FILE 587	dist/assets/pages-DpAz9Vqt.js
BENCH_FILE 370	dist/assets/10-DN6UEE1X.js
BENCH_FILE 370	dist/assets/11-CCbEcjwo.js
BENCH_FILE 370	dist/assets/12-B0yMREyE.js
BENCH_FILE 370	dist/assets/13-CmOq9Ijz.js
BENCH_FILE 370	dist/assets/14-C-0V6YJ5.js
BENCH_FILE 370	dist/assets/15-M_oR9deU.js
BENCH_FILE 370	dist/assets/16-BXldfMcn.js
BENCH_FILE 370	dist/assets/17-CRY7b1rP.js
BENCH_FILE 370	dist/assets/18-B_mWHuha.js
BENCH_FILE 370	dist/assets/19-3rBmerrQ.js
BENCH_FILE 370	dist/assets/20-ah5--NFW.js
BENCH_FILE 370	dist/assets/21-DcDhBryZ.js
BENCH_FILE 370	dist/assets/22-l0pjQeTw.js
BENCH_FILE 370	dist/assets/23-B4lYmqs8.js
BENCH_FILE 370	dist/assets/24-cuUU6-lr.js
BENCH_FILE 370	dist/assets/25-Ca5wrvG6.js
BENCH_FILE 370	dist/assets/26-BNeq3cE6.js
BENCH_FILE 370	dist/assets/27-C43U0o_A.js

# runtime image
BENCH_METRIC app_bytes=281602
BENCH_METRIC native_bytes=0
BENCH_METRIC file_count=54
BENCH_DIRS
BENCH_DIR 278271	dist/assets
BENCH_DIR 3013	server.mjs
BENCH_DIR 318	dist/index.html
BENCH_LARGEST
BENCH_FILE 262771	dist/assets/index-CGl0XLD4.js
BENCH_FILE 3013	server.mjs
BENCH_FILE 587	dist/assets/pages-DpAz9Vqt.js
BENCH_FILE 370	dist/assets/10-DN6UEE1X.js
BENCH_FILE 370	dist/assets/11-CCbEcjwo.js
BENCH_FILE 370	dist/assets/12-B0yMREyE.js
BENCH_FILE 370	dist/assets/13-CmOq9Ijz.js
BENCH_FILE 370	dist/assets/14-C-0V6YJ5.js
BENCH_FILE 370	dist/assets/15-M_oR9deU.js
BENCH_FILE 370	dist/assets/16-BXldfMcn.js
BENCH_FILE 370	dist/assets/17-CRY7b1rP.js
BENCH_FILE 370	dist/assets/18-B_mWHuha.js
BENCH_FILE 370	dist/assets/19-3rBmerrQ.js
BENCH_FILE 370	dist/assets/20-ah5--NFW.js
BENCH_FILE 370	dist/assets/21-DcDhBryZ.js
BENCH_FILE 370	dist/assets/22-l0pjQeTw.js
BENCH_FILE 370	dist/assets/23-B4lYmqs8.js
BENCH_FILE 370	dist/assets/24-cuUU6-lr.js
BENCH_FILE 370	dist/assets/25-Ca5wrvG6.js
BENCH_FILE 370	dist/assets/26-BNeq3cE6.js
BENCH_NATIVE
```

