
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
    window.location.href = APP_CTX + '/admin/users?action=list';
  });

  // confirm actions
  function confirmDeactivate(userId, page) {
    confirmAction('Vô hiệu hoá tài khoản', 'Người dùng sẽ không thể đăng nhập cho tới khi bạn kích hoạt lại. Tiếp tục?', () => {
      window.location.href = APP_CTX + '/admin/users?action=deactivate&id=' + userId + '&page=' + page;
    });
  }

  function confirmActivate(userId, page) {
    confirmAction('Kích hoạt tài khoản', 'Người dùng sẽ có thể đăng nhập trở lại. Tiếp tục?', () => {
      window.location.href = APP_CTX + '/admin/users?action=activate&id=' + userId + '&page=' + page;
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
  document.getElementById('modalCancel').addEventListener('click', () => { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; });
  document.getElementById('modalConfirm').addEventListener('click', () => { if (confirmCb) confirmCb(); document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; });
  document.getElementById('confirmModal').addEventListener('click', e => { if (e.target.id === 'confirmModal') { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; } });

  // toast
  function toast(msg, type = 'default') {
    const host = document.getElementById('toastHost');
    const t = document.createElement('div');
    t.className = 'toast ' + type;
    const icon = type === 'success'
      ? '<svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>'
      : type === 'danger'
      ? '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>'
      : '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';
    t.innerHTML = icon + '<span>' + msg + '</span>';
    host.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 2800); }, 2800);
  }
