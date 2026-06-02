;(function () {
  var CTX = window.CTX || ''
  var USER = window.USER_DATA || {}
  var SESSION = window.SESSION_DATA || {}

  var ROLE_LABEL = { admin: 'Admin', manager: 'Qu\u1ea3n l\u00fd kho', keeper: 'Th\u1ee7 kho', account: 'K\u1ebf to\u00e1n', staff: 'Nh\u00e2n vi\u00ean', viewer: 'Viewer' }
  var STATUS_LABEL = { active: 'Ho\u1ea1t \u0111\u1ed9ng', inactive: 'Ch\u01b0a k\u00edch ho\u1ea1t', pending: 'Ch\u1edd duy\u1ec7t', locked: 'B\u1ecb kho\u00e1' }
  var WH_LABEL = { 'HN-01': 'HN-01 H\u00e0 N\u1ed9i', 'HCM-03': 'HCM-03 TP.HCM', 'DN-02': 'DN-02 \u0110\u00e0 N\u1eb5ng', 'ALL': 'To\u00e0n h\u1ec7 th\u1ed1ng' }
  var FIELD_LABEL = {
    name: 'H\u1ecd v\u00e0 t\u00ean', phone: 'S\u1ed1 \u0111i\u1ec7n tho\u1ea1i', address: '\u0110\u1ecba ch\u1ec9', status: 'Tr\u1ea1ng th\u00e1i',
    role: 'Vai tr\u00f2', permissions: 'Ghi \u0111\u00e8 quy\u1ec1n'
  }

  var form = document.getElementById('editForm')
  function getSelectedRoleName() {
    var sel = document.querySelector('.role-card.selected .role-card-name')
    return sel ? sel.textContent.trim() : ''
  }
  function getPermissionSnapshot() {
    var map = {}
    ;[].slice.call(document.querySelectorAll('input[name^="perOverride_"]')).forEach(function (r) {
      if (r.checked) map[r.name] = r.value
    })
    return JSON.stringify(map)
  }
  var original = {
    name: USER.name,
    phone: USER.phone,
    address: USER.address,
    status: USER.status,
    role: getSelectedRoleName(),
    permissions: getPermissionSnapshot()
  }
  var current = { name: USER.name, phone: USER.phone, address: USER.address, status: USER.status, role: original.role, permissions: original.permissions }

  ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (card) {
    card.addEventListener('click', function (e) {
      e.preventDefault()
      if (e.target.tagName === 'INPUT') return
      if (card.classList.contains('selected')) return
      ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (c) {
        c.classList.remove('selected')
        c.querySelector('input').checked = false
      })
      card.classList.add('selected')
      card.querySelector('input').checked = true
      current.role = getSelectedRoleName()
      diffField('role')
      updateUI()
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

  ;[].slice.call(document.querySelectorAll('input[name^="perOverride_"]')).forEach(function (radio) {
    radio.addEventListener('change', function () {
      var action = this.dataset.action
      if (this.value !== 'DENY' && action !== 'view') {
        var viewRadio = document.querySelector(
          'input[name^="perOverride_"][data-resource="' + this.dataset.resource + '"][data-action="view"][value="' + this.value + '"]'
        )
        if (viewRadio) viewRadio.checked = true
      }
      current.permissions = getPermissionSnapshot()
      diffField('permissions')
      updateUI()
    })
  })

  function diffField(name) {
    if (name === 'status' || name === 'role' || name === 'permissions') return
    var isDirty = String(current[name]).trim() !== String(original[name]).trim()
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

  function getPermissionsDiffItems() {
    var oldMap = {}
    try { oldMap = JSON.parse(original.permissions) } catch (e) {}
    var curMap = {}
    try { curMap = JSON.parse(current.permissions) } catch (e) {}
    var allKeys = Object.keys(oldMap).concat(Object.keys(curMap).filter(function (k) { return !(k in oldMap) }))
    var items = []
    allKeys.forEach(function (key) {
      var oldVal = oldMap[key] || 'default'
      var curVal = curMap[key] || 'default'
      if (oldVal !== curVal) {
        var permLabel = key.replace('perOverride_', '')
        items.push({ label: permLabel, from: oldVal, to: curVal })
      }
    })
    return items
  }

  function updateUI() {
    var dirty = getDirtyFields()
    document.body.classList.toggle('has-changes', dirty.length > 0)
    document.getElementById('dirtyPill').textContent = dirty.length + ' tr\u01b0\u1eddng'
    var badge = document.getElementById('changeBadge')
    badge.textContent = dirty.length
    badge.classList.toggle('has-changes', dirty.length > 0)
    var list = document.getElementById('changesList')
    if (dirty.length === 0) {
      list.innerHTML = '<div class="changes-empty">Ch\u01b0a c\u00f3 thay \u0111\u1ed5i n\u00e0o.<br>S\u1eeda th\u00f4ng tin \u0111\u1ec3 xem diff.</div>'
    } else {
      var html = ''
      dirty.forEach(function (k) {
        if (k === 'permissions') {
          var permDiffs = getPermissionsDiffItems()
          permDiffs.forEach(function (d) {
            html += '<div class="change-item"><span class="field">Ghi \u0111\u00e8 ' + d.label + '</span><span class="from">' + d.from + '</span><span class="arrow">\u2192</span><span class="to">' + d.to + '</span></div>'
          })
        } else {
          html += '<div class="change-item"><span class="field">' + FIELD_LABEL[k] + '</span><span class="from">' + formatValue(k, original[k]) + '</span><span class="arrow">\u2192</span><span class="to">' + formatValue(k, current[k]) + '</span></div>'
        }
      })
      list.innerHTML = html
    }
  }

  function formatValue(field, value) {
    if (field === 'role') return value || '\u2014'
    if (field === 'status') return STATUS_LABEL[value] || value
    if (field === 'warehouse') return WH_LABEL[value] || value
    return value || '\u2014'
  }

  document.getElementById('saveBtn').addEventListener('click', save)
  document.getElementById('cancelBtn').addEventListener('click', cancel)

  function save() {
    if (!isValid()) { toast('Vui l\u00f2ng ki\u1ec3m tra c\u00e1c tr\u01b0\u1eddng \u0111\u01b0\u1ee3c t\u00f4 \u0111\u1ecf', 'danger'); return }
    form.submit()
  }

  function cancel() {
    var dirty = getDirtyFields()
    if (dirty.length === 0) { window.location.href = CTX + '/admin/users?action=list'; return }
    confirmAction('Hu\u1ef7 thay \u0111\u1ed5i?', 'B\u1ea1n c\u00f3 ' + dirty.length + ' thay \u0111\u1ed5i ch\u01b0a l\u01b0u. T\u1ea5t c\u1ea3 s\u1ebd b\u1ecb m\u1ea5t n\u1ebfu r\u1eddi kh\u1ecfi.', function () {
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
      if (action === 'reset-pw') confirmAction('G\u1eedi reset m\u1eadt kh\u1ea9u?', 'Email s\u1ebd g\u1eedi link \u0111\u1eb7t l\u1ea1i m\u1eadt kh\u1ea9u.', function () { toast('\u0110\u00e3 g\u1eedi email reset m\u1eadt kh\u1ea9u', 'success') })
      else if (action === 'logout-all') confirmAction('\u0110\u0103ng xu\u1ea5t m\u1ecdi thi\u1ebft b\u1ecb?', 'User ph\u1ea3i \u0111\u0103ng nh\u1eadp l\u1ea1i.', function () { toast('\u0110\u00e3 \u0111\u0103ng xu\u1ea5t t\u1ea5t c\u1ea3 thi\u1ebft b\u1ecb', 'success') })
      else if (action === 'delete') confirmAction('Xo\u00e1 t\u00e0i kho\u1ea3n?', 'Soft delete \u00b7 c\u00f3 th\u1ec3 kh\u00f4i ph\u1ee5c trong 30 ng\u00e0y.', function () { toast('\u0110\u00e3 xo\u00e1 t\u00e0i kho\u1ea3n', 'success'); setTimeout(function () { window.location.href = CTX + '/admin/users?action=list' }, 1200) })
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
  if (SESSION.error) toast('Vui l\u00f2ng ki\u1ec3m tra l\u1ea1i th\u00f4ng tin', 'danger')
})()

