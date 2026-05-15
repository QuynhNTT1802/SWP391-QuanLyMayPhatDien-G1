<%-- 
    Document   : lgoin
    Created on : May 15, 2026, 8:48:56 AM
    Author     : Phuong Linh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Đăng nhập — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth-layout.css">
    </head>
    <body>
        <div class="auth">

            <aside class="visual">
                <div class="brand">
                    <div class="brand-mark">WH</div>
                    <div>Warehouse OS</div>
                </div>

                <div class="visual-body">
                    <div class="vis-eyebrow"><span class="dot"></span>Đăng nhập</div>
                    <h2 class="vis-title">Quản lý kho <em>biết suy nghĩ</em>.</h2>
                    <p class="vis-sub">240+ doanh nghiệp Việt đang dùng Warehouse OS để theo dõi 4,8 triệu SKU mỗi tháng — không còn excel, không còn SKU âm.</p>

                    <div class="mock" aria-hidden="true">
                        <div class="mock-head">
                            <div class="dots"><span></span><span></span><span></span></div>
                            <div class="title">warehouse-os.app/dashboard</div>
                        </div>
                        <div class="mock-kpis">
                            <div class="mock-kpi"><div class="l">Tồn kho</div><div class="v">348,920</div></div>
                            <div class="mock-kpi"><div class="l">Giá trị</div><div class="v">8.42<span style="font-size:10px;color:var(--muted);font-weight:500;margin-inline-start:2px">tỷ</span></div></div>
                            <div class="mock-kpi"><div class="l">Sắp hết</div><div class="v acc">47</div></div>
                        </div>
                        <div class="mock-chart">
                            <svg viewBox="0 0 240 48" preserveAspectRatio="none">
                            <polyline points="0,38 20,32 40,34 60,28 80,30 100,22 120,26 140,18 160,22 180,14 200,18 220,10 240,8" fill="none" stroke="var(--accent)" stroke-width="1.5"/>
                            <polyline points="0,38 20,32 40,34 60,28 80,30 100,22 120,26 140,18 160,22 180,14 200,18 220,10 240,8 240,48 0,48" fill="var(--accent)" opacity="0.12"/>
                            </svg>
                        </div>
                    </div>

                    <div class="vis-quote">
                        <div class="vis-avatar">PT</div>
                        <div>
                            <p>"Sau 3 tháng, kho HN giảm 31% SKU âm. Đội ops không còn đối chiếu excel cuối tuần nữa."</p>
                            <div class="who"><b>Phạm Tùng</b> · Giám đốc vận hành, An Phú Foods</div>
                        </div>
                    </div>
                </div>
            </aside>

            <main class="form-side">
                <div class="form-top">
                    <a href="${pageContext.request.contextPath}/home" class="back">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Trang chủ
                    </a>
                    <button class="theme-toggle" id="themeToggle" title="Đổi theme">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                    </button>
                </div>

                <div class="form-wrap">
                    <form class="form" onsubmit="event.preventDefault(); window.location.href = 'index.html';">
                        <div class="form-head">
                            <h1>Đăng nhập</h1>
                            <p>Chưa có tài khoản? <a href="signup.html">Tạo tài khoản miễn phí</a></p>
                        </div>

                        <div class="social">
                            <button type="button" class="btn-social">
                                <svg viewBox="0 0 48 48"><path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303c-1.649 4.657-6.08 8-11.303 8c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C12.955 4 4 12.955 4 24s8.955 20 20 20s20-8.955 20-20c0-1.341-.138-2.65-.389-3.917z"/><path fill="#FF3D00" d="m6.306 14.691l6.571 4.819C14.655 15.108 18.961 12 24 12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C16.318 4 9.656 8.337 6.306 14.691z"/><path fill="#4CAF50" d="M24 44c5.166 0 9.86-1.977 13.409-5.192l-6.19-5.238A11.91 11.91 0 0 1 24 36c-5.202 0-9.619-3.317-11.283-7.946l-6.522 5.025C9.505 39.556 16.227 44 24 44z"/><path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303a12.04 12.04 0 0 1-4.087 5.571l.003-.002l6.19 5.238C36.971 39.205 44 34 44 24c0-1.341-.138-2.65-.389-3.917z"/></svg>
                                Tiếp tục với Google
                            </button>
                        </div>

                        <div class="divider">hoặc</div>

                        <div class="field">
                            <label for="email">Email</label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg></span>
                                <input id="email" type="email" placeholder="ban@congty.vn" autocomplete="email" required>
                            </div>
                        </div>

                        <div class="field">
                            <label for="password">
                                Mật khẩu
                                <span class="hint"><a href="forgot-password.html">Quên mật khẩu?</a></span>
                            </label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></span>
                                <input id="password" type="password" placeholder="••••••••••" autocomplete="current-password" required>
                                <button type="button" class="toggle-pw" onclick="togglePw(this)" aria-label="Hiện mật khẩu">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                        </div>

                        <div class="row">
                            <label class="checkbox">
                                <input type="checkbox"> Ghi nhớ đăng nhập 30 ngày
                            </label>
                        </div>

                        <button type="submit" class="btn-primary">Đăng nhập</button>

                        <div class="form-bottom">
                            <a href="auth-gallery.html">Xem tất cả màn auth</a>
                            <span>
                                <a href="#">Điều khoản</a>
                                <span class="dot-sep">·</span>
                                <a href="#">Bảo mật</a>
                            </span>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <script src="assets/js/theme.js"></script>
        <script>
                        function togglePw(btn) {
                            var input = btn.previousElementSibling;
                            input.type = input.type === 'password' ? 'text' : 'password';
                        }
        </script>
    </body>
</html>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Đăng nhập — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/variables.css">
        <link rel="stylesheet" href="assets/css/base.css">
        <link rel="stylesheet" href="assets/css/auth-layout.css">
    </head>
    <body>
        <div class="auth">

            <aside class="visual">
                <div class="brand">
                    <div class="brand-mark">WH</div>
                    <div>Warehouse OS</div>
                </div>

                <div class="visual-body">
                    <div class="vis-eyebrow"><span class="dot"></span>Đăng nhập</div>
                    <h2 class="vis-title">Quản lý kho <em>biết suy nghĩ</em>.</h2>
                    <p class="vis-sub">240+ doanh nghiệp Việt đang dùng Warehouse OS để theo dõi 4,8 triệu SKU mỗi tháng — không còn excel, không còn SKU âm.</p>

                    <div class="mock" aria-hidden="true">
                        <div class="mock-head">
                            <div class="dots"><span></span><span></span><span></span></div>
                            <div class="title">warehouse-os.app/dashboard</div>
                        </div>
                        <div class="mock-kpis">
                            <div class="mock-kpi"><div class="l">Tồn kho</div><div class="v">348,920</div></div>
                            <div class="mock-kpi"><div class="l">Giá trị</div><div class="v">8.42<span style="font-size:10px;color:var(--muted);font-weight:500;margin-inline-start:2px">tỷ</span></div></div>
                            <div class="mock-kpi"><div class="l">Sắp hết</div><div class="v acc">47</div></div>
                        </div>
                        <div class="mock-chart">
                            <svg viewBox="0 0 240 48" preserveAspectRatio="none">
                            <polyline points="0,38 20,32 40,34 60,28 80,30 100,22 120,26 140,18 160,22 180,14 200,18 220,10 240,8" fill="none" stroke="var(--accent)" stroke-width="1.5"/>
                            <polyline points="0,38 20,32 40,34 60,28 80,30 100,22 120,26 140,18 160,22 180,14 200,18 220,10 240,8 240,48 0,48" fill="var(--accent)" opacity="0.12"/>
                            </svg>
                        </div>
                    </div>

                    <div class="vis-quote">
                        <div class="vis-avatar">PT</div>
                        <div>
                            <p>"Sau 3 tháng, kho HN giảm 31% SKU âm. Đội ops không còn đối chiếu excel cuối tuần nữa."</p>
                            <div class="who"><b>Phạm Tùng</b> · Giám đốc vận hành, An Phú Foods</div>
                        </div>
                    </div>
                </div>
            </aside>

            <main class="form-side">
                <div class="form-top">
                    <a href="homepage.html" class="back">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Trang chủ
                    </a>
                    <button class="theme-toggle" id="themeToggle" title="Đổi theme">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                    </button>
                </div>

                <div class="form-wrap">
                    <form class="form" action="authen?action=login" method="POST">
                        <div class="form-head">
                            <h1>Đăng nhập</h1>
                            <p>Chưa có tài khoản? <a href="signup.html">Tạo tài khoản miễn phí</a></p>
                        </div>

                        <div class="social">
                            <button type="button" class="btn-social">
                                <svg viewBox="0 0 48 48"><path fill="#FFC107" d="M43.611 20.083H42V20H24v8h11.303c-1.649 4.657-6.08 8-11.303 8c-6.627 0-12-5.373-12-12s5.373-12 12-12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C12.955 4 4 12.955 4 24s8.955 20 20 20s20-8.955 20-20c0-1.341-.138-2.65-.389-3.917z"/><path fill="#FF3D00" d="m6.306 14.691l6.571 4.819C14.655 15.108 18.961 12 24 12c3.059 0 5.842 1.154 7.961 3.039l5.657-5.657C34.046 6.053 29.268 4 24 4C16.318 4 9.656 8.337 6.306 14.691z"/><path fill="#4CAF50" d="M24 44c5.166 0 9.86-1.977 13.409-5.192l-6.19-5.238A11.91 11.91 0 0 1 24 36c-5.202 0-9.619-3.317-11.283-7.946l-6.522 5.025C9.505 39.556 16.227 44 24 44z"/><path fill="#1976D2" d="M43.611 20.083H42V20H24v8h11.303a12.04 12.04 0 0 1-4.087 5.571l.003-.002l6.19 5.238C36.971 39.205 44 34 44 24c0-1.341-.138-2.65-.389-3.917z"/></svg>
                                Tiếp tục với Google
                            </button>
                        </div>

                        <div class="divider">hoặc</div>

                        <div class="field">
                            <label for="email">Email</label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg></span>
                                <input id="email" type="email" placeholder="ban@congty.vn" autocomplete="email" required>
                            </div>
                        </div>

                        <div class="field">
                            <label for="password">
                                Mật khẩu
                                <span class="hint"><a href="forgot-password.html">Quên mật khẩu?</a></span>
                            </label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></span>
                                <input id="password" type="password" placeholder="••••••••••" autocomplete="current-password" required>
                                <button type="button" class="toggle-pw" onclick="togglePw(this)" aria-label="Hiện mật khẩu">
                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                </button>
                            </div>
                        </div>

                        <div class="row">
                            <label class="checkbox">
                                <input type="checkbox"> Ghi nhớ đăng nhập 30 ngày
                            </label>
                        </div>

                        <button type="submit" class="btn-primary">Đăng nhập</button>

                        <div class="form-bottom">
                            <a href="auth-gallery.html">Xem tất cả màn auth</a>
                            <span>
                                <a href="#">Điều khoản</a>
                                <span class="dot-sep">·</span>
                                <a href="#">Bảo mật</a>
                            </span>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
                        function togglePw(btn) {
                            var input = btn.previousElementSibling;
                            input.type = input.type === 'password' ? 'text' : 'password';
                        }
        </script>
    </body>
</html>
