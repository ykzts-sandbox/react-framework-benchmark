import { use } from "react";
import { useParams } from "react-router";

interface PageRecord {
  body: string;
  id: number;
  title: string;
}

const pages = new Map<string, Promise<PageRecord | null>>();

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

const loadPage = (id: string) => {
  const cached = pages.get(id);

  if (cached !== undefined) {
    return cached;
  }

  const pending = (async () => {
    const response = await fetch(`/api/pages/${id}`);

    if (response.status === 404) {
      return null;
    }

    if (!response.ok) {
      throw new Error(`Laravel returned ${response.status}`);
    }

    const page: unknown = await response.json();

    if (!isPageRecord(page)) {
      throw new Error("Laravel returned an unexpected page");
    }

    return page;
  })();

  pages.set(id, pending);

  return pending;
};

const Page = () => {
  const { id } = useParams();
  const numericId = canonicalId(id);

  if (numericId === undefined) {
    return (
      <main>
        <h1>Not found</h1>
      </main>
    );
  }

  const page = use(loadPage(numericId));

  if (page === null) {
    return (
      <main>
        <h1>Not found</h1>
      </main>
    );
  }

  return (
    <main>
      <h1>{page.title}</h1>
      <p>{page.body}</p>
    </main>
  );
};

export default Page;
