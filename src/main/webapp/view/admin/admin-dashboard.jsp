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
<title>Quản lý kho — Dashboard</title>
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
  .kpi .label .dot { width: 6px; height: 6px; border-radius: 50%; background: var(--accent); }
  .kpi .value { font-family: var(--font-mono); font-size: 24px; font-weight: 600; letter-spacing: -0.02em; line-height: 1.1; color: var(--fg); }
  .kpi .value .unit { font-size: 13px; font-weight: 500; color: var(--muted); margin-inline-start: 4px; }
  .kpi .delta { margin-top: 8px; display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); }

  .grid-2 { display: grid; grid-template-columns: minmax(0, 2fr) minmax(0, 1fr); gap: 12px; }

  .tx-list { display: flex; flex-direction: column; }
  .tx { display: grid; grid-template-columns: 28px 1fr auto; gap: 12px; align-items: center; padding: 10px 0; border-bottom: 1px dashed var(--border); }
  .tx:last-child { border-bottom: 0; }
  .tx-icon { width: 28px; height: 28px; border-radius: 6px; display: grid; place-items: center; background: var(--surface-2); border: 1px solid var(--border); }
  .tx-icon svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .tx-icon.in { color: var(--accent); background: var(--accent-soft); border-color: transparent; }
  .tx-icon.out { color: var(--info); background: var(--info-soft); border-color: transparent; }
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
  .rpt-icon.green { background: var(--accent-soft); color: var(--accent); }
  .rpt-icon.blue { background: var(--info-soft); color: var(--info); }
  .rpt-icon.orange { background: var(--warn-soft); color: var(--warn); }
  .rpt-icon.purple { background: #e8dfff; color: #7c3aed; }
  .rpt-icon.red { background: var(--danger-soft); color: var(--danger); }
  .rpt-icon.teal { background: #d5f5f0; color: #0d9488; }
  .rpt-body { flex: 1; min-width: 0; }
  .rpt-title { font-size: 13px; font-weight: 600; }
  .rpt-desc { font-size: 11.5px; color: var(--muted); margin-top: 3px; line-height: 1.4; }
  .rpt-link { font-size: 11.5px; color: var(--accent); font-weight: 500; margin-top: 6px; display: inline-flex; align-items: center; gap: 3px; }

  .alerts { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
  .alert { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 14px 16px; display: flex; gap: 12px; align-items: flex-start; }
  .alert-icon { width: 30px; height: 30px; border-radius: 6px; display: grid; place-items: center; flex-shrink: 0; }
  .alert-icon svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .alert.warn .alert-icon { background: var(--warn-soft); color: var(--warn); }
  .alert.danger .alert-icon { background: var(--danger-soft); color: var(--danger); }
  .alert.info .alert-icon { background: var(--info-soft); color: var(--info); }
  .alert-body { flex: 1; min-width: 0; }
  .alert-title { font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
  .alert-title .count { font-family: var(--font-mono); font-size: 11px; padding: 1px 6px; border-radius: 3px; background: var(--surface-2); color: var(--fg-soft); border: 1px solid var(--border); font-weight: 500; }
  .alert-desc { font-size: 12px; color: var(--muted); margin-top: 4px; line-height: 1.45; }
  .alert-cta { margin-top: 8px; font-size: 12px; color: var(--fg); font-weight: 500; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; border-bottom: 1px solid var(--border-strong); padding-bottom: 1px; }
  .alert-cta:hover { color: var(--accent); border-color: var(--accent); }

  .foot { margin-top: 28px; padding-top: 14px; border-top: 1px solid var(--border); color: var(--muted); font-size: 11.5px; font-family: var(--font-mono); display: flex; justify-content: space-between; }

  .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
  [data-theme="light"] .theme-toggle .icon-moon { display: block; }
  [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

  @media (max-width: 1280px) {
    .kpis { grid-template-columns: repeat(2, 1fr); }
    .report-cards { grid-template-columns: repeat(2, 1fr); }
    .alerts { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<div class="app">

  <jsp:include page="../common/admin/aside.jsp" />

  <div>
    <header class="topbar" data-od-id="topbar">
      <h1>Dashboard</h1>
      <span class="crumb">/ Tổng quan</span>

      <div class="search">
        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
        <input placeholder="Tìm SKU, phiếu, nhà cung cấp…" />
        <kbd>⌘K</kbd>
      </div>

      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <jsp:include page="../common/admin/bell.jsp"/>
        <a href="${pageContext.request.contextPath}/import-receipt?action=create" class="btn btn-primary">
          <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
          Tạo phiếu nhập
        </a>
      </div>
    </header>

    <main>

      <section data-od-id="kpis">
        <div class="kpis">
          <div class="kpi">
            <div class="label">Tổng serial tồn kho <span class="dot"></span></div>
            <div class="value"><fmt:formatNumber value="${totalInStock}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">${activeWarehouses} kho</span>
              đang hoạt động
            </div>
          </div>

          <div class="kpi">
            <div class="label">Số model đang quản lý</div>
            <div class="value"><fmt:formatNumber value="${totalGenerators}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up"><fmt:formatNumber value="${inStockCount}" pattern="#,##0"/> model</span>
              có tồn kho
            </div>
          </div>

          <div class="kpi">
            <div class="label">Nhập kho tháng này</div>
            <div class="value"><fmt:formatNumber value="${importCount}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">phiếu nhập</span>
              từ đầu tháng
            </div>
          </div>

          <div class="kpi">
            <div class="label">Xuất kho tháng này</div>
            <div class="value"><fmt:formatNumber value="${exportCount}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change down">phiếu xuất</span>
              từ đầu tháng
            </div>
          </div>
        </div>
      </section>

      <div class="section-head">
        <h2>Báo cáo</h2>
      </div>
      <section class="report-cards" data-od-id="report-cards">

        <div class="rpt-card">
          <a href="${pageContext.request.contextPath}/reports?type=inventory">
            <div class="rpt-icon green">
              <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
            </div>
            <div class="rpt-body">
              <div class="rpt-title">Báo cáo tồn kho</div>
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
              <div class="rpt-desc">Chi tiết các serial đã nhập trong kì kèm model, PO</div>
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
              <div class="rpt-desc">Các đơn bán hàng (sale order) trong kì</div>
              <span class="rpt-link">Xem báo cáo →</span>
            </div>
          </a>
        </div>

      </section>

      <section class="grid-2" data-od-id="activity">
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

        <div class="card">
          <div class="card-head">
            <h3>Thông tin hệ thống</h3>
          </div>
          <div class="card-body">
            <div style="display:flex;flex-direction:column;gap:12px;padding:8px 0">
              <div style="display:flex;justify-content:space-between;font-size:13px">
                <span style="color:var(--muted)">Kho đang hoạt động</span>
                <span class="mono" style="font-weight:600">${activeWarehouses}</span>
              </div>
              <div style="display:flex;justify-content:space-between;font-size:13px">
                <span style="color:var(--muted)">Tổng serial tồn kho</span>
                <span class="mono" style="font-weight:600"><fmt:formatNumber value="${totalInStock}" pattern="#,##0"/></span>
              </div>
              <div style="display:flex;justify-content:space-between;font-size:13px">
                <span style="color:var(--muted)">Model máy phát</span>
                <span class="mono" style="font-weight:600"><fmt:formatNumber value="${totalGenerators}" pattern="#,##0"/></span>
              </div>
              <div style="display:flex;justify-content:space-between;font-size:13px">
                <span style="color:var(--muted)">Phiếu nhập tháng này</span>
                <span class="mono" style="font-weight:600;color:var(--accent)">+${importCount}</span>
              </div>
              <div style="display:flex;justify-content:space-between;font-size:13px">
                <span style="color:var(--muted)">Phiếu xuất tháng này</span>
                <span class="mono" style="font-weight:600;color:var(--info)">-${exportCount}</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <div class="section-head">
        <h2>Cảnh báo cần xử lý</h2>
      </div>
      <section class="alerts" data-od-id="alerts">
        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Kho <span class="count">${activeWarehouses} kho</span></div>
            <div class="alert-desc">Hệ thống đang quản lý ${activeWarehouses} kho với tổng cộng <fmt:formatNumber value="${totalInStock}" pattern="#,##0"/> serial máy phát.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/inventory">Quản lý tồn kho →</a>
          </div>
        </div>

        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Hoạt động gần đây</div>
            <div class="alert-desc">Tháng này có ${importCount + exportCount} phiếu nhập/xuất (${importCount} nhập, ${exportCount} xuất).</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/reports?type=import">Xem báo cáo →</a>
          </div>
        </div>

        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Báo cáo định kì</div>
            <div class="alert-desc">Truy cập các báo cáo tồn kho, nhập xuất, kiểm kê, mua bán theo tháng.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/reports?type=inventory">Xem tất cả báo cáo →</a>
          </div>
        </div>
      </section>

      <div class="foot">
        <span>Dashboard · Tổng quan hệ thống</span>
        <span>v2.4.1</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
