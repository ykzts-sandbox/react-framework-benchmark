# Next.js Pages Router

Next.js 16.4.0。静的ルート 500 個と、パラメータ付きの動的ルート 1 つ。

`scripts/generate-routes.sh` が `pages/static/<id>.tsx` を作る。中身は `Page N` と `Benchmark page N`。

`pages/dynamic/[id].tsx` は `getServerSideProps` で Laravel の `GET /api/pages/:id` を読む。200 の応答に `Cache-Control: public, s-maxage=60` を付ける。行が無い ID は 404。

本番出力は `output: "standalone"`。`outputFileTracingRoot` はこのディレクトリ。イメージは `node:24.21.0-alpine` で、`public`、`.next/standalone`、`.next/static` を載せる。`next-rspack` はビルド専用なので standalone には含めない。RSC のファイルは出ない。

バンドラはビルド引数 `BUNDLER`。

- webpack は `next build --webpack`
- Turbopack は `next build --turbopack`
- Rspack は `BUNDLER=rspack next build`。`next-rspack` が設定を包む

`EXCLUDE_SHARP=1` のビルドは `outputFileTracingExcludes` で `node_modules/sharp/**/*` と `node_modules/@img/**/*` を外す。

計測タグは `benchmark-next-pages:webpack`、`benchmark-next-pages:turbopack`、`benchmark-next-pages:rspack`。`sharp` を外したタグはそれぞれ `-no-sharp` が付く。
