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
        permSearch.addEventListener('input', function () {
            var query = this.value.toLowerCase().trim();
            var rows = permTable.querySelectorAll('.perm-row');
            rows.forEach(function (row) {
                var nameEl = row.querySelector('.res-name');
                var text = nameEl ? nameEl.textContent.toLowerCase() : '';
                row.style.display = text.indexOf(query) !== -1 ? '' : 'none';
            });
        });
    }
});
