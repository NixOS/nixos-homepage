import MarkdownIt from 'markdown-it';

export function generatePathFromPost(post, attachBlog = true) {
  const postDate = new Date(post.data.date);
  return `/${attachBlog ? 'blog/' : ''}${
    post.id.split('/')[0] +
    '/' +
    postDate.getFullYear() +
    '/' +
    post.id.split('/').pop().split('_').pop()
  }`;
}

export function createExcerpt(post, maxLength = 500) {
  const parser = new MarkdownIt();
  const text = parser
    .render(post)
    .replace(/<h[1-3][^>]*>[\s\S]*?<\/h[1-3]>/g, ' ') // drop headings incl. multiline
    .replace(/<\/?[^>]+(>|$)/g, '')
    .replace(/\s+/g, ' ')
    .trim();

  if (text.length <= maxLength) return text;

  const cut = text.slice(0, maxLength + 1);
  const boundary = cut.lastIndexOf(' ');
  const trimmed = (boundary > 0 ? cut.slice(0, boundary) : cut).replace(
    /[,.;:\-\s]+$/,
    '',
  );
  return `${trimmed}…`;
}

function authorDiscourse(author, link, linkClass) {
  if (!author.name) return null;
  if (!author.discourse) return author.name;
  if (link)
    return `<a class="${linkClass}" target="blank" rel="noopener noreferrer" href="https://discourse.nixos.org/u/${author.discourse}">${author.name} (${author.discourse})</a>`;
  return `${author.name} (${author.discourse})`;
}

export function createAuthorListRSS(authors) {
  return authors
    ? authors.map((author) => authorDiscourse(author, false, null)).join(', ')
    : 'NixOS';
}

export function createBlogSubheader(entry, link, linkClass) {
  if (!entry.data) {
    return null;
  }
  const formattedDate = entry.data.date
    ? `${entry.data.date.toDateString()}`
    : null;
  const formattedAuthor = entry.data.authors
    ? entry.data.authors
        .map((author) => authorDiscourse(author, link, linkClass))
        .join(', ')
    : null;
  return [formattedDate, formattedAuthor].filter(Boolean).join(' - ');
}
