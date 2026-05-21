<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.quanlymayphatdien.g1.entity.User"%>
<%@page import="com.quanlymayphatdien.g1.entity.Role"%>
<%@page import="java.util.List"%>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/authen?action=login");
        return;
    }
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");

    String fullName = user.getName() != null ? user.getName() : "";
    String username = user.getUsername() != null ? user.getUsername() : "";
    String email = user.getEmail() != null ? user.getEmail() : "";
    String phone = user.getPhone() != null ? user.getPhone() : "";
    String address = user.getAddress() != null ? user.getAddress() : "";
    String status = user.getStatus() != null ? user.getStatus() : "active";

    List<Role> roles = user.getRoles();
    if (roles == null) roles = List.of();

    String initials = "";
    String[] nameParts = fullName.trim().split("\\s+");
    if (nameParts.length == 1) {
        initials = nameParts[0].length() >= 2 ? nameParts[0].substring(0, 2).toUpperCase() : nameParts[0].toUpperCase();
    } else {
        initials = (nameParts[0].charAt(0) + nameParts[nameParts.length - 1].charAt(0) + "").toUpperCase();
    }

    String userIdDisplay = "USR-" + String.format("%05d", user.getId());
%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Hồ sơ của tôi — Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,500;1,600&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/variables.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/base.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/sidebar.css">
<style>

  h1, h2, h3, h4 { font-weight: 700; letter-spacing: -0.01em; }
  label, .label { font-weight: 600; }
  input, select, textarea, button { font-weight: 500; }
  .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }

  .app { display: grid; grid-template-columns: 240px 1fr; min-height: 100vh; }

  /* Sidebar */
  aside.sidebar {
    background: var(--surface);
    border-right: 1px solid var(--border);
    position: sticky; top: 0; height: 100vh;
    display: flex; flex-direction: column;
    padding: 20px 12px 16px;
  }
  .brand { display: flex; align-items: center; gap: 10px; padding: 4px 10px 18px; font-weight: 700; font-size: 14px; letter-spacing: -0.01em; }
  .brand-mark { width: 22px; height: 22px; border-radius: 5px; background: var(--fg); color: var(--bg); display: grid; place-items: center; font-family: var(--font-mono); font-size: 11px; font-weight: 700; }
  nav.nav { display: flex; flex-direction: column; gap: 1px; flex: 1; }
  .nav-section { font-size: 10.5px; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); padding: 14px 10px 6px; font-weight: 500; }
  .nav a { display: flex; align-items: center; gap: 10px; padding: 7px 10px; border-radius: var(--radius-sm); color: var(--fg-soft); text-decoration: none; font-size: 13px; font-weight: 600; }
  .nav a:hover { background: var(--surface-2); color: var(--fg); }
  .nav a.active { background: var(--accent-soft); color: var(--accent); font-weight: 700; }
  .nav a .icon { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.6; flex-shrink: 0; }
  .nav a .count { margin-inline-start: auto; font-family: var(--font-mono); font-size: 11px; color: var(--muted); background: var(--surface-2); padding: 1px 6px; border-radius: 999px; border: 1px solid var(--border); }
  .nav a.active .count { color: var(--accent); background: transparent; border-color: transparent; }
  .sidebar-footer { border-top: 1px solid var(--border); padding: 12px 10px 4px; margin-top: 8px; display: flex; align-items: center; gap: 10px; }
  .avatar-sm { width: 28px; height: 28px; border-radius: 50%; background: var(--surface-2); border: 1px solid var(--border); display: grid; place-items: center; font-size: 11px; font-weight: 600; color: var(--fg-soft); overflow: hidden; }
  .avatar-sm img { width: 100%; height: 100%; object-fit: cover; }
  .user-meta { line-height: 1.2; flex: 1; min-width: 0; }
  .user-meta .name { font-size: 12.5px; font-weight: 700; }
  .user-meta .role { font-size: 11px; color: var(--muted); }

  /* Topbar */
  header.topbar {
    position: sticky; top: 0; z-index: 10;
    background: color-mix(in srgb, var(--bg) 85%, transparent);
    backdrop-filter: blur(8px);
    border-bottom: 1px solid var(--border);
    display: flex; align-items: center; gap: 16px;
    padding: 12px 24px;
  }
  .topbar h1 { font-size: 16px; font-weight: 700; margin: 0; letter-spacing: -0.01em; }
  .crumb { color: var(--muted); font-size: 13px; font-weight: 500; }
  .top-actions { margin-inline-start: auto; display: flex; align-items: center; gap: 8px; }
  .btn { display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--border); background: var(--surface); color: var(--fg); padding: 7px 14px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; cursor: pointer; font-family: var(--font-ui); }
  .btn:hover { background: var(--surface-2); }
  .btn:disabled { opacity: 0.4; cursor: not-allowed; }
  .btn-primary { background: var(--fg); color: var(--bg); border-color: var(--fg); }
  .btn-primary:hover:not(:disabled) { background: var(--fg-soft); border-color: var(--fg-soft); }
  .btn-danger { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); }
  .btn-danger:hover { background: var(--danger-soft); }
  .btn .icon { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .icon-btn { width: 32px; height: 32px; border: 1px solid var(--border); background: var(--surface); color: var(--fg-soft); border-radius: var(--radius-sm); display: grid; place-items: center; cursor: pointer; }
  .icon-btn:hover { background: var(--surface-2); color: var(--fg); }
  .icon-btn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.6; }
  .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
  [data-theme="light"] .theme-toggle .icon-moon { display: block; }
  [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

  /* Main */
  main { padding: 24px 32px 120px; }
  .page-head { margin-bottom: 20px; }
  .eyebrow { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); margin-bottom: 8px; }
  .eyebrow::before { content: ''; width: 5px; height: 5px; border-radius: 50%; background: var(--accent); }
  .page-head h1.title { font-size: 26px; font-weight: 700; letter-spacing: -0.02em; margin: 0; }
  .page-head .lede { color: var(--muted); margin-top: 6px; max-width: 640px; font-size: 14px; }
  .page-head em { font-style: italic; font-weight: 600; color: var(--accent); }

  /* Alert messages */
  .alert {
    padding: 12px 16px;
    border-radius: var(--radius-sm);
    margin-bottom: 20px;
    font-size: 13px;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 10px;
  }
  .alert svg { width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
  .alert-success {
    background: var(--accent-soft);
    color: var(--accent);
    border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
  }
  .alert-error {
    background: var(--danger-soft);
    color: var(--danger);
    border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent);
  }

  /* Tabs */
  .tabs-row { display: flex; gap: 4px; border-bottom: 1px solid var(--border); margin-bottom: 28px; }
  .tab-link { background: transparent; border: 0; padding: 10px 14px; font-size: 13px; color: var(--muted); cursor: pointer; font-family: var(--font-ui); font-weight: 600; border-bottom: 2px solid transparent; margin-bottom: -1px; display: inline-flex; align-items: center; gap: 8px; }
  .tab-link:hover { color: var(--fg); }
  .tab-link.active { color: var(--fg); border-bottom-color: var(--fg); }
  .tab-link .pill-mini { font-family: var(--font-mono); font-size: 10.5px; font-weight: 500; padding: 1px 6px; border-radius: 3px; background: var(--accent-soft); color: var(--accent); }

  /* Layout 2 cols */
  .layout { display: grid; grid-template-columns: 220px minmax(0, 1fr); gap: 32px; align-items: start; }
  .toc { position: sticky; top: 76px; }
  .toc-title { font-size: 10.5px; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); margin-bottom: 10px; }
  .toc-list { display: flex; flex-direction: column; gap: 1px; }
  .toc-item { display: flex; align-items: center; gap: 10px; padding: 7px 10px; font-size: 13px; color: var(--fg-soft); text-decoration: none; border-radius: var(--radius-sm); border-inline-start: 2px solid transparent; }
  .toc-item:hover { background: var(--surface-2); color: var(--fg); }
  .toc-item.active { background: var(--surface-2); color: var(--fg); border-inline-start-color: var(--accent); font-weight: 700; }
  .toc-num { font-family: var(--font-mono); font-size: 11px; color: var(--muted); }
  .toc-item.active .toc-num { color: var(--accent); }
  .toc-meta { margin-top: 14px; padding-top: 14px; border-top: 1px dashed var(--border); font-size: 11.5px; color: var(--muted); line-height: 1.6; }
  .toc-meta .row { display: flex; justify-content: space-between; gap: 8px; }
  .toc-meta .row span:last-child { font-family: var(--font-mono); color: var(--fg-soft); }

  /* Content */
  .content { display: flex; flex-direction: column; gap: 24px; }
  .section { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; }
  .section-head { display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; border-bottom: 1px solid var(--border); }
  .section-head-left { display: flex; align-items: baseline; gap: 12px; min-width: 0; }
  .section-head h3 { font-size: 14px; font-weight: 700; margin: 0; letter-spacing: -0.005em; }
  .section-head .sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); }
  .section-body { padding: 22px 20px; }

  /* Section 01 — Hero card */
  .hero { display: grid; grid-template-columns: auto 1fr auto; gap: 24px; align-items: center; }
  .avatar-lg-wrap { position: relative; }
  .avatar-lg {
    width: 88px; height: 88px; border-radius: 50%;
    background: linear-gradient(135deg, oklch(70% 0.14 145), oklch(58% 0.16 145));
    color: white;
    display: grid; place-items: center;
    font-size: 28px; font-weight: 600;
    letter-spacing: -0.02em;
    overflow: hidden;
    box-shadow: 0 2px 8px oklch(58% 0.16 145 / 0.25);
  }
  .avatar-lg img { width: 100%; height: 100%; object-fit: cover; }
  .avatar-edit {
    position: absolute; bottom: 0; inset-inline-end: 0;
    width: 28px; height: 28px; border-radius: 50%;
    background: var(--fg); color: var(--bg);
    border: 2px solid var(--surface);
    display: grid; place-items: center;
    cursor: pointer;
  }
  .avatar-edit:hover { transform: scale(1.05); }
  .avatar-edit svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2; }
  .status-dot { position: absolute; top: 4px; inset-inline-end: 4px; width: 14px; height: 14px; border-radius: 50%; background: var(--accent); border: 2px solid var(--surface); }
  .hero-info .name-row { display: flex; align-items: center; gap: 8px; }
  .hero-info .name { font-size: 22px; font-weight: 700; letter-spacing: -0.015em; }
  .hero-info .verified { color: var(--info); }
  .hero-info .verified svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; }
  .hero-info .role { color: var(--muted); font-size: 13px; margin-top: 4px; }
  .hero-info .role .mono { color: var(--fg-soft); }
  .hero-pills { display: flex; gap: 6px; margin-top: 10px; flex-wrap: wrap; }
  .pill { display: inline-flex; align-items: center; gap: 5px; font-size: 11.5px; font-weight: 500; padding: 2px 8px; border-radius: 999px; border: 1px solid; font-family: var(--font-ui); }
  .pill .pdot { width: 5px; height: 5px; border-radius: 50%; }
  .pill.ok { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft); }
  .pill.ok .pdot { background: var(--accent); }
  .pill.info { color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft); }
  .pill.info .pdot { background: var(--info); }
  .pill.muted { color: var(--muted); border-color: var(--border); background: var(--surface-2); }
  .pill.muted .pdot { background: var(--muted-2); }

  /* Form fields — always editable */
  .field-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px 20px; }
  .field { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
  .field.full { grid-column: 1 / -1; }
  .field-label {
    display: flex; align-items: center; justify-content: space-between;
    font-size: 12px; font-weight: 500; color: var(--fg-soft);
  }
  .field-label .req { color: var(--danger); margin-inline-start: 2px; }
  .field-label .badge {
    font-size: 10px; padding: 1px 6px; border-radius: 3px;
    background: var(--accent-soft); color: var(--accent);
    font-weight: 500; letter-spacing: 0.02em;
    display: inline-flex; align-items: center; gap: 3px;
  }
  .field-label .badge svg { width: 9px; height: 9px; }
  .field-label .badge.lock { background: var(--surface-2); color: var(--muted); }

  .input, .select {
    font-family: var(--font-ui); font-size: 14px;
    color: var(--fg); background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius-sm);
    padding: 9px 12px;
    transition: border-color 0.15s, background 0.15s;
    width: 100%;
    line-height: 1.4;
  }
  .input:hover, .select:hover { border-color: var(--border-strong); }
  .input:focus, .select:focus {
    outline: none;
    border-color: var(--accent);
    box-shadow: 0 0 0 3px var(--accent-soft);
    background: var(--surface);
  }
  .input.readonly, .select.readonly {
    background: var(--surface-2);
    color: var(--fg-soft);
    cursor: not-allowed;
  }
  .input.readonly:hover { border-color: var(--border); }
  .input.dirty:not(:focus) {
    border-color: var(--info);
    background: color-mix(in srgb, var(--info-soft) 60%, var(--surface));
  }
  .input.invalid {
    border-color: var(--danger);
    background: color-mix(in srgb, var(--danger-soft) 50%, var(--surface));
  }
  .input.invalid:focus {
    box-shadow: 0 0 0 3px var(--danger-soft);
  }

  .help { font-size: 11.5px; color: var(--muted); display: flex; align-items: center; gap: 6px; min-height: 16px; }
  .help.error { color: var(--danger); }
  .help.dirty { color: var(--info); font-weight: 500; }
  .help svg { width: 11px; height: 11px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }

  .date-row { display: grid; grid-template-columns: 1fr 1fr 1.2fr; gap: 6px; }
  .select { appearance: none; background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>"); background-repeat: no-repeat; background-position: right 10px center; background-size: 14px; padding-inline-end: 32px; cursor: pointer; }

  /* Save bar */
  .save-bar {
    position: fixed; bottom: 0; inset-inline-start: 240px; inset-inline-end: 0;
    background: var(--surface);
    border-top: 1px solid var(--border-strong);
    box-shadow: var(--shadow-md);
    padding: 12px 32px;
    display: flex; align-items: center; gap: 16px;
    transform: translateY(100%);
    transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 20;
  }
  .save-bar.show { transform: translateY(0); }
  .save-bar-info { display: flex; align-items: center; gap: 10px; flex: 1; min-width: 0; }
  .save-bar-icon {
    width: 28px; height: 28px; border-radius: 50%;
    background: var(--info-soft); color: var(--info);
    display: grid; place-items: center; flex-shrink: 0;
  }
  .save-bar-icon svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2; }
  .save-bar-text .title { font-size: 13px; font-weight: 700; }
  .save-bar-text .sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); }
  .save-bar-actions { display: flex; gap: 8px; }
  .kbd { font-family: var(--font-mono); font-size: 10.5px; padding: 1px 5px; background: var(--surface-2); border: 1px solid var(--border); border-radius: 3px; color: var(--muted); margin-inline-start: 4px; }

  /* Toast */
  .toast {
    position: fixed; top: 76px; inset-inline-end: 24px;
    background: var(--surface); border: 1px solid var(--border);
    border-radius: var(--radius); padding: 12px 16px;
    box-shadow: var(--shadow-md);
    display: flex; align-items: center; gap: 10px;
    font-size: 13px;
    transform: translateX(calc(100% + 32px));
    transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 30;
    min-width: 280px;
  }
  .toast.show { transform: translateX(0); }
  .toast.success { border-color: color-mix(in srgb, var(--accent) 40%, transparent); }
  .toast.error { border-color: color-mix(in srgb, var(--danger) 40%, transparent); }
  .toast-icon { width: 24px; height: 24px; border-radius: 50%; display: grid; place-items: center; flex-shrink: 0; }
  .toast.success .toast-icon { background: var(--accent-soft); color: var(--accent); }
  .toast.error .toast-icon { background: var(--danger-soft); color: var(--danger); }
  .toast-icon svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2.4; }
  .toast-msg { font-weight: 600; }
  .toast-sub { font-size: 11.5px; color: var(--muted); margin-top: 1px; }

  /* Responsive */
  @media (max-width: 1100px) {
    .layout { grid-template-columns: 1fr; }
    .toc { position: static; }
  }
  @media (max-width: 760px) {
    .app { grid-template-columns: 1fr; }
    aside.sidebar { display: none; }
    .save-bar { inset-inline-start: 0; padding-inline: 16px; }
    main { padding: 16px 16px 120px; }
    .hero { grid-template-columns: auto 1fr; }
    .field-grid { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<input type="file" id="avatarFile" accept="image/*" hidden />

<% request.setAttribute("activePage", "profile"); %>
<div class="app">
  <jsp:include page="../common/admin/aside.jsp"/>

  <div>
    <header class="topbar">
      <h1>Hồ sơ của tôi</h1>
      <span class="crumb">/ Tài khoản · <%=userIdDisplay%></span>

      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        
      </div>
    </header>

    <main>

      <% if (successMsg != null) { %>
      <div class="alert alert-success">
        <svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg>
        <%=successMsg%>
      </div>
      <% } %>

      <% if (errorMsg != null) { %>
      <div class="alert alert-error">
        <svg viewBox="0 0 24 24"><path d="M12 8v4M12 16h.01"/><circle cx="12" cy="12" r="10"/></svg>
        <%=errorMsg%>
      </div>
      <% } %>

      <div class="page-head">
        <div class="eyebrow">Tài khoản</div>
        <h1 class="title">Quản lý hồ sơ <em>cá nhân</em></h1>
        <div class="lede">Mọi thay đổi được lưu khi bạn bấm <em>Lưu</em>. Tên đăng nhập bị khoá vì lý do bảo mật.</div>
      </div>

      <div class="tabs-row">
        <button class="tab-link active">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a7 7 0 0 1 14 0v1"/></svg>
          Hồ sơ
        </button>
      </div>

      <div class="layout">
        <aside class="toc">
          <div class="toc-title">Trên trang này</div>
          <div class="toc-list">
            <a href="#sec-overview" class="toc-item active" data-target="sec-overview">
              <span class="toc-num">01</span>
              Tổng quan
            </a>
            <a href="#sec-personal" class="toc-item" data-target="sec-personal">
              <span class="toc-num">02</span>
              Thông tin cá nhân
            </a>
            <a href="#sec-perms" class="toc-item" data-target="sec-perms">
              <span class="toc-num">03</span>
              Quyền hạn &amp; vai trò
            </a>
          </div>
          <div class="toc-meta">
            <div class="row"><span>ID</span><span><%=userIdDisplay%></span></div>
            <div class="row"><span>Tham gia</span><span><%=user.getCreatedAt() != null ? user.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "—"%></span></div>
            <div class="row"><span>Cập nhật</span><span id="lastUpdated"><%=user.getUpdatedAt() != null ? user.getUpdatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "—"%></span></div>
            <div class="row"><span>Trạng thái</span><span><%=status%></span></div>
          </div>
        </aside>

        <div class="content">

          <!-- Section 01: Overview -->
          <section class="section" id="sec-overview">
            <div class="section-head">
              <div class="section-head-left">
                <h3>01 — Tổng quan</h3>
                <span class="sub">Trạng thái &amp; nhận diện</span>
              </div>
            </div>
            <div class="section-body">
              <div class="hero">
                <div class="avatar-lg-wrap">
                  <div class="avatar-lg" id="avatarLg"><%=initials%></div>
                  <div class="status-dot" title="Đang online"></div>
                  <button class="avatar-edit" id="avatarEdit" title="Đổi ảnh đại diện">
                    <svg viewBox="0 0 24 24"><path d="M14.7 3a2.4 2.4 0 0 1 3.4 0l2.9 2.9a2.4 2.4 0 0 1 0 3.4L9.8 19.5l-5.6 1.4 1.4-5.6z"/></svg>
                  </button>
                </div>
                <div class="hero-info">
                  <div class="name-row">
                    <div class="name" id="displayName"><%=fullName%></div>
                    <span class="verified" title="Đã xác thực">
                      <svg viewBox="0 0 24 24"><path d="m9 12 2 2 4-4"/><circle cx="12" cy="12" r="10"/></svg>
                    </span>
                  </div>
                  <div class="role">Người dùng · <span class="mono"><%=userIdDisplay%></span></div>
                  <div class="hero-pills">
                    <span class="pill <%= "active".equals(status) ? "ok" : "muted" %>"><span class="pdot"></span><%= "active".equals(status) ? "Đang hoạt động" : "Đã khóa" %></span>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <!-- Section 02: Personal Info -->
          <section class="section" id="sec-personal">
            <div class="section-head">
              <div class="section-head-left">
                <h3>02 — Thông tin cá nhân</h3>
                <span class="sub" id="personalSub">Sửa trực tiếp · Cập nhật <%=user.getUpdatedAt() != null ? user.getUpdatedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "—"%></span>
              </div>
            </div>
            <div class="section-body">
              <form id="profileForm" action="<%=request.getContextPath()%>/profile" method="POST" autocomplete="off">

                <div class="field-grid">

                  <!-- Full name -->
                  <div class="field">
                    <label class="field-label" for="fullName">
                      <span>Họ và tên <span class="req">*</span></span>
                    </label>
                    <input type="text" class="input" id="fullName" name="fullName" value="<%=fullName%>" maxlength="60" />
                    <div class="help" data-help-for="fullName">Tên hiển thị trên hệ thống.</div>
                  </div>

                  <!-- Username (locked) -->
                  <div class="field">
                    <label class="field-label" for="username">
                      <span>Tên đăng nhập</span>
                      <span class="badge lock">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        Khoá
                      </span>
                    </label>
                    <input type="text" class="input readonly" id="username" value="<%=username%>" readonly />
                    <div class="help">Không thể thay đổi tên đăng nhập.</div>
                  </div>

                  <!-- Email (locked) -->
                  <div class="field">
                    <label class="field-label" for="email">
                      <span>Email <span class="req">*</span></span>
                      <span class="badge lock">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                        Khoá
                      </span>
                    </label>
                    <input type="email" class="input readonly" id="email" name="email" value="<%=email%>" readonly />
                    <div class="help">Không thể thay đổi email. Liên hệ admin để hỗ trợ.</div>
                  </div>

                  <!-- Phone -->
                  <div class="field">
                    <label class="field-label" for="phone">
                      <span>Số điện thoại <span class="req">*</span></span>
                    </label>
                    <input type="tel" class="input" id="phone" name="phone" value="<%=phone%>" />
                    <div class="help" data-help-for="phone">Dùng để liên hệ và nhận thông báo.</div>
                  </div>

                  <!-- Address (full width) -->
                  <div class="field full">
                    <label class="field-label" for="address">
                      <span>Địa chỉ liên hệ</span>
                    </label>
                    <input type="text" class="input" id="address" name="address" value="<%=address%>" maxlength="120" />
                    <div class="help" data-help-for="address">Dùng cho liên hệ và chứng từ.</div>
                  </div>

                </div>

                <div style="margin-top: 24px; display: flex; gap: 12px;">
                  <button type="submit" class="btn btn-primary" id="saveBtn">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                    Lưu thay đổi
                  </button>
                  <button type="button" class="btn" id="cancelBtn">
                    Hủy
                  </button>
                </div>
              </form>
            </div>
          </section>

          <!-- Section 03: Roles -->
          <section class="section" id="sec-perms">
            <div class="section-head">
              <div class="section-head-left">
                <h3>03 — Vai trò</h3>
                <span class="sub">Read-only · Liên hệ admin để thay đổi</span>
              </div>
            </div>
            <div class="section-body">
              <% if (roles.isEmpty()) { %>
              <div style="color:var(--muted); font-size:13px;">Chưa có vai trò nào được gán.</div>
              <% } else { %>
              <div style="display:flex; flex-wrap:wrap; gap:10px;">
                <% for (Role role : roles) { %>
                <div class="pill ok"><span class="pdot"></span><%=role.getRoleName()%></div>
                <% } %>
              </div>
              <% } %>
            </div>
          </section>

        </div>
      </div>
    </main>
  </div>
</div>

<div class="toast" id="toast">
  <div class="toast-icon" id="toastIcon">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="m5 13 4 4L19 7"/></svg>
  </div>
  <div>
    <div class="toast-msg" id="toastMsg">Đã lưu</div>
    <div class="toast-sub" id="toastSub">Mọi thay đổi đã đồng bộ</div>
  </div>
</div>

<script>
  // ===== Theme toggle =====
  const root = document.documentElement;
  const storedTheme = localStorage.getItem('wh-theme');
  if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
  document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
  });

  // ===== Server values for dirty tracking =====
  const SERVER_VALUES = {
    fullName: '<%=fullName%>',
    phone: '<%=phone%>',
    address: '<%=address%>'
  };

  const FIELD_IDS = ['fullName', 'phone', 'address'];
  const FIELD_LABELS = {
    fullName: 'Họ tên',
    phone: 'SĐT',
    address: 'Địa chỉ'
  };

  function currentInputValues() {
    return {
      fullName: document.getElementById('fullName').value.trim(),
      phone: document.getElementById('phone').value.trim(),
      address: document.getElementById('address').value.trim()
    };
  }

  function dirtyFields() {
    const cur = currentInputValues();
    const fields = [];
    FIELD_IDS.forEach(id => { if (cur[id] !== SERVER_VALUES[id]) fields.push(id); });
    return fields;
  }

  function validate() {
    const cur = currentInputValues();
    const errors = {};
    if (!cur.fullName) errors.fullName = 'Họ tên không được để trống.';
    else if (cur.fullName.length < 2) errors.fullName = 'Họ tên cần ít nhất 2 ký tự.';

    if (!cur.phone) errors.phone = 'SĐT không được để trống.';
    else if (!/^0[0-9]{9,10}$/.test(cur.phone)) errors.phone = 'SĐT không hợp lệ (10-11 số, bắt đầu là 0).';

    return errors;
  }

  function updateDirtyUI() {
    const cur = currentInputValues();
    const errors = validate();
    const fields = dirtyFields();

    FIELD_IDS.forEach(id => {
      const el = document.getElementById(id);
      const isDirty = cur[id] !== SERVER_VALUES[id];
      const hasError = errors[id];
      el.classList.toggle('dirty', isDirty && !hasError);
      el.classList.toggle('invalid', !!hasError);

      const help = document.querySelector('[data-help-for="' + id + '"]');
      if (help) {
        help.classList.remove('error', 'dirty');
        if (hasError) {
          help.classList.add('error');
          help.textContent = errors[id];
        } else if (isDirty) {
          help.classList.add('dirty');
          help.textContent = 'Chưa lưu — bấm Lưu để áp dụng.';
        } else {
          const defaults = {
            fullName: 'Tên hiển thị trên hệ thống.',
            phone: 'Dùng để liên hệ và nhận thông báo.',
            address: 'Dùng cho liên hệ và chứng từ.'
          };
          help.textContent = defaults[id] || '';
        }
      }
    });

    document.getElementById('saveBtn').disabled = Object.keys(errors).length > 0 || fields.length === 0;
  }

  FIELD_IDS.forEach(id => {
    const el = document.getElementById(id);
    el.addEventListener('input', updateDirtyUI);
    el.addEventListener('change', updateDirtyUI);
  });

  // ===== Toast =====
  function showToast(type, msg, sub) {
    const t = document.getElementById('toast');
    const icon = document.getElementById('toastIcon');
    t.classList.remove('success', 'error');
    t.classList.add(type);
    document.getElementById('toastMsg').textContent = msg;
    document.getElementById('toastSub').textContent = sub || '';
    icon.innerHTML = type === 'success'
      ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="m5 13 4 4L19 7"/></svg>'
      : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="M12 8v4M12 16h.01"/><circle cx="12" cy="12" r="10"/></svg>';
    t.classList.add('show');
    clearTimeout(showToast._t);
    showToast._t = setTimeout(() => t.classList.remove('show'), 2800);
  }

  // ===== Cancel =====
  document.getElementById('cancelBtn').addEventListener('click', () => {
    document.getElementById('fullName').value = SERVER_VALUES.fullName;
    document.getElementById('phone').value = SERVER_VALUES.phone;
    document.getElementById('address').value = SERVER_VALUES.address;
    updateDirtyUI();
  });

  // ===== Avatar upload (client only) =====
  document.getElementById('avatarEdit').addEventListener('click', () => {
    document.getElementById('avatarFile').click();
  });
  document.getElementById('avatarFile').addEventListener('change', (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      showToast('error', 'Ảnh quá lớn', 'Tối đa 2MB');
      return;
    }
    const reader = new FileReader();
    reader.onload = (ev) => {
      const lg = document.getElementById('avatarLg');
      lg.innerHTML = '<img src="' + ev.target.result + '" alt="avatar">';
      const sm = document.querySelector('.sidebar-footer .avatar-sm');
      if (sm) sm.innerHTML = '<img src="' + ev.target.result + '" alt="avatar">';
    };
    reader.readAsDataURL(file);
    e.target.value = '';
  });

  // ===== TOC scroll-spy =====
  const tocItems = document.querySelectorAll('.toc-item');
  const sections = ['sec-overview', 'sec-personal', 'sec-perms'].map(id => document.getElementById(id));
  tocItems.forEach(item => {
    item.addEventListener('click', (e) => {
      e.preventDefault();
      const target = document.getElementById(item.dataset.target);
      if (target) {
        const top = target.getBoundingClientRect().top + window.pageYOffset - 80;
        window.scrollTo({ top, behavior: 'smooth' });
      }
    });
  });
  window.addEventListener('scroll', () => {
    const y = window.scrollY + 120;
    let active = sections[0];
    sections.forEach(s => { if (s && s.offsetTop <= y) active = s; });
    if (active) {
      tocItems.forEach(i => i.classList.toggle('active', i.dataset.target === active.id));
    }
  });

  // ===== Show toast if server sent success/error =====
  <% if (successMsg != null) { %>
  showToast('success', 'Đã lưu thay đổi', 'Hồ sơ được đồng bộ');
  <% } %>
  <% if (errorMsg != null) { %>
  showToast('error', 'Lỗi', '<%=errorMsg%>');
  <% } %>

  // initial UI
  updateDirtyUI();
</script>
</body>
</html>
