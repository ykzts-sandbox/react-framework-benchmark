# Next.js App Router

Next.js 16.4.0で静的なルート20個と引数をひとつ取る動的なルート30個を持っています。

`scripts/generate-routes.sh`が`app/static/<id>/page.tsx`を作ります。どれも`dynamic = "force-dynamic"`で`Page N`と`Benchmark page N`を出すだけです。`next.config.ts`の`headers()`で`/static/:id`に`Cache-Control: public, s-maxage=31536000`を付けています。

動的なルートも`scripts/generate-routes.sh`が`app/dynamic/<kind>/[id]/page.tsx`として作ります。どれも`lib/pages.ts`の`loadPage`で`LARAVEL_ORIGIN` (指定がなければ`http://laravel:8000`) の`GET /api/pages/:kind/:id`をオプションなしの`fetch`で読みます。Laravelにはkindごとにidが1から1000までの行があるので30個のルートで30,000ページになります。`headers()`で`/dynamic/:kind/:id`に`Cache-Control: public, s-maxage=60`を付けているのでVarnishがそれを見てキャッシュします。

`output: "standalone"`にしていて`outputFileTracingRoot`はこのディレクトリです。イメージは`node:24.21.0-alpine`に`public`と`.next/standalone`と`.next/static`を入れただけのものです。`next-rspack`はビルドのときにしか使わないのでstandaloneからは外しています。

バンドラはビルド引数の`BUNDLER`で選びます。

- webpackは`next build --webpack`
- Turbopackは`next build --turbopack`
- Rspackは`BUNDLER=rspack next build`で`next-rspack`が設定を包みます

`EXCLUDE_SHARP=1`のときは`outputFileTracingExcludes`で`node_modules/sharp/**/*`と`node_modules/@img/**/*`を外します。

タグは`benchmark-next:webpack`と`benchmark-next:turbopack`と`benchmark-next:rspack`でsharpを外したものはそれぞれ`-no-sharp`が付きます。Varnishの前に置くイメージは`benchmark-next:cache-demo`です。
