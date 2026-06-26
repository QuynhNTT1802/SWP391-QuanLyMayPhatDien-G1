/* =========================================================
   Customer Picker (Side Panel) - Chon khach hang khi tao don
   Mo side panel slide tu ben phai, AJAX search realtime,
   hien thi ket qua dang card. Click card de chon va tu dong
   fill cac field trong form.
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

    function setTriggerLabel(text) {
        var label = $('custTriggerLabel');
        var wrap = $('custTrigger') ? $('custTrigger').parentElement : null;
        if (!label) return;
        if (text && text.trim().length > 0) {
            label.textContent = text.trim();
            label.classList.add('has-value');
            if (wrap) wrap.classList.add('has-value');
        } else {
            label.textContent = '-- Click \u0111\u1ec3 ch\u1ecdn kh\u00e1ch h\u00e0ng --';
            label.classList.remove('has-value');
            if (wrap) wrap.classList.remove('has-value');
        }
    }

    function clearCustomerFields() {
        var ids = ['inpCustName', 'inpCustPhone', 'inpCustEmail', 'inpCustAddress', 'customerCompany'];
        for (var i = 0; i < ids.length; i++) {
            var el = $(ids[i]);
            if (el) el.value = '';
        }
        var sel = $('customerTypeSelect');
        if (sel) {
            sel.value = '';
            if (typeof onCustomerTypeChange === 'function') onCustomerTypeChange();
        }
        var hidden = $('sdHiddenId');
        if (hidden) hidden.value = '';
    }

    function clearCustomerSelection() {
        clearCustomerFields();
        setTriggerLabel('');
    }

    // --- Strings (escape \uXXXX) ---
    var S_HINT_PROMPT = 'G\u00f5 t\u00ean, S\u0110T ho\u1eb7c email \u0111\u1ec3 t\u00ecm...';
    var S_NO_RESULT   = 'Kh\u00f4ng t\u00ecm th\u1ea5y kh\u00e1ch h\u00e0ng ph\u00f9 h\u1ee3p.';
    var S_LOADING     = '\u0110ang t\u1ea3i...';
    var S_ERR_LOAD    = 'L\u1ed7i t\u1ea3i d\u1eef li\u1ec7u (';
    var S_ERR_PARSE   = 'Ph\u1ea3n h\u1ed3i kh\u00f4ng h\u1ee3p l\u1ec7.';
    var S_ERR_NO_EP   = 'Ch\u01b0a c\u1ea5u h\u00ecnh endpoint t\u00ecm ki\u1ebfm.';

    var endpoint = '';
    var debounceTimer = null;
    var xhr = null;
    var currentResults = [];

    function openPanel() {
        var overlay = $('custPanelOverlay');
        var panel = $('custSidePanel');
        if (!overlay || !panel) return;
        overlay.classList.add('show');
        panel.classList.add('show');
        var searchInput = $('custSearchInput');
        var sortOrder = $('custSortOrder');
        if (searchInput) searchInput.value = '';
        if (sortOrder) sortOrder.value = 'name_asc';
        var list = $('custList');
        var loading = $('custLoading');
        if (loading) loading.style.display = 'block';
        if (list) list.innerHTML = '';
        currentResults = [];
        setTimeout(function () {
            if (searchInput) searchInput.focus();
            loadCustomers('');
        }, 50);
    }

    function closePanel() {
        var overlay = $('custPanelOverlay');
        var panel = $('custSidePanel');
        if (overlay) overlay.classList.remove('show');
        if (panel) panel.classList.remove('show');
    }

    function showEmpty(msg) {
        var list = $('custList');
        if (!list) return;
        list.innerHTML = '<div class="cust-empty-msg">' + escHtml(msg) + '</div>';
    }

    function showLoading() {
        var loading = $('custLoading');
        var list = $('custList');
        if (loading) loading.style.display = 'block';
        if (list) list.innerHTML = '';
    }

    function hideLoading() {
        var loading = $('custLoading');
        if (loading) loading.style.display = 'none';
    }

    function renderResults(items) {
        currentResults = Array.isArray(items) ? items : [];
        var list = $('custList');
        if (!list) return;
        if (!currentResults.length) {
            showEmpty(S_NO_RESULT);
            return;
        }
        var html = '';
        for (var i = 0; i < currentResults.length; i++) {
            var c = currentResults[i];
            var name = escHtml(c.name || '(Kh\u00f4ng t\u00ean)');
            var phone = escHtml(c.phone || '');
            var email = escHtml(c.email || '');
            var company = escHtml(c.companyName || '');
            var address = escHtml(c.address || '');
            var status = (c.status || 'active').toLowerCase();
            var badgeClass = status === 'locked' ? 'badge-locked' : 'badge-active';
            var badgeText = status === 'locked' ? 'LOCKED' : 'ACTIVE';

            var meta = '';
            if (phone) meta += '<span class="cust-card-meta-item">\u260E ' + phone + '</span>';
            if (email) meta += '<span class="cust-card-meta-item">\u2709 ' + email + '</span>';
            if (company) meta += '<span class="cust-card-meta-item">\uD83C\uDFE2 ' + company + '</span>';
            if (address) meta += '<span class="cust-card-meta-item">\uD83D\uDCCD ' + address + '</span>';

            html += '<div class="cust-card" data-idx="' + i + '">'
                  +     '<div class="cust-card-left">'
                  +         '<div class="cust-card-name">' + name + '</div>'
                  +         '<div class="cust-card-meta">' + meta + '</div>'
                  +     '</div>'
                  +     '<div class="cust-card-right">'
                  +         '<span class="cust-card-badge ' + badgeClass + '">' + badgeText + '</span>'
                  +     '</div>'
                  + '</div>';
        }
        list.innerHTML = html;
    }

    function loadCustomers(keyword) {
        if (!endpoint) {
            showEmpty(S_ERR_NO_EP);
            return;
        }
        var sortOrder = $('custSortOrder');
        var sortVal = sortOrder ? sortOrder.value : 'name_asc';
        showLoading();
        if (xhr) {
            try { xhr.abort(); } catch (e) {}
        }
        xhr = new XMLHttpRequest();
        var url = endpoint + encodeURIComponent((keyword || '').trim());
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4) return;
            hideLoading();
            if (xhr.status !== 200) {
                showEmpty(S_ERR_LOAD + xhr.status + ').');
                return;
            }
            try {
                var data = JSON.parse(xhr.responseText);
                sortResults(data, sortVal);
                renderResults(data);
            } catch (e) {
                showEmpty(S_ERR_PARSE);
            }
        };
        xhr.send();
    }

    function sortResults(arr, order) {
        if (!Array.isArray(arr)) return;
        arr.sort(function (a, b) {
            var na = (a.name || '').toLowerCase();
            var nb = (b.name || '').toLowerCase();
            if (order === 'name_desc') return nb.localeCompare(na);
            if (order === 'newest') {
                var ida = parseInt(a.id || 0, 10);
                var idb = parseInt(b.id || 0, 10);
                return idb - ida;
            }
            return na.localeCompare(nb);
        });
    }

    function selectCustomer(c) {
        if (!c) return;
        fillFormFields(c);
        var hidden = $('sdHiddenId');
        if (hidden && c.id != null) hidden.value = c.id;
        setTriggerLabel(c.name || c.phone || '');
        closePanel();
    }

    function init() {
        var root = $('customerDropdown');
        if (!root) return;
        endpoint = root.getAttribute('data-endpoint') || '';

        var searchInput = $('custSearchInput');
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                clearTimeout(debounceTimer);
                var kw = searchInput.value;
                debounceTimer = setTimeout(function () { loadCustomers(kw); }, 250);
            });
            searchInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    clearTimeout(debounceTimer);
                    loadCustomers(searchInput.value);
                } else if (e.key === 'Escape') {
                    e.preventDefault();
                    closePanel();
                }
            });
        }

        var sortOrder = $('custSortOrder');
        if (sortOrder) {
            sortOrder.addEventListener('change', function () {
                if (currentResults.length > 0) {
                    var kw = searchInput ? searchInput.value : '';
                    sortResults(currentResults, sortOrder.value);
                    renderResults(currentResults);
                } else {
                    loadCustomers(searchInput ? searchInput.value : '');
                }
            });
        }

        var list = $('custList');
        if (list) {
            list.addEventListener('click', function (e) {
                var card = e.target.closest('.cust-card');
                if (!card) return;
                var idx = parseInt(card.getAttribute('data-idx'), 10);
                if (isNaN(idx) || !currentResults[idx]) return;
                selectCustomer(currentResults[idx]);
            });
        }

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                var panel = $('custSidePanel');
                if (panel && panel.classList.contains('show')) {
                    closePanel();
                }
            }
        });

        // Pre-fill neu server da set san preselectCustomer (tra ve tu customer-create)
        try {
            var nameEl = $('inpCustName');
            var phoneEl = $('inpCustPhone');
            var preName = nameEl && nameEl.value ? nameEl.value.trim() : '';
            var prePhone = phoneEl && phoneEl.value ? phoneEl.value.trim() : '';
            if (preName || prePhone) {
                setTriggerLabel(preName || prePhone);
            }
        } catch (e) {}
    }

    // Expose functions to window for inline onclick
    window.openCustomerPanel = openPanel;
    window.closeCustomerPanel = closePanel;
    window.clearCustomerSelection = clearCustomerSelection;

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
