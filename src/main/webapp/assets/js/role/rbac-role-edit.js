document.addEventListener('DOMContentLoaded', function () {
    var pane = document.getElementById('permPane');
    if (!pane) return;

    var tree = document.getElementById('permTree');
    var detail = document.getElementById('permDetail');
    var detailEmpty = document.getElementById('permDetailEmpty');
    var treeEmpty = document.getElementById('permTreeEmpty');

    function activateFeature(key) {
        var btns = tree.querySelectorAll('.perm-tree-feature');
        var panes = detail.querySelectorAll('.perm-detail-pane');
        btns.forEach(function (b) { b.classList.toggle('is-active', b.getAttribute('data-feature-key') === key); });
        panes.forEach(function (p) { p.classList.toggle('is-active', p.getAttribute('data-feature-key') === key); });
        if (detailEmpty) detailEmpty.style.display = 'none';
    }

    function refreshFeatureCount(featureKey) {
        var btn = tree.querySelector('.perm-tree-feature[data-feature-key="' + cssEscape(featureKey) + '"]');
        var paneEl = detail.querySelector('.perm-detail-pane[data-feature-key="' + cssEscape(featureKey) + '"]');
        if (!btn || !paneEl) return;
        var boxes = paneEl.querySelectorAll('input[type=checkbox][name="perIds"]');
        var checked = 0;
        boxes.forEach(function (cb) { if (cb.checked) checked++; });
        var total = boxes.length;
        var counter = btn.querySelector('.f-count');
        counter.textContent = checked + '/' + total;
        counter.classList.toggle('is-full', total > 0 && checked === total);
        counter.classList.toggle('is-partial', checked > 0 && checked < total);
    }

    function refreshModuleCount(moduleEl) {
        var feats = moduleEl.querySelectorAll('.perm-tree-feature');
        var checkedSum = 0, totalSum = 0;
        feats.forEach(function (b) {
            var c = b.querySelector('.f-count');
            var parts = (c.textContent || '0/0').split('/');
            checkedSum += parseInt(parts[0], 10) || 0;
            totalSum += parseInt(parts[1], 10) || 0;
        });
        var label = moduleEl.querySelector('.m-count');
        if (label) label.textContent = checkedSum + '/' + totalSum;
    }

    function refreshAllCounts() {
        tree.querySelectorAll('.perm-tree-feature').forEach(function (b) {
            refreshFeatureCount(b.getAttribute('data-feature-key'));
        });
        tree.querySelectorAll('.perm-tree-module').forEach(refreshModuleCount);
    }

    function cssEscape(v) {
        if (window.CSS && window.CSS.escape) return window.CSS.escape(v);
        return String(v).replace(/[^a-zA-Z0-9_-]/g, function (c) {
            return '\\' + c.charCodeAt(0).toString(16) + ' ';
        });
    }

    // Click feature -> activate
    tree.addEventListener('click', function (e) {
        var btn = e.target.closest('.perm-tree-feature');
        if (btn) {
            activateFeature(btn.getAttribute('data-feature-key'));
            return;
        }
        var head = e.target.closest('.perm-tree-module-head');
        if (head) {
            head.parentElement.classList.toggle('is-collapsed');
        }
    });

    // Toggle checkbox -> update visual + counts
    detail.addEventListener('change', function (e) {
        var cb = e.target;
        if (!cb || cb.type !== 'checkbox' || cb.name !== 'perIds') return;
        var label = cb.closest('.perm-check');
        if (label) label.classList.toggle('is-checked', cb.checked);
        var paneEl = cb.closest('.perm-detail-pane');
        if (paneEl) {
            var key = paneEl.getAttribute('data-feature-key');
            refreshFeatureCount(key);
            var moduleName = key.split('::')[0];
            var moduleEl = tree.querySelector('.perm-tree-module[data-module="' + cssEscape(moduleName) + '"]');
            if (moduleEl) refreshModuleCount(moduleEl);
        }
    });

    // Bulk buttons
    detail.addEventListener('click', function (e) {
        var btn = e.target.closest('button[data-bulk]');
        if (!btn) return;
        var paneEl = btn.closest('.perm-detail-pane');
        if (!paneEl) return;
        var on = btn.getAttribute('data-bulk') === 'all';
        paneEl.querySelectorAll('input[type=checkbox][name="perIds"]').forEach(function (cb) {
            if (cb.checked !== on) {
                cb.checked = on;
                var label = cb.closest('.perm-check');
                if (label) label.classList.toggle('is-checked', on);
            }
        });
        var key = paneEl.getAttribute('data-feature-key');
        refreshFeatureCount(key);
        var moduleName = key.split('::')[0];
        var moduleEl = tree.querySelector('.perm-tree-module[data-module="' + cssEscape(moduleName) + '"]');
        if (moduleEl) refreshModuleCount(moduleEl);
    });

    // Search filter (client-side over tree)
    var permSearch = document.getElementById('permSearch');
    if (permSearch) {
        permSearch.addEventListener('input', function () {
            var q = this.value.toLowerCase().trim();
            var anyVisible = false;
            tree.querySelectorAll('.perm-tree-module').forEach(function (mod) {
                var feats = mod.querySelectorAll('.perm-tree-feature');
                var moduleName = (mod.getAttribute('data-module') || '').toLowerCase();
                var moduleHit = !q || moduleName.indexOf(q) > -1;
                var visibleFeats = 0;
                feats.forEach(function (b) {
                    var name = (b.querySelector('.f-name').textContent || '').toLowerCase();
                    var hit = moduleHit || !q || name.indexOf(q) > -1;
                    b.classList.toggle('is-hidden', !hit);
                    if (hit) visibleFeats++;
                });
                mod.style.display = visibleFeats > 0 ? '' : 'none';
                if (visibleFeats > 0) anyVisible = true;
            });
            if (treeEmpty) treeEmpty.style.display = anyVisible ? 'none' : 'block';

            if (q) {
                var firstVisible = tree.querySelector('.perm-tree-feature:not(.is-hidden)');
                if (firstVisible) activateFeature(firstVisible.getAttribute('data-feature-key'));
            }
        });
    }

    refreshAllCounts();
});
