(function () {
    'use strict';

    function getOriginalOptions(select) {
        if (!select._origOptions) {
            var arr = [];
            for (var i = 0; i < select.options.length; i++) {
                var o = select.options[i];
                arr.push({
                    value: o.value,
                    text: o.text,
                    isPlaceholder: (o.value === '')
                });
            }
            select._origOptions = arr;
        }
        return select._origOptions;
    }

    function applyFilter(select, query) {
        var q = (query || '').toLowerCase().trim();
        var orig = getOriginalOptions(select);
        var currentValue = select.value;
        var selectedStillVisible = false;

        while (select.options.length > 0) {
            select.remove(0);
        }

        for (var i = 0; i < orig.length; i++) {
            var o = orig[i];
            var matches = o.isPlaceholder || q === '' || (o.text.toLowerCase().indexOf(q) !== -1);
            if (matches) {
                var opt = new Option(o.text, o.value);
                select.add(opt);
                if (o.value === currentValue) {
                    selectedStillVisible = true;
                }
            }
        }

        if (selectedStillVisible) {
            select.value = currentValue;
        } else {
            select.value = '';
        }
    }

    function initGenSelectSearch(rootEl) {
        var scope = rootEl || document;
        var selects = scope.querySelectorAll ? scope.querySelectorAll('.gen-select') : [];
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            if (sel.dataset.searchInit === '1') continue;
            sel.dataset.searchInit = '1';

            var input = document.createElement('input');
            input.type = 'text';
            input.className = 'gen-search-input';
            input.placeholder = 'Tìm máy phát điện...';
            input.autocomplete = 'off';

            sel.parentNode.insertBefore(input, sel);

            input.addEventListener('input', function (e) {
                var s = e.target.nextElementSibling;
                if (s && s.classList && s.classList.contains('gen-select')) {
                    applyFilter(s, e.target.value);
                }
            });

            sel.addEventListener('change', function () {
                var prev = sel.previousElementSibling;
                if (prev && prev.classList && prev.classList.contains('gen-search-input')) {
                    prev.value = '';
                    applyFilter(sel, '');
                }
            });
        }
    }

    window.initGenSelectSearch = initGenSelectSearch;

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function () { initGenSelectSearch(); });
    } else {
        initGenSelectSearch();
    }
})();
