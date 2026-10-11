import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router";

import App from "./app";

const root = document.querySelector("#root");

if (root === null) {
  throw new Error("missing #root");
}

createRoot(root).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>
);
