#!/bin/sh
# Push local images to a temporary registry and print each pull size.
# The size is the platform manifest's config blob plus its layer blobs.
# Attestation manifests are not included. This is not `docker save | gzip`.
set -eu

if [ "$#" -lt 1 ]; then
  echo "usage: measure-compressed.sh <image>..." >&2
  exit 1
fi

root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
port=${REGISTRY_PORT:-5000}
container=${REGISTRY_CONTAINER:-react-framework-benchmark-registry}
registry_image=${REGISTRY_IMAGE:-registry:2}
registry="http://127.0.0.1:${port}"
media_file=$(mktemp)

cleanup() {
  docker rm -f "$container" >/dev/null 2>&1 || true
  rm -f "$media_file"
}

trap cleanup EXIT

if curl -fsS "${registry}/v2/" >/dev/null 2>&1; then
  echo "port ${port} is already in use" >&2
  exit 1
fi

docker pull "$registry_image" >&2
registry_digest=$(docker image inspect --format '{{index .RepoDigests 0}}' "$registry_image")
printf 'registry=%s\n' "$registry_digest"

docker run -d --name "$container" -p "127.0.0.1:${port}:5000" "$registry_image" >&2

ready=0
attempt=0
while [ "$attempt" -lt 40 ]; do
  if curl -fsS "${registry}/v2/" >/dev/null 2>&1; then
    ready=1
    break
  fi
  attempt=$((attempt + 1))
  sleep 0.5
done

if [ "$ready" -ne 1 ]; then
  echo "registry did not start" >&2
  exit 1
fi

for image in "$@"; do
  repository=$(printf '%s' "$image" | tr '[:upper:]' '[:lower:]' | tr ':/' '--')
  destination="127.0.0.1:${port}/${repository}:measured"
  docker tag "$image" "$destination"
  docker push "$destination" >&2
  note=$(mktemp)
  if ! bytes=$(node "$root/scripts/registry-size.mjs" "$registry" "$repository" measured 2>"$note"); then
    cat "$note" >&2
    rm -f "$note"
    docker rmi "$destination" >/dev/null 2>&1 || true
    exit 1
  fi
  cat "$note" >&2
  awk '/^compressed-media / { print substr($0, index($0, " ") + 1) }' "$note" >>"$media_file"
  rm -f "$note"
  docker rmi "$destination" >/dev/null 2>&1 || true
  printf '%s %s\n' "$image" "$bytes"
  echo "compressed ${image} ${bytes}" >&2
done

media_types=$(sort -u "$media_file" | awk 'BEGIN { first = 1 } { if (!first) printf ","; printf "%s", $0; first = 0 } END { printf "\n" }')
printf 'media-types=%s\n' "$media_types"
