const defaultTheme = require("tailwindcss/defaultTheme");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      colors: {
        "nixlightblue": "#7ebae4",
        "nixdarkblue": "#5277c3",
        "nixdarkerblue": "#27385d",
      },
      fontFamily: {
        sans: ["Roboto", ...defaultTheme.fontFamily.sans],
        serif: ["Overpass", ...defaultTheme.fontFamily.serif],
        mono: ["Fira\\ Mono", ...defaultTheme.fontFamily.mono],
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
}
