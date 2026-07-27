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
