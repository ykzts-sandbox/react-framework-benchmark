export interface PageRecord {
  body: string;
  id: number;
  kind: number;
  title: string;
}

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

const pages = new Map<string, Promise<PageRecord | null>>();

const fetchPage = async (
  kind: number,
  id: unknown
): Promise<PageRecord | null> => {
  if (!canonicalId(id)) {
    return null;
  }

  const response = await fetch(`/api/pages/${kind}/${id}`);

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

// use() needs the same promise on every render of one URL, so loadPage
// keeps one request for each kind and id. It resolves to null for a
// non-canonical id and for a row Laravel does not have.
export const loadPage = (kind: number, id: unknown) => {
  const key = `${kind}/${String(id)}`;
  const cached = pages.get(key);

  if (cached !== undefined) {
    return cached;
  }

  const pending = fetchPage(kind, id);
  pages.set(key, pending);

  return pending;
};
