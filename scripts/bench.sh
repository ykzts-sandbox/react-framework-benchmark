#!/bin/sh
# Cold application builds and local Docker image measurements.
# npm ci layers may be reused. The timed step always starts without a
# previous .next or Vite build directory.
#
# Usage: bench.sh [all|next-15]
#   all      Next.js 16, Next.js 15, and React Router, 500 static routes.
#   next-15  Next.js 15 only. Writes results/next-15.md.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$root"
mkdir -p results

scope=${1:-all}
case "$scope" in
  all | next-15) ;;
  *)
    echo "usage: bench.sh [all|next-15]" >&2
    exit 1
    ;;
esac

node_image=${NODE_IMAGE:-node:24.21.0-alpine}
cachebust=$(date +%s)
if [ "$scope" = "next-15" ]; then
  base_metrics="$root/results/next-15.md"
else
  base_metrics="$root/results/benchmark.md"
fi

show_failure() {
  echo "$1" >&2
  if [ -f "$2" ]; then
    tail -n 100 "$2" >&2
  fi
}

metric_value() {
  file=$1
  key=$2
  awk -v key="$key" '
    $1 == "BENCH_METRIC" {
      split($2, pair, "=")
      if (pair[1] == key) {
        value = pair[2]
      }
    }
    END { print value }
  ' "$file"
}

bytes_mib() {
  awk -v bytes="$1" 'BEGIN { printf "%.1f", bytes / 1048576 }'
}

image_size() {
  docker image inspect --format '{{.Size}}' "$1"
}

copy_metrics() {
  local tag=$1
  local destination=$2
  local container
  container=$(docker create "$tag")
  docker cp "$container:/tmp/bench-metrics.txt" "$destination"
  docker rm "$container" >/dev/null
}

build_app() {
  local dockerfile=$1
  local tag=$2
  local log=$3
  shift 3

  echo "building ${tag}"
  if ! docker build --progress=plain \
    -f "$dockerfile" \
    "$@" \
    --build-arg CACHEBUST="$cachebust" \
    --target builder \
    -t "${tag}-builder" \
    . >"$log" 2>&1; then
    show_failure "${tag} builder failed" "$log"
    return 1
  fi

  if ! docker build --progress=plain \
    -f "$dockerfile" \
    "$@" \
    --build-arg CACHEBUST="$cachebust" \
    -t "$tag" \
    . >>"$log" 2>&1; then
    show_failure "${tag} runner failed" "$log"
    return 1
  fi

  copy_metrics "${tag}-builder" "${log%.log}.metrics"
}

build_next() {
  local dockerfile=$1
  local tag=$2
  local log=$3
  local sharp_status=0
  shift 3

  build_app "$dockerfile" "$tag" "$log" "$@" --build-arg EXCLUDE_SHARP=0
  sharp_status=$?
  if [ "$sharp_status" -ne 0 ]; then
    return "$sharp_status"
  fi
  build_app "$dockerfile" "${tag}-no-sharp" "${log%.log}-no-sharp.log" \
    "$@" --build-arg EXCLUDE_SHARP=1
}

docker pull "$node_image" >/dev/null

node_version=$(docker run --rm --entrypoint node "$node_image" -p "process.version")
npm_version=$(docker run --rm --entrypoint npm "$node_image" --version)
base_size=$(image_size "$node_image")

{
  echo "# Benchmark results"
  echo
  echo "Measured by \`scripts/bench.sh\`."
  echo
  echo "## Environment"
  echo
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Scope: ${scope}"
  echo "- OS: $(. /etc/os-release && printf '%s' "$PRETTY_NAME") ($(uname -srm))"
  echo "- CPU: $(nproc) cores; $(awk -F: '/model name|Model name|CPU implementer|CPU part/ { gsub(/^[ \t]+/, "", $1); gsub(/^[ \t]+/, "", $2); key = $1 "=" $2; if (!seen[key]++) printf "%s ", key }' /proc/cpuinfo)"
  echo "- Memory: $(awk '/MemTotal/ { printf "%.1f GiB", $2/1024/1024 }' /proc/meminfo)"
  echo "- Docker: $(docker version --format '{{.Server.Version}}')"
  echo "- Node.js image: ${node_image} (${node_version})"
  echo "- npm in image: ${npm_version}"
  echo "- Base image size: ${base_size} bytes ($(bytes_mib "$base_size") MiB)"
  echo "- Static route modules: 500"
  echo "- Image size metric: \`docker image inspect --format '{{.Size}}'\`, the local uncompressed image size, including the shared base image"
  echo "- Added size: image size minus the base image size"
  echo "- Compressed size: config blob plus layer blobs of the linux platform manifest after \`docker push\` to a temporary registry. This is the \`docker pull\` transfer size. Attestation manifests are excluded."
  echo "- Compressed added size: compressed size minus the base image compressed size"
  echo "- Build output: \`.next\` excluding \`.next/cache\` for Next.js, \`build/\` for React Router Framework Mode, and \`dist/\` for React Router Data Mode and Declarative Mode"
  echo "- Build time: wall-clock time of the production build command inside a fresh builder container. Dependency installation is not included."
  echo "- These builds are cold application builds. Docker may reuse the \`npm ci\` layer when the lockfile is unchanged."
  echo
} >"$base_metrics"

run_v16=0
run_v15=0
run_router=0
if [ "$scope" = "all" ]; then
  run_v16=1
  run_v15=1
  run_router=1
else
  run_v15=1
fi

rspack_ok=0
pages_rspack_ok=0
rspack_15_ok=0
pages_rspack_15_ok=0

if [ "$run_v16" -eq 1 ]; then
  build_next apps/next/Dockerfile benchmark-next:webpack results/next-webpack.log \
    --build-arg BUNDLER=webpack --build-arg STATIC_ROUTES=500
  build_next apps/next/Dockerfile benchmark-next:turbopack results/next-turbopack.log \
    --build-arg BUNDLER=turbopack --build-arg STATIC_ROUTES=500
  if build_next apps/next/Dockerfile benchmark-next:rspack results/next-rspack.log \
    --build-arg BUNDLER=rspack --build-arg STATIC_ROUTES=500; then
    rspack_ok=1
  else
    echo "App Router Rspack build failed. See results/next-rspack.log." | tee -a "$base_metrics"
  fi
  build_next apps/next-pages/Dockerfile benchmark-next-pages:webpack results/next-pages-webpack.log \
    --build-arg BUNDLER=webpack --build-arg STATIC_ROUTES=500
  build_next apps/next-pages/Dockerfile benchmark-next-pages:turbopack results/next-pages-turbopack.log \
    --build-arg BUNDLER=turbopack --build-arg STATIC_ROUTES=500
  if build_next apps/next-pages/Dockerfile benchmark-next-pages:rspack results/next-pages-rspack.log \
    --build-arg BUNDLER=rspack --build-arg STATIC_ROUTES=500; then
    pages_rspack_ok=1
  else
    echo "Pages Router Rspack build failed. See results/next-pages-rspack.log." | tee -a "$base_metrics"
  fi
fi

if [ "$run_v15" -eq 1 ]; then
  build_next apps/next-15/Dockerfile benchmark-next-15:webpack results/next-15-webpack.log \
    --build-arg BUNDLER=webpack --build-arg STATIC_ROUTES=500
  build_next apps/next-15/Dockerfile benchmark-next-15:turbopack results/next-15-turbopack.log \
    --build-arg BUNDLER=turbopack --build-arg STATIC_ROUTES=500
  if build_next apps/next-15/Dockerfile benchmark-next-15:rspack results/next-15-rspack.log \
    --build-arg BUNDLER=rspack --build-arg STATIC_ROUTES=500; then
    rspack_15_ok=1
  else
    echo "Next.js 15 App Router Rspack build failed. See results/next-15-rspack.log." | tee -a "$base_metrics"
  fi
  build_next apps/next-pages-15/Dockerfile benchmark-next-pages-15:webpack results/next-pages-15-webpack.log \
    --build-arg BUNDLER=webpack --build-arg STATIC_ROUTES=500
  build_next apps/next-pages-15/Dockerfile benchmark-next-pages-15:turbopack results/next-pages-15-turbopack.log \
    --build-arg BUNDLER=turbopack --build-arg STATIC_ROUTES=500
  if build_next apps/next-pages-15/Dockerfile benchmark-next-pages-15:rspack results/next-pages-15-rspack.log \
    --build-arg BUNDLER=rspack --build-arg STATIC_ROUTES=500; then
    pages_rspack_15_ok=1
  else
    echo "Next.js 15 Pages Router Rspack build failed. See results/next-pages-15-rspack.log." | tee -a "$base_metrics"
  fi
fi

if [ "$run_router" -eq 1 ]; then
  build_app apps/react-router/Dockerfile benchmark-react-router:vite results/react-router.log \
    --build-arg STATIC_ROUTES=500
  build_app apps/react-router-data/Dockerfile benchmark-react-router-data:vite results/react-router-data.log \
    --build-arg STATIC_ROUTES=500
  build_app apps/react-router-declarative/Dockerfile benchmark-react-router-declarative:vite results/react-router-declarative.log \
    --build-arg STATIC_ROUTES=500
fi

{
  echo "## Versions"
  echo
  echo '```text'
} >>"$base_metrics"

if [ "$run_v16" -eq 1 ]; then
  docker run --rm --entrypoint npm benchmark-next:turbopack-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
  docker run --rm --entrypoint npm benchmark-next-pages:turbopack-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
fi
if [ "$run_v15" -eq 1 ]; then
  docker run --rm --entrypoint npm benchmark-next-15:turbopack-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
  docker run --rm --entrypoint npm benchmark-next-pages-15:turbopack-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
fi
if [ "$run_router" -eq 1 ]; then
  docker run --rm --entrypoint npm benchmark-react-router:vite-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
  docker run --rm --entrypoint node benchmark-react-router:vite-builder -p "require('rolldown/package.json').version" >>"$base_metrics" || true
  echo >>"$base_metrics"
  docker run --rm --entrypoint npm benchmark-react-router-data:vite-builder ls --depth=0 >>"$base_metrics" || true
  echo >>"$base_metrics"
  docker run --rm --entrypoint node benchmark-react-router-data:vite-builder -p "require('rolldown/package.json').version" >>"$base_metrics" || true
  echo >>"$base_metrics"
fi

{
  echo '```'
  echo
  echo "## Route comparison"
  echo
  echo "| Framework / Bundler | Build time (s) | Image size (bytes) | Added size (bytes) | Build output (bytes) |"
  echo "| --- | ---: | ---: | ---: | ---: |"
} >>"$base_metrics"

detail_files=""

append_row() {
  local label=$1
  local tag=$2
  local metrics=$3
  local image added build_seconds output_bytes
  image=$(image_size "$tag")
  added=$((image - base_size))
  build_seconds=$(metric_value "$metrics" build_seconds)
  output_bytes=$(metric_value "$metrics" output_bytes)
  echo "| ${label} | ${build_seconds} | ${image} | ${added} | ${output_bytes} |" >>"$base_metrics"
  docker run --rm -i --entrypoint node "$tag" - <scripts/analyze-runtime.mjs >"${metrics%.metrics}.runtime"
  detail_files="${detail_files} ${metrics}"
}

append_next_row() {
  local label=$1
  local tag=$2
  local metrics=$3
  append_row "${label} / sharp" "$tag" "$metrics"
  append_row "${label} / no sharp" "${tag}-no-sharp" "${metrics%.metrics}-no-sharp.metrics"
}

if [ "$run_v16" -eq 1 ]; then
  append_next_row "Next.js 16 App Router / webpack" benchmark-next:webpack results/next-webpack.metrics
  append_next_row "Next.js 16 App Router / Turbopack" benchmark-next:turbopack results/next-turbopack.metrics
  if [ "$rspack_ok" -eq 1 ]; then
    append_next_row "Next.js 16 App Router / Rspack" benchmark-next:rspack results/next-rspack.metrics
  else
    echo "| Next.js 16 App Router / Rspack / sharp | failed |  |  |  |" >>"$base_metrics"
    echo "| Next.js 16 App Router / Rspack / no sharp | failed |  |  |  |" >>"$base_metrics"
  fi
  append_next_row "Next.js 16 Pages Router / webpack" benchmark-next-pages:webpack results/next-pages-webpack.metrics
  append_next_row "Next.js 16 Pages Router / Turbopack" benchmark-next-pages:turbopack results/next-pages-turbopack.metrics
  if [ "$pages_rspack_ok" -eq 1 ]; then
    append_next_row "Next.js 16 Pages Router / Rspack" benchmark-next-pages:rspack results/next-pages-rspack.metrics
  else
    echo "| Next.js 16 Pages Router / Rspack / sharp | failed |  |  |  |" >>"$base_metrics"
    echo "| Next.js 16 Pages Router / Rspack / no sharp | failed |  |  |  |" >>"$base_metrics"
  fi
fi

if [ "$run_v15" -eq 1 ]; then
  append_next_row "Next.js 15 App Router / webpack" benchmark-next-15:webpack results/next-15-webpack.metrics
  append_next_row "Next.js 15 App Router / Turbopack" benchmark-next-15:turbopack results/next-15-turbopack.metrics
  if [ "$rspack_15_ok" -eq 1 ]; then
    append_next_row "Next.js 15 App Router / Rspack" benchmark-next-15:rspack results/next-15-rspack.metrics
  else
    echo "| Next.js 15 App Router / Rspack / sharp | failed |  |  |  |" >>"$base_metrics"
    echo "| Next.js 15 App Router / Rspack / no sharp | failed |  |  |  |" >>"$base_metrics"
  fi
  append_next_row "Next.js 15 Pages Router / webpack" benchmark-next-pages-15:webpack results/next-pages-15-webpack.metrics
  append_next_row "Next.js 15 Pages Router / Turbopack" benchmark-next-pages-15:turbopack results/next-pages-15-turbopack.metrics
  if [ "$pages_rspack_15_ok" -eq 1 ]; then
    append_next_row "Next.js 15 Pages Router / Rspack" benchmark-next-pages-15:rspack results/next-pages-15-rspack.metrics
  else
    echo "| Next.js 15 Pages Router / Rspack / sharp | failed |  |  |  |" >>"$base_metrics"
    echo "| Next.js 15 Pages Router / Rspack / no sharp | failed |  |  |  |" >>"$base_metrics"
  fi
fi

if [ "$run_router" -eq 1 ]; then
  append_row "React Router Framework / Vite + Rolldown" benchmark-react-router:vite results/react-router.metrics
  append_row "React Router Data / Vite + Rolldown" benchmark-react-router-data:vite results/react-router-data.metrics
  append_row "React Router Declarative / Vite + Rolldown" benchmark-react-router-declarative:vite results/react-router-declarative.metrics
fi

compressed_report=$(mktemp)
set -- "$node_image"
if [ "$run_v16" -eq 1 ]; then
  set -- "$@" \
    benchmark-next:webpack \
    benchmark-next:webpack-no-sharp \
    benchmark-next:turbopack \
    benchmark-next:turbopack-no-sharp \
    benchmark-next-pages:webpack \
    benchmark-next-pages:webpack-no-sharp \
    benchmark-next-pages:turbopack \
    benchmark-next-pages:turbopack-no-sharp
  if [ "$rspack_ok" -eq 1 ]; then
    set -- "$@" benchmark-next:rspack benchmark-next:rspack-no-sharp
  fi
  if [ "$pages_rspack_ok" -eq 1 ]; then
    set -- "$@" benchmark-next-pages:rspack benchmark-next-pages:rspack-no-sharp
  fi
fi
if [ "$run_v15" -eq 1 ]; then
  set -- "$@" \
    benchmark-next-15:webpack \
    benchmark-next-15:webpack-no-sharp \
    benchmark-next-15:turbopack \
    benchmark-next-15:turbopack-no-sharp \
    benchmark-next-pages-15:webpack \
    benchmark-next-pages-15:webpack-no-sharp \
    benchmark-next-pages-15:turbopack \
    benchmark-next-pages-15:turbopack-no-sharp
  if [ "$rspack_15_ok" -eq 1 ]; then
    set -- "$@" benchmark-next-15:rspack benchmark-next-15:rspack-no-sharp
  fi
  if [ "$pages_rspack_15_ok" -eq 1 ]; then
    set -- "$@" benchmark-next-pages-15:rspack benchmark-next-pages-15:rspack-no-sharp
  fi
fi
if [ "$run_router" -eq 1 ]; then
  set -- "$@" \
    benchmark-react-router:vite \
    benchmark-react-router-data:vite \
    benchmark-react-router-declarative:vite
fi
sh scripts/measure-compressed.sh "$@" >"$compressed_report"

compressed_of() {
  awk -v image="$1" '$1 == image { print $2 }' "$compressed_report"
}

base_compressed=$(compressed_of "$node_image")
registry_ref=$(awk -F= '$1 == "registry" { print substr($0, index($0, "=") + 1) }' "$compressed_report")
media_types=$(awk -F= '$1 == "media-types" { print substr($0, index($0, "=") + 1) }' "$compressed_report")

{
  echo
  echo "Uncompressed sizes above come from \`docker image inspect\`. They describe the expanded image, including the shared base image."
  echo
  echo "## Registry compressed size"
  echo
  echo "Measured by \`scripts/measure-compressed.sh\` on the tags above. Each image was pushed to a temporary \`${registry_ref}\`. The size is the linux platform manifest's config blob plus its layer blobs, which is the transfer size of \`docker pull\`. Attestation manifests are not included. This is not the size of \`docker save | gzip\`."
  echo
  echo "Observed layer media types: \`${media_types}\`."
  echo
  echo "Base image compressed size: ${base_compressed} bytes."
  echo
  echo "| Framework / Bundler | Compressed size (bytes) | Compressed added size (bytes) |"
  echo "| --- | ---: | ---: |"
} >>"$base_metrics"

append_compressed() {
  local label=$1
  local tag=$2
  local size added
  size=$(compressed_of "$tag")
  added=$((size - base_compressed))
  echo "| ${label} | ${size} | ${added} |" >>"$base_metrics"
}

append_next_compressed() {
  local label=$1
  local tag=$2
  append_compressed "${label} / sharp" "$tag"
  append_compressed "${label} / no sharp" "${tag}-no-sharp"
}

if [ "$run_v16" -eq 1 ]; then
  append_next_compressed "Next.js 16 App Router / webpack" benchmark-next:webpack
  append_next_compressed "Next.js 16 App Router / Turbopack" benchmark-next:turbopack
  if [ "$rspack_ok" -eq 1 ]; then
    append_next_compressed "Next.js 16 App Router / Rspack" benchmark-next:rspack
  else
    echo "| Next.js 16 App Router / Rspack / sharp | failed |  |" >>"$base_metrics"
    echo "| Next.js 16 App Router / Rspack / no sharp | failed |  |" >>"$base_metrics"
  fi
  append_next_compressed "Next.js 16 Pages Router / webpack" benchmark-next-pages:webpack
  append_next_compressed "Next.js 16 Pages Router / Turbopack" benchmark-next-pages:turbopack
  if [ "$pages_rspack_ok" -eq 1 ]; then
    append_next_compressed "Next.js 16 Pages Router / Rspack" benchmark-next-pages:rspack
  else
    echo "| Next.js 16 Pages Router / Rspack / sharp | failed |  |" >>"$base_metrics"
    echo "| Next.js 16 Pages Router / Rspack / no sharp | failed |  |" >>"$base_metrics"
  fi
fi

if [ "$run_v15" -eq 1 ]; then
  append_next_compressed "Next.js 15 App Router / webpack" benchmark-next-15:webpack
  append_next_compressed "Next.js 15 App Router / Turbopack" benchmark-next-15:turbopack
  if [ "$rspack_15_ok" -eq 1 ]; then
    append_next_compressed "Next.js 15 App Router / Rspack" benchmark-next-15:rspack
  else
    echo "| Next.js 15 App Router / Rspack / sharp | failed |  |" >>"$base_metrics"
    echo "| Next.js 15 App Router / Rspack / no sharp | failed |  |" >>"$base_metrics"
  fi
  append_next_compressed "Next.js 15 Pages Router / webpack" benchmark-next-pages-15:webpack
  append_next_compressed "Next.js 15 Pages Router / Turbopack" benchmark-next-pages-15:turbopack
  if [ "$pages_rspack_15_ok" -eq 1 ]; then
    append_next_compressed "Next.js 15 Pages Router / Rspack" benchmark-next-pages-15:rspack
  else
    echo "| Next.js 15 Pages Router / Rspack / sharp | failed |  |" >>"$base_metrics"
    echo "| Next.js 15 Pages Router / Rspack / no sharp | failed |  |" >>"$base_metrics"
  fi
fi

if [ "$run_router" -eq 1 ]; then
  append_compressed "React Router Framework / Vite + Rolldown" benchmark-react-router:vite
  append_compressed "React Router Data / Vite + Rolldown" benchmark-react-router-data:vite
  append_compressed "React Router Declarative / Vite + Rolldown" benchmark-react-router-declarative:vite
fi

{
  echo
  echo "## Build details"
  echo
} >>"$base_metrics"
rm -f "$compressed_report"

for metrics in $detail_files; do
  {
    echo "### ${metrics}"
    echo
    echo '```text'
    cat "$metrics"
    echo
    echo "# runtime image"
    cat "${metrics%.metrics}.runtime"
    echo '```'
    echo
  } >>"$base_metrics"
done

echo "wrote ${base_metrics}"
