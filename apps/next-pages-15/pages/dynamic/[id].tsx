import type { GetServerSideProps } from "next";

interface PageProps {
  body: string;
  id: number;
  title: string;
}

const laravelOrigin = process.env.LARAVEL_ORIGIN ?? "http://laravel:8000";

const isPageRecord = (value: unknown): value is PageProps => {
  if (typeof value !== "object" || value === null) {
    return false;
  }

  const record = value as { body?: unknown; id?: unknown; title?: unknown };

  return (
    typeof record.body === "string" &&
    typeof record.id === "number" &&
    typeof record.title === "string"
  );
};

const canonicalId = (id: string | string[] | undefined) => {
  const value = Array.isArray(id) ? id[0] : id;

  if (value === undefined || !/^[1-9]\d*$/u.test(value)) {
    return;
  }

  return value;
};

// getServerSideProps would otherwise force no-store. The row is not
// personalized, so the shared cache may store this URL for 60 seconds.
export const getServerSideProps: GetServerSideProps<PageProps> = async ({
  params,
  res,
}) => {
  const id = canonicalId(params?.id);

  if (id === undefined) {
    return { notFound: true };
  }

  const response = await fetch(`${laravelOrigin}/api/pages/${id}`);

  if (response.status === 404) {
    return { notFound: true };
  }

  if (!response.ok) {
    throw new Error(`Laravel returned ${response.status}`);
  }

  const page: unknown = await response.json();

  if (!isPageRecord(page)) {
    throw new Error("Laravel returned an unexpected page");
  }

  res.setHeader("Cache-Control", "public, s-maxage=60");

  return { props: page };
};

const Page = ({ body, title }: PageProps) => (
  <main>
    <h1>{title}</h1>
    <p>{body}</p>
  </main>
);

export default Page;
