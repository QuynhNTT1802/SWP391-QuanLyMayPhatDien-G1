document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        if (typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        } else if (typeof toast === 'function') {
            toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
        } else {
            alert(window.SESSION_DATA.message);
        }
        window.SESSION_DATA = null;
    }
});

function openModal(id) { var m = document.getElementById(id); if (m) m.classList.add('show'); }
function closeModal(id) { var m = document.getElementById(id); if (m) m.classList.remove('show'); }

function showGeneratorModal(el) {
    var id = el.getAttribute('data-gen-id') || '';
    var model = el.getAttribute('data-gen-model') || '—';
    var power = el.getAttribute('data-gen-power') || '—';
    var freq = el.getAttribute('data-gen-freq') || '—';
    var weight = el.getAttribute('data-gen-weight') || '—';
    var status = el.getAttribute('data-gen-status') || '—';

    document.getElementById('gm-id').textContent = id || '—';
    document.getElementById('gm-model').textContent = model;
    document.getElementById('gm-power').textContent = power ? power + ' kVA' : '—';
    document.getElementById('gm-freq').textContent = freq ? freq + ' Hz' : '—';
    document.getElementById('gm-weight').textContent = weight ? weight + ' kg' : '—';
    var statusText = status === 'active' ? 'Đang hoạt động' : (status === 'locked' ? 'Bị khóa' : status || '—');
    document.getElementById('gm-status').textContent = statusText;
    document.getElementById('gm-detail-link').href = window.APP_CTX + '/warehouse/generators?action=view&id=' + id;

    document.getElementById('generatorModal').classList.add('open');
}
function closeGeneratorModal() {
    document.getElementById('generatorModal').classList.remove('open');
}
document.querySelectorAll('.modal-host').forEach(function (m) {
    m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
});
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
        closeGeneratorModal();
    }
});

(function () {
    var tabs = document.querySelectorAll('.tab-bar .tab');
    var panels = document.querySelectorAll('.tab-panel');
    tabs.forEach(function (t) {
        t.addEventListener('click', function (e) {
            var target = t.getAttribute('data-tab');
            if (target === 'history') {
                return;
            }
            e.preventDefault();
            tabs.forEach(function (x) { x.classList.remove('active'); });
            panels.forEach(function (p) { p.classList.remove('active'); });
            t.classList.add('active');
            var panel = document.querySelector('.tab-panel[data-panel="' + target + '"]');
            if (panel) panel.classList.add('active');
            if (window.history && window.history.pushState) {
                var url = window.location.href.split('?')[0];
                window.history.pushState({}, '', url);
            }
        });
    });

    var search = document.getElementById('ordSearch');
    var table = document.getElementById('ordTable');
    if (table) {
        var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr[data-row-id]'));
        function applyFilter() {
            var q = (search && search.value ? search.value : '').toLowerCase().trim();
            rows.forEach(function (r) {
                var haystack = (r.getAttribute('data-search') || '').toLowerCase();
                var matchText = !q || haystack.indexOf(q) !== -1;
                r.style.display = matchText ? '' : 'none';
            });
        }
        if (search) search.addEventListener('input', applyFilter);
        applyFilter();
    }
})();
