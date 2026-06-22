<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sửa đơn thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Sửa đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / Sửa đơn #${liquidation.liquidationCode}</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết
            </a>

            <div class="page-head">
                <div class="eyebrow">Thanh lý · Cập nhật đơn thanh lý</div>
                <h2 class="page-title">Sửa đơn #${liquidation.liquidationCode}</h2>
            </div>

            <div class="form-layout form-layout--full">
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <c:if test="${not empty liquidation.managerFeedbackName}">
                        <div class="feedback-banner feedback-banner--from-mgr">
                            <div class="body">
                                <div class="feedback-banner__label">Phản hồi từ Quản lý kho</div>
                                <div class="feedback-banner__body">${liquidation.managerFeedbackName}</div>
                            </div>
                        </div>
                    </c:if>

                    <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                        <input type="hidden" name="action" value="edit_submit" />
                        <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
                        <input type="hidden" name="customerId" id="customerIdHidden" value="${liquidation.customerId}" />

                        <!-- SECTION 01: THÔNG TIN CHUNG -->
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="form-section-title">Kho hàng và Lý do thanh lý</h3>
                            </div>

                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Kho hàng <span class="req">*</span></label>
                                    <select class="input" name="warehouseId" id="warehouseId" required>
                                        <c:forEach var="w" items="${warehouses}">
                                            <option value="${w.warehouseId}" ${w.warehouseId == liquidation.warehouseId ? 'selected' : ''}>${w.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="field">
                                    <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                    <select class="input" name="reasonId" required>
                                        <c:forEach var="r" items="${reasons}">
                                            <option value="${r.id}" ${r.id == liquidation.reasonId ? 'selected' : ''}>${r.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- SECTION 02: CHỌN MÁY (List 1 cột + sticky bar) -->
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — CHỌN MÁY</div>
                                <h3 class="form-section-title">Chọn máy phát điện thanh lý</h3>
                            </div>

                            <div class="liq-pick">
                                <div class="liq-pick-tools">
                                    <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                                    <select id="serialAgeFilter" class="serial-sort-select" title="Lọc theo tuổi" style="display:none;">
                                        <option value="all" data-base="Tất cả">Tất cả</option>
                                        <option value="old" data-base="&ge; 12 tháng">&ge; 12 tháng</option>
                                        <option value="mid" data-base="6-12 tháng">6-12 tháng</option>
                                        <option value="fresh" data-base="&lt; 6 tháng">&lt; 6 tháng</option>
                                    </select>
                                    <select id="serialSortOrder" class="serial-sort-select" title="Sắp xếp">
                                        <option value="asc">Cũ nhất</option>
                                        <option value="desc">Mới nhất</option>
                                    </select>
                                </div>
                                <div class="liq-pick-body" id="pickBody">
                                    <div class="pick-empty" id="pickEmpty">Chọn Kho hàng ở mục 01 để xem máy có sẵn.</div>
                                </div>
                                <div class="liq-pick-bar">
                                    <div class="bar-summary">
                                        <div class="bar-count">Đã chọn <strong id="barSelectedCount">0</strong> máy<span id="barModelCount" style="color:var(--muted);font-weight:500;"></span></div>
                                        <div class="bar-total">Tổng giá gốc: <span class="total-val" id="formTotalVal">0 đ</span></div>
                                    </div>
                                    <div class="bar-actions">
                                        <a class="btn" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">Huỷ bỏ</a>
                                        <button type="submit" form="liquidationForm" class="btn btn-primary">
                                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                            Lưu &amp; Đề xuất lại
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div id="hiddenInputs"></div>

                            <%-- Preload máy đã chọn từ ${details} (data-attrs an toàn escape) --%>
                            <div id="initialCartData" style="display:none;">
                                <c:forEach var="d" items="${details}">
                                    <c:set var="modelName" value=""/>
                                    <c:forEach var="g" items="${generators}">
                                        <c:if test="${g.id == d.generatorId}">
                                            <c:set var="modelName" value="${g.model}"/>
                                        </c:if>
                                    </c:forEach>
                                    <span class="initial-cart-item"
                                          data-gen-id="${d.generatorId}"
                                          data-model="<c:out value='${modelName}'/>"
                                          data-unit-price="${d.originalPrice}"
                                          data-serial="<c:out value='${d.serialNumber}'/>"
                                          data-created-at="${d.createdAt}"></span>
                                </c:forEach>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>

    var selected = {};
    var warehouseStock = {};
    var lockedByGen = {};
    var currentAgeFilter = 'all';
    var collapsedGroups = {};

    // Máy đã có sẵn trong đơn (preload). Các serial này đang PENDING_LIQUIDATION
    // nên KHÔNG nằm trong kho IN_STOCK trả về từ AJAX -> phải merge thủ công.
    var preloaded = {};

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s).replace(/[&<>"\']/g, function(c) {
            return { '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "\'":'&#39;' }[c];
        });
    }
    function fmt(n) { return Number(n || 0).toLocaleString('vi-VN'); }
    function ageOf(ts) {
        if (!ts) return { cls: 'age-fresh', text: 'Chưa rõ' };
        var months = Math.floor((Date.now() - ts) / (1000 * 60 * 60 * 24 * 30));
        var cls = months >= 12 ? 'age-old' : (months >= 6 ? 'age-mid' : 'age-fresh');
        return { cls: cls, text: months + ' tháng' };
    }
    function tsOf(s) {
        if (!s) return 0;
        var d = new Date(s);
        return isNaN(d.getTime()) ? 0 : d.getTime();
    }
    function dateStrOf(s) {
        if (!s) return '';
        var d = new Date(s);
        if (isNaN(d.getTime())) return '';
        return String(d.getDate()).padStart(2,'0') + '/' + String(d.getMonth()+1).padStart(2,'0') + '/' + d.getFullYear();
    }
    function lockedStatusLabel(s) {
        switch (s) {
            case 'PENDING_MANAGER': return 'Chờ Quản lý duyệt';
            case 'PENDING_CEO': return 'Chờ CEO duyệt';
            case 'MANAGER_REQUEST_EDIT': return 'Quản lý yêu cầu sửa';
            case 'CEO_REQUEST_EDIT': return 'CEO yêu cầu sửa';
            default: return 'Đang xử lý';
        }
    }

    function isSelected(gid, serial) {
        return !!(selected[gid] && selected[gid].items[serial]);
    }
    function toggleSelect(gid, grp, item) {
        if (!selected[gid]) {
            selected[gid] = { model: grp.model, unitPrice: grp.unitPrice, items: {} };
        }
        if (selected[gid].items[item.serial]) {
            delete selected[gid].items[item.serial];
            if (Object.keys(selected[gid].items).length === 0) delete selected[gid];
        } else {
            selected[gid].items[item.serial] = { serial: item.serial, createdAt: item.createdAt };
        }
    }

    function render() {
        var body = document.getElementById('pickBody');
        var hidden = document.getElementById('hiddenInputs');
        body.innerHTML = '';
        hidden.innerHTML = '';

        var query = (document.getElementById('serialSearchInput').value || '').toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;
        var keys = Object.keys(warehouseStock);

        var totalAvail = 0, cOld = 0, cMid = 0, cFresh = 0;
        var totalSelected = 0, totalPrice = 0;
        var anyRendered = false;

        keys.forEach(function(gid) {
            var grp = warehouseStock[gid];
            var items = (grp.items || []).slice();
            var lockedHere = lockedByGen[gid] || [];

            var modelMatch = (grp.model || '').toLowerCase().indexOf(query) > -1;
            var filtered = items.filter(function(it) {
                if (modelMatch || !query) return true;
                return (it.serial || '').toLowerCase().indexOf(query) > -1;
            }).filter(function(it) {
                if (currentAgeFilter === 'all') return true;
                var age = ageOf(tsOf(it.createdAt)).cls;
                return (currentAgeFilter === 'old' && age === 'age-old')
                    || (currentAgeFilter === 'mid' && age === 'age-mid')
                    || (currentAgeFilter === 'fresh' && age === 'age-fresh');
            });
            filtered.sort(function(a, b) {
                var ta = tsOf(a.createdAt), tb = tsOf(b.createdAt);
                return sortOrder === 'desc' ? tb - ta : ta - tb;
            });

            // tính count theo all (không phụ thuộc filter) cho summary chips
            items.forEach(function(it) {
                var age = ageOf(tsOf(it.createdAt)).cls;
                if (age === 'age-old') cOld++;
                else if (age === 'age-mid') cMid++;
                else cFresh++;
                totalAvail++;
            });

            if (filtered.length === 0 && lockedHere.length === 0) return;
            anyRendered = true;

            var selCount = 0;
            filtered.forEach(function(it) { if (isSelected(gid, it.serial)) selCount++; });

            var group = document.createElement('div');
            group.className = 'pick-group' + (collapsedGroups[gid] ? ' is-collapsed' : '');

            var head = document.createElement('div');
            head.className = 'pick-group-head';
            var allOn = filtered.length > 0 && selCount === filtered.length;
            head.innerHTML =
                '<svg class="chev" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>'
                + '<span class="model">' + escapeHtml(grp.model) + '</span>'
                + '<span class="count">' + selCount + '/' + filtered.length + ' máy</span>'
                + (filtered.length > 0
                    ? '<button type="button" class="pick-all' + (allOn ? ' is-all-on' : '') + '">' + (allOn ? 'Bỏ tất cả' : 'Chọn tất cả') + '</button>'
                    : '');
            head.addEventListener('click', function(e) {
                if (e.target.closest('.pick-all')) return;
                collapsedGroups[gid] = !collapsedGroups[gid];
                render();
            });
            var pickAllBtn = head.querySelector('.pick-all');
            if (pickAllBtn) {
                pickAllBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    if (allOn) {
                        filtered.forEach(function(it) {
                            if (isSelected(gid, it.serial)) toggleSelect(gid, grp, it);
                        });
                    } else {
                        filtered.forEach(function(it) {
                            if (!isSelected(gid, it.serial)) toggleSelect(gid, grp, it);
                        });
                    }
                    render();
                });
            }
            group.appendChild(head);

            var groupBody = document.createElement('div');
            groupBody.className = 'pick-group-body';

            filtered.forEach(function(it) {
                var ts = tsOf(it.createdAt);
                var age = ageOf(ts);
                var checked = isSelected(gid, it.serial);
                var price = parseFloat(grp.unitPrice || 0) || 0;

                var row = document.createElement('label');
                row.className = 'pick-row ' + age.cls + (checked ? ' is-checked' : '');
                row.innerHTML =
                    '<input type="checkbox" class="pick-cb"' + (checked ? ' checked' : '') + '/>'
                    + '<span class="age-dot"></span>'
                    + '<span class="row-serial">' + escapeHtml(it.serial) + '</span>'
                    + '<span class="row-age">' + age.text + '</span>'
                    + '<span class="row-date">' + dateStrOf(it.createdAt) + '</span>'
                    + '<span class="row-price">' + fmt(price) + ' đ</span>';
                row.querySelector('.pick-cb').addEventListener('change', function() {
                    toggleSelect(gid, grp, it);
                    render();
                });
                groupBody.appendChild(row);
            });

            // Locked rows
            lockedHere.forEach(function(l) {
                var row = document.createElement('div');
                row.className = 'pick-row is-locked';
                var ctx = '${pageContext.request.contextPath}';
                row.innerHTML =
                    '<svg class="lock-icon" viewBox="0 0 24 24"><rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V7a4 4 0 1 1 8 0v4"/></svg>'
                    + '<span class="age-dot" style="background:#f59e0b;"></span>'
                    + '<span class="row-locked-info">'
                    + '<span style="font-family:var(--font-mono);font-weight:700;color:#92400e;">' + escapeHtml(l.serialNumber) + '</span>'
                    + '<span>·</span>'
                    + '<span>' + lockedStatusLabel(l.liquidationStatus) + '</span>'
                    + '<a class="mono" href="' + ctx + '/liquidations?action=detail&id=' + encodeURIComponent(l.liquidationId) + '" target="_blank">' + escapeHtml(l.liquidationCode) + '</a>'
                    + '</span>';
                groupBody.appendChild(row);
            });

            group.appendChild(groupBody);
            body.appendChild(group);
        });

        // Hidden inputs + totals
        Object.keys(selected).forEach(function(gid) {
            var grp = selected[gid];
            var price = parseFloat(grp.unitPrice || 0) || 0;
            Object.keys(grp.items).forEach(function(sn) {
                totalSelected++;
                totalPrice += price;
                hidden.insertAdjacentHTML('beforeend',
                    '<input type="hidden" name="generatorId" value="' + escapeHtml(gid) + '">'
                    + '<input type="hidden" name="serialNumber" value="' + escapeHtml(sn) + '">'
                );
            });
        });

        if (!anyRendered) {
            var msg;
            if (query) msg = 'Không có kết quả phù hợp';
            else if (Object.keys(warehouseStock).length === 0) msg = 'Kho này chưa có máy phát điện đang IN_STOCK';
            else msg = 'Không có máy khả dụng';
            body.innerHTML = '<div class="pick-empty">' + msg + '</div>';
        }

        var ageSelect = document.getElementById('serialAgeFilter');
        var counts = { all: totalAvail, old: cOld, mid: cMid, fresh: cFresh };
        Array.prototype.forEach.call(ageSelect.options, function(opt) {
            var base = opt.getAttribute('data-base') || opt.value;
            opt.innerHTML = base + ' (' + (counts[opt.value] || 0) + ')';
        });

        document.getElementById('barSelectedCount').textContent = totalSelected;
        var modelCount = Object.keys(selected).length;
        document.getElementById('barModelCount').textContent = modelCount > 0 ? ' · ' + modelCount + ' model' : '';
        document.getElementById('formTotalVal').textContent = fmt(totalPrice) + ' đ';
    }

    // Gộp các máy đã có trong đơn (preloaded) vào warehouseStock theo kho hiện tại,
    // để chúng hiện ra trong danh sách và giữ trạng thái đã chọn.
    function mergePreloadedIntoStock() {
        Object.keys(preloaded).forEach(function(gid) {
            var pre = preloaded[gid];
            if (!warehouseStock[gid]) {
                warehouseStock[gid] = { model: pre.model, unitPrice: pre.unitPrice, items: [] };
            }
            pre.items.forEach(function(it) {
                var exists = warehouseStock[gid].items.some(function(x) { return x.serial === it.serial; });
                if (!exists) {
                    warehouseStock[gid].items.push({ serial: it.serial, createdAt: it.createdAt });
                }
            });
        });
    }

    function loadWarehouseStock() {
        var warehouseId = document.getElementById('warehouseId').value;
        var body = document.getElementById('pickBody');
        if (!warehouseId) {
            warehouseStock = {};
            lockedByGen = {};
            body.innerHTML = '<div class="pick-empty">Chọn Kho hàng ở mục 01 để xem máy có sẵn.</div>';
            document.getElementById('serialAgeFilter').style.display = 'none';
            render();
            return;
        }

        body.innerHTML = '<div class="pick-empty">Đang tải...</div>';

        fetch('${pageContext.request.contextPath}/liquidations?action=get_serials_all&warehouseId=' + encodeURIComponent(warehouseId))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                warehouseStock = {};
                lockedByGen = {};
                (data.generators || []).forEach(function(g) {
                    warehouseStock[g.generatorId] = {
                        model: g.model,
                        unitPrice: g.unitPrice,
                        items: (g.serials || []).map(function(s) {
                            return { serial: s.serialNumber, createdAt: s.createdAt };
                        })
                    };
                });
                (data.locked || []).forEach(function(l) {
                    if (!lockedByGen[l.generatorId]) lockedByGen[l.generatorId] = [];
                    lockedByGen[l.generatorId].push(l);
                });
                mergePreloadedIntoStock();
                document.getElementById('serialAgeFilter').style.display = '';
                render();
            })
            .catch(function() {
                // Vẫn hiện được máy đã chọn dù AJAX lỗi
                warehouseStock = {};
                lockedByGen = {};
                mergePreloadedIntoStock();
                if (Object.keys(warehouseStock).length > 0) {
                    document.getElementById('serialAgeFilter').style.display = '';
                    render();
                } else {
                    body.innerHTML = '<div class="pick-empty" style="color:var(--danger)">Lỗi kết nối khi tải dữ liệu</div>';
                }
            });
    }

    document.getElementById('serialAgeFilter').addEventListener('change', function() {
        currentAgeFilter = this.value;
        render();
    });
    document.getElementById('serialSearchInput').addEventListener('input', render);
    document.getElementById('serialSortOrder').addEventListener('change', render);

    document.getElementById('warehouseId').addEventListener('change', function() {
        if (Object.keys(selected).length > 0) {
            if (!confirm('Đổi kho sẽ xoá danh sách máy đã chọn. Tiếp tục?')) {
                this.value = this.getAttribute('data-prev-value') || '';
                return;
            }
            selected = {};
            preloaded = {};
        }
        this.setAttribute('data-prev-value', this.value);
        loadWarehouseStock();
    });

    (function initEdit() {
        // Đọc máy đã có trong đơn từ initialCartData -> preloaded + selected
        var items = document.querySelectorAll('#initialCartData .initial-cart-item');
        items.forEach(function(it) {
            var gid = it.getAttribute('data-gen-id');
            if (!gid) return;
            var model = it.getAttribute('data-model') || '';
            var unitPrice = parseFloat(it.getAttribute('data-unit-price') || '0') || 0;
            var serial = it.getAttribute('data-serial') || '';
            var createdAt = it.getAttribute('data-created-at') || '';

            if (!preloaded[gid]) {
                preloaded[gid] = { model: model, unitPrice: unitPrice, items: [] };
            }
            preloaded[gid].items.push({ serial: serial, createdAt: createdAt });

            if (!selected[gid]) {
                selected[gid] = { model: model, unitPrice: unitPrice, items: {} };
            }
            selected[gid].items[serial] = { serial: serial, createdAt: createdAt };
        });

        var wh = document.getElementById('warehouseId');
        if (wh) wh.setAttribute('data-prev-value', wh.value);
        loadWarehouseStock();
    })();
</script>
<script>
    <c:if test="${not empty sessionScope.toastMessage}">
    window.SESSION_DATA = { message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>' };
        <c:remove var="toastMessage" scope="session"/>
        <c:remove var="toastType" scope="session"/>
    </c:if>
    <c:if test="${not empty requestScope.toastMessage}">
    window.SESSION_DATA = window.SESSION_DATA || {};
    window.SESSION_DATA.message = '<c:out value="${requestScope.toastMessage}"/>';
    window.SESSION_DATA.type = '<c:out value="${requestScope.toastType}"/>';
    </c:if>
</script>
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
