interface PageRecord {
  body: string;
  id: number;
  title: string;
}

const laravelOrigin = process.env.LARAVEL_ORIGIN ?? "http://laravel:8000";

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

export const loader = async ({ params }: { params: { id?: string } }) => {
  const id = canonicalId(params.id);

  if (id === undefined) {
    throw new Response(null, { status: 404 });
  }

  const response = await fetch(`${laravelOrigin}/api/pages/${id}`);

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

export const headers = ({ errorHeaders }: { errorHeaders?: Headers }) => {
  if (errorHeaders !== undefined) {
    return { "Cache-Control": "private, no-store" };
  }

  return { "Cache-Control": "public, s-maxage=60" };
};

const Page = ({ loaderData }: { loaderData: PageRecord }) => (
  <main>
    <h1>{loaderData.title}</h1>
    <p>{loaderData.body}</p>
  </main>
);

export default Page;
