import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";

export function generatePathFromPost(post) {
  return `/blog/${
    post.slug.split("/")[0] + "/" + post.slug.split("/").pop().split("_").pop()
  }`;
}

export function createExcerpt(post) {
  const parser = new MarkdownIt();
  return parser.render(post)
    .split('\n')
    .slice(0, 8)
    .map((str) => {
        return str.replace(/<\/?[^>]+(>|$)/g, '').split('\n');
    })
    .flat()
    .join(' ');
}
