
  const APP_CTX = window.APP_CTX || '';

  // theme sync (apply immediately to avoid flash)
  const root = document.documentElement;
  const storedTheme = localStorage.getItem('wh-theme');
  if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);

  // confirm actions (hoisted, available to inline onclick)
  function confirmDeactivate(userId, page) {
    confirmAction('Vô hiệu hoá tài khoản', 'Người dùng sẽ không thể đăng nhập cho tới khi bạn kích hoạt lại. Tiếp tục?', function() {
      window.location.href = APP_CTX + '/admin/users?action=deactivate&id=' + userId + '&page=' + page;
    });
  }

  function confirmActivate(userId, page) {
    confirmAction('Kích hoạt tài khoản', 'Người dùng sẽ có thể đăng nhập trở lại. Tiếp tục?', function() {
      window.location.href = APP_CTX + '/admin/users?action=activate&id=' + userId + '&page=' + page;
    });
  }

  // modal
  var confirmCb = null;
  function confirmAction(title, text, cb) {
    var modalTitle = document.getElementById('modalTitle');
    var modalText = document.getElementById('modalText');
    var modal = document.getElementById('confirmModal');
    if (modalTitle) modalTitle.textContent = title;
    if (modalText) modalText.textContent = text;
    confirmCb = cb;
    if (modal) modal.classList.add('open');
  }

  function toast(msg, type) {
    type = type || 'default';
    var host = document.getElementById('toastHost');
    var t = document.createElement('div');
    t.className = 'toast ' + type;
    var icon = type === 'success'
      ? '<svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>'
      : type === 'danger'
      ? '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>'
      : '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';
    t.innerHTML = icon + '<span>' + msg + '</span>';
    if (host) host.appendChild(t);
    requestAnimationFrame(function() { t.classList.add('show'); });
    setTimeout(function() { t.classList.remove('show'); setTimeout(function() { t.remove(); }, 2800); }, 2800);
  }

  document.addEventListener('DOMContentLoaded', function() {
    var themeToggle = document.getElementById('themeToggle');
    if (themeToggle) {
      themeToggle.addEventListener('click', function() {
        var next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', next);
        localStorage.setItem('wh-theme', next);
      });
    }

    var clearFilters = document.getElementById('clearFilters');
    if (clearFilters) {
      clearFilters.addEventListener('click', function() {
        window.location.href = APP_CTX + '/admin/users?action=list';
      });
    }

    var modalCancel = document.getElementById('modalCancel');
    if (modalCancel) {
      modalCancel.addEventListener('click', function() {
        var modal = document.getElementById('confirmModal');
        if (modal) modal.classList.remove('open');
        confirmCb = null;
      });
    }

    var modalConfirm = document.getElementById('modalConfirm');
    if (modalConfirm) {
      modalConfirm.addEventListener('click', function() {
        if (confirmCb) confirmCb();
        var modal = document.getElementById('confirmModal');
        if (modal) modal.classList.remove('open');
        confirmCb = null;
      });
    }

    var confirmModal = document.getElementById('confirmModal');
    if (confirmModal) {
      confirmModal.addEventListener('click', function(e) {
        if (e.target.id === 'confirmModal') {
          confirmModal.classList.remove('open');
          confirmCb = null;
        }
      });
    }
  });