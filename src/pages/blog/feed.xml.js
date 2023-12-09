import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from 'sanitize-html';
import MarkdownIt from 'markdown-it';
import { generatePathFromPost } from "../../lib/utils";
const parser = new MarkdownIt();

export async function GET(context) {
  const blog = await getCollection("blog");
  blog.sort((a, b) => {
    const dateA = new Date(a.data.date);
    const dateB = new Date(b.data.date);
    return dateA > dateB ? -1 : 1;
  });
  console.log(blog);
  return rss({
    title: "NixOS Blog",
    site: context.site,
    description: "NixOS Blog",
    items: blog.map((post) => ({
      title: post.data.title ?? "Untitled",
      pubDate: post.data.date ?? new Date().toISOString(),
      content: sanitizeHtml(parser.render(post.body)),
      link: generatePathFromPost(post),
    })),
    customData: `<language>en-us</language>`,
  });
}
