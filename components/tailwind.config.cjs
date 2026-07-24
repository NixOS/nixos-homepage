import { addDynamicIconSelectors } from '@iconify/tailwind';
import defaultTheme from 'tailwindcss/defaultTheme';
import colors from '@nixos/branding/colors/tailwind.js';

const shadow = {
  md: '0 8px 2px rgba(0,0,0,0.2)',
  DEFAULT: '0 4px 1px rgba(0,0,0,0.2)',
  inner: 'inset 0 0 1rem 0 rgba(0,0,0,0.1)',
  none: 'none',
};

/** @type {import('tailwindcss').Config} */
const preset = {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    fontFamily: {
      sans: ['Roboto Flex Variable', ...defaultTheme.fontFamily.sans],
      serif: ['Route159', ...defaultTheme.fontFamily.serif],
      heading: ['Route159', ...defaultTheme.fontFamily.sans],
      mono: ['Fira Code Variable', ...defaultTheme.fontFamily.mono],
    },
    colors: colors,
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
  plugins: [addDynamicIconSelectors()],
};

export default preset;
