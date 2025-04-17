import { defineConfig, globalIgnores } from "eslint/config";
import globals from "globals";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import eslintPluginAstro from "eslint-plugin-astro";

export default defineConfig([
  { files: ["**/*.{js,mjs,cjs,ts}"] },
  { files: [
    "core/*.{js,mjs,cjs,ts}",
    "core/src/**/*.{js,mjs,cjs,ts}",
  ], languageOptions: { globals: globals.node } },
  { files: [
    "core/public/**/*.{js,mjs,cjs,ts}",
    "core/src/lib/client/**/*.{js,mjs,cjs,ts}",
  ], languageOptions: { globals: globals.browser } },
  { files: ["**/*.{js,mjs,cjs,ts}"], plugins: { js }, extends: ["js/recommended"] },
  tseslint.configs.base,
  eslintPluginAstro.configs.recommended,
  [globalIgnores([
    'core/dist/**/*',
    'core/public/bootstrap/**/*',
    'core/public/manual/**/*',
    'core/public/guides/**/*',
    'core/.astro/**/*',
    'build/**/*',
  ])]
]);