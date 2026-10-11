# react-framework-benchmark

静的ルート 500 個のビルド時間と、Docker イメージの総合容量です。

| アプリ                   | バンドラ        | sharp | ビルド    | 容量     |
| ------------------------ | --------------- | ----- | --------- | -------- |
| Next.js 16 App Router    | webpack         | あり  | 31.153 秒 | 73.8 MiB |
| Next.js 16 App Router    | webpack         | なし  | 29.490 秒 | 65.4 MiB |
| Next.js 16 App Router    | Turbopack       | あり  | 8.378 秒  | 71.2 MiB |
| Next.js 16 App Router    | Turbopack       | なし  | 9.131 秒  | 62.7 MiB |
| Next.js 16 App Router    | Rspack          | あり  | 25.811 秒 | 73.8 MiB |
| Next.js 16 App Router    | Rspack          | なし  | 27.798 秒 | 65.4 MiB |
| Next.js 16 Pages Router  | webpack         | あり  | 18.161 秒 | 73.7 MiB |
| Next.js 16 Pages Router  | webpack         | なし  | 16.892 秒 | 65.3 MiB |
| Next.js 16 Pages Router  | Turbopack       | あり  | 6.746 秒  | 71.2 MiB |
| Next.js 16 Pages Router  | Turbopack       | なし  | 6.581 秒  | 62.8 MiB |
| Next.js 16 Pages Router  | Rspack          | あり  | 15.126 秒 | 73.7 MiB |
| Next.js 16 Pages Router  | Rspack          | なし  | 14.815 秒 | 65.3 MiB |
| Next.js 15 App Router    | webpack         | あり  | 37.955 秒 | 75.8 MiB |
| Next.js 15 App Router    | webpack         | なし  | 36.125 秒 | 67.3 MiB |
| Next.js 15 App Router    | Turbopack       | あり  | 57.250 秒 | 75.8 MiB |
| Next.js 15 App Router    | Turbopack       | なし  | 56.114 秒 | 67.4 MiB |
| Next.js 15 App Router    | Rspack          | あり  | 27.220 秒 | 75.7 MiB |
| Next.js 15 App Router    | Rspack          | なし  | 27.451 秒 | 67.3 MiB |
| Next.js 15 Pages Router  | webpack         | あり  | 19.503 秒 | 75.4 MiB |
| Next.js 15 Pages Router  | webpack         | なし  | 19.823 秒 | 67.0 MiB |
| Next.js 15 Pages Router  | Turbopack       | あり  | 33.520 秒 | 75.6 MiB |
| Next.js 15 Pages Router  | Turbopack       | なし  | 34.224 秒 | 67.2 MiB |
| Next.js 15 Pages Router  | Rspack          | あり  | 17.068 秒 | 75.4 MiB |
| Next.js 15 Pages Router  | Rspack          | なし  | 16.113 秒 | 67.0 MiB |
| React Router Framework   | Vite + Rolldown | なし  | 2.676 秒  | 66.6 MiB |
| React Router Data        | Vite + Rolldown | なし  | 0.442 秒  | 59.3 MiB |
| React Router Declarative | Vite + Rolldown | なし  | 0.547 秒  | 59.3 MiB |

容量はレジストリ上の linux マニフェストの config とレイヤーの合計です。`sharp` なしは `outputFileTracingExcludes` で `node_modules/sharp` と `node_modules/@img` を外したイメージです。バイト数は `results/benchmark.md` にあります。

実行はリポジトリのルートで `make bench`。

- [Next.js 16 App Router](apps/next/README.md)
- [Next.js 16 Pages Router](apps/next-pages/README.md)
- [Next.js 15 App Router](apps/next-15/README.md)
- [Next.js 15 Pages Router](apps/next-pages-15/README.md)
- [React Router Framework Mode](apps/react-router/README.md)
- [React Router Data Mode](apps/react-router-data/README.md)
- [React Router Declarative Mode](apps/react-router-declarative/README.md)
- [Laravel](backend/README.md)
- [Varnish](varnish/README.md)

| 項目            | バージョン                       |
| --------------- | -------------------------------- |
| Next.js 16      | 16.4.0                           |
| Next.js 15      | 15.5.27                          |
| next-rspack     | 16.4.0 / 15.5.27                 |
| React Router    | 8.4.0                            |
| Vite / Rolldown | 8.3.4 / 1.2.13                   |
| React           | 19.3.0                           |
| Node.js         | 24.21.0（`node:24.21.0-alpine`） |
| Varnish         | 7.7                              |
| Laravel / PHP   | 13.35.0 / 8.4.26                 |
| MySQL           | 8.4.11                           |

## Varnish

`benchmark-next:cache-demo` の前段です。ログは `results/varnish.md` です。

静的 HTML は `s-maxage=31536000` で、2 回目は HIT です。動的 HTML は `public, s-maxage=60` で、URL ごとに HIT です。`?_rsc` の RSC は HTML とは別の HIT です。`_rsc` の無い RSC は PASS です。`/dynamic/1` は `Page 1` / `Benchmark page 1` です。`/dynamic/501` は 404 の HTML で、2 回目は HIT です。
