<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu luân chuyển — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Chọn phiếu luân chuyển</span>
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
                    <h2 class="page-title">Chọn phiếu luân chuyển đã xuất kho</h2>
                    <div class="page-sub">${totalItems} phiếu</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty transfers}">
                    <div style="text-align:center;padding:40px;color:var(--muted);">
                        Không có phiếu luân chuyển nào đã xuất kho.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Kho nguồn</th>
                                    <th>Kho đích</th>
                                    <th>Người tạo</th>
                                    <th>Phiếu xuất</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${transfers}">
                                    <tr>
                                        <td><strong style="font-family:monospace;">${t.transferCode}</strong></td>
                                        <td>${t.sourceWarehouseName}</td>
                                        <td>${t.destWarehouseName}</td>
                                        <td>${t.createdByName}</td>
                                        <td><span style="font-family:monospace;">${t.exportReceiptCode}</span></td>
                                        <td class="col-actions">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=create&exportReceiptId=${t.exportReceiptId}" class="btn btn-primary" style="font-size:12px;padding:4px 10px;">
                                                Tạo phiếu nhập
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

<div class="toast-host" id="toastHost"></div>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>