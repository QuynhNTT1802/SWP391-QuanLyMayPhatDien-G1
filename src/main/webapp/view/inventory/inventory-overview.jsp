<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="com.quanlymayphatdien.g1.dal.InventoryDAO"%>
<%@page import="com.quanlymayphatdien.g1.dal.GeneratorDAO"%>
<%@page import="com.quanlymayphatdien.g1.entity.Generator"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%
    InventoryDAO invDAO = new InventoryDAO();
    GeneratorDAO gDAO = new GeneratorDAO();
    List<Generator> allGens = gDAO.findAllActive();
    request.setAttribute("allGens", allGens);
%>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tồn kho</h1>
            <span class="crumb">/ Kho / Tồn kho</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41 1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>
        <main>
            <c:if test="${not empty lockedWarehouseName}">
                <div class="alert" style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb, var(--danger) 25%, transparent);">
                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0;"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    <span>Kho &quot;<c:out value='${lockedWarehouseName}'/>&quot; hiện đang bị khóa. Vui lòng mở khóa kho trong phần <a href="${pageContext.request.contextPath}/warehouse?action=list">Quản lý kho</a> nếu cần xem chi tiết.</span>
                </div>
            </c:if>

            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Tồn kho</div>
                    <h2 class="page-title">Tồn kho hiện tại</h2>
                    <div class="page-sub"><fmt:formatNumber value="${kpiTotalQty}"/> máy phát điện đang trong kho tại <fmt:formatNumber value="${kpiTotalWarehouses}"/> kho</div>
                </div>
            </div>


            <h3 class="section-heading">
                <svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                Phân loại theo kho hàng
            </h3>

            <form method="get" action="${pageContext.request.contextPath}/inventory" class="filter-bar">
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo tên kho hoặc địa chỉ" autocomplete="off" />
                </div>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty search}">
                    <a href="${pageContext.request.contextPath}/inventory" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xoá lọc
                    </a>
                </c:if>
            </form>

            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th style="width:60px;text-align:center;font-family:var(--font-mono);">ID</th>
                            <th>Tên kho</th>
                            <th style="width:160px;text-align:right;">Số máy</th>
                            <th style="width:160px;text-align:right;">Số mặt hàng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty warehouses}">
                                <tr><td colspan="4">
                                    <div class="empty-state">
                                        <div class="icon-wrap">
                                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                                        </div>
                                        <strong>Chưa có kho nào</strong>
                                    </div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="w" items="${warehouses}">
                                    <tr class="warehouse-row" onclick="location.href='${pageContext.request.contextPath}/inventory/list?warehouse=${w.warehouseId}'">
                                        <td style="text-align:center;font-family:var(--font-mono);font-size:0.82rem;color:var(--muted);font-weight:600;">#${w.warehouseId}</td>
                                        <td>
                                            <span class="warehouse-name">
                                                <span class="wdot"></span>
                                                <c:out value="${w.name}"/>
                                            </span>
                                        </td>
                                        <td style="text-align:right;">
                                            <span class="item-count">
                                                <c:out value="${warehouseItemCount[w.warehouseId] != null ? warehouseItemCount[w.warehouseId] : 0}"/>
                                            </span>
                                        </td>
                                        <td style="text-align:right;font-family:var(--font-mono);font-weight:700;color:var(--muted);">
                                            <c:set var="whItems" value="0"/>
                                            <c:forEach var="g" items="${allGens}">
                                                <c:set var="key" value="${w.warehouseId}_${g.id}"/>
                                                <c:if test="${warehouseItemsByWhGen[key] != null}">
                                                    <c:set var="whItems" value="${whItems + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            <fmt:formatNumber value="${whItems}"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <c:set var="filterParams" value="" />
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
