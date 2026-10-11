import { readdirSync } from "node:fs";

import { index, route } from "@react-router/dev/routes";
import type { RouteConfig } from "@react-router/dev/routes";

const staticDirectory = `${import.meta.dirname}/routes/static`;

const staticRoutes = readdirSync(staticDirectory)
  .filter((name) => name.endsWith(".tsx"))
  .map((name) => name.slice(0, -".tsx".length))
  .toSorted((left, right) => Number(left) - Number(right))
  .map((id) => route(`static/${id}`, `routes/static/${id}.tsx`));

export default [
  index("routes/home.tsx"),
  ...staticRoutes,
  route("dynamic/:id", "routes/dynamic.tsx"),
] satisfies RouteConfig;
