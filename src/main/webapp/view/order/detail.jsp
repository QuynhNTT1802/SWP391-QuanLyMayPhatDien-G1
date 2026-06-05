<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <style>
            /* Bổ sung style cho bảng sản phẩm trong đơn hàng */
            .product-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 12px;
            }
            .product-table th, .product-table td {
                padding: 12px 16px;
                text-align: left;
                border-bottom: 1px solid var(--border);
            }
            .product-table th {
                font-size: 12px;
                color: var(--muted);
                text-transform: uppercase;
                font-weight: 600;
                background: #f9fafb;
            }
            .product-table td {
                font-size: 14px;
            }
            .text-right {
                text-align: right;
            }
            .total-row {
                font-size: 18px;
                font-weight: 700;
                color: var(--accent);
            }
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            .status-approved {
                background: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background: #f8d7da;
                color: #721c24;
            }
            .status-cancelled {
                background: #e2e3e5;
                color: #383d41;
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết đơn hàng</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / <span id="crumbId"><c:out value="${order.orderCode}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <c:if test="${order.status == 'PENDING'}">
                    <a class="btn" href="${pageContext.request.contextPath}/order?action=edit&id=${order.orderId}">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                        Chỉnh sửa
                    </a>
                </c:if>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar blue">
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}"></c:when>
                        <c:when test="${order.status == 'APPROVED'}">✅</c:when>
                        <c:when test="${order.status == 'REJECTED'}">❌</c:when>
                        <c:otherwise>🚫</c:otherwise>
                    </c:choose>
                </div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${order.customerName}"/>
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                            <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                            <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                            <c:otherwise><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="hero-meta">
                        <span><c:out value="${order.orderCode}"/></span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${order.orderId}"/></span>
                        <span class="sep">·</span>
                        <span>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                    </div>
                    <div class="hero-pills">
                        <span class="pill role-staff"><span class="pdot"></span>Người tạo: <c:out value="${order.createdByName}"/></span>
                        <c:if test="${order.approvedBy != 0}">
                            <span class="pill role-manager"><span class="pdot"></span>Người duyệt: ID ${order.approvedBy}</span>
                        </c:if>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                        <svg viewBox="0 0 24 24">
                        <path d="M19 12H5M12 19l-7-7 7-7"/>
                        </svg>
                        Quay lại danh sách
                    </a>
                    <div class="hero">
                        <div class="hero-avatar blue">
                            <c:choose>
                                <c:when test="${order.status == 'PENDING'}"></c:when>
                                <c:when test="${order.status == 'APPROVED'}">✅</c:when>
                                <c:when test="${order.status == 'REJECTED'}">❌</c:when>
                                <c:otherwise>🚫</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${order.customerName}"/>
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                    <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                    <c:otherwise><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="hero-meta">
                                <span><c:out value="${order.orderCode}"/></span>
                                <span class="sep">·</span>
                                <span class="id">#<c:out value="${order.orderId}"/></span>
                                <span class="sep">·</span>
                                <span>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill role-staff"><span class="pdot"></span>Người tạo: ID ${order.createdBy}</span>
                                <c:if test="${order.approvedBy != 0}">
                                    <span class="pill role-manager"><span class="pdot"></span>Người duyệt: ID ${order.approvedBy}</span>
                                </c:if>
                                <span class="pill role-admin"><span class="pdot"></span>Tổng tiền: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></span>
                            </div>
                        </div>
                        <div class="hero-actions"></div>
                    </div>

                    <div class="layout">
                        <div class="toc">
                            <a class="toc-item active" data-toc="info"><span class="toc-num">01</span><span>Thông tin đơn hàng</span></a>
                            <a class="toc-item" data-toc="products"><span class="toc-num">02</span><span>Sản phẩm</span></a>
                            <div class="toc-meta">
                                <strong>#<c:out value="${order.orderId}"/></strong><br>
                                Tạo: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/><br>
                                Cập nhật: <fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>

                        <div class="content">
                            <section class="section" id="info">
                                <div class="section-head">
                                    <div>
                                        <div class="section-num">01 — THÔNG TIN KHÁCH HÀNG & XỬ LÝ</div>
                                        <h3 class="section-title">Hồ sơ liên hệ & tiến trình</h3>
                                    </div>
                                    <div class="section-update">Cập nhật <fmt:formatDate value="${order.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                </div>
                                <div class="info-grid">
                                    <div class="info-field">
                                        <div class="info-label">Tên khách hàng</div>
                                        <div class="info-value"><c:out value="${order.customerName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Số điện thoại</div>
                                        <div class="info-value mono"><c:out value="${order.customerPhone}"/></div>
                                    </div>
                                    <c:if test="${not empty order.customerEmail}">
                                        <div class="info-field">
                                            <div class="info-label">Email</div>
                                            <div class="info-value mono"><c:out value="${order.customerEmail}"/></div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Địa chỉ giao hàng</div>
                                        <div class="info-value"><c:out value="${order.customerAddress}"/></div>
                                    </div>
                                    <c:if test="${not empty customerTypeName}">
                                        <div class="info-field">
                                            <div class="info-label">Loại khách hàng</div>
                                            <div class="info-value"><c:out value="${customerTypeName}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.customerCompany or not empty order.customerTaxCode}">
                                        <div class="info-field">
                                            <div class="info-label">Công ty / MST</div>
                                            <div class="info-value">
                                                <c:out value="${order.customerCompany}"/>
                                                <c:if test="${not empty order.customerTaxCode}"> (<c:out value="${order.customerTaxCode}"/>)</c:if>
                                                </div>
                                            </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Trạng thái</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                                <c:otherwise><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${not empty order.rejectReason}">
                                        <div class="info-field" style="grid-column: span 2;">
                                            <div class="info-label" style="color: var(--danger);">Lý do từ chối</div>
                                            <div class="info-value" style="color: var(--danger);"><c:out value="${order.rejectReason}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.note}">
                                        <div class="info-field" style="grid-column: span 2;">
                                            <div class="info-label">Ghi chú nội bộ</div>
                                            <div class="info-value"><c:out value="${order.note}"/></div>
                                        </div>
                                    </c:if>
                                </div>
                            </section>

                            <section class="section" id="products">
                                <div class="section-head">
                                    <div>
                                        <div class="section-num">02 — SẢN PHẨM ĐẶT MUA</div>
                                        <h3 class="section-title">Danh sách máy phát điện</h3>
                                    </div>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th>Tên sản phẩm / Mã</th>
                                            <th style="width: 80px;">SL</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="d" items="${details}">
                                            <tr>
                                                <td><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${d.generatorId}"><c:out value="${d.generatorModel}"/></a></td>
                                                <td>${d.quantity}</td>
                                                <td class="text-right"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                <td class="text-right"><fmt:formatNumber value="${d.quantity * d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty details}">
                                            <tr><td colspan="4" style="text-align: center; padding: 20px; color: var(--muted);">Chưa có sản phẩm nào trong đơn hàng.</td></tr>
                                        </c:if>
                                        <c:if test="${not empty details}">
                                            <tr>
                                                <td colspan="3" class="text-right total-row">Tổng cộng:</td>
                                                <td class="text-right total-row"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </section>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
