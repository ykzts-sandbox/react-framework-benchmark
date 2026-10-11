import type { ComponentType } from "react";
import type { RouteObject } from "react-router";

import Dynamic, { ErrorBoundary, loader } from "./routes/dynamic";
import Home from "./routes/home";

const pages = import.meta.glob<{ default: ComponentType }>(
  "./routes/static/*.tsx"
);

const fileId = (file: string) =>
  file.slice(file.lastIndexOf("/") + 1, -".tsx".length);

const staticRoutes: RouteObject[] = Object.entries(pages)
  .toSorted(([left], [right]) => Number(fileId(left)) - Number(fileId(right)))
  .map(([file, load]) => ({
    lazy: async () => {
      const module = await load();

      return { Component: module.default };
    },
    path: `static/${fileId(file)}`,
  }));

export const routes: RouteObject[] = [
  { Component: Home, path: "/" },
  ...staticRoutes,
  {
    Component: Dynamic,
    ErrorBoundary,
    loader,
    path: "dynamic/:id",
  },
];
