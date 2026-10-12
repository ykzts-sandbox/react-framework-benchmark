# Varnish

`varnish:7.7`を使っていてApp Routerのポート3000につないでいます。

`RSC`ヘッダーがあってURLに`_rsc`がないリクエストは`return (pass)`します。このときNext.jsは`?_rsc`付きのURLへの307を返すのですがこれをキャッシュすると同じURLのHTMLが置き換わってしまうためです。`?_rsc`の付いたレスポンスはNext.jsが付けた`Cache-Control`のとおりにキャッシュします。HTMLとRSCはURLが違うので別々にキャッシュされます。

`vcl_deliver`で`X-Cache`に`HIT`か`MISS`か`PASS`を付けています。
