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
<title>Bảng Điều Khiển — CEO & Điều Hành</title>
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
      <h1>Bảng Điều Khiển CEO</h1>
      <span class="crumb">/ Tổng quan điều hành hệ thống</span>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <jsp:include page="../common/admin/bell.jsp"/>
        <a href="${pageContext.request.contextPath}/reports?type=inventory" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:var(--radius);background:var(--fg);color:#fff;text-decoration:none;font-weight:600;font-size:12.5px">
          <svg viewBox="0 0 24 24" style="width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:2.2"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          Xem báo cáo
        </a>
      </div>
    </header>

    <main class="dashboard-container">

      <%-- Hero Header Banner --%>
      <jsp:include page="dashboard-header.jsp" />

      <%-- Section 1: 4 Template KPI Cards --%>
      <section>
        <div class="kpis">
          <div class="kpi">
            <div class="label">Tổng Model Máy Hệ Thống <span class="dot"></span></div>
            <div class="value mono"><fmt:formatNumber value="${not empty totalGenerators ? totalGenerators : 0}" pattern="#,##0"/></div>
            <div class="delta">
              Danh mục máy khả dụng
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Tồn Kho Máy Phát Điện</div>
            <div class="value mono"><fmt:formatNumber value="${not empty totalInStock ? totalInStock : 0}" pattern="#,##0"/> <span class="unit">chiếc</span></div>
            <div class="delta">
              <span class="change flat">${not empty activeWarehouses ? activeWarehouses : 0} kho</span>
              đang vận hành
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Giá Trị Tài Sản Tồn Kho</div>
            <div class="value mono"><c:out value="${not empty totalStockValue ? totalStockValue : '0 ₫'}"/></div>
            <div class="delta">
              <span class="change up">Định giá</span>
              máy phát điện thực tế
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Hồ Sơ Cần Phê Duyệt</div>
            <div class="value mono" style="color: var(--danger)"><fmt:formatNumber value="${not empty pendingApprovalsCount ? pendingApprovalsCount : 0}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change down">Cần xử lý</span>
              chuyển kho / thanh lý / PO
            </div>
            
          </div>
        </div>
      </section>

      <%-- Quick Hub: Phím Tắt Thao Tác CEO Nhanh --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          Phím Tắt Điều Hành & Phê Duyệt CEO
        </h3>
      </div>

      <div class="dash-quick-grid">
        <a href="${pageContext.request.contextPath}/liquidations" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
          </div>
          Phê Duyệt Thanh Lý (${not empty pendingLiquidations ? pendingLiquidations : 0})
        </a>

        <a href="${pageContext.request.contextPath}/transfers" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M17 1l4 4-4 4"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><path d="M7 23l-4-4 4-4"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
          </div>
          Duyệt Luân Chuyển Kho (${not empty pendingTransfers ? pendingTransfers : 0})
        </a>

        <a href="${pageContext.request.contextPath}/order" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
          </div>
          Duyệt Đơn Bán Hàng (${not empty pendingOrders ? pendingOrders : 0})
        </a>

        <a href="${pageContext.request.contextPath}/reports?type=inventory" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          </div>
          Báo Cáo Xuất Nhập Tồn
        </a>
      </div>

      <%-- Section 2: Activity Grid (Smooth Executive SVG Area Line Chart) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          Phân Tích Hoạt Động & Xu Hướng Vận Hành
        </h3>
      </div>

      <section class="dash-grid-3-1">
        <%-- Executive Line Chart Card With SVG Gradient Areas --%>
        <div class="card">
          <div class="card-head">
            <div>
              <h3>Xu Hướng Nhập / Xuất Kho</h3>
              <div class="sub" style="margin-top:2px">Biểu đồ máy phát điện luân chuyển qua các mốc thời gian</div>
            </div>
            <div class="tabs">
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='ceo'/><c:param name='range' value='7'/></c:url>" class="tab ${chartRange == '7' ? 'active' : ''}">7N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='ceo'/><c:param name='range' value='14'/></c:url>" class="tab ${chartRange == '14' ? 'active' : ''}">14N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='ceo'/><c:param name='range' value='30'/></c:url>" class="tab ${chartRange == '30' ? 'active' : ''}">30N</a>
              <a href="<c:url value='/admin/dashboard'><c:param name='viewRole' value='ceo'/><c:param name='range' value='365'/></c:url>" class="tab ${chartRange == '365' ? 'active' : ''}">12T</a>
            </div>
          </div>
          <div class="card-body">
            <svg class="chart" viewBox="0 0 720 240" preserveAspectRatio="xMidYMid meet">
              <defs>
                <linearGradient id="ceoImportGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="0%" stop-color="var(--accent)" stop-opacity="0.35"/>
                  <stop offset="100%" stop-color="var(--accent)" stop-opacity="0.0"/>
                </linearGradient>
                <linearGradient id="ceoExportGrad" x1="0" y1="0" x2="0" y2="1">
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
              <polygon points="60,220 ${lineImportPoints} ${lineLastImportX},220" fill="url(#ceoImportGrad)"/>
              <polyline points="${lineImportPoints}" fill="none" stroke="var(--accent)" stroke-width="2.5"/>
              </c:if>
              <c:if test="${not empty lineExportPoints}">
              <polygon points="60,220 ${lineExportPoints} ${lineLastExportX},220" fill="url(#ceoExportGrad)"/>
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
              <span class="legend-item"><span class="legend-swatch" style="background:var(--accent)"></span>Nhập kho</span>
              <span class="legend-item"><span class="legend-swatch" style="background:var(--info); height:2px; border-top: 1px dashed var(--info)"></span>Xuất kho</span>
              <span class="legend-item" style="margin-inline-start:auto"><span class="mono" style="color:var(--accent);font-weight:600">+<fmt:formatNumber value="${not empty totalInStock ? totalInStock : 0}" pattern="#,##0"/></span> máy khả dụng</span>
            </div>
          </div>
        </div>

        <%-- CEO Pending Approvals Bar Chart --%>
        <div class="card">
          <div class="card-head">
            <h3>Hồ Sơ Chờ CEO Phê Duyệt</h3>
          </div>
          <div class="card-body" style="padding:12px 0">
            <c:set var="maxApproval" value="1"/>
            <c:if test="${pendingLiquidations > maxApproval}"><c:set var="maxApproval" value="${pendingLiquidations}"/></c:if>
            <c:if test="${pendingTransfers > maxApproval}"><c:set var="maxApproval" value="${pendingTransfers}"/></c:if>
            <c:if test="${pendingPOs > maxApproval}"><c:set var="maxApproval" value="${pendingPOs}"/></c:if>

            <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px">
              <div style="width:120px;font-size:13px;color:var(--fg);text-align:right;flex-shrink:0">Thanh lý</div>
              <div style="flex:1;height:28px;background:var(--surface-2);border-radius:6px;overflow:hidden">
                <div style="width:${pendingLiquidations * 100 / maxApproval}%;height:100%;background:var(--danger);border-radius:6px;display:flex;align-items:center;padding-left:10px">
                  <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:600">${not empty pendingLiquidations ? pendingLiquidations : 0}</span>
                </div>
              </div>
            </div>
            <div style="display:flex;align-items:center;gap:12px;margin-bottom:14px">
              <div style="width:120px;font-size:13px;color:var(--fg);text-align:right;flex-shrink:0">Luân chuyển</div>
              <div style="flex:1;height:28px;background:var(--surface-2);border-radius:6px;overflow:hidden">
                <div style="width:${pendingTransfers * 100 / maxApproval}%;height:100%;background:var(--warn);border-radius:6px;display:flex;align-items:center;padding-left:10px">
                  <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:600">${not empty pendingTransfers ? pendingTransfers : 0}</span>
                </div>
              </div>
            </div>
            <div style="display:flex;align-items:center;gap:12px">
              <div style="width:120px;font-size:13px;color:var(--fg);text-align:right;flex-shrink:0">Phiếu mua PO</div>
              <div style="flex:1;height:28px;background:var(--surface-2);border-radius:6px;overflow:hidden">
                <div style="width:${pendingPOs * 100 / maxApproval}%;height:100%;background:var(--info);border-radius:6px;display:flex;align-items:center;padding-left:10px">
                  <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:600">${not empty pendingPOs ? pendingPOs : 0}</span>
                </div>
              </div>
            </div>
            <c:set var="totalPending" value="${(not empty pendingLiquidations ? pendingLiquidations : 0) + (not empty pendingTransfers ? pendingTransfers : 0) + (not empty pendingPOs ? pendingPOs : 0)}"/>
            <div style="text-align:center;margin-top:14px;font-size:12px;color:var(--muted)">
              Tổng: <span style="font-family:var(--font-mono);font-weight:600;color:var(--fg)">${totalPending}</span> hồ sơ cần xử lý
            </div>
          </div>
        </div>
      </section>

      <%-- Section 3: Model Inventory Table (Chỉ hiển thị Model Sắp hết & Hết hàng cần chú ý) --%>
      <c:set var="attentionCount" value="${lowStockModelsCount + outOfStockModelsCount}"/>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          Danh Sách Model Máy Phát Điện Cần Chú Ý
        </h3>
        <span class="sub">Tập trung theo dõi ${attentionCount} Model sắp hết & hết hàng</span>
      </div>

      <section class="card" style="padding:0;overflow:hidden">
        <div class="card-head" style="padding:14px 16px;margin-bottom:0;border-bottom:1px solid var(--border)">
          <div style="display:flex;gap:8px;align-items:center">
            <button class="btn inv-filter-btn active" onclick="filterInvTable('low', this)" style="padding:4px 10px;font-size:12px;border-radius:var(--radius-sm);border:1px solid var(--border);background:var(--surface);cursor:pointer">Sắp hết · ${lowStockModelsCount}</button>
            <button class="btn inv-filter-btn" onclick="filterInvTable('out', this)" style="padding:4px 10px;font-size:12px;border-radius:var(--radius-sm);border:1px solid var(--border);background:var(--surface);cursor:pointer;color:var(--muted)">Hết hàng · ${outOfStockModelsCount}</button>
          </div>
        </div>

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
            <c:set var="renderedCount" value="0"/>
            <c:forEach var="m" items="${modelSummaries}">
              <c:if test="${m.totalSerials <= 5}">
                <c:set var="statusClass" value="${m.totalSerials > 0 ? 'low' : 'out'}"/>
                <c:if test="${statusClass == 'low'}">
                  <c:set var="renderedCount" value="${renderedCount + 1}"/>
                </c:if>
                <tr data-status="${statusClass}" style="${statusClass == 'out' ? 'display:none' : ''}">
                  <td class="sku">GEN-${m.id}</td>
                  <td>
                    <div class="product"><c:out value="${m.model}"/></div>
                    <div class="product-sub">Máy phát điện chính hãng</div>
                  </td>
                  <td><c:out value="${not empty m.brand ? m.brand : 'Chưa phân loại'}"/></td>
                  <td class="num"><fmt:formatNumber value="${not empty m.totalSerials ? m.totalSerials : 0}" pattern="#,##0"/></td>
                  <td>
                    <c:choose>
                      <c:when test="${m.totalSerials > 0}">
                        <span class="pill low"><span class="pdot"></span>Sắp hết</span>
                      </c:when>
                      <c:otherwise>
                        <span class="pill out"><span class="pdot"></span>Hết hàng</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:if>
            </c:forEach>

            <%-- Dynamic Empty Filter Message Row --%>
            <tr id="emptyFilterRow" style="${renderedCount == 0 ? '' : 'display:none'}">
              <td colspan="5" style="text-align:center;padding:32px 16px;color:var(--muted)">
                <svg viewBox="0 0 24 24" style="width:24px;height:24px;stroke:currentColor;fill:none;stroke-width:1.6;margin-bottom:6px;display:block;margin-inline:auto"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                Không có model máy phát điện nào ở trạng thái này.
              </td>
            </tr>
          </tbody>
        </table>
      </section>

      <%-- Section 4: 3 Template Alert Cards (.alerts) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg>
          Hồ Sơ & Chứng Từ CEO Cần Phê Duyệt
        </h3>
      </div>

      <section class="alerts">
        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Luân chuyển kho <span class="count">${not empty pendingTransfers ? pendingTransfers : 0} Lệnh</span></div>
            <div class="alert-desc">Các yêu cầu điều chuyển máy phát điện giữa các kho chờ CEO duyệt.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/transfers">Phê duyệt luân chuyển →</a>
          </div>
        </div>

        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Thanh lý máy cũ <span class="count">${not empty pendingLiquidations ? pendingLiquidations : 0} Phiếu</span></div>
            <div class="alert-desc">Các đề xuất thanh lý máy hỏng, hỏng nặng tốn chi phí bảo trì.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/liquidations">Phê duyệt thanh lý →</a>
          </div>
        </div>

        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Phiếu mua máy PO <span class="count">${not empty pendingPOs ? pendingPOs : 0} Phiếu</span></div>
            <div class="alert-desc">Các phiếu mua máy mới bổ sung kho chờ duyệt cấp kinh phí.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/purchase-order">Xem phiếu mua PO →</a>
          </div>
        </div>
      </section>

      <%-- Section 5: System Footer --%>
      <div class="foot">
        <span>Đồng bộ cuối · ${not empty todayFormattedDate ? todayFormattedDate : 'Hôm nay'} · Ban Giám Đốc Điều Hành</span>
        <span>v2.4.1 · 6 người dùng đang online</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
function filterInvTable(type, btn) {
  document.querySelectorAll('.inv-filter-btn').forEach(function(b) { b.classList.remove('active'); });
  btn.classList.add('active');
  var rows = document.querySelectorAll('#invTable tbody tr:not(#emptyFilterRow)');
  var visibleCount = 0;
  rows.forEach(function(row) {
    var status = row.getAttribute('data-status');
    if (type === 'attention' || type === 'all') {
      if (status === 'low' || status === 'out') {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    } else if (status === type) {
      row.style.display = '';
      visibleCount++;
    } else {
      row.style.display = 'none';
    }
  });

  var emptyRow = document.getElementById('emptyFilterRow');
  if (emptyRow) {
    if (visibleCount === 0) {
      emptyRow.style.display = '';
    } else {
      emptyRow.style.display = 'none';
    }
  }
}

function exportTableToCSV(filename) {
  var csv = [];
  var rows = document.querySelectorAll('#invTable tr:not(#emptyFilterRow)');
  for (var i = 0; i < rows.length; i++) {
    var row = [], cols = rows[i].querySelectorAll('td, th');
    for (var j = 0; j < cols.length; j++) {
      row.push('"' + cols[j].innerText.replace(/"/g, '""').trim() + '"');
    }
    csv.push(row.join(','));
  }
  var csvFile = new Blob(['\uFEFF' + csv.join('\n')], {type: 'text/csv;charset=utf-8;'});
  var downloadLink = document.createElement('a');
  downloadLink.download = filename;
  downloadLink.href = window.URL.createObjectURL(csvFile);
  downloadLink.style.display = 'none';
  document.body.appendChild(downloadLink);
  downloadLink.click();
}
</script>
</body>
</html>
