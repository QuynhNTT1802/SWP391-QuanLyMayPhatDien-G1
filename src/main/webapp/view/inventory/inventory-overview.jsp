<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tồn kho — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tồn kho</h1>
            <span class="crumb">/ Kho / Tồn kho</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41 1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>
        <main>
            <c:if test="${not empty lockedWarehouseName}">
                <div class="alert" style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb, var(--danger) 25%, transparent);">
                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0;"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    <span>Kho &quot;<c:out value='${lockedWarehouseName}'/>&quot; hiện đang bị khóa. Vui lòng mở khóa kho trong phần <a href="${pageContext.request.contextPath}/warehouse?action=list">Quản lý kho</a> nếu cần xem chi tiết.</span>
                </div>
            </c:if>

            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Tồn kho</div>
                    <h2 class="page-title">Tồn kho hiện tại</h2>
                    <div class="page-sub"><fmt:formatNumber value="${kpiTotalQty}"/> máy phát điện đang được lưu trữ tại <fmt:formatNumber value="${kpiTotalWarehouses}"/> kho</div>
                </div>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card kpi-total">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h7"/></svg>
                    </div>
                    <div class="kpi-title">Tổng tồn kho</div>
                    <div class="kpi-value"><fmt:formatNumber value="${kpiTotalQty}"/></div>
                </div>
                <div class="kpi-card kpi-active">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                    </div>
                    <div class="kpi-title">Kho hoạt động</div>
                    <div class="kpi-value"><fmt:formatNumber value="${kpiActiveWarehouses}"/></div>
                </div>
                <div class="kpi-card kpi-locked">
                    <div class="kpi-icon">
                        <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <div class="kpi-title">Kho bị khóa</div>
                    <div class="kpi-value"><fmt:formatNumber value="${kpiLockedWarehouses}"/></div>
                </div>
            </div>

            <h3 class="section-heading">
                <svg viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                Phân loại theo kho hàng
            </h3>
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th style="width:60px;text-align:center;font-family:var(--font-mono);">ID</th>
                            <th>Tên kho</th>
                            <th style="width:160px;text-align:right;">Số mặt hàng</th>
                            <th style="width:160px;text-align:right;">Tổng tồn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty warehouses}">
                                <tr><td colspan="4">
                                    <div class="empty-state">
                                        <div class="icon-wrap">
                                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                                        </div>
                                        <strong>Chưa có kho nào</strong>
                                    </div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="w" items="${warehouses}">
                                    <tr class="warehouse-row" onclick="location.href='${pageContext.request.contextPath}/inventory/list?warehouse=${w.warehouseId}'">
                                        <td style="text-align:center;font-family:var(--font-mono);font-size:0.82rem;color:var(--muted);font-weight:600;">#${w.warehouseId}</td>
                                        <td>
                                            <span class="warehouse-name">
                                                <span class="wdot"></span>
                                                <c:out value="${w.name}"/>
                                            </span>
                                        </td>
                                        <td style="text-align:right;">
                                            <span class="item-count">
                                                <c:out value="${warehouseItemCount[w.warehouseId] != null ? warehouseItemCount[w.warehouseId] : 0}"/>
                                            </span>
                                        </td>
                                        <td style="text-align:right;font-family:var(--font-mono);font-weight:700;color:var(--muted);">
                                            <fmt:formatNumber value="${warehouseQtySum[w.warehouseId] != null ? warehouseQtySum[w.warehouseId] : 0}"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
