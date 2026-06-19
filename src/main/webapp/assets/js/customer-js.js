const APP_CTX = window.APP_CTX || '';

// theme sync
const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
document.getElementById('themeToggle').addEventListener('click', () => {
  const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  root.setAttribute('data-theme', next);
  localStorage.setItem('wh-theme', next);
});

// clear filters
document.getElementById('clearFilters').addEventListener('click', () => {
  window.location.href = APP_CTX + '/warehouse/customers?action=list';
});

// confirm deactivate
function confirmDeactivateCustomer(id, page) {
  confirmAction('Kh\u00f3a kh\u00e1ch h\u00e0ng', 'Kh\u00e1ch h\u00e0ng n\u00e0y s\u1ebd kh\u00f4ng kh\u1ea3 d\u1ee5ng. Ti\u1ebfp t\u1ee5c?', () => {
    window.location.href = APP_CTX + '/warehouse/customers?action=deactivate&id=' + id + '&page=' + page;
  });
}

// confirm activate
function confirmActivateCustomer(id, page) {
  confirmAction('K\u00edch ho\u1ea1t kh\u00e1ch h\u00e0ng', 'Kh\u00e1ch h\u00e0ng n\u00e0y s\u1ebd kh\u1ea3 d\u1ee5ng tr\u1edf l\u1ea1i. Ti\u1ebfp t\u1ee5c?', () => {
    window.location.href = APP_CTX + '/warehouse/customers?action=activate&id=' + id + '&page=' + page;
  });
}

// modal
let confirmCb = null;
function confirmAction(title, text, cb) {
  document.getElementById('modalTitle').textContent = title;
  document.getElementById('modalText').textContent = text;
  confirmCb = cb;
  document.getElementById('confirmModal').classList.add('open');
}
document.getElementById('modalCancel').addEventListener('click', () => {
  document.getElementById('confirmModal').classList.remove('open');
  confirmCb = null;
});
document.getElementById('modalConfirm').addEventListener('click', () => {
  if (confirmCb) confirmCb();
  document.getElementById('confirmModal').classList.remove('open');
  confirmCb = null;
});
document.getElementById('confirmModal').addEventListener('click', e => {
  if (e.target.id === 'confirmModal') {
    document.getElementById('confirmModal').classList.remove('open');
    confirmCb = null;
  }
});
// tabs
document.querySelectorAll('.tab').forEach(function (t) {
    t.addEventListener('click', function () {
        var key = t.getAttribute('data-tab');
        document.querySelectorAll('.tab').forEach(function (x) { x.classList.remove('active'); });
        document.querySelectorAll('.tab-panel').forEach(function (p) { p.classList.remove('active'); });
        t.classList.add('active');
        var panel = document.getElementById('tab-' + key);
        if (panel) panel.classList.add('active');
    });
});