# React Router Declarative Mode

React Router 8.4.0 の `BrowserRouter` と `Routes`。Vite 8.3.4、Rolldown。

静的ルート 500 個は `import.meta.glob("./routes/static/*.tsx")` とモジュールスコープの `React.lazy`。`scripts/generate-routes.sh` が `src/routes/static/<id>.tsx` を作る。動的ルートはブラウザから `/api/pages/:id` を取る。最初の HTML は空のシェル。行が無い ID はコンポーネントが `Not found` を描く。文書の HTTP ステータスは 200。

本番イメージは `dist/` と `scripts/spa-server.mjs`。`/api` は `LARAVEL_ORIGIN` へ中継し、ステータスと `Cache-Control` を返す。拡張子の無い URL には `index.html` を返し、拡張子のある無いファイルは 404。計測タグは `benchmark-react-router-declarative:vite`。
