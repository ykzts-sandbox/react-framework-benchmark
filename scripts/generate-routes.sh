#!/bin/sh
# Recreate the static route modules for one or both benchmark apps.
# Usage: STATIC_ROUTES=500 sh scripts/generate-routes.sh apps/next apps/react-router
set -eu

if [ "$#" -lt 1 ]; then
  echo "usage: generate-routes.sh <app-directory>..." >&2
  exit 1
fi

count=${STATIC_ROUTES:-500}
case "$count" in
  '' | *[!0-9]*)
    echo "STATIC_ROUTES must be a non-negative integer" >&2
    exit 1
    ;;
esac

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

generate_next() {
  app=$1
  dest="$app/app/static"
  rm -rf "$dest"
  mkdir -p "$dest"
  i=1
  while [ "$i" -le "$count" ]; do
    mkdir -p "$dest/$i"
    write_app_page "$dest/$i/page.tsx" "$i"
    i=$((i + 1))
  done
  echo "generated ${count} Next.js static routes in ${dest}"
}

generate_flat() {
  dest=$1
  label=$2
  writer=${3:-write_page}
  rm -rf "$dest"
  mkdir -p "$dest"
  i=1
  while [ "$i" -le "$count" ]; do
    "$writer" "$dest/$i.tsx" "$i"
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
      generate_next "$app"
      ;;
    pages)
      generate_flat "$app/pages/static" "Next.js Pages Router routes" write_pages_page
      ;;
    framework)
      generate_flat "$app/app/routes/static" "React Router Framework routes"
      ;;
    data)
      generate_flat "$app/src/routes/static" "React Router Data routes"
      ;;
    declarative)
      generate_flat "$app/src/routes/static" "React Router Declarative routes"
      ;;
    *)
      echo "unknown benchmark-mode ${mode} in ${app}" >&2
      exit 1
      ;;
  esac
done
