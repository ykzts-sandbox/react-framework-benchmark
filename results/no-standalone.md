# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T05:46:33Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker
- Scope: no-standalone
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
- No standalone: built with `STANDALONE=0`, which leaves `output` unset, and run from the `runner-full` stage. It has the production `node_modules` and `.next` without `cache`, and runs `next start`.
- Build time: wall-clock time of the production build command inside a fresh builder container. Dependency installation is not included.
- These builds are cold application builds. Docker may reuse the `npm ci` layer when the lockfile is unchanged.

## Versions

```text
next-benchmark@ /app
+-- next@16.4.0
+-- react-dom@19.3.0
`-- react@19.3.0


next-15-benchmark@ /app
+-- next@15.5.27
+-- react-dom@19.3.0
`-- react@19.3.0


next-pages-benchmark@ /app
+-- next@16.4.0
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
| Next.js 16 App Router / webpack / sharp / no standalone | 24.902 | 722772399 | 485303383 | 35310367 |
| Next.js 15 App Router / webpack / sharp / no standalone | 27.189 | 723184154 | 485715138 | 19564609 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 13.076 | 687525136 | 450056120 | 8868497 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 13.353 | 703839613 | 466370597 | 6893350 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 7.367 | 726572031 | 489103015 | 23377655 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 46.299 | 785127430 | 547658414 | 53738664 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 5.815 | 712278550 | 474809534 | 13307322 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 26.621 | 738566566 | 501097550 | 20508347 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 16 App Router / webpack / sharp / no standalone | 151448028 | 89387838 |
| Next.js 15 App Router / webpack / sharp / no standalone | 154485128 | 92424938 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 150869310 | 88809120 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 154133739 | 92073549 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 151974956 | 89914766 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 165879666 | 103819476 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 151190084 | 89129894 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 154466580 | 92406390 |

## Build details

### results/next-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=24.902
BENCH_METRIC output_bytes=35310367
BENCH_METRIC cache_bytes=218071692
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=2531883
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=350117409
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=12931
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 20649724	.next/trace
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 9436577	.next/server
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 2531883	.next/static
BENCH_DIR 2517972	.next/types
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 46572	.next/next-server.js.nft.json
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 18423	.next/app-path-routes-manifest.json
BENCH_LARGEST
BENCH_FILE 90428680	node_modules/@next/swc-linux-arm64-musl/next-swc.linux-arm64-musl.node
BENCH_FILE 20649724	.next/trace
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
BENCH_METRIC build_seconds=27.189
BENCH_METRIC output_bytes=19564609
BENCH_METRIC cache_bytes=396553443
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=2393670
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=353002731
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=11612
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 13473193	.next/server
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 2393670	.next/static
BENCH_DIR 2031896	.next/types
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1359089	.next/trace
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 150463	.next/app-build-manifest.json
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 19538	node_modules/.bin
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
BENCH_METRIC build_seconds=13.076
BENCH_METRIC output_bytes=8868497
BENCH_METRIC cache_bytes=92070726
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=740498
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=323675018
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=11896
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 6078190	.next/server
BENCH_DIR 1556585	.next/trace
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 740498	.next/static
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 158580	.next/types
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 135724	.next/routes-manifest.json
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 120506	.next/build-manifest.json
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 46572	.next/next-server.js.nft.json
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
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
BENCH_METRIC build_seconds=13.353
BENCH_METRIC output_bytes=6893350
BENCH_METRIC cache_bytes=91352583
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=731779
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=340330937
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=10588
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 4136651	.next/server
BENCH_DIR 1555898	.next/trace
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 731779	.next/static
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 152434	.next/types
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 134622	.next/routes-manifest.json
BENCH_DIR 120550	.next/build-manifest.json
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 19538	node_modules/.bin
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
BENCH_FILE 1555898	.next/trace
BENCH_FILE 1538674	node_modules/next/dist/compiled/babel-packages/packages-bundle.js
BENCH_FILE 1378357	node_modules/next/dist/compiled/@vercel/og/resvg.wasm
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
BENCH_METRIC build_seconds=7.367
BENCH_METRIC output_bytes=23377655
BENCH_METRIC cache_bytes=91964252
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=568796
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=338184697
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=17992
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 21666628	.next/server
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 568796	.next/static
BENCH_DIR 451523	.next/types
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 178581	.next/diagnostics
BENCH_DIR 170623	.next/trace
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 121455	.next/build-manifest.json
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 90042	.next/next-server.js.nft.json
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 74387	.next/routes-manifest.json
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
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
BENCH_METRIC build_seconds=46.299
BENCH_METRIC output_bytes=53738664
BENCH_METRIC cache_bytes=181994
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=922228
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=387176786
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=16200
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 52197265	.next/server
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 922228	.next/static
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 170614	.next/trace
BENCH_DIR 162796	.next/types
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 129173	.next/app-build-manifest.json
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 74133	.next/routes-manifest.json
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 19538	node_modules/.bin
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
BENCH_METRIC build_seconds=5.815
BENCH_METRIC output_bytes=13307322
BENCH_METRIC cache_bytes=60188379
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=762388
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=328113843
BENCH_METRIC native_bytes=111031103
BENCH_METRIC file_count=16446
BENCH_DIRS
BENCH_DIR 192287675	node_modules/next
BENCH_DIR 90441126	node_modules/@next
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 11658121	.next/server
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 762388	.next/static
BENCH_DIR 282322	node_modules/@swc
BENCH_DIR 216017	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 170102	.next/trace
BENCH_DIR 158580	.next/types
BENCH_DIR 155390	.next/diagnostics
BENCH_DIR 142782	.next/build-manifest.json
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 134720	.next/routes-manifest.json
BENCH_DIR 133053	node_modules/baseline-browser-mapping
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 90042	.next/next-server.js.nft.json
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 37396	node_modules/.bin
BENCH_DIR 26437	node_modules/detect-libc
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
BENCH_METRIC build_seconds=26.621
BENCH_METRIC output_bytes=20508347
BENCH_METRIC cache_bytes=181551
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=12719421
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=353945934
BENCH_METRIC native_bytes=157638028
BENCH_METRIC file_count=15642
BENCH_DIRS
BENCH_DIR 140861682	node_modules/next
BENCH_DIR 137092008	node_modules/@next
BENCH_DIR 23625066	node_modules/typescript
BENCH_DIR 19139746	node_modules/@img
BENCH_DIR 12719421	.next/static
BENCH_DIR 8063782	node_modules/react-dom
BENCH_DIR 7185330	.next/server
BENCH_DIR 1546386	node_modules/caniuse-lite
BENCH_DIR 1032395	node_modules/styled-jsx
BENCH_DIR 962168	node_modules/sharp
BENCH_DIR 234327	node_modules/@swc
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 169904	.next/trace
BENCH_DIR 152434	.next/types
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 135626	.next/routes-manifest.json
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 83799	.next/build-manifest.json
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 19538	node_modules/.bin
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

