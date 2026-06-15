document.addEventListener('DOMContentLoaded', function () {
    var tree = document.getElementById('permTable');
    if (!tree) return;

    var readonly = tree.dataset.readonly === 'true';
    var allChips = Array.prototype.slice.call(tree.querySelectorAll('.perm-chip'));
    var allModules = Array.prototype.slice.call(tree.querySelectorAll('.perm-module'));
    var totalPerms = allChips.length;

    var initialState = {};
    allChips.forEach(function (chip) {
        var cb = chip.querySelector('input[type="checkbox"]');
        initialState[cb.value] = cb.checked;
    });

    if (readonly) {
        allChips.forEach(function (chip) {
            chip.style.pointerEvents = 'none';
            chip.style.opacity = '0.7';
        });
        var quickBtns = tree.querySelectorAll('.perm-module-quick, .perm-feature-quick');
        quickBtns.forEach(function (b) { b.disabled = true; b.style.opacity = '0.4'; b.style.cursor = 'not-allowed'; });
        var resetBtn = document.getElementById('permResetBtn');
        if (resetBtn) { resetBtn.disabled = true; resetBtn.style.opacity = '0.4'; }
    }

    function chipsOf(scope) {
        return Array.prototype.slice.call(scope.querySelectorAll('.perm-chip'));
    }

    function setChip(chip, on) {
        var cb = chip.querySelector('input[type="checkbox"]');
        if (cb.checked === on) return;
        cb.checked = on;
        chip.classList.toggle('on', on);
    }

    function refreshFeature(featureEl) {
        var chips = chipsOf(featureEl);
        var on = chips.filter(function (c) { return c.querySelector('input').checked; }).length;
        var countEl = featureEl.querySelector('[data-feature-count]');
        countEl.textContent = on + '/' + chips.length;
        countEl.classList.toggle('has', on > 0);
    }

    function refreshModule(moduleEl) {
        moduleEl.querySelectorAll('.perm-feature').forEach(refreshFeature);

        var chips = chipsOf(moduleEl);
        var on = chips.filter(function (c) { return c.querySelector('input').checked; }).length;
        var total = chips.length;
        var countEl = moduleEl.querySelector('[data-module-count]');
        countEl.textContent = on + '/' + total;
        countEl.classList.toggle('has', on > 0);

        var tri = moduleEl.querySelector('[data-module-tri]');
        var state = on === 0 ? 'none' : (on === total ? 'all' : 'some');
        tri.dataset.state = state;

        var quick = moduleEl.querySelector('[data-module-quick]');
        quick.textContent = (state === 'all') ? 'Bỏ tất cả' : 'Chọn tất cả';
    }

    function refreshAll() {
        var totalOn = 0;
        var modulesWithAny = 0;
        allModules.forEach(function (m) {
            refreshModule(m);
            var on = chipsOf(m).filter(function (c) { return c.querySelector('input').checked; }).length;
            totalOn += on;
            if (on > 0) modulesWithAny++;
        });
        document.getElementById('permCountSelected').textContent = totalOn;
        document.getElementById('permCountSelected2').textContent = totalOn;
        document.getElementById('permCountModules').textContent = modulesWithAny;

        var dirty = false;
        allChips.forEach(function (chip) {
            var cb = chip.querySelector('input');
            if (initialState[cb.value] !== cb.checked) dirty = true;
        });
        var dirtyEl = document.getElementById('permDirty');
        if (dirtyEl) dirtyEl.style.display = dirty ? '' : 'none';
    }

    tree.addEventListener('click', function (e) {
        if (readonly) return;

        var chip = e.target.closest('.perm-chip');
        if (chip && !e.target.closest('button')) {
            e.preventDefault();
            var cb = chip.querySelector('input[type="checkbox"]');
            setChip(chip, !cb.checked);
            var moduleEl = chip.closest('.perm-module');
            refreshModule(moduleEl);
            refreshAll();
            return;
        }

        var modQuick = e.target.closest('[data-module-quick]');
        if (modQuick) {
            e.preventDefault();
            e.stopPropagation();
            var moduleEl2 = modQuick.closest('.perm-module');
            var chipsM = chipsOf(moduleEl2);
            var allOn = chipsM.every(function (c) { return c.querySelector('input').checked; });
            chipsM.forEach(function (c) { setChip(c, !allOn); });
            refreshModule(moduleEl2);
            refreshAll();
            return;
        }

        var modTri = e.target.closest('[data-toggle-module]');
        if (modTri) {
            e.preventDefault();
            e.stopPropagation();
            var moduleEl3 = modTri.closest('.perm-module');
            var chipsT = chipsOf(moduleEl3);
            var allOnT = chipsT.every(function (c) { return c.querySelector('input').checked; });
            chipsT.forEach(function (c) { setChip(c, !allOnT); });
            refreshModule(moduleEl3);
            refreshAll();
            return;
        }

        var featQuick = e.target.closest('[data-feature-quick]');
        if (featQuick) {
            e.preventDefault();
            var feature = featQuick.closest('.perm-feature');
            var mode = featQuick.dataset.featureQuick;
            var chipsF = chipsOf(feature);
            chipsF.forEach(function (c) {
                if (mode === 'all') setChip(c, true);
                else if (mode === 'none') setChip(c, false);
                else if (mode === 'readonly') setChip(c, c.dataset.task === 'READ');
            });
            refreshModule(feature.closest('.perm-module'));
            refreshAll();
            return;
        }

        var bar = e.target.closest('.perm-module-bar');
        if (bar && !e.target.closest('button') && !e.target.closest('[data-toggle-module]')) {
            bar.closest('.perm-module').classList.toggle('collapsed');
        }
    });

    var resetBtn = document.getElementById('permResetBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', function () {
            if (readonly) return;
            allChips.forEach(function (chip) {
                var cb = chip.querySelector('input');
                setChip(chip, initialState[cb.value]);
            });
            refreshAll();
        });
    }

    var search = document.getElementById('permSearch');
    var emptyEl = document.getElementById('permEmpty');
    var clearSearchBtn = document.getElementById('permClearSearch');

    function applyFilter(needle) {
        needle = (needle || '').trim().toLowerCase();
        var anyVisible = false;
        allModules.forEach(function (moduleEl) {
            var moduleVisible = false;
            moduleEl.querySelectorAll('.perm-feature').forEach(function (feat) {
                var featureVisible = false;
                if (!needle) {
                    feat.style.display = '';
                    chipsOf(feat).forEach(function (c) { c.style.display = ''; });
                    featureVisible = true;
                } else {
                    var featNameMatch = feat.dataset.feature.toLowerCase().indexOf(needle) >= 0;
                    chipsOf(feat).forEach(function (c) {
                        var hay = c.dataset.permSearch || '';
                        var match = featNameMatch || hay.indexOf(needle) >= 0;
                        c.style.display = match ? '' : 'none';
                        if (match) featureVisible = true;
                    });
                    feat.style.display = featureVisible ? '' : 'none';
                }
                if (featureVisible) moduleVisible = true;
            });
            if (!needle) {
                moduleEl.style.display = '';
            } else {
                moduleEl.style.display = moduleVisible ? '' : 'none';
            }
            if (moduleVisible) anyVisible = true;
        });
        if (emptyEl) emptyEl.style.display = (needle && !anyVisible) ? '' : 'none';
    }

    if (search) {
        search.addEventListener('input', function () { applyFilter(this.value); });
        if (search.value) applyFilter(search.value);
    }
    if (clearSearchBtn) {
        clearSearchBtn.addEventListener('click', function () {
            if (search) { search.value = ''; applyFilter(''); search.focus(); }
        });
    }

    refreshAll();

    var form = document.getElementById('roleForm');
    if (form) {
        form.addEventListener('submit', function () {
            var dirtyEl = document.getElementById('permDirty');
            if (dirtyEl) dirtyEl.style.display = 'none';
        });
    }

    window.addEventListener('beforeunload', function (e) {
        if (readonly) return;
        var dirtyEl = document.getElementById('permDirty');
        if (dirtyEl && dirtyEl.style.display !== 'none') {
            e.preventDefault();
            e.returnValue = '';
        }
    });
});
