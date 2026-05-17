(function () {
    var root = document.documentElement;
    var stored = localStorage.getItem('wh-theme');
    if (stored === 'dark' || stored === 'light')
        root.setAttribute('data-theme', stored);

    document.addEventListener('DOMContentLoaded', function () {
        var toggle = document.getElementById('themeToggle');
        if (toggle) {
            toggle.addEventListener('click', function () {
                var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
                root.setAttribute('data-theme', next);
                localStorage.setItem('wh-theme', next);
            });
        }
    });
})();
