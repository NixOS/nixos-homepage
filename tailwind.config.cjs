const defaultTheme = require("tailwindcss/defaultTheme");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      colors: {
        "nixlighterblue": "#f2f8fd",
        "nixlightblue": "#7ebae4",
        "nixdarkblue": "#5277c3",
        "nixsemidarkblue": "#405D99",
        "nixdarkerblue": "#27385d",
        "nixorange": "#ffab0d",
        "nixdarkorange": "#ff8657",
        "nixgreen": "#6ad541"
      },
      fontFamily: {
        sans: ["Roboto", ...defaultTheme.fontFamily.sans],
        serif: ["Overpass", ...defaultTheme.fontFamily.serif],
        heading: ["Overpass", ...defaultTheme.fontFamily.serif],
        mono: ["Fira\\ Mono", ...defaultTheme.fontFamily.mono],
        nixos: ["Vegur"],
      },
      borderWidth: {
        '0.5': '0.5px',
        '1': '1px'
      },
      listStyleType: {
        "circle": "circle",
      },
    },
    container: {
      // https://tailwindcss.com/docs/container#centering-by-default
      center: true,
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require("daisyui"),
  ],
  daisyui: {
    themes: [], // Disable all themes for the current time being
  },
}
