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
        heading: ["Overpass Variable", ...defaultTheme.fontFamily.serif],
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
      }
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
    require("daisyui"),
  ],
  daisyui: {
    // Disable all themes for the current time being
    themes: false,
    darkTheme: false,
    base: false,
  },
}
