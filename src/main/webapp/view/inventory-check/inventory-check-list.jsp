<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Kiểm kê — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory-check.css">
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>

        <div>
            <header class="topbar">
                <h1>Kiểm kê</h1>
                <span class="crumb">/ Kho / Kiểm kê</span>
                <div class="top-actions">
                    <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    </button>
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/inventory-check?action=create">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                        Tạo phiếu kiểm kê
                    </a>
                </div>
            </header>

            <main>
                <div class="page-head">
                    <div class="left">
                        <div class="eyebrow">Kho</div>
                        <h2 class="page-title">Quản lý kiểm kê</h2>
                        <div class="page-sub">${totalItems} phiếu</div>
                    </div>
                </div>

                <div class="stats-row">
                    <div class="stat"><div class="lbl">Tổng số phiếu</div><div class="val">${totalChecks}</div></div>
                    <div class="stat stat-dng"><div class="lbl">Đang kiểm kê</div><div class="val">${doingCount}</div></div>
                    <div class="stat stat-hoan"><div class="lbl">Đã hoàn thành</div><div class="val">${completedCount}</div></div>
                </div>

                <c:if test="${not empty sessionScope.toastMessage}">
                    <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                        <c:out value="${sessionScope.toastMessage}"/>
                    </div>
                    <c:remove var="toastMessage" scope="session"/>
                </c:if>

                <form method="get" action="${pageContext.request.contextPath}/inventory-check" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                    <input type="hidden" name="action" value="list" />
                    <input type="hidden" name="page" value="1" />
                    <div class="search-input">
                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                        <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu..." autocomplete="off" />
                    </div>
                    <select class="filter-select" name="warehouseId" onchange="this.form.submit()">
                        <option value="">Kho: Tất cả</option>
                        <c:forEach var="wh" items="${warehouses}">
                            <option value="${wh.warehouseId}" <c:if test="${selectedWarehouse == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                        </c:forEach>
                    </select>
                    <select class="filter-select" name="status" onchange="this.form.submit()">
                        <option value="">Trạng thái: Tất cả</option>
                        <option value="doing" <c:if test="${selectedStatus == 'doing'}">selected</c:if>>Đang kiểm kê</option>
                        <option value="completed" <c:if test="${selectedStatus == 'completed'}">selected</c:if>>Đã hoàn thành</option>
                    </select>
                    <div class="spacer"></div>
                    <button type="submit" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                        Tìm kiếm
                    </button>
                    <c:if test="${not empty search or not empty selectedWarehouse or not empty selectedStatus}">
                        <a href="${pageContext.request.contextPath}/inventory-check" class="btn">
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
                                <th>Mã phiếu</th>
                                <th>Trạng thái</th>
                                <th>Người thực hiện</th>
                                <th>Kho kiểm kê</th>
                                <th>Thời gian bắt đầu</th>
                                <th>Thời gian kết thúc</th>
                                <th class="col-actions">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty checkList}">
                                    <tr><td colspan="8">
                                        <div class="empty-state"><strong>Không tìm thấy phiếu kiểm kê</strong></div>
                                    </td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${checkList}" varStatus="st">
                                        <tr onclick="if (!event.target.closest('button,a')) location.href = '${pageContext.request.contextPath}/inventory-check?action=detail&id=${c.id}'" style="cursor:pointer;">
                                            <td>${fromIndex + st.index}</td>
                                            <td><strong><c:out value="${c.checkCode}"/></strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.status == 'doing'}">
                                                        <span class="status-doing"><span class="sdot"></span>Đang kiểm kê</span>
                                                    </c:when>
                                                    <c:when test="${c.status == 'completed'}">
                                                        <span class="status-completed"><span class="sdot"></span>Đã hoàn thành</span>
                                                    </c:when>
                                                    <c:otherwise><c:out value="${c.status}"/></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:out value="${c.createdByName}"/></td>
                                            <td><c:out value="${c.warehouseName}"/></td>
                                            <td style="font-size:12px;color:var(--muted);">${c.startedAt}</td>
                                            <td style="font-size:12px;color:var(--muted);">
                                                <c:choose>
                                                    <c:when test="${not empty c.completedAt}">${c.completedAt}</c:when>
                                                    <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="col-actions">
                                                <div class="row-actions">
                                                    <a href="${pageContext.request.contextPath}/inventory-check?action=detail&id=${c.id}" class="icon-mini" title="Xem chi tiết">
                                                        <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                    </a>
                                                    <c:if test="${c.status == 'doing'}">
                                                        <a href="${pageContext.request.contextPath}/inventory-check?action=edit&id=${c.id}" class="icon-mini" title="Chỉnh sửa" style="color:var(--warn);">
                                                            <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                        </a>
                                                    </c:if>
                                                </div>
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
                    <c:if test="${not empty selectedWarehouse}">
                        <c:set var="filterParams" value="${filterParams}&warehouseId=${selectedWarehouse}" />
                    </c:if>
                    <c:if test="${not empty selectedStatus}">
                        <c:set var="filterParams" value="${filterParams}&status=${selectedStatus}" />
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

    <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/inventory-check.js"></script>
</body>
</html>