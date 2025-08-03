import { addDynamicIconSelectors } from '@iconify/tailwind';
import plugin from 'tailwindcss/plugin';
import fs from 'node:fs';
import path from 'node:path';
import parser from 'node-html-parser';
import svgo from 'svgo';
import colors from 'tailwindcss/colors';
import defaultTheme from 'tailwindcss/defaultTheme';

import nixColors from '../colors.json';

const nixColorsNew = [
  nixColors.palette.accent,
  nixColors.palette.primary,
  nixColors.palette.secondary,
]
  .flat()
  // convert to "name":  { DEFAULT: "#hex" } format
  .reduce((acc, color) => {
    const name = color.name.replace(/ /g, '-').toLowerCase();
    acc[name] = {
      DEFAULT: `oklch(${color.value[0]} ${color.value[1]} ${color.value[2]})`,
      ...Object.fromEntries(
        Object.entries(color.tints).map(([k, v]) => [
          k.slice(1), // remove the leading `-`
          `oklch(${v[0]} ${v[1]} ${v[2]})`,
        ]),
      ),
    };
    return acc;
  }, {});

console.log(nixColorsNew);

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
        100: '#e8effc',
        200: '#b7cefd',
        300: '#87adfa',
        400: '#698dd8',
        500: '#4d6fb7',
        600: '#325197',
        700: '#193578',
        800: '#03185a',
        900: '#00052c',
        'light-transparent': '#87adfa33',
        transparent: '#e8effc33',
        DEFAULT: '#4d6fb7', // nixdarkblue
      },
      'nix-orange': {
        100: '#faebe2',
        200: '#fdbe96',
        300: '#e99861',
        400: '#c77942',
        500: '#a65b21',
        600: '#834105',
        700: '#5a2d09',
        800: '#371802',
        900: '#150702',
        DEFAULT: '#e99861', // nixorange
        transparent: '#e9986133',
      },
      'nix-green': {
        100: '#e0f5e5',
        200: '#8fe5a7',
        300: '#6fc488',
        400: '#4fa46a',
        500: '#2e854d',
        600: '#126635',
        700: '#034721',
        800: '#042912',
        900: '#030f05',
        DEFAULT: '#2e854d', // nixgreen
        transparent: '#2e854d33',
      },
      gray: colors.gray,
      white: colors.white,
      black: colors.black,
      transparent: colors.transparent,
      ...nixColorsNew,
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
