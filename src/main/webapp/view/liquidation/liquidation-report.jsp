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
        /* ----- KPI cards (dashboard style) ----- */
        .kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
        .kpi { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px 16px; }
        .kpi .label { display: flex; align-items: center; justify-content: space-between; font-size: 11.5px; color: var(--muted); font-weight: 500; letter-spacing: 0.01em; margin-bottom: 10px; }
        .kpi .label .dot { width: 6px; height: 6px; border-radius: 50%; background: var(--accent); }
        .kpi .value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; color: var(--fg); }
        .kpi .value .unit { font-size: 13px; font-weight: 500; color: var(--muted); margin-inline-start: 4px; }
        .kpi .value.neg { color: var(--danger); }
        .kpi .delta { margin-top: 8px; display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); }
        .delta .change { display: inline-flex; align-items: center; gap: 2px; font-family: var(--font-mono); font-weight: 500; padding: 1px 6px; border-radius: 3px; font-size: 11.5px; }
        .change.up { color: var(--accent); background: var(--accent-soft); }
        .change.down { color: var(--danger); background: var(--danger-soft); }
        .change.flat { color: var(--muted); background: var(--surface-2); }
        .kpi .spark { margin-top: 12px; height: 32px; width: 100%; }

        /* ----- Layout ----- */
        .grid-2 { display: grid; grid-template-columns: minmax(0, 2fr) minmax(0, 1fr); gap: 12px; }
        .chart { width: 100%; height: 240px; }
        .chart-legend { display: flex; align-items: center; gap: 20px; margin-top: 4px; padding: 0 4px; font-size: 12px; color: var(--muted); }
        .legend-item { display: inline-flex; align-items: center; gap: 6px; }
        .legend-swatch { width: 10px; height: 2px; border-radius: 2px; }

        /* ----- Rank list (top model / theo lý do) ----- */
        .rank-list { display: flex; flex-direction: column; }
        .rank { display: grid; grid-template-columns: 22px 1fr auto; gap: 12px; align-items: center; padding: 10px 0; border-bottom: 1px dashed var(--border); }
        .rank:last-child { border-bottom: 0; }
        .rank-no { width: 22px; height: 22px; border-radius: 6px; display: grid; place-items: center; background: var(--surface-2); border: 1px solid var(--border); font-family: var(--font-mono); font-size: 11px; font-weight: 600; color: var(--muted); }
        .rank:nth-child(1) .rank-no { background: var(--accent-soft); color: var(--accent); border-color: transparent; }
        .rank-body { min-width: 0; line-height: 1.3; }
        .rank-title { font-size: 13px; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .rank-sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); }
        .rank-amount { text-align: end; font-family: var(--font-mono); font-size: 13px; font-weight: 500; color: var(--danger); }

        /* ----- Inventory-style table ----- */
        table.inv { width: 100%; border-collapse: collapse; font-size: 13px; }
        table.inv th, table.inv td { text-align: start; padding: 10px 16px; border-bottom: 1px solid var(--border); }
        table.inv th { font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); border-bottom: 1px solid var(--border-strong); border-top: 1px solid var(--border); }
        table.inv tbody tr:hover { background: var(--surface-2); }
        td.num, th.num { text-align: end; font-family: var(--font-mono); }
        td.loss { color: var(--danger); font-weight: 500; }
        .rate-pill { display: inline-flex; align-items: center; gap: 4px; padding: 2px 8px; border-radius: 999px; font-size: 11.5px; font-weight: 600; }
        .rate-good { background: var(--accent-soft); color: var(--accent); }
        .rate-mid { background: var(--warn-soft); color: var(--warn); }
        .rate-bad { background: var(--danger-soft); color: var(--danger); }

        /* ----- Section-head có filter gắn kèm ----- */
        .section-head--filter { align-items: center; gap: 12px; flex-wrap: wrap; }
        .report-filter { display: inline-flex; align-items: center; gap: 8px; flex-wrap: wrap; }
        .report-filter .rf-field { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface); transition: border-color .12s ease, box-shadow .12s ease; }
        .report-filter .rf-field:focus-within { border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .report-filter .rf-sep { color: var(--muted-2); font-size: 12px; }
        .report-filter input[type="date"], .report-filter > select { font-size: 12.5px; font-family: var(--font-ui); color: var(--fg); }
        .report-filter .rf-field input[type="date"] { border: none; background: transparent; padding: 2px 0; outline: none; cursor: pointer; width: 116px; }
        .report-filter > select { padding: 7px 28px 7px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface); cursor: pointer; min-width: 130px; transition: border-color .12s ease, box-shadow .12s ease; }
        .report-filter > select:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .report-filter .btn { padding: 6px 12px; }
        @media (max-width: 900px) {
            .section-head--filter { align-items: stretch; }
            .report-filter { width: 100%; }
        }
        .empty-cell { text-align: center; color: var(--muted); padding: 22px; }

        @media (max-width: 1280px) {
            .kpis { grid-template-columns: repeat(2, 1fr); }
            .grid-2 { grid-template-columns: 1fr; }
        }
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
                    <div class="page-sub">Phân tích tổn thất, thu hồi vốn và xu hướng thanh lý thiết bị</div>
                </div>
            </div>

            <c:if test="${not empty dateError}">
                <div class="feedback-banner feedback-banner--danger">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="body"><div class="feedback-banner__body">${dateError}</div></div>
                </div>
            </c:if>

            <%-- ===== Tính max + giá trị tháng cuối/trước cho sparkline & delta (dữ liệu thật) ===== --%>
            <c:set var="nM" value="${fn:length(monthly)}"/>
            <c:set var="maxLiq" value="0"/><c:set var="maxOrig" value="0"/>
            <c:set var="maxLoss" value="0"/><c:set var="maxCnt" value="0"/>
            <c:set var="lastLiq" value="0"/><c:set var="prevLiq" value="0"/>
            <c:set var="lastLoss" value="0"/><c:set var="prevLoss" value="0"/>
            <c:forEach var="m" items="${monthly}" varStatus="st">
                <c:if test="${m.totalLiquidation > maxLiq}"><c:set var="maxLiq" value="${m.totalLiquidation}"/></c:if>
                <c:if test="${m.totalOriginal > maxOrig}"><c:set var="maxOrig" value="${m.totalOriginal}"/></c:if>
                <c:if test="${m.totalLoss > maxLoss}"><c:set var="maxLoss" value="${m.totalLoss}"/></c:if>
                <c:if test="${m.orderCount > maxCnt}"><c:set var="maxCnt" value="${m.orderCount}"/></c:if>
                <c:if test="${st.index == nM - 1}"><c:set var="lastLiq" value="${m.totalLiquidation}"/><c:set var="lastLoss" value="${m.totalLoss}"/></c:if>
                <c:if test="${st.index == nM - 2}"><c:set var="prevLiq" value="${m.totalLiquidation}"/><c:set var="prevLoss" value="${m.totalLoss}"/></c:if>
            </c:forEach>

            <%-- ===== Build điểm sparkline + line chart trong 1 vòng lặp =====
                 Line kép: đường nguyên giá (trên) + thu hồi (dưới), cùng scale theo maxOrig.
                 origPts/liqPts: 2 đường. liqPtsRev: đường thu hồi đảo chiều để khép vùng tổn thất. --%>
            <c:set var="sLiq" value=""/><c:set var="sOrig" value=""/>
            <c:set var="sLoss" value=""/><c:set var="sCnt" value=""/>
            <c:set var="origPts" value=""/>
            <c:set var="liqPts" value=""/>
            <c:set var="liqPtsRev" value=""/>
            <c:forEach var="m" items="${monthly}" varStatus="st">
                <c:set var="sx" value="${nM > 1 ? (120 * st.index / (nM - 1)) : 60}"/>
                <c:set var="lx" value="${nM > 1 ? (40 + 660 * st.index / (nM - 1)) : 370}"/>
                <c:set var="yOrig" value="${maxOrig > 0 ? 220 - (190 * m.totalOriginal / maxOrig) : 220}"/>
                <c:set var="yLiq" value="${maxOrig > 0 ? 220 - (190 * m.totalLiquidation / maxOrig) : 220}"/>
                <c:set var="sLiq" value="${sLiq} ${sx},${maxLiq > 0 ? 28 - (24 * m.totalLiquidation / maxLiq) : 28}"/>
                <c:set var="sOrig" value="${sOrig} ${sx},${maxOrig > 0 ? 28 - (24 * m.totalOriginal / maxOrig) : 28}"/>
                <c:set var="sLoss" value="${sLoss} ${sx},${maxLoss > 0 ? 28 - (24 * m.totalLoss / maxLoss) : 28}"/>
                <c:set var="sCnt" value="${sCnt} ${sx},${maxCnt > 0 ? 28 - (24 * m.orderCount / maxCnt) : 28}"/>
                <c:set var="origPts" value="${origPts} ${lx},${yOrig}"/>
                <c:set var="liqPts" value="${liqPts} ${lx},${yLiq}"/>
                <c:set var="liqPtsRev" value=" ${lx},${yLiq}${liqPtsRev}"/>
            </c:forEach>

            <%-- ===== KPI ROW ===== --%>
            <section>
                <div class="kpis">
                    <div class="kpi">
                        <div class="label">Số máy đã thanh lý <span class="dot"></span></div>
                        <div class="value">${summary.machineCount}<span class="unit">máy</span></div>
                        <div class="delta"><span class="change flat">${summary.orderCount} đơn</span> đã duyệt trong kỳ</div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline points="${sCnt}" fill="none" stroke="var(--fg-soft)" stroke-width="1.6"/>
                        </svg>
                    </div>

                    <div class="kpi">
                        <div class="label">Tổng nguyên giá</div>
                        <div class="value"><fmt:formatNumber value="${summary.totalOriginal / 1000000}" maxFractionDigits="1"/><span class="unit">tr ₫</span></div>
                        <div class="delta">Giá trị sổ sách thiết bị thanh lý</div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline points="${sOrig}" fill="none" stroke="var(--fg-soft)" stroke-width="1.6"/>
                        </svg>
                    </div>

                    <div class="kpi">
                        <div class="label">Giá trị thu hồi</div>
                        <div class="value"><fmt:formatNumber value="${summary.totalLiquidation / 1000000}" maxFractionDigits="1"/><span class="unit">tr ₫</span></div>
                        <div class="delta">
                            <c:choose>
                                <c:when test="${prevLiq > 0 && lastLiq >= prevLiq}"><span class="change up">▲ <fmt:formatNumber value="${(lastLiq - prevLiq) * 100 / prevLiq}" maxFractionDigits="1"/>%</span></c:when>
                                <c:when test="${prevLiq > 0}"><span class="change down">▼ <fmt:formatNumber value="${(prevLiq - lastLiq) * 100 / prevLiq}" maxFractionDigits="1"/>%</span></c:when>
                                <c:otherwise><span class="change flat">Tỷ lệ ${summary.recoveryRate}%</span></c:otherwise>
                            </c:choose>
                            so tháng trước
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline points="${sLiq}" fill="none" stroke="var(--accent)" stroke-width="1.6"/>
                            <polyline points="${sLiq} 120,32 0,32" fill="var(--accent)" opacity="0.12"/>
                        </svg>
                    </div>

                    <div class="kpi">
                        <div class="label">Tổn thất</div>
                        <div class="value neg"><fmt:formatNumber value="${summary.totalLoss / 1000000}" maxFractionDigits="1"/><span class="unit">tr ₫</span></div>
                        <div class="delta">
                            <c:choose>
                                <c:when test="${prevLoss > 0 && lastLoss > prevLoss}"><span class="change down">▲ <fmt:formatNumber value="${(lastLoss - prevLoss) * 100 / prevLoss}" maxFractionDigits="1"/>%</span></c:when>
                                <c:when test="${prevLoss > 0}"><span class="change up">▼ <fmt:formatNumber value="${(prevLoss - lastLoss) * 100 / prevLoss}" maxFractionDigits="1"/>%</span></c:when>
                                <c:otherwise><span class="change flat">Chênh nguyên giá</span></c:otherwise>
                            </c:choose>
                            so tháng trước
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline points="${sLoss}" fill="none" stroke="var(--danger)" stroke-width="1.6"/>
                        </svg>
                    </div>
                </div>
            </section>

            <div class="section-head section-head--filter">
                <h2>Xu hướng giá trị thu hồi</h2>
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

            <section class="grid-2">
                <%-- ----- Line chart kép + vùng tổn thất ----- --%>
                <div class="card">
                    <div class="card-head">
                        <div>
                            <h3>Nguyên giá vs Thu hồi theo tháng</h3>
                            <div class="sub" style="margin-top:2px">Vùng tô = tổn thất · Đơn vị: triệu ₫</div>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty monthly}">
                                <div class="empty-cell">Chưa có dữ liệu thanh lý trong khoảng thời gian này.</div>
                            </c:when>
                            <c:otherwise>
                                <svg class="chart" viewBox="0 0 720 240" preserveAspectRatio="none">
                                    <g stroke="var(--border)" stroke-width="1">
                                        <line x1="40" y1="20" x2="710" y2="20"/>
                                        <line x1="40" y1="73" x2="710" y2="73" stroke-dasharray="2,3"/>
                                        <line x1="40" y1="126" x2="710" y2="126" stroke-dasharray="2,3"/>
                                        <line x1="40" y1="173" x2="710" y2="173" stroke-dasharray="2,3"/>
                                        <line x1="40" y1="220" x2="710" y2="220"/>
                                    </g>
                                    <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="end">
                                        <text x="34" y="24"><fmt:formatNumber value="${maxOrig / 1000000}" maxFractionDigits="0"/></text>
                                        <text x="34" y="224">0</text>
                                    </g>
                                    <%-- Vùng tổn thất: nguyên giá (xuôi) -> thu hồi (ngược) --%>
                                    <polygon points="${origPts}${liqPtsRev}" fill="var(--danger)" opacity="0.12"/>
                                    <%-- Đường thu hồi (dưới) --%>
                                    <polyline points="${liqPts}" fill="none" stroke="var(--accent)" stroke-width="2"/>
                                    <%-- Đường nguyên giá (trên) --%>
                                    <polyline points="${origPts}" fill="none" stroke="var(--fg-soft)" stroke-width="2" stroke-dasharray="4,3"/>
                                    <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="middle">
                                        <c:forEach var="m" items="${monthly}" varStatus="st">
                                            <text x="${nM > 1 ? (40 + 660 * st.index / (nM - 1)) : 370}" y="236">${m.month}</text>
                                        </c:forEach>
                                    </g>
                                </svg>
                                <div class="chart-legend">
                                    <span class="legend-item"><span class="legend-swatch" style="background:var(--fg-soft); border-top:1px dashed var(--fg-soft)"></span>Nguyên giá</span>
                                    <span class="legend-item"><span class="legend-swatch" style="background:var(--accent)"></span>Thu hồi</span>
                                    <span class="legend-item"><span class="legend-swatch" style="background:var(--danger); opacity:0.4; height:8px; border-radius:2px"></span>Tổn thất</span>
                                    <span class="legend-item" style="margin-inline-start:auto">Tỷ lệ thu hồi <span class="mono" style="color:var(--accent)">${summary.recoveryRate}%</span></span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%-- ----- Top model ----- --%>
                <div class="card">
                    <div class="card-head"><h3>Top model bị thanh lý</h3></div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty byModel}">
                                <div class="empty-cell">Không có dữ liệu</div>
                            </c:when>
                            <c:otherwise>
                                <div class="rank-list">
                                    <c:forEach var="r" items="${byModel}" varStatus="st">
                                        <div class="rank">
                                            <div class="rank-no">${st.count}</div>
                                            <div class="rank-body">
                                                <div class="rank-title">${r.modelName}</div>
                                                <div class="rank-sub">${r.machineCount} máy</div>
                                            </div>
                                            <div class="rank-amount">−<fmt:formatNumber value="${r.totalLoss / 1000000}" maxFractionDigits="1"/> tr</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </section>

            <div class="section-head">
                <h2>Phân tích theo lý do thanh lý</h2>
                <span class="meta">${fn:length(byReason)} nhóm lý do</span>
            </div>
            <section class="card" style="overflow:hidden">
                <table class="inv">
                    <thead>
                        <tr><th>Lý do</th><th class="num">Số máy</th><th class="num">Nguyên giá</th><th class="num">Thu hồi</th><th class="num">Tổn thất</th></tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty byReason}">
                                <tr><td colspan="5" class="empty-cell">Không có dữ liệu</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${byReason}">
                                    <tr>
                                        <td>${r.reasonName}</td>
                                        <td class="num">${r.machineCount}</td>
                                        <td class="num"><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num"><fmt:formatNumber value="${r.totalLiquidation}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num loss"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </section>

            <div class="section-head">
                <h2>Chi tiết theo kho</h2>
                <span class="meta">${fn:length(byWarehouse)} kho</span>
            </div>
            <section class="card" style="overflow:hidden">
                <table class="inv">
                    <thead>
                        <tr>
                            <th>Kho</th><th class="num">Số máy</th><th class="num">Nguyên giá</th>
                            <th class="num">Thu hồi</th><th class="num">Tổn thất</th><th>Tỷ lệ thu hồi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty byWarehouse}">
                                <tr><td colspan="6" class="empty-cell">Không có dữ liệu</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${byWarehouse}">
                                    <tr>
                                        <td>${r.warehouseName}</td>
                                        <td class="num">${r.machineCount}</td>
                                        <td class="num"><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num"><fmt:formatNumber value="${r.totalLiquidation}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num loss"><fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/></td>
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
            </section>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
