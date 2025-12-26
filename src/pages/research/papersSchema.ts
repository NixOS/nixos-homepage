import { z } from 'astro:content';

export const authorSchema = z.object({
  name: z.string(),
  orcidUrl: z.string().url().optional(),
});

export const publicationInfoSchema = z.discriminatedUnion('type', [
  z.object({
    type: z.literal('conference'),
    conference: z.string(),
    location: z.string(),
    publisher: z.string().optional(),
    pages: z.string().optional(),
  }),
  z.object({
    type: z.literal('journal'),
    journal: z.string(),
    volume: z.string().optional(),
    number: z.string().optional(),
    publisher: z.string().optional(),
    pages: z.string().optional(),
  }),
  z.object({
    type: z.literal('thesis'),
    thesisType: z.enum(['PhD', "Master's", "Bachelor's", 'Diplomarbeit']),
    institution: z.string(),
    location: z.string(),
  }),
]);

export const paperSchema = z.object({
  title: z.string(),
  authors: z.array(authorSchema),
  year: z.number(),
  abstract: z.string().optional(),
  doiOrPublisherUrl: z.string().optional(),
  preprintOrArchiveUrl: z.string().optional(),
  bibtex: z.string().optional(),
  publicationInfo: publicationInfoSchema,
});

export const papersSchema = z.array(paperSchema);
