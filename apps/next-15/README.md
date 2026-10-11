# Next.js 15 App Router

ルート、キャッシュ、Docker の形は [`apps/next`](../next/README.md) と同じ。バージョンは Next.js 15.5.27 と `next-rspack` 15.5.27。`headers()` は `Promise` を返す。`tsconfig.json` の `jsx` は `preserve`。

webpack は `next build`。Turbopack は `next build --turbopack`。Rspack は `BUNDLER=rspack next build`。

計測タグは `benchmark-next-15:webpack`、`benchmark-next-15:turbopack`、`benchmark-next-15:rspack`。
