const [registry, repository, reference] = process.argv.slice(2);

if (
  registry === undefined ||
  repository === undefined ||
  reference === undefined
) {
  console.error("usage: registry-size.mjs <registry> <repository> <reference>");
  process.exit(1);
}

const accept = [
  "application/vnd.oci.image.index.v1+json",
  "application/vnd.docker.distribution.manifest.list.v2+json",
  "application/vnd.oci.image.manifest.v1+json",
  "application/vnd.docker.distribution.manifest.v2+json",
].join(", ");

const dockerArchitecture = () => {
  if (process.arch === "x64") {
    return "amd64";
  }

  return process.arch;
};

const manifestDocument = async (ref) => {
  const response = await fetch(
    `${registry}/v2/${repository}/manifests/${ref}`,
    { headers: { Accept: accept } }
  );

  if (!response.ok) {
    throw new Error(
      `manifest ${repository}:${ref} returned ${response.status}`
    );
  }

  return response.json();
};

const isIndex = (document) => {
  const mediaType = document.mediaType ?? "";

  return (
    mediaType.endsWith("image.index.v1+json") ||
    mediaType.endsWith("manifest.list.v2+json") ||
    Array.isArray(document.manifests)
  );
};

const platformManifest = (document) => {
  const architecture = dockerArchitecture();
  const manifests = document.manifests.filter((item) => {
    const annotations = item.annotations ?? {};
    const referenceType = annotations["vnd.docker.reference.type"];

    return (
      referenceType !== "attestation-manifest" &&
      item.platform?.architecture === architecture &&
      item.platform?.os === "linux"
    );
  });

  if (manifests.length !== 1) {
    throw new Error(
      `expected one linux/${architecture} manifest, found ${manifests.length}`
    );
  }

  return manifests[0].digest;
};

let document = await manifestDocument(reference);

if (isIndex(document)) {
  document = await manifestDocument(platformManifest(document));
}

const layers = document.layers ?? [];
const mediaTypes = [
  ...new Set(layers.map((layer) => layer.mediaType)),
].toSorted();
const size =
  (document.config?.size ?? 0) +
  layers.reduce((sum, layer) => sum + layer.size, 0);

console.error(`compressed-media ${mediaTypes.join(",")}`);

for (const layer of layers) {
  console.error(
    `compressed-layer ${layer.digest} ${layer.size} ${layer.mediaType}`
  );
}

console.error(
  `compressed-config ${document.config?.digest ?? ""} ${document.config?.size ?? 0}`
);
process.stdout.write(`${size}\n`);
