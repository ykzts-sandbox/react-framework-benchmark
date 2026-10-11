import type { AppProps } from "next/app";
import Head from "next/head";

const App = ({ Component, pageProps }: AppProps) => (
  <>
    <Head>
      <title>Benchmark</title>
    </Head>
    <Component {...pageProps} />
  </>
);

export default App;
