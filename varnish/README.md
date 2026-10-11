# Varnish

`varnish:7.7`。バックエンドは App Router のポート 3000。

`RSC` ヘッダがあり、URL に `_rsc` が無い要求は `return (pass)` する。`?_rsc` の付いた応答は、Next.js が付けた `Cache-Control` に従って保存する。HTML と RSC は URL が違うので別のオブジェクトになる。

`vcl_deliver` は `X-Cache` に `HIT`、`MISS`、`PASS` を付ける。
