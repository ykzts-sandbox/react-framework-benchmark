# Repeated build times

Measured by `scripts/bench-repeat.sh`. Each run starts a fresh container from the variant's `source` stage and runs the same timed build as `scripts/bench.sh`. Variants run round-robin. Raw runs are in `results/build-times.csv`.

- First run finished: 2026-10-12T03:51:07Z
- Last run finished: 2026-10-12T06:04:31Z
- Host: Mac mini (Apple M4, 16 GB RAM), Dev Container with Docker in Docker

| Framework / Bundler | Runs | Median (s) | Mean (s) | Stdev (s) | Min (s) | P25 (s) | P75 (s) | Max (s) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Next.js 16 App Router / webpack / sharp | 10 | 26.445 | 26.793 | 1.030 | 25.795 | 26.094 | 27.053 | 29.142 |
| Next.js 16 App Router / webpack / no sharp | 10 | 25.892 | 26.171 | 1.058 | 25.006 | 25.785 | 26.367 | 28.808 |
| Next.js 16 App Router / webpack / sharp / no standalone | 10 | 23.541 | 23.686 | 1.002 | 22.909 | 23.141 | 23.728 | 26.380 |
| Next.js 16 App Router / Turbopack / sharp | 10 | 6.565 | 6.704 | 0.344 | 6.404 | 6.475 | 6.820 | 7.307 |
| Next.js 16 App Router / Turbopack / no sharp | 10 | 6.522 | 6.553 | 0.248 | 6.311 | 6.376 | 6.585 | 7.103 |
| Next.js 16 App Router / Turbopack / sharp / no standalone | 10 | 6.544 | 6.663 | 0.421 | 6.240 | 6.486 | 6.696 | 7.771 |
| Next.js 16 App Router / Rspack / sharp | 10 | 21.688 | 21.719 | 0.258 | 21.381 | 21.587 | 21.801 | 22.322 |
| Next.js 16 App Router / Rspack / no sharp | 10 | 20.673 | 21.501 | 2.860 | 20.148 | 20.389 | 20.899 | 29.599 |
| Next.js 16 Pages Router / webpack / sharp | 10 | 15.485 | 15.819 | 0.896 | 15.265 | 15.466 | 15.696 | 18.317 |
| Next.js 16 Pages Router / webpack / no sharp | 10 | 15.020 | 15.367 | 0.870 | 14.903 | 14.921 | 15.252 | 17.690 |
| Next.js 16 Pages Router / webpack / sharp / no standalone | 10 | 11.950 | 12.115 | 0.711 | 11.674 | 11.811 | 12.008 | 14.093 |
| Next.js 16 Pages Router / Turbopack / sharp | 10 | 5.261 | 5.319 | 0.293 | 5.095 | 5.124 | 5.356 | 6.089 |
| Next.js 16 Pages Router / Turbopack / no sharp | 10 | 5.152 | 5.261 | 0.479 | 4.895 | 5.059 | 5.237 | 6.583 |
| Next.js 16 Pages Router / Turbopack / sharp / no standalone | 10 | 5.029 | 5.171 | 0.467 | 4.858 | 4.938 | 5.085 | 6.415 |
| Next.js 16 Pages Router / Rspack / sharp | 10 | 13.685 | 13.721 | 0.393 | 13.203 | 13.576 | 13.806 | 14.644 |
| Next.js 16 Pages Router / Rspack / no sharp | 10 | 13.395 | 13.427 | 0.276 | 13.057 | 13.268 | 13.482 | 13.926 |
| Next.js 15 App Router / webpack / sharp | 10 | 29.594 | 30.103 | 0.942 | 29.303 | 29.495 | 30.618 | 32.149 |
| Next.js 15 App Router / webpack / no sharp | 10 | 29.293 | 29.785 | 1.154 | 28.617 | 29.066 | 30.212 | 32.390 |
| Next.js 15 App Router / webpack / sharp / no standalone | 10 | 26.220 | 26.278 | 0.627 | 25.407 | 25.934 | 26.472 | 27.472 |
| Next.js 15 App Router / Turbopack / sharp | 10 | 50.130 | 50.525 | 1.842 | 48.513 | 49.720 | 50.646 | 55.370 |
| Next.js 15 App Router / Turbopack / no sharp | 10 | 50.239 | 50.459 | 1.794 | 48.557 | 49.109 | 51.055 | 54.427 |
| Next.js 15 App Router / Turbopack / sharp / no standalone | 10 | 46.013 | 46.074 | 0.916 | 44.228 | 45.635 | 46.790 | 47.302 |
| Next.js 15 App Router / Rspack / sharp | 10 | 24.256 | 24.325 | 0.835 | 23.329 | 23.960 | 24.453 | 26.324 |
| Next.js 15 App Router / Rspack / no sharp | 10 | 23.787 | 23.768 | 0.609 | 22.960 | 23.283 | 24.115 | 24.822 |
| Next.js 15 Pages Router / webpack / sharp | 10 | 17.169 | 17.316 | 0.359 | 16.961 | 17.054 | 17.494 | 18.026 |
| Next.js 15 Pages Router / webpack / no sharp | 10 | 16.829 | 16.956 | 0.423 | 16.570 | 16.719 | 16.923 | 17.855 |
| Next.js 15 Pages Router / webpack / sharp / no standalone | 10 | 12.163 | 12.234 | 0.331 | 11.898 | 12.005 | 12.270 | 12.981 |
| Next.js 15 Pages Router / Turbopack / sharp | 10 | 29.653 | 29.907 | 0.802 | 29.012 | 29.494 | 30.012 | 31.913 |
| Next.js 15 Pages Router / Turbopack / no sharp | 10 | 30.212 | 30.038 | 0.723 | 28.394 | 29.930 | 30.394 | 31.057 |
| Next.js 15 Pages Router / Turbopack / sharp / no standalone | 10 | 25.473 | 25.534 | 0.653 | 24.702 | 25.008 | 25.983 | 26.759 |
| Next.js 15 Pages Router / Rspack / sharp | 10 | 14.957 | 14.999 | 0.494 | 14.474 | 14.588 | 15.257 | 15.963 |
| Next.js 15 Pages Router / Rspack / no sharp | 10 | 14.456 | 14.578 | 0.374 | 14.161 | 14.369 | 14.814 | 15.314 |
| React Router Framework / Vite + Rolldown | 10 | 1.661 | 1.699 | 0.106 | 1.613 | 1.637 | 1.698 | 1.936 |
| React Router Data / Vite + Rolldown | 10 | 0.316 | 0.321 | 0.021 | 0.302 | 0.305 | 0.330 | 0.362 |
| React Router Declarative / Vite + Rolldown | 10 | 0.310 | 0.311 | 0.021 | 0.278 | 0.303 | 0.316 | 0.360 |
