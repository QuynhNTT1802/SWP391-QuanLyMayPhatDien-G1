document.addEventListener('DOMContentLoaded', function () {
    var permTable = document.getElementById('permTable');
    if (!permTable) return;

    permTable.addEventListener('click', function (e) {
        var toggle = e.target.closest('.perm-toggle');
        if (!toggle) return;

        var checkbox = toggle.querySelector('input[type="checkbox"]');
        checkbox.checked = !checkbox.checked;

        if (checkbox.checked) {
            toggle.classList.add('on');
        } else {
            toggle.classList.remove('on');
        }
    });

    var permSearch = document.getElementById('permSearch');
    if (permSearch) {
        permSearch.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                var urlParams = new URLSearchParams(window.location.search);
                var id = urlParams.get('id');
                var url = window.location.pathname;
                var params = [];
                if (id) params.push('id=' + encodeURIComponent(id));
                if (this.value.trim()) {
                    params.push('permSearch=' + encodeURIComponent(this.value.trim()));
                }
                if (params.length) url += '?' + params.join('&');
                window.location.href = url;
            }
        });
    }
});
