const scrollTop = document.getElementById('scroll-to-top');
scrollTop.classList.add('opacity-0');

document.addEventListener('scroll', () => {
  const scrollPosition = window.scrollY;
  const scrollPositionBottom = scrollPosition + window.innerHeight;
  if (scrollPositionBottom > document.body.offsetHeight - 10) {
    scrollTop.classList.remove('bottom-8', '-right-14', 'bg-nix-blue-darker');
    scrollTop.classList.add(
      'md:bottom-4',
      'right-1/2',
      'translate-x-1/2',
      'bottom-0',
    );
  } else {
    scrollTop.classList.remove(
      'md:bottom-4',
      'right-1/2',
      'translate-x-1/2',
      'bottom-0',
    );
    scrollTop.classList.add('bottom-8', '-right-14', 'bg-nix-blue-darker');
  }

  if (scrollPosition > 100) {
    scrollTop.classList.remove('opacity-0');
  } else {
    scrollTop.classList.add('opacity-0');
  }
});
