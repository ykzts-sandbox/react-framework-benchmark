import { readdirSync } from "node:fs";

import { index, route } from "@react-router/dev/routes";
import type { RouteConfig } from "@react-router/dev/routes";

const generatedIds = (directory: string) =>
  readdirSync(`${import.meta.dirname}/routes/${directory}`)
    .filter((name) => name.endsWith(".tsx"))
    .map((name) => name.slice(0, -".tsx".length))
    .toSorted((left, right) => Number(left) - Number(right));

const staticRoutes = generatedIds("static").map((id) =>
  route(`static/${id}`, `routes/static/${id}.tsx`)
);

const dynamicRoutes = generatedIds("dynamic").map((kind) =>
  route(`dynamic/${kind}/:id`, `routes/dynamic/${kind}.tsx`)
);

export default [
  index("routes/home.tsx"),
  ...staticRoutes,
  ...dynamicRoutes,
] satisfies RouteConfig;
