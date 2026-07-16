(function (global) {
    'use strict';

    var APP_CTX = (typeof window.APP_CTX === 'string' && window.APP_CTX) ? window.APP_CTX : '';

    function post(action, params) {
        var body = new URLSearchParams();
        for (var k in params) {
            if (Object.prototype.hasOwnProperty.call(params, k) && params[k] !== null && params[k] !== undefined) {
                body.append(k, params[k]);
            }
        }
        return fetch(APP_CTX + '/export-receipt?action=' + encodeURIComponent(action), {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: body.toString()
        }).then(function (r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        });
    }

    function removeScannedSerial(receiptId, inventoryId) {
        return post('removeScannedSerial', { receiptId: receiptId, inventoryId: inventoryId });
    }

    function cancelPending(receiptId) {
        return post('cancelPending', { receiptId: receiptId });
    }

    function ensureModal(id, title, body, confirmLabel, danger) {
        var host = document.getElementById(id);
        if (!host) {
            host = document.createElement('div');
            host.id = id;
            host.className = 'modal-host';
            host.innerHTML = ''
                + '<div class="modal-card">'
                + '  <h3></h3>'
                + '  <div class="modal-sub"></div>'
                + '  <div class="modal-actions">'
                + '    <button type="button" class="btn cancel-btn">Huỷ</button>'
                + '    <button type="button" class="btn confirm-btn"></button>'
                + '  </div>'
                + '</div>';
            document.body.appendChild(host);
        }
        host.querySelector('h3').textContent = title;
        host.querySelector('.modal-sub').innerHTML = body;
        var confirmBtn = host.querySelector('.confirm-btn');
        confirmBtn.textContent = confirmLabel || 'Xác nhận';
        if (danger) confirmBtn.classList.add('btn-danger'); else confirmBtn.classList.remove('btn-danger');
        return host;
    }

    function confirmAction(opts) {
        var modal = ensureModal(opts.modalId || 'confirmModalGeneric', opts.title, opts.body, opts.confirmLabel, !!opts.danger);
        return new Promise(function (resolve, reject) {
            var close = function () { modal.classList.remove('show'); modal.style.display = 'none'; };
            var cancelBtn = modal.querySelector('.cancel-btn');
            var confirmBtn = modal.querySelector('.confirm-btn');
            function cleanup() {
                cancelBtn.onclick = null;
                confirmBtn.onclick = null;
            }
            cancelBtn.onclick = function () { cleanup(); close(); reject(new Error('cancelled')); };
            confirmBtn.onclick = function () {
                cleanup();
                close();
                resolve();
            };
            modal.style.display = 'flex';
            requestAnimationFrame(function () { modal.classList.add('show'); });
        });
    }

    function releaseRow(rowEl) {
        if (!rowEl) return Promise.resolve({ success: true });
        var invId = parseInt(rowEl.getAttribute('data-inventory-id') || '0', 10);
        var receiptId = parseInt(rowEl.getAttribute('data-receipt-id') || document.getElementById('receiptIdField').value || '0', 10);
        if (!invId || !receiptId) return Promise.resolve({ success: true });
        return removeScannedSerial(receiptId, invId);
    }

    global.ExportScannerActions = {
        removeScannedSerial: removeScannedSerial,
        cancelPending: cancelPending,
        confirmAction: confirmAction,
        releaseRow: releaseRow
    };
})(window);
