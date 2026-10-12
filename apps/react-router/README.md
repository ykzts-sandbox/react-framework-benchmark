# React Router Framework Mode

React Router 8.4.0とVite 8.3.4 (Rolldown) を使っています。`react-router.config.ts`は`ssr: true`で本番では`react-router-serve ./build/server/index.js`を動かします。

`scripts/generate-routes.sh`が`app/routes/static/<id>.tsx`を500個作り`app/routes.ts`がそのディレクトリを読んで`static/<id>`として登録します。静的なルートには`Cache-Control`を付けていません。

`dynamic/:id`のloaderは`LARAVEL_ORIGIN` (指定がなければ`http://laravel:8000`) の`GET /api/pages/:id`を読みます。うまくいったときは`headers`で`Cache-Control: public, s-maxage=60`を返して行がないIDはHTTPの404にします。

イメージは公式のDockerのひな形にならって`node:24.21.0-alpine`に本番用の`node_modules`と`build/`と`public/`を入れています。タグは`benchmark-react-router:vite`です。
