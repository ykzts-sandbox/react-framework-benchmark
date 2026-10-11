import type { LoaderFunctionArgs } from "react-router";
import { useLoaderData } from "react-router";

interface PageRecord {
  body: string;
  id: number;
  title: string;
}

const isPageRecord = (value: unknown): value is PageRecord => {
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

const canonicalId = (id: string | undefined) => {
  if (id === undefined || !/^[1-9]\d*$/u.test(id)) {
    return;
  }

  return id;
};

export const loader = async ({ params }: LoaderFunctionArgs) => {
  const id = canonicalId(params.id);

  if (id === undefined) {
    throw new Response(null, { status: 404 });
  }

  const response = await fetch(`/api/pages/${id}`);

  if (response.status === 404) {
    throw new Response(null, { status: 404 });
  }

  if (!response.ok) {
    throw new Error(`Laravel returned ${response.status}`);
  }

  const page: unknown = await response.json();

  if (!isPageRecord(page)) {
    throw new Error("Laravel returned an unexpected page");
  }

  return page;
};

const Page = () => {
  const page = useLoaderData<typeof loader>();

  return (
    <main>
      <h1>{page.title}</h1>
      <p>{page.body}</p>
    </main>
  );
};

export const ErrorBoundary = () => (
  <main>
    <h1>Not found</h1>
  </main>
);

export default Page;
