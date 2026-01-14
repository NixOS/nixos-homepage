import { defineConfig, envField } from 'astro/config';

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';
import icon from 'astro-icon';

// theme derived from https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/packages/tm-themes/themes/vesper.json
import syntaxTheme from './src/lib/shiki/theme.json';
import favicons from 'astro-favicons';

import { createRequire } from 'module';
import shellPromptTransformer from './src/lib/shiki/shellPromptTransformer';
const require = createRequire(import.meta.url);

function selectFavicon(theme = 'default') {
  switch (theme) {
    case 'pride':
      return require.resolve("@nixos/branding/artifacts/internal/nixos-logomark-rainbow-gradient-none.svg");
    default:
      return require.resolve("@nixos/branding/artifacts/internal/nixos-logomark-default-gradient-none.svg");
  }
}
// https://astro.build/config
export default defineConfig({
  output: 'static',
  site: 'https://nixos.org',
  integrations: [
    mdx(),
    sitemap(),
    icon({
      include: {
        mdi: ['*'],
        simpleIcons: ['*'],
      },
    }),
    favicons({
      input: {
        favicons: [selectFavicon(process.env.THEME)],
      },
      name: 'Nix & NixOS',
      short_name: 'Nix & NixOS',
      manifest: {
        start_url: '/',
      },
    }),
  ],
  markdown: {
    shikiConfig: {
      theme: syntaxTheme,
      transformers: [shellPromptTransformer],
    },
  },
  compressHTML: true,
  vite: {
    plugins: [tailwindcss()],
  },
  redirects: {
    '/values': '/governance',
    '/qr01': '/' // QR code on the NixOS banner
  },
  env: {
    schema: {
      THEME: envField.string({
        context: 'client',
        access: 'public',
        default: 'default',
      }),
      BANNER: envField.string({
        context: 'client',
        access: 'public',
        default: 'default',
      }),
    },
  },
});
