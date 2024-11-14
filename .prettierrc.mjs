/** @type {import("prettier").Config} */
export default {
  singleQuote: true,
  plugins: [
    'prettier-plugin-astro',
    'prettier-plugin-astro-organize-imports',
    'prettier-plugin-tailwindcss',
  ],
  overrides: [
    {
      files: '*.astro',
      options: {
        parser: 'astro',
      },
    },
  ],
};
