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
      return str.replace(/<\/?[^>]+(>|$)/g, '').split('\n');
    })
    .flat()
    .join(' ');
}
