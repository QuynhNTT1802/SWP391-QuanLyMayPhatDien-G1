
(function () {
    'use strict';

    function $(id) {
        return document.getElementById(id);
    }

    function escHtml(s) {
        if (s == null)
            return '';
        return String(s)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
    }

    function fillFormFields(data) {
        if (!data)
            return;
        var set = function (id, val) {
            var el = $(id);
            if (el && val != null)
                el.value = val;
        };
        set('inpCustName', data.name);
        set('inpCustPhone', data.phone);
        set('inpCustEmail', data.email);
        set('inpCustAddress', data.address);
        set('customerCompany', data.companyName);
        set('customerTypeId', data.customerTypeId);
        if (typeof onCustomerTypeChange === 'function')
            onCustomerTypeChange();
    }

    function setTriggerLabel(text) {
        var label = $('custTriggerLabel');
        var wrap = $('custTrigger') ? $('custTrigger').parentElement : null;
        if (!label)
            return;
        if (text && text.trim().length > 0) {
            label.textContent = text.trim();
            label.classList.add('has-value');
            if (wrap)
                wrap.classList.add('has-value');
        } else {
            label.textContent = '-- Click \u0111\u1ec3 ch\u1ecdn kh\u00e1ch h\u00e0ng --';
            label.classList.remove('has-value');
            if (wrap)
                wrap.classList.remove('has-value');
        }
    }

    function clearCustomerFields() {
        var ids = ['inpCustName', 'inpCustPhone', 'inpCustEmail', 'inpCustAddress', 'customerCompany', 'customerTypeId'];
        for (var i = 0; i < ids.length; i++) {
            var el = $(ids[i]);
            if (el)
                el.value = '';
        }
        if (typeof onCustomerTypeChange === 'function')
            onCustomerTypeChange();
        var hidden = $('sdHiddenId');
        if (hidden)
            hidden.value = '';
    }

    function clearCustomerSelection() {
        clearCustomerFields();
        setTriggerLabel('');
    }

    // --- Strings (escape \uXXXX) ---
    var S_HINT_PROMPT = 'G\u00f5 t\u00ean, S\u0110T ho\u1eb7c email \u0111\u1ec3 t\u00ecm...';
    var S_NO_RESULT = 'Kh\u00f4ng t\u00ecm th\u1ea5y kh\u00e1ch h\u00e0ng ph\u00f9 h\u1ee3p.';
    var S_LOADING = '\u0110ang t\u1ea3i...';
    var S_ERR_LOAD = 'L\u1ed7i t\u1ea3i d\u1eef li\u1ec7u (';
    var S_ERR_PARSE = 'Ph\u1ea3n h\u1ed3i kh\u00f4ng h\u1ee3p l\u1ec7.';
    var S_ERR_NO_EP = 'Ch\u01b0a c\u1ea5u h\u00ecnh endpoint t\u00ecm ki\u1ebfm.';

    var endpoint = '';
    var debounceTimer = null;
    var xhr = null;
    var currentResults = [];

    function openPanel() {
        var overlay = $('custPanelOverlay');
        var panel = $('custSidePanel');
        if (!overlay || !panel)
            return;
        overlay.classList.add('show');
        panel.classList.add('show');
        var searchInput = $('custSearchInput');
        var sortOrder = $('custSortOrder');
        if (searchInput)
            searchInput.value = '';
        if (sortOrder)
            sortOrder.value = 'name_asc';
        var list = $('custList');
        var loading = $('custLoading');
        if (loading)
            loading.style.display = 'block';
        if (list)
            list.innerHTML = '';
        currentResults = [];
        setTimeout(function () {
            if (searchInput)
                searchInput.focus();
            loadCustomers('');
        }, 50);
    }

    function closePanel() {
        var overlay = $('custPanelOverlay');
        var panel = $('custSidePanel');
        if (overlay)
            overlay.classList.remove('show');
        if (panel)
            panel.classList.remove('show');
    }

    function showEmpty(msg) {
        var list = $('custList');
        if (!list)
            return;
        list.innerHTML = '<div class="cust-empty-msg">' + escHtml(msg) + '</div>';
    }

    function showLoading() {
        var loading = $('custLoading');
        var list = $('custList');
        if (loading)
            loading.style.display = 'block';
        if (list)
            list.innerHTML = '';
    }

    function hideLoading() {
        var loading = $('custLoading');
        if (loading)
            loading.style.display = 'none';
    }

    function renderResults(items) {
        currentResults = Array.isArray(items) ? items : [];
        var list = $('custList');
        if (!list)
            return;
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

            var meta = '';
            if (phone)
                meta += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>' + phone + '</span>';
            if (email)
                meta += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>' + email + '</span>';
            if (company)
                meta += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>' + company + '</span>';
            if (address)
                meta += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>' + address + '</span>';

            html += '<div class="cust-card" data-idx="' + i + '">'
                    + '<div class="cust-card-left">'
                    + '<div class="cust-card-name">' + name + '</div>'
                    + '<div class="cust-card-meta">' + meta + '</div>'
                    + '</div>'
                    + '<div class="cust-card-icon">'
                    + '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>'
                    + '</div>'
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
            try {
                xhr.abort();
            } catch (e) {
            }
        }
        xhr = new XMLHttpRequest();
        var url = endpoint + encodeURIComponent((keyword || '').trim());
        xhr.open('GET', url, true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4)
                return;
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
        if (!Array.isArray(arr))
            return;
        arr.sort(function (a, b) {
            var na = (a.name || '').toLowerCase();
            var nb = (b.name || '').toLowerCase();
            if (order === 'name_desc')
                return nb.localeCompare(na);
            if (order === 'newest') {
                var ida = parseInt(a.id || 0, 10);
                var idb = parseInt(b.id || 0, 10);
                return idb - ida;
            }
            return na.localeCompare(nb);
        });
    }

    function selectCustomer(c) {
        if (!c)
            return;
        fillFormFields(c);
        var hidden = $('sdHiddenId');
        if (hidden && c.id != null)
            hidden.value = c.id;
        setTriggerLabel(c.name || c.phone || '');
        closePanel();
    }

    function init() {
        var root = $('customerDropdown');
        if (!root)
            return;
        endpoint = root.getAttribute('data-endpoint') || '';

        var searchInput = $('custSearchInput');
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                clearTimeout(debounceTimer);
                var kw = searchInput.value;
                debounceTimer = setTimeout(function () {
                    loadCustomers(kw);
                }, 250);
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
                if (!card)
                    return;
                var idx = parseInt(card.getAttribute('data-idx'), 10);
                if (isNaN(idx) || !currentResults[idx])
                    return;
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
        } catch (e) {
        }
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