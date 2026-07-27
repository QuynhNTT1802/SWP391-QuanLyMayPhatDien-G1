<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu luân chuyển kho — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
            <h1>Phiếu đề xuất luân chuyển</h1>
            <span class="crumb">/ Quản lý kho / Luân chuyển</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('transfers.create')}">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/transfers?action=create">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                        Tạo phiếu luân chuyển
                    </a>
                </c:if>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Phiếu luân chuyển</div>
                    <h2 class="page-title">Danh sách phiếu đề xuất luân chuyển</h2>
                </div>
            </div>

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

            <form method="get" action="${pageContext.request.contextPath}/transfers" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                <input type="hidden" name="action" value="list"/>
                <input type="hidden" name="page" value="1"/>
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu..." autocomplete="off" />
                </div>
                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Trạng thái: Tất cả</option>
                    <option value="PENDING_CEO" ${statusFilter == 'PENDING_CEO' ? 'selected' : ''}>Chờ CEO duyệt</option>
                    <option value="REQUEST_REVISION" ${statusFilter == 'REQUEST_REVISION' ? 'selected' : ''}>Yêu cầu chỉnh sửa</option>
                    <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                    <option value="EXPORTED" ${statusFilter == 'EXPORTED' ? 'selected' : ''}>Đã xuất</option>
                    <option value="AWAITING_DEST_ACCEPT" ${statusFilter == 'AWAITING_DEST_ACCEPT' ? 'selected' : ''}>Chờ kho đích (cũ)</option>
                    <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn tất</option>
                    <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Bị từ chối</option>
                </select>
                <div class="spacer"></div>
                <button type="button" class="btn" onclick="location.href = '${pageContext.request.contextPath}/transfers?action=list'">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    Xóa lọc
                </button>
            </form>

            <div class="table-card" style="margin-top:16px;">
                <table class="users">
                    <thead>
                        <tr>
                            <th>Mã phiếu</th>
                            <th>Kho nguồn</th>
                            <th>Kho đích</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty transfers}">
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state" style="padding:20px;">Chưa có phiếu luân chuyển nào.</div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${transfers}">
                                    <tr>
                                        <td><a class="code-link" href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}"><c:out value="${t.transferCode}"/></a></td>
                                        <td>${t.sourceWarehouseName}</td>
                                        <td>${t.destWarehouseName}</td>
                                        <td>${t.createdByName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty t.createdAt}">
                                                    <fmt:formatDate value="${t.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${t.status == 'PENDING_CEO'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ CEO duyệt</span></c:when>
                                                <c:when test="${t.status == 'APPROVED'}"><span class="status-pill status-completed"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                <c:when test="${t.status == 'EXPORTED'}"><span class="status-pill status-teal"><span class="pdot"></span>Đã xuất</span></c:when>
                                                <c:when test="${t.status == 'AWAITING_DEST_ACCEPT'}"><span class="status-pill status-neutral"><span class="pdot"></span>Chờ kho đích (cũ)</span></c:when>
                                                <c:when test="${t.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn tất</span></c:when>
                                                <c:when test="${t.status == 'REJECTED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Bị từ chối</span></c:when>
                                                <c:when test="${t.status == 'REQUEST_REVISION'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Yêu cầu chỉnh sửa</span></c:when>
                                                <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${t.status}"/></span></c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <c:set var="filterParams" value="" />
                <c:if test="${not empty statusFilter}">
                    <c:set var="filterParams" value="${filterParams}&status=${statusFilter}" />
                </c:if>
                <c:if test="${not empty search}">
                    <c:set var="filterParams" value="${filterParams}&search=${search}" />
                </c:if>
                <div class="pagination">
                    <div class="info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
                    <div class="controls">
                        <c:if test="${currentPage > 1}">
                            <a href="?action=list&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                <c:otherwise><a href="?action=list&page=${p}${filterParams}" class="page-btn">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?action=list&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
        <style>
            .status-purple { background:#ede9fe; color:#6d28d9; }
            .status-orange { background:#fff3e0; color:#b15c00; }
            .status-teal   { background:#e0f2f1; color:#00695c; }
            .status-pink   { background:#fce4ec; color:#a13d63; }
        </style>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            if (typeof showToast === 'function') {
                showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
            } else if (typeof toast === 'function') {
                toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
            }
            window.SESSION_DATA = null;
        }
    });
</script>
</body>
</html>