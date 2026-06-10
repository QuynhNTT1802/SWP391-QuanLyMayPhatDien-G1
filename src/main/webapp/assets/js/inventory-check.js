const APP_CTX = window.APP_CTX || '';

const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);

const themeBtn = document.getElementById('themeToggle');
if (themeBtn) {
    themeBtn.addEventListener('click', () => {
        const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', next);
        localStorage.setItem('wh-theme', next);
    });
}
// Tabs
const tabs = document.querySelectorAll('.tab');
const panels = document.querySelectorAll('.tab-panel');
tabs.forEach(function (t) {
    t.addEventListener('click', function () {
        var key = t.getAttribute('data-tab');
        tabs.forEach(function (x) { x.classList.remove('active'); });
        panels.forEach(function (p) { p.classList.remove('active'); });
        t.classList.add('active');
        var panel = document.getElementById('tab-' + key);
        if (panel) panel.classList.add('active');
    });
});

// Modal
function openModal(id) {
    var m = document.getElementById(id);
    if (m) m.classList.add('show');
}
function closeModal(id) {
    var m = document.getElementById(id);
    if (m) m.classList.remove('show');
}
document.querySelectorAll('.modal-host').forEach(function (m) {
    m.addEventListener('click', function (e) {
        if (e.target === m) m.classList.remove('show');
    });
});