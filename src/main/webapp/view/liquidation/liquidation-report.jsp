<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Báo cáo thanh lý chi tiết — Warehouse OS</title>
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
        table.rpt .col-code { width: 110px; white-space: nowrap; }
        table.rpt .col-date { width: 95px; white-space: nowrap; }
        table.rpt .col-serial { width: 130px; font-family: var(--font-mono); font-size: 12px; white-space: nowrap; }
        table.rpt .col-money { width: 120px; }
        table.rpt .col-model { width: 90px; white-space: nowrap; }
        table.rpt .col-wh { width: 100px; }
        table.rpt .col-reason { width: 120px; }
        .rpt-text { white-space: normal; }
        .rpt-text > div { max-width: 140px; overflow-wrap: break-word; }
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

        @media (max-width: 1100px) { .report-main { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .rpt-kpis { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Báo cáo thanh lý</h1>
            <span class="crumb">/ Quản lý kho / Thanh lý / Báo cáo chi tiết</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
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
                    <h2 class="page-title">Báo cáo thanh lý chi tiết</h2>
                    <div class="page-sub">Thống kê chi tiết từng máy đã thanh lý trong kỳ</div>
                </div>
            </div>

            <c:if test="${not empty dateError}">
                <div class="feedback-banner feedback-banner--danger">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="body"><div class="feedback-banner__body">${dateError}</div></div>
                </div>
            </c:if>

            <%-- Filter --%>
            <div class="section-head" style="margin-bottom: 16px;">
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

            <%-- KPI Cards (dashboard style, 3 cols) --%>
            <c:if test="${not empty summary}">
                <div class="rpt-kpis">
                    <div class="rpt-kpi">
                        <div class="label">Tổng số máy <span class="dot" style="background:var(--info)"></span></div>
                        <div class="value">${summary.machineCount}</div>
                        <div class="delta">
                            <span class="sub">${summary.orderCount} đơn</span>
                        </div>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Tổng giá nhập <span class="dot" style="background:var(--accent)"></span></div>
                        <div class="value"><fmt:formatNumber value="${summary.totalOriginal / 1000000}" type="number" maxFractionDigits="1"/><span class="unit">tr</span></div>
                        <div class="delta">
                            <span class="sub">Giá TL <fmt:formatNumber value="${summary.totalLiquidation / 1000000}" type="number" maxFractionDigits="1"/>tr · Chênh lệch <fmt:formatNumber value="${summary.totalLoss / 1000000}" type="number" maxFractionDigits="1"/>tr</span>
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline id="spk-orig-fill" fill="var(--accent)" opacity="0.12"/>
                            <polyline id="spk-orig" fill="none" stroke="var(--accent)" stroke-width="1.6"/>
                        </svg>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Tỷ lệ hồi vốn <span class="dot" style="background:var(--accent)"></span></div>
                        <div class="value"><fmt:formatNumber value="${summary.recoveryRate}" type="number" maxFractionDigits="1"/><span class="unit">%</span></div>
                        <div class="delta">
                            <span class="sub">Giá TL <fmt:formatNumber value="${summary.totalLiquidation / 1000000}" type="number" maxFractionDigits="1"/>tr / Giá nhập <fmt:formatNumber value="${summary.totalOriginal / 1000000}" type="number" maxFractionDigits="1"/>tr</span>
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline id="spk-loss-fill" fill="var(--danger)" opacity="0.12"/>
                            <polyline id="spk-loss" fill="none" stroke="var(--danger)" stroke-width="1.6"/>
                        </svg>
                    </div>
                </div>
            </c:if>

            <%-- Main content: Chart (left) + Analytics (right) --%>
            <div class="report-main">

                <%-- Left: Monthly trend chart --%>
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
                                    <span class="legend-swatch" style="width: 10px; height: 2px; border-radius: 2px; background: var(--accent);"></span>Giá nhập
                                </span>
                                <span class="legend-item" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-swatch" style="width: 10px; height: 2px; border-radius: 2px; background: var(--info);"></span>Giá thanh lý
                                </span>
                                <span class="legend-item" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-swatch" style="width: 10px; height: 2px; border-radius: 2px; background: var(--danger);"></span>Chênh lệch giá
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <%-- Right: Analytics stacked --%>
                <div class="analytics-stacked">
                    <section class="card" style="margin-bottom:12px;">
                        <h3 style="font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;margin:0;padding:10px 14px;border-bottom:1px solid var(--border);">Phân tích theo lý do</h3>
                        <div style="overflow-x:auto;">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Lý do</th>
                                    <th class="num">Số máy</th>
                                    <th class="num">Giá nhập</th>
                                    <th class="num">Chênh lệch</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty byReason}">
                                        <tr><td colspan="4" class="empty-cell">Không có dữ liệu</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${byReason}">
                                            <tr>
                                                <td>${r.reasonName}</td>
                                                <td class="num">${r.machineCount}</td>
                                                <td class="num"><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                                <td class="num" style="color: ${r.totalLoss != null && r.totalLoss.signum() < 0 ? 'var(--danger)' : (r.totalLoss != null && r.totalLoss.signum() > 0 ? 'var(--accent)' : '')};">
                                                    <fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </div>
                    </section>
                    <section class="card" style="margin-bottom:0;">
                        <h3 style="font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;margin:0;padding:10px 14px;border-bottom:1px solid var(--border);">Phân tích theo kho</h3>
                        <div style="overflow-x:auto;">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Kho</th>
                                    <th class="num">Số máy</th>
                                    <th class="num">Giá nhập</th>
                                    <th class="num">% Hồi vốn</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty byWarehouse}">
                                        <tr><td colspan="4" class="empty-cell">Không có dữ liệu</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${byWarehouse}">
                                            <tr>
                                                <td>${r.warehouseName}</td>
                                                <td class="num">${r.machineCount}</td>
                                                <td class="num"><fmt:formatNumber value="${r.totalOriginal}" type="number" maxFractionDigits="0"/></td>
                                                <td class="num" style="color: var(--accent);">
                                                    <fmt:formatNumber value="${r.recoveryRate}" type="number" maxFractionDigits="1"/>%
                                                </td>
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
                    danger:   isDark ? '#f87171' : '#ef4444',
                    muted:    isDark ? '#9ca3af' : '#6b7280',
                    border:   isDark ? '#374151' : '#e5e7eb',
                    surface:  isDark ? '#1f2937' : '#ffffff'
                };
                var fontMono = "'JetBrains Mono', 'IBM Plex Mono', ui-monospace, Menlo, monospace";

                function fmt(v) { return (v / 1000000).toFixed(0) + 'M'; }

                var len = monthlyData.length;
                var labels = monthlyData.map(function(m) { return m.month; });

                function lastPoint(idx, data) {
                    var arr = new Array(data.length).fill(0);
                    arr[data.length - 1] = idx === 0 ? 5 : 4;
                    return arr;
                }
                var datasets = [
                    { label: 'Giá nhập',       key: 'totalOriginal',      color: colors.accent },
                    { label: 'Giá thanh lý',    key: 'totalLiquidation',   color: colors.info },
                    { label: 'Chênh lệch giá',  key: 'totalLoss',          color: colors.danger }
                ].map(function(ds, idx) {
                    var data = monthlyData.map(function(m) { return m[ds.key]; });
                    return {
                        label: ds.label,
                        data: data,
                        borderColor: ds.color,
                        backgroundColor: ds.color + '1a',
                        fill: idx === 0,
                        tension: 0.3,
                        pointRadius: lastPoint(idx, data),
                        pointHoverRadius: function(ctx) {
                            return ctx.dataIndex === len - 1 ? 6 : 4;
                        },
                        pointBackgroundColor: data.map(function(_, i) {
                            return i === len - 1 ? ds.color : 'transparent';
                        }),
                        pointBorderColor: data.map(function(_, i) {
                            return i === len - 1 ? ds.color : 'transparent';
                        }),
                        pointBorderWidth: function(ctx) {
                            return ctx.dataIndex === len - 1 ? 2 : 0;
                        },
                        borderWidth: idx === 0 ? 2 : (idx === 1 ? 1.6 : 1.6),
                        borderDash: idx === 0 ? [] : [4, 3]
                    };
                });

                new Chart(ctx, {
                    type: 'line',
                    data: { labels: labels, datasets: datasets },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        interaction: {
                            intersect: false,
                            mode: 'index'
                        },
                        hover: {
                            mode: 'index',
                            intersect: false
                        },
                        scales: {
                            y: {
                                beginAtZero: false,
                                border: { display: false },
                                grid: { color: colors.border + '40' },
                                ticks: {
                                    callback: function(v) { return fmt(v); },
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
                sparkline('totalOriginal', 'spk-orig', 'spk-orig-fill');
                sparkline('totalLoss', 'spk-loss', 'spk-loss-fill');
            })();
            </script>

            <%-- Detail table --%>
            <div class="section-label">Chi tiết từng máy</div>
            <section class="card">
                <div style="overflow-x: auto;">
                <table class="rpt">
                    <thead>
                        <tr>
                            <th class="col-stt">#</th>
                            <th class="col-code">Mã đơn</th>
                            <th class="col-date">Ngày TL</th>
                            <th class="col-wh">Kho</th>
                            <th class="col-reason">Lý do</th>
                            <th class="col-serial">Số serial</th>
                            <th class="col-model">Mẫu máy</th>
                            <th>Tình trạng</th>
                            <th class="num col-money">Giá nhập</th>
                            <th class="num col-money">Giá TL</th>
                            <th class="num col-money">Chênh lệch</th>
                            <th>Khách hàng</th>
                            <th>Người duyệt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty rows}">
                                <tr><td colspan="13" class="empty-cell">Không có dữ liệu thanh lý trong khoảng thời gian này.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${rows}" varStatus="vs">
                                    <tr>
                                        <td class="col-stt">${vs.count + (currentPage - 1) * pageSize}</td>
                                        <td class="col-code"><a href="${pageContext.request.contextPath}/liquidations?action=detail&id=${r.liquidationId}">${r.liquidationCode}</a></td>
                                        <td class="col-date">${r.reviewedAtStr}</td>
                                        <td class="col-wh">${r.warehouseName}</td>
                                        <td class="col-reason">${r.reasonName}</td>
                                        <td class="col-serial">${r.serialNumber}</td>
                                        <td class="col-model">${r.modelName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                <c:when test="${r.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                <c:when test="${r.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="num col-money"><fmt:formatNumber value="${r.originalPrice}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num col-money"><fmt:formatNumber value="${r.liquidationPrice}" type="number" maxFractionDigits="0"/></td>
                                        <td class="num col-money" style="color: ${r.totalLoss != null && r.totalLoss.signum() < 0 ? 'var(--danger)' : (r.totalLoss != null && r.totalLoss.signum() > 0 ? 'var(--accent)' : '')};">
                                            <fmt:formatNumber value="${r.totalLoss}" type="number" maxFractionDigits="0"/>
                                        </td>
                                        <td class="rpt-text"><div>${empty r.customerName ? '—' : r.customerName}</div></td>
                                        <td class="rpt-text"><div>${empty r.ceoName ? '—' : r.ceoName}</div></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                    <c:if test="${not empty rows}">
                        <c:set var="sumOrig" value="0"/>
                        <c:set var="sumLiq" value="0"/>
                        <c:set var="sumLoss" value="0"/>
                        <c:forEach var="r" items="${rows}">
                            <c:set var="sumOrig" value="${sumOrig + r.originalPrice}"/>
                            <c:set var="sumLiq" value="${sumLiq + r.liquidationPrice}"/>
                            <c:set var="sumLoss" value="${sumLoss + r.totalLoss}"/>
                        </c:forEach>
                        <tfoot>
                            <tr>
                                <td class="col-stt"></td>
                                <td colspan="5">Tổng (${fn:length(rows)} máy)</td>
                                <td></td>
                                <td class="num col-money"><fmt:formatNumber value="${sumOrig}" type="number" maxFractionDigits="0"/></td>
                                <td class="num col-money"><fmt:formatNumber value="${sumLiq}" type="number" maxFractionDigits="0"/></td>
                                <td class="num col-money" style="color: ${sumLoss < 0 ? 'var(--danger)' : (sumLoss > 0 ? 'var(--accent)' : '')};">
                                    <fmt:formatNumber value="${sumLoss}" type="number" maxFractionDigits="0"/>
                                </td>
                                <td colspan="2"></td>
                            </tr>
                        </tfoot>
                    </c:if>
                </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <c:set var="filterParams" value="fromDate=${fromDate}&toDate=${toDate}"/>
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
