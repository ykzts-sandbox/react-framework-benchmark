# React Router Framework Mode

React Router 8.4.0、Vite 8.3.4、Rolldown。`react-router.config.ts` は `ssr: true`。本番プロセスは `react-router-serve ./build/server/index.js`。

`scripts/generate-routes.sh` が `app/routes/static/<id>.tsx` を 500 個作る。`app/routes.ts` がそのディレクトリを読んで `static/<id>` を登録する。`dynamic/:id` の loader は `LARAVEL_ORIGIN`（既定は `http://laravel:8000`）の `GET /api/pages/:id` を読む。成功した応答の `headers` は `Cache-Control: public, s-maxage=60`。行が無い ID は HTTP 404。

イメージは `node:24.21.0-alpine`。ランタイムには本番の `node_modules` と `build/`、`public/` を入れる。計測タグは `benchmark-react-router:vite`。
