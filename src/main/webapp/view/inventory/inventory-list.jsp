<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <style>
        .wh-group { margin-bottom: 28px; }
        .wh-group-header { display:flex; align-items:center; gap:12px; padding: 10px 0; border-bottom: 2px solid var(--accent); margin-bottom: 8px; }
        .wh-group-header h3 { font-size: 15px; font-weight: 700; color: var(--accent); margin: 0; }
        .wh-group-header .badge { background: var(--accent); color: #fff; font-size: 12px; padding: 2px 10px; border-radius: 20px; font-weight: 600; }
        .qty-cell { font-weight: 700; }
        .qty-low { color: var(--danger); }
        .qty-ok { color: var(--accent); }
    </style>
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
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Tồn kho hiện tại</h2>
                    <div class="page-sub">${totalItems} mặt hàng</div>
                </div>
            </div>
            <form method="get" action="${pageContext.request.contextPath}/inventory" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                    <option value="">Kho: Tất cả</option>
                    <c:forEach var="wh" items="${warehouses}">
                        <option value="${wh.warehouseId}" <c:if test="${selectedWarehouse == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                    </c:forEach>
                </select>
                <div class="spacer"></div>
                <c:if test="${not empty selectedWarehouse}">
                    <a href="${pageContext.request.contextPath}/inventory" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xoá lọc
                    </a>
                </c:if>
            </form>
            <div class="table-card" style="margin-top:16px;">
                <c:choose>
                    <c:when test="${empty inventoryList}">
                        <div class="empty-state"><strong>Không có dữ liệu tồn kho</strong></div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="wh" items="${warehouseGroups}">
                            <div class="wh-group">
                                <div class="wh-group-header">
                                    <h3>${wh.name}</h3>
                                    <span class="badge">${wh.itemCount} mặt hàng</span>
                                </div>
                                <table class="users">
                                    <thead>
                                        <tr>
                                            <th style="width:40px;">#</th>
                                            <th>Model</th>
                                            <th>Hãng</th>
                                            <th style="width:100px;">Số lượng</th>
                                            <th style="width:160px;">Cập nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="idx" value="0"/>
                                        <c:forEach var="item" items="${inventoryList}">
                                            <c:if test="${item.warehouseId == wh.warehouseId}">
                                                <c:set var="idx" value="${idx + 1}"/>
                                                <tr>
                                                    <td>${idx}</td>
                                                    <td><strong>${item.generatorModel}</strong></td>
                                                    <td>${item.generatorBrand}</td>
                                                    <td>
                                                        <span class="qty-cell ${item.quantity <= 3 ? 'qty-low' : 'qty-ok'}">
                                                            ${item.quantity}
                                                        </span>
                                                    </td>
                                                    <td style="font-size:12px;color:var(--muted);">${item.updatedAt}</td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>