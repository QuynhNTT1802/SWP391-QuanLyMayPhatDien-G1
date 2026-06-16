<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết khách hàng — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory-check.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết khách hàng</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/customers?action=list">Khách hàng</a> / <span id="crumbId"><c:out value="${customer.name}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="${pageContext.request.contextPath}/warehouse/customers?action=update&id=${customer.id}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
                <c:choose>
                    <c:when test="${customer.status == 'active'}">
                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/warehouse/customers?action=deactivate&id=${customer.id}">
                            Khóa
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse/customers?action=activate&id=${customer.id}">
                            Kích hoạt
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse/customers?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar purple"><c:out value="${customer.name.substring(0,2)}"/></div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${customer.name}"/>
                        <c:if test="${not empty customerTypeName}">
                            <span class="verified"><c:out value="${customerTypeName}"/></span>
                        </c:if>
                    </h2>
                    <div class="hero-meta">
                        <span class="mono"><c:out value="${customer.phone}"/></span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${customer.id}"/></span>
                        <span class="sep">·</span>
                        <span>Tạo ngày <c:out value="${createdDate}"/></span>
                    </div>
                    <div class="hero-pills">
                        <c:choose>
                            <c:when test="${customer.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${customer.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                        </c:choose>
                    </div>
                </div>
            </div>
                        <div class="section" style="padding: 18px 22px;">
                            <div class="tabs">
                                <button type="button" class="tab active" data-tab="info">Thông tin cơ bản</button>
                                <button type="button" class="tab" data-tab="orders">Đơn hàng</button>
                                <c:if test="${not empty activityLogs}">
                                    <button type="button" class="tab" data-tab="history">Nhật ký hoạt động</button>
                                </c:if>
                            </div>

                            <div class="tab-panel active" id="tab-info">
                                ...giữ nguyên info-grid từ section #basic hiện tại...
                            </div>

                            <div class="tab-panel" id="tab-orders">
                                <c:if test="${empty customerOrders}">
                                    <div style="padding:24px;text-align:center;color:var(--muted);font-size:14px;">Khách hàng chưa có đơn hàng nào.</div>
                                </c:if>
                                <c:if test="${not empty customerOrders}">
                                    <table class="detail-table">
                                        <thead>
                                            <tr>
                                                <th style="width:40px;">#</th>
                                                <th>Mã đơn</th>
                                                <th>Trạng thái</th>
                                                <th>Tổng tiền</th>
                                                <th>Người tạo</th>
                                                <th>Ngày đặt</th>
                                                <th style="width:80px;">Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="o" items="${customerOrders}" varStatus="st">
                                                <tr>
                                                    <td>${st.index + 1}</td>
                                                    <td><strong><a href="${pageContext.request.contextPath}/order?action=detail&id=${o.orderId}">${o.orderCode}</a></strong></td>
                                                    <td><span class="order-status ${o.status}">...</span></td>
                                                    <td><fmt:formatNumber value="${o.totalAmount}" pattern="#,##0" />₫</td>
                                                    <td>${o.createdByName}</td>
                                                    <td class="mono">${o.orderDate}</td>
                                                    <td><a href="${pageContext.request.contextPath}/order?action=detail&id=${o.orderId}" class="btn-sm">Xem</a></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>
                            </div>

                            <c:if test="${not empty activityLogs}">
                                <section class="section" id="logs">
                                    <div class="section-head">
                                        <div>
                                            <div class="section-num">02 — NHẬT KÝ HOẠT ĐỘNG</div>
                                            <h3 class="section-title">Lịch sử thao tác</h3>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${empty activityLogs}">
                                            <div class="actlog-empty">Chưa có hoạt động nào.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <table class="actlog-table">
                                                <thead>
                                                    <tr>
                                                        <th class="col-user">Người thực hiện</th>
                                                        <th>Hành động</th>
                                                        <th class="col-time">Thời gian</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="log" items="${activityLogs}" varStatus="st">
                                                        <tr>
                                                            <td class="col-user"><c:out value="${log.username}"/></td>
                                                            <td><c:out value="${log.details}"/></td>
                                                            <td class="col-time"><c:out value="${logDates[st.index]}"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </section>
                            </c:if>
                        </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>