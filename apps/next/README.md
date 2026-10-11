# Next.js App Router

Next.js 16.4.0。静的ルート 500 個と、パラメータ付きの動的ルート 1 つ。

`scripts/generate-routes.sh` が `app/static/<id>/page.tsx` を作る。各モジュールは `dynamic = "force-dynamic"` で、中身は `Page N` と `Benchmark page N`。`next.config.ts` の `headers()` が `/static/:id` に `Cache-Control: public, s-maxage=31536000` を付ける。

`app/dynamic/[id]/page.tsx` は `LARAVEL_ORIGIN`（既定は `http://laravel:8000`）へ、オプションなしの `fetch` で `GET /api/pages/:id` を取る。`headers()` が `/dynamic/:id` に `Cache-Control: public, s-maxage=60` を付け、Varnish がそれを保存する。

本番出力は `output: "standalone"`。`outputFileTracingRoot` はこのディレクトリ。イメージは `node:24.21.0-alpine` で、`public`、`.next/standalone`、`.next/static` を載せる。`next-rspack` はビルド専用なので standalone には含めない。

バンドラはビルド引数 `BUNDLER`。

- webpack は `next build --webpack`
- Turbopack は `next build --turbopack`
- Rspack は `BUNDLER=rspack next build`。`next-rspack` が設定を包む

`EXCLUDE_SHARP=1` のビルドは `outputFileTracingExcludes` で `node_modules/sharp/**/*` と `node_modules/@img/**/*` を外す。

計測タグは `benchmark-next:webpack`、`benchmark-next:turbopack`、`benchmark-next:rspack`。`sharp` を外したタグはそれぞれ `-no-sharp` が付く。Varnish の前に置くイメージは `benchmark-next:cache-demo`。
