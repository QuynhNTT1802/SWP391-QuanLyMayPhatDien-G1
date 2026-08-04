document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        if (typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        } else {
            alert(window.SESSION_DATA.message);
        }
    }

    var detailRows = document.querySelectorAll('tr[data-gen]');
    var grandTotalEl = document.getElementById('grandTotal');
    var grandQtyEl = document.getElementById('grandQty');

    function parsePrice(str) {
        if (!str) return 0;
        var cleaned = String(str).replace(/[^\d.]/g, '');
        var n = parseFloat(cleaned);
        return isNaN(n) ? 0 : n;
    }

    function fmtMoney(n) {
        if (!isFinite(n)) n = 0;
        return n.toLocaleString('vi-VN');
    }

    function recalc() {
        var perGen = {};
        var totalQty = 0;
        var totalMoney = 0;
        detailRows.forEach(function (row) {
            var gen = row.getAttribute('data-gen');
            if (!gen) return;
            var qtyInp = row.querySelector('input[name="finalQuantity"]');
            var priceInp = row.querySelector('input[name="unitPrice"]');
            var noteInp = row.querySelector('input[name="detailNote"]');
            var v = parseInt(qtyInp ? qtyInp.value : '', 10);
            var safeQty = isNaN(v) || v < 0 ? 0 : v;
            var price = parsePrice(priceInp ? priceInp.value : '');
            var note = (noteInp && noteInp.value || '').trim();
            if (!perGen[gen]) perGen[gen] = {qty: 0, money: 0, price: price, note: ''};
            perGen[gen].qty += safeQty;
            perGen[gen].money += safeQty * price;
            if (price > 0) perGen[gen].price = price;
            if (note) perGen[gen].note = note;
            totalQty += safeQty;
            totalMoney += safeQty * price;
        });
        document.querySelectorAll('.agg-qty').forEach(function (el) {
            var g = el.getAttribute('data-gen');
            if (perGen[g]) el.textContent = perGen[g].qty;
        });
        document.querySelectorAll('.agg-price').forEach(function (el) {
            var g = el.getAttribute('data-gen');
            if (perGen[g] && perGen[g].price > 0) {
                el.textContent = fmtMoney(perGen[g].price);
            } else {
                el.textContent = '\u2014';
            }
        });
        document.querySelectorAll('.agg-row-total').forEach(function (el) {
            var g = el.getAttribute('data-gen');
            if (perGen[g]) el.textContent = fmtMoney(perGen[g].money);
        });
        document.querySelectorAll('.agg-note').forEach(function (el) {
            var g = el.getAttribute('data-gen');
            var n = perGen[g] ? perGen[g].note : '';
            el.textContent = n ? n : '\u2014';
            el.classList.toggle('has-text', !!n);
        });
        if (grandQtyEl) grandQtyEl.textContent = totalQty;
        if (grandTotalEl) grandTotalEl.textContent = fmtMoney(totalMoney);
    }

    detailRows.forEach(function (row) {
        ['finalQuantity', 'unitPrice', 'detailNote'].forEach(function (n) {
            var inp = row.querySelector('input[name="' + n + '"]');
            if (inp && inp.type !== 'hidden') inp.addEventListener('input', recalc);
        });
    });
    recalc();

    var reviewForm = document.querySelector('form[action*="submitReviewCreate"]');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function (e) {
            var missingPriceRows = [];
            var firstErrorRow = null;
            detailRows.forEach(function (row) {
                var qtyInp = row.querySelector('input[name="finalQuantity"]');
                var priceInp = row.querySelector('input[name="unitPrice"]');
                if (!qtyInp) return;
                var priceVal = priceInp ? priceInp.value.trim() : '';
                if (!priceVal || parsePrice(priceVal) <= 0) {
                    missingPriceRows.push(row);
                    if (!firstErrorRow) firstErrorRow = row;
                }
            });
            if (missingPriceRows.length > 0) {
                e.preventDefault();
                alert('Có ' + missingPriceRows.length + ' dòng máy chưa có đơn giá (ô viền đỏ).\nVui lòng nhập đơn giá trước khi tạo phiếu mua.');
                if (firstErrorRow) {
                    firstErrorRow.scrollIntoView({behavior: 'smooth', block: 'center'});
                }
                return;
            }
        });
    }
});
