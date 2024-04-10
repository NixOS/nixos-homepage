const { addDynamicIconSelectors } = require('@iconify/tailwind');
const plugin = require('tailwindcss/plugin')
const fs = require('node:fs');
const parser = require('node-html-parser');
const svgo = require('svgo');

const defaultTheme = require("tailwindcss/defaultTheme");

const inlineSvgs = {
  'hero': './src/assets/image/hero-bg.svg',
  'landing-search-top': './src/assets/image/divider/landing_search_top.svg',
  'header-nixdarkblue': './src/assets/image/divider/header_nixdarkblue.svg',
}

function inlineSvg({ svg }) {
  // load file
  const file = fs.readFileSync(svg, "utf8");
  const stringified = parser.parse(file).toString();
  const optimized = svgo.optimize(stringified, {
    multipass: true,
    plugins: [
      {
        name: "preset-default",
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
  return "data:image/svg+xml;base64," + base64;
}

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}",
    "./node_modules/asciinema-player/**/*.js"
  ],
  theme: {
    extend: {
      colors: {
        "nixlighterblue": "#f2f8fd",
        "nixlighterblue-dimmed": "#e6ecf5",
        "nixlightblue": "#7ebae4",
        "nixdarkblue": "#5277c3",
        "nixsemidarkblue": "#405D99",
        "nixdarkerblue": "#27385d",
        "nixlightorange": "#fff5e1",
        "nixorange": "#ffab0d",
        "nixdarkorange": "#ff8657",
        "nixdarkerorange": "#cc3900",
        "nixgreen": "#6ad541",
        "nixdarkgreen": "#51ba29",
      },
      fontFamily: {
        sans: ["Roboto Flex Variable", ...defaultTheme.fontFamily.sans],
        serif: ["Overpass Variable", ...defaultTheme.fontFamily.serif],
        heading: ["Overpass Variable", ...defaultTheme.fontFamily.sans],
        mono: ["Fira Code Variable", ...defaultTheme.fontFamily.mono],
      },
      borderWidth: {
        '0.5': '0.5px',
        '1': '1px'
      },
      listStyleType: {
        "circle": "circle",
      },
      fontSize: {
        base: '1rem',
        lg: '1.2rem',
        xl: '1.4rem',
        '2xl': '1.625rem',
        '3xl': '1.953rem',
        '4xl': '2.441rem',
        '5xl': '3.052rem',
      },
      textDecorationThickness: {
        '0.5': '0.5px'
      },
      backgroundSize: {
        'divider': 'auto 100%',
      },
    },
    screens: {
      'sm': '480px',
      'md': '768px',
      'lg': '992px',
      'xl': '1200px',
    },
    fontSize: {
      'xs': '0.75rem',
      'sm': '0.875rem',
      'base': '1rem',
      'lg': '1.125rem',
      'xl': '1.3-rem',
      '2xl': '1.4rem',
      '3xl': '1.5rem',
      '4xl': '2rem',
      '5xl': '2.5rem',
    },
    container: {
      // https://tailwindcss.com/docs/container#centering-by-default
      center: true,
    },
  },
  plugins: [
    addDynamicIconSelectors(),
    plugin(function({ addUtilities }) {
      res = {}

      for (const [key, value] of Object.entries(inlineSvgs)) {
        res[`.inline-svg-${key}`] = {
          'background-image': `url(${inlineSvg({ svg: value })})`,
        }
      }

      addUtilities(res)
    })
  ],
  daisyui: {
    themes: false,
    darkTheme: false,
    base: false,
  },
}
