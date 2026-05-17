
// theme
const root = document.documentElement;
const stored = localStorage.getItem('wh-theme');
if (stored === 'dark' || stored === 'light')
    root.setAttribute('data-theme', stored);
document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
});

// mode toggle
let mode = 'invite';
const modeToggle = document.getElementById('modeToggle');
modeToggle.addEventListener('click', e => {
    const btn = e.target.closest('[data-mode]');
    if (!btn)
        return;
    mode = btn.dataset.mode;
    modeToggle.querySelectorAll('button').forEach(b => b.classList.toggle('active', b === btn));
    document.getElementById('pwSection').style.display = mode === 'create' ? 'block' : 'none';
    document.getElementById('submitLabel').textContent = mode === 'create' ? 'Tạo tài khoản' : 'Gửi lời mời';
    document.getElementById('sumMode').textContent = mode === 'create' ? 'Tạo trực tiếp' : 'Lời mời email';
    validate();
});

// role cards
const roleCards = document.querySelectorAll('.role-card');
const roleLabel = {admin: 'Admin', manager: 'Quản lý kho', keeper: 'Thủ kho', account: 'Kế toán', staff: 'Nhân viên', viewer: 'Viewer'};
roleCards.forEach(card => {
    card.addEventListener('click', () => {
        roleCards.forEach(c => c.classList.remove('selected'));
        card.classList.add('selected');
        const v = card.querySelector('input').value;
        card.querySelector('input').checked = true;
        document.getElementById('sumRole').textContent = roleLabel[v];
        validate();
    });
});

// initials
function initialsOf(name) {
    if (!name)
        return '??';
    const parts = name.trim().split(/\s+/);
    if (parts.length === 1)
        return parts[0].slice(0, 2).toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

// live summary
const form = document.getElementById('createForm');
form.addEventListener('input', e => {
    const name = form.fullName.value;
    document.getElementById('sumName').textContent = name || 'Chưa nhập tên';
    document.getElementById('sumName').classList.toggle('empty', !name);
    const av = document.getElementById('sumAvatar');
    av.textContent = initialsOf(name);
    av.classList.toggle('has-value', !!name);
    document.getElementById('sumEmail').textContent = form.email.value || '—';
    document.getElementById('sumWh').textContent = form.warehouse.value || '—';
    if (e.target.name === 'require2fa')
        document.getElementById('sum2fa').textContent = form.require2fa.checked ? 'Bắt buộc' : 'Tuỳ chọn';
    if (e.target.name === 'password')
        updatePwStrength();
    validate();
});

// password generator
document.getElementById('pwGen').addEventListener('click', () => {
    const upper = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const lower = 'abcdefghjkmnpqrstuvwxyz';
    const nums = '23456789';
    const syms = '!@#$%&*?';
    const all = upper + lower + nums + syms;
    let pw = upper[Math.floor(Math.random() * upper.length)] + lower[Math.floor(Math.random() * lower.length)] + nums[Math.floor(Math.random() * nums.length)] + syms[Math.floor(Math.random() * syms.length)];
    for (let i = 0; i < 10; i++)
        pw += all[Math.floor(Math.random() * all.length)];
    pw = pw.split('').sort(() => Math.random() - 0.5).join('');
    form.password.value = pw;
    updatePwStrength();
    validate();
});

function updatePwStrength() {
    const v = form.password.value;
    let score = 0;
    if (v.length >= 10)
        score++;
    if (/[A-Z]/.test(v) && /[a-z]/.test(v))
        score++;
    if (/[0-9]/.test(v))
        score++;
    if (/[^A-Za-z0-9]/.test(v))
        score++;
    if (v.length >= 14)
        score = Math.min(4, score + (score === 4 ? 0 : 0));
    const bars = document.querySelectorAll('#pwStrength .bar');
    bars.forEach((b, i) => {
        b.className = 'bar';
        if (i < score)
            b.classList.add('lv' + score);
    });
    const label = document.getElementById('pwLabel');
    label.className = 'strength';
    if (!v) {
        label.textContent = 'Chưa nhập';
        return;
    }
    const map = {1: ['Rất yếu', 1], 2: ['Yếu', 2], 3: ['Khá', 3], 4: ['Mạnh', 4]};
    if (map[score]) {
        label.textContent = map[score][0];
        label.classList.add('lv' + map[score][1]);
    } else {
        label.textContent = 'Rất yếu';
        label.classList.add('lv1');
    }
}

// validate
function validate() {
    const name = form.fullName.value.trim();
    const email = form.email.value.trim();
    const phone = form.phone.value.trim();
    const wh = form.warehouse.value;
    const pw = form.password.value;
    const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    const phoneOk = !phone || /^(\+84|0)\s?[3-9]\d{1}[\s\d]{6,12}$/.test(phone);
    const pwOk = mode !== 'create' || (pw.length >= 10 && /[A-Z]/.test(pw) && /[0-9]/.test(pw) && /[^A-Za-z0-9]/.test(pw));
    const ok = name.length >= 2 && emailOk && phoneOk && wh && pwOk;
    document.getElementById('submitBtn').disabled = !ok;
    document.getElementById('saveSub').textContent = ok
            ? (mode === 'create' ? 'Sẵn sàng tạo · Người dùng có thể đăng nhập ngay' : 'Sẵn sàng gửi · Email kích hoạt có hiệu lực 24 giờ')
            : 'Điền họ tên + email + chọn kho để bật nút lưu';

    // field-level validation visuals
    setFieldInvalid('fullName', name.length > 0 && name.length < 2);
    setFieldInvalid('email', email.length > 0 && !emailOk);
    setFieldInvalid('phone', phone.length > 0 && !phoneOk);
}
function setFieldInvalid(fieldName, isInvalid) {
    const input = form.querySelector(`[name="${fieldName}"]`);
    if (!input)
        return;
    input.classList.toggle('error', isInvalid);
    input.closest('.field').classList.toggle('invalid', isInvalid);
}

// submit
document.getElementById('submitBtn').addEventListener('click', () => {
    const btn = document.getElementById('submitBtn');
    btn.disabled = true;
    btn.innerHTML = '<svg class="icon" viewBox="0 0 24 24" style="animation:spin 1s linear infinite"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg> Đang xử lý…';
    setTimeout(() => {
        const action = mode === 'create' ? 'Đã tạo tài khoản' : 'Đã gửi lời mời tới';
        const email = form.email.value;
        toast(`${action} ${email}`, 'success');
        setTimeout(() => {
            window.location.href = 'admin-users.html';
        }, 1200);
    }, 800);
});

function toast(msg, type = 'default') {
    const host = document.getElementById('toastHost');
    const t = document.createElement('div');
    t.className = 'toast ' + type;
    const icon = type === 'success' ? '<svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>' : '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';
    t.innerHTML = icon + '<span>' + msg + '</span>';
    host.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => {
        t.classList.remove('show');
        setTimeout(() => t.remove(), 200);
    }, 2800);
}

// init
validate();