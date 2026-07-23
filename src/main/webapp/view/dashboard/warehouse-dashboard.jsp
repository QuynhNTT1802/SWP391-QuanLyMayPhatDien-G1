<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Bảng Điều Khiển — Vận Hành Kho</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
</head>
<body>
<div class="app">
  <c:set var="perms" value="${sessionScope.userPermissions}"/>
  <jsp:include page="../common/admin/aside.jsp" />

  <div>
    <header class="topbar">
      <h1><c:out value="${isWarehouseManager ? 'Bảng Điều Khiển Quản Lý Kho' : 'Bảng Điều Khiển Nhân Viên Kho'}"/></h1>
      <span class="crumb">/ <c:out value="${isWarehouseManager ? 'Giám sát tổng kho & điều chuyển hàng' : 'Vận hành nhập/xuất kho thực tế'}"/></span>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <jsp:include page="../common/admin/bell.jsp"/>
        <c:choose>
          <c:when test="${isWarehouseManager}">
            <a href="${pageContext.request.contextPath}/proposal" style="display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:var(--radius);background:var(--fg);color:#fff;text-decoration:none;font-weight:600;font-size:12.5px">Duyệt đề xuất</a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/import-receipt?action=create" style="display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:var(--radius);background:var(--fg);color:#fff;text-decoration:none;font-weight:600;font-size:12.5px">Tạo phiếu nhập</a>
          </c:otherwise>
        </c:choose>
      </div>
    </header>

    <main class="dashboard-container">

      <%-- Hero Header Banner --%>
      <jsp:include page="dashboard-header.jsp" />

      <%-- Section 1: 4 Template KPI Cards --%>
      <section>
        <div class="kpis">
          <c:choose>
          <c:when test="${isWarehouseManager}">
          <div class="kpi">
            <div class="label">Tổng Model Máy Phát Điện <span class="dot"></span></div>
            <div class="value mono"><fmt:formatNumber value="${not empty totalGenerators ? totalGenerators : 0}" pattern="#,##0"/></div>
            <div class="delta"><span class="change up">Đang vận hành</span>danh mục máy quản lý</div>
          </div>
          <div class="kpi">
            <div class="label">Tổng Tồn Kho (Thực Tế)</div>
            <div class="value mono"><fmt:formatNumber value="${not empty totalInStock ? totalInStock : 0}" pattern="#,##0"/> <span class="unit">chiếc</span></div>
            <div class="delta"><span class="change flat">Ổn định</span>máy có sẵn trong kho</div>
          </div>
          <div class="kpi">
            <div class="label">Giá Trị Tồn Kho Ước Tính</div>
            <div class="value mono"><c:out value="${not empty totalStockValue ? totalStockValue : '0 ₫'}"/></div>
            <div class="delta"><span class="change up">Trong kho</span>tài sản máy phát điện</div>
          </div>
          <div class="kpi">
            <div class="label">Model Sắp Hết Hàng</div>
            <div class="value mono" style="color: var(--danger)"><fmt:formatNumber value="${not empty lowStockModelsCount ? lowStockModelsCount : 0}" pattern="#,##0"/></div>
            <div class="delta"><span class="change down">Cần đặt thêm</span>tồn kho ≤ 5 máy</div>
          </div>
          </c:when>
          <c:otherwise>
          <div class="kpi">
            <div class="label">Tồn Tại Kho Của Tôi <span class="dot"></span></div>
            <div class="value mono"><fmt:formatNumber value="${not empty stockInMyWarehouse ? stockInMyWarehouse : 0}" pattern="#,##0"/></div>
            <div class="delta"><span class="change up">Serial</span>máy trong kho</div>
          </div>
          <div class="kpi">
            <div class="label">Model Tại Kho Của Tôi</div>
            <div class="value mono"><fmt:formatNumber value="${not empty modelsInMyWarehouse ? modelsInMyWarehouse : 0}" pattern="#,##0"/></div>
            <div class="delta"><span class="change flat">Model</span>máy phát điện</div>
          </div>
          <div class="kpi">
            <div class="label">Transfer Chờ Xuất</div>
            <div class="value mono" style="color: var(--warn)">${not empty readyExportCount ? readyExportCount : 0}</div>
            <div class="delta"><span class="change down">Cần xuất</span>từ kho của tôi</div>
          </div>
          <div class="kpi">
            <div class="label">Transfer Chờ Nhận</div>
            <div class="value mono" style="color: var(--info)">${not empty readyImportCount ? readyImportCount : 0}</div>
            <div class="delta"><span class="change up">Cần nhận</span>vào kho của tôi</div>
          </div>
          </c:otherwise>
          </c:choose>
        </div>
      </section>

      <%-- Quick Hub: Phím Tắt Thao Tác Kho Nhanh --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          Phím Tắt Thao Tác Vận Hành Kho
        </h3>
      </div>

      <div class="dash-quick-grid">
        <a href="${pageContext.request.contextPath}/import-receipt?action=create" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
          </div>
          Tạo Phiếu Nhập Kho
        </a>

        <a href="${pageContext.request.contextPath}/transfers" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M17 1l4 4-4 4"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><path d="M7 23l-4-4 4-4"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
          </div>
          Luân Chuyển Kho
        </a>

        <c:if test="${isWarehouseManager}">
        <a href="${pageContext.request.contextPath}/liquidations?action=create" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
          </div>
          Yêu Cầu Thanh Lý
        </a>

        <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20v%e1%ba%adt%20t%c6%b0" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          </div>
          Danh Mục Máy Phát Điện
        </a>
        </c:if>
      </div>

      <%-- Section 2: Activity Grid (14-Day Import/Export Trend Chart & Recent Transactions) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          Hoạt Động Kho — Biến Động Nhập / Xuất
        </h3>
        <span class="sub">Thống kê luân chuyển máy phát điện</span>
      </div>

      <section class="dash-grid-3-1">
        <%-- Chart Card --%>
        <div class="card">
          <div class="card-head">
            <div>
              <h3>Nhập / Xuất kho</h3>
              <div class="sub" style="margin-top:2px">Đơn vị: chiếc máy phát điện</div>
            </div>
            <div class="tabs">
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='warehouse'/><c:param name='range' value='7'/></c:url>" class="tab ${chartRange == '7' ? 'active' : ''}">7N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='warehouse'/><c:param name='range' value='14'/></c:url>" class="tab ${chartRange == '14' ? 'active' : ''}">14N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='warehouse'/><c:param name='range' value='30'/></c:url>" class="tab ${chartRange == '30' ? 'active' : ''}">30N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='warehouse'/><c:param name='range' value='365'/></c:url>" class="tab ${chartRange == '365' ? 'active' : ''}">12T</a>
            </div>
          </div>
          <div class="card-body">
            <svg class="chart" viewBox="0 0 720 240" preserveAspectRatio="xMidYMid meet">
              <defs>
                <linearGradient id="whImportGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stop-color="var(--accent)" stop-opacity="0.35"/>
                  <stop offset="100%" stop-color="var(--accent)" stop-opacity="0.0"/>
                </linearGradient>
                <linearGradient id="whExportGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stop-color="var(--info)" stop-opacity="0.25"/>
                  <stop offset="100%" stop-color="var(--info)" stop-opacity="0.0"/>
                </linearGradient>
              </defs>
              <g stroke="var(--border)" stroke-width="1">
                <line x1="40" y1="20" x2="710" y2="20"/>
                <line x1="40" y1="70" x2="710" y2="70" stroke-dasharray="2,3"/>
                <line x1="40" y1="120" x2="710" y2="120" stroke-dasharray="2,3"/>
                <line x1="40" y1="170" x2="710" y2="170" stroke-dasharray="2,3"/>
                <line x1="40" y1="220" x2="710" y2="220"/>
              </g>
              <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="end">
                <text x="34" y="24"><fmt:formatNumber value="${lineAxisVals[0]}" pattern="#,##0"/></text>
                <text x="34" y="74"><fmt:formatNumber value="${lineAxisVals[1]}" pattern="#,##0"/></text>
                <text x="34" y="124"><fmt:formatNumber value="${lineAxisVals[2]}" pattern="#,##0"/></text>
                <text x="34" y="174"><fmt:formatNumber value="${lineAxisVals[3]}" pattern="#,##0"/></text>
                <text x="34" y="224">0</text>
              </g>
              <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="middle">
                <c:forEach var="item" items="${monthlyImportTrend}" varStatus="st">
                  <text x="${60 + st.index * 95}" y="236">${fn:substring(item.month, 5, 7)}</text>
                </c:forEach>
              </g>
              <c:if test="${not empty lineImportPoints}">
              <polygon points="60,220 ${lineImportPoints} ${lineLastImportX},220" fill="url(#whImportGrad)"/>
              <polyline points="${lineImportPoints}" fill="none" stroke="var(--accent)" stroke-width="2.5"/>
              </c:if>
              <c:if test="${not empty lineExportPoints}">
              <polygon points="60,220 ${lineExportPoints} ${lineLastExportX},220" fill="url(#whExportGrad)"/>
              <polyline points="${lineExportPoints}" fill="none" stroke="var(--info)" stroke-width="2.2" stroke-dasharray="4,4"/>
              </c:if>
              <c:if test="${not empty lineLastImportVal}">
              <g fill="var(--accent)">
                <circle cx="${lineLastImportX}" cy="${lineLastImportY}" r="4"/>
                <circle cx="${lineLastImportX}" cy="${lineLastImportY}" r="7" fill="var(--accent)" opacity="0.25"/>
              </g>
              <g transform="translate(${lineLastImportX - 42}, ${lineLastImportY > 160 ? lineLastImportY - 30 : lineLastImportY + 8})">
                <rect x="0" y="0" width="82" height="22" rx="4" fill="var(--surface-2)" stroke="var(--border)"/>
                <text x="6" y="15" font-family="var(--font-mono)" font-size="11" fill="var(--fg)"><fmt:formatNumber value="${lineLastImportVal}" pattern="#,##0"/> máy</text>
              </g>
              </c:if>
              <c:if test="${not empty lineLastExportVal}">
              <g fill="var(--info)">
                <circle cx="${lineLastExportX}" cy="${lineLastExportY}" r="3.5"/>
                <circle cx="${lineLastExportX}" cy="${lineLastExportY}" r="6" fill="var(--info)" opacity="0.22"/>
              </g>
              <g transform="translate(${lineLastExportX - 42}, ${lineLastExportY > 160 ? lineLastExportY - 30 : lineLastExportY + 8})">
                <rect x="0" y="0" width="82" height="22" rx="4" fill="var(--surface-2)" stroke="var(--border)"/>
                <text x="6" y="15" font-family="var(--font-mono)" font-size="11" fill="var(--fg)"><fmt:formatNumber value="${lineLastExportVal}" pattern="#,##0"/> máy</text>
              </g>
              </c:if>
            </svg>
            <div class="chart-legend">
              <span class="legend-item"><span class="legend-swatch" style="background:var(--accent)"></span>Nhập kho · <fmt:formatNumber value="${not empty importCount ? importCount : 0}" pattern="#,##0"/> chiếc</span>
              <span class="legend-item"><span class="legend-swatch" style="background:var(--info); height:2px; border-top: 1px dashed var(--info)"></span>Xuất kho · <fmt:formatNumber value="${not empty exportCount ? exportCount : 0}" pattern="#,##0"/> chiếc</span>
              <span class="legend-item" style="margin-inline-start:auto"><span class="mono" style="color:var(--accent);font-weight:600">+<fmt:formatNumber value="${not empty totalInStock ? totalInStock : 0}" pattern="#,##0"/></span> máy khả dụng</span>
            </div>
          </div>
        </div>

        <%-- Recent Transactions Card --%>
        <div class="card">
          <div class="card-head">
            <h3>Giao Dịch Gần Đây</h3>
            <a href="${pageContext.request.contextPath}/import-receipt" style="font-size:12px;color:var(--muted);text-decoration:none">Xem tất cả →</a>
          </div>
          <div class="card-body">
            <div class="tx-list">
              <c:forEach var="tx" items="${recentReceipts}">
                <c:set var="isImport" value="${fn:startsWith(tx.receiptCode, 'RX-IM')}"/>
                <div class="tx">
                  <div class="tx-icon ${isImport ? 'in' : 'out'}">
                    <svg viewBox="0 0 24 24"><path d="${isImport ? 'M12 5v14M5 12l7 7 7-7' : 'M12 19V5M19 12l-7-7-7 7'}"/></svg>
                  </div>
                  <div class="tx-body">
                    <div class="tx-title">${isImport ? 'Nhập kho' : 'Xuất kho'} — <c:out value="${tx.receiptCode}"/></div>
                    <div class="tx-sub"><c:out value="${tx.warehouseName}"/> · ${tx.machineCount} máy</div>
                  </div>
                  <div class="tx-amount" style="color:${isImport ? 'var(--accent)' : 'var(--info)'}">
                    ${isImport ? '+' : '−'}${tx.machineCount}
                    <span class="when"><c:out value="${tx.createdAtStr}"/></span>
                  </div>
                </div>
              </c:forEach>
              <c:if test="${empty recentReceipts}">
                <div style="padding:20px;text-align:center;color:var(--muted);font-size:12px">Chưa có giao dịch kho mới</div>
              </c:if>
            </div>
          </div>
        </div>
      </section>

      <%-- Section 3: Detailed Model Inventory Table with Filter Tabs & Export CSV --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          Tồn Kho Chi Tiết Theo Model Máy
        </h3>
        <span class="sub">Hiển thị ${fn:length(modelSummaries)} / <fmt:formatNumber value="${not empty totalGenerators ? totalGenerators : 0}" pattern="#,##0"/> Model</span>
      </div>

      <section class="card" style="padding:0;overflow:hidden">

        <table class="inv" id="invTable">
          <thead>
            <tr>
              <th style="width:120px">MÃ MODEL</th>
              <th>MODEL MÁY PHÁT ĐIỆN</th>
              <th>HÃNG SẢN XUẤT</th>
              <th class="num">TỒN THỰC TẾ</th>
              <th>TRẠNG THÁI</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="m" items="${modelSummaries}">
              <c:set var="statusClass" value="${m.totalSerials > 5 ? 'ok' : (m.totalSerials > 0 ? 'low' : 'out')}"/>
              <tr data-status="${statusClass}">
                <td class="sku">GEN-${m.id}</td>
                <td>
                  <div class="product"><c:out value="${m.model}"/></div>
                  <div class="product-sub">Máy phát điện chính hãng</div>
                </td>
                <td><c:out value="${not empty m.brand ? m.brand : 'Chưa phân loại'}"/></td>
                <td class="num"><fmt:formatNumber value="${not empty m.totalSerials ? m.totalSerials : 0}" pattern="#,##0"/></td>
                <td>
                  <c:choose>
                    <c:when test="${m.totalSerials > 5}">
                      <span class="pill ok"><span class="pdot"></span>Đủ hàng</span>
                    </c:when>
                    <c:when test="${m.totalSerials > 0}">
                      <span class="pill low"><span class="pdot"></span>Sắp hết</span>
                    </c:when>
                    <c:otherwise>
                      <span class="pill out"><span class="pdot"></span>Hết hàng</span>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>

            <%-- Dynamic Empty Filter Message Row --%>
            <tr id="emptyFilterRow" style="display:none">
              <td colspan="5" style="text-align:center;padding:32px 16px;color:var(--muted)">
                <svg viewBox="0 0 24 24" style="width:24px;height:24px;stroke:currentColor;fill:none;stroke-width:1.6;margin-bottom:6px;display:block;margin-inline:auto"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                Không có model máy phát điện nào ở trạng thái này.
              </td>
            </tr>

            <c:if test="${empty modelSummaries}">
              <tr>
                <td colspan="5" style="text-align:center;padding:24px;color:var(--muted)">Chưa có thông tin máy phát điện trong kho</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </section>

      <%-- Section 4: 3 Template Alert Cards (.alerts) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg>
          Cảnh Báo Cần Xử Lý
        </h3>
        <span class="meta" style="font-size:12px;color:var(--muted)">Hệ thống tự động theo dõi</span>
      </div>

      <section class="alerts">
        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Sắp hết hàng <span class="count">${not empty lowStockModelsCount ? lowStockModelsCount : 0} Model</span></div>
            <div class="alert-desc">Số lượng tồn khả dụng dưới ngưỡng an toàn (≤ 5 máy). Cần xem xét nhập bổ sung.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/admin/categories">Xem danh mục máy →</a>
          </div>
        </div>

        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Hết hàng <span class="count">${not empty outOfStockModelsCount ? outOfStockModelsCount : 0} Model</span></div>
            <div class="alert-desc">Máy phát điện đã hết sạch serial khả dụng trong kho. Cần tạo phiếu nhập gấp.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/import-receipt?action=create">Tạo phiếu nhập gấp →</a>
          </div>
        </div>

        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Hồ sơ chờ duyệt <span class="count">${not empty pendingApprovalsCount ? pendingApprovalsCount : 0} Hồ sơ</span></div>
            <div class="alert-desc">Có các yêu cầu chuyển kho, phiếu mua sắm PO hoặc thanh lý đang chờ phê duyệt.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/transfers">Phê duyệt ngay →</a>
          </div>
        </div>
      </section>

      <%-- Section 5: System Footer --%>
      <div class="foot">
        <span>Đồng bộ cuối · ${not empty todayFormattedDate ? todayFormattedDate : 'Hôm nay'} · Hệ Thống Quản Lý Máy Phát Điện</span>
        <span>v2.4.1 · 6 người dùng đang online</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>

</body>
</html>
