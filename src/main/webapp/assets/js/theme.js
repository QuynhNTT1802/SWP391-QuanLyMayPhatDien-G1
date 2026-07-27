(function() {
  var root = document.documentElement;
  var stored = localStorage.getItem('wh-theme');
  if (stored === 'dark' || stored === 'light') root.setAttribute('data-theme', stored);
})();