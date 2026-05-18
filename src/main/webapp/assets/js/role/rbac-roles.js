document.addEventListener('DOMContentLoaded', function () {
    var searchInput = document.getElementById('roleSearch');
    if (!searchInput) return;

    var urlParams = new URLSearchParams(window.location.search);
    var searchValue = urlParams.get('search');
    if (searchValue) {
        searchInput.value = searchValue;
        searchInput.focus();
        searchInput.setSelectionRange(searchInput.value.length, searchInput.value.length);
    }
});
