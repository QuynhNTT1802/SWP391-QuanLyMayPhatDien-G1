<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Báo cáo thanh lý — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
    <style>
        table.rpt { width: 100%; border-collapse: collapse; font-size: 13px; }
        table.rpt th, table.rpt td { text-align: start; padding: 8px 12px; border-bottom: 1px solid var(--border); white-space: nowrap; }
        table.rpt th { font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); border-bottom: 1px solid var(--border-strong); border-top: 1px solid var(--border); }
        table.rpt tbody tr:hover { background: var(--surface-2); }
        table.rpt tfoot td { padding: 10px 12px; background: var(--surface-2); border-top: 2px solid var(--border-strong); font-weight: 600; }
        td.num, th.num { text-align: end; font-family: var(--font-mono); }
        .empty-cell { text-align: center; color: var(--muted); padding: 22px; }
        .report-filter { display: inline-flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .report-filter .rf-field { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface); transition: border-color .12s ease, box-shadow .12s ease; }
        .report-filter .rf-field:focus-within { border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .report-filter .rf-sep { color: var(--muted-2); font-size: 12px; }
        .report-filter input[type="date"] { font-size: 12.5px; font-family: var(--font-ui); color: var(--fg); border: none; background: transparent; padding: 2px 0; outline: none; cursor: pointer; width: 116px; }
        .report-filter > select { font-size: 12.5px; font-family: var(--font-ui); color: var(--fg); padding: 7px 28px 7px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface); cursor: pointer; min-width: 130px; transition: border-color .12s ease, box-shadow .12s ease; }
        .report-filter > select:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .report-filter .btn { padding: 6px 12px; }
        .section-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 16px; }
        .fixed-col { position: sticky; left: 0; background: inherit; }
        .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
        [data-theme="light"] .theme-toggle .icon-moon { display: block; }
        [data-theme="dark"] .theme-toggle .icon-sun { display: block; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Báo cáo thanh lý</h1>
            <span class="crumb">/ Quản lý kho / Thanh lý / Báo cáo</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                </button>
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Báo cáo thanh lý</h2>
                </div>
            </div>

            <c:if test="${not empty dateError}">
                <div class="feedback-banner feedback-banner--danger">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="body"><div class="feedback-banner__body">${dateError}</div></div>
                </div>
            </c:if>

            <div class="section-head">
                <form class="report-filter" method="get" action="${pageContext.request.contextPath}/liquidations/report">
                    <span class="rf-field">
                        <input type="date" name="fromDate" value="${fromDate}" max="${toDate}" title="Từ ngày"/>
                        <span class="rf-sep">–</span>
                        <input type="date" name="toDate" value="${toDate}" title="Đến ngày"/>
                    </span>
                    <select name="warehouseId" title="Kho">
                        <option value="">Tất cả kho</option>
                        <c:forEach var="w" items="${warehouses}">
                            <option value="${w.warehouseId}" ${selectedWarehouseId == w.warehouseId ? 'selected' : ''}>${w.name}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3z"/></svg>
                        Lọc
                    </button>
                    <a class="btn" href="${pageContext.request.contextPath}/liquidations/report?action=export&fromDate=${fromDate}&toDate=${toDate}<c:if test='${not empty selectedWarehouseId}'>&warehouseId=${selectedWarehouseId}</c:if>">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Xuất Excel
                    </a>
                </form>
            </div>

            <section class="card" style="overflow: auto;">
                <table class="rpt">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Mã đơn</th>
                            <th>Ngày thanh lý</th>
                            <th>Kho</th>
                            <th>Lý do</th>
                            <th class="num">Số máy</th>
                            <th class="num">Giá nhập</th>
                            <th class="num">Giá thanh lý</th>
                            <th class="num">Chênh lệch</th>
                            <th>Khách hàng</th>
                            <th>Người tạo</th>
                            <th>Người duyệt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty rows}">
                                <tr><td colspan="12" class="empty-cell">Không có dữ liệu thanh lý trong khoảng thời gian này.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${rows}" varStatus="vs">
                                    <tr>
                                        <td>${vs.count}</td>
                                        <td><a href="${pageContext.request.contextPath}/liquidations?action=detail&id=${r.liquidationId}">${r.liquidationCode}</a></td>
                                        <td>${r.reviewedAtStr}</td>
                                        <td>${r.warehouseName}</td>
                                        <td>${r.reasonName}</td>
                                        <td class="num">${r.machineCount}</td>
                                        <td class="num"><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num"><fmt:formatNumber value="${r.totalLiquidation}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
                                        <td>${empty r.customerName ? '—' : r.customerName}</td>
                                        <td>${empty r.creatorName ? '—' : r.creatorName}</td>
                                        <td>${empty r.ceoName ? '—' : r.ceoName}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                    <c:if test="${not empty rows}">
                        <c:set var="totalMachine" value="0"/>
                        <c:set var="totalOrig" value="0"/>
                        <c:set var="totalLiq" value="0"/>
                        <c:set var="totalLoss" value="0"/>
                        <c:forEach var="r" items="${rows}">
                            <c:set var="totalMachine" value="${totalMachine + r.machineCount}"/>
                            <c:set var="totalOrig" value="${totalOrig + r.totalOriginal}"/>
                            <c:set var="totalLiq" value="${totalLiq + r.totalLiquidation}"/>
                            <c:set var="totalLoss" value="${totalLoss + r.totalLoss}"/>
                        </c:forEach>
                        <tfoot>
                            <tr>
                                <td></td>
                                <td colspan="4">Tổng (${fn:length(rows)} đơn)</td>
                                <td class="num">${totalMachine}</td>
                                <td class="num"><fmt:formatNumber value="${totalOrig}" type="number" maxFractionDigits="0"/></td>
                                <td class="num"><fmt:formatNumber value="${totalLiq}" type="number" maxFractionDigits="0"/></td>
                                <td class="num"><fmt:formatNumber value="${totalLoss}" type="number" maxFractionDigits="0"/></td>
                                <td colspan="3"></td>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
            </section>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
