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
// Select all / deselect all
const selectAllCheckbox = document.getElementById('selectAll');
if (selectAllCheckbox) {
    selectAllCheckbox.addEventListener('change', function () {
        var checkboxes = document.querySelectorAll('.gen-checkbox');
        checkboxes.forEach(function (cb) {
            cb.checked = selectAllCheckbox.checked;
        });
    });
}

// Update select-all state when individual checkbox changes
document.querySelectorAll('.gen-checkbox').forEach(function (cb) {
    cb.addEventListener('change', function () {
        var all = document.querySelectorAll('.gen-checkbox');
        var checked = document.querySelectorAll('.gen-checkbox:checked');
        if (selectAllCheckbox) {
            selectAllCheckbox.checked = all.length === checked.length;
            selectAllCheckbox.indeterminate = checked.length > 0 && checked.length < all.length;
        }
    });
});