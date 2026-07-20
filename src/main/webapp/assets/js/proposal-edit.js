(function () {
    var label = document.getElementById('custTriggerLabel');
    if (label) {
        var nameVal = document.getElementById('inpCustName').value || '';
        var supId = document.getElementById('sdHiddenId').value || '';
        if (nameVal && supId) {
            label.textContent = nameVal;
            label.classList.add('has-value');
        }
    }
    if (typeof refreshSupplierCard === 'function') refreshSupplierCard();

    document.querySelectorAll('.unit-price-input').forEach(function (el) {
        var intPart = ((el.value || '').trim().split('.')[0] || '').replace(/[^\d]/g, '');
        el.value = intPart || '0';
    });
    if (typeof updateTotal === 'function') updateTotal();

    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        }
    });
})();
