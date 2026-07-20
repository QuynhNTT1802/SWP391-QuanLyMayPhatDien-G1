(function () {
    var tabs = document.querySelectorAll('.tab-bar .tab');
    var panels = document.querySelectorAll('.tab-panel');
    tabs.forEach(function (t) {
        t.addEventListener('click', function (e) {
            var target = t.getAttribute('data-tab');
            if (target === 'history') {
                return;
            }
            e.preventDefault();
            tabs.forEach(function (x) { x.classList.remove('active'); });
            panels.forEach(function (p) { p.classList.remove('active'); });
            t.classList.add('active');
            var panel = document.querySelector('.tab-panel[data-panel="' + target + '"]');
            if (panel) panel.classList.add('active');
            if (window.history && window.history.pushState) {
                var url = window.location.href.split('?')[0];
                window.history.pushState({}, '', url);
            }
        });
    });

    var search = document.getElementById('poSearch');
    var table = document.getElementById('poTable');
    if (table) {
        var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr[data-row-id]'));
        function applyFilter() {
            var q = (search && search.value ? search.value : '').toLowerCase().trim();
            rows.forEach(function (r) {
                var haystack = (r.getAttribute('data-search') || '').toLowerCase();
                var matchText = !q || haystack.indexOf(q) !== -1;
                r.style.display = matchText ? '' : 'none';
            });
        }
        if (search) search.addEventListener('input', applyFilter);
        applyFilter();
    }
})();
