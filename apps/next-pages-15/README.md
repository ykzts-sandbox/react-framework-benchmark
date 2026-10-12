# Next.js 15 Pages Router

ルートやキャッシュやDockerイメージの作りは[`apps/next-pages`](../next-pages/README.md)と同じでNext.js 15.5.27と`next-rspack` 15.5.27を使っています。

webpackは`next build`でTurbopackは`next build --turbopack`でRspackは`BUNDLER=rspack next build`です。

タグは`benchmark-next-pages-15:webpack`と`benchmark-next-pages-15:turbopack`と`benchmark-next-pages-15:rspack`でsharpを外したものはそれぞれ`-no-sharp`が付きます。
