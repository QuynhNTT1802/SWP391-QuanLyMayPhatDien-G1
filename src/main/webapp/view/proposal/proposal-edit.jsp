<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa đề xuất nhập kho — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-picker.css">
    <style>
        .detail-table { width:100%; border-collapse:collapse; margin-top:8px; }
        .detail-table th { text-align:left; padding:8px 10px; font-size:12px; font-weight:600; color:var(--muted); border-bottom:1px solid var(--border); text-transform:uppercase; letter-spacing:.5px; }
        .detail-table td { padding:8px 6px; vertical-align:top; }
        .detail-table select, .detail-table input { width:100%; padding:7px 8px; border:1px solid var(--border); border-radius:var(--radius-sm); background:var(--bg); color:var(--fg); font-size:13px; box-sizing:border-box; }
        .col-num { width:36px; text-align:center; color:var(--muted); font-weight:600; padding-top:14px; }
        .col-qty { width:100px; }
        .col-stock { width:90px; text-align:center; font-size:12px; color:var(--muted); padding-top:14px; }
        .col-price { width:160px; }
        .col-note { min-width:140px; }
        .col-del { width:40px; text-align:center; }
        .row-stock { font-family:var(--font-mono); font-variant-numeric:tabular-nums; }
        .row-stock.has-stock { color:var(--accent); font-weight:600; }
        .row-stock.zero-stock { color:var(--danger); font-weight:600; }
        .qty-input, .unit-price-input { font-family:var(--font-mono); font-variant-numeric:tabular-nums; text-align:right; }
        .row-del-btn { width:28px; height:28px; border:none; background:none; color:var(--danger); cursor:pointer; border-radius:var(--radius-sm); margin-top:4px; font-size:18px; line-height:1; }
        .row-del-btn:hover { background:var(--danger-soft); }
        .add-row-btn { margin-top:8px; font-size:13px; }
        .summary-row { display:flex; gap:10px; flex-wrap:wrap; padding:14px 20px; background:var(--surface-2); border:1px solid var(--border); border-radius:var(--radius); margin-top:12px; font-size:13px; color:var(--fg-soft); align-items:center; }
        .summary-row .pill { display:inline-flex; align-items:center; gap:6px; padding:3px 10px; border-radius:999px; border:1px solid var(--border); background:var(--surface); color:var(--fg-soft); font-weight:400; }
        .summary-row strong { font-weight:600; color:var(--fg); }
        .summary-row .sep { color:var(--border); }
        .section-actions-bar { display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
        .customer-info-card { border:1px solid var(--border); border-radius:var(--radius-sm); padding:14px 16px; background:var(--surface-2); margin-top:10px; }
        .cic-header { display:flex; align-items:center; justify-content:space-between; gap:12px; }
        .cic-name { font-size:14px; font-weight:700; color:var(--fg); line-height:1.4; }
        .cic-actions { display:flex; gap:4px; align-items:center; flex-shrink:0; }
        .cic-btn-remove { padding:4px; border:none; color:var(--muted); background:none; cursor:pointer; }
        .cic-btn-remove:hover { color:var(--danger); }
        .cic-btn-remove svg { width:16px; height:16px; stroke:currentColor; fill:none; stroke-width:2.2; stroke-linecap:round; stroke-linejoin:round; }
        .cic-details { display:flex; flex-wrap:wrap; gap:4px 18px; margin-top:10px; }
        .cic-detail-item { display:inline-flex; align-items:center; gap:4px; font-size:12.5px; color:var(--muted); }
        .modal-host { position:fixed; inset:0; background:rgba(15,23,42,.45); display:none; align-items:center; justify-content:center; z-index:1000; padding:20px; }
        .modal-host.show { display:flex; }
        .modal { background:var(--surface); border:1px solid var(--border); border-radius:12px; width:100%; max-width:680px; max-height:90vh; overflow:auto; padding:24px; box-shadow:0 20px 50px rgba(0,0,0,.18); }
        .modal-head { display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; }
        .modal-head h3 { margin:0; font-size:18px; font-weight:700; }
        .modal-close { background:0 0; border:0; color:var(--muted); cursor:pointer; font-size:24px; line-height:1; padding:4px 8px; border-radius:var(--radius-sm); }
        .modal-close:hover { background:var(--surface-2); color:var(--fg); }
        .modal-sub { font-size:13px; color:var(--muted); margin:0 0 14px; }
        .modal-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px 16px; }
        .modal-grid .span-2 { grid-column:span 2; }
        .modal-error { padding:10px 14px; border-radius:var(--radius-sm); background:var(--danger-soft); color:var(--danger); border:1px solid color-mix(in srgb,var(--danger) 25%,transparent); font-size:13px; font-weight:600; margin-bottom:12px; display:none; }
        .modal-error.show { display:block; }
        .modal-actions { display:flex; justify-content:flex-end; gap:8px; margin-top:18px; padding-top:14px; border-top:1px solid var(--border); }
        .topbar { position:sticky; top:0; z-index:10; background:color-mix(in srgb,var(--bg) 85%,transparent); backdrop-filter:blur(8px); border-bottom:1px solid var(--border); display:flex; align-items:center; gap:16px; padding:12px 24px; }
        .topbar h1 { font-size:16px; font-weight:700; margin:0; }
        .crumb { color:var(--muted); font-size:13px; font-weight:500; }
        .top-actions { margin-inline-start:auto; display:flex; align-items:center; gap:8px; }
        .icon-btn { width:32px; height:32px; border:1px solid var(--border); background:var(--surface); color:var(--fg-soft); border-radius:var(--radius-sm); display:grid; place-items:center; cursor:pointer; }
        .icon-btn:hover { background:var(--surface-2); color:var(--fg); }
        .icon-btn svg { width:15px; height:15px; stroke:currentColor; fill:none; stroke-width:1.8; }
        .status-badge { display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:600; padding:2px 9px; border-radius:999px; border:1px solid; margin-left:8px; }
        .status-badge.revision { color:#7c3aed; border-color:color-mix(in srgb,#7c3aed 30%,transparent); background:color-mix(in srgb,#7c3aed 8%,transparent); }
        .revision-reason { background:var(--surface-2); border:1px solid color-mix(in srgb,#7c3aed 30%,transparent); border-radius:10px; padding:14px 18px; margin-bottom:16px; }
        .revision-reason .rr-label { font-weight:700; font-size:11px; color:#7c3aed; text-transform:uppercase; letter-spacing:.04em; margin-bottom:4px; }
        .revision-reason .rr-body { font-size:13px; color:var(--fg); }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Chỉnh sửa đề xuất</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}"><c:out value="${proposal.proposalCode}"/></a> / Chỉnh sửa</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 0 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết
            </a>

            <c:if test="${not empty sessionScope.toastMessage}">
                <div class="alert alert-error"><c:out value="${sessionScope.toastMessage}"/></div>
                <c:remove var="toastMessage" scope="session"/>
                <c:remove var="toastType" scope="session"/>
            </c:if>

            <c:if test="${proposal.status == 'NEEDS_REVISION' && not empty proposal.rejectReason}">
                <div class="revision-reason">
                    <div class="rr-label">Lý do ${proposal.revisionRequestedByRole == 'CEO' ? 'CEO' : 'Sale Manager'} yêu cầu chỉnh sửa</div>
                    <div class="rr-body"><c:out value="${proposal.rejectReason}"/></div>
                </div>
            </c:if>

            <div class="page-head">
                <div class="eyebrow">Đề xuất nhập kho · Chỉnh sửa</div>
                <h2 class="page-title">
                    Chỉnh sửa phiếu đề xuất
                    <c:choose>
                    <c:when test="${proposal.status == 'NEEDS_REVISION'}"><span class="status-badge revision">Cần chỉnh sửa</span></c:when>
                    </c:choose>
                </h2>
                <p class="page-sub">Phiếu <c:out value="${proposal.proposalCode}"/> · Người tạo: <c:out value="${proposal.createdByName}"/></p>
            </div>

            <form id="uploadExcelForm" method="post" action="${pageContext.request.contextPath}/proposal?action=uploadEditExcel&id=${proposal.proposalId}" enctype="multipart/form-data" style="display:none">
                <input type="file" name="excelFile" id="excelUpload" accept=".xlsx,.xls" onchange="this.form.submit()" />
            </form>
            <form id="editForm" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm()">
                <input type="hidden" name="id" value="${proposal.proposalId}" />

                <div class="form-card">
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                            <h3 class="form-section-title">Thông tin chung</h3>
                        </div>

                        <div class="field">
                            <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                            <select class="select" id="warehouseId" name="warehouseId" required
                                    onchange="if(this.value){location.href='${pageContext.request.contextPath}/proposal?action=edit&amp;id=${proposal.id}&amp;warehouseId='+this.value;}">
                                <option value="">-- Chọn kho --</option>
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="field">
                            <label class="field-label" for="custTriggerLabel">Nhà cung cấp <span class="req">*</span>
                                <span class="opt">(áp dụng cho cả phiếu)</span>
                            </label>
                            <div class="sd" id="customerDropdown"
                                 data-endpoint="${pageContext.request.contextPath}/warehouse/suppliers?action=search&q=">
                                <div class="cust-trigger-wrap">
                                    <button type="button" class="cust-trigger" id="custTrigger"
                                            onclick="openCustomerPanel()" aria-haspopup="dialog">
                                        <span class="cust-trigger-label" id="custTriggerLabel">-- Click để chọn nhà cung cấp --</span>
                                        <svg class="cust-trigger-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M21 21l-4.35-4.35M11 19a8 8 0 1 1 0-16 8 8 0 0 1 0 16z" stroke="currentColor" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                        </svg>
                                    </button>
                                    <button type="button" class="cust-clear-btn" id="custClearBtn"
                                            onclick="clearCustomerSelection()" title="Hủy chọn nhà cung cấp" aria-label="Hủy chọn">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M18 6L6 18M6 6l12 12"/>
                                        </svg>
                                    </button>
                                </div>
                                <input type="hidden" name="supplierId" id="sdHiddenId" value="${proposal.supplierId != null ? proposal.supplierId : ''}" />
                                <input type="hidden" id="inpCustName" value="${proposal.supplierName != null ? proposal.supplierName : ''}" />
                                <input type="hidden" id="inpCustPhone" value="" />
                                <input type="hidden" id="inpCustEmail" value="" />
                                <input type="hidden" id="inpCustAddress" value="" />
                                <input type="hidden" id="customerCompany" value="" />
                            </div>

                            <div id="customerCardContainer" class="customer-info-card" style="display:none;"></div>

                            <c:if test="${canCreateSupplier}">
                                <button type="button" class="btn btn-sm" onclick="openNewSupplierModal()" style="margin-top:10px;">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm NCC mới
                                </button>
                            </c:if>
                        </div>

                        <div class="field">
                            <label class="field-label" for="note">Ghi chú phiếu</label>
                            <textarea class="textarea" id="note" name="note" rows="2" placeholder="Ghi chú cho phiếu..."><c:out value="${proposal.note}"/></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-card">
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="section-actions-bar">
                                <c:if test="${canCreateGenerator}">
                                    <button type="button" class="btn btn-sm" onclick="openNewGeneratorModal()">
                                        <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                                        Thêm máy phát mới
                                    </button>
                                </c:if>
                                <div>
                                    <div class="form-section-num">02 — DANH SÁCH MÁY PHÁT</div>
                                    <h3 class="form-section-title">Chi tiết sản phẩm</h3>
                                </div>
                            </div>
                            <div class="section-actions-bar">
                                <a class="btn btn-sm" href="${pageContext.request.contextPath}/proposal?action=downloadTemplate">
                                    <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    Tải mẫu Excel
                                </a>
                                <button type="button" class="btn btn-sm" onclick="document.getElementById('excelUpload').click()">
                                    <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                    Import Excel
                                </button>
                            </div>
                        </div>

                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th>Mẫu máy <span class="req">*</span></th>
                                    <th class="col-stock">Tồn kho</th>
                                    <th class="col-qty">Số lượng <span class="req">*</span></th>
                                    <th class="col-price">Đơn giá (VNĐ) <span class="req">*</span></th>
                                    <th class="col-price">Thành tiền</th>
                                    <th class="col-note">Ghi chú dòng</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${not empty proposal.details}">
                                        <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                            <tr>
                                                <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                                <td>
                                                    <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                        <option value="">-- Chọn máy --</option>
                                                        <c:forEach var="g" items="${generators}">
                                                            <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>><c:out value="${g.model}"/></option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td class="col-stock"><span class="row-stock mono">—</span></td>
                                                <td><input type="text" inputmode="numeric" name="quantity" class="qty-input" value="${d.quantity}" maxlength="4" oninput="validateQty(this);updateTotal()" onblur="finalizeQty(this)" required /></td>
                                                <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="${d.unitPrice}" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="finalizeUnitPrice(this)" required /></td>
                                                <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                                <td><input type="text" name="detailNote" class="row-note-input" value="<c:out value='${d.note}'/>" placeholder="Ghi chú dòng" /></td>
                                                <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
                                            <td>
                                                <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td class="col-stock"><span class="row-stock mono">—</span></td>
                                            <td><input type="text" inputmode="numeric" name="quantity" class="qty-input" value="1" maxlength="4" oninput="validateQty(this);updateTotal()" onblur="finalizeQty(this)" required /></td>
                                            <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="finalizeUnitPrice(this)" required /></td>
                                            <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                            <td><input type="text" name="detailNote" class="row-note-input" placeholder="Ghi chú dòng" /></td>
                                            <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            <tfoot>
                                <tr class="total-row">
                                    <td colspan="5" class="text-right">Tổng cộng:</td>
                                    <td class="text-right mono" id="grandTotal">0₫</td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>

                        <button type="button" class="btn add-row-btn" onclick="addRow()">
                            <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>

                        <template id="rowTemplate">
                            <tr>
                                <td class="col-num"><span class="row-num"></span></td>
                                <td>
                                    <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                        <option value="">-- Chọn máy --</option>
                                        <c:forEach var="g" items="${generators}">
                                            <option value="${g.id}"><c:out value="${g.model}"/></option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td class="col-stock"><span class="row-stock mono">—</span></td>
                                <td><input type="text" inputmode="numeric" name="quantity" class="qty-input" value="1" maxlength="4" oninput="validateQty(this);updateTotal()" onblur="finalizeQty(this)" required /></td>
                                <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="finalizeUnitPrice(this)" required /></td>
                                <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                <td><input type="text" name="detailNote" class="row-note-input" placeholder="Ghi chú dòng" /></td>
                                <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                            </tr>
                        </template>
                    </div>
                </div>

                <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                    <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        ${proposal.status == 'NEEDS_REVISION' ? 'Gửi duyệt lại' : 'Gửi duyệt'}
                    </button>
                </div>
            </form>

            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                <input type="hidden" name="id" value="${proposal.proposalId}" />
            </form>

            <script>
                (function() {
                    var label = document.getElementById('custTriggerLabel');
                    if (label) {
                        var nameVal = document.getElementById('inpCustName').value || '';
                        var supId = document.getElementById('sdHiddenId').value || '';
                        if (nameVal && supId) {
                            label.textContent = nameVal;
                            label.classList.add('has-value');
                        }
                    }
                })();
            </script>
        </main>
    </div>
</div>

<div class="modal-host" id="genModalOverlay">
    <div class="modal">
        <div class="modal-head">
            <h3>Thêm máy phát mới</h3>
            <button type="button" class="modal-close" onclick="closeNewGeneratorModal()">&times;</button>
        </div>
        <p class="modal-sub">Máy phát sẽ được thêm vào dropdown của mọi dòng bên dưới.</p>
        <div class="modal-error" id="genModalError"></div>
        <div class="modal-grid">
            <div>
                <label class="field-label">Mã máy phát (model) <span class="req">*</span></label>
                <input class="input" id="ngModel" placeholder="VD: Honda EU22i" />
            </div>
            <div>
                <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                <input class="input mono" id="ngPower" type="number" step="0.01" placeholder="VD: 50" />
            </div>
            <div>
                <label class="field-label">Tần số (Hz)</label>
                <input class="input mono" id="ngFreq" placeholder="VD: 50" />
            </div>
            <div>
                <label class="field-label">Trọng lượng (kg)</label>
                <input class="input mono" id="ngWeight" type="number" step="0.01" placeholder="VD: 120" />
            </div>
            <div>
                <label class="field-label">Thương hiệu</label>
                <select class="select" id="ngBrandId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catBrands}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Xuất xứ</label>
                <select class="select" id="ngOriginId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catOrigins}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Tình trạng</label>
                <select class="select" id="ngConditionId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catConditions}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Nhiên liệu</label>
                <select class="select" id="ngFuelTypeId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catFuelTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Số pha</label>
                <select class="select" id="ngPhaseId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catPhases}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Loại máy phát</label>
                <select class="select" id="ngGenTypeId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catGenTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeNewGeneratorModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ngSaveBtn" onclick="saveNewGenerator()">Lưu máy phát</button>
        </div>
    </div>
</div>

<div class="modal-host" id="supModalOverlay">
    <div class="modal">
        <div class="modal-head">
            <h3>Thêm nhà cung cấp mới</h3>
            <button type="button" class="modal-close" onclick="closeNewSupplierModal()">&times;</button>
        </div>
        <p class="modal-sub">Nhà cung cấp sẽ được áp dụng cho toàn bộ phiếu.</p>
        <div class="modal-error" id="supModalError"></div>
        <div class="modal-grid">
            <div>
                <label class="field-label">Tên nhà cung cấp <span class="req">*</span></label>
                <input class="input" id="nsName" placeholder="VD: Nguyễn Văn B" />
            </div>
            <div>
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input class="input mono" id="nsPhone" type="tel" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" />
            </div>
            <div>
                <label class="field-label">Email</label>
                <input class="input mono" id="nsEmail" type="email" placeholder="email@example.com" />
            </div>
            <div>
                <label class="field-label">Loại NCC</label>
                <select class="select" id="nsTypeId"><option value="">-- Chọn --</option>
                    <c:forEach var="t" items="${supplierTypeList}"><option value="${t.id}"><c:out value="${t.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="span-2">
                <label class="field-label">Tên công ty</label>
                <input class="input" id="nsCompanyName" placeholder="VD: Công ty TNHH ABC" />
            </div>
            <div class="span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea class="textarea" id="nsAddress" rows="2" placeholder="Địa chỉ NCC"></textarea>
            </div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeNewSupplierModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="nsSaveBtn" onclick="saveNewSupplier()">Lưu NCC</button>
        </div>
    </div>
</div>

<div class="side-panel-overlay" id="custPanelOverlay" onclick="closeCustomerPanel()"></div>
<div class="side-panel" id="custSidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn nhà cung cấp</h3>
        <button type="button" class="side-panel-close" onclick="closeCustomerPanel()">&times;</button>
    </div>
    <div class="side-panel-body">
        <div style="display:flex;gap:8px;margin-bottom:20px;">
            <input type="text" id="custSearchInput" class="serial-search-box" placeholder="Tìm nhanh theo tên, SĐT, email..." />
            <select id="custSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                <option value="name_asc">Tên A-Z</option>
                <option value="name_desc">Tên Z-A</option>
                <option value="newest">Mới nhất</option>
            </select>
        </div>
        <div id="custLoading" style="display:none;text-align:center;padding:40px 20px;color:var(--muted);">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
            </svg><br>Đang tải...
        </div>
        <div class="cust-list-wrap" id="custList"></div>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script>
var STOCK_MAP = {};
<c:forEach var="entry" items="${stockByGen}">
STOCK_MAP['${entry.key}'] = ${entry.value};
</c:forEach>
</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
function formatVND(num) { return new Intl.NumberFormat('vi-VN', {style:'currency', currency:'VND'}).format(num || 0); }
function getStock(gid) { return STOCK_MAP[gid] || 0; }
function htmlEsc(s) { if (s == null) return ''; return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;'); }

function validateQty(input) {
    var cleaned = (input.value || '').replace(/[^0-9]/g, '');
    if (cleaned.length > 4) cleaned = cleaned.slice(0, 4);
    if (input.value !== cleaned) input.value = cleaned;
    updateTotal();
}
function finalizeQty(input) {
    var n = parseInt(input.value, 10);
    if (isNaN(n)) return;
    if (n > 9999) input.value = '9999';
    updateTotal();
}
function validateUnitPrice(input) {
    var cleaned = (input.value || '').replace(/[^\d]/g, '');
    if (input.value && cleaned === '') {
        toast('Đơn giá chỉ được nhập số!', 'danger');
        input.value = '0';
    } else if (cleaned !== input.value) {
        input.value = cleaned;
    }
    updateTotal();
}
function finalizeUnitPrice(input) {
    var n = parseInt((input.value || '').replace(/[^\d]/g, ''), 10);
    if (isNaN(n)) return;
    input.value = n > 0 ? String(n) : '0';
    updateTotal();
}
function formatPriceDisplay(input) {
    var n = parseInt(input.value.replace(/[^\d]/g, '')) || 0;
    input.value = n > 0 ? String(n) : '0';
}
function unformatPrice(input) { input.value = input.value.replace(/[^\d]/g, '') || '0'; }

function updateStockCell(sel) {
    var cell = sel.closest('tr').querySelector('.row-stock');
    if (!sel.value) { cell.textContent = '—'; cell.className = 'row-stock mono'; return; }
    var s = getStock(sel.value);
    cell.textContent = s + ' máy';
    cell.className = s === 0 ? 'row-stock mono zero-stock' : 'row-stock mono has-stock';
}
function updateTotal() {
    var total = 0;
    document.querySelectorAll('#detailBody tr').forEach(function (tr) {
        var q = parseInt(tr.querySelector('.qty-input').value) || 0;
        var p = parseInt((tr.querySelector('.unit-price-input').value || '').replace(/[^\d]/g, '')) || 0;
        var subtotal = q * p;
        var subEl = tr.querySelector('.row-subtotal');
        if (subEl) subEl.textContent = formatVND(subtotal);
        total += subtotal;
    });
    document.getElementById('grandTotal').textContent = formatVND(total);
}
function updateRowNumbers() {
    document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) { el.textContent = i + 1; });
}
function addRow() {
    var clone = document.getElementById('rowTemplate').content.cloneNode(true);
    document.getElementById('detailBody').appendChild(clone);
    updateRowNumbers();
    updateTotal();
}
function removeRow(btn) {
    var tbody = document.getElementById('detailBody');
    if (tbody.querySelectorAll('tr').length <= 1) return;
    btn.closest('tr').remove();
    updateRowNumbers();
    updateTotal();
}
function validateForm() {
    var wh = document.getElementById('warehouseId').value;
    var sup = document.getElementById('sdHiddenId').value;
    if (!wh) { toast('Vui lòng chọn kho nhập.', 'danger'); return false; }
    if (!sup) { toast('Vui lòng chọn nhà cung cấp.', 'danger'); return false; }
    var dataRows = document.querySelectorAll('#detailBody tr');
    var hasValid = false;
    var firstBad = null;
    for (var i = 0; i < dataRows.length; i++) {
        var tr = dataRows[i];
        var sel = tr.querySelector('.gen-select');
        var qtyEl = tr.querySelector('.qty-input');
        var upEl  = tr.querySelector('.unit-price-input');
        var qty = parseInt((qtyEl.value || '').replace(/[^0-9]/g, ''), 10);
        var upStr = (upEl.value || '').replace(/[^\d]/g, '');
        var up = parseInt(upStr, 10);
        if (sel && sel.value) {
            if (!qty || qty < 1) {
                if (!firstBad) firstBad = { el: qtyEl, msg: 'Số lượng ở dòng ' + (i + 1) + ' phải lớn hơn 0.' };
            } else if (!upStr || up <= 0) {
                if (!firstBad) firstBad = { el: upEl, msg: 'Đơn giá ở dòng ' + (i + 1) + ' phải lớn hơn 0.' };
            } else {
                hasValid = true;
            }
        }
    }
    if (firstBad) {
        toast(firstBad.msg, 'danger');
        firstBad.el.focus();
        if (typeof firstBad.el.select === 'function') firstBad.el.select();
        return false;
    }
    if (!hasValid) { toast('Vui lòng chọn ít nhất 1 máy phát điện.', 'danger'); return false; }
    document.querySelectorAll('.unit-price-input').forEach(function (el) { el.value = el.value.replace(/[^\d]/g, ''); });
    return true;
}
function confirmDelete() {
    if (confirm('Xoá phiếu đề xuất này?')) document.getElementById('deleteForm').submit();
}

function refreshSupplierCard() {
    var container = document.getElementById('customerCardContainer');
    if (!container) return;
    var hid = document.getElementById('sdHiddenId');
    var supId = hid ? hid.value : '';
    if (!supId || !supId.trim()) {
        container.style.display = 'none';
        return;
    }
    container.style.display = '';
    var nameEl = document.getElementById('inpCustName');
    var phoneEl = document.getElementById('inpCustPhone');
    var emailEl = document.getElementById('inpCustEmail');
    var companyEl = document.getElementById('customerCompany');
    var nameVal = nameEl ? nameEl.value : '';
    var phoneVal = phoneEl ? phoneEl.value : '';
    var emailVal = emailEl ? emailEl.value : '';
    var companyVal = companyEl ? companyEl.value : '';
    var html = '<div class="cic-header"><span class="cic-name">' + htmlEsc(nameVal || '') + '</span>';
    html += '<div class="cic-actions"><button type="button" class="cic-btn-remove" onclick="clearCustomerSelection();refreshSupplierCard();" title="Hủy chọn" aria-label="Hủy chọn">';
    html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg>';
    html += '</button></div></div>';
    html += '<div class="cic-details">';
    if (phoneVal) html += '<span class="cic-detail-item">📞 ' + htmlEsc(phoneVal) + '</span>';
    if (companyVal) html += '<span class="cic-detail-item">🏢 ' + htmlEsc(companyVal) + '</span>';
    if (emailVal) html += '<span class="cic-detail-item">✉ ' + htmlEsc(emailVal) + '</span>';
    html += '</div>';
    container.innerHTML = html;
}

(function() {
    var list = document.getElementById('custList');
    if (list) {
        list.addEventListener('click', function(e) {
            if (e.target.closest('.cust-card')) {
                setTimeout(refreshSupplierCard, 0);
            }
        });
    }
})();
refreshSupplierCard();

function openNewGeneratorModal() {
    ['ngModel','ngPower','ngFreq','ngWeight','ngBrandId','ngOriginId','ngConditionId','ngFuelTypeId','ngPhaseId','ngGenTypeId']
        .forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
    var err = document.getElementById('genModalError'); err.classList.remove('show'); err.textContent = '';
    document.getElementById('genModalOverlay').classList.add('show');
}
function closeNewGeneratorModal() { document.getElementById('genModalOverlay').classList.remove('show'); }
function saveNewGenerator() {
    var model = document.getElementById('ngModel').value.trim();
    var power = document.getElementById('ngPower').value.trim();
    if (!model || !power) {
        var err = document.getElementById('genModalError');
        err.textContent = 'Vui lòng nhập mã máy phát và công suất.'; err.classList.add('show'); return;
    }
    var btn = document.getElementById('ngSaveBtn');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    var fd = new FormData();
    fd.append('action', 'quickCreateGenerator');
    fd.append('model', model);
    fd.append('powerRating', power);
    fd.append('frequency', document.getElementById('ngFreq').value.trim());
    fd.append('weight', document.getElementById('ngWeight').value.trim());
    fd.append('brandId', document.getElementById('ngBrandId').value);
    fd.append('originId', document.getElementById('ngOriginId').value);
    fd.append('conditionId', document.getElementById('ngConditionId').value);
    fd.append('fuelTypeId', document.getElementById('ngFuelTypeId').value);
    fd.append('phaseId', document.getElementById('ngPhaseId').value);
    fd.append('genTypeId', document.getElementById('ngGenTypeId').value);
    fetch(window.APP_CTX + '/proposal', { method:'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false; btn.textContent = 'Lưu máy phát';
            if (!data.ok) { var err = document.getElementById('genModalError'); err.textContent = data.error || 'Lỗi'; err.classList.add('show'); return; }
            document.querySelectorAll('#detailBody .gen-select').forEach(function (sel) {
                var exists = false;
                for (var i = 0; i < sel.options.length; i++) { if (sel.options[i].value == data.id) { exists = true; break; } }
                if (!exists) {
                    var opt = document.createElement('option');
                    opt.value = data.id; opt.text = data.model;
                    sel.appendChild(opt);
                }
            });
            closeNewGeneratorModal();
            if (typeof toast !== 'undefined') toast(data.existing ? 'Mã "' + data.model + '" đã có — đã thêm vào dropdown.' : 'Đã thêm máy phát "' + data.model + '"', data.existing ? 'info' : 'success');
        }).catch(function () {
            btn.disabled = false; btn.textContent = 'Lưu máy phát';
            var err = document.getElementById('genModalError'); err.textContent = 'Lỗi kết nối'; err.classList.add('show');
        });
}

function openNewSupplierModal() {
    ['nsName','nsPhone','nsEmail','nsCompanyName','nsAddress','nsTypeId'].forEach(function (id) {
        var el = document.getElementById(id); if (el) el.value = '';
    });
    var err = document.getElementById('supModalError'); err.classList.remove('show'); err.textContent = '';
    document.getElementById('supModalOverlay').classList.add('show');
}
function closeNewSupplierModal() { document.getElementById('supModalOverlay').classList.remove('show'); }
function saveNewSupplier() {
    var name = document.getElementById('nsName').value.trim();
    var phone = document.getElementById('nsPhone').value.trim();
    if (!name || !/^[0-9]{10,11}$/.test(phone)) {
        var err = document.getElementById('supModalError');
        err.textContent = 'Vui lòng nhập tên và SĐT hợp lệ (10-11 chữ số).'; err.classList.add('show'); return;
    }
    var btn = document.getElementById('nsSaveBtn');
    btn.disabled = true; btn.textContent = 'Đang lưu...';
    var fd = new FormData();
    fd.append('action', 'quickCreateSupplier');
    fd.append('name', name);
    fd.append('phone', phone);
    fd.append('email', document.getElementById('nsEmail').value.trim());
    fd.append('address', document.getElementById('nsAddress').value.trim());
    fd.append('companyName', document.getElementById('nsCompanyName').value.trim());
    fd.append('supplierTypeId', document.getElementById('nsTypeId').value);
    fetch(window.APP_CTX + '/proposal', { method:'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false; btn.textContent = 'Lưu NCC';
            if (!data.ok) { var err = document.getElementById('supModalError'); err.textContent = data.error || 'Lỗi'; err.classList.add('show'); return; }
            document.getElementById('sdHiddenId').value = data.id;
            document.getElementById('inpCustName').value = data.name || '';
            document.getElementById('inpCustPhone').value = data.phone || '';
            document.getElementById('customerCompany').value = data.companyName || '';
            var label = document.getElementById('custTriggerLabel');
            label.textContent = data.name || data.phone || '';
            label.classList.add('has-value');
            closeNewSupplierModal();
            refreshSupplierCard();
            if (typeof toast !== 'undefined') toast(data.existing ? 'SĐT đã có NCC: ' + data.name + ' — đã tự chọn.' : 'Đã thêm NCC "' + data.name + '"', data.existing ? 'info' : 'success');
        }).catch(function () {
            btn.disabled = false; btn.textContent = 'Lưu NCC';
            var err = document.getElementById('supModalError'); err.textContent = 'Lỗi kết nối'; err.classList.add('show');
        });
}

document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('#detailBody .gen-select').forEach(function (sel) { updateStockCell(sel); });
    updateTotal();
});
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        if (typeof closeCustomerPanel === 'function') closeCustomerPanel();
        closeNewGeneratorModal();
        closeNewSupplierModal();
    }
});
</script>
</body>
</html>