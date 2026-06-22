const APP_CTX = window.APP_CTX || '';

// theme sync
const root = document.documentElement;
const storedTheme = localStorage.getItem('wh-theme');
if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
var themeToggle = document.getElementById('themeToggle');
if (themeToggle) themeToggle.addEventListener('click', () => {
  const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  root.setAttribute('data-theme', next);
  localStorage.setItem('wh-theme', next);
});

// clear filters
var clearFiltersBtn = document.getElementById('clearFilters');
if (clearFiltersBtn) clearFiltersBtn.addEventListener('click', () => {
  window.location.href = APP_CTX + '/warehouse/customers?action=list';
});

// confirm deactivate
function confirmDeactivateCustomer(id, page) {
  confirmAction('Khóa khách hàng', 'Khách hàng này sẽ không khả dụng. Tiếp tục?', () => {
    window.location.href = APP_CTX + '/warehouse/customers?action=deactivate&id=' + id + '&page=' + page;
  });
}

// confirm activate
function confirmActivateCustomer(id, page) {
  confirmAction('Kích hoạt khách hàng', 'Khách hàng này sẽ khả dụng trở lại. Tiếp tục?', () => {
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