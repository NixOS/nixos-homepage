import { addDynamicIconSelectors } from '@iconify/tailwind';
import plugin from 'tailwindcss/plugin';
import fs from 'node:fs';
import path from 'node:path';
import parser from 'node-html-parser';
import svgo from 'svgo';
import colors from 'tailwindcss/colors';
import defaultTheme from 'tailwindcss/defaultTheme';

const inlineSvgs = {
  hero: './src/assets/image/hero-bg.svg',
  'landing-search-top': './src/assets/image/divider/landing_search_top.svg',
  'header-nixdarkblue': './src/assets/image/divider/header_nixdarkblue.svg',
};

const shadow = {
  md: '0 8px 2px rgba(0,0,0,0.2)',
  DEFAULT: '0 4px 1px rgba(0,0,0,0.2)',
  inner: 'inset 0 0 1rem 0 rgba(0,0,0,0.1)',
  none: 'none',
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
  content: [
    './src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}',
    './node_modules/asciinema-player/**/*.js',
  ],
  theme: {
    fontFamily: {
      sans: ['Roboto Flex Variable', ...defaultTheme.fontFamily.sans],
      serif: ['Overpass Variable', ...defaultTheme.fontFamily.serif],
      heading: ['Overpass Variable', ...defaultTheme.fontFamily.sans],
      mono: ['Fira Code Variable', ...defaultTheme.fontFamily.mono],
    },
    colors: {
      'nix-blue': {
        extralight: '#f2f8fd', // nixlighterblue
        lighter: '#e6ecf5', // nixlighterblue-dimmed
        light: '#7ebae4', // nixlightblue
        'light-hover': '#69a6d1',
        DEFAULT: '#5277c3', // nixdarkblue
        hover: '#466cb9',
        dark: '#405D99', // nixsemidarkblue
        'dark-hover': '#4e73bc',
        darker: '#27385d', // nixdarkerblue
      },
      'nix-orange': {
        lighter: '#fff5e1', // nixlightorange
        DEFAULT: '#ffab0d', // nixorange
        hover: '#ec9d0c',
        dark: '#ff8657', // nixdarkorange
        darker: '#cc3900', // nixdarkerorange
      },
      'nix-green': {
        DEFAULT: '#6ad541', // nixgreen
        hover: '#64c53d',
        dark: '#51ba29', // nixdarkgreen
      },
      gray: colors.gray,
      white: colors.white,
      black: colors.black,
      transparent: colors.transparent,
    },
    boxShadow: shadow,
    dropShadow: shadow,
    extend: {
      borderWidth: {
        0.5: '0.5px',
        1: '1px',
      },
      listStyleType: {
        circle: 'circle',
      },
      textDecorationThickness: {
        0.5: '0.5px',
      },
      backgroundSize: {
        divider: 'auto 100%',
      },
    },
    screens: {
      sm: '480px',
      md: '768px',
      lg: '992px',
      xl: '1200px',
    },
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.2rem',
      xl: '1.4rem',
      '2xl': '1.625rem',
      '3xl': '1.953rem',
      '4xl': '2.441rem',
      '5xl': '3.052rem',
    },
    container: {
      center: true,
    },
  },
  plugins: [
    addDynamicIconSelectors(),
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
