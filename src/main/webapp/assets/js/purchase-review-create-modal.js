function toggleCreator(el) {
    el.classList.toggle('open');
    var body = el.nextElementSibling;
    if (body) body.classList.toggle('open');
}
function toggleProposal(el) {
    el.classList.toggle('open');
    var body = el.nextElementSibling;
    if (body) body.classList.toggle('open');
}
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
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
    }
});
