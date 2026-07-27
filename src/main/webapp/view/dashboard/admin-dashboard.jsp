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
<title>Bảng Điều Khiển — Quản Trị Hệ Thống</title>
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
      <h1>Bảng Điều Khiển Admin</h1>
      <span class="crumb">/ Quản trị hệ thống & phân quyền</span>
      <div class="top-actions" style="margin-inline-start: auto;">
        <jsp:include page="../common/admin/bell.jsp"/>
        <a href="${pageContext.request.contextPath}/admin/users?action=create" class="btn btn-primary" style="text-decoration: none;">
          <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="17" y1="11" x2="23" y2="11"/></svg>
          Tạo tài khoản
        </a>
      </div>
    </header>

    <main class="dashboard-container">

      <%-- Đầu trang hero --%>
      <jsp:include page="dashboard-header.jsp" />

      <%-- Phần 1: 4 Thẻ KPI --%>
      <section>
        <div class="kpis">
          <div class="kpi">
            <div class="label">Người Dùng Hoạt Động <span class="dot"></span></div>
            <div class="value mono"><fmt:formatNumber value="${not empty activeUsers ? activeUsers : 0}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change up">Đang hoạt động</span>
              sử dụng hệ thống
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Tài Khoản Bị Khóa</div>
            <div class="value mono"><fmt:formatNumber value="${not empty lockedUsers ? lockedUsers : 0}" pattern="#,##0"/></div>
            <div class="delta">
              <span class="change down">Đã khóa</span>
              tạm ngưng bảo mật
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Vai Trò Hệ Thống</div>
            <div class="value mono">${not empty totalRoles ? totalRoles : 0} <span class="unit">vai trò</span></div>
            <div class="delta">
              <span class="change flat">Đã cấu hình</span>
              phân quyền vai trò
            </div>
            
          </div>

          <div class="kpi">
            <div class="label">Tổng Quyền Hạn Phân Quyền</div>
            <div class="value mono">${not empty totalPermissions ? totalPermissions : 0}</div>
            <div class="delta">
              <span class="change up">Chức năng</span>
              quyền hạn thiết lập
            </div>
            
          </div>
        </div>
      </section>

      <%-- Trung tâm điều khiển nhanh Quản trị --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
          Truy Cập Nhanh Quản Trị Hệ Thống
        </h3>
      </div>

      <div class="dash-quick-grid">
        <%-- Icon 1: Quản Lý Người Dùng (Icon Nhóm Người Dùng) --%>
        <a href="${pageContext.request.contextPath}/admin/users" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
          Quản Lý Người Dùng
        </a>

        <%-- Icon 2: Tạo Tài Khoản Mới (Icon Người Dùng Thêm) --%>
        <a href="${pageContext.request.contextPath}/admin/users?action=create" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="17" y1="11" x2="23" y2="11"/></svg>
          </div>
          Tạo Người Dùng Mới
        </a>

        <%-- Icon 3: Phân Quyền (Icon Khiên Bảo Mật) --%>
        <a href="${pageContext.request.contextPath}/admin/roles" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          </div>
          Phân Quyền
        </a>

        <%-- Icon 4: Danh Mục Vật Tư (Icon Khối Lưới) --%>
        <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20v%e1%ba%adt%20t%c6%b0" class="dash-quick-btn">
          <div class="dash-quick-icon">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
          </div>
          Danh Mục Hệ Thống
        </a>
      </div>

      <%-- Phần 2: Lưới hoạt động (Trái 2fr: Biểu đồ cột | Phải 1fr: Người dùng mới) --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
          Phân Bố Vai Trò & Người Dùng Mới Tạo
        </h3>
        <span class="sub">Thống kê vai trò tài khoản</span>
      </div>

      <section class="dash-grid-3-1">
        <%-- Trái 2fr: Biểu đồ cột phân bố vai trò --%>
        <div class="card">
          <div class="card-head">
            <div>
              <h3>Phân Bố Người Dùng Theo Vai Trò</h3>
              <div class="sub" style="margin-top:2px">Biểu đồ cột thể hiện tỉ lệ & số lượng tài khoản </div>
            </div>
            <a href="${pageContext.request.contextPath}/admin/roles" style="font-size:12px;color:var(--accent);text-decoration:none;font-weight:500">Quản lý vai trò →</a>
          </div>
          <div class="card-body" style="display:flex;flex-direction:column;justify-content:center;height:100%;padding:14px 6px">
            <c:choose>
              <c:when test="${not empty userByRole}">
                <c:set var="maxRoleCount" value="0"/>
                <c:forEach var="entry" items="${userByRole}">
                  <c:if test="${entry.value > maxRoleCount}"><c:set var="maxRoleCount" value="${entry.value}"/></c:if>
                </c:forEach>
                <c:if test="${maxRoleCount == 0}"><c:set var="maxRoleCount" value="1"/></c:if>

                <div style="display:flex;flex-direction:column;gap:14px">
                  <c:forEach var="entry" items="${userByRole}">
                    <c:set var="barPct" value="${entry.value * 100 / maxRoleCount}"/>
                    <c:set var="roleColor" value="var(--muted)"/>
                    <div style="display:flex;align-items:center;gap:16px">
                      <div style="width:180px;font-size:13px;font-weight:600;color:var(--fg);text-align:right;flex-shrink:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">
                        <c:out value="${entry.key}"/>
                      </div>
                      <div style="flex:1;height:26px;background:var(--surface-2);border-radius:6px;overflow:hidden;border:1px solid var(--border);position:relative">
                        <div style="width:${barPct}%;height:100%;background:${roleColor};border-radius:5px;display:flex;align-items:center;padding-left:10px;transition:width 0.4s ease;box-shadow:inset 0 1px 0 rgba(255,255,255,0.25)">
                          <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:700;letter-spacing:0.02em"><c:out value="${entry.value}"/> tài khoản</span>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </c:when>
              <c:otherwise>
                <div style="display:flex;flex-direction:column;gap:14px">
                  <div style="display:flex;align-items:center;gap:16px">
                    <div style="width:180px;font-size:13px;font-weight:600;color:var(--fg);text-align:right;flex-shrink:0">Quản Trị Hệ Thống</div>
                    <div style="flex:1;height:26px;background:var(--surface-2);border-radius:6px;overflow:hidden;border:1px solid var(--border)">
                      <div style="width:100%;height:100%;background:var(--muted);border-radius:5px;display:flex;align-items:center;padding-left:10px">
                        <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:700">1 tài khoản</span>
                      </div>
                    </div>
                  </div>

                  <div style="display:flex;align-items:center;gap:16px">
                    <div style="width:180px;font-size:13px;font-weight:600;color:var(--fg);text-align:right;flex-shrink:0">Vận Hành Kho</div>
                    <div style="flex:1;height:26px;background:var(--surface-2);border-radius:6px;overflow:hidden;border:1px solid var(--border)">
                      <div style="width:75%;height:100%;background:var(--muted);border-radius:5px;display:flex;align-items:center;padding-left:10px">
                        <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:700">4 tài khoản</span>
                      </div>
                    </div>
                  </div>

                  <div style="display:flex;align-items:center;gap:16px">
                    <div style="width:180px;font-size:13px;font-weight:600;color:var(--fg);text-align:right;flex-shrink:0">Kinh Doanh</div>
                    <div style="flex:1;height:26px;background:var(--surface-2);border-radius:6px;overflow:hidden;border:1px solid var(--border)">
                      <div style="width:55%;height:100%;background:var(--muted);border-radius:5px;display:flex;align-items:center;padding-left:10px">
                        <span style="font-family:var(--font-mono);font-size:12px;color:#fff;font-weight:700">3 tài khoản</span>
                      </div>
                    </div>
                  </div>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <%-- Phải 1fr: Người dùng mới tạo gần đây --%>
        <div class="card">
          <div class="card-head">
            <h3>Người Dùng Mới Tạo</h3>
            <a href="${pageContext.request.contextPath}/admin/users" style="font-size:12px;color:var(--muted);text-decoration:none">Xem tất cả →</a>
          </div>
          <div class="card-body">
            <div class="tx-list">
              <c:forEach var="u" items="${recentUsers}">
                <c:set var="isActive" value="${u.status == 'active'}"/>
                <div class="tx">
                  <div class="tx-icon ${isActive ? 'in' : 'out'}">
                    <svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/></svg>
                  </div>
                  <div class="tx-body">
                    <div class="tx-title"><c:out value="${u.name}"/></div>
                    <div class="tx-sub"><c:out value="${not empty u.roles and not empty u.roles[0] ? u.roles[0].description : u.email}"/></div>
                  </div>
                  <div class="tx-amount">
                    ${isActive ? 'Hoạt động' : 'Đã khóa'}
                  </div>
                </div>
              </c:forEach>
              <c:if test="${empty recentUsers}">
                <div style="padding:20px;text-align:center;color:var(--muted);font-size:12px">Chưa có người dùng mới tạo</div>
              </c:if>
            </div>
          </div>
        </div>
      </section>

      <%-- Phần 3: 3 Thẻ Cảnh Báo --%>
      <div class="dash-sec-head">
        <h3>
          <svg viewBox="0 0 24 24"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><path d="M12 9v4M12 17h.01"/></svg>
          Cảnh Báo & Quản Trị Hệ Thống
        </h3>
      </div>

      <section class="alerts">
        <div class="alert warn">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Người dùng đang hoạt động <span class="count">${not empty activeUsers ? activeUsers : 0} Tài khoản</span></div>
            <div class="alert-desc">Quản lý danh sách người dùng, phân gán vai trò và cập nhật trạng thái hoạt động.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/admin/users">Quản lý người dùng →</a>
          </div>
        </div>

        <div class="alert danger">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Tài khoản bị khóa <span class="count">${not empty lockedUsers ? lockedUsers : 0} Tài khoản</span></div>
            <div class="alert-desc">Các tài khoản tạm khóa bảo mật do vi phạm quy định hoặc ngừng hoạt động.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/admin/users">Mở khóa tài khoản →</a>
          </div>
        </div>

        <div class="alert info">
          <div class="alert-icon"><svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>
          <div class="alert-body">
            <div class="alert-title">Cấu hình phân quyền <span class="count">${not empty totalRoles ? totalRoles : 0} Vai trò</span></div>
            <div class="alert-desc">Cấu hình chi tiết vai trò và gán danh sách quyền hạn chức năng.</div>
            <a class="alert-cta" href="${pageContext.request.contextPath}/admin/roles">Cấu hình phân quyền →</a>
          </div>
        </div>
      </section>

      <%-- Phần 4: Chân trang hệ thống --%>
      <div class="foot">
        <span>Đồng bộ cuối · ${not empty todayFormattedDate ? todayFormattedDate : 'Hôm nay'} · Bộ Phận Quản Trị Hệ Thống</span>
        <span>v1.0.0</span>
      </div>

    </main>
  </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
