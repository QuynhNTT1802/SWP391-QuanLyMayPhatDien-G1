<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.quanlymayphatdien.g1.entity.User"%>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        HttpSession sess = request.getSession(false);
        if (sess != null && sess.getAttribute("loggedUser") != null) {
            user = (User) sess.getAttribute("loggedUser");
        }
    }
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/authen?action=login");
        return;
    }
    String successMsg = (String) request.getAttribute("success");
    String errorMsg = (String) request.getAttribute("error");

    String fullName = user.getName() != null ? user.getName() : "";
    String initials = "";
    String[] nameParts = fullName.trim().split("\\s+");
    if (nameParts.length == 1) {
        initials = nameParts[0].length() >= 2 ? nameParts[0].substring(0, 2).toUpperCase() : nameParts[0].toUpperCase();
    } else {
        initials = (nameParts[0].charAt(0) + nameParts[nameParts.length - 1].charAt(0) + "").toUpperCase();
    }
%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Đổi mật khẩu — Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,500;1,600&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/variables.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/base.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/sidebar.css">
<style>
  h1, h2, h3, h4 { font-weight: 700; letter-spacing: -0.01em; }
  label, .label { font-weight: 600; }
  input, select, textarea, button { font-weight: 500; font-family: var(--font-ui); }
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
  .avatar-sm { width: 28px; height: 28px; border-radius: 50%; background: var(--surface-2); border: 1px solid var(--border); display: grid; place-items: center; font-size: 11px; font-weight: 700; color: var(--fg-soft); overflow: hidden; }
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
  .crumb a { color: var(--muted); text-decoration: none; }
  .crumb a:hover { color: var(--fg); }
  .top-actions { margin-inline-start: auto; display: flex; align-items: center; gap: 8px; }
  .btn { display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--border); background: var(--surface); color: var(--fg); padding: 7px 14px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; cursor: pointer; font-family: var(--font-ui); }
  .btn:hover { background: var(--surface-2); }
  .btn-primary { background: var(--fg); color: var(--bg); border-color: var(--fg); }
  .btn-primary:hover { opacity: 0.92; }
  .btn-primary:disabled { background: var(--muted-2); border-color: var(--muted-2); color: var(--surface); cursor: not-allowed; opacity: 1; }
  .btn-danger { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft); }
  .btn-danger:hover { background: color-mix(in srgb, var(--danger) 15%, var(--surface)); }
  .btn .icon { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .icon-btn { width: 32px; height: 32px; border: 1px solid var(--border); background: var(--surface); color: var(--fg-soft); border-radius: var(--radius-sm); display: grid; place-items: center; cursor: pointer; }
  .icon-btn:hover { background: var(--surface-2); color: var(--fg); }
  .icon-btn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.6; }

  /* Main / page head */
  main { padding: 20px 24px 80px; max-width: 1240px; overflow-x: hidden; }
  .page-head { padding: 16px 0 8px; max-width: 720px; }
  .eyebrow { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); padding: 4px 0 10px; }
  .eyebrow::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: var(--accent); }
  .page-head .title { font-size: clamp(28px, 3.4vw, 38px); font-weight: 700; line-height: 1.1; letter-spacing: -0.02em; margin: 0 0 12px; }
  .page-head .title em { font-style: italic; font-weight: 600; color: var(--accent); }
  .page-head .lede { font-size: 15px; color: var(--fg-soft); line-height: 1.55; max-width: 640px; }
  .page-head .lede em { font-style: italic; color: var(--fg); font-weight: 600; }

  /* Tabs */
  .tabs-row { display: flex; gap: 0; border-bottom: 1px solid var(--border); margin: 24px 0 24px; gap: 2px; }
  .tab-link { display: inline-flex; align-items: center; gap: 8px; background: transparent; border: 0; border-bottom: 2px solid transparent; padding: 10px 14px; font-size: 13px; font-weight: 600; color: var(--muted); cursor: pointer; margin-bottom: -1px; font-family: var(--font-ui); }
  .tab-link:hover { color: var(--fg); }
  .tab-link.active { color: var(--fg); border-bottom-color: var(--fg); }
  .tab-link .pill-mini { font-family: var(--font-mono); font-size: 10.5px; padding: 1px 6px; border-radius: 3px; background: var(--accent-soft); color: var(--accent); border: 0; font-weight: 600; }

  /* 2-column layout */
  .layout { display: grid; grid-template-columns: 220px minmax(0, 1fr); gap: 32px; }
  aside.toc { position: sticky; top: 70px; align-self: start; padding: 0; }
  .toc-title { font-size: 10.5px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); padding: 0 0 10px; border-bottom: 1px solid var(--border); margin-bottom: 4px; }
  .toc-list { display: flex; flex-direction: column; gap: 1px; padding: 4px 0; }
  .toc-item { display: flex; align-items: center; gap: 8px; padding: 7px 10px; border-radius: var(--radius-sm); text-decoration: none; color: var(--muted); font-size: 13px; font-weight: 600; }
  .toc-item:hover { color: var(--fg); background: var(--surface-2); }
  .toc-item.active { color: var(--fg); background: var(--surface-2); }
  .toc-item.active .toc-num { color: var(--accent); }
  .toc-num { font-family: var(--font-mono); font-size: 11px; color: var(--muted-2); font-weight: 600; min-width: 18px; }
  .toc-meta { margin-top: 14px; padding: 12px 10px 4px; border-top: 1px solid var(--border); font-size: 11.5px; color: var(--muted); }
  .toc-meta .row { display: flex; justify-content: space-between; padding: 3px 0; }
  .toc-meta .row span:last-child { color: var(--fg-soft); font-family: var(--font-mono); }

  /* Sections */
  .content { display: flex; flex-direction: column; gap: 24px; min-width: 0; }
  .section { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
  .section-head { display: flex; align-items: center; justify-content: space-between; padding: 16px 22px; border-bottom: 1px solid var(--border); }
  .section-head h3 { font-size: 14px; font-weight: 700; margin: 0; letter-spacing: -0.005em; }
  .section-head .sub { font-size: 11.5px; color: var(--muted); margin-top: 2px; font-weight: 500; }
  .section-body { padding: 22px; }

  /* Section 01: Status banner */
  .status-banner { display: flex; gap: 16px; align-items: flex-start; padding: 18px 20px; border-radius: var(--radius); background: var(--accent-soft); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }
  .status-icon { width: 36px; height: 36px; border-radius: 8px; background: var(--surface); display: grid; place-items: center; flex-shrink: 0; color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent); }
  .status-icon svg { width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .status-body { flex: 1; min-width: 0; }
  .status-title { font-size: 14px; font-weight: 700; color: var(--accent); display: flex; align-items: center; gap: 8px; }
  .status-title .pill-tiny { font-family: var(--font-mono); font-size: 10.5px; font-weight: 600; padding: 1px 6px; border-radius: 3px; background: var(--surface); border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent); color: var(--accent); }
  .status-desc { font-size: 13px; color: var(--fg-soft); margin-top: 4px; }
  .status-meta { display: flex; gap: 18px; margin-top: 10px; font-size: 12px; color: var(--muted); font-family: var(--font-mono); flex-wrap: wrap; }
  .status-meta strong { color: var(--fg); font-weight: 600; margin-inline-start: 4px; }

  /* Form fields */
  .field-stack { display: flex; flex-direction: column; gap: 18px; max-width: 540px; }
  .field-label { display: flex; align-items: center; justify-content: space-between; font-size: 12.5px; font-weight: 600; color: var(--fg); margin-bottom: 6px; }
  .field-label .req { color: var(--danger); margin-inline-start: 2px; font-weight: 700; }
  .field-label .hint-mini { font-size: 11px; color: var(--muted); font-weight: 500; }

  .input-wrap { position: relative; }
  .input { width: 100%; border: 1px solid var(--border); background: var(--surface); color: var(--fg); border-radius: var(--radius-sm); padding: 10px 44px 10px 12px; font-size: 14px; font-weight: 500; font-family: var(--font-mono); letter-spacing: 0.02em; transition: border-color 0.15s, box-shadow 0.15s; }
  .input::placeholder { color: var(--muted-2); }
  .input:hover { border-color: var(--border-strong); }
  .input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
  .input.invalid { border-color: var(--danger); }
  .input.invalid:focus { box-shadow: 0 0 0 3px var(--danger-soft); }
  .input.valid:not(:focus) { border-color: color-mix(in srgb, var(--accent) 35%, var(--border)); }

  .reveal-btn {
    position: absolute; inset-inline-end: 6px; inset-block-start: 50%;
    transform: translateY(-50%);
    width: 32px; height: 32px;
    display: grid; place-items: center;
    background: transparent; border: 0; border-radius: 4px;
    color: var(--muted); cursor: pointer;
  }
  .reveal-btn:hover { color: var(--fg); background: var(--surface-2); }
  .reveal-btn svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 1.6; }
  .reveal-btn .icon-eye-off { display: none; }
  .reveal-btn.shown .icon-eye { display: none; }
  .reveal-btn.shown .icon-eye-off { display: block; }

  .help { font-size: 11.5px; color: var(--muted); margin-top: 6px; font-weight: 500; }
  .help.error { color: var(--danger); display: none; }
  .field.has-error .help.error { display: block; }
  .field.has-error .help.default { display: none; }

  /* Strength meter */
  .strength { margin-top: 10px; }
  .strength-bars { display: grid; grid-template-columns: repeat(4, 1fr); gap: 4px; }
  .strength-bar { height: 4px; border-radius: 2px; background: var(--border); transition: background 0.2s; }
  .strength-bar.s1 { background: var(--danger); }
  .strength-bar.s2 { background: var(--warn); }
  .strength-bar.s3 { background: oklch(70% 0.13 145); }
  .strength-bar.s4 { background: var(--accent); }
  .strength-label { display: flex; justify-content: space-between; align-items: center; margin-top: 6px; font-size: 11.5px; font-weight: 600; }
  .strength-label .level { color: var(--muted); }
  .strength-label .level.s1 { color: var(--danger); }
  .strength-label .level.s2 { color: var(--warn); }
  .strength-label .level.s3 { color: oklch(58% 0.13 145); }
  .strength-label .level.s4 { color: var(--accent); }
  .strength-label .crack-time { color: var(--muted); font-family: var(--font-mono); font-size: 11px; font-weight: 500; }

  /* Rules list */
  .rules { margin-top: 12px; display: grid; grid-template-columns: 1fr 1fr; gap: 6px 14px; padding: 12px 14px; background: var(--surface-2); border: 1px dashed var(--border); border-radius: var(--radius-sm); }
  .rule { display: flex; align-items: center; gap: 8px; font-size: 12px; color: var(--muted); font-weight: 500; }
  .rule .rdot { width: 14px; height: 14px; border-radius: 50%; border: 1.5px solid var(--muted-2); display: grid; place-items: center; flex-shrink: 0; }
  .rule .rdot svg { width: 8px; height: 8px; stroke: currentColor; fill: none; stroke-width: 3; opacity: 0; }
  .rule.met { color: var(--accent); }
  .rule.met .rdot { border-color: var(--accent); background: var(--accent); color: var(--surface); }
  .rule.met .rdot svg { opacity: 1; }

  /* Match indicator */
  .match-indicator { display: none; align-items: center; gap: 6px; margin-top: 8px; font-size: 12px; font-weight: 600; }
  .match-indicator.show { display: inline-flex; }
  .match-indicator.match { color: var(--accent); }
  .match-indicator.mismatch { color: var(--danger); }
  .match-indicator svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2.4; }

  /* Form actions */
  .form-actions {
    display: flex; align-items: center; gap: 10px;
    margin-top: 22px; padding-top: 20px; border-top: 1px solid var(--border);
    max-width: 540px;
  }
  .form-actions .left-info { font-size: 12px; color: var(--muted); margin-inline-end: auto; display: flex; align-items: center; gap: 8px; }
  .form-actions .left-info svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; flex-shrink: 0; }

  /* Section 03: sessions */
  .sessions { display: flex; flex-direction: column; }
  .session-row { display: grid; grid-template-columns: 36px 1fr auto auto; gap: 14px; align-items: center; padding: 14px 0; border-bottom: 1px dashed var(--border); }
  .session-row:last-child { border-bottom: 0; }
  .session-icon { width: 36px; height: 36px; border-radius: 8px; background: var(--surface-2); border: 1px solid var(--border); display: grid; place-items: center; color: var(--fg-soft); }
  .session-icon svg { width: 17px; height: 17px; stroke: currentColor; fill: none; stroke-width: 1.6; }
  .session-icon.current { background: var(--accent-soft); border-color: transparent; color: var(--accent); }
  .session-info { line-height: 1.3; min-width: 0; }
  .session-device { font-size: 13.5px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
  .session-device .badge-current { font-family: var(--font-mono); font-size: 10.5px; font-weight: 600; color: var(--accent); background: var(--accent-soft); padding: 1px 6px; border-radius: 3px; }
  .session-meta { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); margin-top: 2px; }
  .session-when { font-size: 12px; color: var(--muted); font-family: var(--font-mono); text-align: end; line-height: 1.3; }
  .session-when .ago { display: block; font-size: 10.5px; color: var(--muted-2); }
  .session-action { }
  .session-action button { background: transparent; border: 0; color: var(--muted); font-size: 12px; font-weight: 600; cursor: pointer; padding: 6px 10px; border-radius: var(--radius-sm); font-family: var(--font-ui); }
  .session-action button:hover { color: var(--danger); background: var(--danger-soft); }
  .session-action .badge-self { color: var(--accent); font-family: var(--font-mono); font-size: 11px; padding: 6px 10px; }

  .sessions-foot { padding: 16px 0 4px; display: flex; align-items: center; justify-content: space-between; border-top: 1px solid var(--border); margin-top: 6px; }
  .sessions-foot .summary { font-size: 12.5px; color: var(--muted); font-weight: 500; }
  .sessions-foot .summary strong { color: var(--fg); font-family: var(--font-mono); }

  /* Toast */
  .toast {
    position: fixed; inset-block-end: 24px; inset-inline-end: 24px;
    background: var(--surface); color: var(--fg);
    border: 1px solid var(--border); border-radius: var(--radius);
    padding: 12px 16px; box-shadow: var(--shadow-md);
    display: none; align-items: center; gap: 10px;
    font-size: 13px; font-weight: 600;
    z-index: 100;
    max-width: 360px;
  }
  .toast.show { display: flex; }
  .toast.success { border-color: color-mix(in srgb, var(--accent) 30%, transparent); }
  .toast.success .toast-icon { color: var(--accent); }
  .toast.error { border-color: color-mix(in srgb, var(--danger) 30%, transparent); }
  .toast.error .toast-icon { color: var(--danger); }
  .toast-icon { width: 22px; height: 22px; border-radius: 50%; display: grid; place-items: center; background: var(--accent-soft); flex-shrink: 0; }
  .toast.error .toast-icon { background: var(--danger-soft); }
  .toast-icon svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2.5; }

  /* Theme toggle */
  .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
  [data-theme="light"] .theme-toggle .icon-moon { display: block; }
  [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

  @media (max-width: 1100px) {
    .layout { grid-template-columns: 1fr; gap: 20px; }
    aside.toc { position: static; }
    .toc-meta { display: none; }
  }
  @media (max-width: 760px) {
    .app { grid-template-columns: 1fr; }
    aside.sidebar { display: none; }
    .rules { grid-template-columns: 1fr; }
    .session-row { grid-template-columns: 36px 1fr; }
    .session-when, .session-action { grid-column: 2; padding-inline-start: 0; }
  }
</style>
</head>
<body>
<% request.setAttribute("activePage", "changepass"); %>
<div class="app">
  <jsp:include page="../common/admin/aside.jsp"/>

  <div>
    <header class="topbar">
      <h1>Bảo mật</h1>
      <span class="crumb">/ <a href="<%=request.getContextPath()%>/profile">Hồ sơ</a> · Đổi mật khẩu</span>

      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
          <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
          <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
        </button>
        <a href="<%=request.getContextPath()%>/profile" class="btn">
          <svg class="icon" viewBox="0 0 24 24"><path d="m15 18-6-6 6-6"/></svg>
          Quay về hồ sơ
        </a>
      </div>
    </header>

    <main>

      <% if (successMsg != null) { %>
      <div class="alert alert-success" style="padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;background:var(--accent-soft);color:var(--accent);border:1px solid color-mix(in srgb, var(--accent) 30%, transparent);">
        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" fill="none" stroke-width="2"><path d="m5 13 4 4L19 7"/></svg>
        <%=successMsg%>
      </div>
      <% } %>

      <% if (errorMsg != null) { %>
      <div class="alert alert-error" style="padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb, var(--danger) 30%, transparent);">
        <svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" fill="none" stroke-width="2"><path d="M12 8v4M12 16h.01"/><circle cx="12" cy="12" r="10"/></svg>
        <%=errorMsg%>
      </div>
      <% } %>

      <div class="page-head">
        <div class="eyebrow">Bảo mật tài khoản</div>
        <h1 class="title">Đổi <em>mật khẩu</em> đăng nhập</h1>
        <div class="lede">Đặt mật khẩu mới ít nhất <em>10 ký tự</em>, có cả chữ hoa, chữ thường, số và ký tự đặc biệt.</div>
      </div>

      <div class="tabs-row">
        <a href="<%=request.getContextPath()%>/profile" class="tab-link">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a7 7 0 0 1 14 0v1"/></svg>
          Hồ sơ
        </a>
        <button class="tab-link active">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          Đổi mật khẩu
        </button>
      </div>

      <div class="layout">
        <aside class="toc">
          <div class="toc-title">Trên trang này</div>
          <div class="toc-list">
            <a href="#sec-status" class="toc-item active" data-target="sec-status">
              <span class="toc-num">01</span>
              Trạng thái
            </a>
            <a href="#sec-form" class="toc-item" data-target="sec-form">
              <span class="toc-num">02</span>
              Đổi mật khẩu
            </a>
          </div>
          
        </aside>

        <div class="content">

          <!-- Section 01: Status -->
          <section class="section" id="sec-status">
            <div class="section-head">
              <div>
                <h3>01 — Trạng thái bảo mật</h3>
                <div class="sub">Tóm tắt nhanh tài khoản</div>
              </div>
            </div>
            <div class="section-body">
              <div class="status-banner">
                <div class="status-icon">
                  <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
                </div>
                <div class="status-body">
                  <div class="status-title">
                    Tài khoản đang an toàn
                    <span class="pill-tiny">Khoá HSM</span>
                  </div>
                  
                  
                </div>
              </div>
            </div>
          </section>

          <!-- Section 02: Change password form -->
          <section class="section" id="sec-form">
            <div class="section-head">
              <div>
                <h3>02 — Đổi mật khẩu</h3>
                <div class="sub">Yêu cầu nhập mật khẩu hiện tại để xác minh</div>
              </div>
            </div>
            <div class="section-body">
              <form id="pwForm" action="<%=request.getContextPath()%>/changepass" method="POST" autocomplete="off">
                <div class="field-stack">

                  <!-- Current password -->
                  <div class="field" id="field-current">
                    <label class="field-label" for="currentPw">
                      <span>Mật khẩu hiện tại <span class="req">*</span></span>
                    </label>
                    <div class="input-wrap">
                      <input type="password" class="input" id="currentPw" name="currentPassword" placeholder="••••••••••" autocomplete="current-password" />
                      <button type="button" class="reveal-btn" data-target="currentPw" aria-label="Hiện/ẩn mật khẩu">
                        <svg class="icon-eye" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        <svg class="icon-eye-off" viewBox="0 0 24 24"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><path d="M1 1l22 22"/></svg>
                      </button>
                    </div>
                    <div class="help default">Nhập đúng mật khẩu đang dùng để đăng nhập.</div>
                    <div class="help error">Mật khẩu hiện tại không đúng.</div>
                  </div>

                  <!-- New password -->
                  <div class="field" id="field-new">
                    <label class="field-label" for="newPw">
                      <span>Mật khẩu mới <span class="req">*</span></span>
                      <span class="hint-mini">Tối thiểu 6 ký tự, có chữ hoa, thường và số</span>
                    </label>
                    <div class="input-wrap">
                      <input type="password" class="input" id="newPw" name="newPassword" placeholder="Tạo mật khẩu mới" autocomplete="new-password" />
                      <button type="button" class="reveal-btn" data-target="newPw" aria-label="Hiện/ẩn mật khẩu">
                        <svg class="icon-eye" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        <svg class="icon-eye-off" viewBox="0 0 24 24"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><path d="M1 1l22 22"/></svg>
                      </button>
                    </div>

                    <div class="strength">
                      <div class="strength-bars">
                        <div class="strength-bar" id="sb1"></div>
                        <div class="strength-bar" id="sb2"></div>
                        <div class="strength-bar" id="sb3"></div>
                        <div class="strength-bar" id="sb4"></div>
                      </div>
                      <div class="strength-label">
                        <span class="level" id="strengthLevel">Chưa nhập</span>
                        <span class="crack-time" id="crackTime"></span>
                      </div>
                    </div>

                    <div class="rules">
                      <div class="rule" data-rule="length">
                        <span class="rdot"><svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg></span>
                        Ít nhất 6 ký tự
                      </div>
                      <div class="rule" data-rule="upper">
                        <span class="rdot"><svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg></span>
                        Có chữ viết hoa (A–Z)
                      </div>
                      <div class="rule" data-rule="lower">
                        <span class="rdot"><svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg></span>
                        Có chữ viết thường (a–z)
                      </div>
                      <div class="rule" data-rule="number">
                        <span class="rdot"><svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg></span>
                        Có chữ số (0–9)
                      </div>
                      <div class="rule" data-rule="not-same">
                        <span class="rdot"><svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg></span>
                        Khác mật khẩu cũ
                      </div>
                    </div>

                    <div class="help default" style="margin-top:10px">Đừng dùng tên, ngày sinh, số điện thoại — quá dễ đoán.</div>
                    <div class="help error">Mật khẩu chưa đáp ứng đủ yêu cầu.</div>
                  </div>

                  <!-- Confirm password -->
                  <div class="field" id="field-confirm">
                    <label class="field-label" for="confirmPw">
                      <span>Xác nhận mật khẩu mới <span class="req">*</span></span>
                    </label>
                    <div class="input-wrap">
                      <input type="password" class="input" id="confirmPw" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password" />
                      <button type="button" class="reveal-btn" data-target="confirmPw" aria-label="Hiện/ẩn mật khẩu">
                        <svg class="icon-eye" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        <svg class="icon-eye-off" viewBox="0 0 24 24"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><path d="M1 1l22 22"/></svg>
                      </button>
                    </div>
                    <div class="match-indicator" id="matchIndicator">
                      <svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg>
                      <span class="msg">Trùng khớp</span>
                    </div>
                    <div class="help default">Gõ lại đúng mật khẩu mới ở trên.</div>
                  </div>

                </div>

                <div class="form-actions">
                  <div class="left-info">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    Các thiết bị khác sẽ tự đăng xuất sau khi đổi
                  </div>
                  <button type="button" class="btn" id="cancelBtn">Hủy</button>
                  <button type="submit" class="btn btn-primary" id="submitBtn" disabled>
                    <svg class="icon" viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                    Đổi mật khẩu
                  </button>
                </div>
              </form>
            </div>
          </section>

        </div>
      </div>

    </main>
  </div>
</div>

<div class="toast" id="toast">
  <div class="toast-icon" id="toastIcon">
    <svg viewBox="0 0 24 24"><path d="m5 13 4 4L19 7"/></svg>
  </div>
  <div id="toastMsg">Đã đổi mật khẩu</div>
</div>

<script>
  // Theme toggle (synced with dashboard)
  const root = document.documentElement;
  const stored = localStorage.getItem('wh-theme');
  if (stored === 'dark' || stored === 'light') root.setAttribute('data-theme', stored);
  document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
  });

  // Reveal password buttons
  document.querySelectorAll('.reveal-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const target = document.getElementById(btn.dataset.target);
      const showing = target.type === 'text';
      target.type = showing ? 'password' : 'text';
      btn.classList.toggle('shown', !showing);
    });
  });

  const currentPw = document.getElementById('currentPw');
  const newPw = document.getElementById('newPw');
  const confirmPw = document.getElementById('confirmPw');
  const submitBtn = document.getElementById('submitBtn');
  const fieldCurrent = document.getElementById('field-current');
  const fieldNew = document.getElementById('field-new');
  const fieldConfirm = document.getElementById('field-confirm');

  // Strength meter
  const sbars = [
    document.getElementById('sb1'),
    document.getElementById('sb2'),
    document.getElementById('sb3'),
    document.getElementById('sb4')
  ];
  const strengthLevel = document.getElementById('strengthLevel');
  const crackTime = document.getElementById('crackTime');

  const rules = {
    length: pw => pw.length >= 6,
    upper:  pw => /[A-Z]/.test(pw),
    lower:  pw => /[a-z]/.test(pw),
    number: pw => /[0-9]/.test(pw),
    'not-same': pw => pw.length > 0 && pw !== currentPw.value
  };

  function computeStrength(pw) {
    if (!pw) return 0;
    let score = 0;
    if (pw.length >= 8)  score++;
    if (pw.length >= 12) score++;
    if (pw.length >= 16) score++;
    const variety = [/[a-z]/, /[A-Z]/, /[0-9]/, /[^A-Za-z0-9]/].filter(r => r.test(pw)).length;
    score += variety - 1;
    return Math.max(0, Math.min(4, score));
  }

  function crackTimeLabel(pw) {
    if (!pw) return '';
    const variety = [/[a-z]/, /[A-Z]/, /[0-9]/, /[^A-Za-z0-9]/].filter(r => r.test(pw)).length;
    const charset = [26, 52, 62, 94][Math.max(0, variety - 1)] || 94;
    const combos = Math.pow(charset, pw.length);
    const secs = combos / 1e10; // 10 tỷ guess/giây
    if (secs < 60) return '< 1 phút để bẻ';
    if (secs < 3600) return Math.round(secs / 60) + ' phút để bẻ';
    if (secs < 86400) return Math.round(secs / 3600) + ' giờ để bẻ';
    if (secs < 86400 * 365) return Math.round(secs / 86400) + ' ngày để bẻ';
    const years = secs / (86400 * 365);
    if (years < 1000) return Math.round(years) + ' năm để bẻ';
    if (years < 1e6) return Math.round(years / 1000) + ' nghìn năm';
    if (years < 1e9) return Math.round(years / 1e6) + ' triệu năm';
    return '∞ năm để bẻ';
  }

  function updateStrengthUI(pw) {
    const s = computeStrength(pw);
    const labels = ['Chưa nhập', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
    const cls = ['', 's1', 's2', 's3', 's4'];
    sbars.forEach((b, i) => {
      b.className = 'strength-bar';
      if (i < s) b.classList.add(cls[s]);
    });
    strengthLevel.className = 'level' + (s > 0 ? ' ' + cls[s] : '');
    strengthLevel.textContent = labels[s];
    crackTime.textContent = crackTimeLabel(pw);
  }

  function updateRulesUI(pw) {
    Object.entries(rules).forEach(([key, fn]) => {
      const el = document.querySelector('.rule[data-rule="' + key + '"]');
      if (el) el.classList.toggle('met', fn(pw));
    });
  }

  function updateMatchUI() {
    const ind = document.getElementById('matchIndicator');
    const msg = ind.querySelector('.msg');
    if (!confirmPw.value) {
      ind.classList.remove('show', 'match', 'mismatch');
      return;
    }
    ind.classList.add('show');
    if (newPw.value === confirmPw.value) {
      ind.classList.add('match'); ind.classList.remove('mismatch');
      msg.textContent = 'Trùng khớp';
    } else {
      ind.classList.add('mismatch'); ind.classList.remove('match');
      msg.textContent = 'Không trùng khớp';
    }
  }

  function allRulesMet(pw) {
    return Object.values(rules).every(fn => fn(pw));
  }

  function updateSubmit() {
    const ok = currentPw.value.length > 0
            && allRulesMet(newPw.value)
            && confirmPw.value === newPw.value
            && confirmPw.value.length > 0;
    submitBtn.disabled = !ok;
  }

  function refresh() {
    updateStrengthUI(newPw.value);
    updateRulesUI(newPw.value);
    updateMatchUI();
    updateSubmit();
    fieldCurrent.classList.remove('has-error');
    fieldNew.classList.remove('has-error');
    fieldConfirm.classList.remove('has-error');
  }

  [currentPw, newPw, confirmPw].forEach(el => el.addEventListener('input', refresh));

  // Submit
  document.getElementById('pwForm').addEventListener('submit', e => {
    if (currentPw.value.length === 0) {
      e.preventDefault();
      fieldCurrent.classList.add('has-error');
      currentPw.classList.add('invalid');
      currentPw.focus();
      showToast('error', 'Vui lòng nhập mật khẩu hiện tại');
      return;
    }

    if (!allRulesMet(newPw.value)) {
      e.preventDefault();
      fieldNew.classList.add('has-error');
      newPw.focus();
      showToast('error', 'Mật khẩu mới chưa đủ yêu cầu');
      return;
    }

    if (newPw.value !== confirmPw.value) {
      e.preventDefault();
      fieldConfirm.classList.add('has-error');
      confirmPw.focus();
      showToast('error', 'Xác nhận mật khẩu không khớp');
      return;
    }
  });

  // Cancel
  document.getElementById('cancelBtn').addEventListener('click', () => {
    window.location.href = '<%=request.getContextPath()%>/profile';
  });

  // Toast
  let toastTimer = null;
  function showToast(type, msg) {
    const t = document.getElementById('toast');
    const icon = document.getElementById('toastIcon');
    t.className = 'toast show ' + type;
    document.getElementById('toastMsg').textContent = msg;
    icon.innerHTML = type === 'success'
      ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="m5 13 4 4L19 7"/></svg>'
      : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>';
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => t.classList.remove('show'), 3200);
  }

  // TOC scroll spy
  const tocItems = document.querySelectorAll('.toc-item');
  const sections = ['sec-status', 'sec-form'].map(id => document.getElementById(id));
  tocItems.forEach(item => {
    item.addEventListener('click', e => {
      e.preventDefault();
      const tgt = document.getElementById(item.dataset.target);
      if (tgt) window.scrollTo({ top: tgt.offsetTop - 80, behavior: 'smooth' });
    });
  });
  window.addEventListener('scroll', () => {
    const y = window.scrollY + 120;
    let active = sections[0];
    for (const s of sections) {
      if (s && s.offsetTop <= y) active = s;
    }
    tocItems.forEach(i => i.classList.toggle('active', i.dataset.target === active.id));
  });

  // Init
  refresh();
</script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>

