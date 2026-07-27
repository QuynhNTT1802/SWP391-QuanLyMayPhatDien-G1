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
<title>Bảng Điều Khiển</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<style>
  .kpis { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
  .kpi { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px 16px; }
  .kpi .label { display: flex; align-items: center; justify-content: space-between; font-size: 11.5px; color: var(--muted); font-weight: 500; letter-spacing: 0.01em; margin-bottom: 10px; }
  .kpi .label .dot { width: 6px; height: 6px; border-radius: 50%; }
  .kpi .value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; color: var(--fg); }
  .kpi .delta { margin-top: 8px; display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); }
  .kpi .dot { background: var(--muted); }

  .charts { display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .chart-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 20px; }
  .chart-card h3 { font-size: 14px; font-weight: 600; margin-bottom: 16px; }

  .grid-2 { display: grid; grid-template-columns: minmax(0, 2fr) minmax(0, 1fr); gap: 12px; }

  .tx-list { display: flex; flex-direction: column; }
  .tx { display: grid; grid-template-columns: 28px 1fr auto; gap: 12px; align-items: center; padding: 10px 0; border-bottom: 1px dashed var(--border); }
  .tx:last-child { border-bottom: 0; }
  .tx-icon { width: 28px; height: 28px; border-radius: 6px; display: grid; place-items: center; background: var(--surface-2); border: 1px solid var(--border); }
  .tx-icon svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .tx-icon.in, .tx-icon.out { color: var(--muted-2); background: var(--surface-2); border-color: var(--border); }
  .tx-body { line-height: 1.3; min-width: 0; }
  .tx-title { font-size: 13px; font-weight: 500; }
  .tx-sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); }
  .tx-amount { text-align: end; font-family: var(--font-mono); font-size: 13px; font-weight: 500; }
  .tx-amount .when { display: block; font-size: 10.5px; color: var(--muted-2); font-weight: 400; }

  .report-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
  .rpt-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; display: flex; gap: 14px; align-items: flex-start; transition: box-shadow 0.15s, border-color 0.15s; }
  .rpt-card:hover { border-color: var(--accent); box-shadow: 0 1px 6px rgba(0,0,0,0.06); }
  .rpt-card a { text-decoration: none; color: inherit; display: flex; gap: 14px; align-items: flex-start; width: 100%; }
  .rpt-icon { width: 36px; height: 36px; border-radius: 8px; display: grid; place-items: center; flex-shrink: 0; }
  .rpt-icon svg { width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .rpt-icon { background: var(--surface-2); color: var(--muted); }
  .rpt-body { flex: 1; min-width: 0; }
  .rpt-title { font-size: 13px; font-weight: 600; }
  .rpt-desc { font-size: 11.5px; color: var(--muted); margin-top: 3px; line-height: 1.4; }
  .rpt-link { font-size: 11.5px; color: var(--accent); font-weight: 500; margin-top: 6px; display: inline-flex; align-items: center; gap: 3px; }

  .alerts { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
  .alert { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px; display: flex; gap: 12px; align-items: flex-start; }
  .alert-icon { width: 30px; height: 30px; border-radius: 6px; display: grid; place-items: center; flex-shrink: 0; }
  .alert-icon svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .alert.warn .alert-icon, .alert.danger .alert-icon, .alert.info .alert-icon { background: var(--surface-2); color: var(--muted-2); }
  .alert-body { flex: 1; min-width: 0; }
  .alert-title { font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
  .alert-title .count { font-family: var(--font-mono); font-size: 11px; padding: 1px 6px; border-radius: 3px; background: var(--surface-2); color: var(--fg-soft); border: 1px solid var(--border); font-weight: 500; }
  .alert-desc { font-size: 12px; color: var(--muted); margin-top: 4px; line-height: 1.45; }
  .alert-cta { margin-top: 8px; font-size: 12px; color: var(--fg); font-weight: 500; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; border-bottom: 1px solid var(--border-strong); padding-bottom: 1px; }
  .alert-cta:hover { color: var(--accent); border-color: var(--accent); }

  .quick-links { display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px; }
  .ql { display: flex; align-items: center; gap: 8px; padding: 10px 12px; border: 1px solid var(--border); border-radius: 6px; text-decoration: none; color: var(--fg); font-size: 13px; font-weight: 500; transition: border-color 0.15s; }
  .ql:hover { border-color: var(--accent); }
  .ql svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 1.8; color: var(--muted); }

  .foot { margin-top: 28px; padding-top: 14px; border-top: 1px solid var(--border); color: var(--muted); font-size: 11.5px; font-family: var(--font-mono); display: flex; justify-content: space-between; }

  .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
  [data-theme="light"] .theme-toggle .icon-moon { display: block; }
  [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

  @media (max-width: 1280px) {
    .kpis { grid-template-columns: repeat(2, 1fr); }
    .charts { grid-template-columns: 1fr; }
    .report-cards { grid-template-columns: repeat(2, 1fr); }
    .alerts { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<div class="app">
  <c:set var="perms" value="${sessionScope.userPermissions}"/>
  <jsp:include page="../common/admin/aside.jsp" />

  <div>
    <header class="topbar" data-od-id="topbar">
      <h1>Bảng Điều Khiển</h1>
      <span class="crumb">/ Tổng quan</span>
      <div class="search">
        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
        <input placeholder="Tìm kiếm..." />
        <kbd>Ctrl K</kbd>
      </div>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <jsp:include page="../common/admin/bell.jsp"/>
      </div>
    </header>

    <main>

      <%-- ===== KPI Quản trị: Người dùng & hệ thống ===== --%>
      <c:if test="${not empty perms and perms.contains('users.view')}">
      <section data-od-id="admin-kpis">
        <div class="kpis">
          <div class="kpi accent">
            <div class="label">Người dùng hoạt động <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${activeUsers}" pattern="#,##0"/></div>
            <div class="delta">Người dùng đang hoạt động</div>
          </div>
          <div class="kpi danger">
            <div class="label">Người dùng bị khoá</div>
            <div class="value"><fmt:formatNumber value="${lockedUsers}" pattern="#,##0"/></div>
            <div class="delta">Tài khoản đã bị vô hiệu hoá</div>
          </div>
          <div class="kpi info">
            <div class="label">Vai trò</div>
            <div class="value">${totalRoles}</div>
            <div class="delta">Vai trò trong hệ thống</div>
          </div>
          <div class="kpi purple">
            <div class="label">Quyền hạn</div>
            <div class="value">${totalPermissions}</div>
            <div class="delta">Quyền đã khai báo</div>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== KPI Tổng quan hệ thống ===== --%>
      <c:if test="${not empty perms and perms.contains('warehouses.view')}">
      <section data-od-id="sys-kpis">
        <div class="kpis">
          <div class="kpi accent">
            <div class="label">Tổng máy tồn kho <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${totalInStock}" pattern="#,##0"/></div>
            <div class="delta"><fmt:formatNumber value="${activeWarehouses}" pattern="#,##0"/> kho đang hoạt động</div>
          </div>
          <div class="kpi info">
            <div class="label">Model đang quản lý</div>
            <div class="value"><fmt:formatNumber value="${totalGenerators}" pattern="#,##0"/></div>
            <div class="delta">Model máy phát điện</div>
          </div>
          <div class="kpi accent">
            <div class="label">Nhập kho tháng này</div>
            <div class="value"><fmt:formatNumber value="${importCount}" pattern="#,##0"/></div>
            <div class="delta">phiếu nhập từ đầu tháng</div>
          </div>
          <div class="kpi info">
            <div class="label">Xuất kho tháng này</div>
            <div class="value"><fmt:formatNumber value="${exportCount}" pattern="#,##0"/></div>
            <div class="delta">phiếu xuất từ đầu tháng</div>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== Nhân viên kho: Kho của tôi ===== --%>
      <c:if test="${not empty userRoleNames and userRoleNames.contains('warehouse_staff')}">
      <section data-od-id="wh-staff-kpis">
        <div class="kpis">
          <div class="kpi accent">
            <div class="label">Tồn tại kho của tôi <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${stockInMyWarehouse}" pattern="#,##0"/></div>
            <div class="delta">serial máy phát</div>
          </div>
          <div class="kpi info">
            <div class="label">Model tại kho của tôi</div>
            <div class="value"><fmt:formatNumber value="${modelsInMyWarehouse}" pattern="#,##0"/></div>
            <div class="delta">model khác nhau</div>
          </div>
          <div class="kpi warn">
            <div class="label">Luân chuyển chờ xuất</div>
            <div class="value">${readyExportCount}</div>
            <div class="delta">cần tạo phiếu xuất</div>
          </div>
          <div class="kpi info">
            <div class="label">Luân chuyển chờ nhận</div>
            <div class="value">${readyImportCount}</div>
            <div class="delta">cần tạo phiếu nhập</div>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== KPI Quản lý kho ===== --%>
      <c:if test="${not empty userRoleNames and userRoleNames.contains('warehouse_manager')}">
      <section data-od-id="wh-mgr-kpis">
        <div class="kpis">
          <div class="kpi warn">
            <div class="label">Đề xuất chờ duyệt <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${pendingProposals}" pattern="#,##0"/></div>
            <div class="delta">đề xuất nhập kho</div>
          </div>
          <div class="kpi info">
            <div class="label">Luân chuyển chờ duyệt</div>
            <div class="value">${transferPendingCount}</div>
            <div class="delta">chờ phê duyệt</div>
          </div>
          <c:if test="${not empty doingChecks}">
          <div class="kpi purple">
            <div class="label">Kiểm kê đang làm</div>
            <div class="value">${doingChecks}</div>
            <div class="delta">phiếu đang kiểm</div>
          </div>
          </c:if>
          <div class="kpi accent">
            <div class="label">Kho đang hoạt động</div>
            <div class="value">${activeWarehouses}</div>
            <div class="delta">kho trong hệ thống</div>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== KPI Kinh doanh ===== --%>
      <c:if test="${not empty perms and (perms.contains('orders.view') or perms.contains('orders.approve'))}">
      <section data-od-id="sales-kpis">
        <div class="kpis">
          <c:choose>
          <c:when test="${not empty userRoleNames and userRoleNames.contains('sales_staff')}">
          <div class="kpi accent">
            <div class="label">Đơn hôm nay (của tôi) <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${todayOrders}" pattern="#,##0"/></div>
            <div class="delta">đơn hàng hôm nay</div>
          </div>
          <div class="kpi warn">
            <div class="label">Đơn chờ duyệt (của tôi)</div>
            <div class="value"><fmt:formatNumber value="${myPendingOrders}" pattern="#,##0"/></div>
            <div class="delta">chờ duyệt</div>
          </div>
          <div class="kpi info">
            <div class="label">Đơn đã duyệt (của tôi)</div>
            <div class="value"><fmt:formatNumber value="${myApprovedOrders}" pattern="#,##0"/></div>
            <div class="delta">đã duyệt</div>
          </div>
          <div class="kpi accent">
            <div class="label">Đơn hoàn thành (của tôi)</div>
            <div class="value"><fmt:formatNumber value="${myCompletedOrders}" pattern="#,##0"/></div>
            <div class="delta">đã hoàn thành</div>
          </div>
          </c:when>
          <c:otherwise>
          <div class="kpi accent">
            <div class="label">Đơn hàng hôm nay <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${todayOrders}" pattern="#,##0"/></div>
            <div class="delta">đơn hàng mới</div>
          </div>
          <div class="kpi warn">
            <div class="label">Đơn chờ duyệt</div>
            <div class="value"><fmt:formatNumber value="${pendingOrders}" pattern="#,##0"/></div>
            <div class="delta">Chờ duyệt</div>
          </div>
          <div class="kpi info">
            <div class="label">Đơn đã duyệt</div>
            <div class="value"><fmt:formatNumber value="${approvedOrders}" pattern="#,##0"/></div>
            <div class="delta">Đã duyệt</div>
          </div>
          <div class="kpi accent">
            <div class="label">Đơn hoàn thành</div>
            <div class="value"><fmt:formatNumber value="${completedOrders}" pattern="#,##0"/></div>
            <div class="delta">Hoàn thành</div>
          </div>
          </c:otherwise>
          </c:choose>
        </div>
      </section>
      </c:if>

      <%-- ===== KPI Khách hàng / Nhà cung cấp ===== --%>
      <c:if test="${not empty perms and (perms.contains('customers.view') or perms.contains('suppliers.view'))}">
      <section data-od-id="cussup-kpis">
        <div class="kpis">
          <c:if test="${not empty perms and perms.contains('customers.view')}">
          <div class="kpi accent">
            <div class="label">Khách hàng hoạt động <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${activeCustomers}" pattern="#,##0"/></div>
            <div class="delta">khách hàng đang hoạt động</div>
          </div>
          </c:if>
          <c:if test="${not empty perms and perms.contains('suppliers.view')}">
          <div class="kpi info">
            <div class="label">Nhà cung cấp hoạt động</div>
            <div class="value"><fmt:formatNumber value="${activeSuppliers}" pattern="#,##0"/></div>
            <div class="delta">NCC đang hoạt động</div>
          </div>
          </c:if>
        </div>
      </section>
      </c:if>

      <%-- ===== KPI Giám đốc: Hàng chờ duyệt ===== --%>
      <c:if test="${not empty userRoleNames and userRoleNames.contains('ceo')}">
      <section data-od-id="ceo-kpis">
        <div class="kpis">
          <div class="kpi danger">
            <div class="label">Thanh lý chờ duyệt <span class="dot"></span></div>
            <div class="value">${pendingLiquidations}</div>
            <div class="delta">cần phê duyệt</div>
          </div>
          <div class="kpi warn">
            <div class="label">Transfer chờ duyệt</div>
            <div class="value">${pendingTransfers}</div>
            <div class="delta">luân chuyển kho</div>
          </div>
          <div class="kpi info">
            <div class="label">Phiếu mua chờ duyệt</div>
            <div class="value">${pendingPOs}</div>
            <div class="delta">phiếu mua hàng</div>
          </div>
          <div class="kpi accent">
            <div class="label">Tổng máy tồn kho</div>
            <div class="value"><fmt:formatNumber value="${totalInStock}" pattern="#,##0"/></div>
            <div class="delta">${activeWarehouses} kho đang hoạt động</div>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== Biểu đồ: Trạng thái đơn hàng ===== --%>
      <c:if test="${not empty perms and perms.contains('orders.approve') and not empty donutSegments}">
      <div class="section-head"><h2>Thống kê đơn hàng</h2></div>
      <section class="charts" data-od-id="order-charts">
        <div class="chart-card">
          <h3>Đơn hàng theo trạng thái</h3>
          <svg viewBox="0 0 200 200" style="width:200px;height:200px">
            <circle cx="100" cy="100" r="80" fill="none" stroke="var(--surface-2)" stroke-width="24"/>
            <c:forEach var="seg" items="${donutSegments}">
            <circle cx="100" cy="100" r="80" fill="none"
              stroke="var(--muted)" stroke-width="24"
              stroke-dasharray="${seg.dashLen} ${seg.gap}"
              stroke-dashoffset="${seg.dashOffset}"
              transform="rotate(-90 100 100)"/>
            </c:forEach>
            <text x="100" y="97" text-anchor="middle" font-family="var(--font-mono)" font-size="20" font-weight="600" fill="var(--fg)">${donutTotal}</text>
            <text x="100" y="115" text-anchor="middle" font-family="var(--font)" font-size="11" fill="var(--muted)">tổng đơn</text>
          </svg>
          <div style="display:flex;flex-wrap:wrap;gap:8px 16px;margin-top:12px;font-size:12px">
            <c:forEach var="seg" items="${donutSegments}">
            <span><span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:var(--muted);margin-right:4px"></span>${seg.status} ${seg.count}</span>
            </c:forEach>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== Biểu đồ: Xu hướng nhập xuất kho ===== --%>
      <c:if test="${not empty perms and perms.contains('receipts.view') and not empty monthlyImportTrend}">
      <div class="section-head"><h2>Xu hướng nhập xuất</h2></div>
      <section class="charts" data-od-id="import-export-chart">
        <div class="chart-card">
          <h3>Nhập / Xuất kho 12 tháng</h3>
          <svg viewBox="0 0 660 200" style="width:100%;height:200px">
            <g stroke="var(--border)" stroke-width="1">
              <line x1="40" y1="20" x2="650" y2="20"/>
              <line x1="40" y1="65" x2="650" y2="65" stroke-dasharray="2,3"/>
              <line x1="40" y1="110" x2="650" y2="110" stroke-dasharray="2,3"/>
              <line x1="40" y1="155" x2="650" y2="155" stroke-dasharray="2,3"/>
              <line x1="40" y1="200" x2="650" y2="200"/>
            </g>
            <c:set var="maxVal" value="0"/>
            <c:forEach var="item" items="${monthlyImportTrend}">
              <c:set var="c" value="${item.machineCount}"/>
              <c:if test="${c > maxVal}"><c:set var="maxVal" value="${c}"/></c:if>
            </c:forEach>
            <c:forEach var="item" items="${monthlyExportTrend}">
              <c:set var="c" value="${item.machineCount}"/>
              <c:if test="${c > maxVal}"><c:set var="maxVal" value="${c}"/></c:if>
            </c:forEach>
            <c:if test="${maxVal == 0}"><c:set var="maxVal" value="1"/></c:if>
            <g font-family="var(--font-mono)" font-size="10" fill="var(--muted)" text-anchor="end">
              <text x="34" y="24"><fmt:formatNumber value="${maxVal}" pattern="#,##0"/></text>
              <text x="34" y="68"><fmt:formatNumber value="${maxVal * 3 / 4}" pattern="#,##0"/></text>
              <text x="34" y="113"><fmt:formatNumber value="${maxVal / 2}" pattern="#,##0"/></text>
              <text x="34" y="158"><fmt:formatNumber value="${maxVal / 4}" pattern="#,##0"/></text>
              <text x="34" y="200">0</text>
            </g>
            <g font-family="var(--font-mono)" font-size="9" fill="var(--muted)" text-anchor="middle">
              <c:set var="i" value="0"/>
              <c:forEach var="item" items="${monthlyImportTrend}">
                <c:set var="xpos" value="${45 + i * 51}"/>
                <text x="${xpos}" y="216">${fn:substring(item.month, 5, 7)}</text>
                <c:set var="i" value="${i + 1}"/>
              </c:forEach>
            </g>
            <c:set var="importPoints" value=""/>
            <c:set var="exportPoints" value=""/>
            <c:set var="idx" value="0"/>
            <c:forEach var="item" items="${monthlyImportTrend}">
              <c:set var="px" value="${45 + idx * 51}"/>
              <c:set var="py" value="${200 - (item.machineCount * 180 / maxVal)}"/>
              <c:set var="importPoints" value="${importPoints} ${px},${py}"/>
              <c:set var="idx" value="${idx + 1}"/>
            </c:forEach>
            <c:set var="idx" value="0"/>
            <c:forEach var="item" items="${monthlyExportTrend}">
              <c:set var="px" value="${45 + idx * 51}"/>
              <c:set var="py" value="${200 - (item.machineCount * 180 / maxVal)}"/>
              <c:set var="exportPoints" value="${exportPoints} ${px},${py}"/>
              <c:set var="idx" value="${idx + 1}"/>
            </c:forEach>
            <c:if test="${not empty importPoints}">
            <polyline points="${importPoints}" fill="none" stroke="var(--muted)" stroke-width="2"/>
            </c:if>
            <c:if test="${not empty exportPoints}">
            <polyline points="${exportPoints}" fill="none" stroke="var(--muted)" stroke-width="2" stroke-dasharray="3,3"/>
            </c:if>
          </svg>
          <div class="chart-legend" style="display:flex;gap:20px;margin-top:8px;font-size:12px;color:var(--muted)">
            <span><span style="display:inline-block;width:14px;height:2px;background:var(--muted);margin-right:6px"></span>Nhập kho</span>
            <span><span style="display:inline-block;width:14px;height:0;border-top:2px dashed var(--muted);margin-right:6px"></span>Xuất kho</span>
          </div>
        </div>
      </section>
      </c:if>

      <%-- ===== Thẻ báo cáo ===== --%>
      <c:if test="${not empty perms and perms.contains('reports.view')}">
      <div class="section-head"><h2>Báo cáo</h2></div>
      <section class="report-cards" data-od-id="report-cards">
        <c:if test="${not empty perms and perms.contains('receipts.view')}">
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=inventory">
            <div class="rpt-icon green">
              <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo xuất nhập tồn</div>
              <div class="rpt-desc">Tồn đầu kì, tồn cuối kì theo từng model tại mỗi kho</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=import">
            <div class="rpt-icon blue">
              <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo nhập kho</div>
              <div class="rpt-desc">Chi tiết các serial đã nhập trong kì kèm model, phiếu mua</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=export">
            <div class="rpt-icon orange">
              <svg viewBox="0 0 24 24"><path d="M12 19V5M19 12l-7-7-7 7"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo xuất kho</div>
              <div class="rpt-desc">Chi tiết các serial đã xuất kèm model, đơn hàng</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        </c:if>
        <c:if test="${not empty perms and perms.contains('inventory_check.view')}">
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=inventory-check">
            <div class="rpt-icon purple">
              <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo kiểm kê</div>
              <div class="rpt-desc">Kết quả kiểm kê, chênh lệch giữa hệ thống và thực tế</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        </c:if>
        <c:if test="${not empty perms and perms.contains('orders.view')}">
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=purchase">
            <div class="rpt-icon red">
              <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo mua hàng</div>
              <div class="rpt-desc">Các đơn mua hàng (PO) trong kì</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=sales">
            <div class="rpt-icon teal">
              <svg viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo bán hàng</div>
              <div class="rpt-desc">Các đơn bán hàng trong kì</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>
        </c:if>
      </section>
      </c:if>

      <%-- ===== Khu vực dưới (2 cột) ===== --%>
      <section class="grid-2" data-od-id="activity">

        <%-- Danh sách giao dịch ===== --%>
        <c:if test="${not empty perms and perms.contains('receipts.view')}">
        <div class="card">
          <div class="card-head">
            <h3>Giao dịch gần đây</h3>
            <a href="${pageContext.request.contextPath}/import-receipt" style="font-size:12px;color:var(--muted);text-decoration:none">Xem tất cả →</a>
          </div>
          <div class="card-body">
            <div class="tx-list">
              <c:forEach var="tx" items="${recentReceipts}">
                <c:set var="isImport" value="${fn:startsWith(tx.receiptCode, 'RX-IM')}"/>
                <div class="tx">
                  <div class="tx-icon ${isImport ? 'in' : 'out'}">
                    <c:choose>
                      <c:when test="${isImport}">
                        <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg>
                      </c:when>
                      <c:otherwise>
                        <svg viewBox="0 0 24 24"><path d="M12 19V5M19 12l-7-7-7 7"/></svg>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="tx-body">
                    <div class="tx-title">${isImport ? 'Nhập' : 'Xuất'} kho — <c:out value="${tx.receiptCode}"/></div>
                    <div class="tx-sub">
                      <c:out value="${tx.warehouseName}"/>
                      <c:if test="${not empty tx.creatorName}"> · <c:out value="${tx.creatorName}"/></c:if>
                      <c:if test="${tx.machineCount > 0}"> · ${tx.machineCount} serial</c:if>
                    </div>
                  </div>
                  <div class="tx-amount">
                    <c:out value="${tx.receiptCode}"/>
                    <span class="when"><c:out value="${tx.createdAtStr}"/></span>
                  </div>
                </div>
              </c:forEach>
              <c:if test="${empty recentReceipts}">
                <div style="padding:20px;text-align:center;color:var(--muted);font-size:13px">Chưa có giao dịch nào</div>
              </c:if>
            </div>
          </div>
        </div>
        </c:if>

        <%-- ===== Liên kết nhanh (Quản trị) ===== --%>
        <c:if test="${not empty perms and perms.contains('users.view')}">
        <div class="card">
          <div class="card-head"><h3>Truy cập nhanh</h3></div>
          <div class="card-body">
            <div class="quick-links">
              <a href="${pageContext.request.contextPath}/admin/users" class="ql">
                <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                Quản lý người dùng
              </a>
              <a href="${pageContext.request.contextPath}/admin/roles" class="ql">
                <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                Phân quyền
              </a>
              <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20v%e1%ba%adt%20t%c6%b0" class="ql">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                Quản lý danh mục
              </a>
              <a href="${pageContext.request.contextPath}/admin/dashboard" class="ql">
                <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Bảng điều khiển
              </a>
            </div>
          </div>
        </div>
        </c:if>

        <%-- ===== Liên kết nhanh Giám đốc ===== --%>
        <c:if test="${not empty userRoleNames and userRoleNames.contains('ceo')}">
        <div class="card">
          <div class="card-head"><h3>Truy cập nhanh</h3></div>
          <div class="card-body">
            <div class="quick-links">
              <c:if test="${not empty perms and perms.contains('liquidations.view')}">
              <a href="${pageContext.request.contextPath}/liquidations" class="ql">
                <svg viewBox="0 0 24 24"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>
                Duyệt thanh lý
              </a>
              </c:if>
              <c:if test="${not empty perms and perms.contains('transfers.view')}">
              <a href="${pageContext.request.contextPath}/transfers" class="ql">
                <svg viewBox="0 0 24 24"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
                Duyệt luân chuyển
              </a>
              </c:if>
              <c:if test="${not empty perms and perms.contains('purchase_orders.view')}">
              <a href="${pageContext.request.contextPath}/purchase-order" class="ql">
                <svg viewBox="0 0 24 24"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-8 2a2 2 0 1 1-4 0 2 2 0 0 1 4 0z"/></svg>
                Duyệt phiếu mua
              </a>
              </c:if>
            </div>
          </div>
        </div>
        </c:if>

      </section>

      <%-- ===== Cảnh báo ===== --%>
      <div class="section-head"><h2>Cảnh báo cần xử lý</h2></div>
      <section class="alerts" data-od-id="alerts">

        <c:if test="${not empty perms and perms.contains('users.view')}">
        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Người dùng <span class="count">${activeUsers} hoạt động</span></div>
            <div class="alert-desc">Hệ thống có ${activeUsers} người dùng hoạt động, ${lockedUsers} tài khoản bị khoá.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng →</a>
          </div>
        </div>
        </c:if>

        <c:if test="${not empty perms and perms.contains('receipts.view')}">
        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Hoạt động kho</div>
            <div class="alert-desc">Tháng này có ${importCount + exportCount} phiếu nhập/xuất (${importCount} nhập, ${exportCount} xuất).</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/reports?type=import">Xem báo cáo →</a>
          </div>
        </div>
        </c:if>

        <c:if test="${not empty pendingLiquidations or not empty pendingTransfers or not empty pendingPOs}">
        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Chờ phê duyệt <span class="count">${pendingLiquidations + pendingTransfers + pendingPOs}</span></div>
            <div class="alert-desc">${pendingLiquidations} thanh lý, ${pendingTransfers} luân chuyển, ${pendingPOs} phiếu mua cần xử lý.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/liquidations">Xem ngay →</a>
          </div>
        </div>
        </c:if>

        <c:if test="${not empty perms and perms.contains('orders.approve')}">
        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Đơn chờ duyệt <span class="count">${pendingOrders}</span></div>
            <div class="alert-desc">Có ${pendingOrders} đơn hàng đang chờ được phê duyệt.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/order">Xem đơn hàng →</a>
          </div>
        </div>
        </c:if>

      </section>

      <div class="foot">
        <span>Bảng điều khiển · Tổng quan hệ thống</span>
        <span>v2.5.0</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
