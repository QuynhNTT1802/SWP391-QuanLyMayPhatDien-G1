<%-- 
    Document   : 404
    Created on : May 25, 2026, 3:34:31 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>404 — Không tìm thấy trang | Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/error/404.css">
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
      <a href="${pageContext.request.contextPath}/home#faq">FAQ</a>
      <a href="#">Khách hàng</a>
    </nav>
    <div class="nav-cta">
      <c:choose>
        <c:when test="${not empty loggedUser}">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn">Dashboard</a>
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
    <div class="error-code">404</div>
    <h1 class="error-title">Trang không tồn tại</h1>
    <p class="error-desc">Đường dẫn bạn truy cập không tồn tại hoặc đã bị di chuyển. Kiểm tra lại URL hoặc quay về trang chủ.</p>
    <div class="error-actions">
      <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Về trang chủ <span class="arrow">&rarr;</span></a>
      <a href="javascript:history.back()" class="btn">Quay lại trang trước</a>
    </div>
    <div class="error-hint">
      <div class="error-hint-title">Có thể bạn đang tìm:</div>
      <ul>
        <li>Dashboard quản lý kho &mdash; <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:var(--accent)">/admin/dashboard</a></li>
        <li>Quản lý người dùng &mdash; <a href="${pageContext.request.contextPath}/admin/users" style="color:var(--accent)">/admin/users</a></li>
        <li>Phân quyền vai trò &mdash; <a href="${pageContext.request.contextPath}/admin/roles" style="color:var(--accent)">/admin/roles</a></li>
      </ul>
    </div>
  </div>
</section>

<footer class="site-footer">
  <div class="container">
    <div class="foot-top">
      <div class="foot-brand">
        <a href="${pageContext.request.contextPath}/home" class="brand"><span class="brand-mark">WH</span>Warehouse OS</a>
        <p>Hệ điều hành cho kho hàng. Made in Vietnam, dành cho nhà bán lẻ &amp; phân phối Việt.</p>
      </div>
      <div class="foot-col">
        <h5>Sản phẩm</h5>
        <ul>
          <li><a href="${pageContext.request.contextPath}/home#features">Tính năng</a></li>
          <li><a href="${pageContext.request.contextPath}/home#pricing">Bảng giá</a></li>
          <li><a href="#">Demo</a></li>
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
          <li><a href="#">API docs</a></li>
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