import { lazy, Suspense } from "react";
import type { ComponentType } from "react";
import { Route, Routes } from "react-router";

import Home from "./routes/home";

const pages = import.meta.glob<{ default: ComponentType }>(
  "./routes/static/*.tsx"
);

const dynamicPages = import.meta.glob<{ default: ComponentType }>(
  "./routes/dynamic/*.tsx"
);

const fileId = (file: string) =>
  file.slice(file.lastIndexOf("/") + 1, -".tsx".length);

const lazyRoutes = (
  modules: Record<string, () => Promise<{ default: ComponentType }>>
) =>
  Object.entries(modules)
    .toSorted(([left], [right]) => Number(fileId(left)) - Number(fileId(right)))
    .map(([file, load]) => ({
      Component: lazy(load),
      id: fileId(file),
    }));

const staticPages = lazyRoutes(pages);
const dynamicKinds = lazyRoutes(dynamicPages);

const App = () => (
  <Suspense fallback={null}>
    <Routes>
      <Route element={<Home />} path="/" />
      {staticPages.map(({ Component, id }) => (
        <Route element={<Component />} key={id} path={`static/${id}`} />
      ))}
      {dynamicKinds.map(({ Component, id }) => (
        <Route element={<Component />} key={id} path={`dynamic/${id}/:id`} />
      ))}
    </Routes>
  </Suspense>
);

export default App;
