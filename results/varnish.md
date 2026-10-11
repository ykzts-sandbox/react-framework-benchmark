# Varnish observations

Varnish URL: http://127.0.0.1:8080

The VCL uses built-in caching. It passes RSC requests that have no _rsc query, because those responses are 307 redirects and a cache fill of them replaces the HTML object for the same URL.

```text
static html 1
  url: http://127.0.0.1:8080/static/1
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 1
static html 2
  url: http://127.0.0.1:8080/static/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 1
static rsc header 1
  url: http://127.0.0.1:8080/static/1
  status: 307
  x-cache: PASS
  content-type: <none>
  cache-control: <none>
  vary: <none>
  location: /static/1?_rsc
  body-bytes: 0
  body-kind: empty
static rsc redirect 1
  url: http://127.0.0.1:8080/static/1?_rsc
  status: 200
  x-cache: MISS
  content-type: text/x-component
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3764
  body-kind: rsc
static rsc redirect 2
  url: http://127.0.0.1:8080/static/1?_rsc
  status: 200
  x-cache: HIT
  content-type: text/x-component
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3764
  body-kind: rsc
static html after rsc
  url: http://127.0.0.1:8080/static/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 1
static prefetch 1
  url: http://127.0.0.1:8080/static/1
  status: 307
  x-cache: PASS
  content-type: <none>
  cache-control: <none>
  vary: <none>
  location: /static/1?_rsc=HEAvJdHAQJrUAe2K
  body-bytes: 0
  body-kind: empty
static prefetch redirect 1
  url: http://127.0.0.1:8080/static/1?_rsc=HEAvJdHAQJrUAe2K
  status: 200
  x-cache: MISS
  content-type: text/x-component
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3764
  body-kind: rsc
static prefetch redirect 2
  url: http://127.0.0.1:8080/static/1?_rsc=HEAvJdHAQJrUAe2K
  status: 200
  x-cache: HIT
  content-type: text/x-component
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3764
  body-kind: rsc
static html after prefetch
  url: http://127.0.0.1:8080/static/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 1
static page 2 html 1
  url: http://127.0.0.1:8080/static/2
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 2
static page 2 html 2
  url: http://127.0.0.1:8080/static/2
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5578
  body-kind: html
  h1: Page 2
static page 500 html 1
  url: http://127.0.0.1:8080/static/500
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5590
  body-kind: html
  h1: Page 500
static page 500 html 2
  url: http://127.0.0.1:8080/static/500
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: s-maxage=31536000
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5590
  body-kind: html
  h1: Page 500
dynamic html 1
  url: http://127.0.0.1:8080/dynamic/1
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 1
dynamic html 2
  url: http://127.0.0.1:8080/dynamic/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 1
dynamic rsc header 1
  url: http://127.0.0.1:8080/dynamic/1
  status: 307
  x-cache: PASS
  content-type: <none>
  cache-control: public, s-maxage=60
  vary: <none>
  location: /dynamic/1?_rsc
  body-bytes: 0
  body-kind: empty
dynamic rsc redirect 1
  url: http://127.0.0.1:8080/dynamic/1?_rsc
  status: 200
  x-cache: MISS
  content-type: text/x-component
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3637
  body-kind: rsc
dynamic rsc redirect 2
  url: http://127.0.0.1:8080/dynamic/1?_rsc
  status: 200
  x-cache: HIT
  content-type: text/x-component
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 3637
  body-kind: rsc
dynamic html after rsc
  url: http://127.0.0.1:8080/dynamic/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 1
dynamic page 2 html 1
  url: http://127.0.0.1:8080/dynamic/2
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 2
dynamic page 2 html 2
  url: http://127.0.0.1:8080/dynamic/2
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 2
dynamic html after other page
  url: http://127.0.0.1:8080/dynamic/1
  status: 200
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5605
  body-kind: html
  h1: Page 1
dynamic page 500
  url: http://127.0.0.1:8080/dynamic/500
  status: 200
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5617
  body-kind: html
  h1: Page 500
dynamic missing 1
  url: http://127.0.0.1:8080/dynamic/501
  status: 404
  x-cache: MISS
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5403
  body-kind: html
dynamic missing 2
  url: http://127.0.0.1:8080/dynamic/501
  status: 404
  x-cache: HIT
  content-type: text/html; charset=utf-8
  cache-control: public, s-maxage=60
  vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding
  location: <none>
  body-bytes: 5403
  body-kind: html
```

## varnishstat

```text
MAIN.cache_hit              13         6.50 Cache hits
MAIN.cache_hitpass            0         0.00 Cache hits for pass.
MAIN.cache_miss              11         5.50 Cache misses
MAIN.n_object                11          .   object structs made
MAIN.n_objectcore            12          .   objectcore structs made
```
