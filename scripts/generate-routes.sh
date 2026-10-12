#!/bin/sh
# Recreate the generated route modules of the benchmark apps.
# STATIC_ROUTES pages render fixed text. DYNAMIC_ROUTES route modules each
# take an id and read the matching row of their kind from Laravel.
# Usage: STATIC_ROUTES=20 DYNAMIC_ROUTES=30 sh scripts/generate-routes.sh apps/next apps/react-router
set -eu

if [ "$#" -lt 1 ]; then
  echo "usage: generate-routes.sh <app-directory>..." >&2
  exit 1
fi

static_count=${STATIC_ROUTES:-20}
dynamic_count=${DYNAMIC_ROUTES:-30}
for value in "$static_count" "$dynamic_count"; do
  case "$value" in
    '' | *[!0-9]*)
      echo "STATIC_ROUTES and DYNAMIC_ROUTES must be non-negative integers" >&2
      exit 1
      ;;
  esac
done

write_page() {
  file=$1
  id=$2
  cat >"$file" <<EOF
const Page = () => (
  <main>
    <h1>Page ${id}</h1>
    <p>Benchmark page ${id}</p>
  </main>
);

export default Page;
EOF
}

write_app_page() {
  file=$1
  id=$2
  cat >"$file" <<EOF
export const dynamic = "force-dynamic";

const Page = () => (
  <main>
    <h1>Page ${id}</h1>
    <p>Benchmark page ${id}</p>
  </main>
);

export default Page;
EOF
}

# getServerSideProps renders on each request, like the App Router pages with
# force-dynamic. Without this header Next.js would send no-store.
write_pages_page() {
  file=$1
  id=$2
  cat >"$file" <<EOF
import type { GetServerSideProps } from "next";

export const getServerSideProps: GetServerSideProps = async ({ res }) => {
  res.setHeader("Cache-Control", "public, s-maxage=31536000");

  return { props: {} };
};

const Page = () => (
  <main>
    <h1>Page ${id}</h1>
    <p>Benchmark page ${id}</p>
  </main>
);

export default Page;
EOF
}

write_app_dynamic() {
  file=$1
  kind=$2
  cat >"$file" <<EOF
import { notFound } from "next/navigation";

import { loadPage } from "@/lib/pages";

const Page = async ({ params }: { params: Promise<{ id: string }> }) => {
  const { id } = await params;
  const page = await loadPage(${kind}, id);

  if (page === null) {
    notFound();
  }

  return (
    <main>
      <h1>{page.title}</h1>
      <p>{page.body}</p>
    </main>
  );
};

export default Page;
EOF
}

# getServerSideProps would otherwise force no-store. The row is not
# personalized, so the shared cache may store this URL for 60 seconds.
write_pages_dynamic() {
  file=$1
  kind=$2
  cat >"$file" <<EOF
import type { GetServerSideProps } from "next";

import { loadPage } from "@/lib/pages";
import type { PageRecord } from "@/lib/pages";

export const getServerSideProps: GetServerSideProps<PageRecord> = async ({
  params,
  res,
}) => {
  const page = await loadPage(${kind}, params?.id);

  if (page === null) {
    return { notFound: true };
  }

  res.setHeader("Cache-Control", "public, s-maxage=60");

  return { props: page };
};

const Page = ({ body, title }: PageRecord) => (
  <main>
    <h1>{title}</h1>
    <p>{body}</p>
  </main>
);

export default Page;
EOF
}

write_framework_dynamic() {
  file=$1
  kind=$2
  cat >"$file" <<EOF
import { loadPage } from "~/lib/pages.server";
import type { PageRecord } from "~/lib/pages.server";

export const loader = async ({ params }: { params: { id?: string } }) => {
  const page = await loadPage(${kind}, params.id);

  if (page === null) {
    throw new Response(null, { status: 404 });
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
EOF
}

write_data_dynamic() {
  file=$1
  kind=$2
  cat >"$file" <<EOF
import type { LoaderFunctionArgs } from "react-router";
import { useLoaderData } from "react-router";

import { loadPage } from "../../lib/pages";

export const loader = async ({ params }: LoaderFunctionArgs) => {
  const page = await loadPage(${kind}, params.id);

  if (page === null) {
    throw new Response(null, { status: 404 });
  }

  return page;
};

export const ErrorBoundary = () => (
  <main>
    <h1>Not found</h1>
  </main>
);

const Page = () => {
  const page = useLoaderData<typeof loader>();

  return (
    <main>
      <h1>{page.title}</h1>
      <p>{page.body}</p>
    </main>
  );
};

export default Page;
EOF
}

write_declarative_dynamic() {
  file=$1
  kind=$2
  cat >"$file" <<EOF
import { use } from "react";
import { useParams } from "react-router";

import { loadPage } from "../../lib/pages";

const Page = () => {
  const { id } = useParams();
  const page = use(loadPage(${kind}, id));

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
EOF
}

# Write <dest>/<n>.tsx, or <dest>/<n>/<leaf> when a leaf name is given.
generate() {
  dest=$1
  count=$2
  label=$3
  writer=$4
  leaf=${5:-}
  rm -rf "$dest"
  mkdir -p "$dest"
  i=1
  while [ "$i" -le "$count" ]; do
    if [ -n "$leaf" ]; then
      mkdir -p "$(dirname "$dest/$i/$leaf")"
      "$writer" "$dest/$i/$leaf" "$i"
    else
      "$writer" "$dest/$i.tsx" "$i"
    fi
    i=$((i + 1))
  done
  echo "generated ${count} ${label} in ${dest}"
}

for app in "$@"; do
  if [ ! -f "$app/benchmark-mode" ]; then
    echo "missing benchmark-mode in ${app}" >&2
    exit 1
  fi

  mode=$(tr -d '[:space:]' <"$app/benchmark-mode")
  case "$mode" in
    app)
      generate "$app/app/static" "$static_count" \
        "Next.js static routes" write_app_page page.tsx
      generate "$app/app/dynamic" "$dynamic_count" \
        "Next.js dynamic routes" write_app_dynamic "[id]/page.tsx"
      ;;
    pages)
      generate "$app/pages/static" "$static_count" \
        "Next.js Pages Router static routes" write_pages_page
      generate "$app/pages/dynamic" "$dynamic_count" \
        "Next.js Pages Router dynamic routes" write_pages_dynamic "[id].tsx"
      ;;
    framework)
      generate "$app/app/routes/static" "$static_count" \
        "React Router Framework static routes" write_page
      generate "$app/app/routes/dynamic" "$dynamic_count" \
        "React Router Framework dynamic routes" write_framework_dynamic
      ;;
    data)
      generate "$app/src/routes/static" "$static_count" \
        "React Router Data static routes" write_page
      generate "$app/src/routes/dynamic" "$dynamic_count" \
        "React Router Data dynamic routes" write_data_dynamic
      ;;
    declarative)
      generate "$app/src/routes/static" "$static_count" \
        "React Router Declarative static routes" write_page
      generate "$app/src/routes/dynamic" "$dynamic_count" \
        "React Router Declarative dynamic routes" write_declarative_dynamic
      ;;
    *)
      echo "unknown benchmark-mode ${mode} in ${app}" >&2
      exit 1
      ;;
  esac
done
