<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chọn phiếu luân chuyển — Warehouse OS</title>
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
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển đã duyệt</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / Chọn phiếu luân chuyển</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>

        <main>
            <a href="${pageContext.request.contextPath}/export-receipt" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại
            </a>

            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Chọn phiếu luân chuyển đã duyệt</h2>
                    <div class="page-sub">${totalItems} phiếu luân chuyển</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty transfers}">
                    <div style="text-align:center;padding:40px;color:var(--muted);">
                        Không có phiếu luân chuyển nào đã duyệt.
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
                                    <th>Ngày tạo</th>
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
                                        <td>${t.createdAt}</td>
                                        <td class="col-actions">
                                            <a href="${pageContext.request.contextPath}/export-receipt?action=create&transferId=${t.transferId}" class="btn btn-primary" style="font-size:12px;padding:4px 10px;">
                                                Tạo phiếu xuất
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