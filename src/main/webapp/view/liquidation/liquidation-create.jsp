<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đơn thanh lý mới — Warehouse OS</title>
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
            <h1>Tạo đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / Thêm mới</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="page-head">
                <div class="eyebrow">Thanh lý · Đơn thanh lý mới</div>
                <h2 class="page-title">Tạo đơn thanh lý</h2>
            </div>

            <div class="form-layout">
                <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                    <input type="hidden" name="action" value="create" />
                    <input type="hidden" name="customerId" id="customerIdHidden" />

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
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}">${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                <select class="input" name="reasonId" required>
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${reasons}">
                                        <option value="${r.id}">${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 02: CHỌN MÁY (Inline 2-col picker) -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — CHỌN MÁY</div>
                            <h3 class="form-section-title">Chọn máy phát điện thanh lý</h3>
                        </div>

                        <div class="liq-picker-shell">
                            <div class="liq-picker-mobile-tabs">
                                <button type="button" class="is-active" data-mobile-pane="left">Kho hàng <span class="badge" id="warehouseAvailBadge">0</span></button>
                                <button type="button" data-mobile-pane="right">Đã chọn <span class="badge" id="cartCountBadge">0</span></button>
                            </div>

                            <div class="liq-picker-grid">
                                <!-- LEFT: KHO HÀNG -->
                                <div class="liq-picker-pane" id="leftPane">
                                    <div class="liq-pane-head">
                                        <span class="pane-title">Kho hàng</span>
                                        <span class="pane-meta" id="leftPaneMeta">Chọn kho ở mục 01</span>
                                    </div>
                                    <div class="liq-pane-tools">
                                        <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                                        <select id="serialSortOrder" class="serial-sort-select" title="Sắp xếp">
                                            <option value="asc">Cũ nhất</option>
                                            <option value="desc">Mới nhất</option>
                                        </select>
                                    </div>
                                    <div class="liq-pane-filters summary-chips" id="warehouseFilters" style="display:none;">
                                        <button type="button" class="filter-chip filter-all is-active" data-filter="all">
                                            <span class="dot"></span><span class="lbl">Tất cả</span><span class="num" id="cntAll">0</span>
                                        </button>
                                        <button type="button" class="filter-chip filter-old" data-filter="old">
                                            <span class="dot"></span><span class="lbl">≥ 12th</span><span class="num" id="cntOld">0</span>
                                        </button>
                                        <button type="button" class="filter-chip filter-mid" data-filter="mid">
                                            <span class="dot"></span><span class="lbl">6-12th</span><span class="num" id="cntMid">0</span>
                                        </button>
                                        <button type="button" class="filter-chip filter-fresh" data-filter="fresh">
                                            <span class="dot"></span><span class="lbl">&lt;6th</span><span class="num" id="cntFresh">0</span>
                                        </button>
                                    </div>
                                    <div class="liq-pane-body" id="warehousePaneBody">
                                        <div class="pane-empty" id="warehouseEmpty">Chọn Kho hàng ở mục 01 để xem máy có sẵn.</div>
                                    </div>
                                </div>

                                <!-- RIGHT: CART -->
                                <div class="liq-picker-pane is-hidden-mobile" id="rightPane">
                                    <div class="liq-pane-head">
                                        <span class="pane-title">Đã chọn</span>
                                        <span class="pane-meta" id="rightPaneMeta">0 máy</span>
                                    </div>
                                    <div class="liq-pane-body" id="cartPaneBody">
                                        <div class="pane-empty" id="cartEmpty">Click vào máy bên trái để thêm vào phiếu.</div>
                                    </div>
                                    <div class="liq-pane-foot">
                                        <span>Tổng giá gốc</span>
                                        <span class="total-val" id="formTotalVal">0 đ</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="hiddenInputs"></div>
                    </div>

                    <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/liquidations">Huỷ bỏ</a>
                        <button type="submit" form="liquidationForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Lưu & Đề xuất
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>

    var cart = {};
    var warehouseStock = {};
    var lockedByGen = {};
    var currentAgeFilter = 'all';

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s).replace(/[&<>"']/g, function(c) {
            return { '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' }[c];
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

    /* ============================================================
       LEFT pane render (kho)
       ============================================================ */
    function renderWarehousePane() {
        var body = document.getElementById('warehousePaneBody');
        var empty = document.getElementById('warehouseEmpty');
        body.innerHTML = '';

        var keys = Object.keys(warehouseStock);
        // Build map serial-in-cart để loại
        var inCart = {};
        Object.keys(cart).forEach(function(gid) {
            inCart[gid] = inCart[gid] || {};
            cart[gid].items.forEach(function(it) { inCart[gid][it.serial] = true; });
        });

        var totalAvail = 0, cOld = 0, cMid = 0, cFresh = 0;
        var anyRendered = false;
        var query = (document.getElementById('serialSearchInput').value || '').toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;

        keys.forEach(function(gid) {
            var grp = warehouseStock[gid];
            var available = (grp.items || []).filter(function(it) {
                return !(inCart[gid] && inCart[gid][it.serial]);
            });
            var lockedHere = lockedByGen[gid] || [];
            if (available.length === 0 && lockedHere.length === 0) return;

            // Filter by query
            var modelMatch = (grp.model || '').toLowerCase().indexOf(query) > -1;
            var filtered = available.filter(function(it) {
                if (modelMatch) return true;
                if (!query) return true;
                return (it.serial || '').toLowerCase().indexOf(query) > -1;
            }).filter(function(it) {
                if (currentAgeFilter === 'all') return true;
                var age = ageOf(tsOf(it.createdAt)).cls;
                return (currentAgeFilter === 'old' && age === 'age-old')
                    || (currentAgeFilter === 'mid' && age === 'age-mid')
                    || (currentAgeFilter === 'fresh' && age === 'age-fresh');
            });
            // Sort
            filtered.sort(function(a, b) {
                var ta = tsOf(a.createdAt), tb = tsOf(b.createdAt);
                return sortOrder === 'desc' ? tb - ta : ta - tb;
            });

            if (filtered.length === 0 && lockedHere.length === 0) return;
            anyRendered = true;

            // Group label
            var label = document.createElement('div');
            label.className = 'pane-group-label';
            label.innerHTML =
                '<span class="lbl">' + escapeHtml(grp.model) + '</span>'
                + '<span class="count">' + filtered.length + '</span>'
                + (filtered.length > 1 ? '<button type="button" class="move-all" data-gen-id="' + gid + '">Chọn tất cả</button>' : '');
            var moveAllBtn = label.querySelector('.move-all');
            if (moveAllBtn) {
                moveAllBtn.addEventListener('click', function() {
                    filtered.forEach(function(it) { addToCart(gid, grp, it); });
                    refreshAll();
                });
            }
            body.appendChild(label);

            // Rows
            filtered.forEach(function(it) {
                totalAvail++;
                var ts = tsOf(it.createdAt);
                var age = ageOf(ts);
                if (age.cls === 'age-old') cOld++;
                else if (age.cls === 'age-mid') cMid++;
                else cFresh++;

                var row = document.createElement('div');
                row.className = 'move-row ' + age.cls;
                row.title = 'Click để thêm vào phiếu';
                row.innerHTML =
                    '<span class="age-dot"></span>'
                    + '<span class="row-serial">' + escapeHtml(it.serial) + '</span>'
                    + '<span class="row-meta">' + age.text + '</span>'
                    + '<span class="row-meta">' + dateStrOf(it.createdAt) + '</span>'
                    + '<svg class="row-action-icon" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>';
                row.addEventListener('click', function() {
                    addToCart(gid, grp, it);
                    refreshAll();
                });
                body.appendChild(row);
            });

            // Locked entries
            if (lockedHere.length > 0) {
                var locked = document.createElement('div');
                locked.className = 'pane-locked-block';
                locked.innerHTML = '<div>' + lockedHere.length + ' máy đang khoá ở phiếu khác</div>';
                lockedHere.forEach(function(l) {
                    var rl = document.createElement('div');
                    rl.className = 'row-locked';
                    rl.innerHTML =
                        '<span>' + escapeHtml(l.serialNumber) + '</span>'
                        + '<span>·</span>'
                        + '<span>' + lockedStatusLabel(l.liquidationStatus) + '</span>'
                        + '<a class="mono" href="${pageContext.request.contextPath}/liquidations?action=detail&id=' + encodeURIComponent(l.liquidationId) + '" target="_blank">'
                        + escapeHtml(l.liquidationCode) + '</a>';
                    locked.appendChild(rl);
                });
                body.appendChild(locked);
            }
        });

        if (!anyRendered) {
            body.innerHTML = '<div class="pane-empty">' + (query ? 'Không có kết quả phù hợp' : 'Không có máy khả dụng') + '</div>';
        }

        document.getElementById('cntAll').textContent = totalAvail;
        document.getElementById('cntOld').textContent = cOld;
        document.getElementById('cntMid').textContent = cMid;
        document.getElementById('cntFresh').textContent = cFresh;
        document.getElementById('warehouseAvailBadge').textContent = totalAvail;
        document.getElementById('leftPaneMeta').textContent = totalAvail + ' máy khả dụng';
    }

    /* ============================================================
       RIGHT pane render (cart) + hidden inputs
       ============================================================ */
    function renderCart() {
        var body = document.getElementById('cartPaneBody');
        var hidden = document.getElementById('hiddenInputs');
        body.innerHTML = '';
        hidden.innerHTML = '';

        var totalItems = 0, totalPrice = 0;
        var keys = Object.keys(cart);

        if (keys.length === 0) {
            body.innerHTML = '<div class="pane-empty">Click vào máy bên trái để thêm vào phiếu.</div>';
            document.getElementById('rightPaneMeta').textContent = '0 máy';
            document.getElementById('formTotalVal').textContent = '0 đ';
            document.getElementById('cartCountBadge').textContent = '0';
            return;
        }

        keys.forEach(function(gid) {
            var grp = cart[gid];
            if (!grp.items.length) return;
            var price = parseFloat(grp.unitPrice || 0) || 0;
            var subTotal = price * grp.items.length;
            totalItems += grp.items.length;
            totalPrice += subTotal;

            var groupBox = document.createElement('div');
            groupBox.className = 'cart-pane-group';

            var head = document.createElement('div');
            head.className = 'cart-pane-group-head';
            head.innerHTML =
                '<span class="model">' + escapeHtml(grp.model) + '</span>'
                + '<span class="count">' + grp.items.length + '</span>'
                + '<span class="price">' + fmt(subTotal) + ' đ</span>';
            groupBox.appendChild(head);

            grp.items.forEach(function(it) {
                var ts = tsOf(it.createdAt);
                var age = ageOf(ts);
                var row = document.createElement('div');
                row.className = 'move-row ' + age.cls;
                row.title = 'Click để bỏ khỏi phiếu';
                row.innerHTML =
                    '<span class="age-dot"></span>'
                    + '<span class="row-serial">' + escapeHtml(it.serial) + '</span>'
                    + '<span class="row-meta">' + age.text + '</span>'
                    + '<span class="row-meta">' + fmt(price) + ' đ</span>'
                    + '<svg class="row-action-icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>';
                row.addEventListener('click', function() {
                    removeFromCart(gid, it.serial);
                    refreshAll();
                });
                groupBox.appendChild(row);

                hidden.insertAdjacentHTML('beforeend',
                    '<input type="hidden" name="generatorId" value="' + escapeHtml(gid) + '">'
                    + '<input type="hidden" name="serialNumber" value="' + escapeHtml(it.serial) + '">'
                    + '<input type="hidden" name="originalPrice" value="' + escapeHtml(price) + '">'
                );
            });
            body.appendChild(groupBox);
        });

        document.getElementById('rightPaneMeta').textContent = totalItems + ' máy · ' + Object.keys(cart).filter(function(k) { return cart[k].items.length > 0; }).length + ' model';
        document.getElementById('formTotalVal').textContent = fmt(totalPrice) + ' đ';
        document.getElementById('cartCountBadge').textContent = totalItems;
    }

    function addToCart(gid, grp, item) {
        if (!cart[gid]) {
            cart[gid] = { model: grp.model, unitPrice: grp.unitPrice, items: [] };
        }
        if (cart[gid].items.find(function(x) { return x.serial === item.serial; })) return;
        cart[gid].items.push({ serial: item.serial, createdAt: item.createdAt });
    }
    function removeFromCart(gid, serial) {
        if (!cart[gid]) return;
        cart[gid].items = cart[gid].items.filter(function(x) { return x.serial !== serial; });
        if (!cart[gid].items.length) delete cart[gid];
    }
    function refreshAll() {
        renderWarehousePane();
        renderCart();
    }

    /* ============================================================
       Load warehouse stock
       ============================================================ */
    function loadWarehouseStock() {
        var warehouseId = document.getElementById('warehouseId').value;
        var body = document.getElementById('warehousePaneBody');
        if (!warehouseId) {
            warehouseStock = {};
            lockedByGen = {};
            body.innerHTML = '<div class="pane-empty">Chọn Kho hàng ở mục 01 để xem máy có sẵn.</div>';
            document.getElementById('warehouseFilters').style.display = 'none';
            document.getElementById('leftPaneMeta').textContent = 'Chọn kho ở mục 01';
            renderCart();
            return;
        }

        body.innerHTML = '<div class="pane-empty">Đang tải...</div>';

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
                document.getElementById('warehouseFilters').style.display = 'flex';
                refreshAll();
            })
            .catch(function() {
                body.innerHTML = '<div class="pane-empty" style="color:var(--danger)">Lỗi kết nối khi tải dữ liệu</div>';
            });
    }

    /* ============================================================
       Wire events
       ============================================================ */
    document.querySelectorAll('.filter-chip').forEach(function(chip) {
        chip.addEventListener('click', function() {
            currentAgeFilter = chip.getAttribute('data-filter');
            document.querySelectorAll('.filter-chip').forEach(function(c) {
                c.classList.toggle('is-active', c === chip);
            });
            renderWarehousePane();
        });
    });
    document.getElementById('serialSearchInput').addEventListener('input', renderWarehousePane);
    document.getElementById('serialSortOrder').addEventListener('change', renderWarehousePane);

    document.getElementById('warehouseId').addEventListener('change', function() {
        if (Object.keys(cart).length > 0) {
            if (!confirm('Đổi kho sẽ xoá danh sách máy đã chọn. Tiếp tục?')) {
                this.value = this.getAttribute('data-prev-value') || '';
                return;
            }
            cart = {};
        }
        this.setAttribute('data-prev-value', this.value);
        loadWarehouseStock();
    });

    document.querySelectorAll('.liq-picker-mobile-tabs button[data-mobile-pane]').forEach(function(tab) {
        tab.addEventListener('click', function() {
            var which = tab.getAttribute('data-mobile-pane');
            document.querySelectorAll('.liq-picker-mobile-tabs button').forEach(function(b) {
                b.classList.toggle('is-active', b === tab);
            });
            document.getElementById('leftPane').classList.toggle('is-hidden-mobile', which !== 'left');
            document.getElementById('rightPane').classList.toggle('is-hidden-mobile', which !== 'right');
        });
    });

    /* Init */
    document.getElementById('warehouseId').setAttribute('data-prev-value', document.getElementById('warehouseId').value);
    renderCart();
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
