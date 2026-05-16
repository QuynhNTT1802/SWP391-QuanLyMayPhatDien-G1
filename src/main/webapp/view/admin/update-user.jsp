<%-- 
    Document   : update-user
    Created on : May 16, 2026, 8:55:42 PM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Chỉnh sửa người dùng — Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<style>
  main { padding: 20px 24px 100px; min-width: 0; }
  .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 12.5px; font-weight: 600; margin-bottom: 12px; }
  .back-link:hover { color: var(--fg); }
  .back-link svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2; }

  .edit-hero {
    background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius);
    padding: 18px 22px; display: flex; gap: 16px; align-items: center; margin-bottom: 18px;
  }
  .edit-avatar {
    width: 56px; height: 56px; border-radius: 50%; flex-shrink: 0; position: relative;
    display: grid; place-items: center; font-size: 20px; font-weight: 700; color: var(--bg);
    background: oklch(58% 0.16 295);
  }
  .avatar-edit-btn {
    position: absolute; inset-block-end: -2px; inset-inline-end: -2px;
    width: 22px; height: 22px; border-radius: 50%; background: var(--fg); color: var(--bg);
    border: 2px solid var(--surface); cursor: pointer; display: grid; place-items: center;
  }
  .avatar-edit-btn svg { width: 10px; height: 10px; stroke: currentColor; fill: none; stroke-width: 2.5; }
  .edit-hero-body { flex: 1; min-width: 0; }
  .edit-hero-title { font-size: 18px; font-weight: 700; letter-spacing: -0.01em; margin: 0 0 2px; }
  .edit-hero-meta { font-size: 12.5px; color: var(--muted); font-weight: 500; }
  .edit-hero-meta .mono { font-family: var(--font-mono); }
  .edit-hero-meta .sep { color: var(--muted-2); margin: 0 6px; }

  .form-layout { display: grid; grid-template-columns: minmax(0, 1fr) 300px; gap: 24px; align-items: start; }

  .form-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
  .form-section { padding: 22px 24px; border-bottom: 1px solid var(--border); }
  .form-section:last-child { border-bottom: 0; }
  .form-section-head { margin-bottom: 16px; display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
  .form-section-head-left { flex: 1; min-width: 0; }
  .form-section-num { font-family: var(--font-mono); font-size: 11.5px; color: var(--accent); font-weight: 700; letter-spacing: 0.04em; }
  .form-section-title { font-size: 15px; font-weight: 700; margin: 2px 0 4px; letter-spacing: -0.01em; }
  .form-section-desc { font-size: 12.5px; color: var(--muted); font-weight: 500; }

  .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
  .form-grid.single { grid-template-columns: 1fr; }
  .field { display: flex; flex-direction: column; gap: 5px; }
  .field-label { font-size: 12px; color: var(--fg-soft); font-weight: 600; display: flex; align-items: center; gap: 4px; }
  .field-label .req { color: var(--danger); font-weight: 700; }
  .field-label .lock {
    display: inline-flex; align-items: center; gap: 3px; margin-inline-start: auto;
    font-size: 10.5px; color: var(--muted); font-weight: 600; padding: 1px 6px;
    background: var(--surface-2); border-radius: 3px;
  }
  .field-label .lock svg { width: 9px; height: 9px; stroke: currentColor; fill: none; stroke-width: 2; }

  .input, .select {
    width: 100%; border: 1px solid var(--border); background: var(--surface); color: var(--fg);
    border-radius: var(--radius-sm); padding: 9px 12px;
    font-size: 13.5px; font-family: var(--font-ui); font-weight: 500;
    transition: border-color .12s ease, box-shadow .12s ease;
  }
  .input.mono { font-family: var(--font-mono); }
  .input:focus, .select:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
  .input[readonly] { background: var(--surface-2); color: var(--muted); cursor: not-allowed; }
  .input.dirty, .select.dirty { border-color: var(--info); background: color-mix(in srgb, var(--info-soft) 50%, var(--surface)); }
  .input.error, .select.error { border-color: var(--danger); }
  .select { appearance: none; cursor: pointer; padding-inline-end: 36px;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 24 24' fill='none' stroke='%23888' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");
    background-repeat: no-repeat; background-position: right 10px center;
  }
  .field-help { font-size: 11.5px; color: var(--muted); font-weight: 500; }
  .field-help.dirty-hint { color: var(--info); font-weight: 600; }
  .field-error { display: none; font-size: 11.5px; color: var(--danger); font-weight: 600; }
  .field.invalid .field-error { display: block; }
  .field.invalid .field-help { display: none; }

  /* role grid (compact) */
  .role-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
  .role-card {
    border: 1.5px solid var(--border); border-radius: var(--radius); padding: 10px 12px;
    background: var(--surface); cursor: pointer; transition: all .12s ease;
    display: flex; flex-direction: column; gap: 3px; position: relative;
  }
  .role-card:hover { border-color: var(--border-strong); background: var(--surface-2); }
  .role-card.selected { border-color: var(--accent); background: var(--accent-soft); }
  .role-card-name { font-size: 12.5px; font-weight: 700; color: var(--fg); }
  .role-card.selected .role-card-name { color: var(--accent); }
  .role-card-desc { font-size: 11px; color: var(--muted); font-weight: 500; line-height: 1.35; }
  .role-card input { position: absolute; opacity: 0; pointer-events: none; }

  /* pill */
  .pill { display: inline-flex; align-items: center; gap: 5px; font-size: 11.5px; font-weight: 600; padding: 2px 8px; border-radius: 999px; border: 1px solid; }
  .pill .pdot { width: 5px; height: 5px; border-radius: 50%; }
  .pill.status-active { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft); }
  .pill.status-active .pdot { background: var(--accent); }

  /* status segmented */
  .seg { display: flex; gap: 4px; background: var(--surface-2); padding: 3px; border-radius: var(--radius-sm); border: 1px solid var(--border); }
  .seg-opt {
    flex: 1; padding: 7px 10px; border: 0; background: transparent; cursor: pointer;
    border-radius: 3px; font-size: 12.5px; font-weight: 600; color: var(--muted);
    display: inline-flex; align-items: center; justify-content: center; gap: 5px; font-family: var(--font-ui);
  }
  .seg-opt .sdot { width: 6px; height: 6px; border-radius: 50%; background: var(--muted-2); }
  .seg-opt.active { background: var(--surface); color: var(--fg); box-shadow: 0 1px 2px oklch(0% 0 0 / 0.05); }
  .seg-opt.active[data-val="active"] .sdot { background: var(--accent); }
  .seg-opt.active[data-val="locked"] { color: var(--danger); }
  .seg-opt.active[data-val="locked"] .sdot { background: var(--danger); }
  .seg-opt.active[data-val="disabled"] { color: var(--muted); }
  .seg-opt.active[data-val="disabled"] .sdot { background: var(--muted-2); }

  /* danger zone */
  .danger-zone { border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent); border-radius: var(--radius); padding: 18px 20px; background: var(--danger-soft); }
  .danger-row { display: flex; justify-content: space-between; align-items: center; gap: 16px; padding: 10px 0; border-bottom: 1px dashed color-mix(in srgb, var(--danger) 25%, transparent); }
  .danger-row:last-child { border-bottom: 0; padding-bottom: 0; }
  .danger-row:first-child { padding-top: 0; }
  .danger-text .t { font-size: 13px; font-weight: 700; }
  .danger-text .d { font-size: 11.5px; color: var(--fg-soft); font-weight: 500; margin-top: 2px; }

  /* sidebar diff */
  .summary-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 18px 20px; position: sticky; top: 76px; }
  .summary-title { font-size: 13px; font-weight: 700; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
  .summary-title .badge { font-family: var(--font-mono); font-size: 10.5px; padding: 1px 6px; border-radius: 3px; background: var(--surface-2); color: var(--muted); font-weight: 600; border: 1px solid var(--border); }
  .summary-title .badge.has-changes { background: var(--info-soft); color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); }
  .changes-list { display: flex; flex-direction: column; gap: 10px; }
  .change-item { font-size: 12px; line-height: 1.4; padding: 9px 11px; border-radius: var(--radius-sm); background: var(--surface-2); border: 1px solid var(--border); }
  .change-item .field { font-size: 11px; color: var(--muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.02em; margin-bottom: 4px; display: block; }
  .change-item .from { color: var(--muted); text-decoration: line-through; font-weight: 500; font-family: var(--font-mono); }
  .change-item .arrow { color: var(--info); margin: 0 6px; font-weight: 700; }
  .change-item .to { color: var(--info); font-weight: 700; font-family: var(--font-mono); }
  .changes-empty { font-size: 12px; color: var(--muted); font-weight: 500; padding: 16px 8px; text-align: center; }

  /* save bar */
  .save-bar {
    position: fixed; bottom: 16px; inset-inline-start: 256px; inset-inline-end: 24px;
    z-index: 30; background: var(--fg); color: var(--bg);
    border-radius: var(--radius); padding: 12px 16px 12px 18px;
    box-shadow: 0 8px 28px oklch(0% 0 0 / 0.18);
    display: flex; align-items: center; gap: 14px;
    transform: translateY(120%); opacity: 0; transition: all .25s ease;
  }
  body.has-changes .save-bar { transform: translateY(0); opacity: 1; }
  .save-bar .info { flex: 1; line-height: 1.3; font-size: 13px; font-weight: 700; }
  .save-bar .info .sub { font-size: 11.5px; opacity: 0.7; font-weight: 500; margin-top: 1px; }
  .save-bar .dirty-pill { display: inline-flex; align-items: center; gap: 5px; background: oklch(100% 0 0 / 0.15); padding: 1px 8px; border-radius: 999px; font-family: var(--font-mono); font-size: 11px; margin-inline-start: 8px; }
  .save-bar .dirty-pill::before { content:''; width: 5px; height: 5px; border-radius: 50%; background: var(--info); }
  .save-bar .btn { background: transparent; color: var(--bg); border-color: oklch(100% 0 0 / 0.25); }
  .save-bar .btn:hover { background: oklch(100% 0 0 / 0.1); }
  .save-bar .btn-primary { background: var(--accent); color: var(--bg); border-color: var(--accent); }
  .save-bar .btn-primary:hover { background: color-mix(in srgb, var(--accent) 88%, white); }

  .toast-host { position: fixed; bottom: 80px; inset-inline-end: 24px; z-index: 60; display: flex; flex-direction: column; gap: 8px; }
  .toast { background: var(--fg); color: var(--bg); padding: 10px 14px; border-radius: var(--radius); font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 10px; transform: translateY(8px); opacity: 0; transition: all .2s ease; }
  .toast.show { transform: translateY(0); opacity: 1; }
  .toast.success { background: var(--accent); color: var(--bg); }
  .toast.danger { background: var(--danger); color: var(--bg); }
  .toast svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2.2; }

  .modal-host { position: fixed; inset: 0; background: oklch(0% 0 0 / 0.4); z-index: 50; display: none; align-items: center; justify-content: center; padding: 20px; }
  .modal-host.open { display: flex; }
  .modal { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); width: 100%; max-width: 420px; padding: 22px; }
  .modal h3 { font-size: 16px; font-weight: 700; margin: 0 0 6px; }
  .modal p { font-size: 13px; color: var(--muted); margin: 0 0 16px; line-height: 1.5; font-weight: 500; }
  .modal .actions { display: flex; gap: 8px; justify-content: flex-end; }

  @media (max-width: 1100px) {
    .form-layout { grid-template-columns: 1fr; }
    .summary-card { position: static; }
  }
  @media (max-width: 760px) {
    .app { grid-template-columns: 1fr; }
    aside.sidebar { display: none; }
    main { padding: 16px 16px 100px; }
    .form-grid { grid-template-columns: 1fr; }
    .role-grid { grid-template-columns: 1fr; }
    .save-bar { inset-inline-start: 12px; inset-inline-end: 12px; }
  }
</style>
</head>
<body>
<div class="app">
  <aside class="sidebar">
    <div class="brand">
      <div class="brand-mark">WH</div>
      <div>Warehouse OS</div>
    </div>
    <nav class="nav">
      <div class="nav-section">Tổng quan</div>
      <a href="index.html">
        <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
        Dashboard
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
        Tồn kho
        <span class="count">12.4k</span>
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M3 12h18M3 18h12"/></svg>
        Phiếu nhập/xuất
        <span class="count">23</span>
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
        Đơn hàng
      </a>

      <div class="nav-section">Quản trị</div>
      <a href="admin-users.html">
        <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
        Người dùng
        <span class="count">142</span>
      </a>
      <a href="rbac-roles.html">
        <svg class="icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
        Phân quyền
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
        Nhà cung cấp
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M20 7l-8 4-8-4M4 7l8 4 8-4M4 7v10l8 4 8-4V7"/></svg>
        Kho &amp; vị trí
      </a>

      <div class="nav-section">Tài khoản</div>
      <a href="profile.html">
        <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        Hồ sơ của tôi
      </a>
      <a href="change-password.html">
        <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        Đổi mật khẩu
      </a>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09a1.65 1.65 0 0 0-1-1.51 1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09a1.65 1.65 0 0 0 1.51-1 1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33h0a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82v0a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
        Cài đặt
      </a>

      <div class="nav-section">Báo cáo</div>
      <a href="#">
        <svg class="icon" viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 14l4-4 4 4 5-5"/></svg>
        Phân tích
      </a>
    </nav>
    <div class="sidebar-footer">
      <div class="avatar">MH</div>
      <div class="user-meta">
        <div class="name">Mai Hoàng</div>
        <div class="role">Super Admin</div>
      </div>
    </div>
  </aside>

  <div>
    <header class="topbar">
      <h1>Chỉnh sửa người dùng</h1>
      <span class="crumb">/ <a href="admin-users.html">Người dùng</a> / <a href="admin-user-detail.html?id=USR-04822">Phạm Tùng</a> / Chỉnh sửa</span>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
      </div>
    </header>

    <main>
      <a class="back-link" href="admin-user-detail.html?id=USR-04822">
        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Quay lại hồ sơ
      </a>

      <div class="edit-hero">
        <div class="edit-avatar">
          PT
          <button class="avatar-edit-btn" title="Đổi ảnh"><svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg></button>
        </div>
        <div class="edit-hero-body">
          <h2 class="edit-hero-title">Phạm Tùng</h2>
          <div class="edit-hero-meta">
            <span class="mono">USR-04822</span>
            <span class="sep">·</span>
            <span>Quản lý kho HN-01</span>
            <span class="sep">·</span>
            <span>Tham gia 04/09/2023</span>
            <span class="sep">·</span>
            <span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span>
          </div>
        </div>
      </div>

      <div class="form-layout">
        <form class="form-card" id="editForm" autocomplete="off">
          <div class="form-section">
            <div class="form-section-head">
              <div class="form-section-head-left">
                <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                <h3 class="form-section-title">Họ tên &amp; liên hệ</h3>
                <div class="form-section-desc">Email không thể đổi sau khi tạo tài khoản — đó là khoá đăng nhập của user.</div>
              </div>
            </div>
            <div class="form-grid">
              <div class="field">
                <label class="field-label">Họ và tên <span class="req">*</span></label>
                <input class="input" name="fullName" data-orig="Phạm Tùng" value="Phạm Tùng" />
                <div class="field-help">Tối đa 60 ký tự</div>
                <div class="field-error">Họ tên phải có ít nhất 2 ký tự</div>
              </div>
              <div class="field">
                <label class="field-label">
                  Email đăng nhập
                  <span class="lock"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>Khoá</span>
                </label>
                <input class="input mono" name="email" value="tung.pham@warehouseos.vn" readonly />
                <div class="field-help">Email là khoá đăng nhập, không thể đổi. Cần đổi? Tạo tài khoản mới và chuyển dữ liệu.</div>
              </div>
              <div class="field">
                <label class="field-label">Số điện thoại</label>
                <input class="input mono" name="phone" data-orig="+84 903 211 988" value="+84 903 211 988" />
                <div class="field-help">Dùng cho 2FA SMS và thông báo khẩn</div>
                <div class="field-error">Số điện thoại không hợp lệ</div>
              </div>
              <div class="field">
                <label class="field-label">Chức danh</label>
                <input class="input" name="title" data-orig="Quản lý kho HN-01" value="Quản lý kho HN-01" />
                <div class="field-help">Hiển thị trong hồ sơ và phiếu nhập/xuất</div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-head">
              <div class="form-section-head-left">
                <div class="form-section-num">02 — VAI TRÒ &amp; KHO</div>
                <h3 class="form-section-title">Phân quyền hệ thống</h3>
                <div class="form-section-desc">Đổi vai trò sẽ áp dụng bộ quyền mới. Thay đổi này được ghi vào audit log.</div>
              </div>
            </div>
            <div class="form-grid single">
              <div class="field">
                <label class="field-label">Vai trò <span class="req">*</span></label>
                <div class="role-grid">
                  <label class="role-card" data-role="admin"><input type="radio" name="role" value="admin"/><div class="role-card-name">Admin</div><div class="role-card-desc">Toàn quyền quản trị</div></label>
                  <label class="role-card selected" data-role="manager"><input type="radio" name="role" value="manager" checked/><div class="role-card-name">Quản lý kho</div><div class="role-card-desc">Duyệt phiếu, quản lý nhân sự</div></label>
                  <label class="role-card" data-role="keeper"><input type="radio" name="role" value="keeper"/><div class="role-card-name">Thủ kho</div><div class="role-card-desc">Tạo &amp; thực hiện phiếu</div></label>
                  <label class="role-card" data-role="account"><input type="radio" name="role" value="account"/><div class="role-card-name">Kế toán</div><div class="role-card-desc">Xem báo cáo &amp; đối soát</div></label>
                  <label class="role-card" data-role="staff"><input type="radio" name="role" value="staff"/><div class="role-card-name">Nhân viên</div><div class="role-card-desc">Soạn phiếu</div></label>
                  <label class="role-card" data-role="viewer"><input type="radio" name="role" value="viewer"/><div class="role-card-name">Viewer</div><div class="role-card-desc">Chỉ xem</div></label>
                </div>
              </div>
              <div class="field">
                <label class="field-label">Kho phụ trách <span class="req">*</span></label>
                <select class="select" name="warehouse" data-orig="HN-01">
                  <option value="HN-01" selected>HN-01 · Hà Nội (Cầu Giấy)</option>
                  <option value="HCM-03">HCM-03 · TP.HCM (Tân Bình)</option>
                  <option value="DN-02">DN-02 · Đà Nẵng (Thanh Khê)</option>
                  <option value="ALL">Toàn hệ thống (chỉ Admin)</option>
                </select>
                <div class="field-help">Người dùng chỉ thao tác trên kho được gán</div>
              </div>
              <div class="field">
                <label class="field-label">Trạng thái tài khoản</label>
                <div class="seg" data-name="status" data-orig="active">
                  <button type="button" class="seg-opt active" data-val="active"><span class="sdot"></span>Hoạt động</button>
                  <button type="button" class="seg-opt" data-val="locked"><span class="sdot"></span>Khoá</button>
                  <button type="button" class="seg-opt" data-val="disabled"><span class="sdot"></span>Vô hiệu</button>
                </div>
                <div class="field-help">"Khoá" tạm thời không thể đăng nhập · "Vô hiệu" xoá khỏi hệ thống nhưng giữ lịch sử</div>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-head">
              <div class="form-section-head-left">
                <div class="form-section-num">03 — VÙNG NGUY HIỂM</div>
                <h3 class="form-section-title">Hành động không thể hoàn tác</h3>
                <div class="form-section-desc">Các thao tác bên dưới cần xác nhận và sẽ ghi audit log toàn cục.</div>
              </div>
            </div>
            <div class="danger-zone">
              <div class="danger-row">
                <div class="danger-text">
                  <div class="t">Reset mật khẩu</div>
                  <div class="d">Gửi email link đặt lại mật khẩu tới tung.pham@warehouseos.vn. Link hết hạn sau 24 giờ.</div>
                </div>
                <button type="button" class="btn" data-danger="reset-pw">
                  <svg class="icon" viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.81 1 6.5 2.62L21 8M21 3v5h-5"/></svg>
                  Gửi reset
                </button>
              </div>
              <div class="danger-row">
                <div class="danger-text">
                  <div class="t">Đăng xuất khỏi mọi thiết bị</div>
                  <div class="d">Vô hiệu hoá toàn bộ 3 phiên đang hoạt động (MacBook, iPhone, Dell). Người dùng phải đăng nhập lại.</div>
                </div>
                <button type="button" class="btn" data-danger="logout-all">
                  <svg class="icon" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg>
                  Đăng xuất
                </button>
              </div>
              <div class="danger-row">
                <div class="danger-text">
                  <div class="t">Xoá tài khoản</div>
                  <div class="d">Soft delete · Có thể khôi phục trong 30 ngày. Phiếu đã tạo bởi user sẽ giữ nguyên audit trail.</div>
                </div>
                <button type="button" class="btn btn-danger" data-danger="delete">
                  <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                  Xoá tài khoản
                </button>
              </div>
            </div>
          </div>
        </form>

        <aside>
          <div class="summary-card">
            <div class="summary-title">
              Thay đổi pending
              <span class="badge" id="changeBadge">0</span>
            </div>
            <div class="changes-list" id="changesList">
              <div class="changes-empty">Chưa có thay đổi nào.<br>Sửa thông tin để xem diff.</div>
            </div>
          </div>
        </aside>
      </div>
    </main>
  </div>
</div>

<div class="save-bar">
  <div class="info">
    <div>Có thay đổi chưa lưu <span class="dirty-pill" id="dirtyPill">0 trường</span></div>
    <div class="sub">⌘S để lưu · Esc để huỷ</div>
  </div>
  <button class="btn" id="cancelBtn">Huỷ</button>
  <button class="btn btn-primary" id="saveBtn">
    <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><path d="M17 21v-8H7v8M7 3v5h8"/></svg>
    Lưu thay đổi
  </button>
</div>

<div class="toast-host" id="toastHost"></div>

<div class="modal-host" id="confirmModal">
  <div class="modal">
    <h3 id="modalTitle">Xác nhận hành động</h3>
    <p id="modalText">Bạn có chắc muốn thực hiện hành động này?</p>
    <div class="actions">
      <button class="btn" id="modalCancel">Huỷ</button>
      <button class="btn btn-danger" id="modalConfirm">Xác nhận</button>
    </div>
  </div>
</div>

<script src="assets/js/theme.js"></script>
<script src="assets/js/sidebar.js"></script>
<script>
  const ROLE_LABEL = { admin: 'Admin', manager: 'Quản lý kho', keeper: 'Thủ kho', account: 'Kế toán', staff: 'Nhân viên', viewer: 'Viewer' };
  const STATUS_LABEL = { active: 'Hoạt động', locked: 'Bị khoá', disabled: 'Vô hiệu' };
  const WH_LABEL = { 'HN-01': 'HN-01 Hà Nội', 'HCM-03': 'HCM-03 TP.HCM', 'DN-02': 'DN-02 Đà Nẵng', 'ALL': 'Toàn hệ thống' };
  const FIELD_LABEL = {
    fullName: 'Họ và tên', phone: 'Số điện thoại', title: 'Chức danh',
    role: 'Vai trò', warehouse: 'Kho phụ trách', status: 'Trạng thái'
  };

  const form = document.getElementById('editForm');
  const original = { fullName: 'Phạm Tùng', phone: '+84 903 211 988', title: 'Quản lý kho HN-01', role: 'manager', warehouse: 'HN-01', status: 'active' };
  const current = { ...original };

  // role cards
  document.querySelectorAll('.role-card').forEach(card => {
    card.addEventListener('click', () => {
      document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
      card.classList.add('selected');
      card.querySelector('input').checked = true;
      current.role = card.dataset.role;
      diffField('role');
      updateUI();
    });
  });

  // status segmented
  const statusSeg = document.querySelector('.seg[data-name="status"]');
  statusSeg.addEventListener('click', e => {
    const btn = e.target.closest('.seg-opt');
    if (!btn) return;
    statusSeg.querySelectorAll('.seg-opt').forEach(o => o.classList.remove('active'));
    btn.classList.add('active');
    current.status = btn.dataset.val;
    diffField('status');
    updateUI();
  });

  // input watchers
  ['fullName', 'phone', 'title'].forEach(name => {
    const el = form.elements[name];
    el.addEventListener('input', () => { current[name] = el.value; diffField(name); updateUI(); });
  });
  form.elements.warehouse.addEventListener('change', e => { current.warehouse = e.target.value; diffField('warehouse'); updateUI(); });

  function diffField(name) {
    const isDirty = String(current[name]).trim() !== String(original[name]).trim();
    const inputName = (name === 'status') ? null : name;
    if (inputName) {
      const el = form.elements[inputName];
      if (el) el.classList.toggle('dirty', isDirty);
    }
  }

  function getDirtyFields() {
    return Object.keys(original).filter(k => String(current[k]).trim() !== String(original[k]).trim());
  }
  function isValid() {
    const name = current.fullName.trim();
    const phone = current.phone.trim();
    const phoneOk = !phone || /^(\+84|0)\s?[3-9]\d{1}[\s\d]{6,12}$/.test(phone);
    document.querySelector('[name="fullName"]').classList.toggle('error', name.length > 0 && name.length < 2);
    document.querySelector('[name="fullName"]').closest('.field').classList.toggle('invalid', name.length > 0 && name.length < 2);
    document.querySelector('[name="phone"]').classList.toggle('error', !phoneOk);
    document.querySelector('[name="phone"]').closest('.field').classList.toggle('invalid', !phoneOk);
    return name.length >= 2 && phoneOk;
  }

  function updateUI() {
    const dirty = getDirtyFields();
    document.body.classList.toggle('has-changes', dirty.length > 0);
    document.getElementById('dirtyPill').textContent = dirty.length + ' trường';
    const badge = document.getElementById('changeBadge');
    badge.textContent = dirty.length;
    badge.classList.toggle('has-changes', dirty.length > 0);

    const list = document.getElementById('changesList');
    if (dirty.length === 0) {
      list.innerHTML = '<div class="changes-empty">Chưa có thay đổi nào.<br>Sửa thông tin để xem diff.</div>';
    } else {
      list.innerHTML = dirty.map(k => {
        const from = formatValue(k, original[k]);
        const to = formatValue(k, current[k]);
        return `<div class="change-item"><span class="field">${FIELD_LABEL[k]}</span><span class="from">${from}</span><span class="arrow">→</span><span class="to">${to}</span></div>`;
      }).join('');
    }
  }
  function formatValue(field, value) {
    if (field === 'role') return ROLE_LABEL[value] || value;
    if (field === 'status') return STATUS_LABEL[value] || value;
    if (field === 'warehouse') return WH_LABEL[value] || value;
    return value || '—';
  }

  // save / cancel
  document.getElementById('saveBtn').addEventListener('click', save);
  document.getElementById('cancelBtn').addEventListener('click', cancel);

  function save() {
    if (!isValid()) { toast('Vui lòng kiểm tra các trường được tô đỏ', 'danger'); return; }
    const dirty = getDirtyFields();
    if (dirty.length === 0) { toast('Không có thay đổi nào để lưu', 'default'); return; }

    const btn = document.getElementById('saveBtn');
    btn.disabled = true;
    setTimeout(() => {
      Object.assign(original, current);
      // reset dirty visuals
      ['fullName', 'phone', 'title'].forEach(n => form.elements[n].classList.remove('dirty'));
      updateUI();
      toast(`Đã lưu ${dirty.length} thay đổi cho Phạm Tùng`, 'success');
      btn.disabled = false;
    }, 500);
  }
  function cancel() {
    const dirty = getDirtyFields();
    if (dirty.length === 0) { location.href = 'admin-user-detail.html?id=USR-04822'; return; }
    confirmAction('Huỷ thay đổi?', `Bạn có ${dirty.length} thay đổi chưa lưu. Tất cả sẽ bị mất nếu rời khỏi.`, () => {
      Object.assign(current, original);
      form.elements.fullName.value = original.fullName;
      form.elements.phone.value = original.phone;
      form.elements.title.value = original.title;
      form.elements.warehouse.value = original.warehouse;
      document.querySelectorAll('.role-card').forEach(c => c.classList.toggle('selected', c.dataset.role === original.role));
      form.querySelector(`input[value="${original.role}"]`).checked = true;
      statusSeg.querySelectorAll('.seg-opt').forEach(o => o.classList.toggle('active', o.dataset.val === original.status));
      ['fullName', 'phone', 'title'].forEach(n => form.elements[n].classList.remove('dirty'));
      updateUI();
      toast('Đã huỷ thay đổi', 'default');
    });
  }

  // keyboard
  document.addEventListener('keydown', e => {
    if ((e.metaKey || e.ctrlKey) && e.key === 's') { e.preventDefault(); save(); }
    else if (e.key === 'Escape') { cancel(); }
  });
  window.addEventListener('beforeunload', e => {
    if (getDirtyFields().length > 0) { e.preventDefault(); e.returnValue = ''; }
  });

  // danger actions
  document.querySelectorAll('[data-danger]').forEach(btn => {
    btn.addEventListener('click', () => {
      const action = btn.dataset.danger;
      if (action === 'reset-pw') confirmAction('Gửi reset mật khẩu?', 'Email sẽ gửi tới tung.pham@warehouseos.vn với link đặt lại trong 24 giờ.', () => toast('Đã gửi email reset mật khẩu', 'success'));
      else if (action === 'logout-all') confirmAction('Đăng xuất mọi thiết bị?', 'Vô hiệu 3 phiên đang hoạt động (MacBook, iPhone, Dell). User phải đăng nhập lại.', () => toast('Đã đăng xuất 3 thiết bị', 'success'));
      else if (action === 'delete') confirmAction('Xoá tài khoản Phạm Tùng?', 'Soft delete · có thể khôi phục trong 30 ngày. Hành động này được ghi audit log.', () => { toast('Đã xoá Phạm Tùng', 'success'); setTimeout(() => location.href = 'admin-users.html', 1200); });
    });
  });

  // modal
  let confirmCb = null;
  function confirmAction(title, text, cb) {
    document.getElementById('modalTitle').textContent = title;
    document.getElementById('modalText').textContent = text;
    confirmCb = cb;
    document.getElementById('confirmModal').classList.add('open');
  }
  document.getElementById('modalCancel').addEventListener('click', () => { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; });
  document.getElementById('modalConfirm').addEventListener('click', () => { if (confirmCb) confirmCb(); document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; });
  document.getElementById('confirmModal').addEventListener('click', e => { if (e.target.id === 'confirmModal') { document.getElementById('confirmModal').classList.remove('open'); confirmCb = null; } });

  function toast(msg, type = 'default') {
    const host = document.getElementById('toastHost');
    const t = document.createElement('div');
    t.className = 'toast ' + type;
    const icon = type === 'success' ? '<svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>' : type === 'danger' ? '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>' : '<svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>';
    t.innerHTML = icon + '<span>' + msg + '</span>';
    host.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => { t.classList.remove('show'); setTimeout(() => t.remove(), 200); }, 2800);
  }

  updateUI();
</script>
</body>
</html>

