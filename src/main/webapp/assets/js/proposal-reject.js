function validateRejectForm() {
    var reason = document.getElementById('rejectReason').value.trim();
    if (reason.length < 5) {
        alert('Vui lòng nhập lý do từ chối (tối thiểu 5 ký tự).');
        document.getElementById('rejectReason').focus();
        return false;
    }
    return true;
}
