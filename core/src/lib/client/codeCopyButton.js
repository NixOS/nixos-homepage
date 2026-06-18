for (const pre of document.querySelectorAll('pre.astro-code')) {
  const wrapper = document.createElement('div');

  wrapper.classList.add('relative', 'flex', 'justify-stretch', 'items-stretch');

  pre.parentNode.insertBefore(wrapper, pre);
  pre.classList.add('flex-1');

  wrapper.appendChild(pre);

  const header = document.createElement('div');
  wrapper.appendChild(header);

  const copyButton = document.createElement('button');

  const copyButtonIcon = document.createElement('span');
  copyButtonIcon.classList.add(
    'w-5',
    'h-5',
    'iconify',
    'icon-[mdi--content-copy]',
  );
  copyButton.appendChild(copyButtonIcon);

  const copyButtonText = document.createElement('span');
  copyButtonText.classList.add();
  copyButton.appendChild(copyButtonText);

  copyButton.classList.add('cursor-pointer', 'text-white', 'h-full');
  header.appendChild(copyButton);

  header.classList.add('bg-secondary-afghani-blue-45', 'text-primary-white');

  const isMultiLine = pre.querySelectorAll('.line').length > 1;

  if (isMultiLine) {
    pre.classList.add('rounded-b-none!', 'mb-0');
    wrapper.classList.add('flex-col', 'mb-4');

    copyButton.classList.add(
      'rounded-2xl',
      'flex',
      'items-center',
      'justify-center',
      'gap-2',
      'px-2',
    );

    copyButtonText.innerText = 'Copy';
    copyButtonText.classList.add('mt');

    header.classList.add(
      'flex',
      'items-center',
      'justify-end',
      'min-h-max',
      'px-2',
      'pt-2',
      'pb-2.5',
      '-mt-1',
      'rounded-b-2xl',
    );
  } else {
    pre.classList.add('rounded-r-none!');

    copyButton.classList.add('rounded-r-2xl', 'w-full', 'px-4');

    copyButtonIcon.classList.add('mt-1.5');

    header.classList.add('min-h-max', 'mt-2', 'mb-4', 'rounded-r-2xl');
  }

  copyButton.addEventListener('click', () => {
    let code = pre.querySelector('code')?.cloneNode(true);
    if (!code) return;

    for (const child of code.querySelectorAll('span')) {
      if (child.style.userSelect === 'none') {
        child.remove();
      }
    }

    navigator.clipboard.writeText(code.innerText.trim()).then(() => {
      copyButton.classList.add('bg-accent-zambian-green-55!');
      copyButtonIcon.classList.remove('icon-[mdi--content-copy]');
      copyButtonIcon.classList.add('icon-[mdi--check]');

      if (isMultiLine) {
        copyButtonText.innerText = 'Copied!';
      }

      setTimeout(() => {
        copyButton.classList.remove('bg-accent-zambian-green-55!');
        copyButtonIcon.classList.add('icon-[mdi--content-copy]');
        copyButtonIcon.classList.remove('icon-[mdi--check]');

        if (isMultiLine) {
          copyButtonText.innerText = 'Copy';
        }
      }, 2000);
    });
  });
}
