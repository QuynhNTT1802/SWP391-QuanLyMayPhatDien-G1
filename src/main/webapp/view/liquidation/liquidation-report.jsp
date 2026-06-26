<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Báo cáo thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
    <style>
        .report-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px; }
        @media (max-width: 900px) { .report-grid { grid-template-columns: 1fr; } }
        .chart-card { background: var(--card, #fff); border: 1px solid var(--border, #e5e7eb); border-radius: 12px; padding: 18px 20px; margin-top: 16px; }
        .chart-card h3, .table-card h3 { margin: 0 0 14px; font-size: 15px; font-weight: 600; }
        .bar-chart { display: flex; align-items: flex-end; gap: 10px; height: 200px; padding-top: 10px; }
        .bar-col { flex: 1; display: flex; flex-direction: column; align-items: center; gap: 6px; height: 100%; justify-content: flex-end; }
        .bar { width: 70%; max-width: 46px; background: linear-gradient(180deg, #4f81bd, #3b6098); border-radius: 4px 4px 0 0; min-height: 2px; transition: height .3s; }
        .bar-wrap { width: 100%; display: flex; justify-content: center; align-items: flex-end; flex: 1; }
        .bar-label { font-size: 11px; color: var(--muted, #6b7280); white-space: nowrap; }
        .bar-val { font-size: 10px; color: var(--muted, #6b7280); }
        .rate-pill { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 12px; font-weight: 600; }
        .rate-good { background: #dcfce7; color: #166534; }
        .rate-mid { background: #fef9c3; color: #854d0e; }
        .rate-bad { background: #fee2e2; color: #991b1b; }
        .loss-val { color: #b91c1c; font-weight: 600; }
        .filter-bar { display: flex; flex-wrap: wrap; gap: 10px; align-items: flex-end; margin-bottom: 8px; }
        .filter-bar .fld { display: flex; flex-direction: column; gap: 4px; }
        .filter-bar .fld label { font-size: 12px; color: var(--muted, #6b7280); }
        .filter-bar input, .filter-bar select { padding: 7px 10px; border: 1px solid var(--border, #e5e7eb); border-radius: 8px; }
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
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Báo cáo thanh lý</h2>
                    <div class="page-sub">Phân tích tổn thất, thu hồi vốn và xu hướng thanh lý thiết bị</div>
                </div>
            </div>
            <%-- BODY_PLACEHOLDER --%>

            <c:if test="${not empty dateError}">
                <div class="alert alert-error" style="margin-bottom:12px;color:#991b1b;">${dateError}</div>
            </c:if>

            <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/liquidations/report">
                <div class="fld">
                    <label>Từ ngày</label>
                    <input type="date" name="fromDate" value="${fromDate}" max="${toDate}"/>
                </div>
                <div class="fld">
                    <label>Đến ngày</label>
                    <input type="date" name="toDate" value="${toDate}"/>
                </div>
                <div class="fld">
                    <label>Kho</label>
                    <select name="warehouseId">
                        <option value="">Tất cả kho</option>
                        <c:forEach var="w" items="${warehouses}">
                            <option value="${w.warehouseId}" ${selectedWarehouseId == w.warehouseId ? 'selected' : ''}>${w.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3z"/></svg>
                    Lọc
                </button>
                <a class="btn" href="${pageContext.request.contextPath}/liquidations/report?action=export&fromDate=${fromDate}&toDate=${toDate}<c:if test='${not empty selectedWarehouseId}'>&warehouseId=${selectedWarehouseId}</c:if>">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                    Xuất Excel
                </a>
            </form>

            <div class="stats-row liq-stats" style="--kpi-cols: 4;">
                <div class="stat">
                    <div class="lbl">Số máy đã thanh lý</div>
                    <div class="val">${summary.machineCount}</div>
                </div>
                <div class="stat">
                    <div class="lbl">Tổng nguyên giá</div>
                    <div class="val"><fmt:formatNumber value="${summary.totalOriginal}" type="number" maxFractionDigits="0"/> ₫</div>
                </div>
                <div class="stat">
                    <div class="lbl">Thu hồi (${summary.recoveryRate}%)</div>
                    <div class="val"><fmt:formatNumber value="${summary.totalLiquidation}" type="number" maxFractionDigits="0"/> ₫</div>
                </div>
                <div class="stat">
                    <div class="lbl">Tổn thất</div>
                    <div class="val loss-val"><fmt:formatNumber value="${summary.totalLoss}" type="number" maxFractionDigits="0"/> ₫</div>
                </div>
            </div>
            <%-- CHART_PLACEHOLDER --%>

            <c:set var="maxMonthly" value="0"/>
            <c:forEach var="m" items="${monthly}">
                <c:if test="${m.totalLiquidation > maxMonthly}"><c:set var="maxMonthly" value="${m.totalLiquidation}"/></c:if>
            </c:forEach>

            <div class="chart-card">
                <h3>Xu hướng giá trị thu hồi theo tháng</h3>
                <c:choose>
                    <c:when test="${empty monthly}">
                        <div class="page-sub">Chưa có dữ liệu thanh lý trong khoảng thời gian này.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="bar-chart">
                            <c:forEach var="m" items="${monthly}">
                                <div class="bar-col" title="${m.month}: <fmt:formatNumber value='${m.totalLiquidation}' type='number' maxFractionDigits='0'/> ₫">
                                    <div class="bar-val"><fmt:formatNumber value="${m.totalLiquidation / 1000000}" maxFractionDigits="1"/>tr</div>
                                    <div class="bar-wrap">
                                        <div class="bar" style="height: ${maxMonthly > 0 ? (m.totalLiquidation * 100 / maxMonthly) : 0}%;"></div>
                                    </div>
                                    <div class="bar-label">${m.month}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="report-grid">
                <div class="table-card">
                    <h3>Theo lý do thanh lý</h3>
                    <table class="users">
                        <thead>
                            <tr><th>Lý do</th><th>Số máy</th><th>Nguyên giá</th><th>Tổn thất</th></tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty byReason}">
                                    <tr><td colspan="4" style="text-align:center;color:var(--muted);">Không có dữ liệu</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="r" items="${byReason}">
                                        <tr>
                                            <td>${r.reasonName}</td>
                                            <td>${r.machineCount}</td>
                                            <td><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                            <td class="loss-val"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="table-card">
                    <h3>Top model bị thanh lý</h3>
                    <table class="users">
                        <thead>
                            <tr><th>Model</th><th>Số máy</th><th>Tổn thất</th></tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty byModel}">
                                    <tr><td colspan="3" style="text-align:center;color:var(--muted);">Không có dữ liệu</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="r" items="${byModel}">
                                        <tr>
                                            <td>${r.modelName}</td>
                                            <td>${r.machineCount}</td>
                                            <td class="loss-val"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <%-- WAREHOUSE_TABLE_PLACEHOLDER --%>

            <div class="table-card" style="margin-top:16px;">
                <h3>Theo kho</h3>
                <table class="users">
                    <thead>
                        <tr>
                            <th>Kho</th><th>Số máy</th><th>Nguyên giá</th>
                            <th>Thu hồi</th><th>Tổn thất</th><th>Tỷ lệ thu hồi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty byWarehouse}">
                                <tr><td colspan="6" style="text-align:center;color:var(--muted);">Không có dữ liệu</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${byWarehouse}">
                                    <tr>
                                        <td>${r.warehouseName}</td>
                                        <td>${r.machineCount}</td>
                                        <td><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                        <td><fmt:formatNumber value="${r.totalLiquidation}" type="number" maxFractionDigits="0"/></td>
                                        <td class="loss-val"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
                                        <td>
                                            <span class="rate-pill ${r.recoveryRate >= 50 ? 'rate-good' : (r.recoveryRate >= 25 ? 'rate-mid' : 'rate-bad')}">
                                                <fmt:formatNumber value="${r.recoveryRate}" maxFractionDigits="1"/>%
                                            </span>
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
</body>
</html>
