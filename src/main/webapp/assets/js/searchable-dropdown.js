/* =========================================================
   Searchable Dropdown - combobox co search realtime + AJAX
   Gan vao form chon EndUser (khach hang) cho order_create
   Chu y: tat ca chuoi tieng Viet dung escape \uXXXX de
   file JS luon la ASCII thuan, tranh loi encoding khi
   Tomcat serve static file .js khong kem header charset.
   ========================================================= */
(function () {
    'use strict';

    function $(id) { return document.getElementById(id); }

    function escHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function fillFormFields(data) {
        if (!data) return;
        if (data.name != null) $('inpCustName').value = data.name;
        if (data.phone != null) $('inpCustPhone').value = data.phone;
        if (data.email != null) $('inpCustEmail').value = data.email;
        if (data.address != null) $('inpCustAddress').value = data.address;
        if (data.companyName != null) $('customerCompany').value = data.companyName;
        if (data.customerTypeId != null && data.customerTypeId > 0) {
            var sel = $('customerTypeSelect');
            if (sel) {
                sel.value = String(data.customerTypeId);
                if (typeof onCustomerTypeChange === 'function') onCustomerTypeChange();
            }
        }
    }

    // --- Cac chuoi tieng Viet (escape \uXXXX) ---
    var S_HINT_PROMPT  = 'G\u00f5 t\u00ean, S\u0110T ho\u1eb7c email \u0111\u1ec3 t\u00ecm...';
    var S_NO_RESULT    = 'Kh\u00f4ng t\u00ecm th\u1ea5y kh\u00e1ch h\u00e0ng. B\u1ea1n c\u00f3 th\u1ec3 nh\u1eadp tay \u1edf c\u00e1c \u00f4 b\u00ean d\u01b0\u1edbi.';
    var S_LOADING      = '\u0110ang t\u00ecm...';
    var S_ERR_LOAD     = 'L\u1ed7i t\u1ea3i d\u1eef li\u1ec7u (';
    var S_ERR_PARSE    = 'Ph\u1ea3n h\u1ed3i kh\u00f4ng h\u1ee3p l\u1ec7.';
    var S_ERR_NO_EP    = 'Ch\u01b0a c\u1ea5u h\u00ecnh endpoint t\u00ecm ki\u1ebfm.';

    function init() {
        var root = $('customerDropdown');
        if (!root) return;
        var trigger = $('sdTrigger');
        var panel = $('sdPanel');
        var search = $('sdSearch');
        var list = $('sdList');
        var label = $('sdLabel');
        var hidden = $('sdHiddenId');
        if (!trigger || !panel || !search || !list || !label) return;

        var endpoint = root.getAttribute('data-endpoint') || '';
        var placeholder = '--Select EndUser--';
        var debounceTimer = null;
        var activeIndex = -1;
        var currentResults = [];
        var xhr = null;

        function open() {
            root.classList.add('open');
            trigger.setAttribute('aria-expanded', 'true');
            panel.hidden = false;
            setTimeout(function () { search.focus(); search.select(); }, 0);
            if (!currentResults.length) {
                showEmpty(S_HINT_PROMPT);
            }
        }

        function close() {
            root.classList.remove('open');
            trigger.setAttribute('aria-expanded', 'false');
            panel.hidden = true;
            search.value = '';
            activeIndex = -1;
        }

        function toggle() {
            if (root.classList.contains('open')) close();
            else open();
        }

        function showEmpty(msg, withIcon) {
            list.innerHTML = '<li class="sd-empty">' + (withIcon ? '<span class="sd-empty-icon">\uD83D\uDD0D</span>' : '') + escHtml(msg) + '</li>';
            currentResults = [];
            activeIndex = -1;
        }

        function showLoading() {
            list.innerHTML = '<li class="sd-loading">' + escHtml(S_LOADING) + '</li>';
        }

        function renderResults(items) {
            currentResults = Array.isArray(items) ? items : [];
            activeIndex = -1;
            if (!currentResults.length) {
                showEmpty(S_NO_RESULT, true);
                return;
            }
            var html = '';
            for (var i = 0; i < currentResults.length; i++) {
                var c = currentResults[i];
                var name = escHtml(c.name || '(khong ten)');
                var phone = escHtml(c.phone || '');
                var email = escHtml(c.email || '');
                var company = escHtml(c.companyName || '');
                var meta = '';
                if (phone) meta += '<span class="sd-item-meta-line">\u260E ' + phone + '</span>';
                if (email) meta += '<span class="sd-item-meta-line">\u2709 ' + email + '</span>';
                if (company) meta += '<span class="sd-item-meta-line">\uD83C\uDFE2 ' + company + '</span>';
                html += '<li class="sd-item" role="option" data-idx="' + i + '">'
                      +     '<span class="sd-item-name">' + name + '</span>'
                      +     (meta ? '<span class="sd-item-meta">' + meta + '</span>' : '')
                      + '</li>';
            }
            list.innerHTML = html;
        }

        function searchAjax(keyword) {
            if (!endpoint) {
                showEmpty(S_ERR_NO_EP);
                return;
            }
            if (!keyword || keyword.trim().length === 0) {
                showEmpty(S_HINT_PROMPT);
                return;
            }
            showLoading();
            if (xhr) {
                try { xhr.abort(); } catch (e) {}
            }
            xhr = new XMLHttpRequest();
            var url = endpoint + encodeURIComponent(keyword.trim());
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState !== 4) return;
                if (xhr.status !== 200) {
                    showEmpty(S_ERR_LOAD + xhr.status + ').');
                    return;
                }
                try {
                    var data = JSON.parse(xhr.responseText);
                    renderResults(data);
                } catch (e) {
                    showEmpty(S_ERR_PARSE);
                }
            };
            xhr.send();
        }

        function updateActive() {
            var items = list.querySelectorAll('.sd-item');
            for (var i = 0; i < items.length; i++) {
                if (i === activeIndex) items[i].classList.add('is-active');
                else items[i].classList.remove('is-active');
            }
            if (activeIndex >= 0 && items[activeIndex]) {
                items[activeIndex].scrollIntoView({ block: 'nearest' });
            }
        }

        function selectItem(c) {
            if (!c) return;
            label.textContent = c.name || placeholder;
            root.classList.add('has-value');
            if (hidden && c.id != null) hidden.value = c.id;
            fillFormFields(c);
            close();
            trigger.focus();
        }

        // --- Events ---
        trigger.addEventListener('click', function (e) {
            e.stopPropagation();
            toggle();
        });

        search.addEventListener('input', function () {
            clearTimeout(debounceTimer);
            var kw = search.value;
            debounceTimer = setTimeout(function () { searchAjax(kw); }, 250);
        });

        search.addEventListener('keydown', function (e) {
            var items = list.querySelectorAll('.sd-item');
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                if (items.length === 0) return;
                activeIndex = (activeIndex + 1) % items.length;
                updateActive();
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                if (items.length === 0) return;
                activeIndex = activeIndex <= 0 ? items.length - 1 : activeIndex - 1;
                updateActive();
            } else if (e.key === 'Enter') {
                e.preventDefault();
                if (activeIndex >= 0 && currentResults[activeIndex]) {
                    selectItem(currentResults[activeIndex]);
                } else if (currentResults.length === 1) {
                    selectItem(currentResults[0]);
                }
            } else if (e.key === 'Escape') {
                e.preventDefault();
                close();
                trigger.focus();
            }
        });

        list.addEventListener('click', function (e) {
            var item = e.target.closest('.sd-item');
            if (!item) return;
            var idx = parseInt(item.getAttribute('data-idx'), 10);
            if (isNaN(idx) || !currentResults[idx]) return;
            selectItem(currentResults[idx]);
        });

        list.addEventListener('mousemove', function (e) {
            var item = e.target.closest('.sd-item');
            if (!item) return;
            var idx = parseInt(item.getAttribute('data-idx'), 10);
            if (idx !== activeIndex) {
                activeIndex = idx;
                updateActive();
            }
        });

        document.addEventListener('click', function (e) {
            if (!root.contains(e.target) && root.classList.contains('open')) {
                close();
            }
        });

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && root.classList.contains('open')) {
                close();
                trigger.focus();
            }
        });

        // Pre-fill neu server da set san preselectCustomer
        try {
            var preNameEl = $('inpCustName');
            var prePhoneEl = $('inpCustPhone');
            if (preNameEl && preNameEl.value && preNameEl.value.trim().length > 0) {
                label.textContent = preNameEl.value.trim();
                root.classList.add('has-value');
                if (hidden && prePhoneEl && prePhoneEl.value) {
                    hidden.value = prePhoneEl.value;
                }
            }
        } catch (e) {}
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
