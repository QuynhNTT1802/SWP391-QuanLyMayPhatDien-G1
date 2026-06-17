/* =========================================================
   Customer Picker — Quick select / quick create customer
   Auto-fill khi click tên KH (unique), focus phone khi trùng
   Modal search realtime qua AJAX
   ========================================================= */
(function () {
    'use strict';

    function $(id) { return document.getElementById(id); }

    function fillFormFields(data) {
        if (data.name != null) $('inpCustName').value = data.name;
        if (data.phone != null) $('inpCustPhone').value = data.phone;
        if (data.email != null) $('inpCustEmail').value = data.email;
        if (data.address != null) $('inpCustAddress').value = data.address;
        if (data.companyName != null) $('inpCustCompany').value = data.companyName;
        if (data.customerTypeId != null && data.customerTypeId > 0) {
            var sel = $('customerTypeSelect');
            if (sel) {
                sel.value = data.customerTypeId;
                if (typeof onCustomerTypeChange === 'function') onCustomerTypeChange();
            }
        }
    }

    function clearFormFields() {
        $('inpCustName').value = '';
        $('inpCustPhone').value = '';
        $('inpCustEmail').value = '';
        $('inpCustAddress').value = '';
        $('inpCustCompany').value = '';
        var sel = $('customerTypeSelect');
        if (sel) sel.value = '';
        var hint = $('custDuplicateHint');
        if (hint) hint.classList.remove('show');
    }

    function showDuplicateHint() {
        var hint = $('custDuplicateHint');
        if (hint) hint.classList.add('show');
    }

    function hideDuplicateHint() {
        var hint = $('custDuplicateHint');
        if (hint) hint.classList.remove('show');
    }

    function initTop4Picker() {
        var items = document.querySelectorAll('.cust-picker-item');
        items.forEach(function (btn) {
            btn.addEventListener('click', function () {
                var raw = btn.getAttribute('data-customer');
                if (!raw) return;
                var c;
                try { c = JSON.parse(raw); } catch (e) { return; }

                var name = (c.name || '').trim().toLowerCase();
                var phone = (c.phone || '').trim();
                if (!name) return;

                hideDuplicateHint();
                fillFormFields(c);
                checkDuplicateAndMaybeClear(name, phone);
            });
        });
    }

    function checkDuplicateAndMaybeClear(name, phone) {
        var xhr = new XMLHttpRequest();
        var url = contextPath + '/warehouse/customers?action=countByName';
        xhr.open('POST', url, true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== 4) return;
            if (xhr.status !== 200) return;
            try {
                var count = parseInt(xhr.responseText) || 0;
                if (count > 1) {
                    $('inpCustName').value = name;
                    $('inpCustPhone').value = '';
                    $('inpCustPhone').focus();
                    showDuplicateHint();
                }
            } catch (e) {}
        };
        xhr.send('name=' + encodeURIComponent(name));
    }

    function initModal() {
        var modal = $('custSearchModal');
        if (!modal) return;
        var btnOpen = $('btnOpenCustSearch');
        var btnClose = $('btnCloseCustSearch');
        var inpSearch = $('inpCustModalSearch');
        var resultsHost = $('custModalResults');
        var debounceTimer = null;

        function open() {
            modal.classList.add('open');
            inpSearch.value = '';
            resultsHost.innerHTML = '<div class="cust-picker-modal-empty">Gõ tên hoặc số điện thoại để tìm...</div>';
            setTimeout(function () { inpSearch.focus(); }, 50);
        }
        function close() { modal.classList.remove('open'); }

        if (btnOpen) btnOpen.addEventListener('click', open);
        if (btnClose) btnClose.addEventListener('click', close);
        modal.addEventListener('click', function (e) {
            if (e.target === modal) close();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && modal.classList.contains('open')) close();
        });

        function search(keyword) {
            resultsHost.innerHTML = '<div class="cust-picker-modal-loading">Đang tìm...</div>';
            var xhr = new XMLHttpRequest();
            var url = contextPath + '/warehouse/customers?action=search&q=' + encodeURIComponent(keyword);
            xhr.open('GET', url, true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState !== 4) return;
                if (xhr.status !== 200) {
                    resultsHost.innerHTML = '<div class="cust-picker-modal-empty">Lỗi tải dữ liệu.</div>';
                    return;
                }
                try {
                    var list = JSON.parse(xhr.responseText);
                    renderResults(list);
                } catch (e) {
                    resultsHost.innerHTML = '<div class="cust-picker-modal-empty">Lỗi phản hồi.</div>';
                }
            };
            xhr.send();
        }

        function renderResults(list) {
            if (!list || list.length === 0) {
                resultsHost.innerHTML = '<div class="cust-picker-modal-empty"><div class="empty-icon">🔍</div>Không tìm thấy khách hàng phù hợp.<br>Bạn có thể nhập tay ở các ô bên dưới.</div>';
                return;
            }
            var html = '';
            for (var i = 0; i < list.length; i++) {
                var c = list[i];
                var name = escHtml(c.name || '');
                var phone = escHtml(c.phone || '');
                var addr = escHtml(c.address || '');
                var company = escHtml(c.companyName || '');
                var dataJson = JSON.stringify(c).replace(/'/g, "&#39;");
                html += '<div class="cust-picker-modal-result" data-customer=\'' + dataJson + '\'>'
                      +     '<div class="cust-picker-modal-result-name">' + name + '</div>'
                      +     '<div class="cust-picker-modal-result-meta">'
                      +         '<span class="cust-picker-modal-result-phone">📞 ' + phone + '</span>'
                      +         (company ? '<span>🏢 ' + company + '</span>' : '')
                      +         (addr ? '<span>📍 ' + addr + '</span>' : '')
                      +     '</div>'
                      + '</div>';
            }
            resultsHost.innerHTML = html;
        }

        if (inpSearch) {
            inpSearch.addEventListener('input', function () {
                clearTimeout(debounceTimer);
                var kw = inpSearch.value;
                debounceTimer = setTimeout(function () { search(kw); }, 250);
            });
        }

        resultsHost.addEventListener('click', function (e) {
            var row = e.target.closest('.cust-picker-modal-result');
            if (!row) return;
            var raw = row.getAttribute('data-customer');
            if (!raw) return;
            try {
                var c = JSON.parse(raw);
                fillFormFields(c);
                close();
            } catch (err) {}
        });
    }

    function escHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    document.addEventListener('DOMContentLoaded', function () {
        if ($('customerPicker') || $('custSearchModal')) {
            initTop4Picker();
            initModal();
        }
    });
})();
