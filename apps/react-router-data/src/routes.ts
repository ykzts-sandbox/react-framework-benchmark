import type { ComponentType } from "react";
import type { LoaderFunction, RouteObject } from "react-router";

import Home from "./routes/home";

const pages = import.meta.glob<{ default: ComponentType }>(
  "./routes/static/*.tsx"
);

const dynamicPages = import.meta.glob<{
  default: ComponentType;
  ErrorBoundary: ComponentType;
  loader: LoaderFunction;
}>("./routes/dynamic/*.tsx");

const fileId = (file: string) =>
  file.slice(file.lastIndexOf("/") + 1, -".tsx".length);

const byFileId = ([left]: [string, unknown], [right]: [string, unknown]) =>
  Number(fileId(left)) - Number(fileId(right));

const staticRoutes: RouteObject[] = Object.entries(pages)
  .toSorted(byFileId)
  .map(([file, load]) => ({
    lazy: async () => {
      const module = await load();

      return { Component: module.default };
    },
    path: `static/${fileId(file)}`,
  }));

const dynamicRoutes: RouteObject[] = Object.entries(dynamicPages)
  .toSorted(byFileId)
  .map(([file, load]) => ({
    lazy: async () => {
      const module = await load();

      return {
        Component: module.default,
        ErrorBoundary: module.ErrorBoundary,
        loader: module.loader,
      };
    },
    path: `dynamic/${fileId(file)}/:id`,
  }));

export const routes: RouteObject[] = [
  { Component: Home, path: "/" },
  ...staticRoutes,
  ...dynamicRoutes,
];
