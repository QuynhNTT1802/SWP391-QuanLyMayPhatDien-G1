<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Báo cáo thẻ kho — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/report-sub.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Báo cáo thẻ kho</h1>
            <span class="crumb">/ Kho / Thẻ kho / Báo cáo chi tiết</span>
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
                    <h2 class="page-title">Báo cáo thẻ kho chi tiết</h2>
                    <div class="page-sub">Thống kê các giao dịch nhập/xuất kho theo kỳ</div>
                </div>
            </div>

            <c:if test="${not empty dateError}">
                <div class="feedback-banner feedback-banner--danger">
                    <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="body"><div class="feedback-banner__body">${dateError}</div></div>
                </div>
            </c:if>

            <div class="section-head rpt-section-head-mb">
                <form class="report-filter" method="get" action="${pageContext.request.contextPath}/stock-card/report">
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
                    <select name="generatorId" title="Mẫu máy">
                        <option value="">Tất cả mẫu máy</option>
                        <c:forEach var="g" items="${generators}">
                            <option value="${g.id}" ${selectedGeneratorId == g.id ? 'selected' : ''}>${g.model}</option>
                        </c:forEach>
                    </select>
                    <select name="type" title="Loại">
                        <option value="">Tất cả loại</option>
                        <option value="IMPORT" ${selectedType == 'IMPORT' ? 'selected' : ''}>Nhập</option>
                        <option value="EXPORT" ${selectedType == 'EXPORT' ? 'selected' : ''}>Xuất</option>
                    </select>
                    <button type="submit" class="btn btn-primary">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3z"/></svg>
                        Lọc
                    </button>
                    <a class="btn" href="${pageContext.request.contextPath}/stock-card/report?action=export&fromDate=${fromDate}&toDate=${toDate}<c:if test='${not empty selectedWarehouseId}'>&warehouseId=${selectedWarehouseId}</c:if><c:if test='${not empty selectedGeneratorId}'>&generatorId=${selectedGeneratorId}</c:if><c:if test='${not empty selectedType}'>&type=${selectedType}</c:if>">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Xuất Excel
                    </a>
                </form>
            </div>

            <c:if test="${not empty summary}">
                <div class="rpt-kpis">
                    <div class="rpt-kpi">
                        <div class="label">Tổng giao dịch <span class="dot rpt-kpi-dot-info"></span></div>
                        <div class="value">${summary.totalTx}</div>
                        <div class="delta">
                            <span class="sub">${summary.warehouseCount} kho · ${summary.modelCount} mẫu máy</span>
                        </div>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Lượng nhập <span class="dot rpt-kpi-dot-accent"></span></div>
                        <div class="value">${summary.importQty}</div>
                        <div class="delta">
                            <span class="sub">Trung bình ${summary.totalTx > 0 ? (summary.importQty / summary.totalTx) : 0} máy / giao dịch</span>
                        </div>
                        <svg class="spark" viewBox="0 0 120 32" preserveAspectRatio="none">
                            <polyline id="spk-import-fill" fill="var(--accent)" opacity="0.12"/>
                            <polyline id="spk-import" fill="none" stroke="var(--accent)" stroke-width="1.6"/>
                        </svg>
                    </div>
                    <div class="rpt-kpi">
                        <div class="label">Biến động ròng <span class="dot rpt-kpi-dot-accent"></span></div>
                        <div class="value"><c:set var="net" value="${summary.netChange}"/>${net >= 0 ? '+' : ''}${summary.netChange}</div>
                        <div class="delta">
                            <span class="sub">Lượng xuất ${summary.exportQty}</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <div class="report-main">
                <section class="card rpt-card-mb0">
                    <div class="card-head rpt-card-head-pad">
                        <h3 class="rpt-card-title">Biến động nhập/xuất theo tháng</h3>
                    </div>
                    <c:choose>
                        <c:when test="${empty monthlyTrend}">
                            <div class="empty-cell">Không có dữ liệu</div>
                        </c:when>
                        <c:otherwise>
                            <div class="rpt-chart-wrap">
                                <canvas id="monthlyChart" height="240" class="rpt-chart-canvas"></canvas>
                            </div>
                            <div class="chart-legend rpt-chart-legend">
                                <span class="legend-item rpt-legend-item">
                                    <span class="legend-swatch rpt-legend-swatch accent"></span>Nhập
                                </span>
                                <span class="legend-item rpt-legend-item">
                                    <span class="legend-swatch rpt-legend-swatch info"></span>Xuất
                                </span>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <div class="analytics-stacked">
                    <section class="card rpt-analytics-card">
                        <h3 class="rpt-analytics-title">Theo kho</h3>
                        <div class="rpt-overflow-x">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Kho</th>
                                    <th class="num">Giao dịch</th>
                                    <th class="num">Nhập</th>
                                    <th class="num">Xuất</th>
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
                                                <td class="num">${r.txCount}</td>
                                                <td class="num">${r.importQty}</td>
                                                <td class="num">${r.exportQty}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </div>
                    </section>
                    <section class="card rpt-card-mb0">
                        <h3 class="rpt-analytics-title">Theo mẫu máy</h3>
                        <div class="rpt-overflow-x">
                        <table class="rpt-as">
                            <thead>
                                <tr>
                                    <th>Mẫu máy</th>
                                    <th class="num">Giao dịch</th>
                                    <th class="num">Nhập</th>
                                    <th class="num">Xuất</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty byGenerator}">
                                        <tr><td colspan="4" class="empty-cell">Không có dữ liệu</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${byGenerator}">
                                            <tr>
                                                <td>${r.generatorModel}</td>
                                                <td class="num">${r.txCount}</td>
                                                <td class="num">${r.importQty}</td>
                                                <td class="num">${r.exportQty}</td>
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
                    border:   isDark ? '#374151' : '#e5e7eb'
                };
                var fontMono = "'JetBrains Mono', 'IBM Plex Mono', ui-monospace, Menlo, monospace";

                var len = monthlyData.length;
                var labels = monthlyData.map(function(m) { return m.month; });

                var datasets = [
                    { label: 'Nh\u1eadp', key: 'importQty', color: colors.accent, dashed: false, fill: true },
                    { label: 'Xu\u1ea5t', key: 'exportQty', color: colors.info,   dashed: true,  fill: false }
                ].map(function(ds, idx) {
                    var data = monthlyData.map(function(m) { return Math.abs(m[ds.key]); });
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
                            y: { beginAtZero: true, border: { display: false }, grid: { color: colors.border + '40' },
                                 ticks: { font: { family: fontMono, size: 10 }, color: colors.muted, padding: 6 } },
                            x: { border: { display: false }, grid: { display: false },
                                 ticks: { font: { family: fontMono, size: 10 }, color: colors.muted, padding: 6 } }
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
                    var values = data.map(function(m) { return Math.abs(Number(m[dataKey])); });
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
                sparkline('importQty', 'spk-import', 'spk-import-fill');
            })();
            </script>

            <div class="section-label">Chi tiết giao dịch trong kỳ</div>
            <section class="card">
                <div class="rpt-overflow-x">
                <table class="rpt">
                    <thead>
                        <tr>
                            <th class="col-stt">#</th>
                            <th class="col-time">Thời gian</th>
                            <th class="col-type">Loại</th>
                            <th class="col-qty">SL</th>
                            <th class="col-after">Tồn sau</th>
                            <th class="col-wh">Kho</th>
                            <th class="col-model">Mẫu máy</th>
                            <th class="col-ref">Mã phiếu</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty rows}">
                                <tr><td colspan="9" class="empty-cell">Không có giao dịch thẻ kho trong khoảng thời gian này.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${rows}" varStatus="vs">
                                    <tr>
                                        <td class="col-stt">${vs.count + (currentPage - 1) * pageSize}</td>
                                        <td class="col-time">${empty r.createdAtStr ? '—' : r.createdAtStr}</td>
                                        <td class="col-type">
                                            <c:choose>
                                                <c:when test="${r.transactionType == 'IMPORT'}"><span class="type-pill import">Nhập</span></c:when>
                                                <c:when test="${r.transactionType == 'EXPORT'}"><span class="type-pill export">Xuất</span></c:when>
                                                <c:otherwise>${r.transactionType}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="col-qty">${r.quantityChange}</td>
                                        <td class="col-after">${r.quantityAfter}</td>
                                        <td class="col-wh">${empty r.warehouseName ? '—' : r.warehouseName}</td>
                                        <td class="col-model">${empty r.generatorModel ? '—' : r.generatorModel}</td>
                                        <td class="col-ref">${empty r.receiptCode ? '—' : r.receiptCode}</td>
                                        <td class="rpt-text"><div>${empty r.referenceNote ? '—' : r.referenceNote}</div></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                    <c:if test="${not empty rows}">
                        <tfoot>
                            <tr>
                                <td class="col-stt"></td>
                                <td colspan="3">Tổng (${fn:length(rows)} giao dịch)</td>
                                <td></td>
                                <td colspan="4"></td>
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
                    <c:if test="${not empty selectedGeneratorId}">
                        <c:set var="filterParams" value="${filterParams}&generatorId=${selectedGeneratorId}"/>
                    </c:if>
                    <c:if test="${not empty selectedType}">
                        <c:set var="filterParams" value="${filterParams}&type=${selectedType}"/>
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
