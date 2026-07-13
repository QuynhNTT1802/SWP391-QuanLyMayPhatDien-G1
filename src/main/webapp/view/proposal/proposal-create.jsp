<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đề xuất nhập kho - Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        h1,h2,h3,h4{font-weight:700;letter-spacing:-0.01em}
        label,.label{font-weight:600}
        input,select,textarea,button{font-weight:500}
        .mono{font-family:var(--font-mono);font-variant-numeric:tabular-nums}
        main{padding:24px 32px 60px;max-width:1100px;margin:0 auto}
        .page-head{margin-bottom:20px}
        .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
        .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
        .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
        .page-head .lede{color:var(--muted);margin-top:6px;max-width:720px;font-size:14px}
        .section{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;margin-bottom:16px}
        .section-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border)}
        .section-head h3{font-size:14px;font-weight:700;margin:0}
        .section-head .sub{font-size:11.5px;color:var(--muted);font-family:var(--font-mono)}
        .section-body{padding:22px 20px}
        .field-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px 20px}
        .field{display:flex;flex-direction:column;gap:6px;min-width:0}
        .field.full{grid-column:1/-1}
        .field-label{font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em}
        .field-label .req{color:var(--danger);margin-inline-start:2px}
        .input,.select{font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;line-height:1.4;box-sizing:border-box}
        .input:focus,.select:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
        .select{appearance:none;background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");background-repeat:no-repeat;background-position:right 10px center;background-size:14px;padding-inline-end:32px;cursor:pointer}
        textarea.input{min-height:64px;resize:vertical}
        .table-scroll{overflow-x:auto;-webkit-overflow-scrolling:touch}
        table.data-table{width:100%;border-collapse:separate;border-spacing:0;font-size:13px}
        table.data-table thead th{text-align:left;font-size:11px;color:var(--muted);text-transform:uppercase;font-weight:700;background:var(--surface-2);padding:11px 14px;border-bottom:1px solid var(--border);letter-spacing:0.04em}
        table.data-table tbody td{padding:10px 14px;border-bottom:1px solid var(--border);vertical-align:middle}
        table.data-table tbody tr:last-child td{border-bottom:0}
        .col-min{white-space:nowrap;width:1%}
        .col-stock{white-space:nowrap;width:90px;text-align:center}
        .col-qty{white-space:nowrap;width:90px}
        .col-price{white-space:nowrap;width:160px}
        .col-del{white-space:nowrap;width:40px;text-align:center}
        .row-generator{width:100%;padding:6px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box}
        .row-qty,.row-unitprice{width:80px;padding:6px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box;text-align:right}
        .row-unitprice{width:140px}
        .stock-cell{display:inline-block;min-width:48px;padding:4px 8px;border-radius:var(--radius-sm);font-family:var(--font-mono);font-size:12.5px;font-weight:600;text-align:center;background:var(--surface-2);border:1px solid var(--border);color:var(--muted)}
        .stock-cell.has-stock{background:var(--accent-soft);color:var(--accent);border-color:color-mix(in srgb,var(--accent) 25%,transparent)}
        .stock-cell.zero-stock{background:var(--warn-soft);color:var(--warn);border-color:color-mix(in srgb,var(--warn) 25%,transparent)}
        .gen-sub{font-size:11.5px;color:var(--muted);margin-top:4px;line-height:1.3}
        .row-del-btn{width:28px;height:28px;border:none;background:none;color:var(--danger);cursor:pointer;border-radius:var(--radius-sm);font-size:18px;line-height:1;display:inline-flex;align-items:center;justify-content:center}
        .row-del-btn:hover{background:var(--danger-soft)}
        .row-del-btn:disabled{opacity:.3;cursor:not-allowed}
        .inline-add-btn{display:inline-flex;align-items:center;gap:4px;padding:4px 10px;font-size:12px;font-weight:600;color:var(--accent);background:var(--accent-soft);border:1px solid color-mix(in srgb,var(--accent) 30%,transparent);border-radius:999px;cursor:pointer;white-space:nowrap}
        .inline-add-btn:hover{background:color-mix(in srgb,var(--accent) 20%,transparent)}
        .inline-add-btn svg{width:12px;height:12px;stroke:currentColor;fill:none;stroke-width:2.4}
        .gen-cell-wrap{display:flex;align-items:center;gap:6px;min-width:240px}
        .gen-cell-wrap .row-generator{flex:1;min-width:0}
        .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
        .btn:hover{background:var(--surface-2)}
        .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
        .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
        .btn-sm{padding:5px 12px;font-size:12px}
        .btn-ghost{background:transparent}
        .btn:disabled{opacity:.4;cursor:not-allowed}
        .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:22px;flex-wrap:wrap}
        .alert{padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:16px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;border:1px solid}
        .alert svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0}
        .alert-warn{background:var(--warn-soft);color:var(--warn);border-color:color-mix(in srgb,var(--warn) 30%,transparent)}
        .alert-error{background:var(--danger-soft);color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
        .topbar{position:sticky;top:0;z-index:10;background:color-mix(in srgb,var(--bg) 85%,transparent);backdrop-filter:blur(8px);border-bottom:1px solid var(--border);display:flex;align-items:center;gap:16px;padding:12px 24px}
        .topbar h1{font-size:16px;font-weight:700;margin:0;letter-spacing:-0.01em}
        .crumb{color:var(--muted);font-size:13px;font-weight:500}
        .top-actions{margin-inline-start:auto;display:flex;align-items:center;gap:8px}
        .icon-btn{width:32px;height:32px;border:1px solid var(--border);background:var(--surface);color:var(--fg-soft);border-radius:var(--radius-sm);display:grid;place-items:center;cursor:pointer}
        .icon-btn:hover{background:var(--surface-2);color:var(--fg)}
        .icon-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.6}
        .back-link{display:inline-flex;align-items:center;gap:6px;color:var(--muted);text-decoration:none;font-size:13px;font-weight:600;margin-bottom:14px}
        .back-link:hover{color:var(--fg)}
        .back-link svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8}
        .summary-row{display:flex;gap:10px;flex-wrap:wrap;padding:12px 20px;border-top:1px solid var(--border);background:var(--surface-2);font-size:13px;color:var(--fg);align-items:center}
        .summary-row .sep{color:var(--border)}
        .modal-host{position:fixed;inset:0;background:rgba(15,23,42,.45);display:none;align-items:center;justify-content:center;z-index:1000;padding:20px}
        .modal-host.show{display:flex}
        .modal{background:var(--surface);border:1px solid var(--border);border-radius:12px;width:100%;max-width:680px;max-height:90vh;overflow:auto;padding:24px;box-shadow:0 20px 50px rgba(0,0,0,.18)}
        .modal-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:6px}
        .modal-head h3{margin:0;font-size:18px;font-weight:700}
        .modal-close{background:0 0;border:0;color:var(--muted);cursor:pointer;font-size:24px;line-height:1;padding:4px 8px;border-radius:var(--radius-sm)}
        .modal-close:hover{background:var(--surface-2);color:var(--fg)}
        .modal-sub{font-size:13px;color:var(--muted);margin:0 0 14px}
        .modal-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px 16px}
        .modal-grid .field.span-2{grid-column:1/-1}
        .modal-error{padding:10px 14px;border-radius:var(--radius-sm);background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 25%,transparent);font-size:13px;font-weight:600;margin-bottom:12px;display:none}
        .modal-error.show{display:block}
        .modal-actions{display:flex;justify-content:flex-end;gap:8px;margin-top:18px;padding-top:14px;border-top:1px solid var(--border)}
        .field.invalid .input,.field.invalid .select{border-color:var(--danger);box-shadow:0 0 0 3px var(--danger-soft)}
        .field-error{display:none;font-size:11.5px;color:var(--danger);font-weight:600;margin-top:4px}
        .field.invalid .field-error{display:block}
        .supplier-card{padding:12px 14px;border-radius:var(--radius-sm);background:var(--surface-2);border:1px solid var(--border);margin-top:6px;font-size:12.5px;color:var(--muted);display:none}
        .supplier-card.show{display:block}
        .supplier-card strong{color:var(--fg)}
        .table-toolbar{display:flex;align-items:center;gap:10px;padding:12px 20px;background:var(--surface);border-bottom:1px solid var(--border);flex-wrap:wrap}
        .table-toolbar .spacer{flex:1}
        .pill{display:inline-flex;align-items:center;gap:6px;font-size:12px;font-weight:600;padding:3px 10px;border-radius:999px;border:1px solid var(--border);background:var(--surface-2);color:var(--muted)}
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tạo đề xuất</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / Tạo mới</span>
            <div class="top-actions">
                <a class="btn btn-sm btn-ghost" href="${pageContext.request.contextPath}/proposal?action=importExcel" title="Import nhiều dòng từ file Excel">
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
            <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <c:if test="${not empty sessionScope.toastMessage}">
                <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : 'alert-warn'}">
                    <span><c:out value="${sessionScope.toastMessage}"/></span>
                </div>
                <c:remove var="toastMessage" scope="session"/>
                <c:remove var="toastType" scope="session"/>
            </c:if>

            <div class="page-head">
                <div class="eyebrow">Đề xuất nhập kho · Tạo mới</div>
                <h1 class="title">Tạo phiếu đề xuất nhập</h1>
                <div class="lede">Chọn kho và nhà cung cấp, sau đó thêm từng dòng máy cần đề xuất. Nếu máy chưa có trong hệ thống, dùng nút <strong>⊕</strong> để tạo nhanh.</div>
            </div>

            <form id="proposalForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=save" onsubmit="return validateForm()">
                <div class="section">
                    <div class="section-head">
                        <h3>Thông tin chung</h3>
                        <span class="sub">Bước 1</span>
                    </div>
                    <div class="section-body">
                        <div class="field-grid">
                            <div class="field">
                                <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                                <select class="select" id="warehouseId" name="warehouseId" required>
                                    <option value="">-- Chọn kho --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}"><c:out value="${w.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="field">
                                <label class="field-label" for="supplierId">
                                    Nhà cung cấp <span class="req">*</span>
                                    <span style="font-weight:500;color:var(--muted-2);text-transform:none;letter-spacing:0">(áp dụng cho cả phiếu)</span>
                                </label>
                                <div style="display:flex;gap:8px;align-items:center">
                                    <select class="select" id="supplierId" name="supplierId" required style="flex:1">
                                        <option value="">-- Chọn nhà cung cấp --</option>
                                        <c:forEach var="s" items="${suppliers}">
                                            <option value="${s.id}" data-phone="${s.phone}" data-email="${s.email}" data-company="${s.companyName}">
                                                <c:out value="${s.name}"/> <c:if test="${not empty s.phone}">- <c:out value="${s.phone}"/></c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${canCreateSupplier}">
                                        <button type="button" class="inline-add-btn" onclick="openNewSupplierModal()" title="Thêm nhà cung cấp mới">
                                            <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                            Thêm NCC
                                        </button>
                                    </c:if>
                                </div>
                                <div class="supplier-card" id="supplierInfoCard"></div>
                            </div>
                            <div class="field full">
                                <label class="field-label" for="note">Ghi chú</label>
                                <textarea class="input" id="note" name="note" rows="2" placeholder="VD: Đề xuất nhập máy phát cho kho HCM..."></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-head">
                        <div>
                            <h3>Danh sách máy phát</h3>
                            <span class="sub" style="margin-left:8px">Bước 2 · NCC đã chọn áp dụng cho tất cả dòng</span>
                        </div>
                        <button type="button" class="btn btn-sm" onclick="addRow()">
                            <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </div>
                    <div class="table-scroll">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th class="col-min">#</th>
                                    <th>Mẫu máy <span class="req">*</span></th>
                                    <th class="col-stock">Tồn kho</th>
                                    <th class="col-qty text-right">Số lượng <span class="req">*</span></th>
                                    <th class="col-price text-right">Đơn giá (VNĐ) <span class="req">*</span></th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <tr>
                                    <td class="mono">1</td>
                                    <td>
                                        <div class="gen-cell-wrap">
                                            <select name="generatorId" class="row-generator" required onchange="onGenChange(this)">
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                </c:forEach>
                                            </select>
                                            <c:if test="${canCreateGenerator}">
                                                <button type="button" class="inline-add-btn" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới">
                                                    <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                                </button>
                                            </c:if>
                                        </div>
                                        <div class="gen-sub"></div>
                                    </td>
                                    <td class="text-center"><span class="stock-cell" data-stock>—</span></td>
                                    <td><input type="number" name="quantity" class="row-qty mono" value="1" min="1" max="9999" oninput="validateQty(this);recalcSummary()" required /></td>
                                    <td><input type="number" name="unitPrice" class="row-unitprice mono" min="0" step="1000" placeholder="0" oninput="recalcSummary()" required /></td>
                                    <td><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="summary-row">
                        <span class="pill"><strong id="sumRows">1</strong> dòng</span>
                        <span class="sep">·</span>
                        <span class="pill"><strong id="sumQty">0</strong> tổng SL</span>
                        <span class="sep">·</span>
                        <span class="pill"><strong id="sumValue">0</strong> ₫</span>
                        <span class="spacer" style="flex:1"></span>
                        <span style="font-size:12px;color:var(--muted)" id="supplierHint">Chưa chọn NCC.</span>
                    </div>
                </div>

                <div class="actions">
                    <a class="btn" href="${pageContext.request.contextPath}/proposal">Huỷ</a>
                    <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                    <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                        <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                        Gửi duyệt
                    </button>
                </div>
            </form>
        </main>
    </div>
</div>

<div class="modal-host" id="genModalOverlay">
    <div class="modal">
        <div class="modal-head">
            <h3>Thêm máy phát mới</h3>
            <button type="button" class="modal-close" onclick="closeNewGeneratorModal()" title="Đóng">×</button>
        </div>
        <p class="modal-sub">Máy phát sẽ được thêm ngay vào dropdown của dòng đang chọn.</p>
        <div class="modal-error" id="genModalError"></div>
        <div class="modal-grid">
            <div class="field">
                <label class="field-label">Mã máy phát (model) <span class="req">*</span></label>
                <input type="text" id="ngModel" class="input" placeholder="VD: Honda EU22i" autocomplete="off" />
                <span class="field-error">Vui lòng nhập mã máy phát.</span>
            </div>
            <div class="field">
                <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                <input type="number" id="ngPower" class="input mono" step="0.01" placeholder="VD: 50" />
                <span class="field-error">Vui lòng nhập công suất.</span>
            </div>
            <div class="field">
                <label class="field-label">Tần số (Hz)</label>
                <input type="text" id="ngFreq" class="input mono" placeholder="VD: 50" />
            </div>
            <div class="field">
                <label class="field-label">Trọng lượng (kg)</label>
                <input type="number" id="ngWeight" class="input mono" step="0.01" placeholder="VD: 120" />
            </div>
            <div class="field">
                <label class="field-label">Thương hiệu</label>
                <select id="ngBrandId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catBrands}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Xuất xứ</label>
                <select id="ngOriginId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catOrigins}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Tình trạng</label>
                <select id="ngConditionId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catConditions}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Nhiên liệu</label>
                <select id="ngFuelTypeId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catFuelTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Số pha</label>
                <select id="ngPhaseId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="b" items="${catPhases}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Loại máy phát</label>
                <select id="ngGenTypeId" class="select">
                    <option value="">-- Chọn --</option>
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
            <button type="button" class="modal-close" onclick="closeNewSupplierModal()" title="Đóng">×</button>
        </div>
        <p class="modal-sub">Nhà cung cấp sẽ được áp dụng cho toàn bộ phiếu đề xuất.</p>
        <div class="modal-error" id="supModalError"></div>
        <div class="modal-grid">
            <div class="field">
                <label class="field-label">Tên nhà cung cấp <span class="req">*</span></label>
                <input type="text" id="nsName" class="input" placeholder="VD: Nguyễn Văn B" autocomplete="off" />
                <span class="field-error">Vui lòng nhập tên.</span>
            </div>
            <div class="field">
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input type="tel" id="nsPhone" class="input mono" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" autocomplete="off" />
                <span class="field-error">SĐT phải gồm 10-11 chữ số.</span>
            </div>
            <div class="field">
                <label class="field-label">Email</label>
                <input type="email" id="nsEmail" class="input mono" placeholder="email@example.com" autocomplete="off" />
            </div>
            <div class="field">
                <label class="field-label">Loại NCC</label>
                <select id="nsTypeId" class="select">
                    <option value="">-- Chọn --</option>
                    <c:forEach var="t" items="${supplierTypeList}"><option value="${t.id}"><c:out value="${t.name}"/></option></c:forEach>
                </select>
            </div>
            <div class="field span-2">
                <label class="field-label">Tên công ty</label>
                <input type="text" id="nsCompanyName" class="input" placeholder="VD: Công ty TNHH ABC" autocomplete="off" />
            </div>
            <div class="field span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea id="nsAddress" class="input" rows="2" placeholder="VD: Số 1, đường ABC, Quận 1, TP.HCM"></textarea>
            </div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeNewSupplierModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="nsSaveBtn" onclick="saveNewSupplier()">Lưu NCC</button>
        </div>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>

<script>
window.APP_CTX = '${pageContext.request.contextPath}';
var STOCK_MAP = {};
<c:forEach var="entry" items="${stockByGen}">
STOCK_MAP['${entry.key}'] = ${entry.value};
</c:forEach>
</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script>
(function () {
    function formatMoney(n) {
        if (!isFinite(n) || isNaN(n)) return '0';
        return Math.round(n).toLocaleString('vi-VN');
    }

    function getRowSelect(tr) { return tr.querySelector('.row-generator'); }
    function getRowStock(tr) { return tr.querySelector('[data-stock]'); }
    function getRowSub(tr) { return tr.querySelector('.gen-sub'); }

    window.onGenChange = function (sel) {
        var tr = sel.closest('tr');
        var stockCell = getRowStock(tr);
        if (!sel.value) {
            stockCell.textContent = '—';
            stockCell.className = 'stock-cell';
            var sub = getRowSub(tr);
            if (sub) sub.textContent = '';
            return;
        }
        var stock = STOCK_MAP[sel.value];
        if (stock == null) {
            stockCell.textContent = '0';
            stockCell.className = 'stock-cell zero-stock';
        } else if (stock === 0) {
            stockCell.textContent = '0';
            stockCell.className = 'stock-cell zero-stock';
            stockCell.title = 'Hiện hết hàng trong kho này. Vẫn có thể đề xuất nhập.';
        } else {
            stockCell.textContent = stock + ' máy';
            stockCell.className = 'stock-cell has-stock';
            stockCell.title = 'Tồn kho tại kho đã chọn';
        }
    };

    window.validateQty = function (input) {
        var v = (input.value || '').replace(/[^0-9]/g, '');
        var n = parseInt(v);
        if (isNaN(n) || n < 1) input.value = 1;
        else if (n > 9999) input.value = 9999;
        else input.value = n;
    };

    window.addRow = function () {
        var tbody = document.getElementById('detailBody');
        var tpl = document.getElementById('rowTemplate');
        var clone = tpl.content.cloneNode(true);
        tbody.appendChild(clone);
        updateRowNumbers();
        recalcSummary();
    };

    window.removeRow = function (btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) {
            alert('Phải có ít nhất 1 dòng máy đề xuất.');
            return;
        }
        btn.closest('tr').remove();
        updateRowNumbers();
        recalcSummary();
    };

    window.updateRowNumbers = function () {
        var trs = document.querySelectorAll('#detailBody tr');
        trs.forEach(function (tr, i) {
            var td = tr.querySelector('td.mono');
            if (td) td.textContent = i + 1;
        });
    };

    window.recalcSummary = function () {
        var trs = document.querySelectorAll('#detailBody tr');
        var rows = 0, qty = 0, total = 0;
        trs.forEach(function (tr) {
            var sel = getRowSelect(tr);
            if (sel && sel.value) rows++;
            var q = parseInt(tr.querySelector('.row-qty').value) || 0;
            var p = parseFloat((tr.querySelector('.row-unitprice').value || '').toString().replace(/[^0-9.]/g, '')) || 0;
            qty += q;
            total += q * p;
        });
        document.getElementById('sumRows').textContent = rows;
        document.getElementById('sumQty').textContent = qty;
        document.getElementById('sumValue').textContent = formatMoney(total);
    };

    window.updateSupplierInfo = function () {
        var sel = document.getElementById('supplierId');
        var opt = sel.options[sel.selectedIndex];
        var card = document.getElementById('supplierInfoCard');
        var hint = document.getElementById('supplierHint');
        if (!sel.value) {
            card.classList.remove('show');
            hint.textContent = 'Chưa chọn NCC.';
            return;
        }
        var phone = opt.getAttribute('data-phone') || '';
        var email = opt.getAttribute('data-email') || '';
        var company = opt.getAttribute('data-company') || '';
        var html = '<strong>' + opt.textContent + '</strong>';
        if (phone) html += ' &nbsp;·&nbsp; 📞 ' + phone;
        if (email) html += ' &nbsp;·&nbsp; ✉ ' + email;
        if (company) html += ' &nbsp;·&nbsp; 🏢 ' + company;
        card.innerHTML = html;
        card.classList.add('show');
        var rowCount = document.querySelectorAll('#detailBody tr').length;
        hint.textContent = 'NCC "' + opt.textContent + '" sẽ áp dụng cho ' + rowCount + ' dòng máy.';
    };

    window.validateForm = function () {
        var wh = document.getElementById('warehouseId').value;
        var sup = document.getElementById('supplierId').value;
        if (!wh) { alert('Vui lòng chọn kho nhập.'); return false; }
        if (!sup) { alert('Vui lòng chọn nhà cung cấp.'); return false; }
        var trs = document.querySelectorAll('#detailBody tr');
        var hasValid = false;
        for (var i = 0; i < trs.length; i++) {
            var tr = trs[i];
            var sel = getRowSelect(tr);
            var qty = parseInt(tr.querySelector('.row-qty').value);
            var upStr = (tr.querySelector('.row-unitprice').value || '').replace(/[^0-9.]/g, '');
            if (sel && sel.value) {
                if (!qty || qty < 1) {
                    alert('Số lượng ở dòng ' + (i + 1) + ' phải là số nguyên dương.');
                    tr.querySelector('.row-qty').focus();
                    return false;
                }
                if (!upStr || parseFloat(upStr) <= 0) {
                    alert('Đơn giá ở dòng ' + (i + 1) + ' phải lớn hơn 0.');
                    tr.querySelector('.row-unitprice').focus();
                    return false;
                }
                hasValid = true;
            }
        }
        if (!hasValid) {
            alert('Vui lòng chọn ít nhất 1 máy phát điện.');
            return false;
        }
        return true;
    };

    document.getElementById('supplierId').addEventListener('change', updateSupplierInfo);

    updateSupplierInfo();
    recalcSummary();

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeNewGeneratorModal();
            closeNewSupplierModal();
        }
    });
})();

var _ngCurrentSelect = null;
window.openNewGeneratorModal = function (btn) {
    var tr = btn.closest('tr');
    _ngCurrentSelect = tr ? tr.querySelector('.row-generator') : null;
    ['ngModel','ngPower','ngFreq','ngWeight','ngBrandId','ngOriginId','ngConditionId','ngFuelTypeId','ngPhaseId','ngGenTypeId']
        .forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.value = '';
        });
    document.querySelectorAll('#genModalOverlay .field').forEach(function (f) { f.classList.remove('invalid'); });
    var err = document.getElementById('genModalError');
    err.classList.remove('show'); err.textContent = '';
    document.getElementById('genModalOverlay').classList.add('show');
    setTimeout(function () { document.getElementById('ngModel').focus(); }, 30);
};
window.closeNewGeneratorModal = function () {
    document.getElementById('genModalOverlay').classList.remove('show');
    _ngCurrentSelect = null;
};
window.saveNewGenerator = function () {
    document.querySelectorAll('#genModalOverlay .field').forEach(function (f) { f.classList.remove('invalid'); });
    document.getElementById('genModalError').classList.remove('show');
    var model = document.getElementById('ngModel').value.trim();
    var power = document.getElementById('ngPower').value.trim();
    if (!model) { markInvalid('ngModel'); return; }
    if (!power) { markInvalid('ngPower'); return; }
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
    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false; btn.textContent = 'Lưu máy phát';
            if (data.ok) {
                applyNewGenerator(data);
                closeNewGeneratorModal();
                if (data.existing && typeof toast !== 'undefined') {
                    toast('Mã máy "' + data.model + '" đã có trong hệ thống — đã tự chọn.', 'info');
                } else if (typeof toast !== 'undefined') {
                    toast('Đã thêm máy phát "' + data.model + '"', 'success');
                }
            } else {
                showGenError(data.error || 'Lỗi không xác định');
            }
        }).catch(function () {
            btn.disabled = false; btn.textContent = 'Lưu máy phát';
            showGenError('Lỗi kết nối máy chủ');
        });
};
function markInvalid(id) {
    var el = document.getElementById(id);
    if (el) {
        var f = el.closest('.field');
        if (f) f.classList.add('invalid');
    }
}
function showGenError(msg) {
    var e = document.getElementById('genModalError');
    e.textContent = msg; e.classList.add('show');
}
window.applyNewGenerator = function (data) {
    var sel = _ngCurrentSelect;
    if (!sel) {
        var firstSel = document.querySelector('#detailBody tr .row-generator');
        sel = firstSel;
    }
    if (!sel) return;
    var exists = false;
    for (var i = 0; i < sel.options.length; i++) {
        if (sel.options[i].value == data.id) { exists = true; break; }
    }
    if (!exists) {
        var opt = document.createElement('option');
        opt.value = data.id;
        opt.text = data.model;
        sel.appendChild(opt);
    }
    sel.value = data.id;
    onGenChange(sel);
};

window.openNewSupplierModal = function () {
    ['nsName','nsPhone','nsEmail','nsCompanyName','nsAddress','nsTypeId'].forEach(function (id) {
        var el = document.getElementById(id); if (el) el.value = '';
    });
    document.querySelectorAll('#supModalOverlay .field').forEach(function (f) { f.classList.remove('invalid'); });
    var err = document.getElementById('supModalError');
    err.classList.remove('show'); err.textContent = '';
    document.getElementById('supModalOverlay').classList.add('show');
    setTimeout(function () { document.getElementById('nsName').focus(); }, 30);
};
window.closeNewSupplierModal = function () {
    document.getElementById('supModalOverlay').classList.remove('show');
};
window.saveNewSupplier = function () {
    document.querySelectorAll('#supModalOverlay .field').forEach(function (f) { f.classList.remove('invalid'); });
    document.getElementById('supModalError').classList.remove('show');
    var name = document.getElementById('nsName').value.trim();
    var phone = document.getElementById('nsPhone').value.trim();
    var phoneRe = /^[0-9]{10,11}$/;
    if (!name) { markInvalid('nsName'); return; }
    if (!phoneRe.test(phone)) { markInvalid('nsPhone'); return; }
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
    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            btn.disabled = false; btn.textContent = 'Lưu NCC';
            if (data.ok) {
                applyNewSupplier(data);
                closeNewSupplierModal();
                if (data.existing && typeof toast !== 'undefined') {
                    toast('SĐT này đã có NCC: ' + data.name + ' — đã tự chọn.', 'info');
                } else if (typeof toast !== 'undefined') {
                    toast('Đã thêm NCC "' + data.name + '"', 'success');
                }
            } else {
                showSupError(data.error || 'Lỗi không xác định');
            }
        }).catch(function () {
            btn.disabled = false; btn.textContent = 'Lưu NCC';
            showSupError('Lỗi kết nối máy chủ');
        });
};
function showSupError(msg) {
    var e = document.getElementById('supModalError');
    e.textContent = msg; e.classList.add('show');
}
window.applyNewSupplier = function (data) {
    var sel = document.getElementById('supplierId');
    var exists = false;
    for (var i = 0; i < sel.options.length; i++) {
        if (sel.options[i].value == data.id) { exists = true; break; }
    }
    var label = data.name + (data.phone ? ' - ' + data.phone : '');
    if (!exists) {
        var opt = document.createElement('option');
        opt.value = data.id;
        opt.text = label;
        opt.setAttribute('data-phone', data.phone || '');
        opt.setAttribute('data-email', '');
        opt.setAttribute('data-company', '');
        sel.appendChild(opt);
    }
    sel.value = data.id;
    updateSupplierInfo();
};
</script>
<template id="rowTemplate">
    <tr>
        <td class="mono"></td>
        <td>
            <div class="gen-cell-wrap">
                <select name="generatorId" class="row-generator" required onchange="onGenChange(this)">
                    <option value="">-- Chọn máy --</option>
                    <c:forEach var="g" items="${generators}">
                        <option value="${g.id}"><c:out value="${g.model}"/></option>
                    </c:forEach>
                </select>
                <c:if test="${canCreateGenerator}">
                    <button type="button" class="inline-add-btn" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới">
                        <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                    </button>
                </c:if>
            </div>
            <div class="gen-sub"></div>
        </td>
        <td class="text-center"><span class="stock-cell" data-stock>—</span></td>
        <td><input type="number" name="quantity" class="row-qty mono" value="1" min="1" max="9999" oninput="validateQty(this);recalcSummary()" required /></td>
        <td><input type="number" name="unitPrice" class="row-unitprice mono" min="0" step="1000" placeholder="0" oninput="recalcSummary()" required /></td>
        <td><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
    </tr>
</template>
</body>
</html>