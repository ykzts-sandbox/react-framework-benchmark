import { lazy, Suspense } from "react";
import type { ComponentType } from "react";
import { Route, Routes } from "react-router";

import Dynamic from "./routes/dynamic";
import Home from "./routes/home";

const pages = import.meta.glob<{ default: ComponentType }>(
  "./routes/static/*.tsx"
);

const fileId = (file: string) =>
  file.slice(file.lastIndexOf("/") + 1, -".tsx".length);

const staticPages = Object.entries(pages)
  .toSorted(([left], [right]) => Number(fileId(left)) - Number(fileId(right)))
  .map(([file, load]) => ({
    Component: lazy(load),
    id: fileId(file),
  }));

const App = () => (
  <Suspense fallback={null}>
    <Routes>
      <Route element={<Home />} path="/" />
      {staticPages.map(({ Component, id }) => (
        <Route element={<Component />} key={id} path={`static/${id}`} />
      ))}
      <Route element={<Dynamic />} path="dynamic/:id" />
    </Routes>
  </Suspense>
);

export default App;
