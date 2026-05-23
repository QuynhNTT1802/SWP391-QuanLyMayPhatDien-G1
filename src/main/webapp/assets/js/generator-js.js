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
    window.location.href = APP_CTX + '/admin/generators?action=list';
  });

  // confirm deactivate
  function confirmDeactivateGenerator(id, page) {
    confirmAction('Khóa máy phát điện', 'Mẫu máy này sẽ không khả dụng cho đơn hàng. Tiếp tục?', () => {
      window.location.href = APP_CTX + '/admin/generators?action=deactivate&id=' + id + '&page=' + page;
    });
  }

  // confirm activate
  function confirmActivateGenerator(id, page) {
    confirmAction('Kích hoạt máy phát điện', 'Mẫu máy này sẽ khả dụng trở lại. Tiếp tục?', () => {
      window.location.href = APP_CTX + '/admin/generators?action=activate&id=' + id + '&page=' + page;
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