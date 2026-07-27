function formatVND(num) {
    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
}
function validateQty(input) {
    var v = input.value.replace(/[^0-9]/g, '');
    if (v === '' || v === '0') {
        input.value = v;
        return;
    }
    var n = parseInt(v);
    if (n > 9999) {
        input.value = 9999;
    } else {
        input.value = n;
    }
    validateQtyAgainstStock(input.closest('tr'));
}
function validateQtyOnBlur(input) {
    var n = parseInt(input.value);
    if (isNaN(n) || n < 1) {
        input.value = 1;
    }
}
function validateUnitPrice(input) {
    var original = input.value;
    var cleaned = original.replace(/[^\d]/g, '');
    if (original && cleaned === '') {
        alert('Đơn giá chỉ được nhập số, không nhập chữ!');
        input.value = '0';
        return;
    }
    input.value = cleaned;
}
function formatPriceDisplay(input) {
    var n = parseInt(input.value.replace(/[^\d]/g, '')) || 0;
    if (n > 0) {
        input.value = n.toLocaleString('vi-VN');
    } else {
        input.value = '0';
    }
}
function unformatPrice(input) {
    input.value = input.value.replace(/[^\d]/g, '');
    if (input.value === '') {
        input.value = '0';
    }
}

var STOCK_MAP = {};
function setStockMap(map) {
    STOCK_MAP = map || {};
}
function getStockFor(generatorId) {
    if (!generatorId) return 0;
    return STOCK_MAP[generatorId] || 0;
}
function updateStockCell(selEl) {
    var row = selEl.closest('tr');
    var stockCell = row.querySelector('.row-stock');
    if (!stockCell) return;
    var gid = parseInt(selEl.value);
    if (!gid) {
        stockCell.textContent = '—';
        return;
    }
    var stock = getStockFor(gid);
    stockCell.textContent = stock;
    stockCell.style.color = stock === 0 ? 'var(--danger)' : 'var(--fg)';
    stockCell.style.fontWeight = stock === 0 ? '600' : '';
    validateQtyAgainstStock(row);
}
function validateQtyAgainstStock(row) {
    var sel = row.querySelector('.gen-select');
    var qtyInput = row.querySelector('.qty-input');
    if (!sel || !qtyInput) return;
    var gid = parseInt(sel.value);
    var qty = parseInt(qtyInput.value) || 0;
    var stock = getStockFor(gid);
    if (gid && qty > stock) {
        qtyInput.classList.add('is-invalid');
    } else {
        qtyInput.classList.remove('is-invalid');
    }
}
function updateTotal() {
    var grand = 0;
    Array.from(document.querySelectorAll('#detailBody tr')).forEach(function (row) {
        var sel = row.querySelector('.gen-select');
        var qty = parseInt(row.querySelector('.qty-input').value) || 0;
        var priceInput = row.querySelector('.unit-price-input');
        var price = parseInt(priceInput.value.replace(/[^\d]/g, '')) || 0;
        var subtotal = price * qty;
        row.querySelector('.row-subtotal').textContent = formatVND(subtotal);
        grand += subtotal;
    });
    document.getElementById('grandTotal').textContent = formatVND(grand);
}
function addRow() {
    var tpl = document.getElementById('rowTemplate');
    var clone = tpl.content.cloneNode(true);
    document.getElementById('detailBody').appendChild(clone);
    updateRowNumbers();
    updateTotal();
}
function removeRow(btn) {
    var tbody = document.getElementById('detailBody');
    if (tbody.querySelectorAll('tr').length <= 1)
        return;
    btn.closest('tr').remove();
    updateRowNumbers();
    updateTotal();
}
function updateRowNumbers() {
    Array.from(document.querySelectorAll('#detailBody .row-num')).forEach(function (el, i) {
        el.textContent = i + 1;
    });
}

function htmlEsc(s) {
    if (s == null) return '';
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;')
        .replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}
function refreshCustomerCard() {
    var container = document.getElementById('customerCardContainer');
    var picker = document.getElementById('custPickerArea');
    if (!container) return;
    var hid = document.getElementById('sdHiddenId');
    var custId = hid ? hid.value : '';
    if (!custId || !custId.trim()) {
        container.style.display = 'none';
        if (picker) picker.style.display = '';
        return;
    }
    if (picker) picker.style.display = 'none';
    var nameVal    = (document.getElementById('inpCustName')    || {}).value || '';
    var phoneVal   = (document.getElementById('inpCustPhone')   || {}).value || '';
    var emailVal   = (document.getElementById('inpCustEmail')   || {}).value || '';
    var addressVal = (document.getElementById('inpCustAddress') || {}).value || '';
    var companyVal = (document.getElementById('customerCompany')|| {}).value || '';
    var html = '<div class="cic-header">';
    html += '<span class="cic-name">' + htmlEsc(nameVal || '') + '</span>';
    html += '<div class="cic-actions">';
    html += '<button type="button" class="cic-btn-remove" onclick="clearCustomerSelection();refreshCustomerCard();" title="Hủy chọn khách hàng" aria-label="Hủy chọn">';
    html += '<svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>';
    html += '</button></div></div>';
    html += '<div class="cic-details">';
    if (phoneVal)   html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>' + htmlEsc(phoneVal) + '</span>';
    if (companyVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>' + htmlEsc(companyVal) + '</span>';
    if (emailVal)   html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>' + htmlEsc(emailVal) + '</span>';
    if (addressVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>' + htmlEsc(addressVal) + '</span>';
    html += '</div>';
    container.innerHTML = html;
    container.style.display = '';
}

function openNewCustomerModal() {
    ['ncName', 'ncPhone', 'ncEmail', 'ncCompanyName', 'ncAddress', 'ncTypeId'].forEach(function (id) {
        var el = document.getElementById(id);
        if (el) el.value = '';
    });
    var err = document.getElementById('custModalError');
    if (err) { err.classList.remove('show'); err.textContent = ''; }
    document.getElementById('custModalOverlay').classList.add('show');
}
function closeNewCustomerModal() {
    document.getElementById('custModalOverlay').classList.remove('show');
}
function saveNewCustomer() {
    var name = document.getElementById('ncName').value.trim();
    var phone = document.getElementById('ncPhone').value.trim();
    if (!name) {
        var err = document.getElementById('custModalError');
        err.textContent = 'Vui lòng nhập tên khách hàng.';
        err.classList.add('show');
        return;
    }
    if (!phone || !/^[0-9]{10,11}$/.test(phone)) {
        var err = document.getElementById('custModalError');
        err.textContent = 'Vui lòng nhập SĐT hợp lệ (10-11 chữ số).';
        err.classList.add('show');
        return;
    }
    var btn = document.getElementById('ncSaveBtn');
    btn.disabled = true;
    btn.textContent = 'Đang lưu...';
    var params = new URLSearchParams();
    params.set('action', 'quickCreateCustomer');
    params.set('name', name);
    params.set('phone', phone);
    params.set('email', document.getElementById('ncEmail').value.trim());
    params.set('address', document.getElementById('ncAddress').value.trim());
    params.set('companyName', document.getElementById('ncCompanyName').value.trim());
    params.set('customerTypeId', document.getElementById('ncTypeId').value);
    fetch(window.APP_CTX + '/order', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        btn.disabled = false;
        btn.textContent = 'Lưu khách hàng';
        if (!data.ok) {
            var err = document.getElementById('custModalError');
            err.textContent = data.error || 'Lỗi';
            err.classList.add('show');
            return;
        }
        document.getElementById('sdHiddenId').value = data.id;
        document.getElementById('inpCustName').value = data.name || '';
        document.getElementById('inpCustPhone').value = data.phone || '';
        document.getElementById('inpCustEmail').value = data.email || '';
        document.getElementById('inpCustAddress').value = data.address || '';
        document.getElementById('customerCompany').value = data.companyName || '';
        if (data.customerTypeId) {
            document.getElementById('customerTypeId').value = String(data.customerTypeId);
        }
        var label = document.getElementById('custTriggerLabel');
        label.textContent = data.name || data.phone || '';
        label.classList.add('has-value');
        closeNewCustomerModal();
        refreshCustomerCard();
        if (typeof showToast === 'function') {
            showToast(
                data.existing ? 'SĐT đã có khách hàng: ' + data.name + ' — đã tự chọn.' : 'Đã thêm khách hàng "' + data.name + '"',
                data.existing ? 'info' : 'success'
            );
        }
    })
    .catch(function () {
        btn.disabled = false;
        btn.textContent = 'Lưu khách hàng';
        var err = document.getElementById('custModalError');
        err.textContent = 'Lỗi kết nối';
        err.classList.add('show');
    });
}

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('#detailBody tr').forEach(function (row) {
        var sel = row.querySelector('.gen-select');
        if (sel && sel.value) {
            updateStockCell(sel);
            var priceInput = row.querySelector('.unit-price-input');
            if (priceInput) formatPriceDisplay(priceInput);
        }
    });
    updateTotal();

    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        if (typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        }
    }
});

(function () {
    var list = document.getElementById('custList');
    if (list) {
        list.addEventListener('click', function (e) {
            if (e.target.closest('.cust-card')) {
                setTimeout(refreshCustomerCard, 0);
            }
        });
    }
})();
document.addEventListener('DOMContentLoaded', refreshCustomerCard);

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeNewCustomerModal();
});
