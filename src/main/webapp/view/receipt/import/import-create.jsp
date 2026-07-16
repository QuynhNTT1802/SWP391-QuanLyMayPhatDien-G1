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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
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
                        <button type="submit" id="submitBtn" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            Gửi phiếu
                        </button>
            </div>
        </header>

        <main>
            <a class="receipt-back-link" href="${pageContext.request.contextPath}/import-receipt">
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
                <c:if test="${not empty exportReceiptId}">
                    <input type="hidden" name="exportReceiptId" value="${exportReceiptId}" />
                </c:if>

                <c:if test="${not empty fromExportReceipt}">
                    <div class="alert" style="background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent); margin: 16px 0; padding: 12px 16px; border-radius: var(--radius);">
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 7v12H3V7M3 7l3-4h12l3 4M9 12h6"/></svg>
                        <div>
                            <div style="font-weight: 700; margin-bottom: 4px;">Tạo phiếu nhập từ phiếu xuất <c:out value="${exportReceiptCode}"/></div>
                            <div style="font-size: 12.5px;">Theo phiếu đề xuất luân chuyển <strong><c:out value="${transferCode}"/></strong>. Các serial đã được hệ thống tự động gắn sẵn — bạn chỉ cần kiểm tra và lưu.</div>
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
                                    <c:when test="${fromExportReceipt}">
                                        <div class="readonly-field" style="display:flex; align-items:center; gap:8px; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface-2); color: var(--fg); font-size: 13px;">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                            <c:set var="warehouseName" value=""/>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <c:if test="${wh.warehouseId == receipt.warehouseId}">
                                                    <c:set var="warehouseName" value="${wh.name}"/>
                                                </c:if>
                                            </c:forEach>
                                            <strong><c:out value="${warehouseName}"/></strong>
                                            <span style="color: var(--muted); font-size: 11px; margin-left: 4px;">(đã khóa theo phiếu xuất)</span>
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
                                <div class="section-num">02 — QUÉT SERIAL NHẬP KHO</div>
                                <h3 class="section-title">Quét barcode từng máy một cho đến khi đủ số lượng</h3>
                            </div>
                            <div class="section-actions">
                                <span id="scanCounter" style="background: var(--surface-2); padding: 6px 12px; border-radius: var(--radius-sm); font-size: 12px; font-weight: 600; color: var(--muted);">
                                    <c:choose>
                                        <c:when test="${fromPurchaseOrder}">
                                            Đã quét: <strong id="scanFilledCount" style="color: var(--accent);">0</strong> / <strong id="scanTotalCount">${expectedRows}</strong>
                                        </c:when>
                                        <c:otherwise>
                                            Đã quét: <strong id="scanFilledCount" style="color: var(--accent);">0</strong> serial
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="scanner-box" id="importScannerBox">
                            <label>Quét serial để nhập nhanh</label>
                            <div class="scanner-input-wrap">
                                <input type="text" id="importScanBox" autocomplete="off"
                                       placeholder="Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)..." />
                            </div>
                            <small id="importScanStatus">Sẵn sàng. Mỗi serial quét vào sẽ tự điền vào dòng trống tương ứng bên dưới.</small>
                        </div>
                    </section>

                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">03 — CHI TIẾT DÒNG HÀNG</div>
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
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="gen" items="${generators}">
                                                        <c:set var="genLabel" value="${gen.model}"/>
                                                        <c:if test="${not empty brandMap[gen.id]}">
                                                            <c:set var="genLabel" value="${genLabel} (${brandMap[gen.id]})"/>
                                                        </c:if>
                                                        <option value="${gen.id}">${genLabel}</option>
                                                    </c:forEach>
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
    var generatorCache = ${empty generatorsJson ? '[]' : generatorsJson};
    var prefillDetails = ${empty prefillDetailsJson ? '[]' : prefillDetailsJson};

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
            var stockLabel = (g.stockQty !== null && g.stockQty !== undefined) ? ' — Tồn: ' + g.stockQty : '';
            var label = g.model + (g.brand ? ' (' + g.brand + ')' : '') + stockLabel;
            var sel = (cur && String(g.id) === String(cur)) ? ' selected' : '';
            var stockVal = (g.stockQty !== null && g.stockQty !== undefined) ? g.stockQty : 0;
            html += '<option value="' + g.id + '" data-stock="' + stockVal + '"' + sel + '>' + label + '</option>';
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

    var TRANSFER_IMPORT_ROWS = ${empty transferRowListJson ? '[]' : transferRowListJson};
    var isTransferImportMode = ${not empty fromExportReceipt and fromExportReceipt};

    function prefillTransferImportRows() {
        if (!isTransferImportMode) return;
        var tbody = document.getElementById('detailBody');
        tbody.innerHTML = '';
        TRANSFER_IMPORT_ROWS.forEach(function (p) {
            var tr = buildEmptyRow(p.generatorId);
            tbody.appendChild(tr);
            var genSel = tr.querySelector('select[name="manualGeneratorId"]');
            if (genSel) {
                genSel.value = p.generatorId;
                var evt = new Event('change');
                genSel.dispatchEvent(evt);
            }
            var serialInput = tr.querySelector('input[name="manualSerialNumber"]');
            if (serialInput) {
                serialInput.value = p.serialNumber || '';
                serialInput.readOnly = true;
            }
            var noteInput = tr.querySelector('input[name="manualDetailNote"]');
            if (noteInput && p.note) {
                noteInput.value = p.note;
            }
            var delBtn = tr.querySelector('.row-del-btn');
            if (delBtn) delBtn.disabled = true;
        });
        updateRowNumbers();
        disableAllRows(true);
    }

    document.addEventListener('DOMContentLoaded', function () {
        if (isTransferImportMode) {
            prefillTransferImportRows();
        }
    });

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
        updatePoCounter();
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
        });
        updatePoCounter();
    }

    function updatePoCounter() {
        var counter = document.getElementById('poFilledCount');
        var poRows = document.querySelectorAll('tr.po-locked-row');
        var filled = 0;
        poRows.forEach(function (r) {
            var inp = r.querySelector('input[name="manualSerialNumber"]');
            if (inp && inp.value && inp.value.trim().length > 0) filled++;
        });
        if (counter) counter.textContent = filled;
        var scanFilled = document.getElementById('scanFilledCount');
        if (scanFilled) {
            var count = 0;
            document.querySelectorAll('input[name="manualSerialNumber"]').forEach(function (inp) {
                if (inp.value && inp.value.trim().length > 0) count++;
            });
            scanFilled.textContent = count;
        }
        var scanEl = document.getElementById('importScanBox');
        if (scanEl && poRows.length > 0 && filled >= poRows.length) {
            disableScanWhenPoFull();
        }
        updateSubmitAvailability();
    }

    function updateSubmitAvailability() {
        var submitBtn = document.getElementById('submitBtn');
        if (!submitBtn) return;
        var isPoMode = !!document.querySelector('tr.po-locked-row');
        if (!isPoMode) {
            submitBtn.disabled = false;
            submitBtn.removeAttribute('title');
            return;
        }
        var rows = document.querySelectorAll('tr.po-locked-row input[name="manualSerialNumber"]');
        var total = rows.length;
        var filled = 0;
        rows.forEach(function (inp) { if (inp.value && inp.value.trim()) filled++; });
        if (filled === total) {
            submitBtn.disabled = false;
            submitBtn.removeAttribute('title');
        } else {
            submitBtn.disabled = true;
            submitBtn.title = 'Đã nhập ' + filled + '/' + total + ' serial. Hãy quét tiếp đến khi đủ.';
        }
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
        <c:if test="${empty preservedWarehouseId and (empty receipt or receipt.warehouseId <= 0) and scopedWarehouseId > 0}">
        var whSelect = document.getElementById('warehouseSelect');
        if (whSelect) {
            whSelect.value = '${scopedWarehouseId}';
            onWarehouseChange();
        }
        </c:if>
        <c:if test="${empty preservedWarehouseId and (empty receipt or receipt.warehouseId <= 0) and (empty scopedWarehouseId or scopedWarehouseId <= 0)}">
        var whSelect = document.getElementById('warehouseSelect');
        if (whSelect && whSelect.options.length === 2) {
            whSelect.value = whSelect.options[1].value;
            onWarehouseChange();
        }
        </c:if>
        </c:if>

        <c:if test="${fromPurchaseOrder}">
        updatePoCounter();
        </c:if>

        // Pre-populate generator selects even before warehouse selection
        <c:if test="${not fromPurchaseOrder}">
        if (generatorCache.length > 0) {
            refreshAllGeneratorSelects();
        }
        </c:if>

        // Lắng nghe thay đổi trên MỌI ô serial (cả PO và non-PO) để cập nhật counter + submit
        document.querySelectorAll('input[name="manualSerialNumber"]').forEach(function (inp) {
            inp.addEventListener('input', function () {
                updatePoCounter();
                maybeReenableScanOnEdit();
            });
        });
        // Khi xoá dòng thì update lại
        document.getElementById('detailBody').addEventListener('DOMSubtreeModified', updatePoCounter);

        <c:if test="${preservedReasonId != null}">
        var reasonSel = document.querySelector('select[name="reasonId"]');
        if (reasonSel) reasonSel.value = '${preservedReasonId}';
        </c:if>

        <c:if test="${preservedNote != null}">
        var noteEl = document.querySelector('textarea[name="note"]');
        if (noteEl) noteEl.value = '<c:out value="${preservedNote}"/>';
        </c:if>

        initImportScanner();
        updateSubmitAvailability();
    });

    // ========== Scanner nhập kho ==========
    var importScannerLock = false;

    function initImportScanner() {
        var scanInput = document.getElementById('importScanBox');
        var scanBox = document.getElementById('importScannerBox');
        if (!scanInput) return;

        var whSelect = document.querySelector('select[name="warehouseId"], input[name="warehouseId"][type="hidden"]');
        var refreshScannerState = function () {
            var wh = whSelect ? whSelect.value : '';
            if (!wh) {
                scanBox.classList.add('disabled');
                scanInput.disabled = true;
                scanInput.placeholder = 'Vui lòng chọn kho trước khi quét...';
            } else {
                scanBox.classList.remove('disabled');
                scanInput.disabled = false;
                scanInput.placeholder = 'Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)...';
            }
        };
        refreshScannerState();
        if (whSelect && whSelect.tagName === 'SELECT') {
            whSelect.addEventListener('change', refreshScannerState);
        }

        scanInput.addEventListener('keydown', function (e) {
            if (e.key !== 'Enter') return;
            e.preventDefault();
            if (importScannerLock) return;
            var serial = scanInput.value.trim();
            if (!serial) return;
            handleImportScan(serial);
        });

        scanInput.addEventListener('input', function () {
            scanInput.classList.remove('success', 'error');
        });

        // Auto-focus scan box ngay từ đầu
        setTimeout(function () {
            if (!scanInput.disabled) scanInput.focus();
        }, 100);
    }

    function setImportScanStatus(msg, type) {
        var el = document.getElementById('importScanStatus');
        if (!el) return;
        el.textContent = msg;
        el.classList.remove('success', 'error');
        if (type) el.classList.add(type);
    }

    function flashImportScan(type) {
        var inp = document.getElementById('importScanBox');
        if (!inp) return;
        inp.classList.remove('success', 'error');
        inp.classList.add(type);
        setTimeout(function () { inp.classList.remove(type); }, 900);
    }

    function flashRowSuccess(row) {
        if (!row) return;
        row.classList.remove('flash');
        // restart animation
        void row.offsetWidth;
        row.classList.add('flash');
    }

    function handleImportScan(serial) {
        importScannerLock = true;
        serial = (serial || '').trim();
        if (!serial) {
            importScannerLock = false;
            return;
        }

        var whSelect = document.querySelector('select[name="warehouseId"], input[name="warehouseId"][type="hidden"]');
        var whId = whSelect ? whSelect.value : '';
        if (!whId) {
            importScannerLock = false;
            setImportScanStatus('Vui lòng chọn kho trước khi quét.', 'error');
            flashImportScan('error');
            return;
        }

        var isPoMode = !!document.querySelector('tr.po-locked-row');

        // 1. Check duplicate trong bảng
        var dupFound = null;
        document.querySelectorAll('input[name="manualSerialNumber"]').forEach(function (inp) {
            if (inp.value.trim() === serial) dupFound = inp;
        });
        if (dupFound) {
            importScannerLock = false;
            setImportScanStatus('Serial "' + serial + '" đã quét trong phiếu này.', 'error');
            flashImportScan('error');
            focusScanBox();
            return;
        }

        if (isPoMode) {
            // PO mode: chi can quet QR dien vao dong trong tiep theo,
            // khong can check serial co ton tai trong he thong hay khong.
            // Hang di theo PO da co san generator_id, nguoi dung chi can
            // quet den khi du so dong theo PO la xong.
            var poRows = document.querySelectorAll('tr.po-locked-row');
            var targetRow = findPoTargetRow();
            if (!targetRow) {
                importScannerLock = false;
                setImportScanStatus('Đã quét đủ ' + poRows.length + ' serial theo PO. Bấm "Gửi phiếu" để hoàn tất.', 'success');
                flashImportScan('success');
                disableScanWhenPoFull();
                var scanEl0 = document.getElementById('importScanBox');
                if (scanEl0) scanEl0.value = '';
                focusScanBox();
                return;
            }
            var snInput = targetRow.querySelector('input[name="manualSerialNumber"]');
            snInput.value = serial;
            flashRowSuccess(targetRow);
            flashImportScan('success');
            updatePoCounter();

            var filledNow = 0;
            poRows.forEach(function (r) {
                var inp = r.querySelector('input[name="manualSerialNumber"]');
                if (inp && inp.value.trim()) filledNow++;
            });
            setImportScanStatus('✓ Đã quét ' + filledNow + '/' + poRows.length + ' serial.', 'success');

            var scanEl = document.getElementById('importScanBox');
            if (scanEl) scanEl.value = '';
            if (filledNow >= poRows.length) {
                disableScanWhenPoFull();
            }
            importScannerLock = false;
            focusScanBox();
            return;
        }

        // 2. Non-PO mode: van giu nguyen flow AJAX lookup nhu cu
        var url = ctx + '/inventory-lookup?action=scan&serial=' + encodeURIComponent(serial)
                + '&warehouseId=' + encodeURIComponent(whId);
        fetch(url).then(function (r) { return r.json(); })
            .then(function (data) {
                importScannerLock = false;

                if (!data || !data.found) {
                    setImportScanStatus('Serial "' + serial + '" không tồn tại trong hệ thống.', 'error');
                    flashImportScan('error');
                    focusScanBox();
                    return;
                }
                if (data.blocked) {
                    setImportScanStatus('Serial "' + serial + '" đang bị chặn / đang sử dụng.', 'error');
                    flashImportScan('error');
                    focusScanBox();
                    return;
                }

                // Non-PO mode: tìm dòng trống hoặc tạo dòng mới
                var emptyRow = findEmptyManualRow();
                var targetTr;
                if (emptyRow) {
                    targetTr = emptyRow;
                } else {
                    targetTr = buildEmptyRow();
                    document.getElementById('detailBody').appendChild(targetTr);
                    updateRowNumbers();
                }
                var genSel = targetTr.querySelector('select[name="manualGeneratorId"]');
                var snInput2 = targetTr.querySelector('input[name="manualSerialNumber"]');
                if (genSel) {
                    // Đảm bảo generator từ serial quét có trong cache để dropdown hiển thị
                    var foundInCache = false;
                    for (var i = 0; i < generatorCache.length; i++) {
                        if (String(generatorCache[i].id) === String(data.generatorId)) { foundInCache = true; break; }
                    }
                    if (!foundInCache) {
                        generatorCache.push({
                            id: data.generatorId,
                            model: data.generatorModel || ('#' + data.generatorId),
                            brand: data.generatorBrand || '',
                            stockQty: 0
                        });
                    }
                    genSel.setAttribute('data-current', data.generatorId);
                    renderGeneratorOptions(genSel);
                    genSel.value = data.generatorId;
                    onGeneratorChange(genSel);
                }
                if (snInput2) {
                    snInput2.value = serial;
                }
                flashRowSuccess(targetTr);
                flashImportScan('success');
                setImportScanStatus('✓ Đã thêm serial "' + serial + '" (model "' + (data.generatorModel || '') + '").', 'success');
                updatePoCounter();

                var scanEl = document.getElementById('importScanBox');
                if (scanEl) scanEl.value = '';
                focusScanBox();
            })
            .catch(function (err) {
                importScannerLock = false;
                console.error(err);
                setImportScanStatus('Lỗi kết nối: ' + err.message, 'error');
                flashImportScan('error');
                focusScanBox();
            });
    }

    function focusScanBox() {
        var scanEl = document.getElementById('importScanBox');
        if (scanEl && !scanEl.disabled) {
            scanEl.focus();
        }
    }

    function findPoTargetRow() {
        var rows = document.querySelectorAll('tr.po-locked-row');
        for (var i = 0; i < rows.length; i++) {
            var snInput = rows[i].querySelector('input[name="manualSerialNumber"]');
            if (!snInput) continue;
            if (!snInput.value.trim()) {
                return rows[i];
            }
        }
        return null;
    }

    function disableScanWhenPoFull() {
        var scanEl = document.getElementById('importScanBox');
        if (!scanEl) return;
        var scanBox = document.getElementById('importScannerBox');
        scanEl.disabled = true;
        scanEl.placeholder = 'Đã đủ serial theo PO. Bấm "Gửi phiếu" để hoàn tất.';
        if (scanBox) scanBox.classList.add('disabled');
    }

    function maybeReenableScanOnEdit() {
        var scanEl = document.getElementById('importScanBox');
        if (!scanEl || !scanEl.disabled) return;
        if (!document.querySelector('tr.po-locked-row')) return;
        var poRows = document.querySelectorAll('tr.po-locked-row');
        var emptyExists = false;
        poRows.forEach(function (r) {
            var inp = r.querySelector('input[name="manualSerialNumber"]');
            if (inp && !inp.value.trim()) emptyExists = true;
        });
        if (emptyExists) {
            scanEl.disabled = false;
            scanEl.placeholder = 'Đặt con trỏ vào đây rồi quét barcode (hoặc gõ tay rồi Enter)...';
            var scanBox = document.getElementById('importScannerBox');
            if (scanBox) scanBox.classList.remove('disabled');
            setImportScanStatus('Đã mở lại ô quét. Bạn có thể tiếp tục quét serial.', 'success');
        }
    }

    function findEmptyManualRow() {
        var rows = document.querySelectorAll('#detailBody tr');
        for (var i = 0; i < rows.length; i++) {
            var snInput = rows[i].querySelector('input[name="manualSerialNumber"]');
            if (snInput && !snInput.value.trim()) {
                return rows[i];
            }
        }
        return null;
    }

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
        updatePoCounter();
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
        updatePoCounter();
    }
</script>
</body>
</html>