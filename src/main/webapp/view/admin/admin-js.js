
  // theme sync
  const root = document.documentElement;
  const storedTheme = localStorage.getItem('wh-theme');
  if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
  document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
  });

  // user data
  const USERS = [
    { id: 'USR-04821', name: 'Mai Hoàng', email: 'mai.hoang@warehouseos.vn', phone: '+84 912 345 678', role: 'admin', warehouse: 'ALL', status: 'active', joined: '2023-08-12', lastLogin: '2026-05-12T14:08:00', avatar: 'green', initials: 'MH' },
    { id: 'USR-04822', name: 'Phạm Tùng', email: 'tung.pham@warehouseos.vn', phone: '+84 903 211 988', role: 'manager', warehouse: 'HN-01', status: 'active', joined: '2023-09-04', lastLogin: '2026-05-12T11:42:00', avatar: 'blue', initials: 'PT' },
    { id: 'USR-04823', name: 'Nguyễn Thị Lan', email: 'lan.nguyen@warehouseos.vn', phone: '+84 988 142 309', role: 'keeper', warehouse: 'HN-01', status: 'active', joined: '2024-01-15', lastLogin: '2026-05-12T09:21:00', avatar: 'orange', initials: 'NL' }
  ];

  const ROLE_LABEL = { admin: 'Admin', manager: 'Quản lý kho', keeper: 'Thủ kho', account: 'Kế toán', staff: 'Nhân viên', viewer: 'Viewer' };
  const STATUS_LABEL = { active: 'Hoạt động', pending: 'Chờ kích hoạt', locked: 'Bị khoá', disabled: 'Vô hiệu' };

  // state
  let state = {
    search: '', role: '', warehouse: '', status: '',
    sortBy: 'lastLogin', sortDir: 'desc',
    page: 1, pageSize: 20,
    selected: new Set()
  };

  function timeAgo(iso) {
    if (!iso) return 'Chưa đăng nhập';
    const d = new Date(iso);
    const now = new Date('2026-05-12T14:30:00');
    const diff = (now - d) / 1000;
    if (diff < 60) return 'Vừa xong';
    if (diff < 3600) return Math.floor(diff/60) + ' phút trước';
    if (diff < 86400) return Math.floor(diff/3600) + ' giờ trước';
    if (diff < 86400*7) return Math.floor(diff/86400) + ' ngày trước';
    const dd = String(d.getDate()).padStart(2,'0');
    const mm = String(d.getMonth()+1).padStart(2,'0');
    return `${dd}/${mm}/${d.getFullYear()}`;
  }
  function formatDate(iso) {
    const d = new Date(iso);
    return `${String(d.getDate()).padStart(2,'0')}/${String(d.getMonth()+1).padStart(2,'0')}/${d.getFullYear()}`;
  }
  function formatTime(iso) {
    if (!iso) return '';
    const d = new Date(iso);
    return `${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`;
  }

  function filtered() {
    let list = USERS.filter(u => {
      if (state.search) {
        const s = state.search.toLowerCase();
        if (!u.name.toLowerCase().includes(s) && !u.email.toLowerCase().includes(s)) return false;
      }
      if (state.role && u.role !== state.role) return false;
      if (state.warehouse && u.warehouse !== state.warehouse) return false;
      if (state.status && u.status !== state.status) return false;
      return true;
    });
    list.sort((a, b) => {
      let va = a[state.sortBy], vb = b[state.sortBy];
      if (state.sortBy === 'lastLogin' || state.sortBy === 'joined') {
        va = va ? new Date(va).getTime() : 0;
        vb = vb ? new Date(vb).getTime() : 0;
      } else {
        va = (va || '').toString().toLowerCase();
        vb = (vb || '').toString().toLowerCase();
      }
      if (va < vb) return state.sortDir === 'asc' ? -1 : 1;
      if (va > vb) return state.sortDir === 'asc' ? 1 : -1;
      return 0;
    });
    return list;
  }

  function render() {
    const list = filtered();
    const total = list.length;
    const totalPages = Math.max(1, Math.ceil(total / state.pageSize));
    if (state.page > totalPages) state.page = totalPages;
    const start = (state.page - 1) * state.pageSize;
    const pageRows = list.slice(start, start + state.pageSize);

    const body = document.getElementById('usersBody');
    const empty = document.getElementById('emptyState');
    if (pageRows.length === 0) {
      body.innerHTML = '';
      empty.style.display = 'block';
    } else {
      empty.style.display = 'none';
      body.innerHTML = pageRows.map(u => {
        const wh = u.warehouse === 'ALL' ? 'Toàn hệ thống' : u.warehouse;
        const last = u.lastLogin
          ? `<div>${timeAgo(u.lastLogin)}</div><div class="when">${formatDate(u.lastLogin)} · ${formatTime(u.lastLogin)}</div>`
          : `<div style="color:var(--muted)">—</div><div class="when">Chưa đăng nhập</div>`;
        const isSelected = state.selected.has(u.id);
        return `
          <tr data-id="${u.id}" class="${isSelected ? 'selected' : ''}">
            <td class="col-check"><input type="checkbox" class="checkbox row-check" ${isSelected ? 'checked' : ''} /></td>
            <td>
              <div class="user-cell">
                <div class="user-avatar ${u.avatar}">${u.initials}</div>
                <div class="user-name-block">
                  <div class="user-name">${u.name}</div>
                  <div class="user-email">${u.email}</div>
                </div>
              </div>
            </td>
            <td><span class="pill role-${u.role}"><span class="pdot"></span>${ROLE_LABEL[u.role]}</span></td>
            <td><span class="warehouse-tag">${wh}</span></td>
            <td><span class="status ${u.status}"><span class="sdot"></span>${STATUS_LABEL[u.status]}</span></td>
            <td class="last-login"><div>${formatDate(u.joined)}</div></td>
            <td class="last-login">${last}</td>
            <td class="col-actions">
              <div class="row-actions">
                <button class="icon-mini" data-action="view" title="Xem chi tiết">
                  <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
                <button class="icon-mini" data-action="edit" title="Chỉnh sửa">
                  <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                </button>
                <button class="icon-mini" data-action="lock" title="Khoá">
                  <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                </button>
                <button class="icon-mini danger" data-action="delete" title="Xoá">
                  <svg viewBox="0 0 24 24"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                </button>
              </div>
            </td>
          </tr>
        `;
      }).join('');
    }

    // pagination meta
    document.getElementById('rangeFrom').textContent = total === 0 ? 0 : start + 1;
    document.getElementById('rangeTo').textContent = Math.min(start + state.pageSize, total);
    document.getElementById('totalFiltered').textContent = total;

    // page numbers
    const pn = document.getElementById('pageNumbers');
    pn.innerHTML = '';
    const maxButtons = 5;
    let pStart = Math.max(1, state.page - 2);
    let pEnd = Math.min(totalPages, pStart + maxButtons - 1);
    pStart = Math.max(1, pEnd - maxButtons + 1);
    for (let p = pStart; p <= pEnd; p++) {
      const btn = document.createElement('button');
      btn.className = 'page-btn' + (p === state.page ? ' active' : '');
      btn.textContent = p;
      btn.onclick = () => { state.page = p; render(); };
      pn.appendChild(btn);
    }
    document.getElementById('prevPage').disabled = state.page <= 1;
    document.getElementById('nextPage').disabled = state.page >= totalPages;

    // selection state
    syncBulkBar();
    syncCheckAll();
  }

  function syncBulkBar() {
    const n = state.selected.size;
    document.body.classList.toggle('has-selection', n > 0);
    document.getElementById('bulkCount').textContent = n;
  }
  function syncCheckAll() {
    const visibleIds = Array.from(document.querySelectorAll('#usersBody tr')).map(r => r.dataset.id);
    const ck = document.getElementById('checkAll');
    const selectedOnPage = visibleIds.filter(id => state.selected.has(id));
    if (selectedOnPage.length === 0) { ck.checked = false; ck.indeterminate = false; }
    else if (selectedOnPage.length === visibleIds.length) { ck.checked = true; ck.indeterminate = false; }
    else { ck.checked = false; ck.indeterminate = true; }
  }

  // event handlers
  const debounce = (fn, ms = 200) => { let t; return (...a) => { clearTimeout(t); t = setTimeout(() => fn(...a), ms); }; };

  document.getElementById('searchInput').addEventListener('input', debounce(e => { state.search = e.target.value.trim(); state.page = 1; render(); }, 180));
  document.getElementById('filterRole').addEventListener('change', e => { state.role = e.target.value; state.page = 1; render(); });
  document.getElementById('filterWarehouse').addEventListener('change', e => { state.warehouse = e.target.value; state.page = 1; render(); });
  document.getElementById('filterStatus').addEventListener('change', e => { state.status = e.target.value; state.page = 1; render(); });
  document.getElementById('clearFilters').addEventListener('click', () => {
    state.search = ''; state.role = ''; state.warehouse = ''; state.status = ''; state.page = 1;
    document.getElementById('searchInput').value = '';
    document.getElementById('filterRole').value = '';
    document.getElementById('filterWarehouse').value = '';
    document.getElementById('filterStatus').value = '';
    render();
  });
  document.getElementById('pageSize').addEventListener('change', e => { state.pageSize = parseInt(e.target.value); state.page = 1; render(); });
  document.getElementById('prevPage').addEventListener('click', () => { if (state.page > 1) { state.page--; render(); } });
  document.getElementById('nextPage').addEventListener('click', () => { state.page++; render(); });

  document.querySelectorAll('th.sortable').forEach(th => {
    th.addEventListener('click', () => {
      const key = th.dataset.sort;
      if (state.sortBy === key) { state.sortDir = state.sortDir === 'asc' ? 'desc' : 'asc'; }
      else { state.sortBy = key; state.sortDir = 'desc'; }
      document.querySelectorAll('th.sortable').forEach(t => { t.classList.remove('sorted-asc', 'sorted-desc'); });
      th.classList.add(state.sortDir === 'asc' ? 'sorted-asc' : 'sorted-desc');
      render();
    });
  });

  document.getElementById('checkAll').addEventListener('change', e => {
    const visibleIds = Array.from(document.querySelectorAll('#usersBody tr')).map(r => r.dataset.id);
    if (e.target.checked) visibleIds.forEach(id => state.selected.add(id));
    else visibleIds.forEach(id => state.selected.delete(id));
    render();
  });

  document.getElementById('usersBody').addEventListener('click', e => {
    const tr = e.target.closest('tr');
    if (!tr) return;
    const id = tr.dataset.id;
    if (e.target.classList.contains('row-check')) {
      if (e.target.checked) state.selected.add(id);
      else state.selected.delete(id);
      tr.classList.toggle('selected', e.target.checked);
      syncBulkBar(); syncCheckAll();
      return;
    }
    const btn = e.target.closest('[data-action]');
    if (btn) {
      e.stopPropagation();
      const action = btn.dataset.action;
      if (action === 'view') location.href = `admin-user-detail.html?id=${id}`;
      else if (action === 'edit') location.href = `admin-user-edit.html?id=${id}`;
      else if (action === 'lock') confirmAction('Khoá tài khoản', `Người dùng sẽ không thể đăng nhập cho tới khi bạn mở khoá. Tiếp tục?`, () => toast('Đã khoá ' + USERS.find(u=>u.id===id).name, 'success'));
      else if (action === 'delete') confirmAction('Xoá người dùng', `Tài khoản sẽ bị xoá mềm và có thể khôi phục trong 30 ngày. Tiếp tục?`, () => toast('Đã xoá ' + USERS.find(u=>u.id===id).name, 'success'));
      return;
    }
    // row click → detail
    if (!e.target.closest('input, button')) {
      location.href = `admin-user-detail.html?id=${id}`;
    }
  });

  document.getElementById('bulkClear').addEventListener('click', () => { state.selected.clear(); render(); });
  document.querySelectorAll('[data-bulk]').forEach(btn => {
    btn.addEventListener('click', () => {
      const action = btn.dataset.bulk;
      const n = state.selected.size;
      if (action === 'role') toast(`Đổi vai trò cho ${n} người dùng — mở dialog (demo)`, 'success');
      else if (action === 'lock') confirmAction('Khoá hàng loạt', `${n} tài khoản sẽ không thể đăng nhập. Tiếp tục?`, () => { toast(`Đã khoá ${n} người dùng`, 'success'); state.selected.clear(); render(); });
      else if (action === 'delete') confirmAction('Xoá hàng loạt', `${n} tài khoản sẽ bị xoá mềm. Tiếp tục?`, () => { toast(`Đã xoá ${n} người dùng`, 'success'); state.selected.clear(); render(); });
    });
  });

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
    setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 200); }, 2800);
  }

  render();



