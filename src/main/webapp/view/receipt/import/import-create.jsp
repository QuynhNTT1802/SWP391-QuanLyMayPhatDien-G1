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
            <h1>Tạo phiếu nhập kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Tạo mới</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
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
                            <span>Tạo từ đơn mua <span class="id">${purchaseOrder.poCode}</span></span>
                        </c:if>
                    </div>
                </div>

            <form id="receiptForm" action="${pageContext.request.contextPath}/import-receipt?action=save" method="POST" onsubmit="return openSaveConfirm();">
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
                            <div style="font-size: 12.5px;">Theo phiếu đề xuất luân chuyển <strong><c:out value="${transferCode}"/></strong>. Các số serial đã được hệ thống tự động gắn sẵn — bạn chỉ cần kiểm tra và lưu.</div>
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
                                <div class="section-num">02 — DANH SÁCH MÁY PHÁT ĐIỆN</div>
                                <h3 class="section-title">Quét / Nhập số serial hàng loạt</h3>
                            </div>
                        </div>

                        <div class="tabs-container">
                            <button type="button" class="tab-button active" data-tab="scan">
                                <svg class="icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 7V5a2 2 0 0 1 2-2h2M3 17v2a2 2 0 0 0 2 2h2M21 7V5a2 2 0 0 0-2-2h-2M21 17v2a2 2 0 0 1-2 2h-2M7 8v8M11 8v8M15 8v8M19 8v8"/></svg>
                                Quét mã vạch
                            </button>
                            <button type="button" class="tab-button" data-tab="excel">
                                <svg class="icon" viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                Nhập từ Excel
                            </button>
                        </div>

                        
                        <c:if test="${fromPurchaseOrder}">
                            <c:set var="poBreakdown" value=""/>
                            <c:forEach var="entry" items="${poQtyMap}" varStatus="loop">
                                <c:set var="genLabel" value=""/>
                                <c:forEach var="gen" items="${generators}">
                                    <c:if test="${gen.id eq entry.key}">
                                        <c:set var="genLabel" value="${gen.model}"/>
                                        <c:if test="${not empty brandMap[gen.id]}">
                                            <c:set var="genLabel" value="${genLabel} (${brandMap[gen.id]})"/>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                                <c:set var="poBreakdown" value="${poBreakdown}${entry.value} ${genLabel}${!loop.last ? ', ' : ''}"/>
                            </c:forEach>
                            <div class="alert alert-info" style="margin: 14px 0;">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                <div class="alert-body">
                                    <div class="alert-title">Phiếu nhập từ Purchase Order</div>
                                    <div>
                                        Tổng cần nhập: <strong>${expectedRows} số serial</strong>, bao gồm: <strong>${poBreakdown}</strong>.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${not empty fromExportReceipt}">
                            <c:set var="trBreakdown" value=""/>
                            <c:forEach var="td" items="${transfer.details}" varStatus="loop">
                                <c:set var="tdLabel" value="${td.generatorModel}"/>
                                <c:if test="${not empty td.generatorBrand}">
                                    <c:set var="tdLabel" value="${tdLabel} (${td.generatorBrand})"/>
                                </c:if>
                                <c:set var="trBreakdown" value="${trBreakdown}${td.quantity} máy ${tdLabel}${!loop.last ? ', ' : ''}"/>
                            </c:forEach>
                            <div class="alert alert-info" style="margin: 14px 0;">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                <div class="alert-body">
                                    <div class="alert-title">Nhập từ phiếu luân chuyển</div>
                                    <div>
                                        Tổng cần nhập: <strong>${expectedRows} số serial</strong>, bao gồm: <strong>${trBreakdown}</strong>.
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <div class="tab-pane active" data-tab="scan">
                            <c:if test="${empty fromExportReceipt}">
                            <div class="scanner-model-picker">
                                <label>Mẫu máy phát điện *</label>
                                <select id="activeGeneratorId" name="selectedGeneratorId" required onchange="onActiveGeneratorChange()">
                                    <option value="">-- Chọn mẫu máy trước khi quét --</option>
                                    <c:choose>
                                        <c:when test="${not empty availableGenerators}">
                                            <c:forEach var="gen" items="${availableGenerators}">
                                                <c:set var="genLabel" value="${gen.model}"/>
                                                <c:if test="${not empty brandMap[gen.id]}">
                                                    <c:set var="genLabel" value="${genLabel} (${brandMap[gen.id]})"/>
                                                </c:if>
                                                <option value="${gen.id}" data-model="<c:out value='${gen.model}'/>" data-brand="<c:out value='${brandMap[gen.id]}'/>">${genLabel}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="gen" items="${generators}">
                                                <c:set var="genLabel" value="${gen.model}"/>
                                                <c:if test="${not empty brandMap[gen.id]}">
                                                    <c:set var="genLabel" value="${genLabel} (${brandMap[gen.id]})"/>
                                                </c:if>
                                                <option value="${gen.id}" data-model="<c:out value='${gen.model}'/>" data-brand="<c:out value='${brandMap[gen.id]}'/>">${genLabel}</option>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                                <small class="hint">
                                    <c:choose>
                                        <c:when test="${not empty availableGenerators}">Chỉ hiển thị các mẫu máy có trong phiếu mua</c:when>
                                        <c:otherwise>Mỗi số serial quét vào sẽ tự gắn vào mẫu máy đã chọn.</c:otherwise>
                                    </c:choose>
                                </small>
                            </div>
                            </c:if>
                        </div>

                        <div class="tab-pane" data-tab="excel">
                            <div class="excel-action-row">
                                <a class="btn" href="${pageContext.request.contextPath}/import-receipt?action=template<c:if test="${not empty receipt.purchaseOrderId}">&poId=${receipt.purchaseOrderId}</c:if><c:if test="${not empty exportReceiptId}">&exportReceiptId=${exportReceiptId}</c:if>" title="Tải file mẫu Excel">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                    Tải mẫu Excel
                                </a>
                                <button type="button" class="btn" id="btnImportExcel" onclick="document.getElementById('excelFileInput').click()" title="<c:choose><c:when test="${fromPurchaseOrder}">Nhập số serial từ Excel (chỉ áp dụng cho các dòng từ PO)</c:when><c:when test="${not empty fromExportReceipt}">Nhập số serial từ Excel (áp dụng cho phiếu luân chuyển)</c:when><c:otherwise>Nhập hàng loạt từ Excel (.xlsx)</c:otherwise></c:choose>">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l5-5-5 5M12 3v12"/></svg>
                                    Nhập từ Excel
                                </button>
                            </div>
                        </div>


                        <div id="warehouseWarn" class="alert alert-info" style="display:none;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <div class="alert-body">
                                <div class="alert-title">Vui lòng chọn kho trước</div>
                                <div>Danh sách máy phát điện sẽ được lọc theo kho bạn đã chọn.</div>
                            </div>
                        </div>

                        <div id="detailGroups" class="detail-groups">
                            <div id="emptyState" class="empty-state" style="display:none;">
                                <svg viewBox="0 0 24 24" width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/></svg>
                                <p class="empty-state-title">Chưa có số serial nào</p>
                                <p class="empty-state-hint">Hãy quét mã vạch hoặc nhập từ Excel để bắt đầu</p>
                            </div>
                        </div>

                        <div id="poCounter" style="margin-top: 12px; padding: 10px 14px; background: var(--surface-2); border-radius: var(--radius-sm); font-size: 13px; color: var(--muted);">
                            Đã nhập số serial: <strong id="poFilledCount" style="color: var(--accent);">0</strong> <c:if test="${not empty expectedRows}"> / <strong>${expectedRows}</strong></c:if>
                        </div>
                    </section>
                </div>
            </form>

            <div class="bottom-actions">
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt">Huỷ</a>
                <button type="submit" id="submitBtn" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    Lưu phiếu
                </button>
            </div>

            <input type="file" name="excelFile" id="excelFileInput" accept=".xlsx"
                   onchange="submitExcelUpload(this)" style="display:none;"/>
        </main>
    </div>
</div>

<div class="modal-host" id="saveConfirmModal" onclick="if (event.target === this) closeSaveConfirm();">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="saveConfirmTitle">
        <h3 id="saveConfirmTitle">Xác nhận lưu phiếu nhập</h3>
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
            var totalSource = document.getElementById('poFilledCount') || document.getElementById('totalRowCount');
            totalEl.textContent = totalSource ? totalSource.textContent.trim() : '0';
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeSaveConfirm();
    });

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
    var expectedRowsJs = <c:out value="${empty expectedRows ? 0 : expectedRows}"/>;
    <c:if test="${not empty availableGenerators}">
    window.PO_AVAILABLE_GENERATORS = [
        <c:forEach var="gen" items="${availableGenerators}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>{id:${gen.id}, model:'<c:out value="${gen.model}"/>', brand:'<c:out value="${brandMap[gen.id]}"/>'}
        </c:forEach>
    ];
    window.PO_QTY_MAP = {
        <c:forEach var="entry" items="${poQtyMap}" varStatus="st">
        <c:if test="${st.index > 0}">,</c:if>'${entry.key}': ${entry.value}
        </c:forEach>
    };
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
                applyActiveGeneratorToAllRows();
            })
            .catch(function (err) {
                console.error(err);
                disableAllRows(false);
                refreshAllGeneratorSelects();
                applyPrefill();
                applyActiveGeneratorToAllRows();
            });
    }

    function refreshAllGeneratorSelects() {
        applyActiveGeneratorToAllRows();
    }

    function applyPrefill() {
        var groups = document.getElementById('detailGroups');
        if (!groups) return;
        var existingGroups = groups.querySelectorAll('details.detail-group').length;
        if (existingGroups > 0) return;

        var source = [];
        if (preservedManualRows && preservedManualRows.length > 0) {
            source = preservedManualRows;
        } else if (prefillDetails && prefillDetails.length > 0) {
            source = prefillDetails;
        }
        source.forEach(function (p) {
            if (!p || !p.generatorId) return;
            var group = getOrCreateGroup(p.generatorId);
            if (!group) return;
            addRowToGroup(group, p.serialNumber || '', p.note || '', p.inventoryId || null);
        });
        updateEmptyState();
        updatePoCounter();
        applyActiveGeneratorToAllRows();
    }

    function disableAllRows(disabled) {
        document.querySelectorAll('#detailGroups tr').forEach(function (row) {
            row.querySelectorAll('input[name="manualSerialNumber"], input[name="manualDetailNote"]').forEach(function (el) {
                el.disabled = disabled;
            });
            var btn = row.querySelector('.row-del-btn');
            if (btn) btn.disabled = disabled;
        });
        var addBtn = document.getElementById('addRowBtn');
        if (addBtn) addBtn.disabled = disabled;
    }

    var isTransferImportMode = ${not empty fromExportReceipt and fromExportReceipt};

    document.addEventListener('DOMContentLoaded', function () {
        initImportTabs();
        updatePoCounter();
        updateEmptyState();
        if (isTransferImportMode) {
            // Prefill serials from export receipt using standard applyPrefill
            if (typeof applyPrefill === 'function') applyPrefill();
        }
    });

    function initImportTabs() {
        document.querySelectorAll('.tab-button').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var tabName = btn.getAttribute('data-tab');
                switchImportTab(tabName);
            });
        });
        var activeBtn = document.querySelector('.tab-button.active');
        var initialTab = activeBtn ? activeBtn.getAttribute('data-tab') : 'scan';
        switchImportTab(initialTab);
    }

    function switchImportTab(tabName) {
        document.querySelectorAll('.tab-button').forEach(function (btn) {
            if (btn.getAttribute('data-tab') === tabName) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
        document.querySelectorAll('.tab-pane').forEach(function (pane) {
            if (pane.getAttribute('data-tab') === tabName) {
                pane.classList.add('active');
            } else {
                pane.classList.remove('active');
            }
        });
        if (tabName === 'scan') {
            // global scanner không cần focus input
        }
    }

    window.switchImportTab = switchImportTab;

    function getActiveGeneratorInfo() {
        var sel = document.getElementById('activeGeneratorId');
        if (!sel || !sel.value) return null;
        var opt = sel.options[sel.selectedIndex];
        return {
            id: sel.value,
            model: opt ? (opt.getAttribute('data-model') || opt.text || '') : '',
            brand: opt ? (opt.getAttribute('data-brand') || '') : ''
        };
    }

    function applyActiveGeneratorToRow(tr) {
        var info = getActiveGeneratorInfo();
        if (!info || !tr) return false;
        var sel = tr.querySelector('input[name="manualGeneratorId"][type="hidden"]');
        if (sel) {
            sel.value = info.id;
            return true;
        }
        return false;
    }

    function applyActiveGeneratorToAllRows() {
        // In grouped structure, each row's generator is determined by its group.
        // Active model is used for new groups created via scan.
        // This function is now mostly a no-op; kept for backward compat.
    }

    function onActiveGeneratorChange() {
        applyActiveGeneratorToAllRows();
    }

    function buildEmptyRow() {
        var tr = document.createElement('tr');
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td class="col-serial"><input type="text" name="manualSerialNumber" placeholder="Quét hoặc nhập số serial" onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>'
                + '<td class="col-note"><input type="text" name="manualDetailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        return tr;
    }

    function findGenInfo(genId) {
        var list = (window.PO_AVAILABLE_GENERATORS && window.PO_AVAILABLE_GENERATORS.length > 0)
                ? window.PO_AVAILABLE_GENERATORS : generatorCache;
        for (var i = 0; i < list.length; i++) {
            if (String(list[i].id) === String(genId)) return list[i];
        }
        return null;
    }

    function getOrCreateGroup(genId) {
        var groups = document.getElementById('detailGroups');
        if (!groups) return null;
        var existing = groups.querySelector('details[data-gen-id="' + genId + '"]');
        if (existing) return existing;
        var info = findGenInfo(genId);
        var modelText = info ? info.model : ('Mẫu #' + genId);
        var brandText = (info && info.brand) ? (' (' + info.brand + ')') : '';
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

    function addRowToGroup(group, serial, note, existingInventoryId) {
        if (!group) return null;
        var tbody = group.querySelector('tbody');
        if (!tbody) return null;
        var tr = buildEmptyRow();
        if (serial != null) {
            var snInput = tr.querySelector('input[name="manualSerialNumber"]');
            if (snInput) snInput.value = serial;
        }
        if (note != null) {
            var noteInput = tr.querySelector('input[name="manualDetailNote"]');
            if (noteInput) noteInput.value = note;
        }
        var genId = group.getAttribute('data-gen-id');
        var hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = 'manualGeneratorId';
        hidden.value = genId;
        tr.appendChild(hidden);
        if (existingInventoryId != null && existingInventoryId !== '') {
            var existHidden = document.createElement('input');
            existHidden.type = 'hidden';
            existHidden.name = 'existingInventoryId';
            existHidden.value = existingInventoryId;
            tr.appendChild(existHidden);
            tr.setAttribute('data-existing', '1');
        }
        tbody.appendChild(tr);
        updateGroupCount(group);
        updateRowNumbers();
        return tr;
    }

    function updateRowNumbers() {
        document.querySelectorAll('#detailGroups details.detail-group tbody').forEach(function (tbody) {
            tbody.querySelectorAll('tr').forEach(function (tr, i) {
                var numEl = tr.querySelector('.row-num');
                if (numEl) numEl.textContent = i + 1;
            });
        });
        updatePoCounter();
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
        updatePoCounter();
    }

    function removeGroup(btn) {
        var group = btn.closest('details.detail-group');
        if (!group) return;
        if (!confirm('Xoá cả nhóm máy này?')) return;
        group.remove();
        updateEmptyState();
        updateRowNumbers();
        updatePoCounter();
    }

    function addRow() {
        var info = getActiveGeneratorInfo();
        if (!info) {
            toast('Vui lòng chọn mẫu máy phát điện trước khi quét.', 'danger');
            return;
        }
        var group = getOrCreateGroup(info.id);
        if (!group) return;
        addRowToGroup(group, '', '');
        group.setAttribute('open', '');
        var tbody = group.querySelector('tbody');
        var lastRow = tbody.lastElementChild;
        if (lastRow) {
            var snInput = lastRow.querySelector('input[name="manualSerialNumber"]');
            if (snInput) snInput.focus();
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

    function updatePoCounter() {
        var counter = document.getElementById('poFilledCount');
        var allRows = document.querySelectorAll('#detailGroups tr');
        var filled = 0;
        allRows.forEach(function (r) {
            var inp = r.querySelector('input[name="manualSerialNumber"]');
            if (inp && inp.value && inp.value.trim().length > 0) filled++;
        });
        if (counter) counter.textContent = filled;
        var scanFilled = document.getElementById('scanFilledCount');
        if (scanFilled) scanFilled.textContent = filled;
        updateSubmitAvailability();
    }

    function updateSubmitAvailability() {
        var submitBtn = document.getElementById('submitBtn');
        if (!submitBtn) return;
        submitBtn.disabled = false;
        submitBtn.removeAttribute('title');
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
        var detailRows = document.querySelectorAll('#detailGroups tr');
        var hasAnySerial = false;
        var rowsWithGenButNoSerial = 0;
        var rowsWithSerialButNoGen = 0;

        detailRows.forEach(function (r) {
            var hiddenGen = r.querySelector('input[name="manualGeneratorId"][type="hidden"]');
            var sn = r.querySelector('input[name="manualSerialNumber"]');
            var genVal = hiddenGen ? hiddenGen.value.trim() : '';
            var snVal = sn ? sn.value.trim() : '';
            if (snVal) hasAnySerial = true;
            if (genVal && !snVal) rowsWithGenButNoSerial++;
            if (snVal && !genVal) rowsWithSerialButNoGen++;
        });

        if (!hasAnySerial) {
            toast('Vui lòng nhập ít nhất 1 số serial trước khi gửi phiếu.', 'danger');
            valid = false;
        }
        if (rowsWithSerialButNoGen > 0) {
            toast('Có ' + rowsWithSerialButNoGen + ' dòng có số serial nhưng chưa gắn với mẫu máy.', 'danger');
            valid = false;
        }
        if (rowsWithGenButNoSerial > 0) {
            toast('Có ' + rowsWithGenButNoSerial + ' dòng đã gắn với nhóm máy nhưng chưa nhập số serial.', 'danger');
            valid = false;
        }
        if (isTransferImportMode && expectedRowsJs && expectedRowsJs > 0) {
            var filledTransferCount = 0;
            detailRows.forEach(function (r) {
                var sn = r.querySelector('input[name="manualSerialNumber"]');
                if (sn && sn.value && sn.value.trim() !== '') {
                    filledTransferCount++;
                }
            });
            if (filledTransferCount < expectedRowsJs) {
                toast('Phiếu nhập theo luân chuyển phải chứa đủ ' + expectedRowsJs
                    + ' serial từ phiếu xuất. Hiện tại mới nhập ' + filledTransferCount
                    + ' serial.', 'danger');
                detailRows.forEach(function (r) {
                    var sn = r.querySelector('input[name="manualSerialNumber"]');
                    if (sn && (!sn.value || sn.value.trim() === '')) {
                        sn.classList.add('is-invalid');
                        r.classList.add('table-warning');
                    }
                });
                valid = false;
            }
        }

        if (!valid && firstInvalid) firstInvalid.focus();
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
            applyActiveGeneratorToAllRows();
        }
        </c:if>

        <c:if test="${not empty preservedSelectedGeneratorId}">
        var picker = document.getElementById('activeGeneratorId');
        if (picker) {
            picker.value = '${preservedSelectedGeneratorId}';
            applyActiveGeneratorToAllRows();
        }
        </c:if>

        // Lắng nghe thay đổi trên MỌI ô serial (cả PO và non-PO) để cập nhật counter + submit
        document.querySelectorAll('input[name="manualSerialNumber"]').forEach(function (inp) {
            inp.addEventListener('input', function () {
                updatePoCounter();
            });
        });
        // Khi xoá dòng thì update lại
        document.getElementById('detailGroups').addEventListener('DOMSubtreeModified', updatePoCounter);

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
    var importScanBuf = '';
    var importScanLastKey = 0;
    var IMPORT_SCAN_THRESHOLD = 50;
    var IMPORT_SCAN_MIN_LEN = 2;

    function initImportScanner() {
        document.addEventListener('keydown', function (e) {
            var now = Date.now();
            var gap = now - importScanLastKey;
            importScanLastKey = now;

            if (e.ctrlKey || e.altKey || e.metaKey) {
                importScanBuf = '';
                return;
            }

            if (e.key === 'Enter' || e.key === 'Tab') {
                if (importScanBuf.length >= IMPORT_SCAN_MIN_LEN) {
                    var serial = importScanBuf.trim();
                    importScanBuf = '';
                    if (serial && !importScannerLock) {
                        e.preventDefault();
                        handleImportScan(serial);
                    }
                    return;
                }
                importScanBuf = '';
                return;
            }

            if (gap > IMPORT_SCAN_THRESHOLD) importScanBuf = '';

            if (e.key && e.key.length === 1 && !e.isComposing) {
                importScanBuf += e.key;
            } else if (e.key === 'Backspace' && importScanBuf.length > 0) {
                importScanBuf = importScanBuf.slice(0, -1);
            }
        });

        document.addEventListener('visibilitychange', function () {
            if (document.hidden) importScanBuf = '';
        });
    }

    function clearScanBuf() {
        importScanBuf = '';
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
            toast('Vui lòng chọn kho trước khi quét.', 'danger');
            clearScanBuf();
            return;
        }

        if (!isTransferImportMode && expectedRowsJs && expectedRowsJs > 0) {
            var currentFilled = parseInt((document.getElementById('poFilledCount') || {}).textContent || '0', 10) || 0;
            if (currentFilled >= expectedRowsJs) {
                importScannerLock = false;
                var fullMsg = 'Đã quét đủ ' + expectedRowsJs + ' số serial theo phiếu. Không thể quét thêm.';
                toast(fullMsg, 'danger');
                clearScanBuf();
                return;
            }
        }

        var activeInfo = getActiveGeneratorInfo();
        var isTransferMode = !!document.querySelector('tr.transfer-suggest-row');

        if (!isTransferImportMode && !isTransferMode && !activeInfo) {
            importScannerLock = false;
            toast('Vui lòng chọn mẫu máy phát điện trước khi quét.', 'danger');
            var picker = document.getElementById('activeGeneratorId');
            if (picker) picker.focus();
            clearScanBuf();
            return;
        }

        var dupFound = null;
        document.querySelectorAll('input[name="manualSerialNumber"]').forEach(function (inp) {
            if (inp.value.trim() === serial) dupFound = inp;
        });
        if (dupFound) {
            importScannerLock = false;
            var dupMsg = 'Số serial "' + serial + '" đã tồn tại trong phiếu này.';
            toast(dupMsg, 'danger');
            clearScanBuf();
            return;
        }

        var url = ctx + '/inventory-lookup?action=scan&serial=' + encodeURIComponent(serial)
                + '&warehouseId=' + encodeURIComponent(whId)
                + '&expectedGeneratorId=' + encodeURIComponent(activeInfo ? activeInfo.id : '');
        fetch(url).then(function (r) { return r.json(); })
            .then(function (data) {
                importScannerLock = false;

                var existingInvId = null;
                if (data && data.found) {
                    if (data.status === 'SOLD' || (isTransferImportMode && data.status === 'IN_TRANSIT')) {
                        existingInvId = data.inventoryId;
                    } else {
                        var statusName = data.status === 'IN_STOCK' ? 'tồn kho'
                            : data.status === 'IN_TRANSIT' ? 'đang luân chuyển'
                            : data.status === 'SOLD' ? 'đã bán'
                            : data.status || 'không xác định';
                        var sysMsg = 'Số serial "' + serial + '" đang ở trạng thái ' + statusName + ', không thể nhập.';
                        toast(sysMsg, 'danger');
                        clearScanBuf();
                        return;
                    }
                } else if (isTransferImportMode) {
                    var nfMsg = 'Số serial "' + serial + '" không tồn tại trong hệ thống, không thể nhập từ phiếu luân chuyển.';
                    toast(nfMsg, 'danger');
                    clearScanBuf();
                    return;
                }

                if (!isTransferImportMode && window.PO_QTY_MAP && activeInfo && window.PO_QTY_MAP[String(activeInfo.id)]) {
                    var allowed = window.PO_QTY_MAP[String(activeInfo.id)];
                    var filled = countFilledForGen(activeInfo.id);
                    if (filled >= allowed) {
                        importScannerLock = false;
                        var perGenMsg = 'Đã quét đủ ' + allowed + ' số serial cho mẫu ' + (activeInfo.model || '') + '.';
                        toast(perGenMsg, 'danger');
                        clearScanBuf();
                        return;
                    }
                }
                var genIdForGroup;
                if (isTransferImportMode && data && data.found) {
                    genIdForGroup = data.generatorId;
                } else {
                    genIdForGroup = activeInfo.id;
                }
                var group = getOrCreateGroup(genIdForGroup);
                if (!group) {
                    importScannerLock = false;
                    return;
                }
                var targetTr = addRowToGroup(group, serial, '', existingInvId);
                group.setAttribute('open', '');
                flashRowSuccess(targetTr);
                var modelLabel;
                if (isTransferImportMode && data && data.found) {
                    modelLabel = data.generatorModel || '';
                } else {
                    modelLabel = activeInfo ? (activeInfo.model || '') : '';
                }
                var okMsg = existingInvId
                        ? 'Đã nhập lại số serial "' + serial + '" (đã xuất trước đó) vào kho'
                        : 'Đã thêm số serial "' + serial + '" vào mẫu ' + modelLabel;
                toast(okMsg, 'success');
                updatePoCounter();

                clearScanBuf();
            })
            .catch(function (err) {
                importScannerLock = false;
                console.error(err);
                toast('Lỗi kết nối: ' + err.message, 'danger');
                clearScanBuf();
            });
    }


    function findPoTargetRow() {
        var rows = document.querySelectorAll('#detailGroups tr');
        for (var i = 0; i < rows.length; i++) {
            var snInput = rows[i].querySelector('input[name="manualSerialNumber"]');
            if (!snInput) continue;
            if (!snInput.value.trim()) {
                return rows[i];
            }
        }
        return null;
    }

    function findEmptyManualRow() {
        var rows = document.querySelectorAll('#detailGroups tr');
        for (var i = 0; i < rows.length; i++) {
            var snInput = rows[i].querySelector('input[name="manualSerialNumber"]');
            if (snInput && !snInput.value.trim()) {
                return rows[i];
            }
        }
        return null;
    }

    function countFilledForGen(genId) {
        var count = 0;
        document.querySelectorAll('#detailGroups tr').forEach(function (tr) {
            var sel = tr.querySelector('input[name="manualGeneratorId"][type="hidden"]');
            var snInput = tr.querySelector('input[name="manualSerialNumber"]');
            if (!sel || !snInput) return;
            if (sel.value === String(genId) && snInput.value.trim()) count++;
        });
        return count;
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

        var reasonEl = document.querySelector('select[name="reasonId"]');
        var noteEl = document.querySelector('textarea[name="note"]');
        var existingPoId = document.querySelector('input[name="poId"]');
        var exportReceiptEl = document.querySelector('input[name="exportReceiptId"]');

        var formData = new FormData();
        formData.append('excelFile', input.files[0]);
        formData.append('warehouseId', whId);
        formData.append('reasonId', reasonEl ? reasonEl.value : '');
        formData.append('note', noteEl ? noteEl.value : '');
        if (existingPoId) formData.append('poId', existingPoId.value || '');
        if (exportReceiptEl) formData.append('exportReceiptId', exportReceiptEl.value || '');

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
                if (isTransferImportMode) {
                    applySerialsToExistingGroups(data.generatorIds || [], data.serials || []);
                } else {
                    applySerialsToTableRows(data.generatorIds || [], data.serials || [], data.models || []);
                }
                toast(data.message || 'Đã đọc file Excel', 'success');
                if (typeof switchImportTab === 'function') switchImportTab('scan');
            })
        .catch(function (err) {
            if (btn) { btn.disabled = false; btn.classList.remove('loading'); }
            input.value = '';
            console.error(err);
            toast('Lỗi kết nối: ' + err.message, 'danger');
        });
    }

    function clearAllGroups() {
        var groups = document.getElementById('detailGroups');
        if (!groups) return;
        groups.querySelectorAll('details.detail-group').forEach(function (g) { g.remove(); });
        groups.querySelectorAll('tr.transfer-suggest-row').forEach(function (r) {
            var sn = r.querySelector('input[name="manualSerialNumber"]');
            if (sn) sn.value = '';
        });
        updateEmptyState();
        updateRowNumbers();
        updatePoCounter();
    }

    function applySerialsToExistingGroups(generatorIds, serials) {
        var added = 0;
        var skipped = 0;
        for (var i = 0; i < serials.length; i++) {
            var serial = (serials[i] || '').trim();
            if (!serial) continue;
            var genId = (generatorIds && generatorIds[i]) ? generatorIds[i] : '';
            if (!genId) { skipped++; continue; }
            var group = getOrCreateGroup(genId);
            var tbody = group.querySelector('tbody');
            var existingInput = null;
            if (tbody) {
                var rows = tbody.querySelectorAll('tr');
                for (var r = 0; r < rows.length; r++) {
                    var inp = rows[r].querySelector('input[name="manualSerialNumber"]');
                    if (inp && !inp.value.trim()) { existingInput = inp; break; }
                }
            }
            if (existingInput) {
                existingInput.value = serial;
            } else {
                addRowToGroup(group, serial, '');
            }
            added++;
        }
        document.querySelectorAll('#detailGroups details.detail-group').forEach(function (g) {
            g.setAttribute('open', '');
        });
        updatePoCounter();
        updateRowNumbers();
        if (added > 0) {
            toast('Đã nhập ' + added + ' số serial từ Excel.', 'success');
        }
        if (skipped > 0) {
            toast('Bỏ qua ' + skipped + ' dòng Excel không xác định được mẫu máy.', 'warning');
        }
    }

    function applySerialsToTableRows(generatorIds, serials, models) {
        clearAllGroups();
        var skipped = 0;
        var added = 0;
        for (var i = 0; i < serials.length; i++) {
            var serial = (serials[i] || '').trim();
            if (!serial) continue;
            var genId = (generatorIds && generatorIds[i]) ? generatorIds[i] : '';
            if (!genId && models && models[i]) {
                var resolved = findGenInfoByModelName(models[i]);
                if (resolved) genId = resolved.id;
            }
            if (!genId) {
                skipped++;
                continue;
            }
            var group = getOrCreateGroup(genId);
            addRowToGroup(group, serial, '');
            added++;
        }
        document.querySelectorAll('#detailGroups details.detail-group').forEach(function (g) {
            g.setAttribute('open', '');
        });
        updatePoCounter();
        updateRowNumbers();
        if (added > 0) {
            toast('Đã nhập ' + added + ' số serial từ Excel.', 'success');
        }
        if (skipped > 0) {
            toast('Bỏ qua ' + skipped + ' dòng Excel không xác định được mẫu máy.', 'warning');
        }
    }

    function findGenInfoByModelName(modelName) {
        if (!modelName) return null;
        var target = String(modelName).trim().toLowerCase();
        var list = (window.PO_AVAILABLE_GENERATORS && window.PO_AVAILABLE_GENERATORS.length > 0)
                ? window.PO_AVAILABLE_GENERATORS : generatorCache;
        for (var i = 0; i < list.length; i++) {
            if (String(list[i].model || '').trim().toLowerCase() === target) {
                return list[i];
            }
        }
        return null;
    }

    function applySerialsToTransferRows(serials) {
        var groups = document.getElementById('detailGroups');
        var transferGroups = [];
        document.querySelectorAll('#detailGroups details.detail-group').forEach(function (g) {
            var expected = (g.getAttribute('data-expected-serial') || '').trim();
            if (expected) transferGroups.push({group: g, expected: expected});
        });
        for (var i = 0; i < transferGroups.length; i++) {
            var input = transferGroups[i].group.querySelector('tbody tr input[name="manualSerialNumber"]');
            if (input && i < serials.length) {
                input.value = (serials[i] != null) ? serials[i] : '';
            }
        }
        if (serials.length !== transferGroups.length) {
            toast('File Excel có ' + serials.length + ' dòng số serial nhưng phiếu yêu cầu ' + transferGroups.length + ' dòng. Đã điền theo vị trí.', 'warning');
        }
        updatePoCounter();
    }
</script>
</body>
</html>