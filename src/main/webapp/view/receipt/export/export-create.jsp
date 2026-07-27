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
    <style>
        .confirm-summary {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 14px 16px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            margin: 6px 0 4px;
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
        .confirm-row span {
            color: var(--muted);
            font-weight: 500;
        }
        .confirm-row strong {
            color: var(--fg);
            font-weight: 600;
            text-align: right;
            word-break: break-word;
        }
    </style>
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

            <form id="receiptForm" action="${pageContext.request.contextPath}/export-receipt?action=save" method="POST" onsubmit="return openSaveConfirm();">
                <c:if test="${not empty errors}">
                    <div class="alert alert-error" style="margin: 16px 0;">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <div class="alert-body">
                            <div class="alert-title">Không thể gửi phiếu !; tồn kho không đủ</div>
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
                                <div class="section-num">02 — DANH SÁCH MÁY PHÁT ĐIỆN</div>
                                <h3 class="section-title">Quét số serial hàng loạt</h3>
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

                        <c:if test="${fromOrder}">
                        <div class="order-req-banner">
                            <div class="req-title">Đơn hàng <strong><c:out value="${order.orderCode}"/></strong> yêu cầu:</div>
                            <c:forEach var="req" items="${orderRequirements}" varStatus="st">
                            <div class="req-item">${st.count}. <c:out value="${req.generatorModel}"/> <c:if test="${not empty req.brandName}">(<c:out value="${req.brandName}"/>)</c:if> x <strong>${req.quantity}</strong></div>
                            </c:forEach>
                        </div>
                        </c:if>
                        <div id="transferSuggestionBanner" class="alert alert-info" style="display:none; margin: 0 0 14px 0;">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7h18M9 7v12M15 7v12M3 7l3-4h12l3 4"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Đề xuất chuyển kho</div>
                                <ul id="transferSuggestionList"></ul>
                            </div>
                        </div>
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

                        <div id="detailGroups" class="detail-groups">
                            <div id="emptyState" class="empty-state" style="display:flex;">
                                <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/></svg>
                                <p class="empty-state-title">Chưa có số serial nào</p>
                                <p class="empty-state-hint">Hãy quét mã vạch số serial của máy cần xuất để bắt đầu</p>
                            </div>
                        </div>

                        <div class="order-counter">
                            <c:if test="${fromOrder}">Đã nhập: <strong id="orderScannedCount">0</strong> / <strong>${expectedRows}</strong> số serial &middot; </c:if>
                            <c:if test="${fromTransfer}">Đã nhập: <strong id="transferScannedCount">0</strong> / <strong>${expectedTransferRows}</strong> số serial &middot; </c:if>
                            Tổng số dòng: <strong id="totalRowCount">0</strong>
                            <c:if test="${not fromOrder and not fromTransfer}">Đã nhập: <strong id="plainScannedCount">0</strong> số serial</c:if>
                        </div>

                    </section>
                </div>

            </form>

            <div class="bottom-actions">
                <a class="btn" href="javascript:void(0)" onclick="confirmCancelCreate()">Huỷ</a>
                <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    Gửi phiếu
                </button>
            </div>
        </main>
    </div>
</div>

<div class="modal-host" id="saveConfirmModal" onclick="if (event.target === this) closeSaveConfirm();">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="saveConfirmTitle">
        <h3 id="saveConfirmTitle">Xác nhận lưu phiếu xuất</h3>
        <p class="modal-sub">Vui lòng kiểm tra thông tin trước khi lưu phiếu.</p>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeSaveConfirm()">Hủy</button>
            <button type="button" class="btn btn-primary" onclick="doConfirmSave()">
                <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                Xác nhận lưu
            </button>
        </div>
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
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    var ctx = window.APP_CTX;
    function confirmCancelCreate() {
            location.href = ctx + '/export-receipt';
    }

    // ========== DATA from server ==========
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
    var isOrderMode = ${not empty fromOrder and fromOrder};
    var isTransferMode = ${not empty fromTransfer and fromTransfer};
    var isLiquidationMode = ${not empty fromLiquidation and fromLiquidation};
    var expectedRows = ${empty expectedRows ? 0 : expectedRows};
    var expectedTransferRows = ${empty expectedTransferRows ? 0 : expectedTransferRows};
    var ORDER_REQUIREMENTS = [
        <c:forEach var="req" items="${orderRequirements}" varStatus="st">
        {genId: ${req.generatorId}, model: '<c:out value="${req.generatorModel}"/>', qty: ${req.quantity}}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var STOCK_DISTRIBUTION = ${empty stockDistributionJson ? '{}' : stockDistributionJson};
    var WAREHOUSE_MAP = ${empty warehouseMapJson ? '{}' : warehouseMapJson};
    var TRANSFER_REQUIREMENTS = [
        <c:forEach var="d" items="${transferDetails}" varStatus="st">
        {genId: ${d.generatorId}, qty: ${d.quantity}, model: '<c:out value="${d.generatorModel}"/>'}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    // ========== Group utilities (like import) ==========
    function findGenInfo(genId) {
        for (var i = 0; i < generatorCache.length; i++) {
            if (String(generatorCache[i].id) === String(genId)) return generatorCache[i];
        }
        return null;
    }

    function getOrCreateGroup(genId, genModel, genBrand) {
        var groups = document.getElementById('detailGroups');
        if (!groups) return null;
        var existing = groups.querySelector('details[data-gen-id="' + genId + '"]');
        if (existing) return existing;

        var info = findGenInfo(genId);
        var modelText = genModel || (info ? info.model : null) || ('Mẫu #' + genId);
        var brandText = genBrand ? (' (' + genBrand + ')') : '';
        if (!genBrand) {
            var info = findGenInfo(genId);
            if (info && info.brand) brandText = ' (' + info.brand + ')';
        }

        var details = document.createElement('details');
        details.className = 'detail-group';
        details.setAttribute('data-gen-id', String(genId));
        details.setAttribute('open', '');
        details.innerHTML = '<summary>'
                + '<span class="group-title">' + escapeHtml(modelText + brandText) + '</span>'
                + '<span class="group-count">(<span class="group-count-num">0</span> máy)</span>'
                + '<span class="group-spacer"></span>'
                + '<button type="button" class="group-delete-btn" onclick="removeGroup(this)" title="Xoá cả nhóm">Xoá nhóm</button>'
                + '</summary>'
                + '<table class="group-table">'
                + '<thead><tr><th class="col-num">#</th><th>Số serial</th><th class="col-note">Ghi chú</th><th class="col-del"></th></tr></thead>'
                + '<tbody></tbody>'
                + '</table>';
        groups.appendChild(details);
        return details;
    }

    function updateGroupCount(group) {
        if (!group) return;
        var tbody = group.querySelector('tbody');
        var count = tbody ? tbody.querySelectorAll('tr').length : 0;
        var countEl = group.querySelector('.group-count-num');
        if (countEl) countEl.textContent = count;
        updateEmptyState();
    }

    function updateEmptyState() {
        var groups = document.getElementById('detailGroups');
        var empty = document.getElementById('emptyState');
        if (!groups || !empty) return;
        var hasGroups = groups.querySelectorAll('details.detail-group').length > 0;
        empty.style.display = hasGroups ? 'none' : 'flex';
    }

    function buildEmptyRow() {
        var tr = document.createElement('tr');
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td class="col-serial"><input type="text" name="serialNumber" placeholder="Số serial" onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>'
                + '<td class="col-note"><input type="text" name="detailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        return tr;
    }

    function addRowToGroup(group, serial, note, inventoryId) {
        if (!group) return null;
        var tbody = group.querySelector('tbody');
        if (!tbody) return null;
        var tr = buildEmptyRow();
        if (serial != null) {
            var snInput = tr.querySelector('input[name="serialNumber"]');
            if (snInput) snInput.value = serial;
        }
        if (note != null) {
            var noteInput = tr.querySelector('input[name="detailNote"]');
            if (noteInput) noteInput.value = note;
        }
        var genId = group.getAttribute('data-gen-id');
        var hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = 'generatorId';
        hidden.value = genId;
        tr.appendChild(hidden);
        if (inventoryId != null && inventoryId !== '') {
            var invHidden = document.createElement('input');
            invHidden.type = 'hidden';
            invHidden.name = 'existingInventoryId';
            invHidden.value = inventoryId;
            tr.appendChild(invHidden);
            tr.setAttribute('data-inventory-id', inventoryId);
        }
        tbody.appendChild(tr);
        updateGroupCount(group);
        updateRowNumbers();
        return tr;
    }

    function removeRow(btn) {
        var tr = btn.closest('tr');
        if (!tr) return;
        var group = tr.closest('details.detail-group');
        tr.remove();
        if (group) {
            updateGroupCount(group);
            var tbody = group.querySelector('tbody');
            if (tbody && tbody.querySelectorAll('tr').length === 0) {
                group.remove();
                updateEmptyState();
            }
        }
        updateRowNumbers();
        validateInventoryRealtime();
    }

    function removeGroup(btn) {
        var group = btn.closest('details.detail-group');
        if (!group) return;
        if (!confirm('Xoá cả nhóm máy này?')) return;
        group.remove();
        updateEmptyState();
        updateRowNumbers();
        validateInventoryRealtime();
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailGroups details.detail-group tbody').forEach(function (tbody) {
            tbody.querySelectorAll('tr').forEach(function (tr, i) {
                var numEl = tr.querySelector('.row-num');
                if (numEl) numEl.textContent = i + 1;
            });
        });
        updateTotalCounter();
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

    // ========== Warehouse / Generator loading ==========
    var prefillApplied = false;

    function onWarehouseChange() {
        var whId = document.getElementById('warehouseSelect').value;
        var warn = document.getElementById('warehouseWarn');
        if (!whId) {
            generatorCache = [];
            warn.style.display = 'flex';
            validateInventoryRealtime();
            checkTransferSuggestions('');
            return;
        }
        warn.style.display = 'none';
        fetch(ctx + '/export-receipt?action=loadGenerators&warehouseId=' + encodeURIComponent(whId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                generatorCache = data || [];
                if (!prefillApplied) {
                    applyPrefill();
                    prefillApplied = true;
                }
                validateInventoryRealtime();
                checkTransferSuggestions(whId);
            })
            .catch(function (err) {
                console.error(err);
                generatorCache = [];
                if (!prefillApplied) {
                    applyPrefill();
                    prefillApplied = true;
                }
                validateInventoryRealtime();
                checkTransferSuggestions(whId);
            });
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

    function updateTotalCounter() {
        var totalRows = document.querySelectorAll('#detailGroups details.detail-group tbody tr').length;
        var elTotal = document.getElementById('totalRowCount');
        if (elTotal) elTotal.textContent = totalRows;

        if (isOrderMode) {
            var count = 0;
            document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
                var sn = tr.querySelector('input[name="serialNumber"]');
                if (sn && sn.value.trim()) count++;
            });
            var el = document.getElementById('orderScannedCount');
            if (el) el.textContent = count;
        }
        if (isTransferMode) {
            updateTransferCounter();
        }
        if (!isOrderMode && !isTransferMode) {
            var el3 = document.getElementById('plainScannedCount');
            if (el3) el3.textContent = totalRows;
        }
    }

    function updateTransferCounter() {
        if (!isTransferMode) return;
        var scannedByGen = {};
        document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
            var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
            var sn = tr.querySelector('input[name="serialNumber"]');
            if (genHidden && genHidden.value && sn && sn.value.trim()) {
                scannedByGen[genHidden.value] = (scannedByGen[genHidden.value] || 0) + 1;
            }
        });
        var total = 0;
        TRANSFER_REQUIREMENTS.forEach(function (req) {
            total += scannedByGen[String(req.genId)] || 0;
        });
        var el = document.getElementById('transferScannedCount');
        if (el) el.textContent = total;
    }

    // ========== Scanner ==========
    var exportScannerLocked = false;
    var exportScanBuf = '';
    var exportScanLastKey = 0;
    var EXPORT_SCAN_THRESHOLD = 50;
    var EXPORT_SCAN_MIN_LEN = 2;

    function initExportScanner() {
        document.addEventListener('keydown', function (e) {
            var now = Date.now();
            var gap = now - exportScanLastKey;
            exportScanLastKey = now;

            if (e.ctrlKey || e.altKey || e.metaKey) {
                exportScanBuf = '';
                return;
            }

            if (e.key === 'Enter' || e.key === 'Tab') {
                if (exportScanBuf.length >= EXPORT_SCAN_MIN_LEN) {
                    var serial = exportScanBuf.trim();
                    exportScanBuf = '';
                    if (serial && !exportScannerLocked) {
                        e.preventDefault();
                        handleExportScan(serial);
                    }
                    return;
                }
                exportScanBuf = '';
                return;
            }

            if (gap > EXPORT_SCAN_THRESHOLD) exportScanBuf = '';

            if (e.key && e.key.length === 1 && !e.isComposing) {
                exportScanBuf += e.key;
            } else if (e.key === 'Backspace' && exportScanBuf.length > 0) {
                exportScanBuf = exportScanBuf.slice(0, -1);
            }
        });

        document.addEventListener('visibilitychange', function () {
            if (document.hidden) exportScanBuf = '';
        });
    }

    function clearScanBuf() {
        exportScanBuf = '';
    }

    function flashRowSuccess(row) {
        if (!row) return;
        row.classList.remove('flash');
        void row.offsetWidth;
        row.classList.add('flash');
    }

    function handleExportScan(serial) {
        exportScannerLocked = true;
        serial = (serial || '').trim();
        if (!serial) {
            exportScannerLocked = false;
            return;
        }

        var whSelect = document.querySelector('select[name="warehouseId"], input[name="warehouseId"][type="hidden"]');
        var whId = whSelect ? whSelect.value : '';
        if (!whId) {
            exportScannerLocked = false;
            toast('Vui lòng chọn kho trước khi quét.', 'danger');
            clearScanBuf();
            return;
        }

        // Check duplicate
        var dupFound = null;
        document.querySelectorAll('input[name="serialNumber"]').forEach(function (inp) {
            if (inp.value.trim() === serial) dupFound = inp;
        });
        if (dupFound) {
            exportScannerLocked = false;
            var dupMsg = 'Số serial "' + serial + '" đã tồn tại trong phiếu này.';
            toast(dupMsg, 'danger');
            clearScanBuf();
            return;
        }

        var url = ctx + '/inventory-lookup?action=scan&serial=' + encodeURIComponent(serial)
                + '&warehouseId=' + encodeURIComponent(whId);

        fetch(url).then(function (r) { return r.json(); })
            .then(function (data) {
                exportScannerLocked = false;

                if (!data || !data.found) {
                    toast((data && data.message) ? data.message : ('Số serial "' + serial + '" không tồn tại trong hệ thống'), 'danger');
                    clearScanBuf();
                    return;
                }

                if (data.inTargetWarehouse === false) {
                    toast('Số serial "' + data.serialNumber + '" không có trong kho này.', 'danger');
                    clearScanBuf();
                    return;
                }

                if (data.status !== 'IN_STOCK') {
                    toast('Số serial "' + data.serialNumber + '" không ở trạng thái IN_STOCK (đang ' + (data.status || 'unknown') + ').', 'danger');
                    clearScanBuf();
                    return;
                }

                if (isOrderMode && ORDER_REQUIREMENTS && ORDER_REQUIREMENTS.length > 0) {
                    var genOk = false;
                    ORDER_REQUIREMENTS.forEach(function (req) {
                        if (String(req.genId) === String(data.generatorId)) genOk = true;
                    });
                    if (!genOk) {
                        toast('Số serial "' + data.serialNumber + '" (' + (data.generatorModel || '') + ') không thuộc đơn hàng này.', 'danger');
                        clearScanBuf();
                        return;
                    }
                    if (isOrderScannedFull(data.generatorId)) {
                        toast('Đã quét đủ số lượng ' + (data.generatorModel || 'mẫu này') + ' theo đơn hàng.', 'danger');
                        clearScanBuf();
                        return;
                    }
                }

                if (isTransferMode && TRANSFER_REQUIREMENTS && TRANSFER_REQUIREMENTS.length > 0) {
                    var genOkT = false;
                    TRANSFER_REQUIREMENTS.forEach(function (req) {
                        if (String(req.genId) === String(data.generatorId)) genOkT = true;
                    });
                    if (!genOkT) {
                        toast('Số serial "' + data.serialNumber + '" (' + (data.generatorModel || '') + ') không thuộc phiếu đề xuất này.', 'danger');
                        clearScanBuf();
                        return;
                    }
                    if (isTransferScannedFull(data.generatorId)) {
                        toast('Đã quét đủ số lượng ' + (data.generatorModel || 'mẫu này') + ' theo phiếu đề xuất.', 'danger');
                        clearScanBuf();
                        return;
                    }
                }

                var genId = data.generatorId;
                var group = getOrCreateGroup(genId, data.generatorModel, data.generatorBrand);
                if (!group) {
                    exportScannerLocked = false;
                    return;
                }
                var addedRow = addRowToGroup(group, data.serialNumber, '', data.inventoryId);
                group.setAttribute('open', '');
                flashRowSuccess(addedRow);
                toast('Đã thêm số serial "' + data.serialNumber + '" (' + (data.generatorModel || '') + ')', 'success');
                updateTotalCounter();
                validateInventoryRealtime();

                clearScanBuf();
            })
            .catch(function (err) {
                exportScannerLocked = false;
                console.error(err);
                toast('Lỗi kết nối: ' + err.message, 'danger');
                clearScanBuf();
            });
    }

    function isOrderScannedFull(genId) {
        var scanned = 0;
        document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
            var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
            var sn = tr.querySelector('input[name="serialNumber"]');
            if (genHidden && String(genHidden.value) === String(genId) && sn && sn.value.trim()) {
                scanned++;
            }
        });
        for (var i = 0; i < ORDER_REQUIREMENTS.length; i++) {
            if (String(ORDER_REQUIREMENTS[i].genId) === String(genId)) {
                return scanned >= ORDER_REQUIREMENTS[i].qty;
            }
        }
        return false;
    }

    function isTransferScannedFull(genId) {
        var scanned = 0;
        document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
            var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
            var sn = tr.querySelector('input[name="serialNumber"]');
            if (genHidden && String(genHidden.value) === String(genId) && sn && sn.value.trim()) {
                scanned++;
            }
        });
        for (var i = 0; i < TRANSFER_REQUIREMENTS.length; i++) {
            if (String(TRANSFER_REQUIREMENTS[i].genId) === String(genId)) {
                return scanned >= TRANSFER_REQUIREMENTS[i].qty;
            }
        }
        return false;
    }

    // ========== Prefill helpers (like import) ==========
    function applyPrefill() {
        if (!prefillDetails || prefillDetails.length === 0) return;
        var groups = document.getElementById('detailGroups');
        if (!groups) return;
        if (prefillApplied) return;

        prefillDetails.forEach(function (p) {
            if (!p || !p.generatorId) return;
            var group = getOrCreateGroup(p.generatorId, p.model, null);
            if (!group) return;
            if (isLiquidationMode && p.serialNumber) {
                var tr = addRowToGroup(group, p.serialNumber, p.note || '', null);
                if (tr) {
                    var snInput = tr.querySelector('input[name="serialNumber"]');
                    if (snInput) {
                        snInput.readOnly = true;
                        snInput.style.background = 'var(--surface-2)';
                    }
                    var delBtn = tr.querySelector('.row-del-btn');
                    if (delBtn) delBtn.disabled = true;
                }
            } else {
                addRowToGroup(group, '', p.note || '');
            }
        });
        document.querySelectorAll('#detailGroups details.detail-group').forEach(function (g) {
            g.setAttribute('open', '');
        });
        updateEmptyState();
        updateTotalCounter();
        validateInventoryRealtime();
    }

    // ========== Validation ==========
    function validateInventoryRealtime() {
        var banner = document.getElementById('realtimeWarn');
        var list = document.getElementById('realtimeWarnList');
        if (!banner || !list) return;
        if (!generatorCache || generatorCache.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
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
        document.querySelectorAll('#detailGroups tbody tr').forEach(function (row) {
            var genHidden = row.querySelector('input[name="generatorId"][type="hidden"]');
            var snInput = row.querySelector('input[name="serialNumber"]');
            if (!genHidden || !genHidden.value) return;
            var genId = parseInt(genHidden.value, 10);
            if (!genId) return;
            if (snInput && snInput.value.trim()) {
                requiredByGen[genId] = (requiredByGen[genId] || 0) + 1;
            }
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
        var keys = Object.keys(shortByGen);
        if (keys.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
            return;
        }
        var html = '';
        keys.forEach(function (k) {
            var id = parseInt(k, 10);
            var info = shortByGen[id];
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

    function checkTransferSuggestions(whId) {
        var banner = document.getElementById('transferSuggestionBanner');
        var list = document.getElementById('transferSuggestionList');
        if (!banner || !list) return;
        if (!whId || !ORDER_REQUIREMENTS || ORDER_REQUIREMENTS.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
            return;
        }
        var suggestions = [];
        ORDER_REQUIREMENTS.forEach(function (req) {
            var genId = String(req.genId);
            var required = req.qty;
            var dist = STOCK_DISTRIBUTION[genId];
            if (!dist) return;
            var inThisWh = parseInt(dist[whId] || 0, 10);
            if (inThisWh >= required) return;
            var shortage = required - inThisWh;
            var otherWh = [];
            Object.keys(dist).forEach(function (whKey) {
                if (whKey === whId) return;
                var qty = parseInt(dist[whKey], 10);
                if (qty > 0) {
                    otherWh.push({ id: whKey, qty: qty, name: WAREHOUSE_MAP[whKey] || ('Kho #' + whKey) });
                }
            });
            if (otherWh.length === 0) return;
            var totalOther = otherWh.reduce(function (s, o) { return s + o.qty; }, 0);
            if (totalOther === 0) return;
            var whNames = otherWh.map(function (o) { return o.name + ' (' + o.qty + ' máy)'; }).join(', ');
            suggestions.push('Máy <strong>' + escapeHtml(req.model) + '</strong> cần <strong>' + required + '</strong> máy, kho này chỉ có <strong>' + inThisWh + '</strong> máy. Còn <strong>' + shortage + '</strong> máy có tại: ' + whNames + '. Vui lòng tạo phiếu chuyển kho trước khi xuất.');
        });
        if (suggestions.length === 0) {
            banner.style.display = 'none';
            list.innerHTML = '';
            return;
        }
        var html = '';
        suggestions.forEach(function (s) { html += '<li>' + s + '</li>'; });
        list.innerHTML = html;
        banner.style.display = 'flex';
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

        var allRows = document.querySelectorAll('#detailGroups tbody tr');
        if (allRows.length === 0) {
            toast('Vui lòng quét ít nhất 1 số serial trước khi gửi phiếu.', 'danger');
            valid = false;
        }

        var hasEmptySerial = false;
        var hasEmptyGen = false;
        allRows.forEach(function (tr) {
            var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
            var snInput = tr.querySelector('input[name="serialNumber"]');
            if (snInput && !snInput.value.trim()) hasEmptySerial = true;
            if (genHidden && !genHidden.value.trim()) hasEmptyGen = true;
        });
        if (hasEmptySerial) {
            toast('Có dòng chưa nhập số serial.', 'danger');
            valid = false;
        }
        if (hasEmptyGen) {
            toast('Có dòng chưa gắn với mẫu máy.', 'danger');
            valid = false;
        }

        if (!valid) {
            if (firstInvalid) firstInvalid.focus();
            return false;
        }

        var banner = document.getElementById('realtimeWarn');
        if (banner && banner.style.display !== 'none' && banner.offsetParent !== null) {
            toast('Tồn kho không đủ để gửi phiếu. Vui lòng nhập thêm máy.', 'danger');
            return false;
        }

        // Order validation
        if (isOrderMode && ORDER_REQUIREMENTS && ORDER_REQUIREMENTS.length > 0) {
            var scannedByGen = {};
            document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
                var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
                var snInput = tr.querySelector('input[name="serialNumber"]');
                if (genHidden && genHidden.value && snInput && snInput.value.trim()) {
                    scannedByGen[genHidden.value] = (scannedByGen[genHidden.value] || 0) + 1;
                }
            });
            var mismatches = [];
            var orderGenIds = {};
            ORDER_REQUIREMENTS.forEach(function (req) {
                orderGenIds[String(req.genId)] = true;
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
            document.querySelectorAll('#detailGroups tbody tr').forEach(function (tr) {
                var genHidden = tr.querySelector('input[name="generatorId"][type="hidden"]');
                var snInput = tr.querySelector('input[name="serialNumber"]');
                if (genHidden && genHidden.value && snInput && snInput.value.trim()) {
                    scannedByGenT[genHidden.value] = (scannedByGenT[genHidden.value] || 0) + 1;
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

        return valid;
    }

    // ========== Confirm Save Modal ==========
    function openSaveConfirm() {
        if (typeof validateReceiptForm === 'function' && !validateReceiptForm()) {
            return false;
        }
        populateSaveSummary();
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.add('show');
        return false;
    }

    function closeSaveConfirm() {
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.remove('show');
    }

    function doConfirmSave() {
        closeSaveConfirm();
        var form = document.getElementById('receiptForm');
        if (form) form.submit();
    }

    function populateSaveSummary() {
        var whEl = document.getElementById('saveSummaryWh');
        var reasonEl = document.getElementById('saveSummaryReason');
        var totalEl = document.getElementById('saveSummaryTotal');

        var whSelect = document.querySelector('select[name="warehouseId"], input[name="warehouseId"][type="hidden"]');
        if (whEl) {
            if (whSelect && whSelect.tagName === 'SELECT') {
                whEl.textContent = whSelect.options[whSelect.selectedIndex]
                    ? whSelect.options[whSelect.selectedIndex].textContent.trim()
                    : '—';
            } else if (whSelect) {
                var disp = document.querySelector('.readonly-field strong');
                whEl.textContent = disp ? disp.textContent.trim() : '—';
            } else {
                whEl.textContent = '—';
            }
        }

        var reasonSelect = document.querySelector('select[name="reasonId"], input[name="reasonId"][type="hidden"]');
        if (reasonEl) {
            if (reasonSelect && reasonSelect.tagName === 'SELECT') {
                reasonEl.textContent = reasonSelect.options[reasonSelect.selectedIndex]
                    ? reasonSelect.options[reasonSelect.selectedIndex].textContent.trim()
                    : '—';
            } else if (reasonSelect) {
                var rdisp = reasonSelect.closest('.form-field');
                if (rdisp) {
                    var ssel = rdisp.querySelector('select');
                    reasonEl.textContent = (ssel && ssel.options[ssel.selectedIndex])
                        ? ssel.options[ssel.selectedIndex].textContent.trim()
                        : '—';
                } else {
                    reasonEl.textContent = '—';
                }
            } else {
                reasonEl.textContent = '—';
            }
        }

        if (totalEl) {
            var totalSource = document.getElementById('totalRowCount') || document.getElementById('orderScannedCount') || document.getElementById('transferScannedCount') || document.getElementById('plainScannedCount');
            totalEl.textContent = totalSource ? totalSource.textContent.trim() : '0';
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeSaveConfirm();
    });

    // ========== DOM Ready ==========
    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            if (typeof showToast === 'function') {
                showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
            }
        }

        if (isLiquidationMode) {
            generatorCache = [];
            applyPrefill();
            prefillApplied = true;
        } else if (prefillDetails && prefillDetails.length > 0) {
            var whId = document.getElementById('warehouseSelect').value;
            if (whId) {
                onWarehouseChange();
            } else {
                applyPrefill();
                prefillApplied = true;
            }
        }

        initExportScanner();
        updateEmptyState();
        updateTotalCounter();
        validateInventoryRealtime();
        var whId = document.getElementById('warehouseSelect').value;
        if (whId) checkTransferSuggestions(whId);
    });
</script>
</body>
</html>