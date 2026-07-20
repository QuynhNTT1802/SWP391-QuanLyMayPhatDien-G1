<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phân quyền</title>

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
                        <h1>Phân quyền</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/dashboard">Quản trị</a> / Phân quyền</span>
                        <div class="top-actions">
                            <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                                <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                                <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/role/edit" class="btn btn-primary" style="text-decoration: none;">
                            <svg class="icon" viewBox="0 0 24 24" style="width:16px;height:16px;fill:none;stroke:currentColor;stroke-width:2;"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo vai trò mới
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="eyebrow">Quản trị phân quyền hệ thống </div>
                        <h2>Vai trò &amp; phân quyền</h2>
                        <p>Quản lý các vai trò trong hệ thống. Mỗi vai trò định nghĩa quyền truy cập tới các module qua các hành động tương ứng.</p>
                    </div>

                    <form method="GET" action="${pageContext.request.contextPath}/admin/roles" class="search-bar">
                        <div class="input has-icon" style="max-width: 360px;">
                            <span class="leading">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                            </span>
                            <input type="text" name="search" id="roleSearch" placeholder="Tìm kiếm vai trò theo tên hoặc mô tả..." value="${param.search}" autocomplete="off">
                        </div>
                        <c:if test="${not empty param.search}">
                            <span class="search-count">${roleList.size()} vai trò</span>
                        </c:if>
                    </form>

                    <section id="view-list">
                        <div class="card-table">
                        <div class="roles-grid" id="rolesGrid">

                            <c:forEach var="role" items="${roleList}">

                                <div class="role-card tone-info">
                                    <div class="head">
                                        <div class="role-icon">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2" />
                                            <circle cx="12" cy="7" r="4" />
                                            </svg>

                                        </div>

                                        <div class="head-body">
                                            <h3>${role.roleName}</h3>
                                        </div>

                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/role/edit?id=${role.roleId}" class="icon-tiny" title="Chỉnh sửa">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M12 20h9"/>
                                                <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"/>
                                                </svg>


                                            </a>
                                        </div>
                                    </div>

                                    <div class="desc">${role.description}</div>

                                    <div class="meta">
                                        <div class="meta-item">
                                            <div class="meta-label">Trạng thái</div>
                                            <div class="meta-value" style="color:${role.status == 'active' ? 'var(--accent)' : 'var(--danger)'}">
                                                ${role.status == 'active' ? 'Hoạt động' : 'Bị Khóa'}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>

                        </div>

                        <c:if test="${totalPages > 1}">
                            <div class="pagination">
                                <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> vai trò</div>
                                <div class="controls">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">‹</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                        <c:choose>
                                            <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                            <c:otherwise><a href="?page=${p}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">›</a>
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
        <script src="${pageContext.request.contextPath}/assets/js/role/rbac-roles.js"></script>
    </body>
</html>
