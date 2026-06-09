<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __propFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }

            /* ============== Page head (eyebrow + title + sub + status) ============== */
            .page-head { margin: 0 0 24px 0; padding-top: 4px; }
            .page-head .eyebrow {
                display: inline-flex; align-items: center; gap: 6px;
                font-size: 11px; font-weight: 700; letter-spacing: 0.08em;
                text-transform: uppercase; color: var(--accent); margin-bottom: 8px;
                font-family: var(--font-ui);
            }
            .page-head .eyebrow::before {
                content: ''; width: 5px; height: 5px; border-radius: 50%;
                background: var(--accent);
            }
            .page-head h1.title {
                font-size: 26px; font-weight: 700; letter-spacing: -0.02em;
                margin: 0; display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
                line-height: 1.2;
            }
            .page-head h1.title .ts-code {
                font-family: var(--font-mono);
                color: var(--fg-soft);
                font-weight: 700;
            }
            .page-head .lede {
                color: var(--muted); margin-top: 8px; font-size: 14px;
                display: flex; align-items: center; flex-wrap: wrap; gap: 4px;
            }
            .page-head .lede .sep { color: var(--muted-2); margin: 0 4px; }
            .page-head .ts-status { display: flex; align-items: center; gap: 6px; }

            /* ============== Status pill (hệ thống) ============== */
            .status-pill {
                display: inline-flex; align-items: center; gap: 5px;
                font-size: 11.5px; font-weight: 600;
                padding: 2px 8px; border-radius: 999px; border: 1px solid;
                font-family: var(--font-ui);
            }
            .status-pill .pdot {
                width: 5px; height: 5px; border-radius: 50%;
                background: currentColor;
            }
            .status-draft,
            .status-cancelled { color: var(--muted); border-color: var(--border); background: var(--surface-2); }
            .status-pending   { color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft); }
            .status-approved  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft); }
            .status-rejected  { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft); }
            .status-converted { color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft); }

            /* ============== Header bar (top code strip - subtle) ============== */
            .header-bar {
                display: flex; align-items: center; justify-content: space-between;
                gap: 12px; width: 100%;
                padding: 0 0 14px 0; margin: 0 0 18px 0;
                border-bottom: 1px solid var(--border);
            }
            .header-bar .hb-left {
                display: flex; align-items: center; gap: 12px; min-width: 0;
            }
            .header-bar .hb-left .hb-text {
                display: flex; align-items: baseline; gap: 10px; min-width: 0; flex-wrap: wrap;
            }
            .header-bar .hb-left .hb-num {
                font-family: var(--font-mono); font-size: 11px; font-weight: 700;
                color: var(--accent); letter-spacing: 0.04em;
            }
            .header-bar .hb-left .hb-label {
                font-size: 10.5px; color: var(--muted);
                text-transform: uppercase; letter-spacing: 0.06em; font-weight: 600;
            }
            .header-bar .hb-left .hb-code {
                font-family: var(--font-mono); font-size: 13px; font-weight: 700;
                color: var(--fg); letter-spacing: 0.02em;
                white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
            }
            .header-bar .hb-right { display: flex; align-items: center; gap: 8px; }

            /* ============== Action bar (button group) ============== */
            .action-bar {
                display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
                width: 100%; padding: 0 0 20px 0; margin: 0 0 8px 0;
            }
            .action-bar .ab-group {
                display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
            }
            .action-bar .ab-divider {
                width: 1px; height: 22px; background: var(--border); margin: 0 4px;
            }

            /* ============== Buttons (scope override - giống hệ thống) ============== */
            .header-bar .btn,
            .action-bar .btn,
            .detail-pager .btn {
                display: inline-flex; align-items: center; gap: 6px;
                height: auto; padding: 7px 12px;
                font-size: 13px; font-weight: 600; line-height: 1.2;
                border-radius: var(--radius-sm);
                border: 1px solid var(--border);
                background: var(--surface); color: var(--fg);
                font-family: var(--font-ui); cursor: pointer;
                white-space: nowrap; text-decoration: none;
                transition: background .15s ease, border-color .15s ease, color .15s ease;
            }
            .header-bar .btn svg,
            .action-bar .btn svg,
            .detail-pager .btn svg {
                width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8;
            }
            .header-bar .btn:hover,
            .action-bar .btn:hover,
            .detail-pager .btn:hover { background: var(--surface-2); }
            .header-bar .btn:disabled,
            .action-bar .btn:disabled,
            .detail-pager .btn:disabled { opacity: .45; cursor: not-allowed; }
            .header-bar .btn:focus-visible,
            .action-bar .btn:focus-visible,
            .detail-pager .btn:focus-visible {
                outline: none; box-shadow: 0 0 0 3px var(--accent-soft);
            }

            .header-bar .btn-primary,
            .action-bar .btn-primary {
                background: var(--fg); color: var(--bg); border-color: var(--fg);
            }
            .header-bar .btn-primary:hover,
            .action-bar .btn-primary:hover { background: var(--fg-soft); border-color: var(--fg-soft); }

            .header-bar .btn-danger,
            .action-bar .btn-danger,
            .detail-pager .btn-danger {
                color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent);
            }
            .header-bar .btn-danger:hover,
            .action-bar .btn-danger:hover,
            .detail-pager .btn-danger:hover { background: var(--danger-soft); }

            .header-bar .btn-success,
            .action-bar .btn-success,
            .detail-pager .btn-success {
                background: var(--accent); color: var(--bg); border-color: var(--accent);
            }
            .header-bar .btn-success:hover,
            .action-bar .btn-success:hover,
            .detail-pager .btn-success:hover { background: color-mix(in srgb, var(--accent) 85%, var(--fg)); }

            .header-bar .btn-warn,
            .action-bar .btn-warn,
            .detail-pager .btn-warn {
                color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent);
            }
            .header-bar .btn-warn:hover,
            .action-bar .btn-warn:hover,
            .detail-pager .btn-warn:hover { background: var(--warn-soft); }

            .action-bar .back-link {
                display: inline-flex; align-items: center; gap: 6px;
                height: auto; padding: 7px 12px;
                font-size: 13px; font-weight: 600;
                color: var(--muted); background: var(--surface);
                border: 1px solid var(--border); border-radius: var(--radius-sm);
                margin-bottom: 0; text-decoration: none;
                transition: color .15s ease, background .15s ease, border-color .15s ease;
            }
            .action-bar .back-link:hover {
                color: var(--fg); background: var(--surface-2);
                border-color: color-mix(in srgb, var(--fg) 18%, var(--border));
            }
            .action-bar .back-link svg { width: 13px; height: 13px; stroke: currentColor; fill: none; stroke-width: 1.8; }

            /* ============== Tabs (giống hệ thống) ============== */
            .tabs {
                display: flex; gap: 4px;
                border-bottom: 1px solid var(--border);
                margin: 0 0 28px 0;
            }
            .tab {
                background: transparent; border: 0;
                padding: 10px 14px;
                font-size: 13px; color: var(--muted); cursor: pointer;
                font-family: var(--font-ui); font-weight: 600;
                border-bottom: 2px solid transparent; margin-bottom: -1px;
                display: inline-flex; align-items: center; gap: 8px;
                transition: color .15s, border-color .15s;
            }
            .tab:hover { color: var(--fg); }
            .tab.active { color: var(--fg); border-bottom-color: var(--fg); }
            .tab svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; }
            .tab .tab-count {
                font-family: var(--font-mono); font-size: 10.5px; font-weight: 500;
                padding: 1px 6px; border-radius: 3px;
                background: var(--accent-soft); color: var(--accent);
            }
            .tab-panel { display: none; }
            .tab-panel.active { display: block; }

            /* ============== Section (content card) ============== */
            .detail-content {
                background: var(--surface); border: 1px solid var(--border);
                border-radius: 10px; padding: 22px 22px;
                width: 100%;
                margin-bottom: 20px;
            }
            .detail-content .dc-section-head {
                display: flex; align-items: center; justify-content: space-between;
                gap: 12px; margin: 0 0 18px 0; padding-bottom: 14px;
                border-bottom: 1px solid var(--border);
            }
            .detail-content .dc-section-head-left {
                display: flex; align-items: baseline; gap: 10px; min-width: 0;
            }
            .detail-content .dc-num {
                font-family: var(--font-mono); font-size: 11.5px; font-weight: 700;
                color: var(--accent); letter-spacing: 0.04em;
            }
            .detail-content .dc-section-title {
                font-size: 15px; font-weight: 700; color: var(--fg);
                margin: 0; letter-spacing: -0.01em;
            }
            .detail-content .dc-section-sub {
                font-size: 11.5px; color: var(--muted);
                font-family: var(--font-mono); font-weight: 500;
            }

            /* ============== Detail grid (info fields) ============== */
            .detail-grid { display: grid; gap: 14px 20px; }
            .detail-grid.row-4 { grid-template-columns: repeat(4, 1fr); }
            .detail-grid.row-2 { grid-template-columns: repeat(2, 1fr); }
            .detail-grid.row-1 { grid-template-columns: 1fr; }
            .detail-field { min-width: 0; }
            .detail-field .df-label {
                font-size: 11px; color: var(--muted);
                font-weight: 600; text-transform: uppercase;
                letter-spacing: 0.02em; margin-bottom: 4px;
            }
            .detail-field .df-value {
                font-size: 14px; color: var(--fg);
                font-weight: 600; word-wrap: break-word;
                display: flex; align-items: center; gap: 8px;
            }
            .detail-field .df-value.mono {
                font-family: var(--font-mono); font-weight: 500;
            }
            .detail-field .df-value.empty {
                color: var(--muted); font-style: italic; font-weight: 500;
            }
            @media (max-width: 1024px) {
                .detail-grid.row-4 { grid-template-columns: repeat(2, 1fr); }
            }
            @media (max-width: 600px) {
                .detail-grid.row-4,
                .detail-grid.row-2 { grid-template-columns: 1fr; }
            }

            /* ============== Note (read-only, soft) ============== */
            .note-soft {
                font-size: 13px; color: var(--fg-soft);
                line-height: 1.6; white-space: pre-wrap;
            }

            /* ============== Tables (product + history) ============== */
            .product-table, .history-table {
                width: 100%; border-collapse: separate; border-spacing: 0;
                border: 1px solid var(--border); border-radius: var(--radius);
                overflow: hidden; font-size: 13px;
            }
            .product-table th, .product-table td,
            .history-table th, .history-table td {
                padding: 11px 14px; text-align: left;
                border-bottom: 1px solid var(--border);
            }
            .product-table th, .history-table th {
                font-size: 11px; color: var(--muted);
                text-transform: uppercase; font-weight: 700;
                background: var(--surface-2); letter-spacing: 0.04em;
            }
            .product-table td, .history-table td {
                font-size: 13.5px; color: var(--fg); vertical-align: middle;
            }
            .product-table tbody tr:hover,
            .history-table tbody tr:hover { background: var(--surface-2); }
            .product-table tbody tr:last-child td,
            .history-table tbody tr:last-child td { border-bottom: 0; }
            .text-center { text-align: center; }
            .history-table .detail-cell {
                color: var(--fg-soft); line-height: 1.5; max-width: 400px;
            }
            .history-table .mono { font-family: var(--font-mono); font-size: 12px; }
            .result-summary {
                padding: 11px 14px; font-size: 12.5px; color: var(--muted);
                border-bottom: 1px solid var(--border); background: var(--surface-2);
            }
            .detail-pager {
                display: flex; align-items: center; justify-content: center;
                gap: 12px; margin-top: 16px;
                font-size: 13px; color: var(--muted);
            }
            .empty-state {
                text-align: center; padding: 40px 12px; color: var(--muted);
            }

            /* ============== Action badge (pill) ============== */
            .action-badge {
                display: inline-flex; align-items: center; gap: 5px;
                font-size: 11px; font-weight: 700;
                padding: 2px 9px; border-radius: 999px; border: 1px solid;
                text-transform: uppercase; letter-spacing: 0.02em;
            }
            .action-badge::before {
                content: ""; width: 5px; height: 5px;
                border-radius: 50%; background: currentColor;
            }
            .action-create   { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent); background: var(--accent-soft); }
            .action-update   { color: var(--purple); border-color: color-mix(in srgb, var(--purple) 32%, transparent); background: var(--purple-soft); }
            .action-approve  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent); background: var(--accent-soft); }
            .action-reject   { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 32%, transparent); background: var(--danger-soft); }
            .action-cancel   { color: var(--muted); border-color: var(--border); background: var(--surface-2); }
            .action-convert  { color: var(--info); border-color: color-mix(in srgb, var(--info) 32%, transparent); background: var(--info-soft); }
            .action-default  { color: var(--muted); border-color: var(--border); background: var(--surface-2); }

            /* ============== Banners (alert style) ============== */
            .reject-banner,
            .convert-banner {
                display: flex; align-items: flex-start; gap: 10px;
                padding: 12px 16px; margin-bottom: 16px;
                border-radius: var(--radius-sm);
                font-size: 13px; font-weight: 500;
            }
            .reject-banner svg, .convert-banner svg {
                width: 18px; height: 18px; stroke: currentColor; fill: none;
                stroke-width: 2; flex-shrink: 0; margin-top: 1px;
            }
            .reject-banner {
                background: var(--danger-soft); color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent);
            }
            .reject-banner .info-label { color: var(--danger); margin-bottom: 4px; }
            .convert-banner {
                background: var(--info-soft); color: var(--info);
                border: 1px solid color-mix(in srgb, var(--info) 30%, transparent);
            }
            .convert-banner .info-label { color: var(--info); margin-bottom: 4px; }
            .convert-banner a { color: var(--info); font-weight: 700; font-family: var(--font-mono); }
            .info-label {
                font-size: 11px; font-weight: 700;
                text-transform: uppercase; letter-spacing: 0.04em;
                margin-bottom: 6px;
            }

            /* ============== Modal ============== */
            .modal-host {
                position: fixed; inset: 0;
                background: rgba(0, 0, 0, 0.45);
                display: none; align-items: center; justify-content: center;
                z-index: 1000;
            }
            .modal-host.show { display: flex; }
            .modal-card {
                background: var(--surface); border-radius: var(--radius);
                padding: 22px 24px; width: 460px; max-width: 90vw;
            }
            .modal-card h3 { margin: 0 0 6px 0; font-size: 17px; }
            .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; }
            .modal-card label {
                display: block; font-size: 12px; font-weight: 700;
                text-transform: uppercase; letter-spacing: 0.04em;
                color: var(--muted); margin-bottom: 6px;
            }
            .modal-card textarea {
                width: 100%; min-height: 80px;
                padding: 8px 10px; border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--surface); color: var(--fg);
                font-family: var(--font-ui); font-size: 13px;
                resize: vertical; box-sizing: border-box;
            }
            .modal-actions {
                display: flex; gap: 8px; justify-content: flex-end; margin-top: 14px;
            }

            /* ============== Alert (error từ controller) ============== */
            .alert {
                display: flex; align-items: center; gap: 10px;
                padding: 12px 16px; border-radius: var(--radius-sm);
                margin-bottom: 16px; font-size: 13px; font-weight: 500;
            }
            .alert svg {
                width: 18px; height: 18px; stroke: currentColor; fill: none;
                stroke-width: 2; flex-shrink: 0;
            }
            .alert-error {
                background: var(--danger-soft); color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent);
            }

            /* ============== In ấn ============== */
            @media print {
                aside, .topbar, .back-link, .tabs, .toast-host,
                .header-bar, .action-bar {
                    display: none !important;
                }
                .detail-content { border: 1px solid #ddd; }
                body, .app > div:last-child, main { background: #fff !important; }
                .tab-panel { display: block !important; }
                .tab-panel:not(.active) { display: none !important; }
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <span><c:out value="${proposal.proposalCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <button type="button" class="btn" onclick="window.print()" title="In phiếu">
                            <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                            In phiếu
                        </button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <c:set var="isOwner" value="${sessionScope.loggedUser.id == proposal.createdBy}" />
                    <c:set var="perms" value="${sessionScope.userPermissions}" />

                    <%-- ============== 1) Header Bar (top code strip) ============== --%>
                    <div class="header-bar">
                        <div class="hb-left">
                            <div class="hb-text">
                                <span class="hb-num">00</span>
                                <span class="hb-label">Đang xem phiếu</span>
                                <span class="hb-code"><c:out value="${proposal.proposalCode}"/></span>
                            </div>
                        </div>
                        <div class="hb-right">
                            <button type="button" class="btn" onclick="window.print()" title="In phiếu">
                                In phiếu
                            </button>
                        </div>
                    </div>

                    <%-- ============== 2) Action Bar (button group: back + business actions) ============== --%>
                    <div class="action-bar">
                        <div class="ab-group">
                            <a class="btn back-link" href="${pageContext.request.contextPath}/proposal" title="Quay lại danh sách">
                                Quay lại danh sách
                            </a>
                        </div>

                        <c:set var="hasActions" value="false" />
                        <c:if test="${proposal.status == 'DRAFT' && isOwner}"><c:set var="hasActions" value="true" /></c:if>
                        <c:if test="${proposal.status == 'PENDING'}"><c:set var="hasActions" value="true" /></c:if>
                        <c:if test="${proposal.status == 'APPROVED'}"><c:set var="hasActions" value="true" /></c:if>

                        <c:if test="${hasActions}">
                            <div class="ab-divider"></div>
                            <div class="ab-group">
                                <c:if test="${proposal.status == 'DRAFT' && isOwner}">
                                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                        Chỉnh sửa
                                    </a>
                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                                        <input type="hidden" name="submitType" value="submit" />
                                        <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">
                                            Gửi duyệt
                                        </button>
                                    </form>
                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:inline;">
                                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này? Hành động không thể hoàn tác.')">
                                            Xoá
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${proposal.status == 'PENDING'}">
                                    <c:if test="${perms.contains('proposals.approve')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận duyệt phiếu đề xuất này?')">
                                                Duyệt phiếu
                                            </button>
                                        </form>
                                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/proposal?action=reject&id=${proposal.proposalId}">
                                            Từ chối
                                        </a>
                                    </c:if>
                                    <c:if test="${perms.contains('proposals.cancel')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">
                                                Huỷ phiếu
                                            </button>
                                        </form>
                                    </c:if>
                                </c:if>

                                <c:if test="${proposal.status == 'APPROVED'}">
                                    <c:if test="${perms.contains('proposals.convert')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=convert" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-success">
                                                Tạo phiếu nhập từ đề xuất
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${perms.contains('proposals.cancel')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất đã duyệt?')">
                                                Huỷ phiếu
                                            </button>
                                        </form>
                                    </c:if>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <%-- ============== 3) Page Head (eyebrow + title + lede + status) ============== --%>
                    <div class="page-head">
                        <div class="eyebrow">Phiếu đề xuất nhập kho</div>
                        <h1 class="title">
                            <span>Chi tiết đề xuất</span>
                            <span class="ts-code">#${proposal.proposalId}</span>
                            <span class="ts-status">
                                <c:choose>
                                    <c:when test="${proposal.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Nháp</span></c:when>
                                    <c:when test="${proposal.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${proposal.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                    <c:when test="${proposal.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                    <c:when test="${proposal.status == 'CONVERTED'}"><span class="status-pill status-converted"><span class="pdot"></span>Đã chuyển phiếu nhập</span></c:when>
                                    <c:when test="${proposal.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã huỷ</span></c:when>
                                    <c:otherwise><span class="status-pill"><c:out value="${proposal.status}"/></span></c:otherwise>
                                </c:choose>
                            </span>
                        </h1>
                        <div class="lede">
                            <span>Ngày đề xuất: <c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose></span>
                            <span class="sep">·</span>
                            <span>Kho: <c:out value="${proposal.warehouseName}"/></span>
                        </div>
                    </div>

                    <%-- ============== Banners (Reject / Convert) ============== --%>
                    <c:if test="${proposal.status == 'CONVERTED' && not empty proposal.convertedReceiptCode}">
                        <div class="convert-banner">
                            <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                            <div style="flex:1;">
                                <div class="info-label">Đã chuyển thành phiếu nhập</div>
                                <div style="margin-top:4px;font-size:13.5px;">
                                    <a href="${pageContext.request.contextPath}/receipt?action=detail&id=${proposal.convertedReceiptId}" style="color:#004085;font-weight:700;font-family:var(--font-mono);">
                                        <c:out value="${proposal.convertedReceiptCode}"/>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <%-- ============== Tabs (2 tab) ============== --%>
                    <div class="tabs">
                        <button type="button" class="tab active" data-tab="overview">
                            Tổng quan
                        </button>
                        <button type="button" class="tab" data-tab="history">
                            Lịch sử cập nhật
                            <span class="tab-count">${totalHistory}</span>
                        </button>
                    </div>

                    <%-- ============== Tab Tổng quan (gộp Thông tin + Chi tiết) ============== --%>
                    <div class="tab-panel active" id="tab-overview">
                        <%-- 5) Detail Content Area: Thông tin chung (read-only grid 4 cột) --%>
                        <div class="detail-content" style="margin-bottom: 16px;">
                            <div class="dc-section-head">
                                <div class="dc-section-head-left">
                                    <span class="dc-num">01</span>
                                    <h3 class="dc-section-title">Thông tin chung</h3>
                                </div>
                                <span class="dc-section-sub">Read-only · Thông tin phiếu</span>
                            </div>

                            <%-- Dòng 1 (4 cột): Mã phiếu · Tên phiếu · Ngày đăng ký · Năm kế hoạch --%>
                            <div class="detail-grid row-4" style="margin-bottom: 16px;">
                                <div class="detail-field">
                                    <div class="df-label">Mã phiếu</div>
                                    <div class="df-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Tên phiếu</div>
                                    <div class="df-value">Phiếu đề xuất nhập kho #${proposal.proposalId}</div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Ngày đăng ký</div>
                                    <div class="df-value mono"><c:choose><c:when test="${proposal.proposalDate == null}"><span class="empty">—</span></c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Kho nhập</div>
                                    <div class="df-value"><c:out value="${proposal.warehouseName}"/></div>
                                </div>
                            </div>

                            <%-- Dòng 3 (4 cột): Cán bộ đầu mối · Người duyệt · Ngày duyệt · Trạng thái --%>
                            <div class="detail-grid row-4" style="margin-bottom: 16px;">
                                <div class="detail-field">
                                    <div class="df-label">Cán bộ đầu mối</div>
                                    <div class="df-value"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Người duyệt</div>
                                    <div class="df-value"><c:out value="${not empty proposal.approvedByName ? proposal.approvedByName : '—'}"/></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Ngày duyệt</div>
                                    <div class="df-value mono"><c:choose><c:when test="${proposal.approvedAt == null}"><span class="empty">—</span></c:when><c:otherwise>${proposal.approvedAt.format(propFmt)}</c:otherwise></c:choose></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Trạng thái</div>
                                    <div class="df-value">
                                        <c:choose>
                                            <c:when test="${proposal.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Nháp</span></c:when>
                                            <c:when test="${proposal.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                            <c:when test="${proposal.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                            <c:when test="${proposal.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                            <c:when test="${proposal.status == 'CONVERTED'}"><span class="status-pill status-converted"><span class="pdot"></span>Đã chuyển phiếu nhập</span></c:when>
                                            <c:when test="${proposal.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã huỷ</span></c:when>
                                            <c:otherwise><span class="status-pill"><c:out value="${proposal.status}"/></span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${proposal.status == 'REJECTED'}">
                                <div class="detail-grid row-4" style="margin-bottom: 16px;">
                                    <div class="detail-field">
                                        <div class="df-label">Người từ chối</div>
                                        <div class="df-value"><c:out value="${not empty proposal.rejectedByName ? proposal.rejectedByName : '—'}"/></div>
                                    </div>
                                    <div class="detail-field">
                                        <div class="df-label">Ngày từ chối</div>
                                        <div class="df-value mono"><c:choose><c:when test="${proposal.rejectedAt == null}"><span class="empty">—</span></c:when><c:otherwise>${proposal.rejectedAt.format(propFmt)}</c:otherwise></c:choose></div>
                                    </div>
                                    <div class="detail-field" style="grid-column: span 2;">
                                        <div class="df-label">Lý do từ chối</div>
                                        <div class="df-value"><c:out value="${not empty proposal.rejectReason ? proposal.rejectReason : '—'}"/></div>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty proposal.note}">
                                <div class="detail-grid row-1" style="margin-top: 6px;">
                                    <div class="detail-field">
                                        <div class="df-label">Ghi chú</div>
                                        <div class="note-soft"><c:out value="${proposal.note}"/></div>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <%-- 5b) Detail Content Area: Chi tiết máy phát đề xuất --%>
                        <div class="detail-content" style="padding: 0; margin-bottom: 16px;">
                            <div class="dc-section-head" style="padding: 18px 22px 14px 22px; border-bottom: 1px solid var(--border);">
                                <div class="dc-section-head-left">
                                    <span class="dc-num">02</span>
                                    <h3 class="dc-section-title">Chi tiết máy phát đề xuất</h3>
                                </div>
                                <span class="dc-section-sub"><c:out value="${fn:length(details)}"/> dòng hàng</span>
                            </div>
                            <c:set var="details" value="${proposal.details}" />
                            <table class="product-table" id="detailTable">
                                <thead>
                                    <tr>
                                        <th style="width:50px;">#</th>
                                        <th>Máy phát / Hãng</th>
                                        <th style="width:100px;">Số lượng</th>
                                        <th style="width:130px;">Tồn kho hiện tại</th>
                                        <th>Ghi chú</th>
                                    </tr>
                                </thead>
                                <tbody id="detailBody">
                                    <c:choose>
                                        <c:when test="${empty details}">
                                            <tr><td colspan="5" class="text-center" style="padding:32px;color:var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${details}" varStatus="st">
                                                <tr class="detail-row">
                                                    <td class="mono">${st.index + 1}</td>
                                                    <td>
                                                        <strong><c:out value="${d.generatorName}"/></strong>
                                                        <span style="color:var(--muted);"> · <c:out value="${d.brandName}"/></span>
                                                    </td>
                                                    <td class="mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                    <td class="mono"><fmt:formatNumber value="${d.currentStock}"/></td>
                                                    <td><c:out value="${d.note}"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            <c:if test="${not empty details && fn:length(details) > 10}">
                                <div style="padding: 16px 20px;">
                                    <div class="detail-pager" id="detailPagination">
                                        <button type="button" class="btn" id="prevDetailPage">‹ Trước</button>
                                        <span id="detailPageInfo"></span>
                                        <button type="button" class="btn" id="nextDetailPage">Sau ›</button>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <%-- ============== Tab Lịch sử cập nhật ============== --%>
                    <div class="tab-panel" id="tab-history">
                        <div class="detail-content" style="padding: 0;">
                            <div class="dc-section-head" style="padding: 18px 22px 14px 22px; border-bottom: 1px solid var(--border);">
                                <div class="dc-section-head-left">
                                    <span class="dc-num">03</span>
                                    <h3 class="dc-section-title">Lịch sử cập nhật</h3>
                                </div>
                                <span class="dc-section-sub">${totalHistory} bản ghi</span>
                            </div>
                            <div class="result-summary">Tìm thấy <strong>${totalHistory}</strong> bản ghi</div>
                            <table class="history-table">
                                <thead><tr>
                                    <th style="width:160px;">Thời gian</th>
                                    <th style="width:200px;">Người thực hiện</th>
                                    <th style="width:150px;">Hành động</th>
                                    <th>Chi tiết thay đổi</th>
                                </tr></thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr><td colspan="4">
                                            <div class="empty-state"><strong>Không có bản ghi nào</strong></div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td class="mono"><c:choose><c:when test="${h.createdAtAsDate == null}">—</c:when><c:otherwise>${h.createdAtAsDate.format(propFmt)}</c:otherwise></c:choose></td>
                                                <td><c:out value="${h.username}"/></td>
                                                <td>
                                                    <span class="action-badge action-<c:choose>
                                                        <c:when test="${h.action == 'CREATE'}">create</c:when>
                                                        <c:when test="${h.action == 'UPDATE'}">update</c:when>
                                                        <c:when test="${h.action == 'APPROVE'}">approve</c:when>
                                                        <c:when test="${h.action == 'REJECT'}">reject</c:when>
                                                        <c:when test="${h.action == 'CANCEL'}">cancel</c:when>
                                                        <c:when test="${h.action == 'CONVERT'}">convert</c:when>
                                                        <c:when test="${h.action == 'DELETE'}">reject</c:when>
                                                        <c:otherwise>default</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${h.action == 'CREATE'}">Tạo phiếu</c:when>
                                                        <c:when test="${h.action == 'UPDATE'}">Cập nhật</c:when>
                                                        <c:when test="${h.action == 'APPROVE'}">Duyệt</c:when>
                                                        <c:when test="${h.action == 'REJECT'}">Từ chối</c:when>
                                                        <c:when test="${h.action == 'CANCEL'}">Huỷ</c:when>
                                                        <c:when test="${h.action == 'CONVERT'}">Chuyển phiếu nhập</c:when>
                                                        <c:when test="${h.action == 'DELETE'}">Xoá</c:when>
                                                        <c:otherwise>${h.action}</c:otherwise>
                                                    </c:choose></span>
                                                </td>
                                                <td class="detail-cell"><c:out value="${h.details}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script>
            <c:if test="${not empty sessionScope.toastMessage}">
            window.SESSION_DATA = { message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>' };
            <c:remove var="toastMessage" scope="session"/>
            <c:remove var="toastType" scope="session"/>
            </c:if>
            <c:if test="${not empty requestScope.toastMessage}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${requestScope.toastMessage}"/>';
            window.SESSION_DATA.type = '<c:out value="${requestScope.toastType}"/>';
            </c:if>
        </script>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            (function () {
                var tabs = document.querySelectorAll('.tab');
                var panels = document.querySelectorAll('.tab-panel');
                tabs.forEach(function (t) {
                    t.addEventListener('click', function () {
                        var key = t.getAttribute('data-tab');
                        tabs.forEach(function (x) { x.classList.remove('active'); });
                        panels.forEach(function (p) { p.classList.remove('active'); });
                        t.classList.add('active');
                        var panel = document.getElementById('tab-' + key);
                        if (panel) panel.classList.add('active');
                    });
                });
            })();

            (function () {
                var rows = document.querySelectorAll('#detailBody .detail-row');
                if (rows.length <= 10) return;
                var pageSize = 10;
                var current = 1;
                var totalPages = Math.ceil(rows.length / pageSize);
                var info = document.getElementById('detailPageInfo');
                var prevBtn = document.getElementById('prevDetailPage');
                var nextBtn = document.getElementById('nextDetailPage');
                function render() {
                    rows.forEach(function (r, i) {
                        var page = Math.floor(i / pageSize) + 1;
                        r.style.display = (page === current) ? '' : 'none';
                    });
                    if (info) info.textContent = 'Trang ' + current + ' / ' + totalPages;
                    if (prevBtn) prevBtn.disabled = (current <= 1);
                    if (nextBtn) nextBtn.disabled = (current >= totalPages);
                }
                if (prevBtn) prevBtn.addEventListener('click', function () { if (current > 1) { current--; render(); } });
                if (nextBtn) nextBtn.addEventListener('click', function () { if (current < totalPages) { current++; render(); } });
                render();
            })();

            function openModal(id) {
                var m = document.getElementById(id);
                if (m) m.classList.add('show');
            }
            function closeModal(id) {
                var m = document.getElementById(id);
                if (m) m.classList.remove('show');
            }
        </script>
    </body>
</html>
