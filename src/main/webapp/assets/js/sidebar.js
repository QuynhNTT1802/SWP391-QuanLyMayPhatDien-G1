(function() {
  document.addEventListener('DOMContentLoaded', function() {
    var nav = document.querySelector('nav.nav');
    if (!nav) return;

    var STORAGE_KEY = 'sidebarOpen';

    function saveState() {
      var state = {};
      nav.querySelectorAll('.nav-parent').forEach(function(el) {
        state[el.textContent.trim()] = el.classList.contains('open');
      });
      try { localStorage.setItem(STORAGE_KEY, JSON.stringify(state)); } catch(e) {}
    }

    function restoreState() {
      try {
        var saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || '{}');
        nav.querySelectorAll('.nav-parent').forEach(function(el) {
          if (saved[el.textContent.trim()]) {
            el.classList.add('open');
            var ch = el.nextElementSibling;
            if (ch && ch.classList.contains('nav-children')) ch.classList.add('open');
          }
        });
      } catch(e) {}
    }

    // Restore saved dropdown states
    restoreState();

    // Mark active link and ensure its dropdown is open
    var current = window.location.pathname.split('/').pop() || 'index.html';
    nav.querySelectorAll('a[href]').forEach(function(link) {
      var href = link.getAttribute('href').split('/').pop();
      if (href === current) {
        link.classList.add('active');
        var children = link.closest('.nav-children');
        if (children) {
          children.classList.add('open');
          var parent = children.previousElementSibling;
          if (parent && parent.classList.contains('nav-parent')) parent.classList.add('open');
        }
      }
    });

    // Save state when user toggles a dropdown
    nav.addEventListener('click', function(e) {
      var parent = e.target.closest('.nav-parent');
      if (parent) setTimeout(saveState, 0);
    });
  });
})();
