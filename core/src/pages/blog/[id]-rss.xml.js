import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import sanitizeHtml from 'sanitize-html';
import MarkdownIt from 'markdown-it';
import { getEntry } from 'astro:content';
import { generatePathFromPost } from '../../lib/utils';
const parser = new MarkdownIt();
const blogMenu = await getEntry('menus', 'blog');

export function getStaticPaths() {
  return blogMenu.data.map((e) => {
    return { params: { id: e.id } };
  });
}

export async function GET(context) {
  const blog = await getCollection('blog');
  const title =
    context.params.id.charAt(0).toUpperCase() + context.params.id.slice(1);
  const numOfPosts = 10;
  const posts = blog
    .sort((a, b) => {
      const dateA = new Date(a.data.date);
      const dateB = new Date(b.data.date);
      return dateA > dateB ? -1 : 1;
    })
    .filter((e) => {
      return e.data.category === context.params.id;
    });
  return rss({
    title: `NixOS ${title}`,
    site: `${context.site}/blog`,
    description: `${title} on NixOS, the purely functional Linux distribution.`,
    items: posts.slice(0, numOfPosts).map((post) => ({
      title: post.data.title ?? 'Untitled',
      pubDate: post.data.date ?? new Date().toISOString(),
      content: sanitizeHtml(parser.render(post.body)),
      link: generatePathFromPost(post),
    })),
    customData: `
      <language>en-us</language>
      <fh:complete xmlns:fh="http://purl.org/syndication/history/1.0"/>
      <image>
        <title>NixOS ${title}</title>
        <url>https://nixos.org/logo/nixos-logo-only-hires.png</url>
        <link>${context.site}/blog</link>
      </image>
    `,
  });
}
