function toast(msg, type) {
    if (!type) type = 'default';
    var host = document.getElementById('toastHost');
    if (!host) return;
    var t = document.createElement('div');
    t.className = 'toast ' + type;
    var icon = type === 'success'
        ? '<svg width="15" height="15" viewBox="0 0 24 24" stroke="currentColor" fill="none" stroke-width="2.2"><path d="M20 6 9 17l-5-5"/></svg>'
        : type === 'danger'
            ? '<svg width="15" height="15" viewBox="0 0 24 24" stroke="currentColor" fill="none" stroke-width="2.2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>'
            : '<svg width="15" height="15" viewBox="0 0 24 24" stroke="currentColor" fill="none" stroke-width="2.2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';
    t.innerHTML = icon + '<span>' + msg + '</span>';
    host.appendChild(t);
    requestAnimationFrame(function () { t.classList.add('show'); });
    setTimeout(function () {
        t.classList.remove('show');
        setTimeout(function () { t.remove(); }, 200);
    }, 2800);
}

document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'success');
    }
});
