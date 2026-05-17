<%-- 
    Document   : forgotpass
    Created on : May 15, 2026, 11:16:34 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <style>
            .steps {
                margin-top: 36px;
                display: flex;
                flex-direction: column;
                gap: 0;
            }
            .step {
                display: flex;
                gap: 16px;
                padding: 14px 0;
                position: relative;
            }
            .step:not(:last-child)::after {
                content: '';
                position: absolute;
                inset-inline-start: 13px;
                inset-block-start: 42px;
                width: 1px;
                height: calc(100% - 30px);
                background: var(--border);
            }
            .step-num {
                width: 26px;
                height: 26px;
                border-radius: 50%;
                border: 1px solid var(--border-strong);
                background: var(--surface);
                display: grid;
                place-items: center;
                font-family: var(--font-mono);
                font-size: 11px;
                font-weight: 600;
                color: var(--fg-soft);
                flex-shrink: 0;
            }
            .step.active .step-num {
                background: var(--fg);
                color: var(--bg);
                border-color: var(--fg);
            }
            .step.done .step-num {
                background: var(--accent-soft);
                color: var(--accent);
                border-color: transparent;
            }
            .step.done .step-num svg {
                width: 13px;
                height: 13px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2.5;
            }
            .step-body {
                padding-top: 3px;
            }
            .step-title {
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 2px;
            }
            .step-sub {
                font-size: 12.5px;
                color: var(--muted);
                line-height: 1.45;
            }

            .icon-badge {
                width: 44px;
                height: 44px;
                border-radius: 10px;
                background: var(--accent-soft);
                color: var(--accent);
                display: grid;
                place-items: center;
                margin-bottom: 18px;
            }
            .icon-badge svg {
                width: 20px;
                height: 20px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
        </style>
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
                    <p class="vis-sub">Chúng tôi sẽ gửi một liên kết khôi phục đến email của bạn. Liên kết hết hạn sau 15 phút.</p>

                    <div class="steps">
                        <div class="step active">
                            <div class="step-num">1</div>
                            <div class="step-body">
                                <div class="step-title">Nhập email</div>
                                <div class="step-sub">Email bạn đã dùng để tạo tài khoản.</div>
                            </div>
                        </div>
                        <div class="step">
                            <div class="step-num">2</div>
                            <div class="step-body">
                                <div class="step-title">Mở email và bấm vào liên kết</div>
                                <div class="step-sub">Nếu không thấy, kiểm tra thư mục Spam / Quảng cáo.</div>
                            </div>
                        </div>
                        <div class="step">
                            <div class="step-num">3</div>
                            <div class="step-body">
                                <div class="step-title">Đặt mật khẩu mới</div>
                                <div class="step-sub">Tối thiểu 8 ký tự, có chữ và số.</div>
                            </div>
                        </div>
                    </div>
                </div>
            </aside>

            <main class="form-side">
                <div class="form-top">
                    <a href="login.html" class="back">
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
                            <p>Nhập email tài khoản — chúng tôi sẽ gửi liên kết khôi phục trong vòng 1 phút.</p>
                        </div>

                        <div class="field">
                            <label for="email">Email tài khoản</label>
                            <div class="input has-icon">
                                <span class="leading"><svg viewBox="0 0 24 24"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg></span>

                                <input name="username" id="email" type="email" placeholder="ban@congty.vn" autocomplete="email" required>
                            </div>

                        </div>
                        <button type="submit" class="btn-primary">Gửi liên kết khôi phục</button>   

                        <div class="form-foot">
                            Nhớ mật khẩu rồi? <a href="authen?action=">Đăng nhập</a>
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
