import { defineConfig } from 'astro/config';

import mdx from "@astrojs/mdx";
import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import icon from "astro-icon";

// theme derivated from https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/packages/tm-themes/themes/vesper.json
import syntaxTheme from "./src/lib/shiki/theme.json"

// https://astro.build/config
export default defineConfig({
  output: 'static',
  site: 'https://nixos.org',
  integrations: [
    tailwind(),
    mdx(),
    sitemap(),
    icon({
      include: {
        mdi: ['*'],
        simpleIcons: ['*'],
      }
    }),
  ],
  markdown: {
    shikiConfig: {
      theme: syntaxTheme,
    },
  },
  compressHTML: true,
});
