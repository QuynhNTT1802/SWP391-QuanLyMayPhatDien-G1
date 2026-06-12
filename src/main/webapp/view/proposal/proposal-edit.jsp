<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            .detail-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 8px;
            }
            .detail-table th {
                text-align: left;
                padding: 8px 10px;
                font-size: 12px;
                font-weight: 600;
                color: var(--muted);
                border-bottom: 1px solid var(--border);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .detail-table td {
                padding: 8px 6px;
                vertical-align: top;
            }
            .detail-table select, .detail-table input {
                width: 100%;
                padding: 7px 8px;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--bg);
                color: var(--fg);
                font-size: 13px;
                box-sizing: border-box;
            }
            .col-num {
                width: 36px;
                text-align: center;
                color: var(--muted);
                font-weight: 600;
                padding-top: 14px;
            }
            .col-qty {
                width: 100px;
            }
            .col-del {
                width: 40px;
                text-align: center;
            }
            .row-del-btn {
                width: 28px;
                height: 28px;
                border: none;
                background: none;
                color: var(--danger);
                cursor: pointer;
                border-radius: var(--radius-sm);
                margin-top: 4px;
            }
            .row-del-btn:hover {
                background: var(--danger-soft);
            }
            .add-row-btn {
                margin-top: 8px;
                font-size: 13px;
            }
            .row-num {
                display: inline-block;
                min-width: 22px;
                color: var(--muted);
                font-weight: 600;
            }
            .gen-select, .qty-input {
                font-family: var(--font-ui);
            }
            .form-section-actions {
                display: flex;
                gap: 10px;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
            }
            .form-section-actions .right {
                display: flex;
                gap: 10px;
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chỉnh sửa đề xuất nhập</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal?action=list">Đề xuất nhập kho</a> / Chỉnh sửa</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <script>
                        <c:if test="${not empty sessionScope.toastMessage}">
                        window.SESSION_DATA = { message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>' };
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Kinh doanh · Đề xuất nhập #${proposal.proposalId}</div>
                        <h2 class="page-title">Chỉnh sửa phiếu đề xuất</h2>
                        <div class="page-sub">Phiếu <c:out value="${proposal.proposalCode}"/> · trạng thái nháp</div>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm();">
                            <input type="hidden" name="proposalId" value="${proposal.proposalId}" />

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                                    <h3 class="form-section-title">Thông tin phiếu đề xuất</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Mã phiếu</label>
                                        <input class="input mono" value="<c:out value="${proposal.proposalCode}"/>" readonly />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Người tạo</label>
                                        <input class="input" value="<c:out value="${proposal.createdByName}"/>" readonly />
                                    </div>
                                    <div class="field">
                                        <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                                        <select class="input" id="warehouseId" name="warehouseId" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Ngày tạo</label>
                                        <input class="input mono" value="<c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose>" readonly />
                                    </div>
                                    <div class="field span-2">
                                        <label class="field-label" for="note">Ghi chú</label>
                                        <textarea class="input" id="note" name="note" rows="3" placeholder="Ghi chú cho phiếu..."><c:out value="${proposal.note}"/></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — CHI TIẾT MÁY PHÁT ĐỀ XUẤT</div>
                                    <h3 class="form-section-title">Danh sách máy phát điện</h3>
                                </div>

                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Máy phát <span class="req">*</span></th>
                                            <th class="col-qty">Số lượng <span class="req">*</span></th>
                                            <th>Ghi chú dòng</th>
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
                                                            <select name="generatorId" class="gen-select" required>
                                                                <option value="">-- Chọn máy --</option>
                                                                <c:forEach var="g" items="${generators}">
                                                                    <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>>
                                                                        <c:out value="${g.model}"/>
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td><input type="number" name="quantity" class="qty-input" value="${d.quantity}" min="1" max="9999" oninput="validateQty(this)" required /></td>
                                                        <td><input type="text" name="detailNote" value="<c:out value="${d.note}"/>" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                        <td class="col-del">
                                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td class="col-num"><span class="row-num">1</span></td>
                                                    <td>
                                                        <select name="generatorId" class="gen-select" required>
                                                            <option value="">-- Chọn máy --</option>
                                                            <c:forEach var="g" items="${generators}">
                                                                <option value="${g.id}">
                                                                    <c:out value="${g.model}"/>
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" oninput="validateQty(this)" required /></td>
                                                    <td><input type="text" name="detailNote" placeholder="VD: Cần gấp cho dự án X" /></td>
                                                    <td class="col-del">
                                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>

                                <template id="rowTemplate">
                                    <tr>
                                        <td class="col-num"><span class="row-num"></span></td>
                                        <td>
                                            <select name="generatorId" class="gen-select" required>
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}">
                                                        <c:out value="${g.model}"/>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" oninput="validateQty(this)" required /></td>
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
                                <div class="form-section-actions">
                                    <button type="button" class="btn" style="color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent);" onclick="confirmDelete()">
                                        <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                        Xoá phiếu nháp
                                    </button>
                                    <div class="right">
                                        <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                                        <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                                        <button type="submit" name="submitType" value="pending" class="btn btn-primary">
                                            <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                            Gửi duyệt
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>

                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                    </form>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
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
                if (confirm('Bạn có chắc chắn muốn XOÁ phiếu nháp "<c:out value="${proposal.proposalCode}"/>"?\n\nHành động này không thể hoàn tác.')) {
                    document.getElementById('deleteForm').submit();
                }
            }
        </script>
    </body>
</html>
