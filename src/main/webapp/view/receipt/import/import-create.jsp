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
    <title>Tạo phiếu nhập kho — Warehouse OS</title>
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
        .stock-info { font-size: 11px; color: var(--muted); margin-top: 3px; font-family: var(--font-mono); display: block; min-height: 14px; }
        .stock-info .stock-label { color: var(--muted); }
        .stock-info .stock-value { color: var(--accent); font-weight: 600; }

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
            <h1>Tạo phiếu nhập kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Tạo mới</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                        <a class="btn" href="${pageContext.request.contextPath}/import-receipt">Huỷ</a>
                        <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            Gửi phiếu
                        </button>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/import-receipt">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại danh sách
            </a>

                <div class="hero-body">
                    <div class="hero-meta">
                        <c:if test="${not empty purchaseOrder}">
                            <span>Tạo từ phiếu purchase <span class="id">${purchaseOrder.poCode}</span></span>
                        </c:if>
                    </div>
                </div>

            <form id="receiptForm" action="${pageContext.request.contextPath}/import-receipt?action=save" method="POST" onsubmit="return validateReceiptForm()">
                <c:if test="${not empty receipt.purchaseOrderId}">
                    <input type="hidden" name="poId" value="${receipt.purchaseOrderId}" />
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
                                    <c:when test="${fromPurchaseOrder}">
                                        <div class="readonly-field" style="display:flex; align-items:center; gap:8px; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface-2); color: var(--fg); font-size: 13px;">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                            <c:set var="warehouseName" value=""/>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <c:if test="${wh.warehouseId == receipt.warehouseId}">
                                                    <c:set var="warehouseName" value="${wh.name}"/>
                                                </c:if>
                                            </c:forEach>
                                            <strong><c:out value="${warehouseName}"/></strong>
                                            <span style="color: var(--muted); font-size: 11px; margin-left: 4px;">(đã khóa theo PO)</span>
                                        </div>
                                        <input type="hidden" name="warehouseId" value="${receipt.warehouseId}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <select id="warehouseSelect" name="warehouseId" required onchange="onWarehouseChange()">
                                            <option value="">-- Chọn kho trước --</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.warehouseId}">${wh.name}</option>
                                            </c:forEach>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
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
                            <c:if test="${not empty purchaseOrder}">
                                <div class="form-field full">
                                    <label>Phiếu purchase nguồn</label>
                                    <div class="order-pin">
                                        <strong>${purchaseOrder.poCode}</strong>
                                    </div>
                                </div>
                            </c:if>
                            <div class="form-field full">
                                <label>Ghi chú phiếu</label>
                                <textarea name="note" placeholder="Nhập ghi chú nếu có..."></textarea>
                            </div>
                        </div>
                    </section>

                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — CHI TIẾT DÒNG HÀNG</div>
                                <h3 class="section-title">Danh sách máy phát điện</h3>
                            </div>
                            <div class="section-actions" style="display:flex; gap:8px;">
                                <a class="btn" href="${pageContext.request.contextPath}/import-receipt?action=template<c:if test="${not empty receipt.purchaseOrderId}">&poId=${receipt.purchaseOrderId}</c:if>" title="Tải file mẫu Excel">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                    Tải mẫu Excel
                                </a>
                                <button type="button" class="btn" id="btnImportExcel" onclick="document.getElementById('excelFileInput').click()" title="<c:choose><c:when test="${fromPurchaseOrder}">Nhập serial từ Excel (chỉ áp dụng cho các dòng từ PO)</c:when><c:otherwise>Nhập hàng loạt từ Excel (.xlsx)</c:otherwise></c:choose>">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l5-5-5 5M12 3v12"/></svg>
                                    Nhập từ Excel
                                </button>
                                <c:if test="${fromPurchaseOrder}">
                                    <span class="po-lock-badge" style="background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); padding: 6px 12px; border-radius: var(--radius-sm); font-size: 12px; font-weight: 600;">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: middle;"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                        Đã khóa từ PO ${purchaseOrder.poCode}
                                    </span>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${fromPurchaseOrder}">
                            <div class="alert alert-info" style="margin-bottom: 14px;">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                <div class="alert-body">
                                    <div class="alert-title">Phiếu nhập từ Purchase Order - danh sách máy đã được cố định</div>
                                    <div>
                                        Bạn <strong>chỉ cần nhập serial</strong> cho từng máy. Không thể thay đổi kho, máy, thêm hoặc xoá dòng.
                                        Tổng cần nhập: <strong>${expectedRows} serial</strong>.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <div id="warehouseWarn" class="alert alert-info" style="display:none;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Vui lòng chọn kho trước</div>
                                <div>Danh sách máy phát điện sẽ được lọc theo kho bạn đã chọn.</div>
                            </div>
                        </div>
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th class="col-gen">Máy phát</th>
                                    <th class="col-serial">Serial</th>
                                    <th class="col-note">Ghi chú</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${fromPurchaseOrder and not empty poRowList}">
                                        <c:forEach var="row" items="${poRowList}" varStatus="st">
                                            <tr class="po-locked-row">
                                                <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                                <td>
                                                    <input type="hidden" name="manualGeneratorId" value="${row.generatorId}"/>
                                                    <strong><c:out value="${row.generatorCode}"/></strong>
                                                    <c:if test="${not empty row.brandName}">
                                                        <span class="stock-info">${row.brandName}</span>
                                                    </c:if>
                                                    <c:if test="${empty row.generatorCode}">
                                                        <span class="stock-info">Mã máy #${row.generatorId}</span>
                                                    </c:if>
                                                    <span class="po-lock-tag" style="margin-left: 6px; font-size: 10px; padding: 2px 6px; background: var(--accent-soft); color: var(--accent); border-radius: 99px; font-weight: 600;">KHÓA</span>
                                                </td>
                                                <td><input type="text" name="manualSerialNumber" placeholder="Nhập S/N"
                                                       value="<c:out value='${not empty poSerialList ? poSerialList[st.index] : (not empty preservedManualRows and st.index lt fn:length(preservedManualRows) ? preservedManualRows[st.index].serialNumber : "")}'/>"
                                                       required onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>
                                                <td><input type="text" name="manualDetailNote" placeholder="Ghi chú"
                                                       value="<c:out value='${row.note}'/>" /></td>
                                                <td class="col-del">
                                                    <span class="po-no-delete" style="color: var(--muted); font-size: 11px;">PO</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
                                            <td>
                                                <select name="manualGeneratorId" required disabled onchange="onGeneratorChange(this)">
                                                    <option value="">-- Chọn kho trước --</option>
                                                </select>
                                                <span class="stock-info" data-stock-info></span>
                                                <span class="field-error" style="display:none;"></span>
                                            </td>
                                            <td><input type="text" name="manualSerialNumber" placeholder="S/N (bắt buộc)" required disabled onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>
                                            <td><input type="text" name="manualDetailNote" placeholder="Ghi chú" /></td>
                                            <td class="col-del">
                                                <button type="button" class="row-del-btn" disabled onclick="removeRow(this)" title="Xoá dòng">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <button type="button" class="btn add-row-btn" id="addRowBtn"<c:if test="${fromPurchaseOrder}"> style="display:none;"</c:if> disabled onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                        <c:if test="${fromPurchaseOrder}">
                            <div id="poCounter" style="margin-top: 12px; padding: 10px 14px; background: var(--surface-2); border-radius: var(--radius-sm); font-size: 13px; color: var(--muted);">
                                Đã nhập serial: <strong id="poFilledCount" style="color: var(--accent);">0</strong> / <strong>${expectedRows}</strong>
                            </div>
                        </c:if>
                    </section>
                </div>
            </form>

            <input type="file" name="excelFile" id="excelFileInput" accept=".xlsx"
                   onchange="submitExcelUpload(this)" style="display:none;"/>
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
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            if (typeof showToast === 'function') {
                showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
            }
        }
    });
</script>
<script>
    var ctx = window.APP_CTX;
    var generatorCache = [];
    var prefillDetails = [];
    var preservedManualRows = [];

    <c:if test="${not empty receipt.details}">
    prefillDetails = [
        <c:forEach var="d" items="${receipt.details}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{generatorId: ${d.generatorId}, note: '<c:out value="${d.note}"/>'}
        </c:forEach>
    ];
    </c:if>

    <c:if test="${not empty preservedManualRows}">
    preservedManualRows = [
        <c:forEach var="row" items="${preservedManualRows}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{generatorId: '<c:out value="${row.generatorId}"/>', serialNumber: '<c:out value="${row.serialNumber}"/>', note: '<c:out value="${row.detailNote}"/>'}
        </c:forEach>
    ];
    </c:if>

    function formatVND(num) {
        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
    }

    function renderGeneratorOptions(selectEl) {
        var cur = selectEl.getAttribute('data-current');
        var html = '<option value="">-- Chọn máy --</option>';
        for (var i = 0; i < generatorCache.length; i++) {
            var g = generatorCache[i];
            var label = g.model + (g.brand ? ' (' + g.brand + ')' : '') + ' — Tồn: ' + (g.stockQty || 0);
            var sel = (cur && String(g.id) === String(cur)) ? ' selected' : '';
            html += '<option value="' + g.id + '" data-stock="' + (g.stockQty || 0) + '"' + sel + '>' + label + '</option>';
        }
        selectEl.innerHTML = html;
    }

    function updateStockInfo(selectEl) {
        var row = selectEl.closest('tr');
        if (!row) return;
        var info = row.querySelector('[data-stock-info]');
        if (!info) return;
        var opt = selectEl.options[selectEl.selectedIndex];
        if (!opt || !opt.value) {
            info.innerHTML = '';
            return;
        }
        var stock = parseInt(opt.getAttribute('data-stock')) || 0;
        info.innerHTML = '<span class="stock-label">Tồn kho hiện tại:</span> <span class="stock-value">' + stock + '</span> máy';
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
        fetch(ctx + '/import-receipt?action=loadGenerators&warehouseId=' + encodeURIComponent(whId))
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
        document.querySelectorAll('#detailBody tr select[name="manualGeneratorId"]').forEach(function (sel) {
            renderGeneratorOptions(sel);
        });
    }

    function applyPrefill() {
        var tbody = document.getElementById('detailBody');
        if (!tbody) return;

        if (tbody.querySelector('tr.po-locked-row')) {
            return;
        }

        while (tbody.firstChild) tbody.removeChild(tbody.firstChild);

        var source = [];
        if (preservedManualRows && preservedManualRows.length > 0) {
            source = preservedManualRows;
        } else if (prefillDetails && prefillDetails.length > 0) {
            source = prefillDetails;
        }
        if (source.length === 0) {
            tbody.appendChild(buildEmptyRow());
        } else {
            source.forEach(function (p) {
                var tr = buildEmptyRow(p.generatorId);
                var noteInput = tr.querySelector('input[name="manualDetailNote"]');
                if (noteInput && p.note) noteInput.value = p.note;
                var serialInput = tr.querySelector('input[name="manualSerialNumber"]');
                if (serialInput && p.serialNumber) serialInput.value = p.serialNumber;
                tbody.appendChild(tr);
            });
        }
        updateRowNumbers();
    }

    function disableAllRows(disabled) {
        document.querySelectorAll('#detailBody tr').forEach(function (row) {
            row.querySelectorAll('select[name="manualGeneratorId"], input[name="manualSerialNumber"]').forEach(function (el) {
                el.disabled = disabled;
            });
            var btn = row.querySelector('.row-del-btn');
            if (btn) btn.disabled = disabled;
        });
        var addBtn = document.getElementById('addRowBtn');
        if (addBtn) addBtn.disabled = disabled;
    }

    function onGeneratorChange(sel) {
        updateStockInfo(sel);
    }

    function buildEmptyRow(presetGenId) {
        var tr = document.createElement('tr');
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td><select name="manualGeneratorId" required onchange="onGeneratorChange(this)"><option value="">-- Chọn máy --</option></select><span class="stock-info" data-stock-info></span><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="manualSerialNumber" placeholder="S/N (bắt buộc)" required onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="manualDetailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        var sel = tr.querySelector('select[name="manualGeneratorId"]');
        if (presetGenId) {
            sel.setAttribute('data-current', presetGenId);
        }
        renderGeneratorOptions(sel);
        return tr;
    }

    function addRow() {
        if (document.querySelector('tr.po-locked-row')) {
            toast('Đang nhập từ PO, không thể thêm dòng mới. Hãy nhập serial vào các dòng có sẵn.', 'danger');
            return;
        }
        var tbody = document.getElementById('detailBody');
        tbody.appendChild(buildEmptyRow());
        updateRowNumbers();
    }

    function removeRow(btn) {
        if (document.querySelector('tr.po-locked-row')) {
            toast('Đang nhập từ PO, không thể xoá dòng.', 'danger');
            return;
        }
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
        });
        updatePoCounter();
    }

    function updatePoCounter() {
        var counter = document.getElementById('poFilledCount');
        if (!counter) return;
        var filled = 0;
        document.querySelectorAll('tr.po-locked-row input[name="manualSerialNumber"]').forEach(function (inp) {
            if (inp.value && inp.value.trim().length > 0) filled++;
        });
        counter.textContent = filled;
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
        var valid = true;
        var firstInvalid = null;
        var isPoMode = !!document.querySelector('tr.po-locked-row');

        document.querySelectorAll('#receiptForm [required]').forEach(function (el) {
            if (isPoMode && el.tagName === 'SELECT' && el.name === 'manualGeneratorId') {
                return;
            }
            if (!validateField(el)) {
                valid = false;
                if (firstInvalid === null) firstInvalid = el;
            }
        });

        if (isPoMode) {
            var missingSerial = 0;
            document.querySelectorAll('tr.po-locked-row input[name="manualSerialNumber"]').forEach(function (inp) {
                if (!inp.value || !inp.value.trim()) missingSerial++;
            });
            if (missingSerial > 0) {
                toast('Còn ' + missingSerial + ' dòng chưa nhập serial. Hãy nhập đủ serial cho tất cả các máy trong PO.', 'danger');
                valid = false;
            }
        } else {
            if (document.querySelectorAll('#detailBody tr').length === 0) {
                toast('Vui lòng thêm ít nhất 1 dòng chi tiết', 'danger');
                valid = false;
            }
        }

        if (!valid) {
            toast('Vui lòng điền đầy đủ các trường bắt buộc', 'danger');
            if (firstInvalid) firstInvalid.focus();
        }
        return valid;
    }

    document.addEventListener('DOMContentLoaded', function () {
        <c:if test="${not fromPurchaseOrder}">
        <c:if test="${preservedWarehouseId != null and preservedWarehouseId > 0}">
        var whSelect = document.getElementById('warehouseSelect');
        if (whSelect) {
            whSelect.value = '${preservedWarehouseId}';
            onWarehouseChange();
        }
        </c:if>
        <c:if test="${empty preservedWarehouseId and not empty receipt and receipt.warehouseId > 0}">
        var whSelect = document.getElementById('warehouseSelect');
        if (whSelect) {
            whSelect.value = '${receipt.warehouseId}';
            onWarehouseChange();
        }
        </c:if>
        </c:if>

        <c:if test="${fromPurchaseOrder}">
        updatePoCounter();
        document.querySelectorAll('tr.po-locked-row input[name="manualSerialNumber"]').forEach(function (inp) {
            inp.addEventListener('input', updatePoCounter);
        });
        </c:if>

        <c:if test="${preservedReasonId != null}">
        var reasonSel = document.querySelector('select[name="reasonId"]');
        if (reasonSel) reasonSel.value = '${preservedReasonId}';
        </c:if>

        <c:if test="${preservedNote != null}">
        var noteEl = document.querySelector('textarea[name="note"]');
        if (noteEl) noteEl.value = '<c:out value="${preservedNote}"/>';
        </c:if>
    });

    function submitExcelUpload(input) {
        if (!input.files || !input.files[0]) {
            return;
        }
        var whSelect = document.querySelector('select[name="warehouseId"]');
        var whId = whSelect ? whSelect.value : '';
        if (!whId) {
            var whHidden = document.querySelector('input[name="warehouseId"][type="hidden"]');
            if (whHidden) whId = whHidden.value;
        }
        if (!whId) {
            toast('Vui lòng chọn kho trước khi nhập Excel', 'danger');
            input.value = '';
            return;
        }

        var isPoMode = !!document.querySelector('tr.po-locked-row');
        var reasonEl = document.querySelector('select[name="reasonId"]');
        var noteEl = document.querySelector('textarea[name="note"]');
        var existingPoId = document.querySelector('input[name="poId"]');

        var formData = new FormData();
        formData.append('excelFile', input.files[0]);
        formData.append('warehouseId', whId);
        formData.append('reasonId', reasonEl ? reasonEl.value : '');
        formData.append('note', noteEl ? noteEl.value : '');
        if (existingPoId) formData.append('poId', existingPoId.value || '');

        var btn = document.getElementById('btnImportExcel');
        if (btn) { btn.disabled = true; btn.classList.add('loading'); }

        fetch(ctx + '/import-receipt?action=importPreview&ajax=1', {
            method: 'POST',
            body: formData,
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(function (r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        })
        .then(function (data) {
            if (btn) { btn.disabled = false; btn.classList.remove('loading'); }
            input.value = '';
            if (!data || !data.success) {
                toast((data && data.message) ? data.message : 'Lỗi khi đọc file', 'danger');
                return;
            }
            if (isPoMode) {
                applySerialsToPoRows(data.serials || []);
                if (typeof updatePoCounter === 'function') updatePoCounter();
            } else {
                applySerialsToManualRows(data.generatorIds || [], data.serials || []);
            }
            toast(data.message || 'Đã đọc file Excel', 'success');
        })
        .catch(function (err) {
            if (btn) { btn.disabled = false; btn.classList.remove('loading'); }
            input.value = '';
            console.error(err);
            toast('Lỗi kết nối: ' + err.message, 'danger');
        });
    }

    function applySerialsToPoRows(serials) {
        var rows = document.querySelectorAll('tr.po-locked-row');
        if (rows.length === 0) return;
        for (var i = 0; i < rows.length; i++) {
            var input = rows[i].querySelector('input[name="manualSerialNumber"]');
            if (!input) continue;
            input.value = (i < serials.length && serials[i] != null) ? serials[i] : '';
        }
    }

    function applySerialsToManualRows(generatorIds, serials) {
        var tbody = document.getElementById('detailBody');
        if (!tbody) return;
        while (tbody.firstChild) tbody.removeChild(tbody.firstChild);
        for (var i = 0; i < serials.length; i++) {
            var genId = generatorIds[i];
            var serial = serials[i];
            if (!serial) continue;
            var tr = buildEmptyRow(genId);
            var snInput = tr.querySelector('input[name="manualSerialNumber"]');
            if (snInput) snInput.value = serial;
            tbody.appendChild(tr);
        }
        updateRowNumbers();
        if (typeof updateOrderCounter === 'function') updateOrderCounter();
    }
</script>
</body>
</html>