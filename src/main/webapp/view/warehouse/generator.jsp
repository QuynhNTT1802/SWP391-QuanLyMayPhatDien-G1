<%-- 
    Document   : generator
    Created on : May 25, 2026, 5:01:27 PM
    Author     : LENOVO
--%>

<%-- 
    Document   : generator-list
    Created on : May 23, 2026
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý máy phát điện — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Máy phát điện</h1>
                    <span class="crumb">/ <a href="#">Quản trị</a> / Máy phát điện</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/warehouse/generators?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm máy phát điện
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Quản trị · Admin</div>
                            <h2 class="page-title">Quản lý máy phát điện</h2>
                            <div class="page-sub">${totalGenerators} máy</div>
                        </div>
                    </div>

                    <div class="stats-row">
                        <div class="stat"><div class="lbl">Tổng máy</div><div class="val">${totalGenerators}</div></div>
                        <div class="stat"><div class="lbl">Đang hoạt động</div><div class="val">${activeCount}</div></div>
                        <div class="stat"><div class="lbl">Bị khóa</div><div class="val">${lockedCount}</div></div>
                    </div>

                    <c:if test="${not empty sessionScope.message}">
                        <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                            <c:out value="${sessionScope.message}"/>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <form method="get" action="${pageContext.request.contextPath}/warehouse/generators" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value="${searchFilter}"/>" placeholder="Tìm theo mẫu hoặc thương hiệu..." autocomplete="off" />
                        </div>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="active" <c:if test="${statusFilter == 'active'}">selected</c:if>>Đang hoạt động</option>
                            <option value="locked" <c:if test="${statusFilter == 'locked'}">selected</c:if>>Bị khóa</option>
                        </select>
                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <table class="users" id="generatorsTable">
                            <thead>
                                <tr>
                                    <th>Mẫu máy</th>
                                    <th>Công suất</th>
                                    <th>Đơn giá</th>
                                    <th>Tồn kho</th>
                                    <th>Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty generators}">
                                        <tr><td colspan="6">
                                                <div class="empty-state">
                                                    <strong>Không tìm thấy máy phát điện</strong>
                                                </div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="g" items="${generators}">
                                            <tr onclick="if (!event.target.closest('button,a'))
                                                        location.href = '${pageContext.request.contextPath}/warehouse/generators?action=view&id=${g.id}'"
                                                style="cursor:pointer;">
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-name-block">
                                                            <div class="user-name"><c:out value="${g.model}"/></div>
                                                            <div class="user-email"><c:out value="${g.brand}"/></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><span class="mono"><c:out value="${g.powerRating}"/> kVA</span></td>
                                                <td><span class="mono"><fmt:formatNumber value="${g.unitPrice}" pattern="#,###"/> ₫</span></td>
                                                <td><c:out value="${g.stockQuantity}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${g.status == 'active'}"><span class="status active"><span class="sdot"></span>Hoạt động</span></c:when>
                                                        <c:when test="${g.status == 'locked'}"><span class="status locked"><span class="sdot"></span>Bị khóa</span></c:when>
                                                        <c:otherwise><span class="status disabled"><span class="sdot"></span><c:out value="${g.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-actions">
                                                    <div class="row-actions">
                                                        <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/warehouse/generators?action=view&id=${g.id}'" title="Xem chi tiết">
                                                            <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                        </button>
                                                        <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/warehouse/generators?action=update&id=${g.id}&page=${currentPage}'" title="Chỉnh sửa">
                                                            <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                        </button>
                                                        <c:choose>
                                                            <c:when test="${g.status == 'active'}">
                                                                <button class="icon-mini" onclick="confirmDeactivateGenerator(${g.id}, ${currentPage})" title="Khóa">
                                                                    <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button class="icon-mini" onclick="confirmActivateGenerator(${g.id}, ${currentPage})" title="Kích hoạt">
                                                                    <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${currentPage * 10 > totalGenerators ? totalGenerators : currentPage * 10}</strong> / <strong>${totalGenerators}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <div class="modal-host" id="confirmModal">
            <div class="modal">
                <h3 id="modalTitle">Xác nhận hành động</h3>
                <p id="modalText">Bạn có chắc muốn thực hiện hành động này?</p>
                <div class="actions">
                    <button class="btn" id="modalCancel">Hủy</button>
                    <button class="btn btn-danger" id="modalConfirm">Xác nhận</button>
                </div>
            </div>
        </div>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/generator-js.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    </body>
</html>