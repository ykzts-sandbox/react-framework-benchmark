import { notFound } from "next/navigation";

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

const canonicalId = (id: string) => /^[1-9]\d*$/u.test(id);

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const { id } = await params;

  if (!canonicalId(id)) {
    notFound();
  }

  const response = await fetch(`${laravelOrigin}/api/pages/${id}`);

  if (response.status === 404) {
    notFound();
  }

  if (!response.ok) {
    throw new Error(`Laravel returned ${response.status}`);
  }

  const page: unknown = await response.json();

  if (!isPageRecord(page)) {
    throw new Error("Laravel returned an unexpected page");
  }

  return (
    <main>
      <h1>{page.title}</h1>
      <p>{page.body}</p>
    </main>
  );
};

export default Page;
