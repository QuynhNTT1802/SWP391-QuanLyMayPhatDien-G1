<%-- 
    Document   : forgotpass
    Created on : May 15, 2026, 11:16:34 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quên mật khẩu — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth-layout.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/forgotpass.css">
    </head>
    <body>
        <div class="auth">

            <aside class="visual">
                <div class="brand">
                    <div class="brand-mark">WH</div>
                    <div>Warehouse OS</div>
                </div>

                <div class="visual-body">
                    <div class="vis-eyebrow"><span class="dot"></span>Khôi phục</div>
                    <h2 class="vis-title">Lấy lại quyền <em>truy cập</em> kho.</h2>
                    <p class="vis-sub">Gửi yêu cầu cấp lại mật khẩu — admin sẽ xử lý và cấp mật khẩu mới cho bạn.</p>

                    <div class="steps">
                        <div class="step active">
                            <div class="step-num">1</div>
                            <div class="step-body">
                                <div class="step-title">Nhập tên đăng nhập</div>
                                <div class="step-sub">Tên đăng nhập bạn đã dùng để tạo tài khoản.</div>
                            </div>
                        </div>
                        <div class="step">
                            <div class="step-num">2</div>
                            <div class="step-body">
                                <div class="step-title">Admin xét duyệt</div>
                                <div class="step-sub">Yêu cầu của bạn được gửi đến admin để xử lý.</div>
                            </div>
                        </div>
                        <div class="step">
                            <div class="step-num">3</div>
                            <div class="step-body">
                                <div class="step-title">Admin cấp mật khẩu mới</div>
                                <div class="step-sub">Đăng nhập với mật khẩu mới do admin cung cấp.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>

            <main class="form-side">
                <div class="form-top">
                    <a href="authen?action=login" class="back">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại đăng nhập
                    </a>
                    <button class="theme-toggle" id="themeToggle">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                    </button>
                </div>

                <div class="form-wrap">
                    <form class="form" action="authen?action=forgotpass" method="post">
                        <div class="icon-badge">
                            <svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/><path d="M16 14h.01"/></svg>
                        </div>

                        <div class="form-head">
                            <h1>Quên mật khẩu?</h1>
                            <p>Nhập tên đăng nhập — admin sẽ cấp lại mật khẩu mới cho bạn.</p>
                        </div>

                        <c:if test="${not empty message}">
                        <div class="alert alert-success">
                            <svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                            <span>${message}</span>
                        </div>
                        </c:if>
                        <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span>${error}</span>
                        </div>
                        </c:if>

                        <div class="field">
                            <label for="username">Tên đăng nhập</label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/></svg></span>

                                <input name="username" id="username" type="text" placeholder="Nhập tên đăng nhập" required>
                            </div>

                        </div>
                        <button type="submit" class="btn-primary">Gửi yêu cầu</button>   

                        <div class="form-foot">
                            Nhớ mật khẩu rồi? <a href="authen?action=login">Đăng nhập</a>
                        </div>
                        <div class="form-bottom">
                            <a href="auth-gallery.html">Xem tất cả màn auth</a>
                            <span>
                                <a href="#">Liên hệ hỗ trợ</a>
                                <span class="dot-sep">·</span>
                                <a href="#">Zalo OA</a>
                            </span>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <script src="assets/js/theme.js"></script>
    </body>
</html>
