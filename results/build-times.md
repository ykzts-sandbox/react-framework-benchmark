# Repeated build times

Measured by `scripts/bench-repeat.sh`. Each run starts a fresh container from the variant's `source` stage and runs the same timed build as `scripts/bench.sh`. Variants run round-robin. Raw runs are in `results/build-times.csv`.

- First run finished: 2026-10-12T07:38:20Z
- Last run finished: 2026-10-12T08:33:58Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker

| Framework / Bundler | Runs | Median (s) | Mean (s) | Stdev (s) | Min (s) | P25 (s) | P75 (s) | Max (s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 10 | 13.184 | 13.186 | 0.343 | 12.647 | 13.041 | 13.306 | 13.873 |
| Next.js 16 App Router / webpack / no sharp | 10 | 12.535 | 12.674 | 0.389 | 12.309 | 12.431 | 12.755 | 13.622 |
| Next.js 16 App Router / webpack / sharp / no standalone | 10 | 9.483 | 9.533 | 0.278 | 9.221 | 9.385 | 9.575 | 10.244 |
| Next.js 16 App Router / Turbopack / sharp | 10 | 3.126 | 3.171 | 0.163 | 2.959 | 3.088 | 3.210 | 3.563 |
| Next.js 16 App Router / Turbopack / no sharp | 10 | 3.133 | 3.144 | 0.083 | 2.991 | 3.120 | 3.155 | 3.292 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 10 | 2.933 | 2.939 | 0.067 | 2.798 | 2.905 | 2.997 | 3.011 |
| Next.js 16 App Router / Rspack / sharp | 10 | 11.354 | 11.485 | 0.434 | 11.205 | 11.310 | 11.391 | 12.691 |
| Next.js 16 App Router / Rspack / no sharp | 10 | 11.244 | 11.351 | 0.349 | 11.044 | 11.184 | 11.340 | 12.245 |
| Next.js 16 Pages Router / webpack / sharp | 10 | 11.018 | 11.006 | 0.218 | 10.696 | 10.832 | 11.138 | 11.382 |
| Next.js 16 Pages Router / webpack / no sharp | 10 | 10.597 | 10.647 | 0.155 | 10.396 | 10.579 | 10.731 | 10.911 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 10 | 7.540 | 7.534 | 0.101 | 7.353 | 7.492 | 7.597 | 7.705 |
| Next.js 16 Pages Router / Turbopack / sharp | 10 | 2.689 | 2.703 | 0.059 | 2.636 | 2.659 | 2.733 | 2.820 |
| Next.js 16 Pages Router / Turbopack / no sharp | 10 | 2.607 | 2.619 | 0.082 | 2.495 | 2.585 | 2.624 | 2.812 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 10 | 2.428 | 2.445 | 0.093 | 2.350 | 2.410 | 2.438 | 2.685 |
| Next.js 16 Pages Router / Rspack / sharp | 10 | 10.023 | 10.069 | 0.170 | 9.859 | 9.932 | 10.234 | 10.301 |
| Next.js 16 Pages Router / Rspack / no sharp | 10 | 9.979 | 9.974 | 0.147 | 9.724 | 9.876 | 10.064 | 10.230 |
| Next.js 15 App Router / webpack / sharp | 10 | 14.456 | 14.475 | 0.320 | 14.049 | 14.262 | 14.483 | 15.122 |
| Next.js 15 App Router / webpack / no sharp | 10 | 14.069 | 14.010 | 0.222 | 13.741 | 13.796 | 14.143 | 14.397 |
| Next.js 15 App Router / webpack / sharp / no standalone | 10 | 9.725 | 9.723 | 0.108 | 9.584 | 9.625 | 9.813 | 9.873 |
| Next.js 15 App Router / Turbopack / sharp | 10 | 17.105 | 17.207 | 0.470 | 16.574 | 16.921 | 17.372 | 18.099 |
| Next.js 15 App Router / Turbopack / no sharp | 10 | 17.013 | 17.049 | 0.182 | 16.826 | 16.962 | 17.053 | 17.485 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 10 | 12.404 | 12.403 | 0.192 | 12.090 | 12.304 | 12.435 | 12.778 |
| Next.js 15 App Router / Rspack / sharp | 10 | 12.473 | 12.457 | 0.205 | 12.072 | 12.338 | 12.528 | 12.755 |
| Next.js 15 App Router / Rspack / no sharp | 10 | 12.091 | 12.193 | 0.281 | 11.891 | 12.032 | 12.287 | 12.823 |
| Next.js 15 Pages Router / webpack / sharp | 10 | 12.199 | 12.326 | 0.331 | 11.968 | 12.181 | 12.454 | 12.931 |
| Next.js 15 Pages Router / webpack / no sharp | 10 | 11.916 | 11.966 | 0.232 | 11.711 | 11.769 | 12.119 | 12.375 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 10 | 7.403 | 7.500 | 0.215 | 7.321 | 7.353 | 7.597 | 7.954 |
| Next.js 15 Pages Router / Turbopack / sharp | 10 | 13.036 | 13.080 | 0.179 | 12.887 | 12.944 | 13.216 | 13.375 |
| Next.js 15 Pages Router / Turbopack / no sharp | 10 | 12.745 | 12.756 | 0.225 | 12.389 | 12.656 | 12.912 | 13.119 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 10 | 8.296 | 8.288 | 0.155 | 8.012 | 8.190 | 8.365 | 8.517 |
| Next.js 15 Pages Router / Rspack / sharp | 10 | 10.931 | 10.909 | 0.137 | 10.702 | 10.803 | 11.026 | 11.072 |
| Next.js 15 Pages Router / Rspack / no sharp | 10 | 10.658 | 10.706 | 0.262 | 10.434 | 10.516 | 10.760 | 11.249 |
| React Router Framework / Vite + Rolldown | 10 | 0.726 | 0.762 | 0.128 | 0.605 | 0.690 | 0.807 | 1.047 |
| React Router Data / Vite + Rolldown | 10 | 0.237 | 0.238 | 0.021 | 0.217 | 0.227 | 0.242 | 0.289 |
| React Router Declarative / Vite + Rolldown | 10 | 0.224 | 0.224 | 0.009 | 0.209 | 0.220 | 0.230 | 0.237 |
