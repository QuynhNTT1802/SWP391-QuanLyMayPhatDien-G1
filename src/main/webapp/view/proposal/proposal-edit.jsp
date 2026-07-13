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
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    <style>
        .detail-table { width:100%; border-collapse:collapse; margin-top:8px; }
        .detail-table th { text-align:left; padding:8px 10px; font-size:12px; font-weight:600; color:var(--muted); border-bottom:1px solid var(--border); text-transform:uppercase; letter-spacing:.5px; }
        .detail-table td { padding:8px 6px; vertical-align:top; }
        .detail-table select, .detail-table input { width:100%; padding:7px 8px; border:1px solid var(--border); border-radius:var(--radius-sm); background:var(--bg); color:var(--fg); font-size:13px; box-sizing:border-box; }
        .col-num { width:36px; text-align:center; color:var(--muted); font-weight:600; padding-top:14px; }
        .col-qty { width:90px; }
        .col-stock { width:90px; text-align:center; font-size:12px; color:var(--muted); padding-top:14px; }
        .col-price { width:140px; }
        .col-note { min-width:140px; }
        .col-del { width:40px; text-align:center; }
        .row-stock { font-family:var(--font-mono); font-variant-numeric:tabular-nums; }
        .row-stock.has-stock { color:var(--accent); font-weight:600; }
        .row-stock.zero-stock { color:var(--danger); font-weight:600; }
        .qty-input, .unit-price-input { font-family:var(--font-mono); font-variant-numeric:tabular-nums; text-align:right; }
        .unit-price-input { color:var(--muted); }
        .row-note-input { font-size:13px; }
        .row-del-btn { width:28px; height:28px; border:none; background:none; color:var(--danger); cursor:pointer; border-radius:var(--radius-sm); margin-top:4px; font-size:18px; line-height:1; }
        .row-del-btn:hover { background:var(--danger-soft); }
        .add-row-btn { margin-top:8px; font-size:13px; }
        .grand-total-box { margin-top:16px; padding:14px 18px; background:var(--accent-soft); border-radius:var(--radius); display:flex; justify-content:space-between; align-items:center; }
        .grand-total-label { font-size:13px; font-weight:600; color:var(--muted); letter-spacing:.5px; text-transform:uppercase; }
        .grand-total-value { font-size:18px; font-weight:700; color:var(--accent); font-family:var(--font-mono); }
        .form-section { background:var(--surface); border:1px solid var(--border); border-radius:10px; padding:20px 22px; margin-bottom:16px; }
        .form-section-head { margin-bottom:14px; padding-bottom:12px; border-bottom:1px solid var(--border); }
        .form-section-num { font-size:11px; font-weight:700; color:var(--accent); letter-spacing:.08em; text-transform:uppercase; }
        .form-section-title { margin:4px 0 0; font-size:15px; font-weight:700; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px 18px; }
        .form-grid .full { grid-column:span 2; }
        .field-label { display:block; font-size:11px; color:var(--muted); font-weight:700; text-transform:uppercase; letter-spacing:.04em; margin-bottom:6px; }
        .field-label .req { color:var(--danger); }
        .pill { display:inline-flex; align-items:center; gap:6px; font-size:12px; font-weight:600; padding:3px 10px; border-radius:999px; border:1px solid var(--border); background:var(--surface-2); color:var(--muted); }
        .summary-row { display:flex; gap:10px; flex-wrap:wrap; margin:14px 0 4px; }
        .alert { padding:12px 16px; border-radius:var(--radius-sm); margin-bottom:16px; font-size:13px; font-weight:600; display:flex; align-items:center; gap:10px; border:1px solid; }
        .alert-warn { background:var(--warn-soft); color:var(--warn); border-color:color-mix(in srgb,var(--warn) 30%,transparent); }
        .alert-error { background:var(--danger-soft); color:var(--danger); border-color:color-mix(in srgb,var(--danger) 30%,transparent); }
        .revision-reason { background:var(--surface-2); border:1px solid color-mix(in srgb,#7c3aed 30%,transparent); border-radius:10px; padding:14px 18px; margin-bottom:16px; }
        .revision-reason .rr-label { font-weight:700; font-size:11px; color:#7c3aed; text-transform:uppercase; letter-spacing:.04em; margin-bottom:4px; }
        .revision-reason .rr-body { font-size:13px; color:var(--fg); }
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
        .input { font-family:var(--font-ui); font-size:14px; color:var(--fg); background:var(--surface); border:1px solid var(--border); border-radius:var(--radius-sm); padding:9px 12px; width:100%; line-height:1.4; box-sizing:border-box; }
        .input:focus { outline:none; border-color:var(--accent); box-shadow:0 0 0 3px var(--accent-soft); }
        textarea.input { min-height:64px; resize:vertical; }
        .btn { display:inline-flex; align-items:center; gap:6px; border:1px solid var(--border); background:var(--surface); color:var(--fg); padding:8px 16px; border-radius:var(--radius-sm); font-size:13px; font-weight:600; cursor:pointer; font-family:var(--font-ui); text-decoration:none; }
        .btn:hover { background:var(--surface-2); }
        .btn-primary { background:var(--fg); color:var(--bg); border-color:var(--fg); }
        .btn-primary:hover { background:var(--fg-soft); border-color:var(--fg-soft); }
        .btn-sm { padding:5px 12px; font-size:12px; }
        .btn-danger { background:var(--danger); color:#fff; border-color:var(--danger); }
        .actions { display:flex; gap:10px; justify-content:flex-end; margin-top:20px; flex-wrap:wrap; }
        .topbar { position:sticky; top:0; z-index:10; background:color-mix(in srgb,var(--bg) 85%,transparent); backdrop-filter:blur(8px); border-bottom:1px solid var(--border); display:flex; align-items:center; gap:16px; padding:12px 24px; }
        .topbar h1 { font-size:16px; font-weight:700; margin:0; }
        .crumb { color:var(--muted); font-size:13px; font-weight:500; }
        .top-actions { margin-inline-start:auto; display:flex; align-items:center; gap:8px; }
        .icon-btn { width:32px; height:32px; border:1px solid var(--border); background:var(--surface); color:var(--fg-soft); border-radius:var(--radius-sm); display:grid; place-items:center; cursor:pointer; }
        .icon-btn:hover { background:var(--surface-2); color:var(--fg); }
        .icon-btn svg { width:15px; height:15px; stroke:currentColor; fill:none; stroke-width:1.6; }
        .back-link { display:inline-flex; align-items:center; gap:6px; color:var(--muted); text-decoration:none; font-size:13px; font-weight:600; margin-bottom:14px; }
        .back-link:hover { color:var(--fg); }
        .back-link svg { width:14px; height:14px; stroke:currentColor; fill:none; stroke-width:1.8; }
        .status-badge { display:inline-flex; align-items:center; gap:5px; font-size:11.5px; font-weight:600; padding:2px 9px; border-radius:999px; border:1px solid; margin-left:8px; }
        .status-badge.draft { color:var(--muted); border-color:var(--border); background:var(--surface-2); }
        .status-badge.revision { color:#7c3aed; border-color:color-mix(in srgb,#7c3aed 30%,transparent); background:color-mix(in srgb,#7c3aed 8%,transparent); }
        .gen-cell-wrap { display:flex; gap:6px; align-items:center; }
        .gen-cell-wrap .gen-select { flex:1; min-width:0; }
        .gen-cell-wrap .inline-add-btn { padding:6px 10px; font-size:12px; }
        .inline-add-btn { display:inline-flex; align-items:center; justify-content:center; width:32px; height:32px; padding:0; font-size:14px; font-weight:700; color:var(--accent); background:var(--accent-soft); border:1px solid color-mix(in srgb,var(--accent) 30%,transparent); border-radius:var(--radius-sm); cursor:pointer; }
        .inline-add-btn:hover { background:color-mix(in srgb,var(--accent) 20%,transparent); }
        .supplier-cell { display:flex; gap:8px; align-items:center; }
        .supplier-cell .input-select { flex:1; min-width:0; }
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
                <a class="btn btn-sm" href="${pageContext.request.contextPath}/proposal?action=importExcel" title="Import nhiều dòng từ file Excel">
                    <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                    Import từ Excel
                </a>
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 0 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
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
                <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : 'alert-warn'}">
                    <span><c:out value="${sessionScope.toastMessage}"/></span>
                </div>
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
                <div class="form-section-num">Đề xuất nhập kho · Chỉnh sửa</div>
                <h2 style="margin:6px 0 4px;font-size:22px;font-weight:700;">
                    Chỉnh sửa phiếu đề xuất
                    <c:choose>
                        <c:when test="${proposal.status == 'DRAFT'}"><span class="status-badge draft">Nháp</span></c:when>
                        <c:when test="${proposal.status == 'NEEDS_REVISION'}"><span class="status-badge revision">Cần chỉnh sửa</span></c:when>
                    </c:choose>
                </h2>
                <div style="font-size:13px;color:var(--muted);">Phiếu <c:out value="${proposal.proposalCode}"/> · Người tạo: <c:out value="${proposal.createdByName}"/></div>
            </div>

            <form id="uploadExcelForm" method="post" action="${pageContext.request.contextPath}/proposal?action=uploadEditExcel&id=${proposal.proposalId}" enctype="multipart/form-data" style="display:none">
                <input type="file" name="excelFile" id="excelUpload" accept=".xlsx,.xls" onchange="this.form.submit()" />
            </form>
            <form id="editForm" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm()">
                <input type="hidden" name="id" value="${proposal.proposalId}" />

                <div class="form-section">
                    <div class="form-section-head">
                        <div class="form-section-num">01 — Thông tin chung</div>
                        <h3 class="form-section-title">Kho nhập & Nhà cung cấp</h3>
                    </div>
                    <div class="form-grid">
                        <div>
                            <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                            <select class="input" id="warehouseId" name="warehouseId" required>
                                <option value="">-- Chọn kho --</option>
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                </c:forEach>
                            </select>
                        </div>
                        <div>
                            <label class="field-label" for="supplierId">Nhà cung cấp <span class="req">*</span> <span style="font-weight:500;color:var(--muted);text-transform:none;letter-spacing:0">(áp dụng cho cả phiếu)</span></label>
                            <div class="supplier-cell">
                                <select class="input input-select" id="supplierId" name="supplierId" required>
                                    <option value="">-- Chọn NCC --</option>
                                    <c:forEach var="s" items="${suppliers}">
                                        <option value="${s.id}" data-phone="${s.phone}" <c:if test="${s.id == proposal.supplierId}">selected</c:if>><c:out value="${s.name}"/></option>
                                    </c:forEach>
                                </select>
                                <c:if test="${canCreateSupplier}">
                                    <button type="button" class="btn btn-sm" onclick="openNewSupplierModal()" title="Thêm NCC mới">+ NCC</button>
                                </c:if>
                            </div>
                        </div>
                        <div class="full">
                            <label class="field-label" for="note">Ghi chú phiếu</label>
                            <textarea class="input" id="note" name="note" rows="2" placeholder="Ghi chú cho phiếu..."><c:out value="${proposal.note}"/></textarea>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="form-section-head">
                        <div style="display:flex;justify-content:space-between;align-items:center;gap:12px;">
                            <div>
                                <div class="form-section-num">02 — Danh sách máy phát</div>
                                <h3 class="form-section-title">Cập nhật sản phẩm</h3>
                            </div>
                            <div>
                                <button type="button" class="btn btn-sm" onclick="document.getElementById('excelUpload').click()">Tải Excel thay thế</button>
                            </div>
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
                                                <div class="gen-cell-wrap">
                                                    <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                        <option value="">-- Chọn máy --</option>
                                                        <c:forEach var="g" items="${generators}">
                                                            <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>><c:out value="${g.model}"/></option>
                                                        </c:forEach>
                                                    </select>
                                                    <c:if test="${canCreateGenerator}">
                                                        <button type="button" class="inline-add-btn" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới">+</button>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td class="col-stock"><span class="row-stock mono">—</span></td>
                                            <td><input type="number" name="quantity" class="qty-input" value="${d.quantity}" min="1" max="9999" step="1" oninput="validateQty(this);updateTotal()" required /></td>
                                            <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="<fmt:formatNumber value='${d.unitPrice}' pattern='#,##0'/>" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="formatPriceDisplay(this)" required /></td>
                                            <td><input type="text" name="detailNote" class="row-note-input" value="<c:out value='${d.note}'/>" placeholder="Ghi chú dòng" /></td>
                                            <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td class="col-num"><span class="row-num">1</span></td>
                                        <td>
                                            <div class="gen-cell-wrap">
                                                <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                    </c:forEach>
                                                </select>
                                                <c:if test="${canCreateGenerator}">
                                                    <button type="button" class="inline-add-btn" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới">+</button>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="col-stock"><span class="row-stock mono">—</span></td>
                                        <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" step="1" oninput="validateQty(this);updateTotal()" required /></td>
                                        <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="formatPriceDisplay(this)" required /></td>
                                        <td><input type="text" name="detailNote" class="row-note-input" placeholder="Ghi chú dòng" /></td>
                                        <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <button type="button" class="btn add-row-btn" onclick="addRow()">
                        <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                        Thêm dòng
                    </button>

                    <div class="grand-total-box">
                        <div class="grand-total-label">Tổng cộng (<span id="sumRows">0</span> dòng · <span id="sumQty">0</span> máy)</div>
                        <div class="grand-total-value" id="sumValue">0₫</div>
                    </div>
                </div>

                <div class="actions">
                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                    <c:if test="${proposal.status == 'DRAFT'}">
                        <button type="button" class="btn btn-danger" onclick="confirmDelete()">Xoá phiếu</button>
                        <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                    </c:if>
                    <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        ${proposal.status == 'NEEDS_REVISION' ? 'Gửi duyệt lại' : 'Gửi duyệt'}
                    </button>
                </div>
            </form>

            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                <input type="hidden" name="id" value="${proposal.proposalId}" />
            </form>

            <template id="rowTemplate">
                <tr>
                    <td class="col-num"><span class="row-num"></span></td>
                    <td>
                        <div class="gen-cell-wrap">
                            <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                <option value="">-- Chọn máy --</option>
                                <c:forEach var="g" items="${generators}">
                                    <option value="${g.id}"><c:out value="${g.model}"/></option>
                                </c:forEach>
                            </select>
                            <c:if test="${canCreateGenerator}">
                                <button type="button" class="inline-add-btn" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới">+</button>
                            </c:if>
                        </div>
                    </td>
                    <td class="col-stock"><span class="row-stock mono">—</span></td>
                    <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" step="1" oninput="validateQty(this);updateTotal()" required /></td>
                    <td><input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this);updateTotal()" onfocus="unformatPrice(this)" onblur="formatPriceDisplay(this)" required /></td>
                    <td><input type="text" name="detailNote" class="row-note-input" placeholder="Ghi chú dòng" /></td>
                    <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                </tr>
            </template>
        </main>
    </div>
</div>

<div class="modal-host" id="genModalOverlay">
    <div class="modal">
        <div class="modal-head">
            <h3>Thêm máy phát mới</h3>
            <button type="button" class="modal-close" onclick="closeNewGeneratorModal()">&times;</button>
        </div>
        <p class="modal-sub">Máy phát sẽ được thêm ngay vào dropdown của dòng đang chọn.</p>
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
                <select class="input" id="ngBrandId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catBrands}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Xuất xứ</label>
                <select class="input" id="ngOriginId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catOrigins}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Tình trạng</label>
                <select class="input" id="ngConditionId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catConditions}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Nhiên liệu</label>
                <select class="input" id="ngFuelTypeId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catFuelTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Số pha</label>
                <select class="input" id="ngPhaseId"><option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catPhases}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div>
                <label class="field-label">Loại máy phát</label>
                <select class="input" id="ngGenTypeId"><option value="">-- Chọn --</option>
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
                <select class="input" id="nsTypeId"><option value="">-- Chọn --</option>
                    <c:forEach var="t" items="${supplierTypeList}"><option value="${t.id}"><c:out value="${t.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="span-2">
                <label class="field-label">Tên công ty</label>
                <input class="input" id="nsCompanyName" placeholder="VD: Công ty TNHH ABC" />
            </div>
            <div class="span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea class="input" id="nsAddress" rows="2" placeholder="Địa chỉ NCC"></textarea>
            </div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeNewSupplierModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="nsSaveBtn" onclick="saveNewSupplier()">Lưu NCC</button>
        </div>
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
<script>
function formatVND(num) {
    return new Intl.NumberFormat('vi-VN', {style:'currency', currency:'VND'}).format(num || 0);
}
function getStock(gid) { return STOCK_MAP[gid] || 0; }
function validateQty(input) {
    var v = (input.value || '').replace(/[^0-9]/g, '');
    var n = parseInt(v);
    if (isNaN(n) || n < 1) input.value = 1;
    else if (n > 9999) input.value = 9999;
    else input.value = n;
}
function validateUnitPrice(input) {
    var cleaned = input.value.replace(/[^\d]/g, '');
    if (input.value && cleaned === '') { alert('Đơn giá chỉ được nhập số!'); input.value = '0'; return; }
    input.value = cleaned;
}
function formatPriceDisplay(input) {
    var n = parseInt(input.value.replace(/[^\d]/g, '')) || 0;
    input.value = n > 0 ? n.toLocaleString('vi-VN') : '0';
}
function unformatPrice(input) {
    input.value = input.value.replace(/[^\d]/g, '') || '0';
}
function updateStockCell(sel) {
    var cell = sel.closest('tr').querySelector('.row-stock');
    if (!sel.value) { cell.textContent = '—'; cell.className = 'row-stock mono'; return; }
    var s = getStock(sel.value);
    cell.textContent = s + ' máy';
    cell.className = s === 0 ? 'row-stock mono zero-stock' : 'row-stock mono has-stock';
}
function updateTotal() {
    var rows = 0, qty = 0, total = 0;
    document.querySelectorAll('#detailBody tr').forEach(function (tr) {
        var sel = tr.querySelector('.gen-select');
        if (sel && sel.value) rows++;
        var q = parseInt(tr.querySelector('.qty-input').value) || 0;
        var p = parseInt((tr.querySelector('.unit-price-input').value || '').replace(/[^\d]/g, '')) || 0;
        qty += q;
        total += q * p;
    });
    document.getElementById('sumRows').textContent = rows;
    document.getElementById('sumQty').textContent = qty;
    document.getElementById('sumValue').textContent = formatVND(total);
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
    if (tbody.querySelectorAll('tr').length <= 1) { alert('Phải có ít nhất 1 dòng máy đề xuất.'); return; }
    btn.closest('tr').remove();
    updateRowNumbers();
    updateTotal();
}
function validateForm() {
    var sup = document.getElementById('supplierId');
    if (!sup.value) { alert('Vui lòng chọn nhà cung cấp.'); sup.focus(); return false; }
    var rows = document.querySelectorAll('#detailBody tr');
    var hasValid = false;
    for (var i = 0; i < rows.length; i++) {
        var sel = rows[i].querySelector('.gen-select');
        var qty = parseInt(rows[i].querySelector('.qty-input').value);
        var up = parseInt((rows[i].querySelector('.unit-price-input').value || '').replace(/[^\d]/g, ''));
        if (sel.value) {
            if (!qty || qty < 1) { alert('Số lượng ở dòng ' + (i + 1) + ' phải là số nguyên dương.'); return false; }
            if (!up || up <= 0) { alert('Đơn giá ở dòng ' + (i + 1) + ' phải lớn hơn 0.'); return false; }
            hasValid = true;
        }
    }
    if (!hasValid) { alert('Vui lòng chọn ít nhất 1 máy phát điện.'); return false; }
    document.querySelectorAll('.unit-price-input').forEach(function (el) {
        el.value = el.value.replace(/[^\d]/g, '');
    });
    return true;
}
function confirmDelete() {
    if (confirm('Xoá phiếu đề xuất này?')) document.getElementById('deleteForm').submit();
}

var _ngSel = null;
function openNewGeneratorModal(btn) {
    _ngSel = btn.closest('tr').querySelector('.gen-select');
    ['ngModel','ngPower','ngFreq','ngWeight','ngBrandId','ngOriginId','ngConditionId','ngFuelTypeId','ngPhaseId','ngGenTypeId']
        .forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
    var err = document.getElementById('genModalError'); err.classList.remove('show'); err.textContent = '';
    document.getElementById('genModalOverlay').classList.add('show');
}
function closeNewGeneratorModal() {
    document.getElementById('genModalOverlay').classList.remove('show'); _ngSel = null;
}
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
            var sel = _ngSel;
            var exists = false;
            for (var i = 0; i < sel.options.length; i++) { if (sel.options[i].value == data.id) { exists = true; break; } }
            if (!exists) { var opt = document.createElement('option'); opt.value = data.id; opt.text = data.model; sel.appendChild(opt); }
            sel.value = data.id;
            updateStockCell(sel);
            closeNewGeneratorModal();
            if (typeof toast !== 'undefined') toast(data.existing ? 'Mã "' + data.model + '" đã có — đã tự chọn.' : 'Đã thêm "' + data.model + '"', data.existing ? 'info' : 'success');
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
function closeNewSupplierModal() {
    document.getElementById('supModalOverlay').classList.remove('show');
}
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
            var sel = document.getElementById('supplierId');
            var exists = false;
            for (var i = 0; i < sel.options.length; i++) { if (sel.options[i].value == data.id) { exists = true; break; } }
            if (!exists) { var opt = document.createElement('option'); opt.value = data.id; opt.text = data.name; opt.setAttribute('data-phone', data.phone || ''); sel.appendChild(opt); }
            sel.value = data.id;
            closeNewSupplierModal();
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
    if (e.key === 'Escape') { closeNewGeneratorModal(); closeNewSupplierModal(); }
});
</script>
</body>
</html>