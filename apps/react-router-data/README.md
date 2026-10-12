# React Router Data Mode

React Router 8.4.0の`createBrowserRouter`とVite 8.3.4 (Rolldown) を使っています。

静的なルート20個と動的なルート30個は`import.meta.glob`とrouteの`lazy`で読み込みます。`scripts/generate-routes.sh`が`src/routes/static/<id>.tsx`と`src/routes/dynamic/<kind>.tsx`を作ります。動的なルートのloaderはブラウザから`src/lib/pages.ts`の`loadPage`で`/api/pages/:kind/:id`を読みます。最初に返すHTMLは中身のない枠だけで文字はJavaScriptが動いてから出ます。行がないIDはError Boundaryが`Not found`を出しますがHTTPのステータスは200のままです。

イメージには`dist/`と`scripts/spa-server.mjs`だけを入れています。`/api`は`LARAVEL_ORIGIN`へ中継してステータスと`Cache-Control`をそのまま返します。拡張子のないURLには`index.html`を返して拡張子のあるURLでファイルがないときは404です。タグは`benchmark-react-router-data:vite`です。
