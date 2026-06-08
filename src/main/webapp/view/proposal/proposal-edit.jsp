<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            .table-card { overflow-x: auto; -webkit-overflow-scrolling: touch; }
            .order-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--muted); }
            .detail-table { width: 100%; border-collapse: collapse; margin-top: 8px; }
            .detail-table th { text-align: left; padding: 8px 10px; font-size: 12px; font-weight: 600; color: var(--muted); border-bottom: 1px solid var(--border); text-transform: uppercase; letter-spacing: 0.5px; }
            .detail-table td { padding: 8px 6px; vertical-align: top; }
            .detail-table select, .detail-table input { width: 100%; padding: 7px 8px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; box-sizing: border-box; }
            .col-num { width: 36px; text-align: center; color: var(--muted); font-weight: 600; padding-top: 14px; }
            .col-qty { width: 110px; }
            .col-stock { width: 90px; text-align: center; padding-top: 14px !important; color: var(--muted); font-size: 13px; }
            .col-del { width: 40px; text-align: center; }
            .row-del-btn { width: 28px; height: 28px; border: none; background: none; color: var(--danger); cursor: pointer; border-radius: var(--radius-sm); margin-top: 4px; }
            .row-del-btn:hover { background: var(--danger-soft); }
            .add-row-btn { margin-top: 8px; font-size: 13px; }
            .form-section { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 18px 20px; margin-bottom: 18px; }
            .form-section-head { display: flex; align-items: baseline; gap: 10px; margin-bottom: 14px; }
            .form-section-num { font-size: 11px; font-weight: 700; color: var(--accent); letter-spacing: 0.08em; }
            .form-section-title { font-size: 16px; font-weight: 700; margin: 0; }
            .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px 20px; }
            .field { display: flex; flex-direction: column; gap: 6px; }
            .field-label { font-size: 12.5px; font-weight: 600; color: var(--muted); }
            .input { padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13.5px; font-family: inherit; }
            .input:focus { outline: none; border-color: var(--accent); }
            textarea.input { min-height: 80px; resize: vertical; }
            .req { color: #dc3545; }
            .readonly-box { padding: 9px 12px; background: var(--surface-2); border-radius: var(--radius-sm); font-size: 13.5px; color: var(--fg); }
            .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; background: #e2e3e5; color: #383d41; }
            .status-pill .pdot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; opacity: 0.55; }
            .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 13px; margin-bottom: 12px; }
            .back-link:hover { color: var(--accent); }
            .btn-danger { background: #dc3545; color: #fff; border: 1px solid #dc3545; }
            .btn-danger:hover { background: #c82333; border-color: #bd2130; }
            .footer-actions { display: flex; gap: 10px; justify-content: space-between; align-items: center; flex-wrap: wrap; }
            .footer-actions .right { display: flex; gap: 10px; }
            .alert-warn { padding: 12px 16px; border-radius: 8px; background: #fff3cd; color: #856404; border: 1px solid #ffe69c; display: flex; gap: 10px; align-items: flex-start; }
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
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Chỉnh sửa đề xuất nhập</div>
                            <h2 class="page-title">Chỉnh sửa phiếu đề xuất nhập kho</h2>
                            <div class="page-sub">
                                Phiếu <c:out value="${proposal.proposalCode}"/> ·
                                <span class="status-pill" style="margin-left:6px;"><span class="pdot"></span>Nháp</span>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert-warn" style="background:${sessionScope.toastType == 'danger' ? '#f8d7da' : '#d4edda'};color:${sessionScope.toastType == 'danger' ? '#721c24' : '#155724'};border-color:${sessionScope.toastType == 'danger' ? '#f5c6cb' : '#c3e6cb'};">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div><c:out value="${sessionScope.toastMessage}"/></div>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>

                    <form class="form-card" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm();">

                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="form-section-title">Kho nhập & ghi chú</h3>
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Mã phiếu</label>
                                    <div class="readonly-box order-code"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="field">
                                    <label class="field-label">Người tạo</label>
                                    <div class="readonly-box"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="field">
                                    <label class="field-label">Kho nhập <span class="req">*</span></label>
                                    <select class="input" name="warehouseId" required>
                                        <option value="">-- Chọn kho --</option>
                                        <c:forEach var="w" items="${warehouses}">
                                            <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>>
                                                <c:out value="${w.name}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="field">
                                    <label class="field-label">Ngày tạo</label>
                                    <div class="readonly-box">
                                        <c:choose>
                                            <c:when test="${proposal.proposalDate == null}">—</c:when>
                                            <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="field" style="grid-column: span 2;">
                                    <label class="field-label">Ghi chú</label>
                                    <textarea class="input" name="note" rows="3" placeholder="VD: Đề xuất nhập máy phát 100kW cho kho HCM..."><c:out value="${proposal.note}"/></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — MÁY PHÁT ĐIỆN ĐỀ XUẤT NHẬP</div>
                                <h3 class="form-section-title">Chi tiết đề xuất</h3>
                            </div>

                            <div class="table-card">
                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Máy phát <span class="req">*</span></th>
                                            <th class="col-qty">Số lượng <span class="req">*</span></th>
                                            <th class="col-stock">Tồn kho HT</th>
                                            <th>Ghi chú dòng</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <c:choose>
                                            <c:when test="${empty proposal.details}">
                                                <tr>
                                                    <td class="col-num"><span class="row-num">1</span></td>
                                                    <td>
                                                        <select name="generatorId" class="gen-select" required>
                                                            <option value="">-- Chọn máy --</option>
                                                            <c:forEach var="g" items="${generators}">
                                                                <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" step="1" oninput="validateQty(this)" required /></td>
                                                    <td class="col-stock"><span class="current-stock">0</span></td>
                                                    <td><input type="text" name="detailNote" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                    <td class="col-del">
                                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr>
                                                        <td class="col-num"><span class="row-num">${st.count}</span></td>
                                                        <td>
                                                            <select name="generatorId" class="gen-select" onchange="updateCurrentStock(this)" required>
                                                                <option value="">-- Chọn máy --</option>
                                                                <c:forEach var="g" items="${generators}">
                                                                    <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>><c:out value="${g.model}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td><input type="number" name="quantity" class="qty-input" value="<c:out value="${d.quantity}"/>" min="1" max="9999" step="1" oninput="validateQty(this)" required /></td>
                                                        <td class="col-stock"><span class="current-stock"><c:out value="${d.currentStock}"/></span></td>
                                                        <td><input type="text" name="detailNote" value="<c:out value="${d.note}"/>" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                        <td class="col-del">
                                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <template id="rowTemplate">
                                <tr>
                                    <td class="col-num"><span class="row-num"></span></td>
                                    <td>
                                        <select name="generatorId" class="gen-select" onchange="updateCurrentStock(this)" required>
                                            <option value="">-- Chọn máy --</option>
                                            <c:forEach var="g" items="${generators}">
                                                <option value="${g.id}"><c:out value="${g.model}"/></option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" step="1" oninput="validateQty(this)" required /></td>
                                    <td class="col-stock"><span class="current-stock">0</span></td>
                                    <td><input type="text" name="detailNote" placeholder="VD: Cần gấp cho dự án X" /></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                    </td>
                                </tr>
                            </template>

                            <button type="button" class="btn add-row-btn" onclick="addRow()">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                Thêm dòng
                            </button>
                        </div>

                        <div class="form-section">
                            <div class="footer-actions">
                                <button type="button" class="btn btn-danger" onclick="confirmDelete()">
                                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-2 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/></svg>
                                    Xoá phiếu nháp
                                </button>
                                <div class="right">
                                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                                    <button type="submit" name="submitType" value="draft" class="btn">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                        Lưu nháp
                                    </button>
                                    <button type="submit" name="submitType" value="pending" class="btn btn-primary">
                                        <svg class="icon" viewBox="0 0 24 24"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                                        Gửi duyệt
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>

                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                    </form>

                </main>
            </div>
        </div>

        <script>
            function updateCurrentStock(selectEl) {
                var row = selectEl.closest('tr');
                var opt = selectEl.options[selectEl.selectedIndex];
                var stock = opt ? (opt.getAttribute('data-stock') || '0') : '0';
                row.querySelector('.current-stock').textContent = stock;
            }
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
                document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
                    el.textContent = i + 1;
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
                    var sel = rows[i].querySelector('.gen-select');
                    var qtyInput = rows[i].querySelector('.qty-input');
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
                if (confirm('Bạn có chắc chắn muốn XOÁ phiếu nháp "${proposal.proposalCode}"?\n\nHành động này không thể hoàn tác.')) {
                    document.getElementById('deleteForm').submit();
                }
            }
            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('#detailBody .gen-select').forEach(function (sel) {
                    updateCurrentStock(sel);
                });
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
