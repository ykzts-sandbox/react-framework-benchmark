#!/bin/sh
# Repeat the timed production build of every variant and record each run.
# Each run starts a fresh container from the variant's source stage, so the
# build never sees a previous .next, build, or dist directory. Variants run
# round-robin so slow drift on the host spreads across all of them.
#
# Usage: RUNS=10 sh scripts/bench-repeat.sh
# Appends to results/build-times.csv and resumes from the rows already
# there. Writes results/build-times.md at the end.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$root"
mkdir -p results

runs=${RUNS:-10}
csv="$root/results/build-times.csv"
log=$(mktemp)

cleanup() {
  rm -f "$log"
}

trap cleanup EXIT

# label|dockerfile|tag|build arguments
variants=$(
  cat <<'EOF'
Next.js 16 App Router / webpack / sharp|apps/next/Dockerfile|benchmark-next:webpack|BUNDLER=webpack
Next.js 16 App Router / webpack / no sharp|apps/next/Dockerfile|benchmark-next:webpack-no-sharp|BUNDLER=webpack EXCLUDE_SHARP=1
Next.js 16 App Router / webpack / sharp / no standalone|apps/next/Dockerfile|benchmark-next:webpack-full|BUNDLER=webpack STANDALONE=0
Next.js 16 App Router / Turbopack / sharp|apps/next/Dockerfile|benchmark-next:turbopack|BUNDLER=turbopack
Next.js 16 App Router / Turbopack / no sharp|apps/next/Dockerfile|benchmark-next:turbopack-no-sharp|BUNDLER=turbopack EXCLUDE_SHARP=1
Next.js 16 App Router / Turbopack / sharp / no standalone|apps/next/Dockerfile|benchmark-next:turbopack-full|BUNDLER=turbopack STANDALONE=0
Next.js 16 App Router / Rspack / sharp|apps/next/Dockerfile|benchmark-next:rspack|BUNDLER=rspack
Next.js 16 App Router / Rspack / no sharp|apps/next/Dockerfile|benchmark-next:rspack-no-sharp|BUNDLER=rspack EXCLUDE_SHARP=1
Next.js 16 Pages Router / webpack / sharp|apps/next-pages/Dockerfile|benchmark-next-pages:webpack|BUNDLER=webpack
Next.js 16 Pages Router / webpack / no sharp|apps/next-pages/Dockerfile|benchmark-next-pages:webpack-no-sharp|BUNDLER=webpack EXCLUDE_SHARP=1
Next.js 16 Pages Router / webpack / sharp / no standalone|apps/next-pages/Dockerfile|benchmark-next-pages:webpack-full|BUNDLER=webpack STANDALONE=0
Next.js 16 Pages Router / Turbopack / sharp|apps/next-pages/Dockerfile|benchmark-next-pages:turbopack|BUNDLER=turbopack
Next.js 16 Pages Router / Turbopack / no sharp|apps/next-pages/Dockerfile|benchmark-next-pages:turbopack-no-sharp|BUNDLER=turbopack EXCLUDE_SHARP=1
Next.js 16 Pages Router / Turbopack / sharp / no standalone|apps/next-pages/Dockerfile|benchmark-next-pages:turbopack-full|BUNDLER=turbopack STANDALONE=0
Next.js 16 Pages Router / Rspack / sharp|apps/next-pages/Dockerfile|benchmark-next-pages:rspack|BUNDLER=rspack
Next.js 16 Pages Router / Rspack / no sharp|apps/next-pages/Dockerfile|benchmark-next-pages:rspack-no-sharp|BUNDLER=rspack EXCLUDE_SHARP=1
Next.js 15 App Router / webpack / sharp|apps/next-15/Dockerfile|benchmark-next-15:webpack|BUNDLER=webpack
Next.js 15 App Router / webpack / no sharp|apps/next-15/Dockerfile|benchmark-next-15:webpack-no-sharp|BUNDLER=webpack EXCLUDE_SHARP=1
Next.js 15 App Router / webpack / sharp / no standalone|apps/next-15/Dockerfile|benchmark-next-15:webpack-full|BUNDLER=webpack STANDALONE=0
Next.js 15 App Router / Turbopack / sharp|apps/next-15/Dockerfile|benchmark-next-15:turbopack|BUNDLER=turbopack
Next.js 15 App Router / Turbopack / no sharp|apps/next-15/Dockerfile|benchmark-next-15:turbopack-no-sharp|BUNDLER=turbopack EXCLUDE_SHARP=1
Next.js 15 App Router / Turbopack / sharp / no standalone|apps/next-15/Dockerfile|benchmark-next-15:turbopack-full|BUNDLER=turbopack STANDALONE=0
Next.js 15 App Router / Rspack / sharp|apps/next-15/Dockerfile|benchmark-next-15:rspack|BUNDLER=rspack
Next.js 15 App Router / Rspack / no sharp|apps/next-15/Dockerfile|benchmark-next-15:rspack-no-sharp|BUNDLER=rspack EXCLUDE_SHARP=1
Next.js 15 Pages Router / webpack / sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:webpack|BUNDLER=webpack
Next.js 15 Pages Router / webpack / no sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:webpack-no-sharp|BUNDLER=webpack EXCLUDE_SHARP=1
Next.js 15 Pages Router / webpack / sharp / no standalone|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:webpack-full|BUNDLER=webpack STANDALONE=0
Next.js 15 Pages Router / Turbopack / sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:turbopack|BUNDLER=turbopack
Next.js 15 Pages Router / Turbopack / no sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:turbopack-no-sharp|BUNDLER=turbopack EXCLUDE_SHARP=1
Next.js 15 Pages Router / Turbopack / sharp / no standalone|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:turbopack-full|BUNDLER=turbopack STANDALONE=0
Next.js 15 Pages Router / Rspack / sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:rspack|BUNDLER=rspack
Next.js 15 Pages Router / Rspack / no sharp|apps/next-pages-15/Dockerfile|benchmark-next-pages-15:rspack-no-sharp|BUNDLER=rspack EXCLUDE_SHARP=1
React Router Framework / Vite + Rolldown|apps/react-router/Dockerfile|benchmark-react-router:vite|
React Router Data / Vite + Rolldown|apps/react-router-data/Dockerfile|benchmark-react-router-data:vite|
React Router Declarative / Vite + Rolldown|apps/react-router-declarative/Dockerfile|benchmark-react-router-declarative:vite|
EOF
)

if [ ! -f "$csv" ]; then
  echo "round,label,seconds,finished_at" >"$csv"
fi

completed() {
  awk -F, -v label="$1" 'NR > 1 && $2 == label { count++ } END { print count + 0 }' "$csv"
}

echo "$variants" | while IFS='|' read -r label dockerfile tag build_args; do
  set -- --build-arg STATIC_ROUTES=500
  for build_arg in $build_args; do
    set -- "$@" --build-arg "$build_arg"
  done
  echo "building ${tag}-source"
  if ! docker build --progress=plain -f "$dockerfile" "$@" \
    --target source -t "${tag}-source" . >"$log" 2>&1; then
    tail -n 100 "$log" >&2
    exit 1
  fi
done

round=1
while [ "$round" -le "$runs" ]; do
  echo "$variants" | while IFS='|' read -r label dockerfile tag build_args; do
    if [ "$(completed "$label")" -ge "$round" ]; then
      continue
    fi

    if ! docker run --rm --entrypoint node "${tag}-source" scripts/timed-build.mjs >"$log" 2>&1; then
      echo "${label} failed in round ${round}" >&2
      tail -n 100 "$log" >&2
      exit 1
    fi

    seconds=$(awk -F= '/^BENCH_METRIC build_seconds=/ { print $2 }' "$log")
    echo "${round},${label},${seconds},$(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$csv"
    echo "round ${round}/${runs} ${label} ${seconds}"
  done
  round=$((round + 1))
done

node scripts/summarize-build-times.mjs
