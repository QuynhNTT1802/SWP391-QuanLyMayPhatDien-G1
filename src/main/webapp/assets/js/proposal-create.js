function formatVND(num) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num || 0);
}

function getStock(gid) {
    return STOCK_MAP[gid] || 0;
}

function htmlEsc(s) {
    if (s == null) return '';
    return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

function validateQty(input) {
    var cleaned = (input.value || '').replace(/[^\d]/g, '');
    if (input.value !== cleaned) {
        toast(MSG.QTY_ONLY_NUM, 'danger');
        input.value = '1';
    }
    updateTotal();
}

function finalizeQty(input) {
    var cleaned = (input.value || '').replace(/[^0-9]/g, '');
    if (cleaned.length > 4) cleaned = cleaned.slice(0, 4);
    var n = parseInt(cleaned, 10);
    if (isNaN(n) || n < 1) {
        input.value = '1';
    } else {
        input.value = cleaned;
    }
    updateTotal();
}

function validateUnitPrice(input) {
    var cleaned = (input.value || '').replace(/[^\d]/g, '');
    if (input.value && cleaned === '') {
        toast(MSG.DG_ONLY_NUM, 'danger');
        input.value = '0';
    } else if (cleaned !== input.value) {
        input.value = cleaned;
    }
    updateTotal();
}

function finalizeUnitPrice(input) {
    var n = parseInt((input.value || '').replace(/[^\d]/g, ''), 10);
    if (isNaN(n)) return;
    input.value = n > 0 ? String(n) : '0';
    updateTotal();
}

function formatPriceDisplay(input) {
    var n = parseInt(input.value.replace(/[^\d]/g, '')) || 0;
    input.value = n > 0 ? String(n) : '0';
}

function unformatPrice(input) {
    input.value = input.value.replace(/[^\d]/g, '') || '0';
}

function updateStockCell(sel) {
    var cell = sel.closest('tr').querySelector('.row-stock');
    if (!sel.value) {
        cell.textContent = '\u2014';
        cell.className = 'row-stock mono';
        return;
    }
    var s = getStock(sel.value);
    cell.textContent = s + ' m\u00e1y';
    cell.className = s === 0 ? 'row-stock mono zero-stock' : 'row-stock mono has-stock';
}

function updateTotal() {
    var total = 0;
    Array.from(document.querySelectorAll('#detailBody tr')).forEach(function (tr) {
        var q = parseInt(tr.querySelector('.qty-input').value) || 0;
        var p = parseInt((tr.querySelector('.unit-price-input').value || '').replace(/[^\d]/g, '')) || 0;
        var subtotal = q * p;
        tr.querySelector('.row-subtotal').textContent = formatVND(subtotal);
        total += subtotal;
    });
    document.getElementById('grandTotal').textContent = formatVND(total);
}

function updateRowNumbers() {
    Array.from(document.querySelectorAll('#detailBody .row-num')).forEach(function (el, i) {
        el.textContent = i + 1;
    });
}

function addRow() {
    var clone = document.getElementById('rowTemplate').content.cloneNode(true);
    document.getElementById('detailBody').appendChild(clone);
    updateRowNumbers();
    updateTotal();
}

function removeRow(btn) {
    var tbody = document.getElementById('detailBody');
    if (tbody.querySelectorAll('tr').length <= 1) return;
    btn.closest('tr').remove();
    updateRowNumbers();
    updateTotal();
}

function validateForm() {
    var wh = document.getElementById('warehouseId').value;
    var sup = document.getElementById('sdHiddenId').value;
    if (!wh) { toast(MSG.SEL_WAREHOUSE, 'danger'); return false; }
    if (!sup) { toast(MSG.SEL_SUPPLIER, 'danger'); return false; }

    var dataRows = document.querySelectorAll('#detailBody tr');
    var hasValid = false;
    var firstBad = null;
    for (var i = 0; i < dataRows.length; i++) {
        var tr = dataRows[i];
        var sel = tr.querySelector('.gen-select');
        var qtyEl = tr.querySelector('.qty-input');
        var upEl  = tr.querySelector('.unit-price-input');
        var qty = parseInt((qtyEl.value || '').replace(/[^0-9]/g, ''), 10);
        var upStr = (upEl.value || '').replace(/[^\d]/g, '');
        var up = parseInt(upStr, 10);
        if (sel && sel.value) {
            if (!qty || qty < 1) {
                if (!firstBad) firstBad = { el: qtyEl, msg: MSG.QTY_ROW + (i + 1) + MSG.GT_ZERO };
            } else if (!upStr || up <= 0) {
                if (!firstBad) firstBad = { el: upEl, msg: MSG.DG_ROW + (i + 1) + MSG.GT_ZERO };
            } else {
                hasValid = true;
            }
        }
    }
    if (firstBad) {
        toast(firstBad.msg, 'danger');
        firstBad.el.focus();
        if (typeof firstBad.el.select === 'function') firstBad.el.select();
        return false;
    }
    if (!hasValid) { toast(MSG.SEL_ONE_GEN, 'danger'); return false; }

    Array.from(document.querySelectorAll('.unit-price-input')).forEach(function (el) {
        el.value = el.value.replace(/[^\d]/g, '');
    });
    return true;
}

function refreshSupplierCard() {
    var container = document.getElementById('customerCardContainer');
    var picker = document.getElementById('custPicker');
    if (!container) return;

    var hid = document.getElementById('sdHiddenId');
    var supId = hid ? hid.value : '';

    if (!supId || !supId.trim()) {
        container.style.display = 'none';
        if (picker) picker.style.display = '';
        return;
    }

    if (picker) picker.style.display = 'none';
    container.style.display = '';

    var nameVal = document.getElementById('inpCustName').value || '';
    var phoneVal = document.getElementById('inpCustPhone').value || '';
    var emailVal = document.getElementById('inpCustEmail').value || '';
    var companyVal = document.getElementById('customerCompany').value || '';

    var html = '<div class="cic-header">';
    html += '<span class="cic-name">' + htmlEsc(nameVal) + '</span>';
    html += '<div class="cic-actions">';
    html += '<button type="button" class="cic-btn-remove" onclick="clearCustomerSelection();refreshSupplierCard();" title="H\u1ee7y ch\u1ecdn nh\u00e0 cung c\u1ea5p" aria-label="H\u1ee7y ch\u1ecdn">';
    html += '<svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>';
    html += '</button>';
    html += '</div></div>';
    html += '<div class="cic-details">';
    if (phoneVal) {
        html += '<span class="cic-detail-item">'
            + '<svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>'
            + htmlEsc(phoneVal) + '</span>';
    }
    if (companyVal) {
        html += '<span class="cic-detail-item">'
            + '<svg viewBox="0 0 24 24"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>'
            + htmlEsc(companyVal) + '</span>';
    }
    if (emailVal) {
        html += '<span class="cic-detail-item">'
            + '<svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>'
            + htmlEsc(emailVal) + '</span>';
    }
    html += '</div>';
    container.innerHTML = html;
}

function openNewGeneratorModal() {
    ['ngModel', 'ngPower', 'ngFreq', 'ngWeight', 'ngBrandId', 'ngOriginId', 'ngConditionId', 'ngFuelTypeId', 'ngPhaseId', 'ngGenTypeId']
        .forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
    var err = document.getElementById('genModalError');
    err.classList.remove('show');
    err.textContent = '';
    document.getElementById('genModalOverlay').classList.add('show');
}

function closeNewGeneratorModal() {
    document.getElementById('genModalOverlay').classList.remove('show');
}

function saveNewGenerator() {
    var model = document.getElementById('ngModel').value.trim();
    var power = document.getElementById('ngPower').value.trim();
    if (!model || !power) {
        var err = document.getElementById('genModalError');
        err.textContent = MSG.ERR_MODEL_INFO;
        err.classList.add('show');
        return;
    }
    var btn = document.getElementById('ngSaveBtn');
    btn.disabled = true;
    btn.textContent = MSG.SAVING;
    var fd = new FormData();
    fd.append('action', 'quickCreateGenerator');
    fd.append('model', model);
    fd.append('powerRating', power);
    fd.append('frequency', document.getElementById('ngFreq').value.trim());
    fd.append('weight', document.getElementById('ngWeight').value.trim());
    fd.append('brandId', document.getElementById('ngBrandId').value);
    fd.append('originId', document.getElementById('ngOriginId').value);
    fd.append('conditionId', document.getElementById('ngConditionId').value);
    fd.append('fuelTypeId', document.getElementById('ngFuelTypeId').value);
    fd.append('phaseId', document.getElementById('ngPhaseId').value);
    fd.append('genTypeId', document.getElementById('ngGenTypeId').value);
    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false;
            btn.textContent = MSG.SAVE_GEN;
            if (!data.ok) {
                var err = document.getElementById('genModalError');
                err.textContent = data.error || MSG.ERR;
                err.classList.add('show');
                return;
            }
            Array.from(document.querySelectorAll('#detailBody .gen-select')).forEach(function (sel) {
                var exists = false;
                for (var i = 0; i < sel.options.length; i++) {
                    if (sel.options[i].value == data.id) { exists = true; break; }
                }
                if (!exists) {
                    var opt = document.createElement('option');
                    opt.value = data.id;
                    opt.text = data.model;
                    sel.appendChild(opt);
                }
            });
            closeNewGeneratorModal();
            if (typeof toast !== 'undefined') {
                toast(
                    data.existing ? MSG.EXIST_GEN_PREFIX + data.model + MSG.EXIST_GEN_SUFFIX : MSG.ADDED_GEN_PREFIX + data.model + MSG.ADDED_GEN_SUFFIX,
                    data.existing ? 'info' : 'success'
                );
            }
        })
        .catch(function () {
            btn.disabled = false;
            btn.textContent = MSG.SAVE_GEN;
            var err = document.getElementById('genModalError');
            err.textContent = MSG.CONN_ERR;
            err.classList.add('show');
        });
}

function openNewSupplierModal() {
    ['nsName', 'nsPhone', 'nsEmail', 'nsCompanyName', 'nsAddress', 'nsTypeId'].forEach(function (id) {
        var el = document.getElementById(id);
        if (el) el.value = '';
    });
    var err = document.getElementById('supModalError');
    err.classList.remove('show');
    err.textContent = '';
    document.getElementById('supModalOverlay').classList.add('show');
}

function closeNewSupplierModal() {
    document.getElementById('supModalOverlay').classList.remove('show');
}

function triggerImportExcel() {
    var whEl = document.getElementById('warehouseId');
    var supEl = document.getElementById('sdHiddenId');
    if (!whEl || !whEl.value) {
        toast(MSG.SEL_WAREHOUSE, 'danger');
        return;
    }
    if (!supEl || !supEl.value) {
        toast(MSG.SEL_SUPPLIER, 'danger');
        return;
    }
    document.getElementById('importExcelFile').value = '';
    document.getElementById('importExcelFile').click();
}

function uploadExcelFile(input) {
    if (!input.files || input.files.length === 0) return;
    var fd = new FormData();
    fd.append('excelFile', input.files[0]);
    fd.append('warehouseId', document.getElementById('warehouseId').value);
    fd.append('supplierId', document.getElementById('sdHiddenId').value);
    fd.append('note', (document.getElementById('note') || {}).value || '');
    fd.append('ajax', '1');
    fetch(window.APP_CTX + '/proposal?action=importExcel', {
        method: 'POST',
        body: fd,
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(function (r) { return r.json(); })
    .then(function (data) {
        if (!data.success) {
            toast(data.message || 'Lá»—i khÃ´ng xÃ¡c Ä‘á»‹nh', 'danger');
            return;
        }
        if (data.invalidCount > 0) {
            data.rows.forEach(function (r) {
                if (r.error) toast('Dong ' + r.stt + ': ' + r.error, 'danger');
            });
            return;
        }
        if (data.rows && data.rows.length > 0) {
            applyExcelRows(data.rows);
        }
        toast(data.message, 'success');
    })
    .catch(function () {
        toast('Lá»—i káº¿t ná»‘i hoáº·c server khÃ´ng pháº£n há»“i dá»¯ liá»‡u há»£p lá»‡.', 'danger');
    });
}

function applyExcelRows(rows) {
    var tbody = document.getElementById('detailBody');
    while (tbody.firstChild) tbody.removeChild(tbody.firstChild);
    var added = 0;
    rows.forEach(function (row) {
        if (row.error) return;
        var clone = document.getElementById('rowTemplate').content.cloneNode(true);
        var tr = clone.querySelector('tr');
        var sel = tr.querySelector('.gen-select');
        if (sel && row.generatorId) {
            for (var i = 0; i < sel.options.length; i++) {
                if (sel.options[i].value == row.generatorId) {
                    sel.value = row.generatorId;
                    break;
                }
            }
        }
        var qtyInput = tr.querySelector('.qty-input');
        if (qtyInput && row.quantity) qtyInput.value = row.quantity;
        var upInput = tr.querySelector('.unit-price-input');
        if (upInput && row.unitPrice) {
            var n = parseInt(row.unitPrice) || 0;
            upInput.value = n > 0 ? String(n) : '0';
        }
        tbody.appendChild(tr);
        if (sel) updateStockCell(sel);
        added++;
    });
    if (added > 0) {
        updateRowNumbers();
        updateTotal();
    }
}

function saveNewSupplier() {
    var name = document.getElementById('nsName').value.trim();
    var phone = document.getElementById('nsPhone').value.trim();
    if (!name || !/^[0-9]{10,11}$/.test(phone)) {
        var err = document.getElementById('supModalError');
        err.textContent = MSG.ERR_CONTACT;
        err.classList.add('show');
        return;
    }
    var btn = document.getElementById('nsSaveBtn');
    btn.disabled = true;
    btn.textContent = MSG.SAVING;
    var fd = new FormData();
    fd.append('action', 'quickCreateSupplier');
    fd.append('name', name);
    fd.append('phone', phone);
    fd.append('email', document.getElementById('nsEmail').value.trim());
    fd.append('address', document.getElementById('nsAddress').value.trim());
    fd.append('companyName', document.getElementById('nsCompanyName').value.trim());
    fd.append('supplierTypeId', document.getElementById('nsTypeId').value);
    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false;
            btn.textContent = MSG.SAVE_SUP;
            if (!data.ok) {
                var err = document.getElementById('supModalError');
                err.textContent = data.error || MSG.ERR;
                err.classList.add('show');
                return;
            }
            document.getElementById('sdHiddenId').value = data.id;
            document.getElementById('inpCustName').value = data.name || '';
            document.getElementById('inpCustPhone').value = data.phone || '';
            document.getElementById('customerCompany').value = data.companyName || '';
            var label = document.getElementById('custTriggerLabel');
            label.textContent = data.name || data.phone || '';
            label.classList.add('has-value');
            closeNewSupplierModal();
            refreshSupplierCard();
            if (typeof toast !== 'undefined') {
                toast(
                    data.existing ? MSG.EXIST_SUP_PREFIX + data.name + MSG.EXIST_SUP_SUFFIX : MSG.ADDED_SUP_PREFIX + data.name + MSG.ADDED_SUP_SUFFIX,
                    data.existing ? 'info' : 'success'
                );
            }
        })
        .catch(function () {
            btn.disabled = false;
            btn.textContent = MSG.SAVE_SUP;
            var err = document.getElementById('supModalError');
            err.textContent = MSG.CONN_ERR;
            err.classList.add('show');
        });
}

var origClearSelection = window.clearCustomerSelection;
window.clearCustomerSelection = function () {
    if (typeof origClearSelection === 'function') origClearSelection();
    refreshSupplierCard();
};

document.addEventListener('DOMContentLoaded', function () {
    Array.from(document.querySelectorAll('#detailBody .gen-select')).forEach(function (sel) {
        updateStockCell(sel);
    });
    updateTotal();

    var list = document.getElementById('custList');
    if (list) {
        list.addEventListener('click', function () {
            setTimeout(refreshSupplierCard, 0);
        });
    }
    refreshSupplierCard();
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        if (typeof closeCustomerPanel === 'function') closeCustomerPanel();
        closeNewGeneratorModal();
        closeNewSupplierModal();
    }
});

