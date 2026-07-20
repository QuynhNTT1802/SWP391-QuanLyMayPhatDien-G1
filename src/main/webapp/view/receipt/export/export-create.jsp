<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo phiếu xuất kho — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Tạo phiếu xuất kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / Tạo mới</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                        <a class="btn" href="javascript:void(0)" onclick="confirmCancelCreate()">Huỷ</a>
                        <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            Gửi phiếu
                        </button>
            </div>
        </header>

                <main>
                    <a class="receipt-back-link" href="javascript:void(0)" onclick="confirmCancelCreate()">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại danh sách
            </a>

                <div class="hero-body">
                    <div class="hero-meta">
                        <c:if test="${not empty order}">
                            <span>Tạo từ đơn <span class="id">${order.orderCode}</span></span>
                        </c:if>
                    </div>
                </div>

            <form id="receiptForm" action="${pageContext.request.contextPath}/export-receipt?action=save" method="POST" onsubmit="return validateReceiptForm()">
                <c:if test="${not empty errors}">
                    <div class="alert alert-error" style="margin: 16px 0;">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <div class="alert-body">
                            <div class="alert-title">Không thể gửi phiếu &mdash; tồn kho không đủ</div>
                            <ul>
                                <c:forEach var="e" items="${errors}">
                                    <li><c:out value="${e}"/></li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty receipt.orderId}">
                    <input type="hidden" name="orderId" value="${receipt.orderId}" />
                </c:if>
                <c:if test="${not empty transferId}">
                    <input type="hidden" name="transferId" value="${transferId}" />
                </c:if>
                <c:if test="${not empty receipt.liquidationId}">
                    <input type="hidden" name="liquidationId" value="${receipt.liquidationId}" />
                </c:if>
                <input type="hidden" name="receiptId" id="receiptIdField" value="0" />

                <c:if test="${not empty fromTransfer}">
                    <div class="alert" style="background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent); margin: 16px 0; padding: 12px 16px; border-radius: var(--radius);">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18M9 7v12M15 7v12M3 7l3-4h12l3 4"/></svg>
                        <div>
                            <div style="font-weight: 700; margin-bottom: 4px;">Tạo phiếu xuất từ phiếu đề xuất luân chuyển <c:out value="${transferCode}"/></div>
                            <div style="font-size: 12.5px;">Quét các serial từ kho nguồn <strong><c:out value="${transfer.sourceWarehouseName}"/></strong>. Khi lưu, phiếu đề xuất sẽ chuyển sang trạng thái <strong>EXPORTED</strong> và kho đích sẽ nhận thông báo để tạo phiếu nhập.</div>
                        </div>
                    </div>
                </c:if>

                <div class="content">
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN PHIẾU</div>
                                <h3 class="section-title">Kho, lý do và ghi chú</h3>
                            </div>
                        </div>
                        <div class="form-grid">
                            <div class="form-field">
                                <label>Kho *</label>
                                <c:choose>
                                    <c:when test="${fromLiquidation}">
                                        <input type="hidden" name="warehouseId" value="${receipt.warehouseId}" />
                                        <select id="warehouseSelect" disabled>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.warehouseId}" ${wh.warehouseId == receipt.warehouseId ? 'selected' : ''}>${wh.name}</option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <select id="warehouseSelect" name="warehouseId" required onchange="onWarehouseChange()">
                                            <option value="">-- Chọn kho trước --</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.warehouseId}"
                                                        <c:if test="${wh.warehouseId == preselectSourceWarehouseId}">selected</c:if>>
                                                    <c:out value="${wh.name}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                                <span class="field-error" style="display:none;"></span>
                            </div>
                            <div class="form-field">
                                <label>Lý do *</label>
                                <c:choose>
                                    <c:when test="${fromLiquidation}">
                                        <input type="hidden" name="reasonId" value="${receipt.reasonId}" />
                                        <select class="input" disabled>
                                            <c:forEach var="r" items="${receiptReasons}">
                                                <option value="${r.id}" ${r.id == receipt.reasonId ? 'selected' : ''}>${r.name}</option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <select name="reasonId" class="input" required onchange="validateField(this)">
                                            <option value="">-- Chọn lý do --</option>
                                            <c:forEach var="r" items="${receiptReasons}">
                                                <option value="${r.id}">${r.name}</option>
                                            </c:forEach>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                                <span class="field-error" style="display:none;"></span>
                            </div>
                            <c:if test="${not empty order}">
                                <div class="form-field full">
                                    <label>Đơn hàng nguồn</label>
                                    <div class="order-pin">
                                        <strong>${order.orderCode}</strong>
                                        <span class="order-cust">— ${order.customer.name}</span>
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${not empty liquidation}">
                                <div class="form-field full">
                                    <label>Đơn thanh lý nguồn</label>
                                    <div class="order-pin">
                                        <strong>${liquidation.liquidationCode}</strong>
                                        <span class="order-cust">— Kho: ${liquidation.warehouseName}</span>
                                    </div>
                                </div>
                            </c:if>
                            <div class="form-field full">
                                <label>Ghi chú phiếu</label>
                                <textarea name="note" placeholder="Nhập ghi chú nếu có..."><c:out value="${receipt.note}"/></textarea>
                            </div>
                        </div>
                    </section>

                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — CHI TIẾT DÒNG HÀNG</div>
                                <h3 class="section-title">Danh sách máy phát điện</h3>
                            </div>
                        </div>
                        <c:if test="${not empty stockWarnings}">
                            <div id="stockWarnBanner" class="alert alert-warn" style="margin: 0 0 14px 0;">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                <div class="alert-body">
                                    <div class="alert-title">Đơn hàng này hiện đang thiếu máy trong kho</div>
                                    <ul>
                                        <c:forEach var="w" items="${stockWarnings}">
                                            <li><strong>Thiếu:</strong> ${w}</li>
                                        </c:forEach>
                                    </ul>
                                    <div style="margin-top: 8px; font-size: 12px; color: var(--muted);">
                                        Vui lòng nhập thêm máy vào kho hoặc chọn kho có đủ máy để tạo phiếu.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <div id="warehouseWarn" class="alert alert-info" style="display:none;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Vui lòng chọn kho trước</div>
                                <div>Danh sách máy phát điện sẽ chỉ hiển thị những máy đang có tồn kho tại kho bạn chọn.</div>
                            </div>
                        </div>
                        <div id="realtimeWarn" class="alert alert-error" style="display:none; margin: 0 0 14px 0;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Tồn kho không đủ để xuất</div>
                                <ul id="realtimeWarnList"></ul>
                            </div>
                        </div>
                        <c:if test="${not fromLiquidation}">
                        <div class="scanner-box" id="scannerBox">
                            <label>Quét barcode nhanh</label>
                            <div class="scanner-row">
                                <input type="text" id="scanBox" autocomplete="off"
                                       placeholder="Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)..." />
                                <button type="button" class="cam-btn" id="camBtn" title="Mở camera để quét" onclick="toggleCamera()">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                                </button>
                            </div>
                            <div id="scannerCamera"></div>
                            <small>Mỗi lần quét, hệ thống tự reserve serial nếu máy đang IN_STOCK tại kho đã chọn.</small>
                        </div>
                        </c:if>
                        <c:if test="${fromOrder}">
                        <div class="order-req-banner">
                            <div class="req-title">Đơn hàng <strong><c:out value="${order.orderCode}"/></strong> yêu cầu:</div>
                            <c:forEach var="req" items="${orderRequirements}" varStatus="st">
                            <div class="req-item">${st.count}. <c:out value="${req.generatorModel}"/> <c:if test="${not empty req.brandName}">(<c:out value="${req.brandName}"/>)</c:if> x <strong>${req.quantity}</strong></div>
                            </c:forEach>
                        </div>
                        </c:if>
                        <c:if test="${not empty stockWarningsTransfer}">
                            <div class="alert alert-warn" style="margin: 0 0 14px 0;">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                <div class="alert-body">
                                    <div class="alert-title">Phiếu đề xuất đang thiếu máy tại kho nguồn</div>
                                    <ul>
                                        <c:forEach var="w" items="${stockWarningsTransfer}">
                                            <li><strong>Thiếu:</strong> <c:out value="${w}"/></li>
                                        </c:forEach>
                                    </ul>
                                    <div style="margin-top: 8px; font-size: 12px; color: var(--muted);">
                                        Vui lòng nhập thêm máy vào kho nguồn hoặc chờ phiếu đề xuất khác.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${fromTransfer}">
                        <div class="order-req-banner">
                            <div class="req-title">Phiếu đề xuất luân chuyển <strong><c:out value="${transferCode}"/></strong> yêu cầu:</div>
                            <c:forEach var="td" items="${transferDetails}" varStatus="st">
                            <div class="req-item">${st.count}. <c:out value="${td.generatorModel}"/> x <strong><c:out value="${td.quantity}"/></strong></div>
                            </c:forEach>
                        </div>
                        </c:if>
                        <div class="order-counter">
                            <c:if test="${fromOrder}">Đã nhập: <strong id="orderScannedCount">0</strong> / <strong>${expectedRows}</strong> serial &middot; </c:if>
                            <c:if test="${fromTransfer}">Đã nhập: <strong id="transferScannedCount">0</strong> / <strong>${expectedTransferRows}</strong> serial &middot; </c:if>
                            Tổng số dòng: <strong id="totalRowCount">0</strong>
                        </div>
                        <div id="detailGroups" class="detail-groups">
                            <div id="emptyState" class="empty-state" style="display:none;">
                                <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/></svg>
                                <p class="empty-state-title">Chưa có serial nào</p>
                                <p class="empty-state-hint">Hãy quét barcode hoặc thêm dòng để bắt đầu</p>
                            </div>
                            <table class="detail-table" style="display:none;">
                                <thead>
                                    <tr>
                                        <th class="col-num">#</th>
                                        <th class="col-gen">Máy phát (Tồn kho)</th>
                                        <th class="col-serial">Serial</th>
                                        <th class="col-note">Ghi chú</th>
                                        <th class="col-del"></th>
                                    </tr>
                                </thead>
                                <tbody id="detailBody">
                                </tbody>
                            </table>
                        </div>

                        <c:if test="${not fromLiquidation}">
                        <button type="button" class="btn add-row-btn" id="addRowBtn" disabled onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                        </c:if>
                        <c:if test="${fromLiquidation}">
                        <button type="button" class="btn add-row-btn" id="addRowBtn" disabled style="display:none;">Thêm dòng</button>
                        </c:if>
                    </section>
                </div>

            </form>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>
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
<script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js"></script>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/export-scanner-actions.js"></script>
<script>
    var ctx = window.APP_CTX;
    function confirmCancelCreate() {
        if (confirm('Bạn có chắc muốn huỷ tạo phiếu xuất?')) {
            location.href = ctx + '/export-receipt';
        }
    }
    var generatorCache = [];
    var prefillDetails = [
        <c:choose>
        <c:when test="${fromLiquidation}">
        <c:forEach var="r" items="${orderRowList}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{generatorId: ${r.generatorId}, serialNumber: '<c:out value="${r.serialNumber}"/>', model: '<c:out value="${r.generatorModel}"/>', note: '<c:out value="${r.note}"/>'}
        </c:forEach>
        </c:when>
        <c:when test="${not empty prefillDetailsJson}">
        ${prefillDetailsJson}
        </c:when>
        <c:otherwise>
        <c:forEach var="d" items="${receipt.details}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{generatorId: ${d.generatorId}, note: '<c:out value="${d.note}"/>'}
        </c:forEach>
        </c:otherwise>
        </c:choose>
    ];
    var stockWarningGenIds = [
        <c:forEach var="genId" items="${stockWarningGenIds}" varStatus="st">
        ${genId}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var allSerials = [
        <c:forEach var="inv" items="${allSerials}" varStatus="st">
        {
            inventoryId: ${inv.inventoryId},
            serialNumber: '<c:out value="${inv.serialNumber}"/>',
            generatorId: ${inv.generatorId},
            generatorModel: '<c:out value="${inv.generatorModel}"/>',
            warehouseId: ${inv.warehouseId},
            warehouseName: '<c:out value="${inv.warehouseName}"/>',
            createdAt: '<c:out value="${inv.createdAt}"/>'
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var isOrderMode = ${not empty fromOrder and fromOrder};
    var isTransferMode = ${not empty fromTransfer and fromTransfer};
    var isLiquidationMode = ${not empty fromLiquidation and fromLiquidation};
    var expectedRows = ${empty expectedRows ? 0 : expectedRows};
    var ORDER_REQUIREMENTS = [
        <c:forEach var="req" items="${orderRequirements}" varStatus="st">
        {genId: ${req.generatorId}, model: '<c:out value="${req.generatorModel}"/>', qty: ${req.quantity}}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var TRANSFER_REQUIREMENTS = [
        <c:forEach var="d" items="${transferDetails}" varStatus="st">
        {genId: ${d.generatorId}, qty: ${d.quantity}, model: '<c:out value="${d.generatorModel}"/>'}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var TRANSFER_PROGRESS = {};

    function updateTransferCounter() {
        if (!isTransferMode) return;
        var scannedByGen = {};
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            if (sel.value) scannedByGen[sel.value] = (scannedByGen[sel.value] || 0) + 1;
        });
        var total = 0;
        TRANSFER_REQUIREMENTS.forEach(function (req) {
            total += scannedByGen[String(req.genId)] || 0;
        });
        var el = document.getElementById('transferScannedCount');
        if (el) el.textContent = total;
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (prefillDetails && prefillDetails.length > 0) {
            var whId = document.getElementById('warehouseSelect').value;
            if (whId) {
                onWarehouseChange();
            }
        }
        updateEmptyState();
        reorganizeGroups();
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
            window.SESSION_DATA = null;
        }
    });

    function formatVND(num) {
        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
    }

    function renderGeneratorOptions(selectEl) {
        var cur = selectEl.getAttribute('data-current');
        var html = '<option value="">-- Chọn máy --</option>';
        for (var i = 0; i < generatorCache.length; i++) {
            var g = generatorCache[i];
            var label = g.model + (g.brand ? ' (' + g.brand + ')' : '') + ' (' + (g.stockQty || 0) + ')';
            var sel = (cur && String(g.id) === String(cur)) ? ' selected' : '';
            html += '<option value="' + g.id + '" data-stock="' + (g.stockQty || 0) + '"' + sel + '>' + label + '</option>';
        }
        selectEl.innerHTML = html;
    }

    function onWarehouseChange() {
        var whId = document.getElementById('warehouseSelect').value;
        var warn = document.getElementById('warehouseWarn');
        if (!whId) {
            generatorCache = [];
            warn.style.display = 'flex';
            disableAllRows(true);
            validateInventoryRealtime();
            return;
        }
        warn.style.display = 'none';
        fetch(ctx + '/export-receipt?action=loadGenerators&warehouseId=' + encodeURIComponent(whId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                generatorCache = data || [];
                disableAllRows(false);
                refreshAllGeneratorSelects();
                applyPrefill();
                validateInventoryRealtime();
            })
            .catch(function (err) {
                console.error(err);
                generatorCache = [];
                disableAllRows(false);
                refreshAllGeneratorSelects();
                applyPrefill();
                validateInventoryRealtime();
            });
    }

    function refreshAllGeneratorSelects() {
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            renderGeneratorOptions(sel);
        });
    }

    function disableAllRows(disabled) {
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            row.querySelectorAll('select[name="generatorId"], select[name="serialNumber"]').forEach(function (el) {
                el.disabled = disabled;
            });
            var btn = row.querySelector('.row-del-btn');
            if (btn) btn.disabled = disabled;
        });
        var addBtn = document.getElementById('addRowBtn');
        if (addBtn) addBtn.disabled = disabled;
    }

    function applyPrefill() {
        if (!prefillDetails || prefillDetails.length === 0) return;
        var tbody = document.getElementById('detailBody');
        while (tbody.firstChild) tbody.removeChild(tbody.firstChild);
        prefillDetails.forEach(function (p) {
            var tr = buildEmptyRow(p.generatorId);
            var noteInput = tr.querySelector('input[name="detailNote"]');
            if (noteInput) noteInput.value = p.note || '';
            tbody.appendChild(tr);
            var genSelect = tr.querySelector('select[name="generatorId"]');
            var serialSelect = tr.querySelector('select[name="serialNumber"]');
            if (genSelect && serialSelect) {
                if (isLiquidationMode && p.serialNumber) {
                    genSelect.innerHTML = '';
                    var genOpt = document.createElement('option');
                    genOpt.value = p.generatorId;
                    genOpt.textContent = p.model || ('#' + p.generatorId);
                    genSelect.appendChild(genOpt);
                    genSelect.value = p.generatorId;
                    genSelect.disabled = true;
                    genSelect.removeAttribute('name');
                    var genHidden = document.createElement('input');
                    genHidden.type = 'hidden';
                    genHidden.name = 'generatorId';
                    genHidden.value = p.generatorId;
                    genSelect.parentNode.appendChild(genHidden);

                    serialSelect.innerHTML = '';
                    var opt = document.createElement('option');
                    opt.value = p.serialNumber;
                    opt.textContent = p.serialNumber;
                    serialSelect.appendChild(opt);
                    serialSelect.value = p.serialNumber;
                    serialSelect.disabled = true;
                    serialSelect.removeAttribute('name');
                    var snHidden = document.createElement('input');
                    snHidden.type = 'hidden';
                    snHidden.name = 'serialNumber';
                    snHidden.value = p.serialNumber;
                    serialSelect.parentNode.appendChild(snHidden);

                    var delBtn = tr.querySelector('.row-del-btn');
                    if (delBtn) delBtn.style.display = 'none';
                } else {
                    populateSerialOptions(serialSelect, parseInt(genSelect.value, 10));
                }
            }
        });
        updateRowNumbers();
        updateOrderCounter();
        validateInventoryRealtime();
        filterAlreadySelected();
        if (!generatorCache || generatorCache.length === 0) {
            highlightShortRows();
        }
    }

    function highlightShortRows() {
        if (!stockWarningGenIds || stockWarningGenIds.length === 0) return;
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            var sel = row.querySelector('select[name="generatorId"]');
            if (!sel) return;
            var genId = parseInt(sel.value, 10);
            if (genId && stockWarningGenIds.indexOf(genId) !== -1) {
                row.classList.add('row-short');
            }
        });
    }

    function onGeneratorChange(sel) {
        var row = sel.closest('tr');
        var opt = sel.options[sel.selectedIndex];
        var stock = parseInt(opt && opt.getAttribute('data-stock')) || 0;
        var stockInfo = row.querySelector('.col-stock');
        if (stockInfo) {
            if (sel.value) {
                stockInfo.textContent = 'Tồn kho: ' + stock + ' máy';
            } else {
                stockInfo.textContent = '';
            }
        }
        var serialSelect = row.querySelector('select[name="serialNumber"]');
        populateSerialOptions(serialSelect, parseInt(sel.value, 10));
        validateInventoryRealtime();
    }

    function populateSerialOptions(serialSelect, genId) {
        if (!serialSelect) return;
        while (serialSelect.firstChild) serialSelect.removeChild(serialSelect.firstChild);
        var placeholder = document.createElement('option');
        placeholder.value = '';
        placeholder.textContent = '-- Chọn serial --';
        serialSelect.appendChild(placeholder);
        serialSelect.disabled = true;
        if (!genId) return;
        var whId = parseInt(document.getElementById('warehouseSelect').value, 10);
        for (var k = 0; k < allSerials.length; k++) {
            var s = allSerials[k];
            if (s.warehouseId === whId && s.generatorId === genId) {
                var opt = document.createElement('option');
                opt.value = s.serialNumber;
                opt.textContent = s.serialNumber;
                serialSelect.appendChild(opt);
            }
        }
        serialSelect.disabled = false;
    }

    function onSerialChange(sel) {
        filterAlreadySelected();
        validateInventoryRealtime();
    }

    function filterAlreadySelected() {
        var selectedSerials = {};
        document.querySelectorAll('#detailBody select[name="serialNumber"]').forEach(function (s) {
            if (s.value) selectedSerials[s.value] = true;
        });
        document.querySelectorAll('#detailBody select[name="serialNumber"]').forEach(function (sel) {
            var currentVal = sel.value;
            for (var j = 0; j < sel.options.length; j++) {
                var opt = sel.options[j];
                if (!opt.value) continue;
                opt.disabled = selectedSerials[opt.value] && opt.value !== currentVal;
            }
        });
    }

    function escapeHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function buildEmptyRow(currentId) {
        var tr = document.createElement('tr');
        if (currentId) tr.setAttribute('data-current', currentId);
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td><select name="generatorId" required onchange="onGeneratorChange(this)"><option value="">-- Chọn máy --</option></select><div class="col-stock"></div><span class="field-error" style="display:none;"></span></td>'
                + '<td><select name="serialNumber" required onchange="onSerialChange(this)" style="font-family: var(--font-mono); font-size: 12px;"><option value="">-- Chọn máy trước --</option></select><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        var sel = tr.querySelector('select[name="generatorId"]');
        if (currentId) sel.setAttribute('data-current', currentId);
        renderGeneratorOptions(sel);
        return tr;
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        tbody.appendChild(buildEmptyRow());
        updateRowNumbers();
        updateOrderCounter();
        validateInventoryRealtime();
        filterAlreadySelected();
    }

    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        var row = btn.closest('tr');
        var invId = parseInt(row.getAttribute('data-inventory-id') || '0', 10);
        var receiptId = parseInt(document.getElementById('receiptIdField').value || '0', 10);
        if (invId > 0 && receiptId > 0 && window.ExportScannerActions) {
            btn.disabled = true;
            window.ExportScannerActions.removeScannedSerial(receiptId, invId)
                .then(function (data) {
                    if (!data || !data.success) {
                        btn.disabled = false;
                        toast((data && data.message) ? data.message : 'Lỗi khi giải phóng serial', 'danger');
                        return;
                    }
                    if (data.emptyReceipt) {
                        document.getElementById('receiptIdField').value = '0';
                    }
                    row.remove();
                    updateRowNumbers();
                    updateOrderCounter();
                    validateInventoryRealtime();
                    toast(data.message || 'Đã giải phóng serial', 'success');
                })
                .catch(function (err) {
                    btn.disabled = false;
                    console.error(err);
                    toast('Lỗi kết nối: ' + err.message, 'danger');
                });
        } else {
            row.remove();
            updateRowNumbers();
            updateOrderCounter();
            validateInventoryRealtime();
        }
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
        });
        updateEmptyState();
        reorganizeGroups();
    }

    function updateEmptyState() {
        var groups = document.getElementById('detailGroups');
        var empty = document.getElementById('emptyState');
        var table = groups ? groups.querySelector('table.detail-table') : null;
        if (!groups || !empty || !table) return;
        var rowCount = document.querySelectorAll('#detailBody tr').length;
        var showEmpty = rowCount === 0;
        empty.style.display = showEmpty ? 'flex' : 'none';
        table.style.display = showEmpty ? 'none' : '';
    }

    function reorganizeGroups() {
        var groups = document.getElementById('detailGroups');
        var table = groups ? groups.querySelector('table.detail-table') : null;
        if (!groups || !table) return;

        var existingGroups = Array.prototype.slice.call(groups.querySelectorAll('details.export-group'));
        var rowGroups = {};
        var orphanRows = [];

        table.querySelectorAll('tbody tr').forEach(function (tr) {
            var sel = tr.querySelector('select[name="generatorId"]');
            var genId = sel ? sel.value : '';
            if (genId) {
                if (!rowGroups[genId]) rowGroups[genId] = [];
                rowGroups[genId].push(tr);
            } else {
                orphanRows.push(tr);
            }
        });

        existingGroups.forEach(function (g) { g.remove(); });

        var sortedGenIds = Object.keys(rowGroups).sort(function (a, b) {
            return parseInt(a, 10) - parseInt(b, 10);
        });
        sortedGenIds.forEach(function (genId) {
            var rows = rowGroups[genId];
            var info = generatorCache.find(function (g) { return String(g.id) === String(genId); });
            var modelText = info ? info.model : ('Mẫu #' + genId);
            var details = document.createElement('details');
            details.className = 'detail-group export-group';
            details.setAttribute('data-gen-id', String(genId));
            details.setAttribute('open', '');
            details.innerHTML = '<summary>'
                    + '<span class="group-title">' + escapeHtml(modelText) + '</span>'
                    + '<span class="group-count">(<span class="group-count-num">' + rows.length + '</span> máy)</span>'
                    + '<span class="group-spacer"></span>'
                    + '</summary>'
                    + '<table class="group-table"><tbody></tbody></table>';
            var newTbody = details.querySelector('tbody');
            rows.forEach(function (tr) { newTbody.appendChild(tr); });
            groups.appendChild(details);
        });

        if (orphanRows.length > 0) {
            var orphanDetails = document.createElement('details');
            orphanDetails.className = 'detail-group export-group';
            orphanDetails.setAttribute('data-gen-id', 'none');
            orphanDetails.setAttribute('open', '');
            orphanDetails.innerHTML = '<summary>'
                    + '<span class="group-title">Chưa chọn mẫu máy</span>'
                    + '<span class="group-count">(<span class="group-count-num">' + orphanRows.length + '</span> dòng)</span>'
                    + '<span class="group-spacer"></span>'
                    + '</summary>'
                    + '<table class="group-table"><tbody></tbody></table>';
            var orphanTbody = orphanDetails.querySelector('tbody');
            orphanRows.forEach(function (tr) { orphanTbody.appendChild(tr); });
            groups.appendChild(orphanDetails);
        }
    }

    function escapeHtml(s) {
        if (s == null) return '';
        return String(s)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    function validateInventoryRealtime() {
        var banner = document.getElementById('realtimeWarn');
        var list = document.getElementById('realtimeWarnList');
        if (!banner || !list) return;
        if (!generatorCache || generatorCache.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
            document.querySelectorAll('#detailBody tr.row-short').forEach(function (r) { r.classList.remove('row-short'); });
            return;
        }
        var stockMap = {};
        var modelMap = {};
        for (var i = 0; i < generatorCache.length; i++) {
            var g = generatorCache[i];
            stockMap[g.id] = parseInt(g.stockQty) || 0;
            modelMap[g.id] = g.model + (g.brand ? ' (' + g.brand + ')' : '');
        }
        var requiredByGen = {};
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            var sel = row.querySelector('select[name="generatorId"]');
            if (!sel) return;
            var genId = parseInt(sel.value, 10);
            if (!genId) {
                row.classList.remove('row-short');
                return;
            }
            requiredByGen[genId] = (requiredByGen[genId] || 0) + 1;
        });
        var shortByGen = {};
        Object.keys(requiredByGen).forEach(function (k) {
            var id = parseInt(k, 10);
            var need = requiredByGen[k];
            var onHand = stockMap[id] || 0;
            if (need > onHand) {
                shortByGen[id] = { need: need, onHand: onHand };
            }
        });
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            var sel = row.querySelector('select[name="generatorId"]');
            if (!sel) return;
            var genId = parseInt(sel.value, 10);
            if (genId && shortByGen[genId]) {
                row.classList.add('row-short');
            } else {
                row.classList.remove('row-short');
            }
        });
        var keys = Object.keys(shortByGen);
        if (keys.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
            return;
        }
        var html = '';
        keys.forEach(function (k) {
            var id = parseInt(k, 10);
            var info = shortByGen[k];
            var model = modelMap[id] || ('#' + id);
            var shortage = info.need - info.onHand;
            html += '<li>Máy <strong>' + escapeHtml(model)
                + '</strong> trong kho không đủ: cần <strong>' + info.need
                + '</strong> máy, chỉ còn <strong>' + info.onHand
                + '</strong> máy. Vui lòng nhập thêm <strong>' + shortage + '</strong> máy.</li>';
        });
        list.innerHTML = html;
        banner.style.display = 'flex';
    }

    function validateField(el) {
        var err = el.parentElement.querySelector('.field-error');
        if (err === null) return true;
        if (el.required && !el.value.trim()) {
            el.style.borderColor = '#dc3545';
            err.style.display = 'block';
            return false;
        }
        el.style.borderColor = '';
        err.style.display = 'none';
        return true;
    }

    function validateReceiptForm() {
        var valid = true;
        var firstInvalid = null;
        document.querySelectorAll('#receiptForm [required]').forEach(function (el) {
            if (!validateField(el)) {
                valid = false;
                if (firstInvalid === null) firstInvalid = el;
            }
        });
        if (document.querySelectorAll('#detailBody tr').length === 0) {
            toast('Vui lòng thêm ít nhất 1 dòng chi tiết', 'danger');
            valid = false;
        }
        if (!valid) {
            toast('Vui lòng điền đầy đủ các trường bắt buộc', 'danger');
            if (firstInvalid) firstInvalid.focus();
            return false;
        }
        var banner = document.getElementById('realtimeWarn');
        if (banner && banner.style.display !== 'none' && banner.offsetParent !== null) {
            toast('Tồn kho không đủ để gửi phiếu. Vui lòng nhập thêm máy.', 'danger');
            return false;
        }
        if (isOrderMode && ORDER_REQUIREMENTS && ORDER_REQUIREMENTS.length > 0) {
            var scannedByGen = {};
            document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
                if (sel.value) {
                    scannedByGen[sel.value] = (scannedByGen[sel.value] || 0) + 1;
                }
            });
            var orderGenIds = {};
            ORDER_REQUIREMENTS.forEach(function (req) {
                orderGenIds[String(req.genId)] = true;
            });
            var mismatches = [];
            ORDER_REQUIREMENTS.forEach(function (req) {
                var scanned = scannedByGen[String(req.genId)] || 0;
                if (scanned < req.qty) {
                    mismatches.push('Thiếu ' + (req.qty - scanned) + ' ' + req.model);
                } else if (scanned > req.qty) {
                    mismatches.push('Thừa ' + (scanned - req.qty) + ' ' + req.model);
                }
            });
            Object.keys(scannedByGen).forEach(function (genId) {
                if (!orderGenIds[genId]) {
                    mismatches.push('Có dòng máy không thuộc đơn (ID=' + genId + ')');
                }
            });
            if (mismatches.length > 0) {
                toast('Chưa khớp với đơn hàng: ' + mismatches.join('; '), 'danger');
                return false;
            }
        }
        if (isTransferMode && TRANSFER_REQUIREMENTS && TRANSFER_REQUIREMENTS.length > 0) {
            var scannedByGenT = {};
            document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
                if (sel.value) {
                    scannedByGenT[sel.value] = (scannedByGenT[sel.value] || 0) + 1;
                }
            });
            var transferGenIds = {};
            TRANSFER_REQUIREMENTS.forEach(function (req) {
                transferGenIds[String(req.genId)] = true;
            });
            var mismatchesT = [];
            TRANSFER_REQUIREMENTS.forEach(function (req) {
                var scanned = scannedByGenT[String(req.genId)] || 0;
                if (scanned < req.qty) {
                    mismatchesT.push('Thiếu ' + (req.qty - scanned) + ' ' + req.model);
                } else if (scanned > req.qty) {
                    mismatchesT.push('Thừa ' + (scanned - req.qty) + ' ' + req.model);
                }
            });
            Object.keys(scannedByGenT).forEach(function (genId) {
                if (!transferGenIds[genId]) {
                    mismatchesT.push('Có dòng máy không thuộc phiếu đề xuất (ID=' + genId + ')');
                }
            });
            if (mismatchesT.length > 0) {
                toast('Chưa khớp với phiếu đề xuất: ' + mismatchesT.join('; '), 'danger');
                return false;
            }
        }
        sessionStorage.removeItem('scanDraftReceiptId');
        return valid;
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (isLiquidationMode) {
            var whSelect = document.getElementById('warehouseSelect');
            if (whSelect) {
                generatorCache = [];
                var whId = parseInt(whSelect.value, 10);
                whSelect.dataset.whId = whId;
            }
            applyPrefill();
            var addBtn = document.getElementById('addRowBtn');
            if (addBtn) addBtn.style.display = 'none';
        } else if (prefillDetails && prefillDetails.length > 0) {
            var whId2 = document.getElementById('warehouseSelect').value;
            if (whId2) {
                onWarehouseChange();
            }
        }
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
            window.SESSION_DATA = null;
        }
    });

    var currentExportReceiptId = 0;
    var exportScannerLocked = false;

    function refreshExportScannerState() {
        var box = document.getElementById('scannerBox');
        var input = document.getElementById('scanBox');
        if (!box || !input) return;
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) {
            box.classList.add('disabled');
            input.disabled = true;
            input.placeholder = 'Vui lòng chọn kho trước khi quét...';
        } else {
            box.classList.remove('disabled');
            input.disabled = false;
            input.placeholder = 'Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)...';
        }
    }

    function findGeneratorInCache(generatorId) {
        if (!generatorCache) return null;
        for (var i = 0; i < generatorCache.length; i++) {
            if (String(generatorCache[i].id) === String(generatorId)) return generatorCache[i];
        }
        return null;
    }

    var html5Scanner = null;
    var isScanning = false;

    function toggleCamera() {
        if (isScanning) { stopCamera(); }
        else { startCamera(); }
    }

    function startCamera() {
        var camDiv = document.getElementById('scannerCamera');
        var camBtn = document.getElementById('camBtn');
        if (!camDiv) return;
        camDiv.style.display = 'block';
        camBtn.classList.add('active');
        camBtn.title = 'Tắt camera';
        try {
            html5Scanner = new Html5Qrcode('scannerCamera');
            html5Scanner.start(
                { facingMode: 'environment' },
                { fps: 10, qrbox: { width: 250, height: 150 } },
                function (decodedText) { onExportScanned(decodedText); },
                function () {}
            ).then(function () { isScanning = true; })
            .catch(function (err) {
                console.error(err);
                toast('Không thể mở camera: ' + err, 'danger');
                stopCamera();
            });
        } catch (e) {
            console.error(e);
            toast('Lỗi: ' + e.message, 'danger');
            stopCamera();
        }
    }

    function stopCamera() {
        if (html5Scanner) {
            try { html5Scanner.stop().then(function () { html5Scanner = null; }).catch(function () {}); } catch (e) {}
        }
        var camDiv = document.getElementById('scannerCamera');
        if (camDiv) camDiv.style.display = 'none';
        var camBtn = document.getElementById('camBtn');
        if (camBtn) { camBtn.classList.remove('active'); camBtn.title = 'Mở camera để quét'; }
        isScanning = false;
    }

    function updateOrderCounter() {
        var totalRows = document.querySelectorAll('#detailBody tr').length;
        var elTotal = document.getElementById('totalRowCount');
        if (elTotal) elTotal.textContent = totalRows;
        if (isOrderMode) {
            var count = 0;
            document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
                if (sel.value) count++;
            });
            var el = document.getElementById('orderScannedCount');
            if (el) el.textContent = count;
        }
        if (isTransferMode && typeof updateTransferCounter === 'function') {
            updateTransferCounter();
        }
    }

    function onExportScanned(serial) {
        if (!serial) return;
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) { toast('Vui lòng chọn kho trước khi quét', 'danger'); return; }
        if (exportScannerLocked) return;
        exportScannerLocked = true;

        var url = ctx + '/inventory-lookup?action=scan'
                + '&serial=' + encodeURIComponent(serial)
                + '&warehouseId=' + encodeURIComponent(whId);

        var focusScan = function () {
            var scanEl = document.getElementById('scanBox');
            if (scanEl) { scanEl.value = ''; scanEl.focus(); }
        };

        fetch(url)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                exportScannerLocked = false;
                if (!data || !data.found) {
                    toast((data && data.message) ? data.message : 'Serial không tồn tại trong hệ thống', 'danger');
                    focusScan();
                    return;
                }
                if (data.inTargetWarehouse === false) {
                    toast('Serial "' + data.serialNumber + '" không có trong kho này.', 'danger');
                    focusScan();
                    return;
                }

                // Check duplicate serial in existing rows
                var dupFound = false;
                document.querySelectorAll('#detailBody select[name="serialNumber"]').forEach(function (select) {
                    if (select.value && select.value === data.serialNumber) {
                        dupFound = true;
                    }
                });
                if (dupFound) {
                    toast('Serial "' + data.serialNumber + '" đã có trong phiếu, không thể quét trùng.', 'danger');
                    focusScan();
                    return;
                }

                var tr = buildEmptyRow();
                if (data.inventoryId) {
                    tr.setAttribute('data-inventory-id', data.inventoryId);
                }
                var sel = tr.querySelector('select[name="generatorId"]');
                if (sel && data.generatorId) {
                    sel.setAttribute('data-current', data.generatorId);
                    renderGeneratorOptions(sel);
                }
                var serialSel = tr.querySelector('select[name="serialNumber"]');
                if (serialSel) {
                    var opt = document.createElement('option');
                    opt.value = data.serialNumber;
                    opt.textContent = data.serialNumber + ' (' + (data.generatorModel || '') + ')';
                    opt.selected = true;
                    serialSel.innerHTML = '';
                    serialSel.appendChild(opt);
                    var newOpt = document.createElement('option');
                    newOpt.value = '';
                    newOpt.textContent = '-- Chọn serial --';
                    serialSel.insertBefore(newOpt, opt);
                }
                var stockDiv = tr.querySelector('.col-stock');
                if (stockDiv && data.generatorModel) {
                    stockDiv.textContent = 'Đã quét: ' + data.generatorModel;
                    stockDiv.style.color = 'var(--accent)';
                    stockDiv.style.fontWeight = '600';
                }
                var tbody = document.getElementById('detailBody');
                tbody.querySelectorAll('tr').forEach(function (r) {
                    var gs = r.querySelector('select[name="generatorId"]');
                    if (gs && !gs.value) r.remove();
                });
                tbody.appendChild(tr);
                updateRowNumbers();
                updateOrderCounter();
                toast('Đã thêm serial ' + data.serialNumber, 'success');
                focusScan();
            })
            .catch(function (err) {
                exportScannerLocked = false;
                console.error(err);
                toast('Lỗi kết nối: ' + err.message, 'danger');
            });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var scanInput = document.getElementById('scanBox');
        if (scanInput) {
            scanInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    var val = scanInput.value.trim();
                    if (val) onExportScanned(val);
                }
            });
        }
        refreshExportScannerState();
        var whSelect = document.getElementById('warehouseSelect');
        if (whSelect) {
            whSelect.addEventListener('change', refreshExportScannerState);
        }
        if (scanInput && !scanInput.disabled) {
            scanInput.focus();
        }
        if (isOrderMode) {
            updateOrderCounter();
        }
    });





    function confirmCancelCreate() {
        if (confirm('Huỷ tạo phiếu xuất? Dữ liệu đã nhập sẽ không được lưu.')) {
            window.location.href = window.APP_CTX + '/export-receipt';
        }
    }
    window.addEventListener('beforeunload', function () { stopCamera(); });
</script>
</body>
</html>
