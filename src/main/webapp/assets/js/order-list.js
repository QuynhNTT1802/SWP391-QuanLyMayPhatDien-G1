document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        if (typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        }
    }
});

function showCustomerModal(el) {
    event.stopPropagation();
    var id = el.getAttribute('data-cust-id') || '';
    var name = el.getAttribute('data-cust-name') || '—';
    var phone = el.getAttribute('data-cust-phone') || '—';
    var email = el.getAttribute('data-cust-email') || '';
    var address = el.getAttribute('data-cust-address') || '';
    var company = el.getAttribute('data-cust-company') || '';

    document.getElementById('cm-id').textContent = id || '—';
    document.getElementById('cm-name').textContent = name;
    document.getElementById('cm-phone').textContent = phone;
    document.getElementById('cm-email').textContent = email || '—';
    document.getElementById('cm-company').textContent = company || '—';
    document.getElementById('cm-address').textContent = address || '—';
    document.getElementById('cm-detail-link').href = window.APP_CTX + '/warehouse/customers?action=view&id=' + id;

    document.getElementById('customerModal').classList.add('open');
}
function closeCustomerModal() {
    document.getElementById('customerModal').classList.remove('open');
}
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        closeCustomerModal();
    }
});
