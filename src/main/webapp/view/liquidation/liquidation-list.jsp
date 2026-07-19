<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Đơn thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
    <style>
        .liquidation-list .table-card table.users { min-width: 900px; }
        .liquidation-list table.users th,
        .liquidation-list table.users td { padding: 9px 10px; }
        @media (max-width: 1100px) {
            .liquidation-list table.users th:nth-child(4),
            .liquidation-list table.users td:nth-child(4) { display: none; }
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Đơn thanh lý</h1>
            <span class="crumb">/ Quản lý kho / Thanh lý</span>
            <div class="top-actions">
                <jsp:include page="../common/admin/bell.jsp"/>
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create')}">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/liquidations?action=create">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                        Tạo đơn thanh lý
                    </a>
                </c:if>
            </div>
        </header>
        <main class="liquidation-list">
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Quản lý thanh lý</h2>
                    <div class="page-sub">Theo dõi và xử lý các đơn thanh lý thiết bị</div>
                </div>
            </div>

            <c:set var="kpiCount" value="1"/>
<<<<<<< HEAD
            <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_manager')}"><c:set var="kpiCount" value="${kpiCount + 1}"/></c:if>
            <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_ceo')}"><c:set var="kpiCount" value="${kpiCount + 1}"/></c:if>
            <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create')}"><c:set var="kpiCount" value="${kpiCount + 2}"/></c:if>
=======
            <c:if test="${canSeeCeoKpi}"><c:set var="kpiCount" value="${kpiCount + 2}"/></c:if>
            <c:if test="${canSeeEditKpi}"><c:set var="kpiCount" value="${kpiCount + 2}"/></c:if>
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
            <div class="stats-row liq-stats" style="--kpi-cols: ${kpiCount};">
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_manager')}">
                    <div class="stat">
                        <div class="lbl">Chờ Quản lý duyệt</div>
                        <div class="val">${kpiPendingManager}</div>
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.approve_ceo')}">
                    <div class="stat">
                        <div class="lbl">Chờ Sếp duyệt</div>
                        <div class="val">${kpiPendingCeo}</div>
                    </div>
                    <div class="stat">
                        <div class="lbl">Đã duyệt</div>
                        <div class="val">${kpiApproved}</div>
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create')}">
                    <div class="stat">
                        <div class="lbl">Bị yêu cầu sửa</div>
                        <div class="val">${kpiRequestEdit}</div>
                    </div>
                    <div class="stat">
                        <div class="lbl">Đã hủy</div>
                        <div class="val">${kpiRejected}</div>
                    </div>
                </c:if>
                <div class="stat">
                    <div class="lbl">Đã xuất</div>
                    <div class="val">${kpiCompleted}</div>
                </div>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/liquidations" class="toolbar">
                <input type="hidden" name="action" value="list"/>
                <input type="hidden" name="page" value="1"/>
                <div class="search-input">
                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo Mã đơn, Người tạo..." autocomplete="off" />
                </div>
                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Trạng thái: Tất cả</option>
                    <c:if test="${not empty sessionScope.userPermissions and (sessionScope.userPermissions.contains('liquidations.create') or sessionScope.userPermissions.contains('liquidations.approve_ceo'))}">
                        <option value="PENDING_CEO" ${statusFilter == 'PENDING_CEO' ? 'selected' : ''}>Chờ Sếp duyệt</option>
                        <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>Đã duyệt chờ xuất</option>
                        <option value="CEO_REQUEST_EDIT" ${statusFilter == 'CEO_REQUEST_EDIT' ? 'selected' : ''}>Sếp yêu cầu sửa</option>
                        <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                    </c:if>
                    <option value="COMPLETED" ${statusFilter == 'COMPLETED' ? 'selected' : ''}>Đã xuất kho</option>
                </select>
                <div class="spacer"></div>
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

            <div class="table-card">
                <table class="users">
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Người tạo</th>
                            <th>Lý do</th>
                            <th>Khách hàng</th>
                            <th>Số máy</th>
                            <th>Tổng giá TL</th>
                            <th>Ngày tạo</th>
                            <th>Trạng thái</th>
                            <th class="col-actions">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty liquidations}">
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <div class="icon-wrap">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><line x1="10" y1="9" x2="8" y2="9"/></svg>
                                            </div>
                                            <c:choose>
                                                <c:when test="${not empty statusFilter or not empty search}">
                                                    <strong>Không tìm thấy đơn nào khớp bộ lọc</strong>
                                                    <p>Thử thay đổi từ khoá tìm kiếm hoặc trạng thái lọc.</p>
                                                    <div class="clear-filter-hint">
                                                        <a href="${pageContext.request.contextPath}/liquidations">Xoá lọc và xem tất cả</a>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <strong>Chưa có đơn thanh lý nào</strong>
                                                    <p>Tạo đơn mới để bắt đầu quy trình thanh lý thiết bị.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="liq" items="${liquidations}">
                                    <tr onclick="window.location.href='${pageContext.request.contextPath}/liquidations?action=detail&id=${liq.liquidationId}'">
                                        <td onclick="event.stopPropagation()">
                                            <span class="code-copy" data-copy="${liq.liquidationCode}" title="Click để sao chép">
                                                <strong class="mono">${liq.liquidationCode}</strong>
                                                <svg class="copy-icon" viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                                            </span>
                                        </td>
                                        <td>${liq.createdByName}</td>
                                        <td>${liq.reasonName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty liq.customerName}">${liq.customerName}</c:when>
                                                <c:otherwise><span style="color:var(--muted-2)">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="mono">
                                            <c:choose>
                                                <c:when test="${not empty liq.detailCount}">${liq.detailCount}</c:when>
                                                <c:otherwise>0</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="mono">
                                            <c:choose>
                                                <c:when test="${not empty liq.totalLiquidationPrice and liq.totalLiquidationPrice > 0}">
                                                    <fmt:formatNumber value="${liq.totalLiquidationPrice}" type="number" maxFractionDigits="0"/>
                                                </c:when>
                                                <c:otherwise><span style="color:var(--muted-2)">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="mono">${liq.createdAt}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${liq.status == 'PENDING_CEO'}">
                                                    <span class="pill liq-pending-ceo"><span class="pdot"></span>Chờ Sếp duyệt</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'APPROVED'}">
                                                    <span class="pill liq-pending-mgr" title="Sếp đã duyệt"><span class="pdot"></span>Đã duyệt</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'COMPLETED'}">
                                                    <span class="pill liq-approved"><span class="pdot"></span>Đã xuất kho</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'CEO_REQUEST_EDIT'}">
                                                    <span class="pill liq-edit" title="Sếp yêu cầu sửa: ${not empty liq.ceoFeedbackName ? liq.ceoFeedbackName : 'Không có lý do'}"><span class="pdot"></span>Yêu cầu sửa</span>
                                                </c:when>
                                                <c:when test="${liq.status == 'CANCELLED'}">
                                                    <span class="pill liq-cancelled"><span class="pdot"></span>Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="pill liq-muted"><span class="pdot"></span>${liq.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-actions" onclick="event.stopPropagation()">
                                            <div class="row-actions">
                                                <a href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liq.liquidationId}" class="icon-mini" title="Xem chi tiết">
                                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                </a>
                                                <c:if test="${not empty sessionScope.userPermissions and sessionScope.userPermissions.contains('liquidations.create') and liq.status == 'CEO_REQUEST_EDIT'}">
                                                    <a href="${pageContext.request.contextPath}/liquidations?action=edit_view&id=${liq.liquidationId}" class="icon-mini" title="Sửa đơn">
                                                        <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
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

                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <div class="info">
                            Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        </div>
                        <div class="controls">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}&search=${search}&status=${statusFilter}" class="page-btn">‹</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn" style="opacity:0.4;cursor:not-allowed">‹</span>
                                </c:otherwise>
                            </c:choose>
                            <c:set var="windowSize" value="2"/>
                            <c:set var="winStart" value="${currentPage - windowSize}"/>
                            <c:set var="winEnd" value="${currentPage + windowSize}"/>
                            <c:if test="${winStart < 1}"><c:set var="winStart" value="1"/></c:if>
                            <c:if test="${winEnd > totalPages}"><c:set var="winEnd" value="${totalPages}"/></c:if>
                            <c:if test="${winStart > 1}">
                                <a href="?action=list&page=1&search=${search}&status=${statusFilter}" class="page-btn ${1 == currentPage ? 'active' : ''}">1</a>
                                <c:if test="${winStart > 2}"><span class="ellipsis">…</span></c:if>
                            </c:if>
                            <c:forEach begin="${winStart}" end="${winEnd}" var="p">
                                <a href="?action=list&page=${p}&search=${search}&status=${statusFilter}" class="page-btn ${p == currentPage ? 'active' : ''}">${p}</a>
                            </c:forEach>
                            <c:if test="${winEnd < totalPages}">
                                <c:if test="${winEnd < totalPages - 1}"><span class="ellipsis">…</span></c:if>
                                <a href="?action=list&page=${totalPages}&search=${search}&status=${statusFilter}" class="page-btn ${totalPages == currentPage ? 'active' : ''}">${totalPages}</a>
                            </c:if>
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}&search=${search}&status=${statusFilter}" class="page-btn">›</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn" style="opacity:0.4;cursor:not-allowed">›</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    document.querySelectorAll('.code-copy').forEach(function(el) {
        el.addEventListener('click', function(e) {
            e.stopPropagation();
            var text = el.getAttribute('data-copy');
            if (!text) return;
            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(text).then(function() { flashCopied(el); });
            } else {
                var ta = document.createElement('textarea');
                ta.value = text;
                document.body.appendChild(ta);
                ta.select();
                try { document.execCommand('copy'); flashCopied(el); } catch (err) {}
                document.body.removeChild(ta);
            }
        });
    });
    function flashCopied(el) {
        el.classList.add('copied');
        var oldTitle = el.getAttribute('title');
        el.setAttribute('title', 'Đã sao chép ✓');
        setTimeout(function() {
            el.classList.remove('copied');
            el.setAttribute('title', oldTitle || 'Click để sao chép');
        }, 1200);
    }
</script>
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
    <c:if test="${not empty param.error}">
    window.SESSION_DATA = window.SESSION_DATA || {};
    window.SESSION_DATA.message = '<c:out value="${param.error}"/>';
    window.SESSION_DATA.type = 'danger';
    </c:if>
    <c:if test="${not empty param.success}">
    window.SESSION_DATA = window.SESSION_DATA || {};
    window.SESSION_DATA.message = '<c:out value="${param.success}"/>';
    window.SESSION_DATA.type = 'success';
    </c:if>
</script>
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script>
    if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
    }
</script>
</body>
</html>