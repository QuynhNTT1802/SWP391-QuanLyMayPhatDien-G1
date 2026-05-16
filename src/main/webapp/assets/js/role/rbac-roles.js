document.addEventListener('DOMContentLoaded', function () {
    var searchInput = document.getElementById('roleSearch');
    var grid = document.getElementById('rolesGrid');
    var countEl = document.getElementById('searchCount');
    if (!searchInput || !grid) return;

    searchInput.addEventListener('input', function () {
        var query = this.value.toLowerCase().trim();
        var cards = grid.querySelectorAll('.role-card');
        var visibleCount = 0;

        cards.forEach(function (card) {
            var name = card.querySelector('h3');
            var desc = card.querySelector('.desc');
            var nameText = name ? name.textContent.toLowerCase() : '';
            var descText = desc ? desc.textContent.toLowerCase() : '';
            var match = nameText.indexOf(query) !== -1 || descText.indexOf(query) !== -1;

            card.style.display = match ? '' : 'none';
            if (match) visibleCount++;
        });

        if (countEl) {
            countEl.textContent = query ? visibleCount + ' / ' + cards.length + ' vai tro' : '';
        }
    });
});
