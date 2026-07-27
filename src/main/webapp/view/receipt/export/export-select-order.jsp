<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chọn đơn hàng · Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Đơn hàng</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / Chọn đơn hàng</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>

        <main>
            <a href="${pageContext.request.contextPath}/export-receipt" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại
            </a>

            <div class="page-head">
                <div class="left">
                    <h2 class="page-title">Đơn hàng</h2>
                </div>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/export-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-bottom:16px;">
                <input type="hidden" name="action" value="selectOrder" />
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã đơn hoặc tên khách" autocomplete="off" />
                </div>
                <label style="font-size:13px;color:var(--muted);">Từ:</label>
                <input type="date" name="fromDate" class="filter-select" value="<c:out value='${fromDate}'/>" />
                <label style="font-size:13px;color:var(--muted);">Đến:</label>
                <input type="date" name="toDate" class="filter-select" value="<c:out value='${toDate}'/>" />
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty search or not empty fromDate or not empty toDate}">
                    <a href="${pageContext.request.contextPath}/export-receipt?action=selectOrder" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xóa lọc
                    </a>
                </c:if>
            </form>

            <c:choose>
                <c:when test="${empty approvedOrders}">
                    <div class="empty-state">
                        Không có đơn hàng nào đã duyệt.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users" style="width:100%;table-layout:fixed;">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày duyệt</th>
                                    <th>Tổng tiền</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${approvedOrders}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/order?action=detail&id=${o.orderId}" class="receipt-code-link"><strong class="receipt-code">${o.orderCode}</strong></a></td>
                                        <td>${o.customer.name}</td>
                                        <td><fmt:formatDate value="${o.approvedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="amount-cell">
                                            <fmt:formatNumber value="${o.totalAmount}" pattern="#,##0"/> ₫
                                        </td>
                                        <td>
                                        <button type="button" class="btn" style="font-size:12px;padding:4px 10px;" onclick="viewOrderDetail(${o.orderId}, '${o.orderCode}', '${pageContext.request.contextPath}/export-receipt?action=create&orderId=${o.orderId}')" title="Xem chi tiết đơn hàng">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                        Xem chi tiết
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty search}">
                            <c:set var="filterParams" value="${filterParams}&search=${search}" />
                        </c:if>
                        <c:if test="${not empty fromDate}">
                            <c:set var="filterParams" value="${filterParams}&fromDate=${fromDate}" />
                        </c:if>
                        <c:if test="${not empty toDate}">
                            <c:set var="filterParams" value="${filterParams}&toDate=${toDate}" />
                        </c:if>
                        <div class="pagination">
                            <div class="info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=selectOrder&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=selectOrder&page=${p}${filterParams}" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=selectOrder&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>

<div class="modal-overlay" id="detailModal" style="display:none;">
    <div class="modal-box" style="max-width:700px;">
        <div class="modal-header">
            <h3 id="modalTitle">Chi tiết đơn hàng</h3>
            <button type="button" class="modal-close" onclick="closeDetailModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="table-card" style="border:none;padding:0;">
                <table class="users" id="detailTable">
                    <thead>
                        <tr>
                            <th>Mẫu máy</th>
                            <th>Công suất</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody id="detailBody">
                    </tbody>
                </table>
            </div>
            <div class="empty-state" id="detailEmpty" style="display:none;">Không có chi tiết.</div>
        </div>
        <div class="modal-footer">
            <a id="createBtn" href="#" class="btn btn-primary" style="font-size:13px;padding:6px 16px;">Tạo phiếu xuất</a>
            <button type="button" class="btn" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<style>
.receipt-code-link { text-decoration:none; }
.receipt-code-link:hover { text-decoration:underline; }
.modal-overlay { position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center; }
.modal-box { background:var(--card-bg,#fff);border-radius:12px;width:90%;max-height:80vh;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(0,0,0,0.3); }
.modal-header { display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-bottom:1px solid var(--border,#e5e7eb); }
.modal-header h3 { margin:0;font-size:16px;font-weight:600; }
.modal-close { background:none;border:none;font-size:24px;cursor:pointer;color:var(--muted,#999);padding:0;line-height:1; }
.modal-body { padding:20px;overflow-y:auto;flex:1; }
.modal-footer { display:flex;justify-content:flex-end;gap:8px;padding:12px 20px;border-top:1px solid var(--border,#e5e7eb); }
</style>
<script>
function viewOrderDetail(orderId, orderCode, createUrl) {
    var title = document.getElementById('modalTitle');
    title.textContent = 'Chi tiết đơn hàng ' + orderCode;
    document.getElementById('createBtn').href = createUrl;
    var tbody = document.getElementById('detailBody');
    tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:20px;color:var(--muted)">Đang tải...</td></tr>';
    document.getElementById('detailEmpty').style.display = 'none';
    document.getElementById('detailModal').style.display = 'flex';
    fetch(window.APP_CTX + '/export-receipt?action=getOrderDetail&id=' + orderId)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            tbody.innerHTML = '';
            if (!data || data.length === 0) {
                document.getElementById('detailEmpty').style.display = 'block';
                return;
            }
            data.forEach(function(item) {
                var tr = document.createElement('tr');
                tr.innerHTML = '<td>' + (item.generatorModel || '') + '</td>'
                    + '<td>' + (item.generatorPower || '') + '</td>'
                    + '<td>' + item.quantity + '</td>'
                    + '<td>' + (item.unitPrice ? new Intl.NumberFormat('vi-VN', {style:'currency',currency:'VND'}).format(item.unitPrice) : '') + '</td>'
                    + '<td>' + (item.note || '') + '</td>';
                tbody.appendChild(tr);
            });
        })
        .catch(function() {
            tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;padding:20px;color:red;">L?i t?i d? li?u.</td></tr>';
        });
}
function closeDetailModal() {
    document.getElementById('detailModal').style.display = 'none';
}
document.addEventListener('DOMContentLoaded', function () {
    if (window.SESSION_DATA && window.SESSION_DATA.message) {
        toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
        window.SESSION_DATA = null;
    }
});
</script>
</body>
</html>