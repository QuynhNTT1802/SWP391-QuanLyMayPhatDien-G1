<%-- 
    Document   : user-detail
    Created on : May 16, 2026, 8:47:21 PM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Chi tiết người dùng — Warehouse OS</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
<style>

  [data-theme="dark"] {
    --bg: oklch(16% 0.012 250); --surface: oklch(20% 0.014 250); --surface-2: oklch(22% 0.014 250); --surface-3: oklch(24% 0.014 250);
    --fg: oklch(96% 0.005 240); --fg-soft: oklch(82% 0.008 240); --muted: oklch(65% 0.012 240); --muted-2: oklch(50% 0.012 240);
    --border: oklch(28% 0.014 240); --border-strong: oklch(36% 0.016 240);
    --accent: oklch(70% 0.18 145); --accent-soft: oklch(28% 0.06 145);
    --danger: oklch(68% 0.20 25); --danger-soft: oklch(28% 0.06 25);
    --warn: oklch(75% 0.16 75); --warn-soft: oklch(28% 0.06 75);
    --info: oklch(70% 0.15 250); --info-soft: oklch(28% 0.05 250);
    --purple: oklch(72% 0.16 295); --purple-soft: oklch(28% 0.06 295);
  }
  * { box-sizing: border-box; } html, body { margin: 0; padding: 0; }
  body { font-family: var(--font-ui); font-size: 14px; line-height: 1.5; font-weight: 450; color: var(--fg); background: var(--bg); font-variant-numeric: tabular-nums; font-feature-settings: var(--font-feature); -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; text-rendering: optimizeLegibility; }
  .mono { font-family: var(--font-mono); }
  .app { display: grid; grid-template-columns: 240px 1fr; min-height: 100vh; }
  aside.sidebar { background: var(--surface); border-right: 1px solid var(--border); position: sticky; top: 0; height: 100vh; display: flex; flex-direction: column; padding: 20px 12px 16px; }
  .brand { display: flex; align-items: center; gap: 10px; padding: 4px 10px 18px; font-weight: 700; font-size: 14px; letter-spacing: -0.01em; }
  .brand-mark { width: 22px; height: 22px; border-radius: 5px; background: var(--fg); color: var(--bg); display: grid; place-items: center; font-family: var(--font-mono); font-size: 11px; font-weight: 700; }
  nav.nav { display: flex; flex-direction: column; gap: 1px; flex: 1; }
  .nav-section { font-size: 10.5px; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); padding: 14px 10px 6px; font-weight: 700; }
  .nav a { display: flex; align-items: center; gap: 10px; padding: 7px 10px; border-radius: var(--radius-sm); color: var(--fg-soft); text-decoration: none; font-size: 13px; font-weight: 600; }
  .nav a:hover { background: var(--surface-2); color: var(--fg); }
  .nav a.active { background: var(--accent-soft); color: var(--accent); font-weight: 700; }
  .nav a .icon { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; flex-shrink: 0; }
  .nav a .count { margin-left: auto; font-family: var(--font-mono); font-size: 11px; color: var(--muted); background: var(--surface-2); padding: 1px 6px; border-radius: 999px; border: 1px solid var(--border); font-weight: 600; }
  .nav a.active .count { color: var(--accent); background: transparent; border-color: transparent; }
  .sidebar-footer { border-top: 1px solid var(--border); padding: 12px 10px 4px; margin-top: 8px; display: flex; align-items: center; gap: 10px; }
  .avatar { width: 28px; height: 28px; border-radius: 50%; background: var(--surface-2); border: 1px solid var(--border); display: grid; place-items: center; font-size: 11px; font-weight: 700; color: var(--fg-soft); }
  .user-meta { line-height: 1.2; flex: 1; min-width: 0; }
  .user-meta .name { font-size: 12.5px; font-weight: 700; }
  .user-meta .role { font-size: 11px; color: var(--muted); font-weight: 500; }

  header.topbar { position: sticky; top: 0; z-index: 10; background: color-mix(in srgb, var(--bg) 85%, transparent); backdrop-filter: blur(8px); border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 16px; padding: 12px 24px; }
  .topbar h1 { font-size: 16px; font-weight: 700; margin: 0; letter-spacing: -0.01em; }
  .crumb { color: var(--muted); font-size: 13px; font-weight: 500; }
  .crumb a { color: var(--muted); text-decoration: none; }
  .crumb a:hover { color: var(--fg); }
  .top-actions { margin-left: auto; display: flex; align-items: center; gap: 8px; }
  .btn { display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--border); background: var(--surface); color: var(--fg); padding: 7px 12px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; cursor: pointer; font-family: var(--font-ui); text-decoration: none; }
  .btn:hover { background: var(--surface-2); }
  .btn-primary { background: var(--fg); color: var(--bg); border-color: var(--fg); }
  .btn-primary:hover { background: var(--fg-soft); }
  .btn-danger { background: var(--surface); color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); }
  .btn-danger:hover { background: var(--danger-soft); }
  .btn .icon { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }
  .icon-btn { width: 32px; height: 32px; border: 1px solid var(--border); background: var(--surface); color: var(--fg-soft); border-radius: var(--radius-sm); display: grid; place-items: center; cursor: pointer; }
  .icon-btn:hover { background: var(--surface-2); color: var(--fg); }
  .icon-btn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.6; }
  .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
  [data-theme="light"] .theme-toggle .icon-moon { display: block; }
  [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

  main { padding: 20px 24px 60px; min-width: 0; }
  .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 12.5px; font-weight: 600; margin-bottom: 12px; }
  .back-link:hover { color: var(--fg); }
  .back-link svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 2; }

  .hero {
    background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius);
    padding: 22px 24px; display: flex; gap: 20px; align-items: center; margin-bottom: 16px;
  }
  .hero-avatar {
    width: 72px; height: 72px; border-radius: 50%; flex-shrink: 0;
    display: grid; place-items: center; font-size: 26px; font-weight: 700; color: var(--bg);
    position: relative;
  }
  .hero-avatar.purple { background: oklch(58% 0.16 295); }
  .hero-avatar::after {
    content: ''; position: absolute; inset-block-end: 2px; inset-inline-end: 2px;
    width: 14px; height: 14px; background: var(--accent); border: 2.5px solid var(--surface);
    border-radius: 50%;
  }
  .hero-body { flex: 1; min-width: 0; }
  .hero-name { font-size: 22px; font-weight: 700; letter-spacing: -0.02em; margin: 0 0 4px; display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
  .verified {
    display: inline-flex; align-items: center; gap: 4px; font-size: 11.5px; font-weight: 600; color: var(--accent);
    background: var(--accent-soft); padding: 2px 8px; border-radius: 999px;
  }
  .verified svg { width: 11px; height: 11px; stroke: currentColor; fill: none; stroke-width: 2.5; }
  .hero-meta { font-size: 13px; color: var(--muted); font-weight: 500; }
  .hero-meta .sep { margin: 0 8px; color: var(--muted-2); }
  .hero-meta .id { font-family: var(--font-mono); }
  .hero-pills { display: flex; gap: 6px; margin-top: 10px; flex-wrap: wrap; }
  .hero-actions { display: flex; gap: 6px; flex-shrink: 0; }

  .layout { display: grid; grid-template-columns: 240px 1fr; gap: 24px; align-items: start; }
  .toc { position: sticky; top: 76px; }
  .toc-item {
    display: flex; align-items: center; gap: 10px; padding: 9px 12px; border-radius: var(--radius-sm);
    color: var(--muted); text-decoration: none; font-size: 13px; font-weight: 600;
    cursor: pointer; transition: all .12s ease;
  }
  .toc-item:hover { color: var(--fg); background: var(--surface-2); }
  .toc-item.active { background: var(--surface); color: var(--fg); border: 1px solid var(--border); }
  .toc-num { font-family: var(--font-mono); font-size: 11px; color: var(--muted); width: 18px; }
  .toc-item.active .toc-num { color: var(--accent); }
  .toc-meta { margin-top: 18px; padding: 12px 12px 4px; border-top: 1px solid var(--border); font-size: 11.5px; color: var(--muted); line-height: 1.6; }
  .toc-meta strong { color: var(--fg-soft); font-weight: 600; }

  .content { min-width: 0; display: flex; flex-direction: column; gap: 18px; }
  .section { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 20px 22px; scroll-margin-top: 76px; }
  .section-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px; }
  .section-num { font-family: var(--font-mono); font-size: 11.5px; color: var(--accent); font-weight: 700; letter-spacing: 0.04em; }
  .section-title { font-size: 15px; font-weight: 700; margin: 2px 0 0; letter-spacing: -0.01em; }
  .section-update { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); font-weight: 500; }

  .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; }
  .info-field { display: flex; flex-direction: column; gap: 4px; }
  .info-label { font-size: 11px; color: var(--muted); font-weight: 600; letter-spacing: 0.02em; text-transform: uppercase; }
  .info-value { font-size: 14px; font-weight: 600; color: var(--fg); display: flex; align-items: center; gap: 8px; }
  .info-value.mono { font-family: var(--font-mono); font-weight: 500; }
  .copy-mini {
    width: 22px; height: 22px; border: 1px solid transparent; background: transparent;
    border-radius: 3px; color: var(--muted); cursor: pointer;
    display: grid; place-items: center; opacity: 0; transition: opacity .12s ease;
  }
  .info-field:hover .copy-mini { opacity: 1; }
  .copy-mini:hover { background: var(--surface-2); color: var(--fg); border-color: var(--border); }
  .copy-mini svg { width: 12px; height: 12px; stroke: currentColor; fill: none; stroke-width: 2; }

  .pill {
    display: inline-flex; align-items: center; gap: 5px;
    font-size: 11.5px; font-weight: 600; padding: 2px 8px;
    border-radius: 999px; border: 1px solid;
  }
  .pill .pdot { width: 5px; height: 5px; border-radius: 50%; }
  .pill.role-admin { color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft); }
  .pill.role-admin .pdot { background: var(--purple); }
  .pill.status-active { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft); }
  .pill.status-active .pdot { background: var(--accent); }
  .pill.warehouse { color: var(--fg-soft); border-color: var(--border-strong); background: var(--surface-2); font-family: var(--font-mono); }
  .pill.warehouse .pdot { background: var(--fg-soft); }

  .activity-list { display: flex; flex-direction: column; gap: 2px; }
  .activity { display: grid; grid-template-columns: 32px 1fr auto; gap: 12px; align-items: flex-start; padding: 10px 0; border-bottom: 1px dashed var(--border); }
  .activity:last-child { border-bottom: 0; }
  .activity-icon { width: 32px; height: 32px; border-radius: 6px; display: grid; place-items: center; background: var(--surface-2); border: 1px solid var(--border); }
  .activity-icon svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; color: var(--fg-soft); }
  .activity-icon.in { background: var(--accent-soft); border-color: transparent; color: var(--accent); }
  .activity-icon.out { background: var(--info-soft); border-color: transparent; color: var(--info); }
  .activity-icon.login { background: var(--surface-2); border-color: var(--border); color: var(--fg-soft); }
  .activity-body { line-height: 1.35; min-width: 0; }
  .activity-title { font-size: 13px; font-weight: 600; color: var(--fg); }
  .activity-title em { color: var(--accent); font-style: normal; font-weight: 600; }
  .activity-sub { font-size: 11.5px; color: var(--muted); font-family: var(--font-mono); margin-top: 2px; }
  .activity-time { font-size: 11px; color: var(--muted-2); font-family: var(--font-mono); white-space: nowrap; }

  .perm-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px; }
  .perm-role-pill { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }

  .rbac-role-assign { margin-bottom: 16px; padding: 16px; background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius); }
  .rbac-label { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: var(--muted); margin-bottom: 10px; }
  .rbac-roles-list { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; margin-bottom: 10px; }
  .rbac-role-tag { display: inline-flex; align-items: center; gap: 6px; font-size: 12.5px; font-weight: 600; padding: 5px 12px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 20%, transparent); }
  .rbac-role-x { margin-left: 4px; font-size: 15px; cursor: pointer; opacity: 0.6; line-height: 1; }
  .rbac-role-x:hover { opacity: 1; }
  .rbac-add-role { font-size: 12px; font-weight: 600; padding: 5px 12px; border-radius: 999px; background: transparent; color: var(--muted); border: 1px dashed var(--border-strong); cursor: pointer; }
  .rbac-add-role:hover { color: var(--accent); border-color: var(--accent); }
  .rbac-note { font-size: 12px; color: var(--muted); line-height: 1.5; }

  .rbac-legend { display: flex; flex-wrap: wrap; gap: 16px; margin-bottom: 14px; padding: 10px 14px; background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); }
  .legend-item { display: inline-flex; align-items: center; gap: 6px; font-size: 11.5px; font-weight: 600; color: var(--fg-soft); }
  .legend-dot { width: 10px; height: 10px; border-radius: 50%; }
  .legend-dot.inherited { background: var(--accent); }
  .legend-dot.override-on { background: var(--info); }
  .legend-dot.override-off { background: var(--danger); }

  .pm-source-tag { font-size: 10.5px; font-weight: 600; padding: 2px 8px; border-radius: 999px; white-space: nowrap; margin-left: auto; margin-right: 12px; }
  .pm-source-tag.inherited { background: var(--accent-soft); color: var(--accent); }
  .pm-source-tag.override { background: var(--info-soft); color: var(--info); }
  .pm-source-tag.none { background: transparent; color: var(--muted-2); }
  .pm-row.override-off .pm-source-tag.override { background: var(--danger-soft); color: var(--danger); }

  .toggle.locked { opacity: 0.7; cursor: not-allowed; pointer-events: none; }
  .pm-row.inherited { background: color-mix(in srgb, var(--accent-soft) 30%, transparent); }
  .pm-row.override-on { background: color-mix(in srgb, var(--info-soft) 40%, transparent); }
  .pm-row.override-off { background: color-mix(in srgb, var(--danger-soft) 30%, transparent); }
  .pmh-source { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: var(--muted); margin-left: auto; padding-right: 50px; }

  .perm-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
  .perm-item {
    display: flex; align-items: center; justify-content: space-between;
    padding: 12px 14px; border-radius: var(--radius-sm);
    background: var(--surface-2); border: 1px solid var(--border);
  }
  .perm-item .perm-label { display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 600; color: var(--fg); }
  .perm-item .perm-icon { width: 20px; height: 20px; border-radius: 4px; display: grid; place-items: center; background: var(--accent-soft); color: var(--accent); }
  .perm-item .perm-icon svg { width: 12px; height: 12px; stroke: currentColor; fill: none; stroke-width: 2; }
  .perm-item.disabled .perm-label { color: var(--muted); }
  .perm-item.disabled .perm-icon { background: var(--surface-3); color: var(--muted-2); }
  .toggle { position: relative; width: 36px; height: 20px; border-radius: 999px; background: var(--muted-2); cursor: pointer; flex-shrink: 0; transition: background .15s ease; }
  .toggle.on { background: var(--accent); }
  .toggle::after { content: ''; position: absolute; top: 2px; left: 2px; width: 16px; height: 16px; border-radius: 50%; background: white; transition: transform .15s ease; box-shadow: 0 1px 2px rgba(0,0,0,.15); }
  .toggle.on::after { transform: translateX(16px); }
  @media (max-width: 760px) { .perm-grid { grid-template-columns: 1fr; } }

  .perm-matrix { display: flex; flex-direction: column; gap: 2px; }
  .perm-matrix-header { display: flex; align-items: center; padding: 8px 14px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: var(--muted); }
  .pmh-module { flex: 1; }
  .pmh-actions { display: flex; gap: 0; }
  .pmh-actions span { width: 52px; text-align: center; }
  .perm-module { border: 1px solid var(--border); border-radius: var(--radius-sm); overflow: hidden; }
  .perm-module + .perm-module { margin-top: 4px; }
  .perm-module-head { display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: var(--surface-2); cursor: pointer; user-select: none; }
  .perm-module-head:hover { background: var(--surface-3); }
  .pm-left { display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 600; color: var(--fg); }
  .pm-chevron { width: 14px; height: 14px; stroke: var(--muted); fill: none; stroke-width: 2; transition: transform .15s ease; flex-shrink: 0; }
  .perm-module.open .pm-chevron { transform: rotate(90deg); }
  .pm-icon { width: 18px; height: 18px; stroke: var(--accent); fill: none; stroke-width: 1.8; }
  .pm-summary { display: flex; align-items: center; gap: 8px; }
  .pm-count { font-family: var(--font-mono); font-size: 11px; font-weight: 600; color: var(--muted); background: var(--surface-3); padding: 2px 8px; border-radius: 999px; }
  .perm-module-body { display: none; border-top: 1px solid var(--border); }
  .perm-module.open .perm-module-body { display: block; }
  .pm-row { display: flex; align-items: center; justify-content: space-between; padding: 9px 14px 9px 42px; border-bottom: 1px solid var(--border); }
  .pm-row:last-child { border-bottom: none; }
  .pm-action-label { font-size: 12.5px; color: var(--fg-soft); font-weight: 500; }
  .pm-row .toggle { width: 32px; height: 18px; }
  .pm-row .toggle::after { width: 14px; height: 14px; }
  .pm-row .toggle.on::after { transform: translateX(14px); }

  .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
  .mini-stat {
    background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm);
    padding: 11px 13px;
  }
  .mini-stat .lbl { font-size: 10.5px; color: var(--muted); font-weight: 600; letter-spacing: 0.04em; text-transform: uppercase; margin-bottom: 4px; }
  .mini-stat .val { font-family: var(--font-mono); font-size: 19px; font-weight: 700; letter-spacing: -0.02em; }
  .mini-stat .sub { font-size: 11px; color: var(--muted); margin-top: 2px; font-weight: 500; }

  @media (max-width: 1100px) {
    .layout { grid-template-columns: 1fr; }
    .toc { position: static; display: flex; flex-direction: row; flex-wrap: wrap; gap: 4px; }
    .toc-item { padding: 6px 10px; font-size: 12.5px; }
    .toc-meta { display: none; }
    .info-grid { grid-template-columns: 1fr; }
    .stats-grid { grid-template-columns: repeat(2, 1fr); }
  }
  @media (max-width: 760px) {
    .app { grid-template-columns: 1fr; }
    aside.sidebar { display: none; }
    main { padding: 16px; }
    .hero { flex-direction: column; align-items: flex-start; }
    .hero-actions { width: 100%; }
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
      <h1>Chi tiết người dùng</h1>
      <span class="crumb">/ <a href="admin-users.html">Người dùng</a> / <span id="crumbId">USR-04822</span></span>
      <div class="top-actions">
        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
        <a class="btn" href="admin-user-edit.html?id=USR-04822">
          <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
          Chỉnh sửa
        </a>
        <button class="btn btn-danger">
          <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          Khoá tài khoản
        </button>
      </div>
    </header>

    <main>
      <a class="back-link" href="admin-users.html">
        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        Quay lại danh sách
      </a>

      <div class="hero">
        <div class="hero-avatar purple">PT</div>
        <div class="hero-body">
          <h2 class="hero-name">
            Phạm Tùng
            <span class="verified"><svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg> Đã xác thực</span>
          </h2>
          <div class="hero-meta">
            <span>Quản lý kho HN-01</span>
            <span class="sep">·</span>
            <span class="id">USR-04822</span>
            <span class="sep">·</span>
            <span>Tham gia 04/09/2023 (1 năm 8 tháng)</span>
          </div>
          <div class="hero-pills">
            <span class="pill role-admin"><span class="pdot"></span>Quản lý kho</span>
            <span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span>
            <span class="pill warehouse"><span class="pdot"></span>HN-01 · Hà Nội</span>
          </div>
        </div>
        <div class="hero-actions">
          <button class="icon-btn" title="Gửi email">
            <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><path d="m22 6-10 7L2 6"/></svg>
          </button>
          <button class="icon-btn" title="Reset mật khẩu">
            <svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-9-9c2.52 0 4.81 1 6.5 2.62L21 8M21 3v5h-5"/></svg>
          </button>
          <button class="icon-btn" title="Tải hồ sơ PDF">
            <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
          </button>
        </div>
      </div>

      <div class="layout">
        <div class="toc">
          <a class="toc-item active" data-toc="overview"><span class="toc-num">01</span><span>Tổng quan</span></a>
          <a class="toc-item" data-toc="info"><span class="toc-num">02</span><span>Thông tin cá nhân</span></a>
          <a class="toc-item" data-toc="activity"><span class="toc-num">03</span><span>Hoạt động gần đây</span></a>
          <a class="toc-item" data-toc="permissions"><span class="toc-num">04</span><span>Phân quyền</span></a>
          <div class="toc-meta">
            <strong>USR-04822</strong><br>
            Tạo: 04/09/2023<br>
            Cập nhật: 11/05/2026<br>
            Bởi: Mai Hoàng
          </div>
        </div>

        <div class="content">
          <section class="section" id="overview">
            <div class="section-head">
              <div>
                <div class="section-num">01 — TỔNG QUAN</div>
                <h3 class="section-title">Hoạt động trong 30 ngày</h3>
              </div>
              <div class="section-update">Cập nhật 14:08 hôm nay</div>
            </div>
            <div class="stats-grid">
              <div class="mini-stat"><div class="lbl">Phiếu đã duyệt</div><div class="val">87</div><div class="sub">+12 vs tháng trước</div></div>
              <div class="mini-stat"><div class="lbl">Phiếu đã tạo</div><div class="val">142</div><div class="sub">Trung bình 4.7/ngày</div></div>
              <div class="mini-stat"><div class="lbl">Đăng nhập</div><div class="val">28</div><div class="sub">26 ngày làm việc</div></div>
              <div class="mini-stat"><div class="lbl">Lần sửa SKU</div><div class="val">19</div><div class="sub">Trong định mức</div></div>
            </div>
          </section>

          <section class="section" id="info">
            <div class="section-head">
              <div>
                <div class="section-num">02 — THÔNG TIN CÁ NHÂN</div>
                <h3 class="section-title">Hồ sơ liên hệ &amp; nhân sự</h3>
              </div>
              <div class="section-update">Cập nhật 11/05/2026</div>
            </div>
            <div class="info-grid">
              <div class="info-field">
                <div class="info-label">Họ và tên</div>
                <div class="info-value">Phạm Tùng</div>
              </div>
              <div class="info-field">
                <div class="info-label">Email đăng nhập</div>
                <div class="info-value mono">tung.pham@warehouseos.vn
                  <button class="copy-mini" data-copy="tung.pham@warehouseos.vn"><svg viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg></button>
                </div>
              </div>
              <div class="info-field">
                <div class="info-label">Số điện thoại</div>
                <div class="info-value mono">+84 903 211 988
                  <button class="copy-mini" data-copy="+84903211988"><svg viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg></button>
                </div>
              </div>
              <div class="info-field">
                <div class="info-label">Vai trò</div>
                <div class="info-value"><span class="pill role-admin"><span class="pdot"></span>Quản lý kho</span></div>
              </div>
              <div class="info-field">
                <div class="info-label">Kho phụ trách</div>
                <div class="info-value"><span class="pill warehouse"><span class="pdot"></span>HN-01 · Hà Nội</span></div>
              </div>
              <div class="info-field">
                <div class="info-label">Trạng thái</div>
                <div class="info-value"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></div>
              </div>
              <div class="info-field">
                <div class="info-label">Tham gia</div>
                <div class="info-value mono">04/09/2023</div>
              </div>
              <div class="info-field">
                <div class="info-label">Đăng nhập cuối</div>
                <div class="info-value mono">12/05/2026 11:42 <span style="color:var(--muted);font-weight:500;font-family:var(--font-ui)">· 2 giờ trước</span></div>
              </div>
            </div>
          </section>

          <section class="section" id="activity">
            <div class="section-head">
              <div>
                <div class="section-num">03 — HOẠT ĐỘNG GẦN ĐÂY</div>
                <h3 class="section-title">14 sự kiện · 7 ngày qua</h3>
              </div>
              <a href="#" style="font-size:12px;color:var(--muted);text-decoration:none;font-weight:600">Xem tất cả →</a>
            </div>
            <div class="activity-list">
              <div class="activity">
                <div class="activity-icon login"><svg viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Đăng nhập từ <em>MacBook · Chrome 124</em></div>
                  <div class="activity-sub">IP 27.71.•••.42 · Hà Nội, VN</div>
                </div>
                <div class="activity-time">12/05 · 11:42</div>
              </div>
              <div class="activity">
                <div class="activity-icon in"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Duyệt phiếu nhập <em>PN-2645</em> · Cà phê Trung Nguyên G7</div>
                  <div class="activity-sub">540 thùng · NCC Trung Nguyên</div>
                </div>
                <div class="activity-time">12/05 · 09:48</div>
              </div>
              <div class="activity">
                <div class="activity-icon out"><svg viewBox="0 0 24 24"><path d="M12 19V5M19 12l-7-7-7 7"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Duyệt phiếu xuất <em>PX-1183</em> · Sữa Vinamilk 1L</div>
                  <div class="activity-sub">1,200 thùng → Coopmart Hà Đông</div>
                </div>
                <div class="activity-time">12/05 · 08:20</div>
              </div>
              <div class="activity">
                <div class="activity-icon"><svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Cập nhật tồn kho SKU <em>SKU-100921</em></div>
                  <div class="activity-sub">186 → 220 đơn vị · lý do: nhập bổ sung</div>
                </div>
                <div class="activity-time">11/05 · 16:15</div>
              </div>
              <div class="activity">
                <div class="activity-icon login"><svg viewBox="0 0 24 24"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Đăng nhập từ <em>iPhone 15 Pro · Safari</em></div>
                  <div class="activity-sub">IP 27.71.•••.42 · Hà Nội, VN</div>
                </div>
                <div class="activity-time">11/05 · 07:30</div>
              </div>
              <div class="activity">
                <div class="activity-icon in"><svg viewBox="0 0 24 24"><path d="M12 5v14M5 12l7 7 7-7"/></svg></div>
                <div class="activity-body">
                  <div class="activity-title">Duyệt phiếu nhập <em>PN-2644</em> · Nước mắm Nam Ngư</div>
                  <div class="activity-sub">920 thùng · NCC Masan</div>
                </div>
                <div class="activity-time">10/05 · 17:25</div>
              </div>
            </div>
          </section>

          <section class="section" id="permissions">
            <div class="section-head">
              <div>
                <div class="section-num">04 — PHÂN QUYỀN (RBAC)</div>
                <h3 class="section-title">Vai trò & Quyền hạn</h3>
              </div>
            </div>

            <div class="rbac-role-assign">
              <div class="rbac-label">Vai trò được gán</div>
              <div class="rbac-roles-list">
                <div class="rbac-role-tag active">
                  <svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" fill="none" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                  Quản lý kho
                  <span class="rbac-role-x" title="Gỡ vai trò">&times;</span>
                </div>
                <div class="rbac-role-tag active">
                  <svg viewBox="0 0 24 24" width="13" height="13" stroke="currentColor" fill="none" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/></svg>
                  Nhân viên PO
                  <span class="rbac-role-x" title="Gỡ vai trò">&times;</span>
                </div>
                <button class="rbac-add-role">+ Thêm vai trò</button>
              </div>
              <div class="rbac-note">Quyền kế thừa từ vai trò hiển thị bên dưới. Bạn có thể override (thêm/bớt) quyền riêng cho user này.</div>
            </div>

            <div class="rbac-legend">
              <span class="legend-item"><span class="legend-dot inherited"></span> Kế thừa từ vai trò</span>
              <span class="legend-item"><span class="legend-dot override-on"></span> Override: bật thêm</span>
              <span class="legend-item"><span class="legend-dot override-off"></span> Override: tắt bớt</span>
            </div>

            <div class="perm-matrix">
              <div class="perm-matrix-header">
                <div class="pmh-module">Module</div>
                <div class="pmh-source">Nguồn</div>
              </div>
              <div class="perm-module open">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                    <span>Quản lý kho hàng</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">5/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem tồn kho &amp; vị trí</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Nhập kho (tạo phiếu nhập)</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xuất kho (tạo phiếu xuất)</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Kiểm kê &amp; điều chỉnh số lượng</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Điều chuyển giữa các kho</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xoá phiếu kho nháp</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                    <span>Quản lý sản phẩm</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">6/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem danh mục &amp; chi tiết sản phẩm</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Thêm sản phẩm mới</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Sửa thông tin sản phẩm</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xoá / ẩn sản phẩm</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Quản lý danh mục &amp; phân loại</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xuất danh sách sản phẩm</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M16 3h5v5M4 20L21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/></svg>
                    <span>Nhà cung cấp</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">4/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem danh sách nhà cung cấp</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Thêm nhà cung cấp mới</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Sửa thông tin NCC</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row override-off"><span class="pm-action-label">Xoá / ngừng hợp tác</span><span class="pm-source-tag override">Override: tắt</span><div class="toggle locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Đánh giá &amp; xếp hạng NCC</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xuất danh sách NCC</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><path d="M16 13H8M16 17H8M10 9H8"/></svg>
                    <span>Đơn đặt hàng (PO)</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">5/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem danh sách đơn đặt hàng</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Tạo đơn đặt hàng mới</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Sửa đơn đặt hàng nháp</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Huỷ đơn đặt hàng</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Duyệt đơn đặt hàng</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row override-on"><span class="pm-action-label">Xuất PO sang PDF/Excel</span><span class="pm-source-tag override">Override: bật</span><div class="toggle on"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M9 17H7A5 5 0 0 1 7 7h2M15 7h2a5 5 0 1 1 0 10h-2M8 12h8"/></svg>
                    <span>Vận chuyển &amp; Giao nhận</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">3/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem lịch giao hàng</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Tạo phiếu giao hàng</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Cập nhật trạng thái vận chuyển</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Huỷ phiếu giao hàng</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xác nhận giao thành công</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xuất báo cáo vận chuyển</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M3 3h18v18H3zM12 8v8M8 12h8"/></svg>
                    <span>Quản lý vị trí &amp; kệ hàng</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">4/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem sơ đồ kho &amp; vị trí</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Thêm vị trí / kệ mới</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Sửa thông tin vị trí</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xoá vị trí trống</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Gán sản phẩm vào vị trí</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xuất sơ đồ kho PDF</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    <span>Quản lý người dùng</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">3/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem danh sách nhân viên</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Thêm nhân viên mới</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Sửa thông tin nhân viên</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Vô hiệu hoá tài khoản</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Gán vai trò &amp; phân quyền</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xuất danh sách nhân viên</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <span>Phân quyền &amp; Vai trò</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">2/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem danh sách vai trò</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Tạo vai trò mới</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Sửa quyền vai trò</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xoá vai trò</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Gán vai trò cho nhân viên</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xuất ma trận quyền</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                </div>
              </div>
              <div class="perm-module">
                <div class="perm-module-head" onclick="this.parentElement.classList.toggle('open')">
                  <div class="pm-left">
                    <svg class="pm-chevron" viewBox="0 0 24 24"><path d="M9 18l6-6-6-6"/></svg>
                    <svg class="pm-icon" viewBox="0 0 24 24"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>
                    <span>Báo cáo &amp; Thống kê</span>
                  </div>
                  <div class="pm-summary"><span class="pm-count">5/6</span></div>
                </div>
                <div class="perm-module-body">
                  <div class="pm-row inherited"><span class="pm-action-label">Xem dashboard tổng quan</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xem báo cáo tồn kho</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Xem báo cáo nhập/xuất</span><span class="pm-source-tag inherited">Nhân viên PO</span><div class="toggle on locked"></div></div>
                  <div class="pm-row"><span class="pm-action-label">Xem báo cáo tài chính kho</span><span class="pm-source-tag none">—</span><div class="toggle"></div></div>
                  <div class="pm-row inherited"><span class="pm-action-label">Tạo báo cáo tuỳ chỉnh</span><span class="pm-source-tag inherited">Quản lý kho</span><div class="toggle on locked"></div></div>
                  <div class="pm-row override-on"><span class="pm-action-label">Xuất báo cáo Excel/PDF</span><span class="pm-source-tag override">Override: bật</span><div class="toggle on"></div></div>
                </div>
              </div>
            </div>
          </section>
        </div>
      </div>
    </main>
  </div>
</div>

<script>
  const root = document.documentElement;
  const storedTheme = localStorage.getItem('wh-theme');
  if (storedTheme === 'dark' || storedTheme === 'light') root.setAttribute('data-theme', storedTheme);
  document.getElementById('themeToggle').addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('wh-theme', next);
  });

  // TOC scroll spy
  const tocItems = document.querySelectorAll('.toc-item');
  tocItems.forEach(item => {
    item.addEventListener('click', () => {
      const target = document.getElementById(item.dataset.toc);
      if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  });
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        tocItems.forEach(t => t.classList.remove('active'));
        const match = document.querySelector(`.toc-item[data-toc="${e.target.id}"]`);
        if (match) match.classList.add('active');
      }
    });
  }, { rootMargin: '-100px 0px -60% 0px' });
  document.querySelectorAll('.section').forEach(s => observer.observe(s));

  // copy buttons
  document.querySelectorAll('.copy-mini').forEach(btn => {
    btn.addEventListener('click', () => {
      navigator.clipboard?.writeText(btn.dataset.copy);
      const orig = btn.innerHTML;
      btn.innerHTML = '<svg viewBox="0 0 24 24" stroke="currentColor" fill="none" stroke-width="2.5"><path d="M20 6 9 17l-5-5"/></svg>';
      setTimeout(() => { btn.innerHTML = orig; }, 1200);
    });
  });

  // permission toggles
  document.querySelectorAll('.toggle').forEach(toggle => {
    toggle.addEventListener('click', () => {
      toggle.classList.toggle('on');
      const item = toggle.closest('.perm-item') || toggle.closest('.pm-row');
      if (item) item.classList.toggle('disabled', !toggle.classList.contains('on'));
      // update module count
      const mod = toggle.closest('.perm-module');
      if (mod) {
        const total = mod.querySelectorAll('.pm-row .toggle').length;
        const active = mod.querySelectorAll('.pm-row .toggle.on').length;
        const countEl = mod.querySelector('.pm-count');
        if (countEl) countEl.textContent = active + '/' + total;
      }
    });
  });
</script>
<script src="assets/js/sidebar.js"></script>
</body>
</html>

