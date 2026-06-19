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
    window.location.href = APP_CTX + '/warehouse/generators?action=list';
  });

  // confirm deactivate
  function confirmDeactivateGenerator(id, page) {
    confirmAction('Kh\u00f3a m\u00e1y ph\u00e1t \u0111i\u1ec7n', 'M\u1eabu m\u00e1y n\u00e0y s\u1ebd kh\u00f4ng kh\u1ea3 d\u1ee5ng cho \u0111\u01a1n h\u00e0ng. Ti\u1ebfp t\u1ee5c?', () => {
      window.location.href = APP_CTX + '/warehouse/generators?action=deactivate&id=' + id + '&page=' + page;
    });
  }

  // confirm activate
  function confirmActivateGenerator(id, page) {
    confirmAction('K\u00edch ho\u1ea1t m\u00e1y ph\u00e1t \u0111i\u1ec7n', 'M\u1eabu m\u00e1y n\u00e0y s\u1ebd kh\u1ea3 d\u1ee5ng tr\u1edf l\u1ea1i. Ti\u1ebfp t\u1ee5c?', () => {
      window.location.href = APP_CTX + '/warehouse/generators?action=activate&id=' + id + '&page=' + page;
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