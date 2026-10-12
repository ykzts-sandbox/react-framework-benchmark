# react-framework-benchmark

同じルートをNext.jsとReact Routerのいくつかの書き方で作ってビルドの時間とDockerイメージの大きさを計ったものです。ルートは決まった文字を出すだけの静的なルート20個と、Laravelから行を読む動的なルート30個です。動的なルートはそれぞれidが1から1000までのページを出すので合わせて30,000ページになります。

![ビルドの時間](results/build-time.svg)

![Dockerイメージの大きさ](results/image-size.svg)

ビルドの時間は10回計った中央値でsharpありのものです。sharpなしでもほとんど変わりません。最初の列はNext.js 16とReact Routerの標準のバンドラです。Next.js 15の標準のバンドラはwebpackでTurbopackは`--turbopack`をつけたときだけ使われます。

| アプリ | Turbopack / Vite + Rolldown | Turbopack (standaloneなし) | webpack | webpack (standaloneなし) | Rspack |
| --- | --: | --: | --: | --: | --: |
| Next.js 16 App Router | 3.1秒 | 2.9秒 | 13.2秒 | 9.5秒 | 11.4秒 |
| Next.js 16 Pages Router | 2.7秒 | 2.4秒 | 11.0秒 | 7.5秒 | 10.0秒 |
| Next.js 15 App Router | 17.1秒 | 12.4秒 | 14.5秒 | 9.7秒 | 12.5秒 |
| Next.js 15 Pages Router | 13.0秒 | 8.3秒 | 12.2秒 | 7.4秒 | 10.9秒 |
| React Router Framework | 0.7秒 |  |  |  |  |
| React Router Data | 0.2秒 |  |  |  |  |
| React Router Declarative | 0.2秒 |  |  |  |  |

Dockerイメージの大きさもsharpありのものです。sharpなしにするとNext.jsはどれも8.4MiBほど小さくなります。

| アプリ | Turbopack / Vite + Rolldown | Turbopack (standaloneなし) | webpack | webpack (standaloneなし) | Rspack |
| --- | --: | --: | --: | --: | --: |
| Next.js 16 App Router | 70.9 MiB | 144.5 MiB | 73.7 MiB | 144.0 MiB | 73.6 MiB |
| Next.js 16 Pages Router | 71.0 MiB | 143.8 MiB | 73.6 MiB | 143.7 MiB | 73.6 MiB |
| Next.js 15 App Router | 75.5 MiB | 148.5 MiB | 75.6 MiB | 147.0 MiB | 75.5 MiB |
| Next.js 15 Pages Router | 75.3 MiB | 146.9 MiB | 75.3 MiB | 146.8 MiB | 75.3 MiB |
| React Router Framework | 66.6 MiB |  |  |  |  |
| React Router Data | 59.3 MiB |  |  |  |  |
| React Router Declarative | 59.3 MiB |  |  |  |  |

ビルドは依存のインストールを除いた本番ビルドのコマンドだけの時間でそれぞれ10回計った中央値です。毎回新しいコンテナで`.next`などがない状態から始めて全部の組み合わせを1回ずつ順に回すのを10周しています。大きさはイメージをレジストリにpushしたときのlinuxのマニフェストにあるconfigとレイヤーの合計なのでdocker pullで送られる量と同じです。ベースの`node:24.21.0-alpine`も含みます。sharpなしは`outputFileTracingExcludes`で`node_modules/sharp`と`node_modules/@img`を外したイメージです。standaloneなしは`STANDALONE=0`で`output: "standalone"`を外してビルドして本番用の`node_modules`と`.next`を入れて`next start`で動かすイメージです。Next.js 15は`next.config.ts`を読むのに`typescript`が要るのでそれも入れています。ビルドの時間のばらつきは`results/build-times.md`に、毎回の数字は`results/build-times.csv`にあります。大きさのバイト数は`results/benchmark.md`にありますがstandaloneなしだけは別の回に作ったイメージで`results/no-standalone.md`にあります。

どれもMac mini (Apple M4、メモリ16GB) の上で立ち上げたDev ContainerからDocker in Dockerで計っています。Dockerから見えるのは8コアと11.7GiBのメモリです。

静的なルートといってもビルドのときにHTMLを書き出すことはしていません。App Routerは`dynamic = "force-dynamic"`でPages Routerは`getServerSideProps`を使ってReact Router Framework Modeと同じくリクエストのたびにレンダリングするようにそろえています。動的なルートも`generateStaticParams`や`getStaticPaths`や`prerender`は使わずにリクエストのたびにLaravelから読みます。

リポジトリのルートで`make bench`を実行するとイメージを作り直してすべて1回ずつ計り直します。ビルドの時間を10回ずつ計るのは`make repeat`で`RUNS`で回数を変えられます。止まっても`results/build-times.csv`にある分から続けます。standaloneなしだけなら`sh scripts/bench.sh no-standalone`です。グラフは`make charts`で作り直せます。

- [Next.js 16 App Router](apps/next/README.md)
- [Next.js 16 Pages Router](apps/next-pages/README.md)
- [Next.js 15 App Router](apps/next-15/README.md)
- [Next.js 15 Pages Router](apps/next-pages-15/README.md)
- [React Router Framework Mode](apps/react-router/README.md)
- [React Router Data Mode](apps/react-router-data/README.md)
- [React Router Declarative Mode](apps/react-router-declarative/README.md)
- [Laravel](backend/README.md)
- [Varnish](varnish/README.md)

| 名前            | バージョン                      |
| --------------- | ------------------------------- |
| Next.js 16      | 16.4.0                          |
| Next.js 15      | 15.5.27                         |
| next-rspack     | 16.4.0 / 15.5.27                |
| React Router    | 8.4.0                           |
| Vite / Rolldown | 8.3.4 / 1.2.13                  |
| React           | 19.3.0                          |
| Node.js         | 24.21.0 (`node:24.21.0-alpine`) |
| Varnish         | 7.7                             |
| Laravel / PHP   | 13.35.0 / 8.4.26                |
| MySQL           | 8.4.11                          |

## Varnish

App Routerでもページごとのキャッシュができることを確かめるために`benchmark-next:cache-demo`の前にVarnishを置いています。`make varnish-verify`のログは`results/varnish.md`にあります。

静的なHTMLは`s-maxage=31536000`で2回目からHITになります。動的なHTMLは`public, s-maxage=60`でURLごとにHITになります。`?_rsc`の付いたRSCはHTMLとは別のものとしてHITになり`_rsc`のないRSCのリクエストはPASSです。`/dynamic/1/1`は`Page 1-1`と`Benchmark page 1-1`を返し`/dynamic/30/1001`は404のHTMLを返して2回目からHITになります。
