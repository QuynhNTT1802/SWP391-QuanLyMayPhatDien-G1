<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Danh sách thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
            <h1>Đơn thanh lý</h1>
            <span class="crumb">/ Quản lý kho / Thanh lý</span>
            <div class="top-actions">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/liquidations?action=create">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                    Tạo đơn thanh lý
                </a>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Quản lý thanh lý</h2>
                    <div class="page-sub">Danh sách các đơn thanh lý</div>
                </div>
            </div>

            <div class="kpi-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-top: 20px;">
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_manager')}">
                <div class="kpi-card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase;">Cần Quản lý duyệt</div>
                    <div style="font-size: 28px; font-weight: 700; margin-top: 8px; color: var(--text);">${kpiPendingManager}</div>
                </div>
                </c:if>

                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_ceo')}">
                <div class="kpi-card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase;">Cần Sếp duyệt</div>
                    <div style="font-size: 28px; font-weight: 700; margin-top: 8px; color: var(--text);">${kpiPendingCeo}</div>
                </div>
                </c:if>

                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create')}">
                <div class="kpi-card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase;">Bị yêu cầu sửa</div>
                    <div style="font-size: 28px; font-weight: 700; margin-top: 8px; color: var(--text);">${kpiRequestEdit}</div>
                </div>
                </c:if>

                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create')}">
                <div class="kpi-card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase;">Đã bị hủy</div>
                    <div style="font-size: 28px; font-weight: 700; margin-top: 8px; color: var(--text);">${kpiRejected}</div>
                </div>
                </c:if>

                <c:if test="${not empty sessionScope.userPermissions and (sessionScope.userPermissions.contains('liquidations.approve_manager') or sessionScope.userPermissions.contains('liquidations.approve_ceo'))}">
                <div class="kpi-card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                    <div style="font-size: 12px; color: var(--muted); font-weight: 600; text-transform: uppercase;">Đã xuất thành công</div>
                    <div style="font-size: 28px; font-weight: 700; margin-top: 8px; color: var(--text);">${kpiApproved}</div>
                </div>
                </c:if>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/liquidations" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin-top:20px;">
                <input type="hidden" name="action" value="list"/>
                <input type="hidden" name="page" value="1"/>
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo Mã đơn, Người tạo..." autocomplete="off" />
                </div>
                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Trạng thái: Tất cả</option>
                    
                    <c:if test="${not empty sessionScope.userPermissions and (sessionScope.userPermissions.contains('liquidations.create') or sessionScope.userPermissions.contains('liquidations.approve_manager'))}">
                        <option value="PENDING_MANAGER" ${statusFilter == 'PENDING_MANAGER' ? 'selected' : ''}>Chờ Quản lý duyệt</option>
                        <option value="MANAGER_REQUEST_EDIT" ${statusFilter == 'MANAGER_REQUEST_EDIT' ? 'selected' : ''}>Quản lý yêu cầu sửa</option>
                        <option value="REJECTED_BY_MANAGER" ${statusFilter == 'REJECTED_BY_MANAGER' ? 'selected' : ''}>Quản lý từ chối</option>
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.userPermissions and (sessionScope.userPermissions.contains('liquidations.create') or sessionScope.userPermissions.contains('liquidations.approve_ceo') or sessionScope.userPermissions.contains('liquidations.approve_manager'))}">
                        <option value="PENDING_CEO" ${statusFilter == 'PENDING_CEO' ? 'selected' : ''}>Chờ Sếp duyệt</option>
                        <option value="CEO_REQUEST_EDIT" ${statusFilter == 'CEO_REQUEST_EDIT' ? 'selected' : ''}>Sếp yêu cầu sửa</option>
                        <option value="REJECTED_BY_CEO" ${statusFilter == 'REJECTED_BY_CEO' ? 'selected' : ''}>Sếp từ chối</option>
                    </c:if>
                    
                    <option value="APPROVED_BY_CEO" ${statusFilter == 'APPROVED_BY_CEO' ? 'selected' : ''}>Đã duyệt</option>
                </select>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <c:if test="${not empty statusFilter or not empty search}">
                    <a href="${pageContext.request.contextPath}/liquidations" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xóa lọc
                    </a>
                </c:if>
            </form>

            <div class="table-card" style="margin-top:16px;">
                <table class="users">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Người tạo</th>
                            <th>Lý do</th>
                            <th>Khách hàng</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th class="col-actions">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty liquidations}">
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state"><strong>Không có đơn thanh lý nào.</strong></div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="liq" items="${liquidations}">
                                    <tr>
                                        <td><strong>${liq.liquidationCode}</strong></td>
                                        <td>${liq.createdByName}</td>
                                        <td>${liq.reasonName}</td>
                                        <td>${not empty liq.customerName ? liq.customerName : '<span style="color:var(--muted)">--</span>'}</td>
                                        <td>${liq.createdAt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${liq.status == 'PENDING_MANAGER'}">
                                                    <span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ Quản lý duyệt</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'PENDING_CEO'}">
                                                    <span class="pill" style="color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft);"><span class="pdot" style="background: var(--purple);"></span>Chờ Sếp duyệt</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'APPROVED_BY_CEO'}">
                                                    <span class="pill" style="color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft);"><span class="pdot" style="background: var(--accent);"></span>Đã duyệt (Đã xuất)</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'CEO_REQUEST_EDIT' or liq.status == 'MANAGER_REQUEST_EDIT'}">
                                                    <span class="pill" style="color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft);"><span class="pdot" style="background: var(--warn);"></span>Bị yêu cầu sửa</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'REJECTED_BY_MANAGER' or liq.status == 'REJECTED_BY_CEO'}">
                                                    <span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Đã bị hủy</span>
                                                </c:when>
                                                <c:otherwise><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>${liq.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-actions">
                                            <div class="row-actions">
                                                <a href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liq.liquidationId}" class="icon-mini" title="Xem chi tiết">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="margin-top: 16px; display: flex; justify-content: space-between; align-items: center;">
                        <div class="info" style="font-size: 13px; color: var(--muted);">
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        </div>
                        <div class="controls" style="display: flex; gap: 4px;">
                            <a href="?action=list&page=${currentPage - 1}&search=${search}&status=${statusFilter}" class="page-btn" ${currentPage == 1 ? 'style="pointer-events: none; opacity: 0.5;"' : ''}>Trước</a>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="?action=list&page=${p}&search=${search}&status=${statusFilter}" class="page-btn ${p == currentPage ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            <a href="?action=list&page=${currentPage + 1}&search=${search}&status=${statusFilter}" class="page-btn" ${currentPage == totalPages ? 'style="pointer-events: none; opacity: 0.5;"' : ''}>Sau</a>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
