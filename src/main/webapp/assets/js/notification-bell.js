(function () {
    'use strict';

    var bell = document.getElementById('notifBell');
    if (!bell) return;

    var dropdown = document.getElementById('notifDropdown');
    var listEl = document.getElementById('notifList');
    var markAllBtn = document.getElementById('notifMarkAll');
    var badge = document.getElementById('notifBadge');
    var endpoint = bell.dataset.endpoint;
    var loaded = false;

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function formatTime(iso) {
        if (!iso) return '';
        var d = new Date(iso);
        if (isNaN(d.getTime())) return iso;
        var now = new Date();
        var diff = (now - d) / 1000;
        if (diff < 60) return 'V\u1EEBa xong';
        if (diff < 3600) return Math.floor(diff / 60) + ' ph\u00FAt tr\u01B0\u1EDBc';
        if (diff < 86400) return Math.floor(diff / 3600) + ' gi\u1EDD tr\u01B0\u1EDBc';
        var pad = function (n) { return n < 10 ? '0' + n : n; };
        return pad(d.getDate()) + '/' + pad(d.getMonth() + 1) + ' ' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    }

    function renderItems(items) {
        if (!items || items.length === 0) {
            listEl.innerHTML = '<div class="bell-empty">Kh\u00F4ng c\u00F3 th\u00F4ng b\u00E1o</div>';
            return;
        }
        var html = '';
        items.forEach(function (n) {
            var cls = 'bell-item' + (n.isRead ? '' : ' unread');
            html += '<div class="' + cls + '" data-id="' + n.id + '" data-link="' + escapeHtml(n.link || '') + '">';
            if (!n.isRead) html += '<span class="dot"></span>';
            html += '<div class="body">';
            html += '<div class="ttl">' + escapeHtml(n.title) + '</div>';
            html += '<div class="msg">' + escapeHtml(n.message) + '</div>';
            html += '<div class="time">' + escapeHtml(formatTime(n.createdAt)) + '</div>';
            html += '</div></div>';
        });
        listEl.innerHTML = html;

        Array.prototype.forEach.call(listEl.querySelectorAll('.bell-item'), function (el) {
            el.addEventListener('click', function () {
                var id = el.dataset.id;
                var link = el.dataset.link;
                fetch(endpoint + '?action=markRead&id=' + encodeURIComponent(id), {
                    method: 'POST',
                    credentials: 'same-origin'
                }).finally(function () {
                    if (link) window.location.href = link;
                });
            });
        });
    }

    function updateBadge(count) {
        if (count > 0) {
            if (!badge) {
                badge = document.createElement('span');
                badge.id = 'notifBadge';
                badge.className = 'bell-badge';
                bell.appendChild(badge);
            }
            badge.textContent = count > 99 ? '99+' : count;
        } else if (badge) {
            badge.remove();
            badge = null;
        }
    }

    function load() {
        listEl.innerHTML = '<div class="bell-empty">\u0110ang t\u1EA3i...</div>';
        fetch(endpoint + '?action=dropdown', { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                updateBadge(data.unreadCount || 0);
                renderItems(data.items || []);
                loaded = true;
            })
            .catch(function () {
                listEl.innerHTML = '<div class="bell-empty">Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c th\u00F4ng b\u00E1o</div>';
            });
    }

    bell.addEventListener('click', function (e) {
        e.stopPropagation();
        var open = !dropdown.hasAttribute('hidden');
        if (open) {
            dropdown.setAttribute('hidden', '');
        } else {
            dropdown.removeAttribute('hidden');
            if (!loaded) load();
        }
    });

    document.addEventListener('click', function (e) {
        if (!dropdown.hasAttribute('hidden') && !dropdown.contains(e.target) && e.target !== bell && !bell.contains(e.target)) {
            dropdown.setAttribute('hidden', '');
        }
    });

    if (markAllBtn) {
        markAllBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            fetch(endpoint + '?action=markAllRead', {
                method: 'POST',
                credentials: 'same-origin'
            })
                .then(function (r) { return r.json(); })
                .then(function () {
                    updateBadge(0);
                    loaded = false;
                    load();
                });
        });
    }
})();
