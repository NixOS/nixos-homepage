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

export function createExcerpt(post) {
  const parser = new MarkdownIt();
  return parser
    .render(post)
    .split('\n')
    .slice(0, 8)
    .map((str) => {
      return str
        .replace(/<h1.*?>(.*?)<\/h1>/g, '') // remove h1 tag
        .replace(/<h2.*?>(.*?)<\/h2>/g, '') // remove h2 tag
        .replace(/<h3.*?>(.*?)<\/h3>/g, '') // remove h3 tag
        .replace(/<\/?[^>]+(>|$)/g, '')
        .split('\n');
    })
    .flat()
    .join(' ');
}

export function getNixosLogosUrlUniversal(theme, prefix) {
  const assetPath = '/src/assets/image/';
  switch (theme) {
    case 'black':
      return {
        logo:
          prefix +
          assetPath +
          'nixos-logo-primary-black-flat-primary-black-regular-horizontal-none.svg',
        logomark:
          prefix + assetPath + 'nixos-logomark-primary-black-flat-none.svg',
      };
    case 'pride':
      return {
        logo:
          prefix +
          assetPath +
          'nixos-logo-rainbow-gradient-primary-black-regular-horizontal-none.svg',
        logomark:
          prefix + assetPath + 'nixos-logomark-rainbow-gradient-none.svg',
      };
    case 'white':
      return {
        logo:
          prefix +
          assetPath +
          'nixos-logo-white-flat-white-regular-horizontal-none.svg',
        logomark: prefix + assetPath + 'nixos-logomark-white-flat-none.svg',
      };
    default:
      return {
        logo:
          prefix +
          assetPath +
          'nixos-logo-default-gradient-black-regular-horizontal-none.svg',
        logomark:
          prefix + assetPath + 'nixos-logomark-default-gradient-none.svg',
      };
  }
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
    ? `Published on ${entry.data.date.toDateString()}`
    : null;
  const formattedAuthor = entry.data.authors
    ? entry.data.authors
        .map((author) => authorDiscourse(author, link, linkClass))
        .join(', ')
    : null;
  return [formattedDate, formattedAuthor].filter(Boolean).join(' - ');
}
