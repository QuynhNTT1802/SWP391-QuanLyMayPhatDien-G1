const APP_CTX = window.APP_CTX || '';

const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
document.getElementById('themeToggle').addEventListener('click', () => {
  const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  root.setAttribute('data-theme', next);
  localStorage.setItem('wh-theme', next);
});

document.getElementById('clearFilters').addEventListener('click', () => {
  window.location.href = APP_CTX + '/warehouse/suppliers?action=list';
});

function confirmDeactivateSupplier(id, page) {
  confirmAction('Kh\u00f3a nh\u00e0 cung c\u1ea5p', 'Nh\u00e0 cung c\u1ea5p n\u00e0y s\u1ebd kh\u00f4ng kh\u1ea3 d\u1ee5ng. Ti\u1ebfp t\u1ee5c?', () => {
    window.location.href = APP_CTX + '/warehouse/suppliers?action=deactivate&id=' + id + '&page=' + page;
  });
}

function confirmActivateSupplier(id, page) {
  confirmAction('K\u00edch ho\u1ea1t nh\u00e0 cung c\u1ea5p', 'Nh\u00e0 cung c\u1ea5p n\u00e0y s\u1ebd kh\u1ea3 d\u1ee5ng tr\u1edf l\u1ea1i. Ti\u1ebfp t\u1ee5c?', () => {
    window.location.href = APP_CTX + '/warehouse/suppliers?action=activate&id=' + id + '&page=' + page;
  });
}

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