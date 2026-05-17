;(function () {
  var CTX = window.CTX || ''
  var USER = window.USER_DATA || {}
  var SESSION = window.SESSION_DATA || {}

  var ROLE_LABEL = { admin: 'Admin', manager: 'Quản lý kho', keeper: 'Thủ kho', account: 'Kế toán', staff: 'Nhân viên', viewer: 'Viewer' }
  var STATUS_LABEL = { active: 'Hoạt động', inactive: 'Chưa kích hoạt', pending: 'Chờ duyệt', locked: 'Bị khoá' }
  var WH_LABEL = { 'HN-01': 'HN-01 Hà Nội', 'HCM-03': 'HCM-03 TP.HCM', 'DN-02': 'DN-02 Đà Nẵng', 'ALL': 'Toàn hệ thống' }
  var FIELD_LABEL = {
    name: 'Họ và tên', phone: 'Số điện thoại', address: 'Địa chỉ', status: 'Trạng thái'
  }

  var form = document.getElementById('editForm')
  var original = {
    name: USER.name,
    phone: USER.phone,
    address: USER.address,
    status: USER.status
  }
  var current = { name: USER.name, phone: USER.phone, address: USER.address, status: USER.status }

  ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (card) {
    card.addEventListener('click', function () {
      ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (c) { c.classList.remove('selected') })
      card.classList.add('selected')
      card.querySelector('input').checked = true
    })
  })

  var statusSeg = document.querySelector('.seg[data-name="status"]')
  statusSeg.addEventListener('click', function (e) {
    var btn = e.target.closest('.seg-opt')
    if (!btn) return
    ;[].slice.call(statusSeg.querySelectorAll('.seg-opt')).forEach(function (o) { o.classList.remove('active') })
    btn.classList.add('active')
    current.status = btn.dataset.val
    document.querySelector('input[name="status"]').value = btn.dataset.val
    diffField('status')
    updateUI()
  })

  ;['name', 'phone', 'address'].forEach(function (name) {
    var el = form.elements[name]
    if (el) el.addEventListener('input', function () { current[name] = el.value; diffField(name); updateUI() })
  })

  function diffField(name) {
    var isDirty = String(current[name]).trim() !== String(original[name]).trim()
    if (name === 'status') return
    var el = form.elements[name]
    if (el) el.classList.toggle('dirty', isDirty)
  }

  function getDirtyFields() {
    return Object.keys(original).filter(function (k) { return String(current[k]).trim() !== String(original[k]).trim() })
  }

  function isValid() {
    var name = (current.name || '').trim()
    var phone = (current.phone || '').trim()
    var phoneOk = !phone || /^(\+84|0)\s?[3-9]\d{1}[\s\d]{6,12}$/.test(phone)
    var nameEl = document.querySelector('[name="name"]')
    var nameField = nameEl ? nameEl.closest('.field') : null
    var phoneEl = document.querySelector('[name="phone"]')
    var phoneField = phoneEl ? phoneEl.closest('.field') : null
    if (nameEl) nameEl.classList.toggle('error', name.length > 0 && name.length < 2)
    if (nameField) nameField.classList.toggle('invalid', name.length > 0 && name.length < 2)
    if (phoneEl) phoneEl.classList.toggle('error', !phoneOk)
    if (phoneField) phoneField.classList.toggle('invalid', !phoneOk)
    return name.length >= 2 && phoneOk
  }

  function updateUI() {
    var dirty = getDirtyFields()
    document.body.classList.toggle('has-changes', dirty.length > 0)
    document.getElementById('dirtyPill').textContent = dirty.length + ' trường'
    var badge = document.getElementById('changeBadge')
    badge.textContent = dirty.length
    badge.classList.toggle('has-changes', dirty.length > 0)
    var list = document.getElementById('changesList')
    if (dirty.length === 0) {
      list.innerHTML = '<div class="changes-empty">Chưa có thay đổi nào.<br>Sửa thông tin để xem diff.</div>'
    } else {
      list.innerHTML = dirty.map(function (k) {
        return '<div class="change-item"><span class="field">' + FIELD_LABEL[k] + '</span><span class="from">' + formatValue(k, original[k]) + '</span><span class="arrow">→</span><span class="to">' + formatValue(k, current[k]) + '</span></div>'
      }).join('')
    }
  }

  function formatValue(field, value) {
    if (field === 'role') return ROLE_LABEL[value] || value
    if (field === 'status') return STATUS_LABEL[value] || value
    if (field === 'warehouse') return WH_LABEL[value] || value
    return value || '—'
  }

  document.getElementById('saveBtn').addEventListener('click', save)
  document.getElementById('cancelBtn').addEventListener('click', cancel)

  function save() {
    if (!isValid()) { toast('Vui lòng kiểm tra các trường được tô đỏ', 'danger'); return }
    form.submit()
  }

  function cancel() {
    var dirty = getDirtyFields()
    if (dirty.length === 0) { window.location.href = CTX + '/admin/users?action=list'; return }
    confirmAction('Huỷ thay đổi?', 'Bạn có ' + dirty.length + ' thay đổi chưa lưu. Tất cả sẽ bị mất nếu rời khỏi.', function () {
      window.location.href = CTX + '/admin/users?action=list'
    })
  }

  document.addEventListener('keydown', function (e) {
    if ((e.metaKey || e.ctrlKey) && e.key === 's') { e.preventDefault(); save() }
    else if (e.key === 'Escape') { cancel() }
  })
  window.addEventListener('beforeunload', function (e) {
    if (getDirtyFields().length > 0) { e.preventDefault(); e.returnValue = '' }
  })

  ;[].slice.call(document.querySelectorAll('[data-danger]')).forEach(function (btn) {
    btn.addEventListener('click', function () {
      var action = btn.dataset.danger
      if (action === 'reset-pw') confirmAction('Gửi reset mật khẩu?', 'Email sẽ gửi link đặt lại mật khẩu.', function () { toast('Đã gửi email reset mật khẩu', 'success') })
      else if (action === 'logout-all') confirmAction('Đăng xuất mọi thiết bị?', 'User phải đăng nhập lại.', function () { toast('Đã đăng xuất tất cả thiết bị', 'success') })
      else if (action === 'delete') confirmAction('Xoá tài khoản?', 'Soft delete · có thể khôi phục trong 30 ngày.', function () { toast('Đã xoá tài khoản', 'success'); setTimeout(function () { window.location.href = CTX + '/admin/users?action=list' }, 1200) })
    })
  })

  var confirmCb = null
  function confirmAction(title, text, cb) {
    document.getElementById('modalTitle').textContent = title
    document.getElementById('modalText').textContent = text
    confirmCb = cb
    document.getElementById('confirmModal').classList.add('open')
  }
  document.getElementById('modalCancel').addEventListener('click', function () { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null })
  document.getElementById('modalConfirm').addEventListener('click', function () { if (confirmCb) confirmCb(); document.getElementById('confirmModal').classList.remove('open'); confirmCb = null })
  document.getElementById('confirmModal').addEventListener('click', function (e) { if (e.target.id === 'confirmModal') { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null } })

  function toast(msg, type) {
    if (!type) type = 'default'
    var host = document.getElementById('toastHost')
    var t = document.createElement('div')
    t.className = 'toast ' + type
    var icon = type === 'success'
      ? '<svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>'
      : type === 'danger'
        ? '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>'
        : '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>'
    t.innerHTML = icon + '<span>' + msg + '</span>'
    host.appendChild(t)
    requestAnimationFrame(function () { t.classList.add('show') })
    setTimeout(function () { t.classList.remove('show'); setTimeout(function () { t.remove() }, 200) }, 2800)
  }

  updateUI()

  if (SESSION.message) toast(SESSION.message, 'success')
  if (SESSION.error) toast('Vui lòng kiểm tra lại thông tin', 'danger')
})()
