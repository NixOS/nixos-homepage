import plugin from 'tailwindcss/plugin';
import fs from 'node:fs';
import path from 'node:path';
import parser from 'node-html-parser';
import svgo from 'svgo';
import nixosUiPreset from '@nixos/ui/tailwind';

const inlineSvgs = {
  hero: './src/assets/image/hero-bg.svg',
  'landing-search-top': './src/assets/image/divider/landing_search_top.svg',
  'header-nixdarkblue': './src/assets/image/divider/header_nixdarkblue.svg',
  'why-nix-bg-usecases': './src/assets/image/why-nix/usecase-bg.svg'
};

function inlineSvg({ svg }) {
  const filePath = path.resolve(__dirname, svg);
  const file = fs.readFileSync(filePath, 'utf8');
  const stringified = parser.parse(file).toString();

  const optimized = svgo.optimize(stringified, {
    multipass: true,
    plugins: [
      {
        name: 'preset-default',
        params: {
          overrides: {
            removeViewBox: false,
            cleanupIds: false,
          },
        },
      },
    ],
  });

  const base64 = Buffer.from(optimized.data).toString('base64');

  return 'data:image/svg+xml;base64,' + base64;
}

/** @type {import('tailwindcss').Config} */
module.exports = {
  presets: [nixosUiPreset],
  content: [
    './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}',
    '../components/src/**/*.{astro,ts}',
    './node_modules/asciinema-player/**/*.js',
  ],
  plugins: [
    plugin(function ({ addUtilities }) {
      let res = {};

      for (const [key, value] of Object.entries(inlineSvgs)) {
        res[`.inline-svg-${key}`] = {
          'background-image': `url(${inlineSvg({ svg: value })})`,
        };
      }

      addUtilities(res);
    }),
  ],
};
