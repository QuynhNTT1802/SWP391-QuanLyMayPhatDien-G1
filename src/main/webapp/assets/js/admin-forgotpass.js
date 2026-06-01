
function toggleTheme() {
    const html = document.documentElement;
    const current = html.getAttribute('data-theme');
    html.setAttribute('data-theme', current === 'dark' ? 'light' : 'dark');
}
document.getElementById('themeToggle').addEventListener('click', toggleTheme);

const resetModal = document.getElementById('resetModal');
function openModal(id, username) {
    resetModal.classList.add('open');
    document.getElementById('requestId').value = id;
    document.getElementById('username').value = username;
}
function closeModal() {
    resetModal.classList.remove('open');
}

const detailModal = document.getElementById('detailModal');
function openDetailModal(username, status, note, processedAt) {
    detailModal.classList.add('open');
    document.getElementById('detailUsername').value = username;
    document.getElementById('detailStatus').value = status === 'approved' ? '\u0110\u00e3 c\u1ea5p l\u1ea1i' : status;
    document.getElementById('detailNote').value = note || '';
    document.getElementById('detailProcessedAt').value = processedAt || '';
}
function closeDetailModal() {
    detailModal.classList.remove('open');
}

window.addEventListener('click', e => {
    if (e.target === resetModal)
        closeModal();
    if (e.target === detailModal)
        closeDetailModal();
});
