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
        .order-pin { padding: 10px 14px; background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
            border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; }
        .order-pin .order-cust { color: var(--fg-soft); font-weight: 500; }

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

        .row-del-btn { width: 28px; height: 28px; border: 1px solid transparent;
            background: transparent; color: var(--danger); cursor: pointer;
            border-radius: var(--radius-sm); display: inline-flex; align-items: center;
            justify-content: center; margin-top: 4px; }
        .row-del-btn:hover { background: var(--danger-soft); border-color: color-mix(in srgb, var(--danger) 25%, transparent); }
        .row-del-btn:disabled { color: var(--muted); cursor: not-allowed; opacity: 0.5; }
        .add-row-btn { margin-top: 12px; font-size: 13px; }
        .add-row-btn:disabled { opacity: 0.5; cursor: not-allowed; }

        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert ul { margin: 4px 0 0 18px; padding: 0; }
        .alert-error { background: var(--danger-soft); color: var(--danger);
            border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
        .alert-warn { background: var(--warn-soft); color: var(--warn);
            border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
        .alert-info { background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }

        a.btn { text-decoration: none; }

        .side-panel-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 1000; opacity: 0; visibility: hidden; transition: opacity 0.3s; }
        .side-panel-overlay.show { opacity: 1; visibility: visible; }
        .side-panel { position: fixed; top: 0; right: -420px; width: 400px; max-width: 100%; height: 100%; background: var(--bg); box-shadow: -8px 0 32px rgba(0,0,0,0.1); z-index: 1001; transition: right 0.3s cubic-bezier(0.16, 1, 0.3, 1); display: flex; flex-direction: column; }
        .side-panel.show { right: 0; }
        .side-panel-head { display: flex; justify-content: space-between; align-items: center; padding: 24px; border-bottom: 1px solid var(--border); flex-shrink: 0; }
        .side-panel-title { font-size: 18px; font-weight: 700; margin: 0; }
        .side-panel-close { width: 32px; height: 32px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 22px; display: grid; place-items: center; border-radius: var(--radius-sm); }
        .side-panel-close:hover { background: var(--surface-2); color: var(--fg); }
        .side-panel-body { flex: 1; overflow-y: auto; padding: 24px; }
        .serial-search-box { width: 100%; padding: 12px 16px; border: 1px solid var(--border); border-radius: var(--radius); background: var(--bg); color: var(--fg); font-size: 14px; font-family: var(--font-ui); box-sizing: border-box; }
        .serial-search-box:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .serial-list-wrap { display: flex; flex-direction: column; gap: 12px; }
        .serial-card { padding: 16px; border: 1px solid var(--border); border-radius: var(--radius); background: var(--surface); cursor: pointer; transition: all 0.2s; display: flex; justify-content: space-between; align-items: center; }
        .serial-card:hover { border-color: var(--accent); box-shadow: 0 4px 12px rgba(13,110,253,0.1); transform: translateY(-1px); }
        .serial-card-left { display: flex; flex-direction: column; gap: 6px; }
        .serial-number-text { font-family: var(--font-mono); font-size: 15px; font-weight: 700; }
        .serial-meta { font-size: 12px; color: var(--muted); display: flex; gap: 12px; align-items: center; }
        .serial-card-icon { color: var(--accent); opacity: 0; transition: 0.2s; transform: translateX(-8px); }
        .serial-card:hover .serial-card-icon { opacity: 1; transform: translateX(0); }
        .badge-avail { display: inline-flex; align-items: center; gap: 4px; padding: 2px 6px; border-radius: 12px; font-size: 10px; font-weight: 700; background: #d1fae5; color: #059669; text-transform: uppercase; }
        .empty-msg { text-align: center; padding: 40px 20px; color: var(--muted); font-size: 14px; }

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
            <h1>Tạo phiếu xuất kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / Tạo mới</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                        <a class="btn" href="${pageContext.request.contextPath}/export-receipt">Huỷ</a>
                        <button type="submit" name="submitMode" value="draft" form="receiptForm" class="btn" title="Lưu nháp để chỉnh sửa tiếp">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                            Lưu nháp
                        </button>
                        <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            Gửi phiếu
                        </button>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/export-receipt">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar" style="background: oklch(58% 0.16 250);">X</div>
                <div class="hero-body">
                    <h2 class="hero-name">Phiếu xuất kho</h2>
                    <div class="hero-meta">
                        <span>Chọn kho trước, chỉ những máy đang có tồn kho sẽ hiển thị</span>
                        <c:if test="${not empty order}">
                            <span class="sep">·</span>
                            <span>Tạo từ đơn <span class="id">${order.orderCode}</span></span>
                        </c:if>
                    </div>
                </div>
            </div>

            <form id="receiptForm" action="${pageContext.request.contextPath}/export-receipt?action=save" method="POST" onsubmit="return validateReceiptForm()">
                <c:if test="${not empty receipt.orderId}">
                    <input type="hidden" name="orderId" value="${receipt.orderId}" />
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
                                <select id="warehouseSelect" name="warehouseId" required onchange="onWarehouseChange()">
                                    <option value="">-- Chọn kho trước --</option>
                                    <c:forEach var="wh" items="${warehouses}">
                                        <option value="${wh.warehouseId}">${wh.name}</option>
                                    </c:forEach>
                                </select>
                                <span class="field-error" style="display:none;"></span>
                            </div>
                            <div class="form-field">
                                <label>Lý do *</label>
                                <select name="reasonId" class="input" required onchange="validateField(this)">
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${receiptReasons}">
                                        <option value="${r.id}">${r.name}</option>
                                    </c:forEach>
                                </select>
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
                        <div id="warehouseWarn" class="alert alert-info" style="display:none;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Vui lòng chọn kho trước</div>
                                <div>Danh sách máy phát điện sẽ chỉ hiển thị những máy đang có tồn kho tại kho bạn chọn.</div>
                            </div>
                        </div>
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th class="col-gen">Máy phát (Tồn kho)</th>
                                    <th class="col-serial">Serial</th>
                                    <th style="width:130px;">Đơn giá</th>
                                    <th style="width:130px;">Thành tiền</th>
                                    <th class="col-note">Ghi chú</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <tr>
                                    <td class="col-num"><span class="row-num">1</span></td>
                                    <td>
                                        <select name="generatorId" required disabled onchange="onGeneratorChange(this)">
                                            <option value="">-- Chọn kho trước --</option>
                                        </select>
                                        <div class="col-stock"></div>
                                        <span class="field-error" style="display:none;"></span>
                                    </td>
                                    <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly disabled style="cursor:pointer;background:var(--surface-2);" onclick="openSerialModal(this)"/><span class="field-error" style="display:none;"></span></td>
                                    <td><input type="text" name="unitPrice" class="price-input mono" readonly placeholder="0₫" oninput="updateRowTotal(this)" style="width:120px;" /><span class="field-error" style="display:none;"></span></td>
                                    <td class="col-price mono row-subtotal">0₫</td>
                                    <td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" disabled onclick="removeRow(this)" title="Xoá dòng">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr class="total-row">
                                    <td colspan="4" class="text-right" style="text-align:right;padding:10px 12px;font-weight:700;border-top:2px solid var(--border);">Tổng cộng:</td>
                                    <td class="mono" id="grandTotal" style="padding:10px 12px;font-weight:700;border-top:2px solid var(--border);">0₫</td>
                                    <td colspan="2" style="border-top:2px solid var(--border);"></td>
                                </tr>
                            </tfoot>
                        </table>

                        <button type="button" class="btn add-row-btn" id="addRowBtn" disabled onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </section>
                </div>

            </form>
        </main>
    </div>
</div>

<div class="side-panel-overlay" id="sidePanelOverlay" onclick="closeSerialPanel()"></div>
<div class="side-panel" id="sidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn Số Serial</h3>
        <button class="side-panel-close" onclick="closeSerialPanel()">&times;</button>
    </div>
    <div class="side-panel-body">
        <div style="display:flex; gap: 8px; margin-bottom: 20px;">
            <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm nhanh Serial..."/>
            <select id="serialSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                <option value="desc">Mới nhất</option>
                <option value="asc">Cũ nhất</option>
            </select>
        </div>
        <div id="serialLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
            </svg><br>Đang tải...
        </div>
        <div class="serial-list-wrap" id="serialList"></div>
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
    var generatorCache = [];
    var prefillDetails = [
        <c:forEach var="d" items="${receipt.details}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{generatorId: ${d.generatorId}, note: '<c:out value="${d.note}"/>'}
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
    var currentSerialInput = null;

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
            html += '<option value="' + g.id + '" data-price="' + (g.unitPrice || 0) + '" data-stock="' + (g.stockQty || 0) + '"' + sel + '>' + label + '</option>';
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
            })
            .catch(function (err) {
                console.error(err);
                generatorCache = [];
                disableAllRows(false);
                refreshAllGeneratorSelects();
                applyPrefill();
            });
    }

    function refreshAllGeneratorSelects() {
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            renderGeneratorOptions(sel);
        });
    }

    function disableAllRows(disabled) {
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            row.querySelectorAll('select[name="generatorId"], input[name="serialNumber"]').forEach(function (el) {
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
        });
        updateRowNumbers();
        updateGrandTotal();
    }

    function onGeneratorChange(sel) {
        var row = sel.closest('tr');
        var opt = sel.options[sel.selectedIndex];
        var price = parseFloat(opt && opt.getAttribute('data-price')) || 0;
        var stock = parseInt(opt && opt.getAttribute('data-stock')) || 0;
        var priceInput = row.querySelector('input[name="unitPrice"]');
        if (priceInput && price > 0) priceInput.value = price;
        var stockInfo = row.querySelector('.col-stock');
        if (stockInfo) {
            if (sel.value) {
                stockInfo.textContent = 'Tồn kho: ' + stock + ' máy';
            } else {
                stockInfo.textContent = '';
            }
        }
        var serialInput = row.querySelector('input[name="serialNumber"]');
        if (serialInput) serialInput.value = '';
        updateRowTotal(priceInput);
    }

    function updateRowTotal(el) {
        var row = el ? el.closest('tr') : null;
        if (!row) return;
        var priceStr = row.querySelector('input[name="unitPrice"]').value.replace(/[^0-9]/g, '');
        var price = parseFloat(priceStr) || 0;
        row.querySelector('.row-subtotal').textContent = formatVND(price);
        updateGrandTotal();
    }

    function updateGrandTotal() {
        var grand = 0;
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            var priceStr = row.querySelector('input[name="unitPrice"]').value.replace(/[^0-9]/g, '');
            var price = parseFloat(priceStr) || 0;
            grand += price;
        });
        document.getElementById('grandTotal').textContent = formatVND(grand);
    }

    function openSerialModal(inputElem) {
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) { toast('Vui lòng chọn Kho trước!', 'danger'); return; }
        var tr = inputElem.closest('tr');
        var genSelect = tr.querySelector('select[name="generatorId"]');
        var genId = genSelect.value;
        if (!genId) { toast('Vui lòng chọn Máy phát trước!', 'danger'); return; }
        currentSerialInput = inputElem;
        document.getElementById('serialSearchInput').value = '';
        document.getElementById('serialSortOrder').value = 'desc';
        document.getElementById('sidePanelOverlay').classList.add('show');
        document.getElementById('sidePanel').classList.add('show');
        document.getElementById('serialList').innerHTML = '';
        document.getElementById('serialLoading').style.display = 'block';
        setTimeout(function() { document.getElementById('serialSearchInput').focus(); }, 300);
        var warehouseId = parseInt(whId, 10);
        var gId = parseInt(genId, 10);
        var filtered = [];
        for (var k = 0; k < allSerials.length; k++) {
            var s = allSerials[k];
            if (s.warehouseId === warehouseId && s.generatorId === gId) {
                filtered.push(s);
            }
        }
        document.getElementById('serialLoading').style.display = 'none';
        var listWrap = document.getElementById('serialList');
        if (filtered.length === 0) {
            listWrap.innerHTML = '<div class="empty-msg">Không có serial nào trong kho đang rảnh.</div>';
            return;
        }
        var selectedSerials = Array.from(document.querySelectorAll('input[name="serialNumber"]'))
            .map(function(inp) { return inp.value; }).filter(function(val) { return val !== ''; });
        var count = 0;
        for (var i = 0; i < filtered.length; i++) {
            var sn = filtered[i];
            if (selectedSerials.indexOf(sn.serialNumber) === -1) {
                (function(serialNumber, createdAt) {
                    var dateStr = 'Chưa xác định';
                    var timestamp = 0;
                    if (createdAt) {
                        var d = new Date(createdAt);
                        if (!isNaN(d.getTime())) {
                            timestamp = d.getTime();
                            var dd = String(d.getDate()).padStart(2, '0');
                            var mm = String(d.getMonth() + 1).padStart(2, '0');
                            var yyyy = d.getFullYear();
                            dateStr = dd + '/' + mm + '/' + yyyy;
                        }
                    }
                    var card = document.createElement('div');
                    card.className = 'serial-card';
                    card.setAttribute('data-serial', serialNumber.toLowerCase());
                    card.setAttribute('data-date', dateStr);
                    card.setAttribute('data-time', timestamp);
                    card.innerHTML = '<div class="serial-card-left">'
                        + '<div class="serial-number-text">' + escapeHtml(serialNumber) + '</div>'
                        + '<div class="serial-meta"><span>' + dateStr + '</span><span class="badge-avail">IN STOCK</span></div>'
                        + '</div>'
                        + '<div class="serial-card-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg></div>';
                    card.onclick = function() {
                        currentSerialInput.value = serialNumber;
                        closeSerialPanel();
                    };
                    listWrap.appendChild(card);
                    count++;
                })(sn.serialNumber, sn.createdAt);
            }
        }
        if (count === 0) {
            listWrap.innerHTML = '<div class="empty-msg">Tất cả serial khả dụng đã được chọn.</div>';
        }
        filterAndSortSerials();
    }

    function filterAndSortSerials() {
        var query = document.getElementById('serialSearchInput').value.toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;
        var listWrap = document.getElementById('serialList');
        var items = Array.from(listWrap.querySelectorAll('.serial-card'));
        items.sort(function(a, b) {
            var timeA = parseInt(a.getAttribute('data-time') || '0', 10);
            var timeB = parseInt(b.getAttribute('data-time') || '0', 10);
            if (sortOrder === 'desc') return timeB - timeA;
            return timeA - timeB;
        });
        for (var i = 0; i < items.length; i++) {
            var text = items[i].getAttribute('data-serial');
            items[i].style.display = text.indexOf(query) !== -1 ? 'flex' : 'none';
            listWrap.appendChild(items[i]);
        }
    }

    function closeSerialPanel() {
        document.getElementById('sidePanelOverlay').classList.remove('show');
        document.getElementById('sidePanel').classList.remove('show');
        currentSerialInput = null;
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
                + '<td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly style="cursor:pointer;background:var(--surface-2);" onclick="openSerialModal(this)"/><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="unitPrice" class="price-input mono" readonly placeholder="0₫" oninput="updateRowTotal(this)" style="width:120px;" /><span class="field-error" style="display:none;"></span></td>'
                + '<td class="col-price mono row-subtotal">0₫</td>'
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
    }

    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
        updateGrandTotal();
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
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

    function validateReceiptForm() {
        var submitter = (typeof event !== 'undefined' && event && event.submitter) ? event.submitter : null;
        var isDraft = submitter && submitter.value === 'draft';
        if (isDraft) {
            return true;
        }
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
        }
        return valid;
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (prefillDetails && prefillDetails.length > 0) {
            var whId = document.getElementById('warehouseSelect').value;
            if (whId) {
                onWarehouseChange();
            }
        }
        updateGrandTotal();
    });

    document.getElementById('serialSearchInput').addEventListener('input', filterAndSortSerials);
    document.getElementById('serialSortOrder').addEventListener('change', filterAndSortSerials);
</script>
</body>
</html>
