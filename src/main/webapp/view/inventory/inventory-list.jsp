<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tồn kho — Warehouse OS</title>
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
            <h1>Tồn kho</h1>
            <span class="crumb">/ Kho / Tồn kho</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Tồn kho hiện tại</h2>
                    <div class="page-sub">${totalItems} mặt hàng</div>
                </div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/inventory" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo model hoặc hãng" autocomplete="off" />
                </div>
                <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                    <option value="">Kho: Tất cả</option>
                    <c:forEach var="wh" items="${warehouses}">
                        <option value="${wh.warehouseId}" <c:if test="${selectedWarehouse == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty selectedWarehouse or not empty search}">
                    <a href="${pageContext.request.contextPath}/inventory" class="btn">
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
                            <th>Model</th>
                            <th>Hãng</th>
                            <th style="width:100px;">Số lượng</th>
                            <th>Kho</th>
                            <th style="width:160px;">Cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty inventoryList}">
                                <tr><td colspan="6">
                                    <div class="empty-state"><strong>Không có dữ liệu tồn kho</strong></div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${inventoryList}" varStatus="st">
                                    <tr>
                                        <td>${fromIndex + st.index}</td>
                                        <td><strong><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${item.generatorId}">${item.generatorModel}</a></strong></td>
                                        <td>${item.generatorBrand}</td>
                                        <td>
                                            <span class="qty-cell ${item.quantity <= 3 ? 'qty-low' : 'qty-ok'}">
                                                ${item.quantity}
                                            </span>
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${item.warehouseId}"><c:out value="${item.warehouseName}"/></a></td>
                                        <td style="font-size:12px;color:var(--muted);">${item.updatedAt}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <c:set var="filterParams" value="" />
                <c:if test="${not empty selectedWarehouse}">
                    <c:set var="filterParams" value="${filterParams}&warehouse=${selectedWarehouse}" />
                </c:if>
                <c:if test="${not empty search}">
                    <c:set var="filterParams" value="${filterParams}&search=${search}" />
                </c:if>
                <div class="pagination">
                    <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                    <div class="controls">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                <c:otherwise><a href="?page=${p}${filterParams}" class="page-btn">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>