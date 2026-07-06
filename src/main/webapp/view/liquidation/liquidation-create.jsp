<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đơn thanh lý mới — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css?v=20260703">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }

        .liqd .section { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; margin-bottom: 16px; }
        .liqd .section-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 14px 20px; border-bottom: 1px solid var(--border); background: var(--surface); }
        .liqd .section-head h3 { font-size: 14px; font-weight: 700; margin: 0; }
        .liqd .section-body { padding: 20px; }

        .form-grid { display: grid; gap: 14px 18px; }
        .form-grid.cols-4 { grid-template-columns: repeat(4, 1fr); }
        .form-grid.cols-2 { grid-template-columns: repeat(2, 1fr); }
        @media (max-width: 1280px) { .form-grid.cols-4 { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 760px) { .form-grid.cols-4, .form-grid.cols-2 { grid-template-columns: 1fr; } }
        .liqd .info-field { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
        .liqd .info-field label { font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
        .liqd .info-input { font-family: var(--font-ui); font-size: 13px; color: var(--fg); background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 9px 11px; width: 100%; line-height: 1.4; box-sizing: border-box; }
        .liqd .info-input:disabled { opacity: 0.9; cursor: not-allowed; }
        .liqd .info-input.mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }
        .liqd .info-input[required] { cursor: pointer; }
        .liqd .info-input:not([disabled]):not([readonly]) { background: var(--surface); }

        .table-toolbar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; padding: 12px 14px; background: var(--surface); border-bottom: 1px solid var(--border); }
        .table-toolbar .spacer { flex: 1; }
        .search-input { position: relative; display: inline-flex; align-items: center; min-width: 240px; }
        .search-input svg { position: absolute; left: 10px; width: 16px; height: 16px; stroke: var(--muted); fill: none; stroke-width: 2; pointer-events: none; }
        .search-input input { width: 100%; padding: 8px 12px 8px 32px; font-size: 13px; font-family: var(--font-ui); color: var(--fg); background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); box-sizing: border-box; }
        .search-input input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .search-input input::placeholder { color: var(--muted-2); }

        .product-table { width: 100%; border-collapse: collapse; }
        .product-table th, .product-table td { padding: 11px 14px; text-align: left; border-bottom: 1px solid var(--border); vertical-align: middle; }
        .product-table th { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); letter-spacing: 0.04em; }
        .product-table td { font-size: 13px; }
        .product-table tbody tr:hover { background: var(--surface-2); }
        .product-table tfoot td { background: var(--surface-2); font-weight: 700; border-top: 2px solid var(--border); padding: 12px 14px; }
        .product-table .col-cb { width: 36px; text-align: center; }
        .product-table .col-date { white-space: nowrap; }
        .product-table .col-price { text-align: right; white-space: nowrap; }
        .product-table .pick-cb { width: 16px; height: 16px; margin: 0; cursor: pointer; accent-color: var(--accent); }
        .product-table #pickAll { width: 16px; height: 16px; margin: 0; cursor: pointer; accent-color: var(--accent); }
        .product-table .row-serial { font-family: var(--font-mono); font-size: 12.5px; font-weight: 500; }
        .product-table .row-model { max-width: 180px; overflow: hidden; text-overflow: ellipsis; }
        .product-table .row-price { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }
        .product-table .is-locked td { color: var(--muted); font-size: 12.5px; }
        .product-table .is-locked .locked-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 999px; font-size: 12px; background: var(--surface-2); border: 1px solid var(--border); color: var(--muted); text-decoration: none; }
        .product-table .is-locked .locked-pill:hover { border-color: var(--accent); color: var(--accent); }
        .product-table .gen-hidden { display: none; }

        .liq-price-wrap { display: inline-flex; align-items: center; gap: 4px; }
        .liq-price-wrap .liq-price-input { width: 110px; padding: 7px 8px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface-2); color: var(--fg); font-size: 13px; font-family: var(--font-mono); text-align: right; box-sizing: border-box; }
        .liq-price-wrap .liq-price-input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .liq-price-wrap .liq-price-input:disabled { opacity: 0.5; cursor: not-allowed; }
        .liq-price-wrap .liq-price-suffix { font-size: 11px; color: var(--muted); font-weight: 600; }

        .cust-subhead { border-top: 1px solid var(--border); padding-top: 16px; margin-top: 22px; }
        .cust-subhead h4 { font-size: 13px; font-weight: 700; margin: 0 0 14px; }

        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
        .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
        .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
        .empty-state strong { color: var(--fg); font-size: 14px; }

        .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
        [data-theme="light"] .theme-toggle .icon-moon { display: block; }
        [data-theme="dark"] .theme-toggle .icon-sun { display: block; }
        @media (max-width: 900px) {
            .table-toolbar { flex-direction: column; align-items: stretch; }
            .search-input { min-width: 0; }
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tạo đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / Thêm mới</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main class="liqd">
            <%-- ===== HEADER BAR ===== --%>
            <div class="header-bar">
                <div class="left">
                    <span class="code-tag">
                        <span class="ct-label">Đơn thanh lý -</span>
                        <span>TẠO MỚI</span>
                    </span>
                    <h2 class="page-main-title">Tạo đơn thanh lý</h2>
                </div>
                <div class="right">
                    <a class="btn" href="${pageContext.request.contextPath}/liquidations">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại
                    </a>
                    <button type="submit" form="liquidationForm" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                        Lưu &amp; Gửi Sếp duyệt
                    </button>
                </div>
            </div>

            <%-- ===== SECTION 1: LỌC KHO + THÔNG TIN CHUNG (GET) ===== --%>
            <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/liquidations">
                <input type="hidden" name="action" value="create" />
                <div class="section">
                    <div class="section-head"><h3>Thông tin chung</h3></div>
                    <div class="section-body">
                        <div class="form-grid cols-4">
                            <div class="info-field">
                                <label>Kho hàng <span style="color:var(--danger)">*</span></label>
                                <select class="info-input" name="warehouseId" id="warehouseId" required onchange="document.getElementById('filterForm').submit();">
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${selectedWarehouseId == w.warehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="info-field">
                                <label>Lý do thanh lý <span style="color:var(--danger)">*</span></label>
                                <select class="info-input" name="reasonId" form="liquidationForm" required>
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${reasons}">
                                        <option value="${r.id}" ${selectedReasonId == r.id ? 'selected' : ''}>${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="info-field">
                                <label>Tình trạng máy</label>
                                <select class="info-input" name="cond" id="condFilter" onchange="document.getElementById('filterForm').submit();" ${empty selectedWarehouseId ? 'disabled' : ''}>
                                    <option value="all" ${condFilter == 'all' ? 'selected' : ''}>Tất cả (${condCountAll})</option>
                                    <option value="DAMAGED" ${condFilter == 'DAMAGED' ? 'selected' : ''}>Hỏng (${condCountDamaged})</option>
                                    <option value="POOR" ${condFilter == 'POOR' ? 'selected' : ''}>Kém (${condCountPoor})</option>
                                    <option value="GOOD" ${condFilter == 'GOOD' ? 'selected' : ''}>Tốt (${condCountGood})</option>
                                </select>
                            </div>
                            <div class="info-field">
                                <label>Số máy khả dụng</label>
                                <input class="info-input mono" type="text" disabled value="${empty selectedWarehouseId ? '—' : (empty pickRows ? '0' : fn:length(pickRows))} máy">
                            </div>
                        </div>
                    </div>
                </div>
            </form>

            <%-- ===== SECTION 2: KHÁCH HÀNG + CHỌN MÁY & BÁO GIÁ (POST) ===== --%>
            <form id="liquidationForm" action="${pageContext.request.contextPath}/liquidations" method="POST">
                <input type="hidden" name="action" value="create" />
                <input type="hidden" name="warehouseId" value="${selectedWarehouseId}" />

                <div class="section">
                    <div class="section-head"><h3>Khách hàng nhận</h3></div>
                    <div class="section-body">
                        <p class="kv-hint" style="margin:0 0 12px;font-size:13px;color:var(--muted);">Chọn khách hàng có sẵn hoặc tạo khách hàng mới để gán vào đơn thanh lý.</p>
                        <div class="sd" id="customerDropdown"
                             data-endpoint="${pageContext.request.contextPath}/liquidations?action=search_customer&q=">
                            <div class="cust-trigger-wrap">
                                <button type="button" class="cust-trigger" id="custTrigger"
                                        onclick="openCustomerPanel()" aria-haspopup="dialog">
                                    <span class="cust-trigger-label" id="custTriggerLabel">-- Click để chọn khách hàng --</span>
                                </button>
                                <button type="button" class="cust-clear-btn" id="custClearBtn"
                                        onclick="clearCustomerSelection()" title="Hủy chọn khách hàng" aria-label="Hủy chọn">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M18 6L6 18M6 6l12 12"/>
                                    </svg>
                                </button>
                            </div>
                            <input type="hidden" name="customerId" id="sdHiddenId" value="" />
                        </div>
                        <button type="button" class="btn btn-primary" onclick="openNewCustomerModal()" style="margin-top:10px;">
                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo khách hàng mới
                        </button>
                    </div>
                </div>

                <div class="section">
                    <div class="section-head"><h3>Chọn máy &amp; báo giá</h3></div>
                    <div class="table-toolbar">
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input type="text" id="serialSearchInput" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                        </div>
                        <div class="spacer"></div>
                        <button type="button" class="btn" onclick="selectAllVisible()">Chọn tất cả</button>
                        <button type="button" class="btn" onclick="deselectAll()">Bỏ chọn</button>
                    </div>
                    <c:choose>
                        <c:when test="${empty selectedWarehouseId}">
                            <div class="empty-state">
                                <div class="icon-wrap">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg>
                                </div>
                                <strong>Chọn kho hàng trước</strong>
                                <span>Vui lòng chọn kho ở mục Thông tin chung để xem máy có sẵn.</span>
                            </div>
                        </c:when>
                        <c:when test="${empty pickRows and empty lockedRows}">
                            <div class="empty-state">
                                <div class="icon-wrap">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                </div>
                                <strong>Không có máy khả dụng</strong>
                                <span>Kho này chưa có máy phát điện đã kiểm kê trong tình trạng đã chọn.</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th class="col-cb"><input type="checkbox" id="pickAll"/></th>
                                        <th>Serial</th>
                                        <th>Model</th>
                                        <th>Tình trạng</th>
                                        <th class="col-date">Ngày nhập</th>
                                        <th class="col-price">Giá nhập</th>
                                        <th class="col-price">Giá thanh lý <span style="color:var(--danger)">*</span></th>
                                    </tr>
                                </thead>
                                <tbody id="pickBody">
                                    <c:forEach var="r" items="${pickRows}">
                                        <tr class="pick-trow" data-model="<c:out value='${r.model}'/>">
                                            <td class="col-cb">
                                                <input type="checkbox" class="pick-cb" name="serialNumber"
                                                       value="<c:out value='${r.serialNumber}'/>"
                                                       data-gen="${r.generatorId}"
                                                       data-price="${r.unitPrice}"
                                                       data-condition="${r.condition}"/>
                                                <input type="hidden" class="gen-hidden" name="generatorId" value="${r.generatorId}" disabled/>
                                            </td>
                                            <td class="row-serial"><c:out value="${r.serialNumber}"/></td>
                                            <td class="row-model"><c:out value="${r.model}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${r.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                    <c:when test="${r.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                    <c:when test="${r.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                    <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="col-date"><c:out value="${r.createdAtStr}"/></td>
                                            <td class="col-price row-price"><fmt:formatNumber value="${r.unitPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                            <td class="col-price">
                                                <div class="liq-price-wrap">
                                                    <input type="text" inputmode="numeric" class="liq-price-input" name="liquidationPrice" placeholder="Nhập giá..." disabled/>
                                                    <span class="liq-price-suffix">đ</span>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:forEach var="lk" items="${lockedRows}">
                                        <tr class="is-locked">
                                            <td class="col-cb"></td>
                                            <td class="row-serial"><c:out value="${lk.serialNumber}"/></td>
                                            <td class="row-model"><c:out value="${lk.model}"/></td>
                                            <td colspan="4">
                                                <a class="locked-pill" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${lk.liquidationId}" target="_blank">Trong đơn <c:out value="${lk.liquidationCode}"/></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="2">Đã chọn <strong id="barSelectedCount">0</strong> máy<span id="barModelCount" style="color:var(--muted);font-weight:500;"></span></td>
                                        <td></td>
                                        <td></td>
                                        <td class="col-price">Tổng giá nhập:</td>
                                        <td class="col-price"><span class="total-val" id="formTotalVal">0 đ</span></td>
                                        <td class="col-price">Tổng thanh lý: <span class="total-val" id="formLiqTotalVal">0 đ</span></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <div id="condWarn" class="liq-cond-warn"></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </main>
    </div>
</div>

<%-- ===== TOAST ===== --%>
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    (function () {
        var checkboxes = Array.prototype.slice.call(document.querySelectorAll('.pick-cb'));

        function fmt(n) { return Number(n || 0).toLocaleString('vi-VN'); }

        function recalc() {
            var count = 0, total = 0, liqTotal = 0, good = 0;
            var models = {};
            checkboxes.forEach(function (cb) {
                var row = cb.closest('.pick-trow');
                var genHidden = row ? row.querySelector('.gen-hidden') : null;
                var priceInput = row ? row.querySelector('.liq-price-input') : null;
                if (cb.checked) {
                    count++;
                    total += parseFloat(cb.getAttribute('data-price') || '0') || 0;
                    models[cb.getAttribute('data-gen')] = true;
                    if (cb.getAttribute('data-condition') === 'GOOD') good++;
                    if (row) row.classList.add('is-checked');
                    if (row) row.classList.toggle('cond-warn-selected', cb.getAttribute('data-condition') === 'GOOD');
                    if (genHidden) genHidden.disabled = false;
                    if (priceInput) {
                        priceInput.disabled = false;
                        liqTotal += parseFloat((priceInput.value || '').replace(/[^0-9]/g, '')) || 0;
                    }
                } else {
                    if (row) row.classList.remove('is-checked');
                    if (row) row.classList.remove('cond-warn-selected');
                    if (genHidden) genHidden.disabled = true;
                    if (priceInput) priceInput.disabled = true;
                }
            });
            document.getElementById('barSelectedCount').textContent = count;
            var modelCount = Object.keys(models).length;
            document.getElementById('barModelCount').textContent = modelCount > 0 ? ' · ' + modelCount + ' model' : '';
            document.getElementById('formTotalVal').textContent = fmt(total) + ' đ';
            document.getElementById('formLiqTotalVal').textContent = fmt(liqTotal) + ' đ';

            var warnEl = document.getElementById('condWarn');
            if (warnEl) {
                if (good > 0) {
                    warnEl.textContent = '⚠ Đang chọn ' + good + ' máy tình trạng "Tốt" — cân nhắc trước khi thanh lý.';
                    warnEl.classList.add('is-shown');
                } else {
                    warnEl.classList.remove('is-shown');
                }
            }
        }

        checkboxes.forEach(function (cb) { cb.addEventListener('change', recalc); });

        function formatPriceInput(el) {
            var digits = (el.value || '').replace(/[^0-9]/g, '');
            el.value = digits ? Number(digits).toLocaleString('vi-VN') : '';
        }
        document.querySelectorAll('.liq-price-input').forEach(function (el) {
            el.addEventListener('input', function () { formatPriceInput(el); recalc(); });
        });

        var pickAll = document.getElementById('pickAll');
        if (pickAll) {
            pickAll.addEventListener('change', function () {
                checkboxes.forEach(function (cb) {
                    var row = cb.closest('.pick-trow');
                    if (row && row.style.display !== 'none') cb.checked = pickAll.checked;
                });
                recalc();
            });
        }

        var search = document.getElementById('serialSearchInput');
        if (search) {
            search.addEventListener('input', function () {
                var q = (this.value || '').toLowerCase().trim();
                document.querySelectorAll('.pick-trow').forEach(function (row) {
                    var model = (row.getAttribute('data-model') || '').toLowerCase();
                    var serialEl = row.querySelector('.row-serial');
                    var serial = serialEl ? (serialEl.textContent || '').toLowerCase() : '';
                    var show = !q || model.indexOf(q) > -1 || serial.indexOf(q) > -1;
                    row.style.display = show ? '' : 'none';
                });
            });
        }

        // Chọn tất cả / Bỏ chọn
        window.selectAllVisible = function () {
            checkboxes.forEach(function (cb) {
                var row = cb.closest('.pick-trow');
                if (row && row.style.display !== 'none') cb.checked = true;
            });
            recalc();
        };
        window.deselectAll = function () {
            checkboxes.forEach(function (cb) { cb.checked = false; });
            recalc();
        };

        var form = document.getElementById('liquidationForm');
        if (form) {
            form.addEventListener('submit', function (e) {
                var checked = checkboxes.filter(function (cb) { return cb.checked; });
                if (checked.length === 0) {
                    e.preventDefault();
                    alert('Phải chọn ít nhất 1 máy phát điện.');
                    return;
                }
                var missingPrice = checked.some(function (cb) {
                    var row = cb.closest('.pick-trow');
                    var priceInput = row ? row.querySelector('.liq-price-input') : null;
                    var v = priceInput ? (priceInput.value || '').replace(/[^0-9]/g, '') : '';
                    return !v || Number(v) <= 0;
                });
                if (missingPrice) {
                    e.preventDefault();
                    alert('Phải nhập giá thanh lý (lớn hơn 0) cho tất cả máy đã chọn.');
                    return;
                }
                var custId = (document.getElementById('sdHiddenId') || {}).value;
                if (!custId || !custId.trim()) {
                    e.preventDefault();
                    alert('Phải chọn khách hàng hoặc tạo khách hàng mới trước khi gửi Sếp duyệt.');
                    return;
                }
                document.querySelectorAll('.liq-price-input').forEach(function (el) {
                    el.value = (el.value || '').replace(/[^0-9]/g, '');
                });
            });
        }

        recalc();
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

<%-- ===== SIDE PANEL CHỌN KHÁCH HÀNG ===== --%>
<div class="side-panel-overlay" id="custPanelOverlay" onclick="closeCustomerPanel()"></div>
<div class="side-panel" id="custSidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn Khách Hàng</h3>
        <button type="button" class="side-panel-close" onclick="closeCustomerPanel()">&times;</button>
    </div>
    <div class="side-panel-body">
        <div style="display:flex; gap: 8px; margin-bottom: 20px;">
            <input type="text" id="custSearchInput" class="serial-search-box" placeholder="Tìm nhanh theo tên, SĐT, email..."/>
            <select id="custSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                <option value="name_asc">Tên A-Z</option>
                <option value="name_desc">Tên Z-A</option>
                <option value="newest">Mới nhất</option>
            </select>
        </div>
        <div id="custLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
            </svg><br>Đang tải...
        </div>
        <div class="cust-list-wrap" id="custList"></div>
    </div>
</div>

<%-- ===== MODAL TẠO KHÁCH HÀNG MỚI ===== --%>
<div class="modal-host" id="ncModalOverlay">
    <div class="modal modal-lg">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
            <h3 style="margin:0;">Thêm khách hàng mới</h3>
            <button type="button" class="side-panel-close" onclick="closeNewCustomerModal()" title="Đóng">&times;</button>
        </div>
        <p style="font-size:13px;color:var(--muted);margin:0 0 4px;">Nhập thông tin khách hàng để tạo nhanh và gán vào đơn.</p>
        <div class="modal-error" id="ncError" style="display:none;"></div>
        <div class="modal-grid">
            <div class="field">
                <label class="field-label">Họ và tên <span class="req">*</span></label>
                <input type="text" id="ncName" class="input" placeholder="VD: Nguyễn Văn A" autocomplete="off" />
                <span class="field-error" id="ncNameErr">Vui lòng nhập họ và tên.</span>
            </div>
            <div class="field">
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input type="tel" id="ncPhone" class="input mono" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" autocomplete="off" />
                <span class="field-error" id="ncPhoneErr">SĐT phải gồm 10–11 chữ số.</span>
            </div>
            <div class="field">
                <label class="field-label">Email</label>
                <input type="email" id="ncEmail" class="input mono" placeholder="email@example.com" autocomplete="off" />
                <span class="field-error" id="ncEmailErr">Email không hợp lệ.</span>
            </div>
            <div class="field">
                <label class="field-label">Loại khách hàng</label>
                <select id="ncTypeId" class="select" onchange="ncOnTypeChange()">
                    <option value="">-- Chọn loại --</option>
                    <c:forEach var="ct" items="${customerTypes}">
                        <option value="${ct.id}" data-name="${ct.name}"><c:out value="${ct.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Tên công ty <span class="req nc-company-req" style="display:none;">*</span></label>
                <input type="text" id="ncCompanyName" class="input" placeholder="VD: Công ty TNHH ABC" autocomplete="off" />
                <span class="field-error" id="ncCompanyErr">Vui lòng nhập tên công ty.</span>
            </div>
            <div class="field span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea id="ncAddress" class="textarea" rows="2" placeholder="VD: Số 1, Đường ABC, Quận 1, TP.HCM"></textarea>
            </div>
        </div>
        <div class="modal-actions" style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
<script>
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-host.show').forEach(function(m) { m.classList.remove('show'); });
        }
    });

    function clearCustomerSelectionLocal() {
        var hid = document.getElementById('sdHiddenId');
        if (hid) hid.value = '';
        var label = document.getElementById('custTriggerLabel');
        if (label) { label.textContent = '-- Click để chọn khách hàng --'; label.classList.remove('has-value'); }
    }
    if (typeof window.clearCustomerSelection !== 'function') {
        window.clearCustomerSelection = clearCustomerSelectionLocal;
    }

    function openNewCustomerModal() {
        ['ncName','ncPhone','ncEmail','ncAddress','ncCompanyName'].forEach(function(id){
            document.getElementById(id).value = '';
        });
        document.getElementById('ncTypeId').selectedIndex = 0;
        ncClearInvalid();
        ncOnTypeChange();
        hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }
    function closeNewCustomerModal() {
        document.getElementById('ncModalOverlay').classList.remove('show');
    }
    function showNcError(msg) {
        var el = document.getElementById('ncError');
        el.textContent = msg; el.style.display = 'block';
    }
    function hideNcError() {
        document.getElementById('ncError').style.display = 'none';
    }

    function ncOnTypeChange() {
        var sel = document.getElementById('ncTypeId');
        var opt = sel.options[sel.selectedIndex];
        var name = (opt && opt.getAttribute('data-name') || '').toLowerCase();
        var isCompany = name.indexOf('doanh nghi') >= 0 || name.indexOf('công ty') >= 0;
        var req = document.querySelector('.nc-company-req');
        if (req) req.style.display = isCompany ? '' : 'none';
    }

    function ncSetInvalid(inputId, invalid) {
        var el = document.getElementById(inputId);
        if (!el) return;
        var field = el.closest('.field');
        if (field) field.classList.toggle('invalid', !!invalid);
    }
    function ncClearInvalid() {
        ['ncName','ncPhone','ncEmail','ncCompanyName'].forEach(function(id){ ncSetInvalid(id, false); });
    }

    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        var email = document.getElementById('ncEmail').value.trim();
        var company = document.getElementById('ncCompanyName').value.trim();
        var sel = document.getElementById('ncTypeId');
        var typeName = (sel.options[sel.selectedIndex] && sel.options[sel.selectedIndex].getAttribute('data-name') || '').toLowerCase();
        var isCompany = typeName.indexOf('doanh nghi') >= 0 || typeName.indexOf('công ty') >= 0;

        ncClearInvalid();
        hideNcError();

        var firstBad = null;
        var phoneRe = /^[0-9]{10,11}$/;
        var emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!name) { ncSetInvalid('ncName', true); firstBad = firstBad || 'ncName'; }
        if (!phone || !phoneRe.test(phone)) { ncSetInvalid('ncPhone', true); firstBad = firstBad || 'ncPhone'; }
        if (email && !emailRe.test(email)) { ncSetInvalid('ncEmail', true); firstBad = firstBad || 'ncEmail'; }
        if (isCompany && !company) { ncSetInvalid('ncCompanyName', true); firstBad = firstBad || 'ncCompanyName'; }

        if (firstBad) {
            document.getElementById(firstBad).focus();
            return;
        }

        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';

        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', email);
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', company);
        fd.append('custTypeId', sel.value);

        fetch('${pageContext.request.contextPath}/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    applyChosenCustomer(data);
                    closeNewCustomerModal();
                    if (typeof closeCustomerPanel === 'function') closeCustomerPanel();
                    if (data.existing) {
                        alert('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                    }
                } else {
                    showNcError(data.error || 'Lỗi không xác định');
                }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }

    function applyChosenCustomer(c) {
        var hid = document.getElementById('sdHiddenId');
        if (hid) hid.value = c.id;
        var label = document.getElementById('custTriggerLabel');
        if (label) { label.textContent = c.name || c.phone || ''; label.classList.add('has-value'); }
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
