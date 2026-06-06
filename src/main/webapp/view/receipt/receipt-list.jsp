<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phiếu nhập/xuất — Warehouse OS</title>
        <!-- fonts + css giữ nguyên -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
                        <h1>Phiếu nhập/xuất</h1>
                        <span class="crumb">/ Kho / Phiếu nhập/xuất</span>
                        <div class="top-actions">
                            <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                                <svg class="icon-sun" viewBox="0 0 24 24">...</svg>
                                <svg class="icon-moon" viewBox="0 0 24 24">...</svg>
                            </button>
                            <a class="btn" href="${pageContext.request.contextPath}/receipt?action=selectOrder">
                            Xem phiếu mua đã duyệt
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/receipt?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu mới
                        </a>
                    </div>
                </header>
                <main>
                    <!-- page-head giữ nguyên -->
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho</div>
                            <h2 class="page-title">Quản lý phiếu nhập/xuất</h2>
                            <div class="page-sub">${totalItems} phiếu</div>
                        </div>
                    </div>
                    <div class="toast-host" id="toastHost"></div>
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
                    <!-- filter giữ nguyên -->
                    <form method="get" action="${pageContext.request.contextPath}/receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, đơn, khách hàng, người tạo" autocomplete="off" />
                        </div>
                        <select class="filter-select" name="type" onchange="this.form.submit()">
                            <option value="">Loại: Tất cả</option>
                            <option value="IMPORT" <c:if test="${typeFilter == 'IMPORT'}">selected</c:if>>Nhập kho</option>
                            <option value="EXPORT" <c:if test="${typeFilter == 'EXPORT'}">selected</c:if>>Xuất kho</option>
                            </select>
                            <select class="filter-select" name="status" onchange="this.form.submit()">
                                <option value="">Trạng thái: Tất cả</option>
                                <option value="PENDING" <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                                <option value="NEEDS_REVISION" <c:if test="${statusFilter == 'NEEDS_REVISION'}">selected</c:if>>Yêu cầu chỉnh sửa</option>
                                <option value="COMPLETED" <c:if test="${statusFilter == 'COMPLETED'}">selected</c:if>>Hoàn thành</option>
                                <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã từ chối</option>
                            </select>
                            <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                                <option value="">Kho: Tất cả</option>
                            <c:forEach var="wh" items="${warehouses}">
                                <option value="${wh.warehouseId}" <c:if test="${whFilter == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                            </c:forEach>
                        </select>
                        <div class="spacer"></div>
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            Tìm kiếm
                        </button>
                        <c:if test="${not empty typeFilter or not empty statusFilter or not empty whFilter or not empty search}">
                            <a href="${pageContext.request.contextPath}/receipt" class="btn">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                Xoá lọc
                            </a>
                        </c:if>
                    </form>
                    <!-- bảng -->
                    <div class="table-card" style="margin-top:16px;">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Loại</th>
                                    <th>Kho</th>
                                    <th>Đơn liên quan</th>
                                    <th>Lý do</th>
                                    <th>Người tạo</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty receiptList}">
                                        <tr><td colspan="10">
                                                <div class="empty-state"><strong>Không tìm thấy phiếu nào</strong></div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="r" items="${receiptList}">
                                            <tr>
                                                <td><strong>${r.receiptCode}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.receiptType == 'IMPORT'}">
                                                            <span style="color:#155724;background:#d4edda;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;">Nhập kho</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:#004085;background:#cce5ff;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;">Xuất kho</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.warehouseName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty r.orderCode}">
                                                            <a href="${pageContext.request.contextPath}/order?action=detail&id=${r.orderId}" style="font-family:monospace;font-size:12px;">${r.orderCode}</a>
                                                            <div style="font-size:11px;color:var(--muted);">${r.customerName}</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty r.reasonName}">
                                                            <span class="status-pill status-pending"><span class="pdot"></span>${r.reasonName}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.createdByName}</td>
                                                <td class="mono">
                                                    <c:choose>
                                                        <c:when test="${not empty r.totalAmount}">
                                                            <fmt:formatNumber value="${r.totalAmount}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                                        </c:when>
                                                        <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.status == 'PENDING'}">
                                                            <span class="status active" style="--dot:var(--warn);"><span class="sdot"></span>Chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'NEEDS_REVISION'}">
                                                            <span class="status active" style="--dot:var(--warn);background:var(--warn-soft);color:var(--warn);"><span class="sdot"></span>Yêu cầu chỉnh sửa</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'COMPLETED'}">
                                                            <span class="status active"><span class="sdot"></span>Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'CANCELLED'}">
                                                            <span class="status locked"><span class="sdot"></span>Đã từ chối</span>
                                                        </c:when>
                                                        <c:otherwise>${r.status}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.createdAt}</td>
                                                <td class="col-actions">
                                                    <div class="row-actions">
                                                        <a href="${pageContext.request.contextPath}/receipt?action=detail&id=${r.receiptId}" class="icon-mini" title="Xem chi tiết">
                                                            <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                        </a>
                                                        <c:if test="${r.status == 'NEEDS_REVISION' && r.createdBy == sessionScope.loggedUser.id}">
                                                            <a href="${pageContext.request.contextPath}/receipt?action=edit&id=${r.receiptId}" class="icon-mini" title="Chỉnh sửa và gửi lại" style="color:var(--warn);">
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
                        <!-- pagination -->
                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty typeFilter}">
                            <c:set var="filterParams" value="${filterParams}&type=${typeFilter}" />
                        </c:if>
                        <c:if test="${not empty statusFilter}">
                            <c:set var="filterParams" value="${filterParams}&status=${statusFilter}" />
                        </c:if>
                        <c:if test="${not empty whFilter}">
                            <c:set var="filterParams" value="${filterParams}&warehouse=${whFilter}" />
                        </c:if>
                        <c:if test="${not empty search}">
                            <c:set var="filterParams" value="${filterParams}&search=${search}" />
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
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
