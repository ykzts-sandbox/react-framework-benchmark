# Next.js Pages Router

Next.js 16.4.0で静的なルート20個と引数をひとつ取る動的なルート30個を持っています。

`scripts/generate-routes.sh`が`pages/static/<id>.tsx`を作ります。`Page N`と`Benchmark page N`を出すだけですがApp Routerの`force-dynamic`とそろえるために`getServerSideProps`を持たせてリクエストのたびにレンダリングするようにしています。なのでビルドのときにHTMLは書き出されません。App Routerと同じキャッシュになるように`getServerSideProps`の中で`Cache-Control: public, s-maxage=31536000`を付けています。

動的なルートも`scripts/generate-routes.sh`が`pages/dynamic/<kind>/[id].tsx`として作ります。どれも`getServerSideProps`から`lib/pages.ts`の`loadPage`でLaravelの`GET /api/pages/:kind/:id`を読みます。200のときは`Cache-Control: public, s-maxage=60`を付けて行がないIDは404にします。

`output: "standalone"`にしていて`outputFileTracingRoot`はこのディレクトリです。イメージは`node:24.21.0-alpine`に`public`と`.next/standalone`と`.next/static`を入れただけのものです。`next-rspack`はビルドのときにしか使わないのでstandaloneからは外しています。RSCのファイルは出ません。

バンドラはビルド引数の`BUNDLER`で選びます。

- webpackは`next build --webpack`
- Turbopackは`next build --turbopack`
- Rspackは`BUNDLER=rspack next build`で`next-rspack`が設定を包みます

`EXCLUDE_SHARP=1`のときは`outputFileTracingExcludes`で`node_modules/sharp/**/*`と`node_modules/@img/**/*`を外します。

タグは`benchmark-next-pages:webpack`と`benchmark-next-pages:turbopack`と`benchmark-next-pages:rspack`でsharpを外したものはそれぞれ`-no-sharp`が付きます。
