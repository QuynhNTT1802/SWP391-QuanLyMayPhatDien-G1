<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Báo cáo nhập kho chi tiết — Warehouse OS</title>
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
        table.rpt th, table.rpt td { text-align: start; padding: 8px 10px; border-bottom: 1px solid var(--border); }
        table.rpt th { white-space: nowrap; font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); border-bottom: 1px solid var(--border-strong); border-top: 1px solid var(--border); }
        table.rpt tbody tr:hover { background: var(--surface-2); }
        table.rpt tfoot td { padding: 10px 12px; background: var(--surface-2); border-top: 2px solid var(--border-strong); font-weight: 600; }
        td.num, th.num { text-align: end; font-family: var(--font-mono); white-space: nowrap; }
        table.rpt .col-stt { width: 40px; text-align: center; white-space: nowrap; }
        table.rpt .col-code { width: 140px; white-space: nowrap; font-family: var(--font-mono); }
        table.rpt .col-date { width: 95px; white-space: nowrap; }
        table.rpt .col-wh { width: 110px; }
        table.rpt .col-status { width: 105px; }
        table.rpt .col-qty { width: 70px; text-align: end; font-family: var(--font-mono); }
        table.rpt .col-ref { width: 130px; font-family: var(--font-mono); font-size: 12px; }
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
        .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
        [data-theme="light"] .theme-toggle .icon-moon { display: block; }
        [data-theme="dark"] .theme-toggle .icon-sun { display: block; }
        .section-label { font-size: 13px; font-weight: 600; color: var(--fg); margin-bottom: 10px; display: flex; align-items: center; gap: 6px; }
        .rpt-kpis { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 18px; }
        .rpt-kpi { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px 16px; position: relative; }
        .rpt-kpi .label { display: flex; align-items: center; justify-content: space-between; font-size: 11.5px; color: var(--muted); font-weight: 500; letter-spacing: 0.01em; margin-bottom: 10px; }
        .rpt-kpi .label .dot { width: 6px; height: 6px; border-radius: 50%; background: var(--accent); }
        .rpt-kpi .value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; color: var(--fg); }
        .rpt-kpi .value .unit { font-size: 13px; font-weight: 500; color: var(--muted); margin-inline-start: 4px; }
        .rpt-kpi .delta { margin-top: 8px; display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); }
        .rpt-kpi .spark { margin-top: 12px; height: 32px; width: 100%; display: block; }
        .report-main { display: grid; grid-template-columns: 2fr 1fr; gap: 12px; margin-bottom: 18px; }
        .report-main .card { margin: 0; }
        .analytics-stacked { display: flex; flex-direction: column; gap: 12px; }
        table.rpt-as { width: 100%; border-collapse: collapse; font-size: 12.5px; }
        table.rpt-as th { font-size: 10.5px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; padding: 8px 10px; text-align: start; border-bottom: 1px solid var(--border-strong); background: var(--surface-2); }
        table.rpt-as th.num { text-align: end; }
        table.rpt-as td { padding: 7px 10px; border-bottom: 1px solid var(--border); }
        table.rpt-as tbody tr:last-child td { border-bottom: none; }
        table.rpt-as tbody tr:hover { background: var(--surface-2); }
        .status-pill { display: inline-block; padding: 2px 8px; border-radius: 999px; font-size: 11.5px; font-weight: 600; white-space: nowrap; }
        .status-pill.completed { background: rgba(34, 197, 94, 0.12); color: #15803d; }
        .status-pill.pending { background: rgba(234, 179, 8, 0.15); color: #a16207; }
        .status-pill.cancelled { background: rgba(239, 68, 68, 0.12); color: #b91c1c; }
        .rpt-text { white-space: normal; }
        .rpt-text > div { max-width: 220px; overflow-wrap: break-word; }
        @media (max-width: 1100px) { .report-main { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .rpt-kpis { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Báo cáo nhập kho</h1>
            <span class="crumb">/ Kho / Phiếu nhập / Báo cáo chi tiết</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                </button>
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Báo cáo nhập kho chi tiết</h2>
                    <div class="page-sub">Thống kê chi tiết các phiếu nhập kho trong kỳ</div>
                </div>
            </div>

            <c:if test="${not empty dateError}">
                <div class="feedback-banner feedback-banner--danger">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="body"><div class="feedback-banner__body">${dateError}</div></div>
                </div>
            </c:if>

            <div class="section-head" style="margin-bottom: 16px;">
                <form class="report-filter" method="get" action="${pageContext.request.contextPath}/receipts/report">
                    <input type="hidden" name="type" value="IMPORT"/>
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
                    <a class="btn" href="${pageContext.request.contextPath}/receipts/report?action=export&type=IMPORT&fromDate=${fromDate}&toDate=${toDate}<c:if test='${not empty selectedWarehouseId}'>&warehouseId=${selectedWarehouseId}</c:if>">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Xuất Excel
                    </a>
                </form>
            </div>

            <c:if test="${not empty summary}">
                <div class="rpt-kpis">
                    <div class="rpt-kpi">
                        <div class="label">Tổng số phiếu nhập <span class="dot" style="background:var(--info)"></span></div>
                        <div class="value">${summary.totalReceipts}</div>
                        <div class="delta">
                            <span class="sub">Chờ duyệt ${summary.pendingCount} · Huỷ ${summary.cancelledCount}</span>
                        </div>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Tổng số máy nhập <span class="dot" style="background:var(--accent)"></span></div>
                        <div class="value">${summary.totalMachines}</div>
                        <div class="delta">
                            <span class="sub">Trung bình ${summary.totalReceipts > 0 ? (summary.totalMachines / summary.totalReceipts) : 0} máy / phiếu</span>
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline id="spk-machines-fill" fill="var(--accent)" opacity="0.12"/>
                            <polyline id="spk-machines" fill="none" stroke="var(--accent)" stroke-width="1.6"/>
                        </svg>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Phiếu hoàn thành <span class="dot" style="background:var(--accent)"></span></div>
                        <div class="value">${summary.completedCount}</div>
                        <div class="delta">
                            <span class="sub">Tỷ lệ hoàn thành ${summary.completionRate}%</span>
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline id="spk-receipts-fill" fill="var(--info)" opacity="0.12"/>
                            <polyline id="spk-receipts" fill="none" stroke="var(--info)" stroke-width="1.6"/>
                        </svg>
                    </div>
                </div>
            </c:if>

            <div class="report-main">
                <section class="card" style="margin-bottom:0;">
                    <div class="card-head" style="padding:12px 16px 0;">
                        <h3 style="font-size:13px;font-weight:600;margin:0;">Phân tích theo tháng</h3>
                    </div>
                    <c:choose>
                        <c:when test="${empty monthlyTrend}">
                            <div class="empty-cell">Không có dữ liệu</div>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 8px 14px 4px;">
                                <canvas id="monthlyChart" height="240" style="display: block; width: 100%;"></canvas>
                            </div>
                            <div class="chart-legend" style="display: flex; align-items: center; gap: 20px; padding: 8px 18px 14px; font-size: 12px; color: var(--muted); border-top: 1px solid var(--border); margin-top: 4px;">
                                <span class="legend-item" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-swatch" style="width: 10px; height: 2px; border-radius: 2px; background: var(--accent);"></span>Số phiếu nhập
                                </span>
                                <span class="legend-item" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-swatch" style="width: 10px; height: 2px; border-radius: 2px; background: var(--info);"></span>Số máy nhập
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <div class="analytics-stacked">
                    <section class="card" style="margin-bottom:12px;">
                        <h3 style="font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;margin:0;padding:10px 14px;border-bottom:1px solid var(--border);">Phân tích theo kho</h3>
                        <div style="overflow-x:auto;">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Kho</th>
                                    <th class="num">Số phiếu</th>
                                    <th class="num">Số máy</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty byWarehouse}">
                                        <tr><td colspan="3" class="empty-cell">Không có dữ liệu</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${byWarehouse}">
                                            <tr>
                                                <td>${r.warehouseName}</td>
                                                <td class="num">${r.receiptCount}</td>
                                                <td class="num">${r.machineCount}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </div>
                    </section>
                    <section class="card" style="margin-bottom:0;">
                        <h3 style="font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;margin:0;padding:10px 14px;border-bottom:1px solid var(--border);">Phân tích theo trạng thái</h3>
                        <div style="overflow-x:auto;">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Trạng thái</th>
                                    <th class="num">Số phiếu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty byStatus}">
                                        <tr><td colspan="2" class="empty-cell">Không có dữ liệu</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${byStatus}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.status == 'COMPLETED'}"><span class="status-pill completed">Hoàn thành</span></c:when>
                                                        <c:when test="${r.status == 'PENDING'}"><span class="status-pill pending">Chờ duyệt</span></c:when>
                                                        <c:when test="${r.status == 'CANCELLED'}"><span class="status-pill cancelled">Đã huỷ</span></c:when>
                                                        <c:otherwise>${r.status}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="num">${r.receiptCount}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </div>
                    </section>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
            <script>
            (function() {
                var monthlyData = ${monthlyTrendJson};
                if (!monthlyData || monthlyData.length === 0) return;
                var ctx = document.getElementById('monthlyChart');
                if (!ctx) return;

                var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
                var colors = {
                    accent:   isDark ? '#4ade80' : '#22c55e',
                    info:     isDark ? '#60a5fa' : '#3b82f6',
                    muted:    isDark ? '#9ca3af' : '#6b7280',
                    border:   isDark ? '#374151' : '#e5e7eb',
                    surface:  isDark ? '#1f2937' : '#ffffff'
                };
                var fontMono = "'JetBrains Mono', 'IBM Plex Mono', ui-monospace, Menlo, monospace";

                var len = monthlyData.length;
                var labels = monthlyData.map(function(m) { return m.month; });

                var datasets = [
                    { label: 'S\u1ed1 phi\u1ebfu nh\u1eadp',  key: 'receiptCount', color: colors.accent, dashed: false, fill: true },
                    { label: 'S\u1ed1 m\u00e1y nh\u1eadp',     key: 'machineCount', color: colors.info,   dashed: true,  fill: false }
                ].map(function(ds, idx) {
                    var data = monthlyData.map(function(m) { return m[ds.key]; });
                    var lastDot = function(_, i) { return i === len - 1 ? ds.color : 'transparent'; };
                    return {
                        label: ds.label,
                        data: data,
                        borderColor: ds.color,
                        backgroundColor: ds.color + '1a',
                        fill: ds.fill,
                        tension: 0.3,
                        pointRadius: 3,
                        pointHoverRadius: 5,
                        pointBackgroundColor: data.map(lastDot),
                        pointBorderColor: data.map(lastDot),
                        pointBorderWidth: function(c) { return c.dataIndex === len - 1 ? 2 : 0; },
                        borderWidth: idx === 0 ? 2 : 1.6,
                        borderDash: ds.dashed ? [4, 3] : []
                    };
                });

                new Chart(ctx, {
                    type: 'line',
                    data: { labels: labels, datasets: datasets },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        interaction: { intersect: false, mode: 'index' },
                        hover: { mode: 'index', intersect: false },
                        scales: {
                            y: {
                                beginAtZero: true,
                                border: { display: false },
                                grid: { color: colors.border + '40' },
                                ticks: {
                                    font: { family: fontMono, size: 10 },
                                    color: colors.muted,
                                    padding: 6
                                }
                            },
                            x: {
                                border: { display: false },
                                grid: { display: false },
                                ticks: {
                                    font: { family: fontMono, size: 10 },
                                    color: colors.muted,
                                    padding: 6
                                }
                            }
                        }
                    }
                });
            })();
            </script>
            <script>
            (function() {
                var data = ${monthlyTrendJson};
                if (!data || data.length === 0) return;
                function sparkline(dataKey, lineId, fillId) {
                    var values = data.map(function(m) { return Number(m[dataKey]); });
                    var min = Math.min.apply(null, values);
                    var max = Math.max.apply(null, values);
                    var range = max - min || 1;
                    var w = 120, h = 32, pad = 2;
                    var pts = values.map(function(v, i) {
                        var x = pad + (i / (data.length - 1 || 1)) * (w - 2 * pad);
                        var y = pad + (1 - (v - min) / range) * (h - 2 * pad);
                        return x.toFixed(1) + ',' + y.toFixed(1);
                    }).join(' ');
                    var line = document.getElementById(lineId);
                    if (line) line.setAttribute('points', pts);
                    if (fillId) {
                        var fill = document.getElementById(fillId);
                        if (fill) fill.setAttribute('points', pts + ' ' + (w - pad).toFixed(1) + ',' + h + ' ' + pad + ',' + h);
                    }
                }
                sparkline('machineCount', 'spk-machines', 'spk-machines-fill');
                sparkline('receiptCount', 'spk-receipts', 'spk-receipts-fill');
            })();
            </script>

            <div class="section-label">Chi tiết từng phiếu</div>
            <section class="card">
                <div style="overflow-x: auto;">
                <table class="rpt">
                    <thead>
                        <tr>
                            <th class="col-stt">#</th>
                            <th class="col-code">Mã phiếu</th>
                            <th class="col-date">Ngày lập phiếu</th>
                            <th class="col-wh">Kho</th>
                            <th class="col-status">Trạng thái</th>
                            <th class="col-qty">Số máy</th>
                            <th class="col-ref">Mã phiếu mua</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty rows}">
                                <tr><td colspan="8" class="empty-cell">Không có dữ liệu nhập kho trong khoảng thời gian này.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${rows}" varStatus="vs">
                                    <tr>
                                        <td class="col-stt">${vs.count + (currentPage - 1) * pageSize}</td>
                                        <td class="col-code">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${r.receiptId}">${r.receiptCode}</a>
                                        </td>
                                        <td class="col-date">${empty r.createdAtStr ? '—' : r.createdAtStr}</td>
                                        <td class="col-wh">${r.warehouseName}</td>
                                        <td class="col-status">
                                            <c:choose>
                                                <c:when test="${r.status == 'COMPLETED'}"><span class="status-pill completed">Hoàn thành</span></c:when>
                                                <c:when test="${r.status == 'PENDING'}"><span class="status-pill pending">Chờ duyệt</span></c:when>
                                                <c:when test="${r.status == 'CANCELLED'}"><span class="status-pill cancelled">Đã huỷ</span></c:when>
                                                <c:otherwise>${r.status}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-qty">${r.machineCount}</td>
                                        <td class="col-ref">${empty r.purchaseOrderCode ? '—' : r.purchaseOrderCode}</td>
                                        <td class="rpt-text"><div>${empty r.note ? '—' : r.note}</div></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                    <c:if test="${not empty rows}">
                        <c:set var="sumQty" value="0"/>
                        <c:forEach var="r" items="${rows}">
                            <c:set var="sumQty" value="${sumQty + r.machineCount}"/>
                        </c:forEach>
                        <tfoot>
                            <tr>
                                <td class="col-stt"></td>
                                <td colspan="3">Tổng (${fn:length(rows)} phiếu)</td>
                                <td class="col-qty">${sumQty}</td>
                                <td colspan="3"></td>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <c:set var="filterParams" value="type=IMPORT&fromDate=${fromDate}&toDate=${toDate}"/>
                    <c:if test="${not empty selectedWarehouseId}">
                        <c:set var="filterParams" value="${filterParams}&warehouseId=${selectedWarehouseId}"/>
                    </c:if>
                    <div class="pagination">
                        <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                        <div class="controls">
                            <c:if test="${currentPage > 1}">
                                <a href="?${filterParams}&page=${currentPage - 1}" class="page-btn">‹</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                    <c:otherwise><a href="?${filterParams}&page=${p}" class="page-btn">${p}</a></c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?${filterParams}&page=${currentPage + 1}" class="page-btn">›</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </section>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
