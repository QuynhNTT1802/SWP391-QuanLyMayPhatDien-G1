<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết thẻ kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .summary-card { display: flex; gap: 16px; margin: 16px 0; flex-wrap: wrap; }
            .summary-item { flex: 1; min-width: 180px; background: var(--surface-1); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; }
            .summary-label { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em; margin-bottom: 6px; }
            .summary-value { font-size: 24px; font-weight: 800; }
            .qty-import { color: #155724; font-weight: 700; }
            .qty-export { color: #721c24; font-weight: 700; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
            <div>
                <header class="topbar">
                    <h1>Thẻ kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/stock-card">Thẻ kho</a> / Chi tiết</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a href="${pageContext.request.contextPath}/stock-card" class="btn btn-back" title="Quay lại">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại
                    </a>

                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho · Sản phẩm</div>
                            <h2 class="page-title">
                                <c:choose>
                                    <c:when test="${not empty stockCards}">
                                        ${stockCards.get(0).warehouseName} — ${stockCards.get(0).generatorModel}
                                    </c:when>
                                    <c:otherwise>Không tìm thấy dữ liệu</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="page-sub">Lịch sử nhập/xuất/điều chỉnh</div>
                        </div>
                    </div>

                    <div class="summary-card">
                        <div class="summary-item">
                            <div class="summary-label">Tổng nhập</div>
                            <div class="summary-value qty-import">+${totalImport}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tổng xuất</div>
                            <div class="summary-value qty-export">-${totalExport}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tồn kho hiện tại</div>
                            <div class="summary-value" style="color:var(--accent);">${currentStock}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tổng giao dịch</div>
                            <div class="summary-value" style="color:var(--fg);">${not empty stockCards ? stockCards.size() : 0}</div>
                        </div>
                    </div>

                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th style="width:140px;">Thời gian</th>
                                    <th style="width:100px;">Loại</th>
                                    <th style="width:90px;">+/- SL</th>
                                    <th style="width:80px;">Tồn sau</th>
                                    <th>Mã phiếu</th>
                                    <th>Ghi chú</th>
                                    <th>Người tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty stockCards}">
                                        <tr><td colspan="7">
                                            <div class="empty-state"><strong>Sản phẩm này chưa có giao dịch nào trong kho này</strong></div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sc" items="${stockCards}">
                                            <tr>
                                                <td style="font-size:12px;"><fmt:formatDate value="${sc.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}"><span class="status active" style="--dot:var(--accent);"><span class="sdot"></span>Nhập</span></c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}"><span class="status locked" style="--dot:var(--danger);"><span class="sdot"></span>Xuất</span></c:when>
                                                        <c:otherwise><span class="status active" style="--dot:var(--warn);background:var(--warn-soft);color:var(--warn);"><span class="sdot"></span>Điều chỉnh</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}"><span class="qty-import">+${sc.quantityChange}</span></c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}"><span class="qty-export">-${sc.quantityChange}</span></c:when>
                                                        <c:otherwise><c:out value="${sc.quantityChange >= 0 ? '+' : ''}${sc.quantityChange}"/></c:otherwise>
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