document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        if (typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        } else {
            alert(window.SESSION_DATA.message);
        }
    }

    var selectAll = document.getElementById('selectAll');
    var rowChecks = document.querySelectorAll('.row-check:not(:disabled)');
    var groupBtn = document.getElementById('groupBtn');
    var tickedCountEl = document.getElementById('tickedCount');
    var reviewForm = document.getElementById('reviewForm');

    function updateCount() {
        var ticked = document.querySelectorAll('.row-check:checked').length;
        tickedCountEl.textContent = ticked;
        if (groupBtn) {
            if (ticked > 0) {
                groupBtn.classList.add('show');
            } else {
                groupBtn.classList.remove('show');
            }
        }
        if (selectAll) {
            var enabledCount = rowChecks.length;
            selectAll.checked = enabledCount > 0 && ticked === enabledCount;
            selectAll.indeterminate = ticked > 0 && ticked < enabledCount;
        }
    }

    if (selectAll) {
        selectAll.addEventListener('change', function () {
            rowChecks.forEach(function (cb) {
                cb.checked = selectAll.checked;
            });
            updateCount();
        });
    }

    rowChecks.forEach(function (cb) {
        cb.addEventListener('change', updateCount);
    });

    if (reviewForm) {
        reviewForm.addEventListener('submit', function (e) {
            var ticked = document.querySelectorAll('.row-check:checked');
            if (ticked.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất 1 phiếu đề xuất');
                return;
            }
            var firstPeriod = ticked[0].getAttribute('data-period');
            var firstWarehouse = ticked[0].getAttribute('data-warehouse');
            var firstLabel = ticked[0].closest('tr').querySelector('.order-code').textContent.trim();
            for (var i = 1; i < ticked.length; i++) {
                var p = ticked[i].getAttribute('data-period');
                var w = ticked[i].getAttribute('data-warehouse');
                if (p !== firstPeriod || w !== firstWarehouse) {
                    e.preventDefault();
                    var lbl = ticked[i].closest('tr').querySelector('.order-code').textContent.trim();
                    alert('Không thể gom các phiếu khác tháng hoặc khác kho.\n\n'
                            + 'Phiếu gốc: ' + firstLabel + ' (tháng ' + firstPeriod + ')\n'
                            + 'Phiếu khác: ' + lbl + ' (tháng ' + p + ')');
                    return;
                }
            }
        });
    }
});
