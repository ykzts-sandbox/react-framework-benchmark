# Benchmark results

Measured by `scripts/bench.sh`.

## Environment

- Date: 2026-10-12T07:32:33Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker
- Scope: no-standalone
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
| Next.js 16 App Router / webpack / sharp / no standalone | 11.178 | 679746942 | 442277926 | 3535594 |
| Next.js 15 App Router / webpack / sharp / no standalone | 11.176 | 697638371 | 460169355 | 3331734 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 9.460 | 676425473 | 438956457 | 1689447 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 8.353 | 694607214 | 457138198 | 1441368 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 3.735 | 684323129 | 446854113 | 6228202 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 12.978 | 706146949 | 468677933 | 8724487 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 3.227 | 679554763 | 442085747 | 2645660 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 9.095 | 698684858 | 461215842 | 3338869 |

Uncompressed sizes above come from `docker image inspect`. They describe the expanded image, including the shared base image.

## Registry compressed size

Measured by `scripts/measure-compressed.sh` on the tags above. Each image was pushed to a temporary `registry@sha256:a3d8aaa63ed8681a604f1dea0aa03f100d5895b6a58ace528858a7b332415373`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of `docker pull`. Attestation manifests are not included. This is not the size of `docker save | gzip`.

Observed layer media types: `application/vnd.oci.image.layer.v1.tar+gzip`.

Base image compressed size: 62060190 bytes.

| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |
| --- | ---: | ---: |
| Next.js 16 App Router / webpack / sharp / no standalone | 150951340 | 88891150 |
| Next.js 15 App Router / webpack / sharp / no standalone | 154166609 | 92106419 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 150636335 | 88576145 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 153916636 | 91856446 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 151542118 | 89481928 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 155761138 | 93700948 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 150816505 | 88756315 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 154078504 | 92018314 |

## Build details

### results/next-webpack-full.metrics

```text
BENCH_METRIC bundler=webpack
BENCH_METRIC router=app
BENCH_METRIC build_seconds=11.178
BENCH_METRIC output_bytes=3535594
BENCH_METRIC cache_bytes=69814645
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=947281
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=318342642
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
BENCH_DIR 578733	.next/trace
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
BENCH_METRIC build_seconds=11.176
BENCH_METRIC output_bytes=3331734
BENCH_METRIC cache_bytes=80450940
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=836468
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=336769862
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
BENCH_DIR 317324	.next/trace
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
BENCH_METRIC build_seconds=9.460
BENCH_METRIC output_bytes=1689447
BENCH_METRIC cache_bytes=24914997
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=498358
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=316495968
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
BENCH_DIR 234055	.next/trace
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
BENCH_METRIC build_seconds=8.353
BENCH_METRIC output_bytes=1441368
BENCH_METRIC cache_bytes=24244347
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=490025
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=334878955
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
BENCH_DIR 232455	.next/trace
BENCH_DIR 196517	node_modules/postcss
BENCH_DIR 178663	node_modules/react
BENCH_DIR 142723	node_modules/source-map-js
BENCH_DIR 96108	node_modules/semver
BENCH_DIR 90359	node_modules/tslib
BENCH_DIR 82659	node_modules/scheduler
BENCH_DIR 43192	.next/next-server.js.nft.json
BENCH_DIR 26437	node_modules/detect-libc
BENCH_DIR 25679	node_modules/nanoid
BENCH_DIR 21713	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=3.735
BENCH_METRIC output_bytes=6228202
BENCH_METRIC cache_bytes=28061573
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=568792
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=321035250
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
BENCH_DIR 22383	.next/trace
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
BENCH_METRIC build_seconds=12.978
BENCH_METRIC output_bytes=8724487
BENCH_METRIC cache_bytes=116909
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=904944
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=342162615
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
BENCH_DIR 22444	.next/trace
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
BENCH_METRIC build_seconds=3.227
BENCH_METRIC output_bytes=2645660
BENCH_METRIC cache_bytes=15383704
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=410895
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=317452181
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
BENCH_DIR 21898	.next/trace
BENCH_DIR 21651	.next/routes-manifest.json
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
BENCH_METRIC build_seconds=9.095
BENCH_METRIC output_bytes=3338869
BENCH_METRIC cache_bytes=116938
BENCH_METRIC standalone_bytes=0
BENCH_METRIC static_bytes=1648469
BENCH_METRIC static_html_count=0
BENCH_METRIC dynamic_html_count=0
BENCH_METRIC standalone_server=missing
BENCH_METRIC native_bytes=0

# runtime image
BENCH_METRIC app_bytes=336776456
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
BENCH_DIR 21707	.next/trace
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

