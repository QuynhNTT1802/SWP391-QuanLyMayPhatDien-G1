<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chọn phiếu mua — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
            <h1>Phiếu mua bán đã duyệt</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/receipt">Phiếu nhập/xuất</a> / Chọn phiếu mua</span>
        </header>

        <main>
            <a href="${pageContext.request.contextPath}/receipt" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại
            </a>

            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Chọn phiếu mua bán đã duyệt</h2>
                    <div class="page-sub">${empty approvedOrders ? 0 : approvedOrders.size()} đơn hàng</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty approvedOrders}">
                    <div style="text-align:center;padding:40px;color:var(--muted);">
                        Không có đơn hàng nào đã duyệt.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày duyệt</th>
                                    <th>Tổng tiền</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="o" items="${approvedOrders}">
                                    <tr>
                                        <td><strong style="font-family:monospace;">${o.orderCode}</strong></td>
                                        <td>${o.customerName}</td>
                                        <td><fmt:formatDate value="${o.approvedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td style="font-weight:600;color:var(--accent);">
                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="col-actions">
                                            <a href="${pageContext.request.contextPath}/receipt?action=create&orderId=${o.orderId}" class="btn btn-primary" style="font-size:12px;padding:4px 10px;">
                                                Tạo phiếu nhập xuất
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>