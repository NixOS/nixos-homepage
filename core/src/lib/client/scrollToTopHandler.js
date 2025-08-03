const scrollTop = document.getElementById('scroll-to-top');
scrollTop.classList.add('opacity-0');

document.addEventListener('scroll', () => {
  const scrollPosition = window.scrollY;
  const scrollPositionBottom = scrollPosition + window.innerHeight;
  if (scrollPositionBottom > document.body.offsetHeight - 10) {
    scrollTop.classList.remove(
      'bottom-4',
      'md:bottom-8',
      'md:-right-14',
      'right-4',
      'bg-afghani-blue-15',
    );
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
    scrollTop.classList.add(
      'bottom-4',
      'md:bottom-8',
      'md:-right-14',
      'right-4',
      'bg-afghani-blue-15',
    );
  }

  if (scrollPosition > 100) {
    scrollTop.classList.remove('opacity-0');
  } else {
    scrollTop.classList.add('opacity-0');
  }
});
