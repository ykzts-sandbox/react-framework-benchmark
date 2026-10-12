import { defineConfig } from "oxfmt";
import ultracite from "ultracite/oxfmt";

export default defineConfig({
  ...ultracite,
  ignorePatterns: [
    ...ultracite.ignorePatterns,
    "**/devcontainer-lock.json",
    "apps/next/app/static/**",
    "apps/next/app/dynamic/**",
    "apps/next-pages/pages/static/**",
    "apps/next-pages/pages/dynamic/**",
    "apps/react-router/app/routes/static/**",
    "apps/react-router/app/routes/dynamic/**",
    "apps/react-router-data/src/routes/static/**",
    "apps/react-router-data/src/routes/dynamic/**",
    "apps/react-router-declarative/src/routes/static/**",
    "apps/react-router-declarative/src/routes/dynamic/**",
    "results/**",
    "backend/**",
  ],
});
