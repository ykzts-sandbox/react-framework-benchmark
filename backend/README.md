# ベンチマークのAPI

動的なページのためにJSONを返すだけのLaravelのアプリで`GET /api/pages/{kind}/{id}`だけを持っています。kindは動的なルートの種類で1から30まで、idはkindごとに1から1000までです。データベースはMySQL 8.4で起動するたびに`migrate`と`db:seed`が走って30,000行をupsertします。主キーは`(kind, id)`です。タイトルは`Page K-N`で本文は`Benchmark page K-N`です。

行があるときは`200`で`Content-Type: application/json`と`Cache-Control: public, s-maxage=60`を返します。0で始まるkindやidと行がないものは404で`Cache-Control: no-cache, private`です。

イメージは`php:8.4-cli-bookworm`で`php artisan serve --host=0.0.0.0 --port=8000`を動かしています。
