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
    <title>Chỉnh sửa phiếu xuất — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; }
        .form-field { display: flex; flex-direction: column; gap: 6px; }
        .form-field.full { grid-column: 1 / -1; }
        .form-field label { font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-field input, .form-field select, .form-field textarea {
            width: 100%; padding: 9px 12px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); box-sizing: border-box;
        }
        .form-field input:focus, .form-field select:focus, .form-field textarea:focus {
            outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent);
        }
        .form-field textarea { min-height: 70px; resize: vertical; font-family: var(--font-ui); }
        .form-field input:disabled, .form-field select:disabled { background: var(--surface-2); color: var(--muted); cursor: not-allowed; }

        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th { text-align: left; padding: 10px 12px; font-size: 11px;
            font-weight: 700; color: var(--muted); border-bottom: 1px solid var(--border);
            text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); }
        .detail-table td { padding: 8px 8px; vertical-align: top; border-bottom: 1px solid var(--border); }
        .detail-table tbody tr:last-child td { border-bottom: 0; }
        .detail-table select, .detail-table input {
            width: 100%; padding: 7px 10px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); box-sizing: border-box;
        }
        .detail-table select:focus, .detail-table input:focus {
            outline: none; border-color: var(--accent);
        }
        .detail-table .col-num { width: 36px; text-align: center; color: var(--muted);
            font-size: 12px; font-weight: 600; padding-top: 14px; font-family: var(--font-mono); }
        .detail-table .col-gen { min-width: 200px; }
        .detail-table .col-serial { min-width: 130px; }
        .detail-table .col-note { min-width: 130px; }
        .detail-table .col-del { width: 40px; text-align: center; }
        .detail-table .col-stock { font-size: 11px; color: var(--muted); margin-top: 2px; font-family: var(--font-mono); }
        .detail-table tr.row-short { background: color-mix(in srgb, var(--danger) 6%, transparent); }
        .detail-table tr.row-short select[name="generatorId"],
        .detail-table tr.row-short input[name="serialNumber"] { border-color: var(--danger); }
        .detail-table tr.row-short .col-stock { color: var(--danger); font-weight: 600; }

        .row-del-btn { width: 28px; height: 28px; border: 1px solid transparent;
            background: transparent; color: var(--danger); cursor: pointer;
            border-radius: var(--radius-sm); display: inline-flex; align-items: center;
            justify-content: center; margin-top: 4px; }
        .row-del-btn:hover { background: var(--danger-soft); border-color: color-mix(in srgb, var(--danger) 25%, transparent); }
        .add-row-btn { margin-top: 12px; font-size: 13px; }

        .scanner-box { display: flex; flex-direction: column; gap: 8px; padding: 14px 16px;
            background: color-mix(in srgb, var(--accent) 6%, var(--bg));
            border: 1px dashed color-mix(in srgb, var(--accent) 35%, transparent);
            border-radius: var(--radius); margin-bottom: 14px; }
        .scanner-box label { font-size: 11px; color: var(--accent); font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.04em; }
        .scanner-box input { width: 100%; padding: 10px 14px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 14px; font-family: var(--font-mono); box-sizing: border-box; }
        .scanner-box input:focus { outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 18%, transparent); }
        .scanner-box small { color: var(--muted); font-size: 12px; }

        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert ul { margin: 4px 0 0 18px; padding: 0; }
        .alert pre { margin: 6px 0 0; font-family: inherit; font-size: 13px;
            white-space: pre-wrap; word-break: break-word; line-height: 1.5; }
        .alert-error { background: var(--danger-soft); color: var(--danger);
            border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
        .alert-warn { background: var(--warn-soft); color: var(--warn);
            border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }

        a.btn { text-decoration: none; }
        .hero-avatar.edit { background: oklch(58% 0.16 250); }
        .field-error { display: none; font-size: 11px; color: #dc3545; margin-top: 3px; }

        .scanner-row { display: flex; gap: 8px; align-items: stretch; }
        .scanner-row input { flex: 1; }
        .scanner-row .cam-btn { width: 42px; min-width: 42px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--accent); cursor: pointer; display: grid; place-items: center; }
        .scanner-row .cam-btn:hover { background: var(--accent-soft); border-color: var(--accent); }
        .scanner-row .cam-btn.active { background: var(--danger-soft); color: var(--danger); border-color: var(--danger); }
        #scannerCamera { display: none; margin-top: 8px; }
        #scannerCamera video { width: 100%; max-width: 400px; border-radius: var(--radius-sm); }

        @media (max-width: 760px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chỉnh sửa phiếu xuất</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / <c:out value="${receipt.receiptCode}"/> / Chỉnh sửa</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="javascript:void(0)" onclick="confirmCancelEdit()">Huỷ</a>
                <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    Gửi lại để duyệt
                </button>
            </div>
        </header>

        <main>
            <a class="back-link" href="javascript:void(0)" onclick="confirmCancelEdit()">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại chi tiết phiếu
            </a>

            <div class="hero">
                <div class="hero-avatar edit">X</div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${receipt.receiptCode}"/>
                        <span class="status-pill" style="background: oklch(94% 0.04 75); color: oklch(50% 0.13 75); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">Yêu cầu chỉnh sửa</span>
                    </h2>
                    <div class="hero-meta">
                        <span>Phiếu xuất kho</span>
                        <span class="sep">·</span>
                        <span class="id">#${receipt.receiptId}</span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty receipt.reasonNote or not empty receipt.reasonName}">
                <div class="alert alert-warn">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <div class="alert-title">Lý do quản lý yêu cầu chỉnh sửa</div>
                        <c:if test="${not empty receipt.reasonName}">
                            <div><strong>Lý do:</strong> <c:out value="${receipt.reasonName}"/></div>
                        </c:if>
                        <c:if test="${not empty receipt.reasonNote}">
                            <pre><c:out value="${receipt.reasonNote}"/></pre>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <form id="receiptForm" action="${pageContext.request.contextPath}/export-receipt?action=update" method="POST" onsubmit="return validateReceiptForm()">
                <c:if test="${not empty errors}">
                    <div class="alert alert-error" style="margin: 16px 0;">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <div class="alert-body">
                            <div class="alert-title">Không thể cập nhật phiếu &mdash; tồn kho không đủ</div>
                            <ul>
                                <c:forEach var="e" items="${errors}">
                                    <li><c:out value="${e}"/></li>
                                </c:forEach>
                            </ul>
                            <div style="margin-top: 8px; font-size: 12px; color: var(--muted);">
                                Vui lòng nhập thêm máy vào kho rồi cập nhật lại phiếu.
                            </div>
                        </div>
                    </div>
                </c:if>
                <input type="hidden" name="receiptId" value="${receipt.receiptId}" />

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
                                <select id="warehouseSelect" name="warehouseId" required onchange="onWarehouseChange()">
                                    <option value="">-- Chọn kho --</option>
                                    <c:forEach var="wh" items="${warehouses}">
                                        <option value="${wh.warehouseId}" <c:if test="${receipt.warehouseId == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                                    </c:forEach>
                                </select>
                                <span class="field-error"></span>
                            </div>
                            <div class="form-field">
                                <label>Lý do *</label>
                                <select name="reasonId" class="input" required onchange="validateField(this)">
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${receiptReasons}">
                                        <option value="${r.id}" <c:if test="${receipt.reasonId == r.id}">selected</c:if>>${r.name}</option>
                                    </c:forEach>
                                </select>
                                <span class="field-error"></span>
                            </div>
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
                        <div id="realtimeWarn" class="alert alert-error" style="display:none; margin: 0 0 14px 0;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Tồn kho không đủ để xuất</div>
                                <ul id="realtimeWarnList"></ul>
                                <div style="margin-top: 8px; font-size: 12px; color: var(--muted);">
                                    Vui lòng nhập thêm máy vào kho rồi cập nhật lại phiếu.
                                </div>
                            </div>
                        </div>
                        <div class="scanner-box">
                            <label>Quét barcode nhanh</label>
                            <div class="scanner-row">
                                <input type="text" id="scanBox" autocomplete="off"
                                       placeholder="Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)..." />
                                <button type="button" class="cam-btn" id="camBtn" title="Mở camera để quét" onclick="toggleCamera()">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"/><circle cx="12" cy="13" r="4"/></svg>
                                </button>
                            </div>
                            <div id="scannerCamera"></div>
                            <small>Mỗi lần quét, hệ thống tự reserve serial nếu máy đang IN_STOCK tại kho <strong>${receipt.warehouseName}</strong>.</small>
                        </div>
                        <table class="detail-table">
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
                                <c:choose>
                                    <c:when test="${not empty receipt.details}">
                                        <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                            <tr data-inventory-id="${d.inventoryId}" data-receipt-id="${receipt.receiptId}">
                                                <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                                <td>
                                                    <select name="generatorId" data-current="${d.generatorId}" required onchange="onGeneratorChange(this)">
                                                        <option value="">-- Chọn máy --</option>
                                                    </select>
                                                    <div class="col-stock"></div>
                                                    <span class="field-error"></span>
                                                </td>
                                                <td>
                                                    <select name="serialNumber" data-current="${d.serialNumber}" required onchange="onSerialChange(this)" style="font-family: var(--font-mono); font-size: 12px;">
                                                        <option value="">-- Chọn serial --</option>
                                                        <option value="<c:out value='${d.serialNumber}'/>" selected><c:out value="${d.serialNumber}"/></option>
                                                    </select>
                                                    <span class="field-error"></span>
                                                </td>
                                                <td><input type="text" name="detailNote" placeholder="Ghi chú" value="<c:out value='${d.note}'/>" /></td>
                                                <td class="col-del">
                                                    <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
                                            <td>
                                                <select name="generatorId" required onchange="onGeneratorChange(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                </select>
                                                <div class="col-stock"></div>
                                                <span class="field-error"></span>
                                            </td>
                                            <td>
                                                <select name="serialNumber" required onchange="onSerialChange(this)" style="font-family: var(--font-mono); font-size: 12px;">
                                                    <option value="">-- Chọn máy trước --</option>
                                                </select>
                                                <span class="field-error"></span>
                                            </td>
                                            <td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>
                                            <td class="col-del">
                                                <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <button type="button" class="btn add-row-btn" onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
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
    var generatorCache = [];
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
        stopCamera();
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) {
            generatorCache = [];
            refreshAllGeneratorSelects();
            validateInventoryRealtime();
            return;
        }
        fetch(ctx + '/export-receipt?action=loadGenerators&warehouseId=' + encodeURIComponent(whId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                generatorCache = data || [];
                refreshAllGeneratorSelects();
                preSelectExistingRows();
                validateInventoryRealtime();
            });
    }

    function refreshAllGeneratorSelects() {
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            renderGeneratorOptions(sel);
        });
    }

    function onGeneratorChange(sel) {
        var row = sel.closest('tr');
        var opt = sel.options[sel.selectedIndex];
        var stock = parseInt(opt && opt.getAttribute('data-stock')) || 0;
        var stockInfo = row.querySelector('.col-stock');
        if (stockInfo) {
            if (sel.value) stockInfo.textContent = 'Tồn kho: ' + stock + ' máy';
            else stockInfo.textContent = '';
        }
        var serialSelect = row.querySelector('select[name="serialNumber"]');
        populateSerialOptions(serialSelect, parseInt(sel.value, 10));
        validateInventoryRealtime();
    }

    function onSerialChange(sel) {
        filterAlreadySelected();
        validateInventoryRealtime();
    }

    function escapeHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
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

    function buildEmptyRow() {
        var tr = document.createElement('tr');
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td><select name="generatorId" required onchange="onGeneratorChange(this)"><option value="">-- Chọn máy --</option></select><div class="col-stock"></div><span class="field-error" style="display:none;"></span></td>'
                + '<td><select name="serialNumber" required onchange="onSerialChange(this)" style="font-family: var(--font-mono); font-size: 12px;"><option value="">-- Chọn máy trước --</option></select><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        renderGeneratorOptions(tr.querySelector('select[name="generatorId"]'));
        return tr;
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        tbody.appendChild(buildEmptyRow());
        updateRowNumbers();
        validateInventoryRealtime();
        filterAlreadySelected();
    }
    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        var row = btn.closest('tr');
        var invId = parseInt(row.getAttribute('data-inventory-id') || '0', 10);
        var receiptId = parseInt(row.getAttribute('data-receipt-id') || ('${receipt.receiptId}') || '0', 10);
        if (invId > 0 && receiptId > 0 && window.ExportScannerActions) {
            btn.disabled = true;
            window.ExportScannerActions.removeScannedSerial(receiptId, invId)
                .then(function (data) {
                    if (!data || !data.success) {
                        btn.disabled = false;
                        toast((data && data.message) ? data.message : 'Lỗi khi giải phóng serial', 'danger');
                        return;
                    }
                    row.remove();
                    updateRowNumbers();
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
            validateInventoryRealtime();
        }
    }
    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
        });
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

    function validateQty(input) {
        var v = input.value.replace(/[^0-9]/g, '');
        var n = parseInt(v);
        var maxStock = parseInt(input.getAttribute('max')) || 100000;
        if (isNaN(n) || n < 1) { input.value = 1; }
        else if (n > maxStock) { input.value = maxStock; }
        else { input.value = n; }
        validateField(input);
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
        return valid;
    }

    document.addEventListener('DOMContentLoaded', function () {
        var whId = document.getElementById('warehouseSelect').value;
        if (whId) onWarehouseChange();
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
            window.SESSION_DATA = null;
        }
    });

    var exportEditScannerLocked = false;
    var currentEditReceiptId = parseInt('<c:out value="${receipt.receiptId}" default="0"/>', 10) || 0;

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
                function (decodedText) { onExportEditScanned(decodedText); },
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

    function onExportEditScanned(serial) {
        if (!serial) return;
        if (exportEditScannerLocked) return;
        exportEditScannerLocked = true;
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) { toast('Không xác định được kho', 'danger'); exportEditScannerLocked = false; return; }

        var url = ctx + '/inventory-lookup?action=scan'
                + '&serial=' + encodeURIComponent(serial)
                + '&warehouseId=' + encodeURIComponent(whId);

        fetch(url)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                exportEditScannerLocked = false;
                if (!data || !data.found) {
                    toast((data && data.message) ? data.message : 'Serial không tồn tại trong hệ thống', 'danger');
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
                var serialSelect = tr.querySelector('select[name="serialNumber"]');
                if (serialSelect) {
                    var opt = document.createElement('option');
                    opt.value = data.serialNumber;
                    opt.textContent = data.serialNumber + ' (' + (data.generatorModel || '') + ')';
                    opt.selected = true;
                    serialSelect.innerHTML = '';
                    serialSelect.appendChild(opt);
                    var newOpt = document.createElement('option');
                    newOpt.value = '';
                    newOpt.textContent = '-- Chọn serial --';
                    serialSelect.insertBefore(newOpt, opt);
                }
                var stockDiv = tr.querySelector('.col-stock');
                if (stockDiv && data.generatorModel) {
                    stockDiv.textContent = 'Đã quét: ' + data.generatorModel;
                    stockDiv.style.color = 'var(--accent)';
                    stockDiv.style.fontWeight = '600';
                }
                document.getElementById('detailBody').appendChild(tr);
                updateRowNumbers();
                if (typeof validateInventoryRealtime === 'function') validateInventoryRealtime();
                toast('Đã thêm serial ' + data.serialNumber, 'success');
                var scanEl = document.getElementById('scanBox');
                if (scanEl) { scanEl.value = ''; scanEl.focus(); }
            })
            .catch(function (err) {
                exportEditScannerLocked = false;
                console.error(err);
                toast('Lỗi kết nối: ' + err.message, 'danger');
            });
    }

    function preSelectExistingRows() {
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            var genId = parseInt(sel.getAttribute('data-current'), 10);
            var tr = sel.closest('tr');
            var serialSelect = tr.querySelector('select[name="serialNumber"]');
            var curSerial = serialSelect && serialSelect.getAttribute('data-current');
            if (genId && serialSelect) {
                populateSerialOptions(serialSelect, genId, curSerial);
                if (curSerial) serialSelect.value = curSerial;
                filterAlreadySelected();
                var stockInfo = tr.querySelector('.col-stock');
                if (stockInfo) {
                    var opt = sel.options[sel.selectedIndex];
                    var stock = parseInt(opt && opt.getAttribute('data-stock')) || 0;
                    if (sel.value) stockInfo.textContent = 'Tồn kho: ' + stock + ' máy';
                }
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        var scanInput = document.getElementById('scanBox');
        if (scanInput) {
            scanInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    var val = scanInput.value.trim();
                    if (val) onExportEditScanned(val);
                }
            });
            scanInput.focus();
        }
    });

    window.addEventListener('beforeunload', function () { stopCamera(); });

    function confirmCancelEdit() {
        var receiptId = currentEditReceiptId;
        if (receiptId) {
            window.location.href = window.APP_CTX + '/export-receipt?action=detail&id=' + receiptId;
        } else {
            window.location.href = window.APP_CTX + '/export-receipt';
        }
    }
</script>
</body>
</html>