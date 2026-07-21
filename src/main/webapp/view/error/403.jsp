<%-- 
    Document   : 403
    Created on : May 25, 2026, 3:34:40 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>403 — Không có quyền truy cập | Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error/403.css">
</head>
<body>

<header class="site-nav">
  <div class="container nav-inner">
    <a href="${pageContext.request.contextPath}/home" class="brand">
      <span class="brand-mark">WH</span>
      Warehouse OS
    </a>
    <nav class="nav-links">
      <a href="${pageContext.request.contextPath}/home#features">Tính năng</a>
      <a href="${pageContext.request.contextPath}/home#preview">Sản phẩm</a>
      <a href="${pageContext.request.contextPath}/home#pricing">Bảng giá</a>
      <a href="${pageContext.request.contextPath}/home#faq">Câu hỏi thường gặp</a>
      <a href="#">Khách hàng</a>
    </nav>
    <div class="nav-cta">
      <c:choose>
        <c:when test="${not empty loggedUser}">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn">Bảng điều khiển</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/authen?action=login" class="btn btn-ghost">Đăng nhập</a>
          <a href="#" class="btn btn-primary">Dùng thử miễn phí <span class="arrow">&rarr;</span></a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<section class="error-section">
  <div class="error-content">
    <div class="error-code">403</div>
    <h1 class="error-title">Không có quyền truy cập</h1>
    <p class="error-desc">Tài khoản của bạn không được phép truy cập trang này. Liên hệ quản trị viên nếu bạn cho rằng đây là nhầm lẫn.</p>
    <div class="error-actions">
      <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Về trang chủ <span class="arrow">&rarr;</span></a>
      <a href="javascript:history.back()" class="btn">Quay lại trang trước</a>
      <a href="${pageContext.request.contextPath}/authen?action=logout" class="btn">Đổi tài khoản</a>
    </div>

    <c:if test="${not empty loggedUser}">
    <c:set var="roleNames" value="" />
    <c:forEach items="${loggedUser.roles}" var="role" varStatus="rs">
      <c:set var="roleNames" value="${roleNames}${role.roleName}${rs.last ? '' : ', '}" />
    </c:forEach>
    <div class="role-pill">
      <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
      Vai trò hiện tại: ${empty roleNames ? 'Chưa phân quyền' : roleNames}
    </div>
    </c:if>

    <c:if test="${not empty requiredPerm}">
    <div class="perm-pill">
      <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
      Quyền yêu cầu: ${requiredPerm}
    </div>
    </c:if>

    <div class="error-panel">
      <div class="error-panel-title">
        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        Bạn có thể thử
      </div>
      <ul class="suggestion-list">
        <li><span class="num">1</span>Yêu cầu quản trị viên cấp quyền truy cập trang này cho vai trò của bạn</li>
        <li><span class="num">2</span>Đăng nhập bằng tài khoản khác có quyền cao hơn (Quản trị viên, Quản lý kho)</li>
        <li><span class="num">3</span>Kiểm tra vai trò hiện tại tại trang <a href="${pageContext.request.contextPath}/profile" style="color:var(--accent)">Hồ sơ cá nhân</a></li>
        <li><span class="num">4</span>Liên hệ bộ phận IT qua email hỗ trợ <span style="font-family:var(--font-mono);font-size:12px;color:var(--accent)">support@warehouse-os.vn</span></li>
      </ul>
    </div>
  </div>
</section>

<footer class="site-footer">
  <div class="container">
    <div class="foot-top">
      <div class="foot-brand">
        <a href="${pageContext.request.contextPath}/home" class="brand"><span class="brand-mark">WH</span>Warehouse OS</a>
        <p>Hệ điều hành cho kho hàng. Sản xuất tại Việt Nam, dành cho nhà bán lẻ &amp; phân phối Việt.</p>
      </div>
      <div class="foot-col">
        <h5>Sản phẩm</h5>
        <ul>
          <li><a href="${pageContext.request.contextPath}/home#features">Tính năng</a></li>
          <li><a href="${pageContext.request.contextPath}/home#pricing">Bảng giá</a></li>
          <li><a href="#">Bản demo</a></li>
          <li><a href="#">Tích hợp</a></li>
          <li><a href="#">Thay đổi gần đây</a></li>
        </ul>
      </div>
      <div class="foot-col">
        <h5>Công ty</h5>
        <ul>
          <li><a href="#">Về chúng tôi</a></li>
          <li><a href="#">Khách hàng</a></li>
          <li><a href="#">Tuyển dụng</a></li>
          <li><a href="#">Liên hệ</a></li>
        </ul>
      </div>
      <div class="foot-col">
        <h5>Tài liệu</h5>
        <ul>
          <li><a href="#">Hướng dẫn dùng</a></li>
          <li><a href="#">Tài liệu API</a></li>
          <li><a href="#">Blog vận hành kho</a></li>
          <li><a href="#">Trạng thái hệ thống</a></li>
        </ul>
      </div>
    </div>
    <div class="foot-bot">
      <span>&copy; 2026 Warehouse OS &middot; MST 0108-xxxx-xxx &middot; 24 Lý Thường Kiệt, Hà Nội</span>
      <div class="socials">
        <a href="#">Facebook</a>
        <a href="#">LinkedIn</a>
        <a href="#">YouTube</a>
      </div>
    </div>
  </div>
</footer>

</body>
</html>
