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
<title>Bảng Điều Khiển — Kinh Doanh & Đơn Hàng</title>
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
      <h1><c:out value="${isSalesManager ? 'Bảng Điều Khiển Quản Lý Kinh Doanh' : 'Bảng Điều Khiển Nhân Viên Kinh Doanh'}"/></h1>
      <span class="crumb">/ <c:out value="${isSalesManager ? 'Quản lý đội ngũ kinh doanh & phê duyệt đơn' : 'Theo dõi đơn hàng & chỉ số cá nhân'}"/></span>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <jsp:include page="../common/admin/bell.jsp"/>
        <c:choose>
          <c:when test="${isSalesManager}">
            <a href="${pageContext.request.contextPath}/order" style="display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:var(--radius);background:var(--fg);color:#fff;text-decoration:none;font-weight:600;font-size:12.5px">
              Quản lý đơn hàng
            </a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/order?action=create" style="display:inline-flex;align-items:center;gap:6px;padding:7px 14px;border-radius:var(--radius);background:var(--fg);color:#fff;text-decoration:none;font-weight:600;font-size:12.5px">
              Tạo đơn bán hàng
            </a>
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
          <div class="kpi">
            <div class="label">Đơn Hàng Hôm Nay <span class="dot"></span></div>
            <div class="value mono"><fmt:formatNumber value="${not empty todayOrders ? todayOrders : 0}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">Phát sinh</span>
              đơn bán máy trong ngày
            </div>
          </div>

          <div class="kpi">
            <div class="label">Đơn Chờ Duyệt (PENDING)</div>
            <div class="value mono"><fmt:formatNumber value="${isSalesManager ? pendingOrders : (not empty myPendingOrders ? myPendingOrders : 0)}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change down">Cần duyệt</span>
              đang chờ xác nhận
            </div>
          </div>

          <div class="kpi">
            <div class="label">Đã Duyệt Xuất Kho</div>
            <div class="value mono"><fmt:formatNumber value="${isSalesManager ? approvedOrders : (not empty myApprovedOrders ? myApprovedOrders : 0)}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">Sẵn sàng</span>
              đã chuyển kho xuất
            </div>
          </div>

          <div class="kpi">
            <div class="label">Đã Hoàn Thành</div>
            <div class="value mono"><fmt:formatNumber value="${isSalesManager ? completedOrders : (not empty myCompletedOrders ? myCompletedOrders : 0)}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">Thành công</span>
              đã giao cho khách
            </div>
          </div>
        </div>
      </section>

      <%-- Quick Hub: Phím Tắt Thao Tác Bán Hàng Nhanh --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          Phím Tắt Thao Tác Bán Hàng & Đơn Hàng
        </h3>
      </div>

      <div class="dash-quick-grid">
        <a href="${pageContext.request.contextPath}/order?action=create" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
          </div>
          Tạo Đơn Bán Hàng (PO)
        </a>

        <a href="${pageContext.request.contextPath}/order" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
          </div>
          Quản Lý Đơn Hàng
        </a>

        <a href="${pageContext.request.contextPath}/reports?type=sales" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
          </div>
          Báo Cáo Doanh Số
        </a>

        <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20v%e1%ba%adt%20t%c6%b0" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          </div>
          Danh Mục Máy Khả Dụng
        </a>
      </div>

      <%-- Section 2: Activity Grid (Sales Donut Status & Active Customers) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
          Phân Tích Đơn Bán Hàng & Đối Tác
        </h3>
      </div>

      <section class="dash-grid-3-1">
        <%-- Donut Chart Card (Manager: all orders, Staff: own orders) --%>
        <c:set var="donutData" value="${isSalesManager ? donutSegments : myDonutSegments}"/>
        <c:set var="donutTotalVal" value="${isSalesManager ? donutTotal : myDonutTotal}"/>
        <div class="card">
          <div class="card-head">
            <div>
              <h3>Tỉ Lệ Đơn Hàng Theo Trạng Thái</h3>
              <div class="sub" style="margin-top:2px">${isSalesManager ? 'Thống kê toàn hệ thống' : 'Đơn hàng của tôi'}</div>
            </div>
            <a href="${pageContext.request.contextPath}/order" style="font-size:12px;color:var(--accent);text-decoration:none;font-weight:500">Danh sách đơn →</a>
          </div>
          <div class="card-body" style="display:flex;flex-direction:column;justify-content:center;height:100%;min-height:240px">
            <c:choose>
              <c:when test="${not empty donutData}">
                <div style="display:flex;align-items:center;justify-content:center;gap:24px;padding:12px 8px">
                  <svg viewBox="0 0 200 200" style="width:180px;height:180px;flex-shrink:0">
                    <circle cx="100" cy="100" r="78" fill="none" stroke="var(--surface-2)" stroke-width="22"/>
                    <c:forEach var="seg" items="${donutData}">
                    <circle cx="100" cy="100" r="78" fill="none"
                      stroke="${seg.color}" stroke-width="22"
                      stroke-dasharray="${seg.dashLen} ${seg.gap}"
                      stroke-dashoffset="${seg.dashOffset}"
                      transform="rotate(-90 100 100)"/>
                    </c:forEach>
                    <text x="100" y="96" text-anchor="middle" font-family="var(--font-mono)" font-size="23" font-weight="700" fill="var(--fg)">${not empty donutTotalVal ? donutTotalVal : 0}</text>
                    <text x="100" y="116" text-anchor="middle" font-family="var(--font-ui)" font-size="11.5" fill="var(--muted)" font-weight="500">tổng đơn</text>
                  </svg>
                  <div style="display:flex;flex-direction:column;gap:10px;font-size:13px;min-width:180px">
                    <c:forEach var="seg" items="${donutData}">
                    <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;padding:3px 0;border-bottom:1px dashed var(--border)">
                      <span style="display:inline-flex;align-items:center;gap:8px;font-weight:500;color:var(--fg)">
                        <span style="display:inline-block;width:10px;height:10px;border-radius:3px;background:${seg.color}"></span>
                        <c:out value="${seg.status}"/>
                      </span>
                      <span style="font-family:var(--font-mono);font-weight:700;color:var(--fg)"><c:out value="${seg.count}"/> đơn</span>
                    </div>
                    </c:forEach>
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <div style="padding:30px;text-align:center;color:var(--muted);font-size:13px">Chưa có biểu đồ đơn hàng</div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <%-- Recent Customer List --%>
        <div class="card">
          <div class="card-head">
            <h3>Khách Hàng Gần Đây</h3>
            <a href="${pageContext.request.contextPath}/warehouse/customers" style="font-size:12px;color:var(--muted);text-decoration:none">Xem tất cả →</a>
          </div>
          <div class="card-body">
            <div class="tx-list">
              <c:forEach var="cust" items="${recentCustomers}">
                <div class="tx">
                  <div class="tx-icon in">
                    <svg viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                  </div>
                  <div class="tx-body">
                    <div class="tx-title"><c:out value="${cust.name}"/></div>
                    <div class="tx-sub"><c:out value="${not empty cust.phone ? cust.phone : 'Chưa có SĐT'}"/></div>
                  </div>
                  <div class="tx-amount">
                    <span class="when"><c:out value="${not empty cust.companyName ? cust.companyName : 'Cá nhân'}"/></span>
                  </div>
                </div>
              </c:forEach>
              <c:if test="${empty recentCustomers}">
                <div style="padding:20px;text-align:center;color:var(--muted);font-size:12px">Chưa có khách hàng</div>
              </c:if>
            </div>
          </div>
        </div>
      </section>

      <%-- Section 3: Detailed Model Inventory Table with Filter Tabs & Export CSV --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          Danh Mục Model Máy Phát Điện Khả Dụng Để Bán
        </h3>
        <span class="sub">Hiển thị ${fn:length(modelSummaries)} / <fmt:formatNumber value="${not empty totalGenerators ? totalGenerators : 0}" pattern="#,##0"/> Model</span>
      </div>

      <section class="card" style="padding:0;overflow:hidden">
        <div class="card-head" style="padding:14px 16px;margin-bottom:0;border-bottom:1px solid var(--border)">
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
            <c:forEach var="m" items="${modelSummaries}">
              <c:set var="statusClass" value="${m.totalSerials > 5 ? 'ok' : (m.totalSerials > 0 ? 'low' : 'out')}"/>
              <tr data-status="${statusClass}">
                <td class="sku">GEN-${m.id}</td>
                <td>
                  <div class="product"><c:out value="${m.model}"/></div>
                  <div class="product-sub">Máy phát điện bán mới</div>
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
          Thao Tác Bán Hàng & Cảnh Báo
        </h3>
      </div>

      <section class="alerts">
        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Đơn chờ duyệt <span class="count">${not empty pendingOrders ? pendingOrders : 0} Đơn</span></div>
            <div class="alert-desc">Các đơn hàng bán máy đang chờ quản lý phê duyệt cấp phép xuất kho.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/order">Xem đơn bán hàng →</a>
          </div>
        </div>

        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Model sắp hết <span class="count">${not empty lowStockModelsCount ? lowStockModelsCount : 0} Model</span></div>
            <div class="alert-desc">Có ${not empty lowStockModelsCount ? lowStockModelsCount : 0} Model tồn kho ≤ 5 máy. Cần tư vấn khách chuyển Model hoặc tạo đơn sớm.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/order?action=create">Tạo đơn bán ngay →</a>
          </div>
        </div>

        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Báo cáo doanh số <span class="count">Kinh doanh</span></div>
            <div class="alert-desc">Xem chi tiết doanh số bán hàng, doanh thu và các chỉ số kinh doanh tháng này.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/reports?type=sales">Xem báo cáo →</a>
          </div>
        </div>
      </section>

      <%-- Section 5: System Footer --%>
      <div class="foot">
        <span>Đồng bộ cuối · ${not empty todayFormattedDate ? todayFormattedDate : 'Hôm nay'} · Bộ Phận Kinh Doanh & Đơn Hàng</span>
        <span>v2.4.1 · 6 người dùng đang online</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
