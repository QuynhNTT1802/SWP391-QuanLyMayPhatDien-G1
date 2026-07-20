<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    java.time.format.DateTimeFormatter __poFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("poFmt", __poFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý phiếu mua — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-list.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Kinh doanh</a> / Phiếu mua</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Danh sách phiếu mua</h2>
                            <div class="page-sub">${totalPOs} phiếu mua</div>
                        </div>
                        <c:set var="perms" value="${sessionScope.userPermissions}"/>
                        <c:set var="canCreatePo" value="${perms.contains('purchase_orders.create')}"/>
                        
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.message}"/>', type: 'success'};
                            <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.toastMessage}">
                            window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/purchase-order" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />

                        <input type="date" class="filter-select" name="dateFrom" value="${dateFrom}"
                               title="Từ ngày" onchange="this.form.submit()" />
                        <input type="date" class="filter-select" name="dateTo" value="${dateTo}"
                               title="Đến ngày" onchange="this.form.submit()" />

                        <select class="filter-select" name="warehouseId" onchange="this.form.submit()">
                            <option value="">Kho: Tất cả</option>
                            <c:forEach var="w" items="${warehouses}">
                                <option value="${w.warehouseId}" <c:if test="${warehouseId == w.warehouseId}">selected</c:if>>${w.name}</option>
                            </c:forEach>
                        </select>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>

                            <%-- Sale Staff (chỉ có view): thấy trạng thái cuối, KHÔNG có Chờ CEO duyệt --%>
                            <c:if test="${perms.contains('purchase_orders.view') and !perms.contains('purchase_orders.create') and !perms.contains('purchase_orders.approve')}">
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>

                            <%-- CEO (chỉ có approve): thấy Chờ CEO, Đã duyệt, Từ chối, Cần chỉnh sửa --%>
                            <c:if test="${perms.contains('purchase_orders.approve') and !perms.contains('purchase_orders.create')}">
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO duyệt</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                            </c:if>

                            <%-- Sale Manager (có create + view): thấy Chờ CEO, Đã duyệt, Từ chối, Cần chỉnh sửa, Đã hủy --%>
                            <c:if test="${perms.contains('purchase_orders.create') and !perms.contains('purchase_orders.approve')}">
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO duyệt</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>

                            <%-- Có cả create + approve (admin/PM): thấy tất cả status --%>
                            <c:if test="${perms.contains('purchase_orders.approve') and perms.contains('purchase_orders.create')}">
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO duyệt</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" onclick="location.href = '${pageContext.request.contextPath}/purchase-order?action=list'">
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <table class="users" id="poTable">
                            <thead>
                                <tr>
                                    <th>Mã PO</th>
                                    <th>Tháng</th>
                                    <th>Kho</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>SL đề xuất</th>
                                    <th class="col-status">Trạng thái</th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty purchaseOrders}">
                                        <tr><td colspan="7" style="text-align:center; padding:20px; color:var(--muted);">Chưa có phiếu mua nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="po" items="${purchaseOrders}">
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}" class="code-link"><c:out value="${po.poCode}"/></a></td>
                                                <td><c:out value="${po.period}"/></td>
                                                <td><c:out value="${po.warehouseName}"/></td>
                                                <td><c:out value="${po.createdByName}"/></td>
                                                <td>${po.createdAt.format(poFmt)}</td>
                                                <td>${po.totalQuantity}</td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${po.status == 'PENDING_CEO'}"><span class="status-pill status-pending_ceo">Chờ CEO duyệt</span></c:when>
                                                        <c:when test="${po.status == 'APPROVED'}"><span class="status-pill status-approved">Đã duyệt bởi CEO</span></c:when>
                                                        <c:when test="${po.status == 'REJECTED'}"><span class="status-pill status-rejected">Từ chối bởi CEO</span></c:when>
                                                        <c:when test="${po.status == 'CANCELLED'}"><span class="status-pill status-cancelled">Đã hủy</span></c:when>
                                                        <c:otherwise><span class="status-pill"><c:out value="${po.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <div class="info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-list.js"></script>
    </body>
</html>
