#!/bin/sh
# Request HTML and RSC payloads through Varnish and record HIT/MISS/PASS.
set -eu

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$root"
mkdir -p results

base=${VARNISH_URL:-http://127.0.0.1:8080}
report="$root/results/varnish.md"

# Build the cache-demo App Router image and the Laravel API. MySQL is the
# source for /dynamic/:kind/:id. Recreate Varnish so it attaches to this Next.js.
docker compose up -d --build --wait mysql laravel nextjs
docker compose up -d --force-recreate --no-deps varnish

wait_for_url() {
  url=$1
  attempt=0
  while [ "$attempt" -lt 60 ]; do
    if curl -fsS -o /dev/null --max-time 2 "$url" 2>/dev/null; then
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  echo "timed out waiting for ${url}" >&2
  return 1
}

header_value() {
  file=$1
  name=$2
  # mawk has no IGNORECASE. Compare the header name in lowercase.
  awk -v name="$name" '{
    header = tolower($0)
    wanted = tolower(name) ":"
    if (index(header, wanted) == 1) {
      sub("^[^:]+:[ \t]*", "")
      sub("\r$", "")
      print
    }
  }' "$file" | tail -n 1
}

status_code() {
  awk 'NR == 1 { print $2 }' "$1"
}

request() {
  label=$1
  url=$2
  shift 2
  header_file=$(mktemp)
  body_file=$(mktemp)
  curl -sS -D "$header_file" -o "$body_file" "$@" "$url"
  status=$(status_code "$header_file")
  cache=$(header_value "$header_file" X-Cache)
  cache_control=$(header_value "$header_file" Cache-Control)
  vary=$(header_value "$header_file" Vary)
  content_type=$(header_value "$header_file" Content-Type)
  location=$(header_value "$header_file" Location)
  echo "${label}"
  echo "  url: ${url}"
  echo "  status: ${status}"
  echo "  x-cache: ${cache:-<none>}"
  echo "  content-type: ${content_type:-<none>}"
  echo "  cache-control: ${cache_control:-<none>}"
  echo "  vary: ${vary:-<none>}"
  echo "  location: ${location:-<none>}"
  echo "  body-bytes: $(wc -c <"$body_file" | tr -d ' ')"
  if grep -q '<html' "$body_file"; then
    echo "  body-kind: html"
  elif grep -q 'react.fragment' "$body_file"; then
    echo "  body-kind: rsc"
  elif [ ! -s "$body_file" ]; then
    echo "  body-kind: empty"
  else
    echo "  body-kind: other"
  fi
  h1=$(sed -n 's/.*<h1>\([^<]*\)<\/h1>.*/\1/p' "$body_file" | head -n 1)
  if [ -n "$h1" ]; then
    echo "  h1: ${h1}"
  fi
  if [ -n "$location" ]; then
    printf '%s' "$location" >"$root/results/last-location.txt"
  fi
  rm -f "$header_file" "$body_file"
}

wait_for_url "http://127.0.0.1:8000/api/pages/1/1"
wait_for_url "http://127.0.0.1:3000/dynamic/1/1"
wait_for_url "${base}/"

timeout 30 docker compose exec -T varnish varnishlog -g request -i ReqURL,ReqMethod,ReqHeader,RespStatus,RespHeader,VCL_call,Hit,BereqURL >results/varnishlog.txt &
log_pid=$!
sleep 1

{
  echo "# Varnish observations"
  echo
  echo "Varnish URL: ${base}"
  echo
  echo "The VCL uses built-in caching. It passes RSC requests that have no _rsc query, because those responses are 307 redirects and a cache fill of them replaces the HTML object for the same URL."
  echo
  echo '```text'
  request "static html 1" "${base}/static/1"
  request "static html 2" "${base}/static/1"
  request "static rsc header 1" "${base}/static/1" -H "RSC: 1"
  if [ -f results/last-location.txt ]; then
    location=$(cat results/last-location.txt)
    case "$location" in
      http*) rsc_url=$location ;;
      /*) rsc_url="${base}${location}" ;;
      *) rsc_url="${base}/${location}" ;;
    esac
    request "static rsc redirect 1" "$rsc_url" -H "RSC: 1"
    request "static rsc redirect 2" "$rsc_url" -H "RSC: 1"
    rm -f results/last-location.txt
  fi
  request "static html after rsc" "${base}/static/1"
  request "static prefetch 1" "${base}/static/1" -H "RSC: 1" -H "Next-Router-Prefetch: 1"
  if [ -f results/last-location.txt ]; then
    location=$(cat results/last-location.txt)
    case "$location" in
      http*) rsc_url=$location ;;
      /*) rsc_url="${base}${location}" ;;
      *) rsc_url="${base}/${location}" ;;
    esac
    request "static prefetch redirect 1" "$rsc_url" -H "RSC: 1" -H "Next-Router-Prefetch: 1"
    request "static prefetch redirect 2" "$rsc_url" -H "RSC: 1" -H "Next-Router-Prefetch: 1"
    rm -f results/last-location.txt
  fi
  request "static html after prefetch" "${base}/static/1"
  request "static page 2 html 1" "${base}/static/2"
  request "static page 2 html 2" "${base}/static/2"
  request "static page 20 html 1" "${base}/static/20"
  request "static page 20 html 2" "${base}/static/20"
  request "dynamic html 1" "${base}/dynamic/1/1"
  request "dynamic html 2" "${base}/dynamic/1/1"
  request "dynamic rsc header 1" "${base}/dynamic/1/1" -H "RSC: 1"
  if [ -f results/last-location.txt ]; then
    location=$(cat results/last-location.txt)
    case "$location" in
      http*) rsc_url=$location ;;
      /*) rsc_url="${base}${location}" ;;
      *) rsc_url="${base}/${location}" ;;
    esac
    request "dynamic rsc redirect 1" "$rsc_url" -H "RSC: 1"
    request "dynamic rsc redirect 2" "$rsc_url" -H "RSC: 1"
    rm -f results/last-location.txt
  fi
  request "dynamic html after rsc" "${base}/dynamic/1/1"
  request "dynamic page 2 html 1" "${base}/dynamic/1/2"
  request "dynamic page 2 html 2" "${base}/dynamic/1/2"
  request "dynamic html after other page" "${base}/dynamic/1/1"
  request "dynamic kind 30 page 1000" "${base}/dynamic/30/1000"
  request "dynamic missing 1" "${base}/dynamic/30/1001"
  request "dynamic missing 2" "${base}/dynamic/30/1001"
  echo '```'
  echo
  echo "## varnishstat"
  echo
  echo '```text'
  docker compose exec -T varnish varnishstat -1 \
    -f MAIN.cache_hit \
    -f MAIN.cache_miss \
    -f MAIN.cache_hitpass \
    -f MAIN.n_object \
    -f MAIN.n_objectcore
  echo '```'
} >"$report"

sleep 1
kill "$log_pid" >/dev/null 2>&1 || true
wait "$log_pid" >/dev/null 2>&1 || true

echo "wrote ${report}"
cat "$report"

dynamic_second=$(awk '
  $0 == "dynamic html 2" { capture = 1 }
  capture && /x-cache:/ { print; exit }
' "$report")
dynamic_control=$(awk '
  $0 == "dynamic html 2" { capture = 1 }
  capture && /cache-control:/ { print; exit }
' "$report")

case "$dynamic_second" in
  *HIT*) ;;
  *)
    echo "dynamic HTML was not a cache hit on the second request" >&2
    exit 1
    ;;
esac

case "$dynamic_control" in
  *s-maxage*) ;;
  *)
    echo "dynamic HTML did not send s-maxage" >&2
    exit 1
    ;;
esac

dynamic_other=$(awk '
  $0 == "dynamic page 2 html 2" { capture = 1 }
  capture && /x-cache:/ { print; exit }
' "$report")
dynamic_kept=$(awk '
  $0 == "dynamic html after rsc" { capture = 1 }
  capture && /x-cache:/ { print; exit }
' "$report")

case "$dynamic_other" in
  *HIT*) ;;
  *)
    echo "a second dynamic URL was not a cache hit" >&2
    exit 1
    ;;
esac

case "$dynamic_kept" in
  *HIT*) ;;
  *)
    echo "dynamic HTML was replaced after the RSC request" >&2
    exit 1
    ;;
esac
