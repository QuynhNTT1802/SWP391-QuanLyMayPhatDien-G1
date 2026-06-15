<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@page import="com.quanlymayphatdien.g1.dal.GeneratorDAO"%>
<%@page import="com.quanlymayphatdien.g1.entity.Generator"%>
<%@page import="java.util.List"%>
<%
    GeneratorDAO gdao = new GeneratorDAO();
    List<Generator> gens = gdao.findAllActive();
    request.setAttribute("gens", gens);
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
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/inventory">Kho</a> / Tồn kho<c:if test="${selectedWarehouse != null}"> / <c:set var="selectedWhName" value=""/><c:forEach var="w" items="${warehouses}"><c:if test="${w.warehouseId == selectedWarehouse}"><c:set var="selectedWhName" value="${w.name}"/></c:if></c:forEach><c:out value="${selectedWhName}"/></c:if></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41 1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>
        <main>
            <c:if test="${not empty lockedWarehouseName}">
                <div class="alert" style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb, var(--danger) 25%, transparent);">
                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0;"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    <span>Kho &quot;<c:out value='${lockedWarehouseName}'/>&quot; hiện đang bị khóa. Các serial trong kho này tạm thời không hiển thị trong tồn kho. Vui lòng mở khóa kho trong phần <a href="${pageContext.request.contextPath}/warehouse?action=list">Quản lý kho</a> nếu cần xem.</span>
                </div>
            </c:if>

            <a class="back-link" href="${pageContext.request.contextPath}/inventory">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại tổng quan tồn kho
            </a>

            <c:if test="${selectedWarehouse != null}">
                <c:set var="selectedWhName" value=""/>
                <c:forEach var="w" items="${warehouses}">
                    <c:if test="${w.warehouseId == selectedWarehouse}">
                        <c:set var="selectedWhName" value="${w.name}"/>
                    </c:if>
                </c:forEach>
                <div class="type-header">
                    <span class="type-badge"><span class="tdot"></span><c:out value="${selectedWhName}"/></span>
                    <span class="type-count">${totalItems} serial</span>
                </div>
            </c:if>

            <h3 class="section-heading">
                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                Danh sách serial tồn kho
            </h3>

            <form method="get" action="${pageContext.request.contextPath}/inventory/list" class="filter-bar">
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo serial hoặc model" autocomplete="off" />
                </div>
                <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                    <option value="">Kho: Tất cả</option>
                    <c:forEach var="wh" items="${warehouses}">
                        <option value="${wh.warehouseId}" <c:if test="${selectedWarehouse == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                    </c:forEach>
                </select>
                <select class="filter-select" name="generator" onchange="this.form.submit()">
                    <option value="">Máy: Tất cả</option>
                    <c:forEach var="g" items="${gens}">
                        <option value="${g.id}" <c:if test="${selectedGenerator == g.id}">selected</c:if>>${g.model}</option>
                    </c:forEach>
                </select>
                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Trạng thái: Tất cả</option>
                    <option value="IN_STOCK" <c:if test="${status == 'IN_STOCK'}">selected</c:if>>IN_STOCK</option>
                    <option value="SOLD" <c:if test="${status == 'SOLD'}">selected</c:if>>SOLD</option>
                    <option value="PENDING_LIQUIDATION" <c:if test="${status == 'PENDING_LIQUIDATION'}">selected</c:if>>PENDING_LIQUIDATION</option>
                    <option value="LIQUIDATED" <c:if test="${status == 'LIQUIDATED'}">selected</c:if>>LIQUIDATED</option>
                    <option value="IN_TRANSIT" <c:if test="${status == 'IN_TRANSIT'}">selected</c:if>>IN_TRANSIT</option>
                </select>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty selectedWarehouse or not empty selectedGenerator or not empty search or not empty status}">
                    <a href="${pageContext.request.contextPath}/inventory/list" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xoá lọc
                    </a>
                </c:if>
            </form>

            <div class="users-card">
                <table class="users">
                    <thead>
                        <tr>
                            <th style="width:40px;">#</th>
                            <th>Serial</th>
                            <th>Model</th>
                            <th>Hãng</th>
                            <th>Kho</th>
                            <th style="width:150px;">Trạng thái</th>
                            <th style="width:160px;">Ngày nhập</th>
                            <th style="width:160px;">Cập nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty serialList}">
                                <tr><td colspan="8">
                                    <div class="empty-state">
                                        <div class="icon-wrap">
                                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                                        </div>
                                        <strong>Không có serial nào trong tồn kho</strong>
                                    </div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${serialList}" varStatus="st">
                                    <tr>
                                        <td>${fromIndex + st.index}</td>
                                        <td>
                                            <strong style="font-family:var(--font-mono);font-size:12.5px;">
                                                <c:out value="${item.serialNumber}"/>
                                            </strong>
                                        </td>
                                        <td><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${item.generatorId}">${item.generatorModel}</a></td>
                                        <td>${item.generatorBrand}</td>
                                        <td><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${item.warehouseId}"><c:out value="${item.warehouseName}"/></a></td>
                                        <td>
                                            <span class="status-badge status-${item.status}">
                                                <span class="sdot"></span>
                                                <c:out value="${item.status}"/>
                                            </span>
                                        </td>
                                        <td style="font-size:12px;color:var(--muted);">
                                            <c:choose>
                                                <c:when test="${item.createdAt != null}">
                                                    ${item.createdAt}
                                                </c:when>
                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
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
                <c:if test="${not empty selectedGenerator}">
                    <c:set var="filterParams" value="${filterParams}&generator=${selectedGenerator}" />
                </c:if>
                <c:if test="${not empty search}">
                    <c:set var="filterParams" value="${filterParams}&search=${search}" />
                </c:if>
                <c:if test="${not empty status}">
                    <c:set var="filterParams" value="${filterParams}&status=${status}" />
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
