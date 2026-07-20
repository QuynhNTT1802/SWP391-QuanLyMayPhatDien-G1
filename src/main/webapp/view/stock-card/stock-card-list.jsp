<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Thẻ kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .qty-import { color: #155724; font-weight: 700; }
            .qty-export { color: #721c24; font-weight: 700; }
            .qty-adjust { color: #856404; font-weight: 700; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
            <div>
                <header class="topbar">
                    <h1>Thẻ kho</h1>
                    <span class="crumb">/ Kho / Thẻ kho</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho</div>
                            <h2 class="page-title">Lịch sử nhập xuất kho</h2>
                            <div class="page-sub">${totalItems} giao dịch</div>
                        </div>
                    </div>

                    <form method="get" action="${pageContext.request.contextPath}/stock-card" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                        <input type="hidden" name="action" value="list" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, số serial, ghi chú" autocomplete="off" />
                        </div>
                        <select class="filter-select" name="warehouseId" onchange="this.form.submit()" <c:if test="${not empty scopedWarehouseId}">disabled</c:if>>
                            <c:choose>
                                <c:when test="${not empty scopedWarehouseId}">
                                    <option value="${scopedWarehouseId}" selected>Kho: <c:out value="${scopedWarehouseName}"/></option>
                                </c:when>
                                <c:otherwise>
                                    <option value="">Kho: Tất cả</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" <c:if test="${warehouseId == w.warehouseId}">selected</c:if>>${w.name}</option>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </select>
                        <select class="filter-select" name="generatorId">
                            <option value="">Sản phẩm: Tất cả</option>
                            <c:forEach var="g" items="${generators}">
                                <option value="${g.id}" <c:if test="${generatorId == g.id}">selected</c:if>>${g.model}</option>
                            </c:forEach>
                        </select>
                        <select class="filter-select" name="type">
                            <option value="">Loại: Tất cả</option>
                            <option value="IMPORT" <c:if test="${typeFilter == 'IMPORT'}">selected</c:if>>Nhập kho</option>
                            <option value="EXPORT" <c:if test="${typeFilter == 'EXPORT'}">selected</c:if>>Xuất kho</option>
                            <option value="ADJUST" <c:if test="${typeFilter == 'ADJUST'}">selected</c:if>>Điều chỉnh</option>
                        </select>
                        <label style="font-size:13px;color:var(--muted);">Từ:</label>
                        <input type="date" name="fromDate" class="filter-select" value="<c:out value='${fromDate}'/>" />
                        <label style="font-size:13px;color:var(--muted);">Đến:</label>
                        <input type="date" name="toDate" class="filter-select" value="<c:out value='${toDate}'/>" />
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            Tìm kiếm
                        </button>
                        <c:if test="${not empty search or not empty warehouseId or not empty generatorId or not empty typeFilter or not empty fromDate or not empty toDate}">
                            <a href="${pageContext.request.contextPath}/stock-card" class="btn">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                Xoá lọc
                            </a>
                        </c:if>
                    </form>

                    <div class="table-card" style="margin-top:16px;">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th style="width:140px;">Thời gian</th>
                                    <th>Kho</th>
                                    <th style="width:100px;">Loại</th>
                                    <th>Sản phẩm</th>
                                    <th style="width:200px;">Số serial</th>
                                    <th style="width:90px;">+/- SL</th>
                                    <th style="width:80px;">Tồn sau</th>
                                    <th>Mã phiếu</th>
                                    <th>Ghi chú</th>
                                    <th>Người tạo</th>
                                    <th style="width:80px;">Xem</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty stockCards}">
                                        <tr><td colspan="12">
                                            <div class="empty-state"><strong>Không có giao dịch nào</strong></div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sc" items="${stockCards}">
                                            <tr>
                                                <td style="font-size:12px;"><fmt:formatDate value="${sc.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>${sc.warehouseName}</td>
                                                <td>${sc.generatorModel}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}"><span class="status active" style="--dot:var(--accent);"><span class="sdot"></span>Nhập</span></c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}"><span class="status locked" style="--dot:var(--danger);"><span class="sdot"></span>Xuất</span></c:when>
                                                        <c:otherwise><span class="status active" style="--dot:var(--warn);background:var(--warn-soft);color:var(--warn);"><span class="sdot"></span>Điều chỉnh</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-size:11px;font-family:monospace;max-width:200px;" title="<c:out value='${sc.serialList}'/>">
                                                    <c:choose>
                                                        <c:when test="${empty sc.serialList}">
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="serialsArr" value="${fn:split(sc.serialList, ', ')}" />
                                                            <c:out value="${serialsArr[0]}"/>
                                                            <c:if test="${fn:length(serialsArr) > 1}">
                                                                <span style="color:var(--accent);font-weight:600;"> +${fn:length(serialsArr) - 1}</span>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}">
                                                            <span class="qty-import">+${sc.quantityChange}</span>
                                                        </c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}">
                                                            <span class="qty-export">${sc.quantityChange}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="qty-adjust"><c:out value="${sc.quantityChange >= 0 ? '+' : ''}${sc.quantityChange}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong>${sc.quantityAfter}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty sc.receiptCode}">
                                                            <a href="${pageContext.request.contextPath}${sc.transactionType == 'IMPORT' ? '/import-receipt' : '/export-receipt'}?action=detail&id=${sc.receiptId}" style="font-family:monospace;font-size:12px;">${sc.receiptCode}</a>
                                                        </c:when>
                                                        <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-size:12px;color:var(--muted);">${sc.referenceNote}</td>
                                                <td>${sc.createdByName}</td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/stock-card?action=detail&warehouseId=${sc.warehouseId}&generatorId=${sc.generatorId}" class="btn" style="font-size:11px;padding:3px 8px;" title="Xem lịch sử sản phẩm này">
                                                        Lịch sử
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty search}">
                            <c:set var="filterParams" value="${filterParams}&search=${search}" />
                        </c:if>
                        <c:if test="${not empty warehouseId}">
                            <c:set var="filterParams" value="${filterParams}&warehouseId=${warehouseId}" />
                        </c:if>
                        <c:if test="${not empty generatorId}">
                            <c:set var="filterParams" value="${filterParams}&generatorId=${generatorId}" />
                        </c:if>
                        <c:if test="${not empty typeFilter}">
                            <c:set var="filterParams" value="${filterParams}&type=${typeFilter}" />
                        </c:if>
                        <c:if test="${not empty fromDate}">
                            <c:set var="filterParams" value="${filterParams}&fromDate=${fromDate}" />
                        </c:if>
                        <c:if test="${not empty toDate}">
                            <c:set var="filterParams" value="${filterParams}&toDate=${toDate}" />
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
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
