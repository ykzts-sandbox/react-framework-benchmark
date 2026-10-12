# Next.js 15 App Router

ルートやキャッシュやDockerイメージの作りは[`apps/next`](../next/README.md)と同じでNext.js 15.5.27と`next-rspack` 15.5.27を使っています。違うのは`headers()`が`Promise`を返すところと`tsconfig.json`の`jsx`が`preserve`なところくらいです。

webpackは`next build`でTurbopackは`next build --turbopack`でRspackは`BUNDLER=rspack next build`です。

タグは`benchmark-next-15:webpack`と`benchmark-next-15:turbopack`と`benchmark-next-15:rspack`でsharpを外したものはそれぞれ`-no-sharp`が付きます。
