<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu purchase đã duyệt — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <style>
        .po-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--fg); font-weight: 600; }
        .col-period { white-space: nowrap; width: 100px; }
        .col-creator { white-space: nowrap; width: 160px; }
        .col-actions { white-space: nowrap; }
        .table-card { overflow-x: auto; -webkit-overflow-scrolling: touch; margin-top: 16px; }
        .muted { color: var(--muted); }
        .empty-state { text-align: center; padding: 40px; color: var(--muted); }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Phiếu purchase đã duyệt</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Chọn phiếu purchase</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    Quay lại
                </a>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Phiếu nhập</div>
                    <h2 class="page-title">Chọn phiếu purchase đã duyệt</h2>
                    <div class="page-sub">${totalItems} phiếu</div>
                </div>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/import-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                <input type="hidden" name="action" value="selectPurchase" />
                <input type="hidden" name="page" value="1" />
                <label style="font-size:13px;color:var(--muted);">Kỳ:</label>
                <input name="period" class="filter-select" value="<c:out value='${period}'/>" placeholder="VD: 2026-Q2" style="width:120px;" />
                <label style="font-size:13px;color:var(--muted);">Kho:</label>
                <select name="warehouseId" class="filter-select" style="width:160px;">
                    <option value="">Tất cả</option>
                    <c:forEach var="wh" items="${warehouses}">
                        <option value="${wh.warehouseId}" ${wh.warehouseId == warehouseId ? 'selected' : ''}>${wh.name}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                    Tìm kiếm
                </button>
                <div class="spacer"></div>
                <button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/import-receipt?action=selectPurchase'">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                    Xóa lọc
                </button>
            </form>

            <c:choose>
                <c:when test="${empty approvedPOs}">
                    <div class="empty-state">Không có phiếu purchase nào đã duyệt.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th class="col-period">Kỳ</th>
                                    <th>Kho nhập</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="po" items="${approvedPOs}">
                                    <tr>
                                        <td><span class="po-code">${po.poCode}</span></td>
                                        <td class="col-period">${po.period}</td>
                                        <td>${po.warehouseName}</td>
                                        <td class="col-creator"><c:out value="${po.createdByName}"/></td>
                                        <td class="col-actions">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=create&poId=${po.poId}" class="btn btn-primary" style="font-size:12px;padding:5px 12px;">
                                                Tạo phiếu nhập
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty period}">
                            <c:set var="filterParams" value="${filterParams}&period=${period}" />
                        </c:if>
                        <c:if test="${warehouseId > 0}">
                            <c:set var="filterParams" value="${filterParams}&warehouseId=${warehouseId}" />
                        </c:if>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=selectPurchase&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="pg">
                                    <c:choose>
                                        <c:when test="${pg == currentPage}"><span class="page-btn active">${pg}</span></c:when>
                                        <c:otherwise><a href="?action=selectPurchase&page=${pg}${filterParams}" class="page-btn">${pg}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=selectPurchase&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
</body>
</html>
