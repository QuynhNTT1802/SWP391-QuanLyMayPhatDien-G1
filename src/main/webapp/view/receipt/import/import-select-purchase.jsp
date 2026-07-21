<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đơn mua — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
</head>
<body>
<c:set var="currentAction" value="${not empty param.action ? param.action : 'selectPurchase'}" />
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Đơn mua</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Chọn đơn mua</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    Quay lại
                </a>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Phiếu nhập</div>
                    <h2 class="page-title">Đơn mua</h2>
                    <div class="page-sub">${totalItems} phiếu</div>
                </div>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/import-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                <input type="hidden" name="action" value="${currentAction}" />
                <input type="hidden" name="page" value="1" />
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã đơn mua" autocomplete="off" />
                </div>
                <label style="font-size:13px;color:var(--muted);">Từ:</label>
                <input type="date" name="fromDate" class="filter-select" value="<c:out value='${fromDate}'/>" title="Từ ngày duyệt" />
                <label style="font-size:13px;color:var(--muted);">Đến:</label>
                <input type="date" name="toDate" class="filter-select" value="<c:out value='${toDate}'/>" title="Đến ngày duyệt" />
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <div class="spacer"></div>
                <button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/import-receipt?action=${currentAction}'">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    Xóa lọc
                </button>
            </form>

            <c:choose>
                <c:when test="${empty approvedPOs}">
                    <div class="empty-state">Không có đơn mua nào đã duyệt.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users" style="width:100%;table-layout:fixed;">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th class="col-period">Kỳ</th>
                                    <th>Kho nhập</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="po" items="${approvedPOs}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}" class="po-code-link"><span class="po-code">${po.poCode}</span></a></td>
                                        <td class="col-period">${po.period}</td>
                                        <td>${po.warehouseName}</td>
                                        <td class="col-creator"><c:out value="${po.createdByName}"/></td>
                                        <td>
                                            <button type="button" class="btn" style="font-size:12px;padding:5px 12px;" onclick="viewPurchaseDetail(${po.poId}, '${po.poCode}', '${pageContext.request.contextPath}/import-receipt?action=create&poId=${po.poId}')" title="Xem chi tiết">
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
                                    <a href="?action=${currentAction}&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="pg">
                                    <c:choose>
                                        <c:when test="${pg == currentPage}"><span class="page-btn active">${pg}</span></c:when>
                                        <c:otherwise><a href="?action=${currentAction}&page=${pg}${filterParams}" class="page-btn">${pg}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=${currentAction}&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
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
            <h3 id="modalTitle">Chi tiết đơn mua</h3>
            <button type="button" class="modal-close" onclick="closeDetailModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="table-card" style="border:none;padding:0;">
                <table class="users" id="detailTable">
                    <thead>
                        <tr>
                            <th>Mã máy</th>
                            <th>Tên máy</th>
                            <th>Thương hiệu</th>
                            <th>SL đề xuất</th>
                            <th>SL duyệt</th>
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
            <a id="createBtn" href="#" class="btn btn-primary" style="font-size:13px;padding:6px 16px;">Tạo phiếu nhập</a>
            <button type="button" class="btn" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<style>
.po-code-link { text-decoration:none; }
.po-code-link:hover { text-decoration:underline; }
.modal-overlay { position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center; }
.modal-box { background:var(--card-bg,#fff);border-radius:12px;width:90%;max-height:80vh;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(0,0,0,0.3); }
.modal-header { display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-bottom:1px solid var(--border,#e5e7eb); }
.modal-header h3 { margin:0;font-size:16px;font-weight:600; }
.modal-close { background:none;border:none;font-size:24px;cursor:pointer;color:var(--muted,#999);padding:0;line-height:1; }
.modal-body { padding:20px;overflow-y:auto;flex:1; }
.modal-footer { display:flex;justify-content:flex-end;gap:8px;padding:12px 20px;border-top:1px solid var(--border,#e5e7eb); }
</style>
<script>
function viewPurchaseDetail(id, code, createUrl) {
    document.getElementById('modalTitle').textContent = 'Chi tiết đơn mua ' + code;
    document.getElementById('createBtn').href = createUrl;
    var tbody = document.getElementById('detailBody');
    tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:20px;color:var(--muted)">Đang tải...</td></tr>';
    document.getElementById('detailEmpty').style.display = 'none';
    document.getElementById('detailModal').style.display = 'flex';
    fetch(window.APP_CTX + '/import-receipt?action=getPurchaseDetail&id=' + id)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            tbody.innerHTML = '';
            if (!data || data.length === 0) {
                document.getElementById('detailEmpty').style.display = 'block';
                return;
            }
            data.forEach(function(item) {
                var tr = document.createElement('tr');
                tr.innerHTML = '<td>' + (item.generatorCode || '') + '</td>'
                    + '<td>' + (item.generatorName || '') + '</td>'
                    + '<td>' + (item.brandName || '') + '</td>'
                    + '<td>' + item.proposedQuantity + '</td>'
                    + '<td>' + item.finalQuantity + '</td>'
                    + '<td>' + (item.unitPrice ? new Intl.NumberFormat('vi-VN', {style:'currency',currency:'VND'}).format(item.unitPrice) : '') + '</td>'
                    + '<td>' + (item.note || '') + '</td>';
                tbody.appendChild(tr);
            });
        })
        .catch(function() {
            tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:20px;color:red;">Lỗi tải dữ liệu.</td></tr>';
        });
}
function closeDetailModal() {
    document.getElementById('detailModal').style.display = 'none';
}
</script>
</body>
</html>
