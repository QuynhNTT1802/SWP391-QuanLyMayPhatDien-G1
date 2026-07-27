<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản lý kho — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <style>
        .qty-cell { font-weight: 700; }
        .qty-low { color: var(--danger); }
        .qty-ok { color: var(--accent); }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Kho hàng</h1>
            <span class="crumb">/ Quản trị / Kho hàng</span>
            <div class="top-actions">
                </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Quản trị</div>
                    <h2 class="page-title">Quản lý kho</h2>
                    <div class="page-sub">${totalItems} kho</div>
                </div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/warehouse" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <input type="hidden" name="action" value="list" />
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo tên kho hoặc địa chỉ" autocomplete="off" />
                </div>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty search}">
                    <a href="${pageContext.request.contextPath}/warehouse?action=list" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xoá lọc
                    </a>
                </c:if>
            </form>
            <div class="table-card" style="margin-top:16px;">
                <table class="users">
                    <thead>
                        <tr>
                            <th style="width:40px;">#</th>
                            <th>Tên kho</th>
                            <th>Địa chỉ</th>
                            <th>Trạng thái</th>
                            <th style="width:100px;">Tổng tồn</th>
                            <th style="width:100px;">Số mặt hàng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty warehouses}">
                                <tr><td colspan="7">
                                    <div class="empty-state"><strong>Không có dữ liệu kho</strong></div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="w" items="${warehouses}" varStatus="st">
                                    <tr>
                                        <td>${fromIndex + st.index}</td>
                                        <td><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${w.warehouseId}"><c:out value="${w.name}"/></a></td>
                                        <td><c:out value="${w.address}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${w.status == 'active'}"><span class="status active"><span class="sdot"></span>Hoạt động</span></c:when>
                                                <c:when test="${w.status == 'locked'}"><span class="status locked"><span class="sdot"></span>Bị khóa</span></c:when>
                                                <c:otherwise><span class="status disabled"><span class="sdot"></span>Ngưng hoạt động</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="qty-cell qty-ok"><fmt:formatNumber value="${w.totalInventory}"/></span></td>
                                        <td><span class="qty-cell qty-ok">${w.itemCount}</span></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <c:set var="filterParams" value="" />
                <c:if test="${not empty search}">
                    <c:set var="filterParams" value="&search=${search}" />
                </c:if>
                <div class="pagination">
                    <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
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
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
