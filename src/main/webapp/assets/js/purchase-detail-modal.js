function openModal(id) {
    var m = document.getElementById(id);
    if (m) m.classList.add('show');
}
function closeModal(id) {
    var m = document.getElementById(id);
    if (m) m.classList.remove('show');
}
document.querySelectorAll('.modal-host').forEach(function (m) {
    m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
});

function showProposalModal(el) {
    document.getElementById('pm-code').textContent = el.getAttribute('data-proposal-code');
    document.getElementById('pm-creator').textContent = el.getAttribute('data-creator');
    document.getElementById('pm-date').textContent = el.getAttribute('data-date');
    document.getElementById('pm-supplier').textContent = el.getAttribute('data-supplier');
    document.getElementById('pm-status').textContent = el.getAttribute('data-status');
    document.getElementById('pm-details').textContent = el.getAttribute('data-total-details');
    document.getElementById('pm-qty').textContent = el.getAttribute('data-total-qty');
    document.getElementById('pm-detail-link').href = window.APP_CTX + '/proposal?action=detail&id=' + el.getAttribute('data-proposal-id');
    document.getElementById('proposalModal').classList.add('open');
}
function closeProposalModal() {
    document.getElementById('proposalModal').classList.remove('open');
}

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
        closeProposalModal();
    }
});
