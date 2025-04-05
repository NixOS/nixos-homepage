import { defineConfig, envField } from "astro/config";

import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";
import tailwindcss from "@tailwindcss/vite";
import icon from "astro-icon";

// theme derivated from https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/packages/tm-themes/themes/vesper.json
import syntaxTheme from "./src/lib/shiki/theme.json";
import favicons from "astro-favicons";
import { getNixLogoUrlUniversal } from "./src/lib/utils.js";

// https://astro.build/config
export default defineConfig({
  output: "static",
  site: "https://nixos.org",
  integrations: [mdx(), sitemap(), icon({
    include: {
      mdi: ["*"],
      simpleIcons: ["*"],
    },
  }), favicons({
    input: {
      favicons: [
        getNixLogoUrlUniversal(process.env.THEME, '.')
      ],
    },
    name: "Nix & NixOS",
    short_name: "Nix & NixOS",
    manifest: {
      start_url: "/",
    }
  })],
  markdown: {
    shikiConfig: {
      theme: syntaxTheme,
    },
  },
  compressHTML: true,
  vite: {
    plugins: [tailwindcss()],
  },
  env: {
    schema: {
      THEME: envField.string({ context: "client", access: "public", default: "default" }),
      BANNER: envField.string({ context: "client", access: "public", default: "default" }),
    },
  },
});