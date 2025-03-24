import { defineConfig, globalIgnores } from "eslint/config";
import globals from "globals";
import js from "@eslint/js";
import tseslint from "typescript-eslint";
import eslintPluginAstro from "eslint-plugin-astro";


export default defineConfig([
  { files: ["**/*.{js,mjs,cjs,ts}"] },
  { files: [
    "*.{js,mjs,cjs,ts}",
    "src/**/*.{js,mjs,cjs,ts}",
  ], languageOptions: { globals: globals.node } },
  { files: ["public/**/*.{js,mjs,cjs,ts}"], languageOptions: { globals: globals.browser } },
  { files: ["**/*.{js,mjs,cjs,ts}"], plugins: { js }, extends: ["js/recommended"] },
  tseslint.configs.base,
  eslintPluginAstro.configs.recommended,
  [globalIgnores([
    "public/bootstrap/**/*",
    '.astro/**/*',
  ])]
]);