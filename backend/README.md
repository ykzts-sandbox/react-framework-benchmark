# ベンチマークのAPI

動的なページのためにJSONを返すだけのLaravelのアプリで`GET /api/pages/{id}`だけを持っています。データベースはMySQL 8.4で起動するたびに`migrate`と`db:seed`が走ってidが1から500までの行をupsertします。タイトルは`Page N`で本文は`Benchmark page N`です。

行があるときは`200`で`Content-Type: application/json`と`Cache-Control: public, s-maxage=60`を返します。0で始まるIDや行がないIDは404で`Cache-Control: no-cache, private`です。

イメージは`php:8.4-cli-bookworm`で`php artisan serve --host=0.0.0.0 --port=8000`を動かしています。
