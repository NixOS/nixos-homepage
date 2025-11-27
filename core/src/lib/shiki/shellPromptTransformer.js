export default {
  name: 'prepend-shell-dollar-sign',
  line(node) {
    const isZsh =
      this.options.lang === 'bash' ||
      this.options.lang === 'sh' ||
      this.options.lang === 'zsh';
    const isPrompt =
      this.options.meta &&
      this.options.meta.__raw.split(' ').includes('prompt');

    if (isZsh && isPrompt) {
      let idx = 0;

      while (idx < node.children.length) {
        const promptEnd = node.children[idx].children.find(
          (child) => child.value.includes('$') || child.value.includes('>'),
        );

        node.children[idx].properties.style =
          'user-select: none;' + node.children[idx].properties.style;

        if (promptEnd) {
          if (!node.children[idx].children[0].value.endsWith(' ')) {
            node.children[idx].children[0].value += ' ';
          }
          node.children[idx + 1].children[0].value = node.children[
            idx + 1
          ].children[0].value.replace(' ', '');
          break;
        }

        idx += 1;
      }
    }
  },
};
