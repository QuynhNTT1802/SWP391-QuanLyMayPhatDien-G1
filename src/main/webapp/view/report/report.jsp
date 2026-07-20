<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __rptFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
    request.setAttribute("rptFmt", __rptFmt);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo - Warehouse OS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/report.css">
</head>
<body>
<div class="app">
    <c:set var="activePage" value="report-${reportType}" scope="request"/>
    <c:set var="sidebarPermissions" value="${sessionScope.userPermissions}" scope="request"/>
    <jsp:include page="/view/common/admin/aside.jsp"/>

    <main class="main-content">
        <div class="page-head">
            <h2>
                <c:choose>
                    <c:when test="${reportType == 'inventory'}">Báo cáo tồn kho</c:when>
                    <c:when test="${reportType == 'import'}">Báo cáo nhập kho</c:when>
                    <c:when test="${reportType == 'export'}">Báo cáo xuất kho</c:when>
                    <c:when test="${reportType == 'inventory-check'}">Báo cáo kiểm kê</c:when>
                    <c:when test="${reportType == 'purchase'}">Báo cáo mua hàng</c:when>
                    <c:when test="${reportType == 'sales'}">Báo cáo bán hàng</c:when>
                </c:choose>
            </h2>
        </div>

        <div class="report-filter-bar">
            <form method="GET" action="${pageContext.request.contextPath}/reports" class="filter-form">
                <input type="hidden" name="type" value="${reportType}"/>

                <div class="filter-group">
                    <label>Kì báo cáo</label>
                    <div class="filter-row">
                        <select name="month" class="edit-input" style="width:100px;">
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${m == month ? 'selected' : ''}>Tháng ${m}</option>
                            </c:forEach>
                        </select>
                        <input type="number" name="year" value="${year}" class="edit-input" style="width:110px;">
                    </div>
                </div>

                <c:if test="${reportType != 'sales'}">
                    <div class="filter-group">
                        <label>Kho</label>
                        <select name="warehouseId" class="edit-input" style="width:200px;">
                            <option value="">Tất cả</option>
                            <c:forEach var="wh" items="${warehouses}">
                                <option value="${wh.warehouseId}" ${wh.warehouseId == selWarehouseId ? 'selected' : ''}>
                                    <c:out value="${wh.name}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <div class="filter-actions">
                    <button type="submit" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                        Xem
                    </button>
                    <c:if test="${sessionScope.userPermissions.contains('reports.export')}">
                        <button type="button" class="btn btn-success" onclick="exportExcel()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                            Xuất Excel
                        </button>
                    </c:if>
                </div>
            </form>
        </div>

        <div class="report-table-wrap">
            <c:choose>
                <%-- TỒN KHO --%>
                <c:when test="${reportType == 'inventory'}">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Kho</th>
                                <th>Mã máy</th>
                                <th>Model</th>
                                <th>Thương hiệu</th>
                                <th>Tồn đầu kì</th>
                                <th>Nhập trong kì</th>
                                <th>Xuất trong kì</th>
                                <th>Tồn cuối kì</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${inventoryItems}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1 + (currentPage - 1) * 15}</td>
                                    <td><c:out value="${item.warehouseName}"/></td>
                                    <td>${item.generatorId}</td>
                                    <td><c:out value="${item.model}"/></td>
                                    <td><c:out value="${item.brand}"/></td>
                                    <td class="num">${item.openQuantity}</td>
                                    <td class="num">${item.importQuantity}</td>
                                    <td class="num">${item.exportQuantity}</td>
                                    <td class="num">${item.closeQuantity}</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty inventoryItems}">
                                <tr><td colspan="9" class="empty">Không có dữ liệu</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </c:when>

                <%-- NHẬP / XUẤT --%>
                <c:when test="${reportType == 'import' || reportType == 'export'}">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã phiếu</th>
                                <th>Ngày</th>
                                <th>Kho</th>
                                <c:if test="${reportType == 'export'}"><th>Khách hàng</th></c:if>
                                <c:if test="${reportType == 'import'}"><th>Mã PO</th></c:if>
                                <th>Người tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${receiptItems}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1 + (currentPage - 1) * 15}</td>
                                    <td><c:out value="${r.receiptCode}"/></td>
                                    <td>${r.createdAt.format(rptFmt)}</td>
                                    <td><c:out value="${r.warehouseName}"/></td>
                                    <c:if test="${reportType == 'export'}"><td><c:out value="${r.customerName}"/></td></c:if>
                                    <c:if test="${reportType == 'import'}"><td><c:out value="${r.purchaseOrderCode}"/></td></c:if>
                                    <td><c:out value="${r.createdByName}"/></td>
                                    <td><span class="status-badge status-${fn:toLowerCase(r.status)}">
                                        <c:choose>
                                            <c:when test="${r.status == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${r.status == 'PENDING'}">Chờ duyệt</c:when>
                                            <c:when test="${r.status == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:when test="${r.status == 'DRAFT'}">Bản nháp</c:when>
                                            <c:otherwise><c:out value="${r.status}"/></c:otherwise>
                                        </c:choose>
                                    </span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty receiptItems}">
                                <tr><td colspan="7" class="empty">Không có dữ liệu</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </c:when>

                <c:when test="${reportType == 'inventory-check'}">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã phiếu</th>
                                <th>Kho</th>
                                <th>Mã máy</th>
                                <th>Model</th>
                                <th>SL hệ thống</th>
                                <th>SL thực tế</th>
                                <th>Chênh lệch</th>
                                <th>Người tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${checkItems}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1 + (currentPage - 1) * 15}</td>
                                    <td><c:out value="${item.checkCode}"/></td>
                                    <td><c:out value="${item.warehouseName}"/></td>
                                    <td>${item.generatorId}</td>
                                    <td><c:out value="${item.generatorModel}"/></td>
                                    <td class="num">${item.systemQuantity}</td>
                                    <td class="num">${item.actualQuantity}</td>
                                    <td class="num ${item.discrepancy != 0 ? 'text-danger' : ''}">${item.discrepancy}</td>
                                    <td><c:out value="${item.createdByName}"/></td>
                                    <td>
                                        <span class="status-badge ${item.status == 'completed' ? 'status-completed' : 'status-doing'}">
                                            ${item.status == 'completed' ? 'Hoàn thành' : 'Đang kiểm kê'}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty checkItems}">
                                <tr><td colspan="10" class="empty">Không có dữ liệu</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </c:when>

                <c:when test="${reportType == 'purchase'}">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã phiếu</th>
                                <th>Kho</th>
                                <th>Kỳ</th>
                                <th>Số lượng</th>
                                <th>Người tạo</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="po" items="${poItems}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1 + (currentPage - 1) * 15}</td>
                                    <td><c:out value="${po.poCode}"/></td>
                                    <td><c:out value="${po.warehouseName}"/></td>
                                    <td><c:out value="${po.period}"/></td>
                                    <td class="num">${po.totalQuantity}</td>
                                    <td><c:out value="${po.createdByName}"/></td>
                                    <td>${po.createdAt.format(rptFmt)}</td>
                                    <td><span class="status-badge status-${fn:toLowerCase(po.status)}">
                                        <c:choose>
                                            <c:when test="${po.status == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${po.status == 'PENDING'}">Chờ duyệt</c:when>
                                            <c:when test="${po.status == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:when test="${po.status == 'DRAFT'}">Bản nháp</c:when>
                                            <c:otherwise><c:out value="${po.status}"/></c:otherwise>
                                        </c:choose>
                                    </span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty poItems}">
                                <tr><td colspan="8" class="empty">Không có dữ liệu</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </c:when>

                <c:when test="${reportType == 'sales'}">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã đơn</th>
                                <th>Ngày đặt</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Người tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="so" items="${saleItems}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1 + (currentPage - 1) * 15}</td>
                                    <td><c:out value="${so.orderCode}"/></td>
                                    <td><fmt:formatDate value="${so.orderDate}" pattern="dd/MM/yyyy"/></td>
                                    <td><c:out value="${so.customer.name}"/></td>
                                    <td class="num"><fmt:formatNumber value="${so.totalAmount}" pattern="#,##0"/></td>
                                    <td><c:out value="${so.createdByName}"/></td>
                                    <td><span class="status-badge status-${fn:toLowerCase(so.status)}">
                                        <c:choose>
                                            <c:when test="${so.status == 'COMPLETED'}">Hoàn thành</c:when>
                                            <c:when test="${so.status == 'PENDING'}">Chờ duyệt</c:when>
                                            <c:when test="${so.status == 'CANCELLED'}">Đã hủy</c:when>
                                            <c:when test="${so.status == 'APPROVED'}">Đã duyệt</c:when>
                                            <c:otherwise><c:out value="${so.status}"/></c:otherwise>
                                        </c:choose>
                                    </span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty saleItems}">
                                <tr><td colspan="7" class="empty">Không có dữ liệu</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </c:when>
            </c:choose>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="?type=${reportType}&month=${month}&year=${year}&warehouseId=${selWarehouseId}&page=${currentPage - 1}" class="page-link">Trước</a>
                </c:if>
                <c:forEach var="p" begin="1" end="${totalPages}">
                    <c:if test="${p >= currentPage - 2 && p <= currentPage + 2}">
                        <a href="?type=${reportType}&month=${month}&year=${year}&warehouseId=${selWarehouseId}&page=${p}"
                           class="page-link ${p == currentPage ? 'active' : ''}">${p}</a>
                    </c:if>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="?type=${reportType}&month=${month}&year=${year}&warehouseId=${selWarehouseId}&page=${currentPage + 1}" class="page-link">Sau</a>
                </c:if>
                <span class="page-info">${totalItems} bản ghi</span>
            </div>
        </c:if>
    </main>
</div>

<script>
    function exportExcel() {
        var url = '${pageContext.request.contextPath}/reports?action=export&type=${reportType}'
            + '&month=${month}&year=${year}'
            + '&warehouseId=${selWarehouseId}';
        window.location.href = url;
    }
</script>
</body>
</html>