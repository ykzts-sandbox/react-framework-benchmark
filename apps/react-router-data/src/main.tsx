import { createRoot } from "react-dom/client";
import { createBrowserRouter, RouterProvider } from "react-router";

import { routes } from "./routes";

const root = document.querySelector("#root");

if (root === null) {
  throw new Error("missing #root");
}

const router = createBrowserRouter(routes);

createRoot(root).render(<RouterProvider router={router} />);
