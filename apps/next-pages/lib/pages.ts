export interface PageRecord {
  body: string;
  id: number;
  kind: number;
  title: string;
}

const laravelOrigin = process.env.LARAVEL_ORIGIN ?? "http://laravel:8000";

const isPageRecord = (value: unknown): value is PageRecord => {
  if (typeof value !== "object" || value === null) {
    return false;
  }

  const record = value as {
    body?: unknown;
    id?: unknown;
    kind?: unknown;
    title?: unknown;
  };

  return (
    typeof record.body === "string" &&
    typeof record.id === "number" &&
    typeof record.kind === "number" &&
    typeof record.title === "string"
  );
};

const canonicalId = (id: unknown): id is string =>
  typeof id === "string" && /^[1-9]\d*$/u.test(id);

// Every generated dynamic route reads its rows through this function. It
// returns null for a non-canonical id and for a row Laravel does not have.
export const loadPage = async (
  kind: number,
  id: unknown
): Promise<PageRecord | null> => {
  if (!canonicalId(id)) {
    return null;
  }

  const response = await fetch(`${laravelOrigin}/api/pages/${kind}/${id}`);

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
};
