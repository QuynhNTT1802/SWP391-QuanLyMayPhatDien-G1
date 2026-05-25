<%-- 
    Document   : admin-category
    Created on : May 24, 2026, 8:48:05 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Danh mục</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/role/rbac-roles.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Danh mục</h1>
            <span class="crumb">/ <a href="#">Quản trị</a> / Danh mục</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <a href="${pageContext.request.contextPath}/admin/category/edit" class="btn btn-primary" style="text-decoration: none;">
                    <svg class="icon" viewBox="0 0 24 24" style="width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:2;"><path d="M12 5v14M5 12h14"/></svg>
                    Thêm danh mục mới
                </a>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="eyebrow">Quản trị hệ thống</div>
                <h2>Quản lý danh mục</h2>
                <p>Phân loại máy phát điện theo hãng sản xuất, nhiên liệu, công suất, loại máy, pha và tình trạng.</p>
            </div>

            <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
                <form method="GET" action="${pageContext.request.contextPath}/admin/categories" style="display:flex;gap:12px;align-items:center;flex:1;flex-wrap:wrap;">
                    <div class="input has-icon" style="max-width: 360px;">
                        <span class="leading">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        </span>
                        <input type="text" name="search" placeholder="Tìm theo tên hoặc mô tả..." value="${param.search}" autocomplete="off">
                    </div>
                    <select name="filterType" onchange="this.form.submit()" style="padding:8px 12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;cursor:pointer;">
                        <option value="">Tất cả loại</option>
                        <c:forEach var="t" items="${types}">
                            <option value="${t}" ${param.filterType == t ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${t=='brand'}">Hãng sản xuất</c:when>
                                    <c:when test="${t=='fuel_type'}">Nhiên liệu</c:when>
                                    <c:when test="${t=='power_range'}">Dải công suất</c:when>
                                    <c:when test="${t=='generator_type'}">Loại máy</c:when>
                                    <c:when test="${t=='phase'}">Loại pha</c:when>
                                    <c:when test="${t=='condition'}">Tình trạng</c:when>
                                    <c:otherwise>${t}</c:otherwise>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                </form>
                <c:if test="${not empty param.search || not empty param.filterType}">
                    <span style="font-size:13px;color:var(--muted);">${categoryList.size()} kết quả</span>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="btn" style="font-size:13px;">Xóa bộ lọc</a>
                </c:if>
            </div>

            <section id="view-list" style="margin-top:20px;">
                <div class="card-table">
                <div class="roles-grid" id="rolesGrid">
                    <c:forEach var="cat" items="${categoryList}">
                        <div class="role-card tone-info">
                            <div class="head">
                                <div class="role-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                                        <line x1="7" y1="7" x2="7.01" y2="7"/>
                                    </svg>
                                </div>
                                <div class="head-body">
                                    <h3>${cat.name}</h3>
                                </div>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/category/edit?id=${cat.id}" class="icon-tiny" title="Chỉnh sửa">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M12 20h9"/><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>
                                        </svg>
                                    </a>
                                </div>
                            </div>
                            <div class="desc">${cat.description}</div>
                            <div class="meta">
                                <div class="meta-item">
                                    <div class="meta-label">Loại</div>
                                    <div class="meta-value" style="color:var(--info);">
                                        <c:choose>
                                            <c:when test="${cat.type == 'brand'}">Hãng sản xuất</c:when>
                                            <c:when test="${cat.type == 'fuel_type'}">Loại nhiên liệu</c:when>
                                            <c:when test="${cat.type == 'power_range'}">Dải công suất</c:when>
                                            <c:when test="${cat.type == 'generator_type'}">Loại máy</c:when>
                                            <c:when test="${cat.type == 'phase'}">Loại pha</c:when>
                                            <c:when test="${cat.type == 'condition'}">Tình trạng</c:when>
                                            <c:otherwise>${cat.type}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="meta-item">
                                    <div class="meta-label">Trạng thái</div>
                                    <div class="meta-value" style="color:${cat.status == 'active' ? 'var(--accent)' : 'var(--danger)'}">
                                        ${cat.status == 'active' ? 'Hoạt động' : 'Bị khóa'}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> danh mục</div>
                        <div class="controls">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if><c:if test="${not empty param.filterType}">&filterType=<c:out value="${param.filterType}"/></c:if>" class="page-btn">‹</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                    <c:otherwise><a href="?page=${p}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if><c:if test="${not empty param.filterType}">&filterType=<c:out value="${param.filterType}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if><c:if test="${not empty param.filterType}">&filterType=<c:out value="${param.filterType}"/></c:if>" class="page-btn">›</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                </div>
            </section>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>