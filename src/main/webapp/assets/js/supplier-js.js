const APP_CTX = window.APP_CTX || '';

const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
var themeToggle = document.getElementById('themeToggle');
if (themeToggle) themeToggle.addEventListener('click', () => {
  const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  root.setAttribute('data-theme', next);
  localStorage.setItem('wh-theme', next);
});

var clearFiltersBtn = document.getElementById('clearFilters');
if (clearFiltersBtn) clearFiltersBtn.addEventListener('click', () => {
  window.location.href = APP_CTX + '/warehouse/suppliers?action=list';
});

function confirmDeactivateSupplier(id, page) {
  confirmAction('Khóa nhà cung cấp', 'Nhà cung cấp này sẽ không khả dụng. Tiếp tục?', () => {
    window.location.href = APP_CTX + '/warehouse/suppliers?action=deactivate&id=' + id + '&page=' + page;
  });
}

function confirmActivateSupplier(id, page) {
  confirmAction('Kích hoạt nhà cung cấp', 'Nhà cung cấp này sẽ khả dụng trở lại. Tiếp tục?', () => {
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
var modalCancel = document.getElementById('modalCancel');
var modalConfirm = document.getElementById('modalConfirm');
var confirmModal = document.getElementById('confirmModal');
if (modalCancel) modalCancel.addEventListener('click', () => {
  if (confirmModal) confirmModal.classList.remove('open');
  confirmCb = null;
});
if (modalConfirm) modalConfirm.addEventListener('click', () => {
  if (confirmCb) confirmCb();
  if (confirmModal) confirmModal.classList.remove('open');
  confirmCb = null;
});
if (confirmModal) confirmModal.addEventListener('click', e => {
  if (e.target.id === 'confirmModal') {
    confirmModal.classList.remove('open');
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
