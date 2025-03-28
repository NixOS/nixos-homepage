import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/blog' }),
});

const community = defineCollection({
  loader: glob({ pattern: '**/[^_]*.yaml', base: './src/content/community' }),
});

const download = defineCollection({
  loader: glob({
    pattern: '**/[^_]*.{md,mdx}',
    base: './src/content/download',
  }),
});

const explore = defineCollection({
  loader: glob({ pattern: '**/[^_]*.yaml', base: './src/content/explore' }),
});

const landing = defineCollection({
  loader: glob({ pattern: '**/[^_]*.yaml', base: './src/content/landing' }),
});

const landingFeatures = defineCollection({
  loader: glob({
    pattern: '**/[^_]*.{md,mdx}',
    base: './src/content/landing-features',
  }),
});

const learningManuals = defineCollection({
  loader: glob({
    pattern: '**/[^_]*.{md,mdx}',
    base: './src/content/learning-manuals',
  }),
});

const menus = defineCollection({
  loader: glob({ pattern: '**/[^_]*.yaml', base: './src/content/menus' }),
});

// TODO get `research` from astro collection instead of hardcoded json

const sponsors = defineCollection({
  loader: glob({ pattern: '**/[^_]*.yaml', base: './src/content/sponsors' }),
});

const teams = defineCollection({
  loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/teams' }),
});

export const collections = {
  blog,
  community,
  download,
  explore,
  landing,
  landingFeatures,
  learningManuals,
  menus,
  sponsors,
  teams,
};
