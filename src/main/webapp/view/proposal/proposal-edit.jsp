<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa đề xuất nhập kho — Warehouse OS</title>
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
            main{padding:24px 32px 200px;max-width:960px;margin:0 auto}
            .page-head{margin-bottom:20px}
            .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
            .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
            .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
            .page-head .lede{color:var(--muted);margin-top:6px;max-width:640px;font-size:14px}
            .section{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;margin-bottom:16px}
            .section-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 20px;border-bottom:1px solid var(--border)}
            .section-head-left{display:flex;align-items:baseline;gap:12px;min-width:0}
            .section-head h3{font-size:14px;font-weight:700;margin:0}
            .section-head .sub{font-size:11.5px;color:var(--muted);font-family:var(--font-mono)}
            .section-body{padding:22px 20px}
            .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px 20px}
            .info-field{display:flex;flex-direction:column;gap:6px;min-width:0}
            .info-field.full{grid-column:1/-1}
            .info-label{font-size:11.5px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:0.03em;display:flex;align-items:center;justify-content:space-between}
            .info-label .req{color:var(--danger);margin-inline-start:2px}
            .info-value{font-size:13.5px;padding:8px 12px;background:var(--surface-2);border:1px solid var(--border);border-radius:var(--radius-sm);color:var(--fg)}
            .info-input{font-family:var(--font-ui);font-size:13.5px;color:var(--fg);background:var(--bg);border:1px solid var(--border);border-radius:var(--radius-sm);padding:8px 12px;width:100%;line-height:1.4;box-sizing:border-box}
            .info-input:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .info-select{appearance:none;background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");background-repeat:no-repeat;background-position:right 10px center;background-size:14px;padding-inline-end:32px;cursor:pointer;font-family:var(--font-ui);font-size:13.5px;color:var(--fg);background-color:var(--bg);border:1px solid var(--border);border-radius:var(--radius-sm);padding:8px 12px;width:100%;line-height:1.4;box-sizing:border-box}
            .info-select:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            textarea.info-input{min-height:72px;resize:vertical}
            .table-scroll{overflow-x:auto;-webkit-overflow-scrolling:touch}
            table.data-table{width:100%;border-collapse:separate;border-spacing:0;font-size:13px}
            table.data-table thead th{text-align:left;font-size:11px;color:var(--muted);text-transform:uppercase;font-weight:700;background:var(--surface-2);padding:11px 14px;border-bottom:1px solid var(--border);letter-spacing:0.04em}
            table.data-table tbody td{padding:10px 14px;border-bottom:1px solid var(--border);vertical-align:middle}
            table.data-table tbody tr:last-child td{border-bottom:0}
            .text-right{text-align:right}
            .text-center{text-align:center}
            .col-num{width:36px;text-align:center}
            .col-qty{width:100px}
            .col-del{width:40px;text-align:center}
            .row-select{width:100%;padding:7px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box}
            .row-select:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .row-qty{width:80px;padding:7px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box;text-align:right}
            .row-qty:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .row-note{width:100%;padding:7px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box}
            .row-note:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .row-del-btn{width:28px;height:28px;border:none;background:none;color:var(--danger);cursor:pointer;border-radius:var(--radius-sm);font-size:18px;line-height:1;display:inline-flex;align-items:center;justify-content:center}
            .row-del-btn:hover{background:var(--danger-soft)}
            .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
            .btn:hover{background:var(--surface-2)}
            .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
            .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
            .btn-danger{color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
            .btn-danger:hover{background:var(--danger-soft)}
            .btn-sm{padding:5px 12px;font-size:12px}
            .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px;flex-wrap:wrap}
            .alert{padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:16px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;border:1px solid}
            .alert svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0}
            .alert-error{background:var(--danger-soft);color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
            .alert-success{background:var(--accent-soft);color:var(--accent);border-color:color-mix(in srgb,var(--accent) 30%,transparent)}
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
            .add-row-btn{margin-top:0}
            .status-badge{display:inline-flex;align-items:center;gap:5px;font-size:11.5px;font-weight:600;padding:2px 9px;border-radius:999px;border:1px solid}
            .status-badge.draft{color:var(--muted);border-color:var(--border);background:var(--surface-2)}
            .status-badge.revision{color:#7c3aed;border-color:color-mix(in srgb,#7c3aed 30%,transparent);background:color-mix(in srgb,#7c3aed 8%,transparent)}
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
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : 'alert-success'}">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>

                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Chỉnh sửa</div>
                        <h1 class="title">
                            Chỉnh sửa phiếu đề xuất
                            <c:choose>
                                <c:when test="${proposal.status == 'DRAFT'}"><span class="status-badge draft">Nháp</span></c:when>
                                <c:when test="${proposal.status == 'NEEDS_REVISION'}"><span class="status-badge revision">Cần chỉnh sửa</span></c:when>
                            </c:choose>
                        </h1>
                        <div class="lede">Phiếu <c:out value="${proposal.proposalCode}"/></div>
                    </div>

                    <form id="editForm" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm()">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />

                        <div class="section">
                            <div class="section-head">
                                <div class="section-head-left"><h3>Thông tin chung</h3></div>
                            </div>
                            <div class="section-body">
                                <div class="form-grid">
                                    <div class="info-field">
                                        <span class="info-label">Mã phiếu</span>
                                        <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <span class="info-label">Người tạo</span>
                                        <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <span class="info-label">Kho nhập <span class="req">*</span></span>
                                        <select class="info-select" id="warehouseId" name="warehouseId" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="info-field">
                                        <span class="info-label">Ngày tạo</span>
                                        <div class="info-value mono"><c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose></div>
                                    </div>
                                    <div class="info-field full">
                                        <span class="info-label" for="note">Ghi chú</span>
                                        <textarea class="info-input" id="note" name="note" rows="2" placeholder="Ghi chú cho phiếu..."><c:out value="${proposal.note}"/></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="section" style="padding:0">
                            <div class="section-head">
                                <div class="section-head-left"><h3>Danh sách máy phát</h3><span class="sub">${not empty proposal.details ? fn:length(proposal.details) : 0} dòng</span></div>
                                <div>
                                    <form id="uploadExcelForm" method="post" action="${pageContext.request.contextPath}/proposal?action=uploadEditExcel&id=${proposal.proposalId}" enctype="multipart/form-data" style="display:none">
                                        <input type="file" name="excelFile" id="excelUpload" accept=".xlsx,.xls" onchange="this.form.submit()" />
                                    </form>
                                    <button type="button" class="btn btn-sm" onclick="document.getElementById('excelUpload').click()">Tải Excel thay thế</button>
                                </div>
                            </div>
                            <div class="table-scroll">
                                <table class="data-table" style="min-width:1200px;">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th style="min-width:140px;">Máy phát <span class="req">*</span></th>
                                            <th>Hãng</th>
                                            <th>Xuất xứ</th>
                                            <th>Loại</th>
                                            <th style="width:80px;">C.suất</th>
                                            <th style="width:60px;">T.lượng</th>
                                            <th style="min-width:140px;">NCC</th>
                                            <th style="width:100px;" class="text-right">Đơn giá</th>
                                            <th style="width:80px;" class="text-right">SL <span class="req">*</span></th>
                                            <th style="min-width:120px;">Ghi chú dòng</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <c:choose>
                                            <c:when test="${not empty proposal.details}">
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr>
                                                        <td class="col-num mono">${st.index + 1}</td>
                                                        <td>
                                                            <select name="generatorId" class="row-select" required>
                                                                <option value="">-- Chọn máy --</option>
                                                                <c:forEach var="g" items="${generators}">
                                                                    <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>><c:out value="${g.model}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td class="gen-display"><c:out value="${d.brandName}"/></td>
                                                        <td class="gen-display"><c:out value="${d.originName}"/></td>
                                                        <td class="gen-display"><c:out value="${d.genTypeName}"/></td>
                                                        <td class="gen-display mono"><c:out value="${d.powerRating}"/></td>
                                                        <td class="gen-display mono"><c:out value="${d.weight}"/></td>
                                                        <td>
                                                            <select name="supplierId" class="row-supplier">
                                                                <option value="">-- Chọn NCC --</option>
                                                                <c:forEach var="s" items="${suppliers}">
                                                                    <option value="${s.id}" <c:if test="${s.id == d.supplierId}">selected</c:if>><c:out value="${s.name}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td><input type="number" name="unitPrice" class="row-price" value="${d.unitPrice != null ? d.unitPrice : ''}" min="1" step="1" /></td>
                                                        <td><input type="number" name="quantity" class="row-qty" value="${d.quantity}" min="1" max="9999" oninput="validateQty(this)" required /></td>
                                                        <td><input type="text" name="detailNote" class="row-note" value="<c:out value="${d.note}"/>" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                        <td class="col-del">
                                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td class="col-num mono">1</td>
                                                    <td>
                                                        <select name="generatorId" class="row-select" required>
                                                            <option value="">-- Chọn máy --</option>
                                                            <c:forEach var="g" items="${generators}">
                                                                <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td class="gen-display"></td>
                                                    <td class="gen-display"></td>
                                                    <td class="gen-display"></td>
                                                    <td class="gen-display"></td>
                                                    <td class="gen-display"></td>
                                                    <td>
                                                        <select name="supplierId" class="row-supplier">
                                                            <option value="">-- Chọn NCC --</option>
                                                            <c:forEach var="s" items="${suppliers}">
                                                                <option value="${s.id}"><c:out value="${s.name}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><input type="number" name="unitPrice" class="row-price" min="1" step="1" /></td>
                                                    <td><input type="number" name="quantity" class="row-qty" value="1" min="1" max="9999" oninput="validateQty(this)" required /></td>
                                                    <td><input type="text" name="detailNote" class="row-note" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                    <td class="col-del">
                                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div style="padding:12px 20px;border-top:1px solid var(--border)">
                                <button type="button" class="btn btn-sm add-row-btn" onclick="addRow()">
                                    <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm dòng
                                </button>
                            </div>
                        </div>

                        <div class="actions">
                            <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                            <c:if test="${proposal.status == 'DRAFT'}">
                                <button type="button" class="btn btn-danger" onclick="confirmDelete()">Xoá phiếu</button>
                                <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                            </c:if>
                            <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                                <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                ${proposal.status == 'NEEDS_REVISION' ? 'Gửi duyệt lại' : 'Gửi duyệt'}
                            </button>
                        </div>
                    </form>

                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                    </form>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <template id="rowTemplate">
            <tr>
                <td class="col-num mono"></td>
                <td>
                    <select name="generatorId" class="row-select" required>
                        <option value="">-- Chọn máy --</option>
                        <c:forEach var="g" items="${generators}">
                            <option value="${g.id}"><c:out value="${g.model}"/></option>
                        </c:forEach>
                    </select>
                </td>
                <td><input type="number" name="quantity" class="row-qty" value="1" min="1" max="9999" oninput="validateQty(this)" required /></td>
                <td><input type="text" name="detailNote" class="row-note" placeholder="VD: Cần gấp cho dự án X" /></td>
                <td class="col-del">
                    <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                </td>
            </tr>
        </template>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            function validateQty(input) {
                var v = input.value.replace(/[^0-9]/g, '');
                var n = parseInt(v);
                if (isNaN(n) || n < 1) input.value = 1;
                else if (n > 9999) input.value = 9999;
                else input.value = n;
            }
            function addRow() {
                var tpl = document.getElementById('rowTemplate');
                var clone = tpl.content.cloneNode(true);
                document.getElementById('detailBody').appendChild(clone);
                updateRowNumbers();
            }
            function removeRow(btn) {
                var tbody = document.getElementById('detailBody');
                if (tbody.querySelectorAll('tr').length <= 1) {
                    alert('Phải có ít nhất 1 dòng máy đề xuất.');
                    return;
                }
                btn.closest('tr').remove();
                updateRowNumbers();
            }
            function updateRowNumbers() {
                document.querySelectorAll('#detailBody tr').forEach(function (tr, i) {
                    var td = tr.querySelector('.col-num');
                    if (td) td.textContent = i + 1;
                });
            }
            function validateForm() {
                var rows = document.querySelectorAll('#detailBody tr');
                if (rows.length === 0) {
                    alert('Vui lòng thêm ít nhất 1 dòng máy đề xuất nhập.');
                    return false;
                }
                var hasValid = false;
                for (var i = 0; i < rows.length; i++) {
                    var sel = rows[i].querySelector('.row-select');
                    var qtyInput = rows[i].querySelector('.row-qty');
                    var qty = parseInt(qtyInput.value);
                    if (sel.value && (isNaN(qty) || qty < 1)) {
                        alert('Số lượng ở dòng ' + (i + 1) + ' phải là số nguyên dương.');
                        qtyInput.focus();
                        return false;
                    }
                    if (sel.value) hasValid = true;
                }
                if (!hasValid) {
                    alert('Vui lòng chọn ít nhất 1 máy phát điện.');
                    return false;
                }
                return true;
            }
            function confirmDelete() {
                if (confirm('Bạn có chắc chắn muốn XOÁ phiếu nháp "<c:out value="${proposal.proposalCode}"/>"?\n\nHành động này không thể hoàn tác.')) {
                    document.getElementById('deleteForm').submit();
                }
            }
        </script>
    </body>
</html>
