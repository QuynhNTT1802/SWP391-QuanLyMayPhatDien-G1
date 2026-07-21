<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu luân chuyển kho — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển kho</h1>
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
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Quản lý luân chuyển</h2>
                    <div class="page-sub">Danh sách các phiếu luân chuyển giữa các kho</div>
                </div>
            </div>


            <form method="get" action="${pageContext.request.contextPath}/transfers" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-top:20px;">
                <input type="hidden" name="action" value="list"/>
                <input type="hidden" name="page" value="1"/>
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu..." autocomplete="off" />
                </div>
                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Tất cả trạng thái</option>
                    <option value="PENDING_CEO" ${statusFilter == 'PENDING_CEO' ? 'selected' : ''}>Chờ CEO duyệt</option>
                    <option value="REQUEST_REVISION" ${statusFilter == 'REQUEST_REVISION' ? 'selected' : ''}>Yêu cầu chỉnh sửa</option>
                    <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt (chờ tạo phiếu xuất)</option>
                    <option value="EXPORTED" ${statusFilter == 'EXPORTED' ? 'selected' : ''}>Đã xuất (chờ phiếu nhập)</option>
                    <option value="AWAITING_DEST_ACCEPT" ${statusFilter == 'AWAITING_DEST_ACCEPT' ? 'selected' : ''}>Chờ kho đích xác nhận (cũ)</option>
                    <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Hoàn tất</option>
                    <option value="REJECTED" ${statusFilter == 'REJECTED' ? 'selected' : ''}>Bị từ chối</option>
                </select>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty statusFilter or not empty search}">
                    <a href="${pageContext.request.contextPath}/transfers" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xóa lọc
                    </a>
                </c:if>
            </form>

            <div class="table-card" style="margin-top:16px;">
                <table class="users">
                    <thead>
                        <tr>
                            <th>Mã phiếu</th>
                            <th>Kho nguồn → Kho đích</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th class="col-actions">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty transfers}">
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state"><strong>Chưa có phiếu luân chuyển nào.</strong></div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="t" items="${transfers}">
                                    <tr>
                                        <td><strong style="font-family: var(--font-mono);">${t.transferCode}</strong></td>
                                        <td>
                                            <div>${t.sourceWarehouseName}</div>
                                            <div style="color: var(--muted); font-size: 12px;">↓</div>
                                            <div>${t.destWarehouseName}</div>
                                        </td>
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
                                                <c:when test="${t.status == 'PENDING_CEO'}">
                                                    <span class="pill" style="color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft);"><span class="pdot" style="background: var(--purple);"></span>Chờ CEO duyệt</span>
                                                </c:when>
                                                <c:when test="${t.status == 'APPROVED'}">
                                                    <span class="pill" style="color: #0c5460; border-color: color-mix(in srgb, #0c5460 30%, transparent); background: #d1ecf1;"><span class="pdot" style="background: #0c5460;"></span>Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${t.status == 'EXPORTED'}">
                                                    <span class="pill" style="color: #856404; border-color: color-mix(in srgb, #856404 30%, transparent); background: #fff3cd;"><span class="pdot" style="background: #856404;"></span>Đã xuất</span>
                                                </c:when>
                                                <c:when test="${t.status == 'AWAITING_DEST_ACCEPT'}">
                                                    <span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ kho đích (cũ)</span>
                                                </c:when>
                                                <c:when test="${t.status == 'COMPLETED'}">
                                                    <span class="pill" style="color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft);"><span class="pdot" style="background: var(--accent);"></span>Hoàn tất</span>
                                                </c:when>
                                                <c:when test="${t.status == 'REJECTED'}">
                                                    <span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Bị từ chối</span>
                                                </c:when>
                                                <c:when test="${t.status == 'REQUEST_REVISION'}">
                                                    <span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Yêu cầu chỉnh sửa</span>
                                                </c:when>
                                                <c:otherwise><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>${t.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-actions">
                                            <div class="row-actions">
                                                <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}" class="icon-mini" title="Xem chi tiết">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="pagination">
                    <div class="info">Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${currentPage * 10 > total ? total : currentPage * 10}</strong> / <strong>${total}</strong> phiếu</div>
                    <div class="controls">
                        <c:if test="${currentPage > 1}">
                            <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">‹</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if>" class="page-btn">›</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
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
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
