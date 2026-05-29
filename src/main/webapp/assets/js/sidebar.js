(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var nav = document.querySelector('nav.nav');
    if (!nav) return;

    var current = window.location.pathname.split('/').pop() || 'index.html';
    var links = nav.querySelectorAll('a[href]');
    links.forEach(function(link) {
      var href = link.getAttribute('href').split('/').pop();
      if (href === current) {
        link.classList.add('active');
      }
    });
  });
})();