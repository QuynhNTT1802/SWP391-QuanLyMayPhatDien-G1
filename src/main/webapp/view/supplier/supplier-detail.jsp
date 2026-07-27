<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết nhà cung cấp — Warehouse OS</title>
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
            <h1>Chi tiết nhà cung cấp</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">Nhà cung cấp</a> / <span id="crumbId"><c:out value="${supplier.name}"/></span></span>
            <div class="top-actions">
                <a class="btn" href="${pageContext.request.contextPath}/warehouse/suppliers?action=update&id=${supplier.id}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
                <c:choose>
                    <c:when test="${supplier.status == 'active'}">
                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/warehouse/suppliers?action=deactivate&id=${supplier.id}">Khóa</a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse/suppliers?action=activate&id=${supplier.id}">Kích hoạt</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${supplier.name}"/>
                        <c:if test="${not empty supplierTypeName}">
                            <span class="verified"><c:out value="${supplierTypeName}"/></span>
                        </c:if>
                    </h2>
                    <div class="hero-meta">
                        <span class="mono"><c:out value="${supplier.phone}"/></span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${supplier.id}"/></span>
                        <span class="sep">·</span>
                        <span>Tạo ngày <c:out value="${createdDate}"/></span>
                    </div>
                    <div class="hero-pills">
                        <c:choose>
                            <c:when test="${supplier.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${supplier.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="section" style="padding: 18px 22px;">
                <div class="tabs">
                    <button type="button" class="tab active" data-tab="info">Thông tin cơ bản</button>
                    <button type="button" class="tab" data-tab="orders">Đơn hàng</button>
                    <button type="button" class="tab" data-tab="history">Nhật ký hoạt động</button>
                </div>

                <div class="tab-panel active" id="tab-info">
                    <div class="section">
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Tên nhà cung cấp</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${supplier.name}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Số điện thoại</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${supplier.phone}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Email</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty supplier.email ? supplier.email : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Loại nhà cung cấp</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${supplierTypeName}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Trạng thái</label>
                                    <input class="info-input" type="text" disabled value="${supplier.status == 'active' ? 'Đang hoạt động' : (supplier.status == 'locked' ? 'Bị khóa' : '')}">
                                </div>
                            </div>
                            <div class="form-grid cols-5" style="margin-top:14px;">
                                <div class="info-field">
                                    <label>Tên công ty</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty supplier.companyName ? supplier.companyName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Địa chỉ</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty supplier.address ? supplier.address : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày tạo</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${createdDate}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Cập nhật cuối</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${updatedDate}'/>">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-panel" id="tab-orders">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                        <h3 style="font-size:15px;font-weight:700;margin:0;">Đơn mua</h3>
                        <a href="${pageContext.request.contextPath}/purchase-order" class="btn" style="font-size:12px;">Xem tất cả →</a>
                    </div>
                    <c:if test="${empty purchaseOrders}">
                        <div style="padding:24px;text-align:center;color:var(--muted);font-size:14px;">Nhà cung cấp chưa có đơn mua nào.</div>
                    </c:if>
                    <c:if test="${not empty purchaseOrders}">
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th style="width:40px;">#</th>
                                    <th>Mã đơn</th>
                                    <th>Kỳ</th>
                                    <th>Trạng thái</th>
                                    <th>Kho</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="po" items="${purchaseOrders}" varStatus="st">
                                    <tr>
                                        <td>${st.index + 1}</td>
                                        <td><strong><a href="${pageContext.request.contextPath}/purchase-order?action=view&poId=${po.poId}" style="color:var(--accent);text-decoration:none;">${po.poCode}</a></strong></td>
                                        <td>${po.period}</td>
                                        <td>${po.status}</td>
                                        <td>${po.warehouseName}</td>
                                        <td>${po.createdByName}</td>
                                        <td class="mono"><c:out value="${poDates[st.index]}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>

                <div class="tab-panel" id="tab-history">
                    <c:choose>
                        <c:when test="${empty activityLogs}">
                            <div style="padding:24px;text-align:center;color:var(--muted);font-size:14px;">Chưa có hoạt động nào.</div>
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
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/supplier-js.js"></script>
</body>
</html>
