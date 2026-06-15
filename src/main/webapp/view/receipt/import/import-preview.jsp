<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Xem trước nhập Excel — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        .preview-wrap { max-width: 1200px; margin: 24px auto; padding: 0 24px; }
        .info-box {
            background: var(--surface-2); border-radius: 10px; padding: 16px 20px;
            margin-bottom: 20px; font-size: 0.9rem; color: var(--muted); line-height: 1.7;
        }
        .info-box strong { color: var(--fg); }
        .section-title {
            font-size: 1rem; font-weight: 700; margin: 24px 0 10px;
            display: flex; align-items: center; gap: 8px; color: var(--fg);
        }
        .badge-count {
            font-size: 0.78rem; font-weight: 600; padding: 2px 10px; border-radius: 99px;
        }
        .badge-valid   { background: #d1fae5; color: #065f46; }
        .badge-invalid { background: #fee2e2; color: #991b1b; }
        .badge-skipped { background: #e0e7ff; color: #3730a3; }
        .error-text { font-size: 0.82rem; color: #dc2626; }
        .btn-row { display: flex; gap: 12px; margin-top: 24px; flex-wrap: wrap; }
        .table-card {
            background: var(--bg); border: 1px solid var(--border);
            border-radius: var(--radius); overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
        thead tr { background: var(--surface-2); }
        th, td { padding: 10px 14px; text-align: left; border-bottom: 1px solid var(--border); vertical-align: top; }
        th { font-weight: 600; color: var(--muted); font-size: 0.78rem; text-transform: uppercase; }
        tr:last-child td { border-bottom: none; }
        .cb-col { width: 40px; text-align: center; }
        input[type=checkbox] { width: 16px; height: 16px; cursor: pointer; }
        tr.row-invalid { background: #fef2f2; }
        tr.row-invalid td { color: #991b1b; }
        .empty-msg {
            padding: 24px; text-align: center; color: var(--muted);
        }
        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert-info { background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }
        a.btn { text-decoration: none; }
        .col-num { width: 50px; font-family: var(--font-mono); color: var(--muted); }
        .col-brand { color: var(--muted); font-size: 0.82rem; }
        .col-serial { font-family: var(--font-mono); font-size: 0.85rem; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"/>

    <div>
        <header class="topbar">
            <h1>Xem trước nhập Excel</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Tạo mới / Nhập Excel</span>
            <div class="top-actions">
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt?action=create">← Quay lại</a>
            </div>
        </header>

        <main>
            <div class="preview-wrap">

                <div class="info-box">
                    Kho: <strong>${warehouseId}</strong>
                    &nbsp;|&nbsp; Lý do: <strong>${empty reasonId ? '(chưa chọn)' : reasonId}</strong>
                    &nbsp;|&nbsp; Hợp lệ:
                    <strong style="color:#065f46;">${fn:length(validRows)}</strong>
                    dòng &nbsp;|&nbsp; Lỗi:
                    <strong style="color:#991b1b;">${fn:length(invalidRows)}</strong>
                    dòng
                </div>

                <c:if test="${empty validRows and empty invalidRows}">
                    <div class="alert alert-info">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                        <div class="alert-body">
                            <div class="alert-title">File không có dữ liệu</div>
                            <div>Vui lòng kiểm tra lại file Excel. Tải mẫu tại <a href="${pageContext.request.contextPath}/import-receipt?action=template">đây</a>.</div>
                        </div>
                    </div>
                </c:if>

                <div class="section-title">
                    Dòng hợp lệ <span class="badge-count badge-valid">${fn:length(validRows)}</span>
                </div>

                <c:choose>
                    <c:when test="${empty validRows}">
                        <div class="table-card empty-msg">Không có dòng hợp lệ nào.</div>
                    </c:when>
                    <c:otherwise>
                        <form method="post" id="confirmForm"
                              action="${pageContext.request.contextPath}/import-receipt?action=importConfirm">
                            <input type="hidden" name="warehouseId" value="${warehouseId}"/>
                            <input type="hidden" name="reasonId" value="${reasonId}"/>
                            <input type="hidden" name="note" value="${note}"/>

                            <div class="table-card">
                                <table>
                                    <thead>
                                        <tr>
                                            <th class="cb-col">
                                                <input type="checkbox" id="checkAll" checked
                                                       onclick="document.querySelectorAll('.row-cb').forEach(c => c.checked = this.checked)"/>
                                            </th>
                                            <th class="col-num">#</th>
                                            <th>Mã máy</th>
                                            <th>Thương hiệu</th>
                                            <th>Serial</th>
                                            <th>Số lượng</th>
                                            <th>Đơn giá</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="row" items="${validRows}" varStatus="st">
                                        <tr>
                                            <td class="cb-col">
                                                <input type="checkbox" class="row-cb" name="rowIndex" value="${st.index}" checked/>
                                            </td>
                                            <td class="col-num">${row.rowNum}</td>
                                            <td>
                                                <c:out value="${row.generatorModel}"/>
                                                <input type="hidden" name="generatorId" value="${row.generatorId}"/>
                                            </td>
                                            <td class="col-brand"><c:out value="${row.brand}"/></td>
                                            <td class="col-serial">
                                                <c:out value="${row.serial}"/>
                                                <input type="hidden" name="serialNumber" value="${row.serial}"/>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" value="${row.quantity}" min="1" max="100000"
                                                       style="width:70px;" onblur="if(this.value<1)this.value=1;"/>
                                            </td>
                                            <td>
                                                <input type="text" name="unitPrice" value="${row.unitPrice}"
                                                       style="width:120px;" placeholder="0"/>
                                            </td>
                                            <td>
                                                <input type="text" name="detailNote" value="${row.note}"
                                                       style="width:200px;" placeholder="(không có)"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="btn-row">
                                <button type="submit" class="btn btn-primary" onclick="return confirmImport()">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                                    Tạo phiếu nháp từ ${fn:length(validRows)} dòng đã chọn
                                </button>
                                <a class="btn" href="${pageContext.request.contextPath}/import-receipt?action=create">
                                    Huỷ và quay lại
                                </a>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>

                <c:if test="${not empty invalidRows}">
                    <div class="section-title">
                        Dòng lỗi <span class="badge-count badge-invalid">${fn:length(invalidRows)}</span>
                    </div>
                    <div class="table-card">
                        <table>
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th>Mã máy</th>
                                    <th>Serial</th>
                                    <th>Số lượng</th>
                                    <th>Đơn giá</th>
                                    <th>Ghi chú</th>
                                    <th>Lỗi</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="row" items="${invalidRows}">
                                <tr class="row-invalid">
                                    <td class="col-num">${row.rowNum}</td>
                                    <td><c:out value="${row.model}"/></td>
                                    <td class="col-serial"><c:out value="${row.serial}"/></td>
                                    <td><c:out value="${row.quantity}"/></td>
                                    <td><c:out value="${row.unitPrice}"/></td>
                                    <td><c:out value="${row.note}"/></td>
                                    <td class="error-text"><c:out value="${row['_errors']}"/></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

            </div>
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
    function confirmImport() {
        var count = document.querySelectorAll('.row-cb:checked').length;
        if (count === 0) {
            toast('Vui lòng chọn ít nhất 1 dòng để nhập', 'danger');
            return false;
        }
        return confirm('Tạo phiếu nháp với ' + count + ' dòng đã chọn? Bạn có thể chỉnh sửa trước khi gửi duyệt.');
    }
</script>
</body>
</html>
