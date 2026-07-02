<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __ordFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    java.time.format.DateTimeFormatter __ordDateFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
    java.time.format.DateTimeFormatter __ordDtFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    request.setAttribute("ordFmt", __ordFmt);
    request.setAttribute("ordDateFmt", __ordDateFmt);
    request.setAttribute("ordDtFmt", __ordDtFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }
            .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
            .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
            .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
            .alert-info { background: var(--info-soft); color: var(--info); border: 1px solid color-mix(in srgb, var(--info) 25%, transparent); }

            .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
            .danger-note { background: color-mix(in srgb, var(--danger-soft) 70%, transparent); color: var(--danger); padding: 14px; border-radius: var(--radius-sm); border-left: 3px solid var(--danger); white-space: pre-wrap; line-height: 1.55; }

            
            .header-bar {
                display: flex;
                gap: 20px;
                align-items: flex-start;
                justify-content: space-between;
                flex-wrap: wrap;
                margin-bottom: 18px;
            }
            .header-bar .left {
                flex: 1;
                min-width: 240px;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .code-tag {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 7px 14px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-family: var(--font-mono);
                font-size: 12.5px;
                font-weight: 600;
                background: var(--surface);
                color: var(--fg);
                width: fit-content;
            }
            .code-tag .ct-label {
                color: var(--muted);
                font-weight: 500;
            }
            .page-main-title {
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                letter-spacing: -0.02em;
                display: flex;
                gap: 12px;
                align-items: center;
                flex-wrap: wrap;
            }
            .header-bar .right {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                align-items: center;
                align-content: flex-start;
            }

            
            .section {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 16px;
            }
            .section-head {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
                padding: 14px 20px;
                border-bottom: 1px solid var(--border);
                background: var(--surface);
            }
            .section-head h3 {
                font-size: 14px;
                font-weight: 700;
                margin: 0;
            }
            .section-body {
                padding: 20px;
            }

            
            .form-grid {
                display: grid;
                gap: 14px 18px;
            }
            .form-grid.cols-5 { grid-template-columns: repeat(5, 1fr); }
            .form-grid.cols-4 { grid-template-columns: repeat(4, 1fr); }
            .form-grid.cols-2 { grid-template-columns: repeat(2, 1fr); }
            @media (max-width: 1280px) {
                .form-grid.cols-5 { grid-template-columns: repeat(3, 1fr); }
                .form-grid.cols-4 { grid-template-columns: repeat(2, 1fr); }
            }
            @media (max-width: 760px) {
                .form-grid.cols-5,
                .form-grid.cols-4,
                .form-grid.cols-2 { grid-template-columns: 1fr; }
            }
            .info-field {
                display: flex;
                flex-direction: column;
                gap: 6px;
                min-width: 0;
                position: relative;
            }
            .info-field label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
            }
            .info-input,
            .info-select,
            .info-textarea {
                font-family: var(--font-ui);
                font-size: 13px;
                color: var(--fg);
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                padding: 9px 11px;
                width: 100%;
                line-height: 1.4;
                box-sizing: border-box;
            }
            .info-input:disabled,
            .info-select:disabled,
            .info-textarea:disabled {
                opacity: 0.85;
                cursor: not-allowed;
            }
            .info-select {
                appearance: none;
                background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");
                background-repeat: no-repeat;
                background-position: right 8px center;
                background-size: 12px;
                padding-inline-end: 28px;
            }
            .info-input.mono {
                font-family: var(--font-mono);
                font-variant-numeric: tabular-nums;
            }
            .info-field.with-info-icon .info-input,
            .info-field.with-info-icon .info-select {
                padding-right: 32px;
            }
            .info-field .info-icon {
                position: absolute;
                right: 8px;
                bottom: 9px;
                width: 18px;
                height: 18px;
                border-radius: 50%;
                background: var(--surface);
                color: var(--muted);
                display: grid;
                place-items: center;
                font-size: 11px;
                font-weight: 700;
                border: 1px solid var(--border);
                pointer-events: none;
            }
            .info-field.full { grid-column: 1 / -1; }

            
            .tab-bar {
                display: flex;
                gap: 4px;
                padding: 0 16px;
                border-bottom: 1px solid var(--border);
                background: var(--surface);
            }
            .tab {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 12px 16px;
                font-size: 13px;
                font-weight: 600;
                color: var(--muted);
                text-decoration: none;
                border-bottom: 2px solid transparent;
                margin-bottom: -1px;
                transition: all .12s ease;
                cursor: pointer;
            }
            .tab:hover { color: var(--fg); }
            .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
            .tab-icon { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2; }
            .tab-badge {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                min-width: 18px;
                height: 18px;
                padding: 0 6px;
                font-family: var(--font-mono);
                font-size: 11px;
                font-weight: 700;
                background: var(--surface-2);
                border: 1px solid var(--border);
                color: var(--muted);
                border-radius: 999px;
            }
            .tab.active .tab-badge {
                background: var(--accent-soft);
                color: var(--accent);
                border-color: color-mix(in srgb, var(--accent) 30%, transparent);
            }

            .tab-panel { display: none; }
            .tab-panel.active { display: block; }

            
            .table-toolbar {
                display: flex;
                gap: 10px;
                align-items: center;
                flex-wrap: wrap;
                padding: 12px 14px;
                background: var(--surface);
                border-top: 1px solid var(--border);
                border-bottom: 1px solid var(--border);
            }
            .table-toolbar .spacer { flex: 1; }

            
            .product-table { width: 100%; border-collapse: collapse; }
            .product-table th, .product-table td {
                padding: 11px 14px;
                text-align: left;
                border-bottom: 1px solid var(--border);
                vertical-align: middle;
            }
            .product-table th {
                font-size: 11px;
                color: var(--muted);
                text-transform: uppercase;
                font-weight: 700;
                background: var(--surface-2);
                letter-spacing: 0.04em;
            }
            .product-table td { font-size: 13px; }
            .product-table tbody tr:hover { background: var(--surface-2); }
            .product-table tfoot td {
                background: var(--surface-2);
                font-weight: 700;
                border-top: 2px solid var(--border);
            }
            .text-center { text-align: center; }
            .text-right { text-align: right; }
            .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }

            
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 11.5px;
                font-weight: 600;
                padding: 3px 9px;
                border-radius: 999px;
                border: 1px solid;
                white-space: nowrap;
            }
            .status-pill .pdot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
            }
            .status-draft { background: #e2e3e5; color: #383d41; border-color: #c4c5c7; }
            .status-pending { background: #fff3cd; color: #856404; border-color: color-mix(in srgb, #856404 25%, transparent); }
            .status-approved { background: #d4edda; color: #155724; border-color: color-mix(in srgb, #155724 25%, transparent); }
            .status-rejected { background: #f8d7da; color: #721c24; border-color: color-mix(in srgb, #721c24 25%, transparent); }
            .status-revision { background: #ede9fe; color: #5b21b6; border-color: color-mix(in srgb, #5b21b6 25%, transparent); }
            .status-cancelled { background: #e2e3e5; color: #383d41; border-color: #c4c5c7; }

            
            .empty-state {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 48px 16px;
                gap: 8px;
                color: var(--muted);
            }
            .empty-state .icon-wrap {
                width: 44px;
                height: 44px;
                border-radius: 50%;
                background: var(--surface-2);
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .empty-state .icon-wrap svg {
                width: 22px;
                height: 22px;
                stroke: var(--muted);
            }
            .empty-state strong {
                color: var(--fg);
                font-size: 14px;
            }

            
            .history-filter-bar {
                display: flex;
                gap: 10px;
                align-items: center;
                flex-wrap: wrap;
                padding: 12px 14px;
                background: var(--surface);
                border-top: 1px solid var(--border);
                border-bottom: 1px solid var(--border);
            }
            .history-filter-bar .hf-search { flex: 1; min-width: 200px; max-width: 320px; }
            .history-filter-bar .date-range { display: inline-flex; align-items: center; gap: 6px; }
            .history-filter-bar .date-label { font-size: 11px; color: var(--muted); font-weight: 600; }
            .history-filter-bar .date-input {
                border: 1px solid var(--border);
                background: var(--surface-2);
                color: var(--fg);
                border-radius: var(--radius-sm);
                padding: 6px 10px;
                font-size: 12.5px;
                font-family: var(--font-ui);
                font-weight: 600;
            }

            .result-summary {
                padding: 10px 14px;
                font-size: 12.5px;
                color: var(--muted);
                background: var(--surface-2);
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .filter-active-badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 999px;
                background: var(--accent-soft);
                color: var(--accent);
                font-weight: 600;
                font-size: 11px;
            }

            
            .modal-host {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.45);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 100;
                padding: 20px;
            }
            .modal-host.show { display: flex; }
            .modal-card {
                background: var(--bg);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 22px;
                width: 100%;
                max-width: 480px;
            }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-card .modal-sub {
                font-size: 12.5px;
                color: var(--muted);
                margin-bottom: 14px;
                line-height: 1.5;
            }
            .modal-card label {
                display: block;
                font-size: 11px;
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-bottom: 6px;
            }
            .modal-card textarea {
                width: 100%;
                padding: 9px 12px;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--bg);
                color: var(--fg);
                font-size: 13px;
                font-family: var(--font-ui);
                box-sizing: border-box;
                min-height: 80px;
                resize: vertical;
            }
            .modal-card textarea:focus {
                outline: none;
                border-color: var(--accent);
                box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent);
            }
            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 8px;
                margin-top: 16px;
            }

            .action-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 11px;
                font-weight: 700;
                padding: 2px 9px;
                border-radius: 999px;
                border: 1px solid;
                text-transform: uppercase;
                letter-spacing: 0.02em;
                font-family: var(--font-ui);
            }
            .action-badge.action-create   { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent);  background: var(--accent-soft); }
            .action-badge.action-update   { color: var(--info);   border-color: color-mix(in srgb, var(--info) 32%, transparent);    background: var(--info-soft); }
            .action-badge.action-approve  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent);  background: var(--accent-soft); }
            .action-badge.action-reject   { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 32%, transparent);  background: var(--danger-soft); }
            .action-badge.action-revision { color: #7c3aed;        border-color: color-mix(in srgb, #7c3aed 32%, transparent);         background: color-mix(in srgb, #7c3aed 8%, transparent); }
            .action-badge.action-cancel   { color: var(--muted);  border-color: var(--border); background: var(--surface-2); }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết đơn hàng</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / <span><c:out value="${order.orderCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <button type="button" class="btn" onclick="window.print()" title="In đơn hàng">
                            <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                            In đơn
                        </button>
                    </div>
                </header>

                <main>
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusPillClass" value="status-pending"/>
                        </c:when>
                        <c:when test="${order.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${order.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:when test="${order.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Yêu cầu chỉnh sửa"/>
                            <c:set var="statusPillClass" value="status-revision"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApproveNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canRejectNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canRevisionNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canCancelNow" value="${order.status == 'PENDING' && canApproveOrder && canCancelOrder}" />

                    <%-- ============================================================
                         HEADER BAR
                         ============================================================ --%>
                    <div class="header-bar">
                        <div class="left">
                            <span class="code-tag">
                                <span class="ct-label">Đơn hàng -</span>
                                <span><c:out value="${order.orderCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${order.orderCode}"/>
                                <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                            </h2>
                        </div>
                        <div class="right">
                            <a class="btn" href="${pageContext.request.contextPath}/order?action=list">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại
                            </a>
                            <button type="button" class="btn" onclick="location.reload()">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
                                Làm mới
                            </button>
                            <button type="button" class="btn" disabled>
                                <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                Lưu
                            </button>
                            <c:if test="${canApproveNow}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Xác nhận
                                </button>
                            </c:if>
                            <c:if test="${canRevisionNow}">
                                <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Yêu cầu chỉnh sửa
                                </button>
                            </c:if>
                            <c:if test="${canRejectNow}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>
                            <c:if test="${canCancelNow}">
                                <button type="button" class="btn" onclick="openModal('cancelModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Hủy đơn
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <c:if test="${order.status == 'NEEDS_REVISION' && order.createdBy == sessionScope.loggedUser.id}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            <span>Đơn hàng cần được chỉnh sửa theo yêu cầu của Sale Manager. <a href="${pageContext.request.contextPath}/order?action=edit&id=${order.orderId}" style="color:inherit;text-decoration:underline;font-weight:700;">Sửa lại &amp; Gửi duyệt</a></span>
                        </div>
                    </c:if>

                    <%-- ============================================================
                         KHỐI 1: THÔNG TIN CHUNG
                         ============================================================ --%>
                    <div class="section">
                        <div class="section-head">
                            <h3>Thông tin chung</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Mã đơn hàng</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${order.orderCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tên đơn hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${order.orderCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày đặt</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatDate value='${order.orderDate}' pattern='dd/MM/yyyy HH:mm'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tổng số lượng máy</label>
                                    <input class="info-input mono" type="number" disabled value="${totalQty}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng kinh phí (VNĐ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${order.totalAmount}' pattern='#,##0'/> ₫">
                                </div>
                            </div>
                            <div class="form-grid cols-4" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>Khách hàng</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${not empty order.customer.name ? order.customer.name : '—'}"/></option>
                                    </select>
                                    <span class="info-icon" title="Khách hàng đặt đơn">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Số điện thoại</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${not empty order.customer.phone ? order.customer.phone : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Loại khách hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty customerTypeName ? customerTypeName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Địa chỉ giao hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.customer.address ? order.customer.address : "—"}'/>">
                                </div>
                            </div>
                            <div class="form-grid cols-2" style="margin-top: 14px;">
                                <div class="info-field">
                                    <label>Email</label>
                                    <input class="info-input mono" type="email" disabled value="<c:out value='${not empty order.customer.email ? order.customer.email : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Công ty</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.customer.companyName ? order.customer.companyName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Người tạo</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.createdByName ? order.createdByName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Người duyệt</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${order.approvedBy != 0 && not empty order.approvedByName ? order.approvedByName : "—"}'/>">
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- ============================================================
                         KHỐI 2: DANH SÁCH MÁY PHÁT
                         ============================================================ --%>
                    <div class="section">
                        <div class="section-head">
                            <h3>Danh sách máy phát đăng ký</h3>
                        </div>

                        <div class="tab-bar">
                            <a href="#" class="tab ${currentTab != 'history' ? 'active' : ''}" data-tab="generators">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                Sản phẩm đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <span class="tab-badge">${totalLogs}</span>
                            </a>
                        </div>

                        <%-- ============ Tab 1: Bảng sản phẩm ============ --%>
                        <div class="tab-panel ${currentTab != 'history' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="ordSearch" placeholder="Tìm kiếm thông tin..." autocomplete="off"/>
                                </div>
                                <div class="spacer"></div>
                                <button type="button" class="btn" title="Xuất file (đang phát triển)">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    Xuất file
                                </button>
                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="ordTable">
                                    <thead>
                                        <tr>
                                            <th>Mã máy phát</th>
                                            <th>Tên sản phẩm</th>
                                            <th class="text-right">Số lượng</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                            <th>Ghi chú</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty details}">
                                                <tr><td colspan="7">
                                                    <div class="empty-state">
                                                        <div class="icon-wrap">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                        </div>
                                                        <strong>Chưa có sản phẩm nào trong đơn hàng</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${details}" varStatus="st">
                                                    <tr data-row-id="${st.index}"
                                                        data-search="<c:out value='${d.generatorId} ${d.generatorModel}'/>"
                                                        data-status="${order.status}">
                                                        <td class="mono"><c:out value="${d.generatorId}"/></td>
                                                        <td><strong><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${d.generatorId}"><c:out value="${d.generatorModel}"/></a></strong></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                        <td class="text-right mono" style="font-weight:600;"><fmt:formatNumber value="${d.quantity * d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                        <td><c:out value="${d.note}"/></td>
                                                        <td>
                                                            <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="4" class="text-right" style="padding: 12px 14px;">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td colspan="2"></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                            </div>

                            <div class="pagination">
                                <div class="info">
                                    Hiển thị <strong>1</strong> – <strong>${totalRows}</strong> của <strong>${totalRows}</strong> bản ghi
                                </div>
                                <div class="controls">
                                    <button class="page-btn" disabled>‹ Trước</button>
                                    <span class="page-btn active">1</span>
                                    <button class="page-btn" disabled>Sau ›</button>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${order.status == 'REJECTED' && not empty order.rejectReason}">
                                    <div style="padding: 18px 20px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do từ chối</div>
                                        <div class="danger-note"><c:out value="${order.rejectReason}"/></div>
                                    </div>
                                </c:when>
                                <c:when test="${order.status == 'NEEDS_REVISION' && not empty order.revisionReason}">
                                    <div style="padding: 18px 20px;">
                                        <div class="info-label" style="font-size:11px;color:#b15c00;font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do yêu cầu chỉnh sửa</div>
                                        <div class="note-soft" style="border-left:3px solid #b15c00;"><c:out value="${order.revisionReason}"/></div>
                                    </div>
                                </c:when>
                            </c:choose>
                            <c:if test="${not empty order.note}">
                                <div style="padding: 0 20px 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú nội bộ</div>
                                    <div class="note-soft"><c:out value="${order.note}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.customerNote}">
                                <div style="padding: 0 20px 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú của khách hàng</div>
                                    <div class="note-soft"><c:out value="${order.customerNote}"/></div>
                                </div>
                            </c:if>
                        </div>

                        <%-- ============ Tab 2: Lịch sử ============ --%>
                        <div class="tab-panel ${currentTab == 'history' ? 'active' : ''}" data-panel="history">
                            <form method="get" action="${pageContext.request.contextPath}/order" class="history-filter-bar">
                                <input type="hidden" name="action" value="detail"/>
                                <input type="hidden" name="id" value="${order.orderId}"/>
                                <input type="hidden" name="tab" value="history"/>
                                <input type="hidden" name="page" value="1"/>

                                <div class="search-input hf-search">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                </div>
                                <select name="logAction" class="filter-select">
                                    <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                    <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo đơn hàng</option>
                                    <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                    <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                    <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                    <option value="CANCEL" ${logAction == 'CANCEL' ? 'selected' : ''}>Hủy đơn</option>
                                </select>
                                <div class="date-range">
                                    <label class="date-label">Từ</label>
                                    <input type="date" name="dateFrom" value="${dateFrom}" class="date-input"/>
                                    <label class="date-label">đến</label>
                                    <input type="date" name="dateTo"   value="${dateTo}"   class="date-input"/>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    Áp dụng
                                </button>
                                <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                    <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history" class="btn">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                        Xóa lọc
                                    </a>
                                </c:if>
                            </form>

                            <div class="result-summary">
                                Tìm thấy <strong>${totalLogs}</strong> bản ghi
                                <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                    &nbsp;—&nbsp;<span class="filter-active-badge">Bộ lọc đang hoạt động</span>
                                </c:if>
                            </div>

                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th style="width:170px;">Thời gian</th>
                                        <th style="width:200px;">Người thực hiện</th>
                                        <th style="width:170px;">Hành động</th>
                                        <th>Chi tiết thay đổi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty logList}">
                                            <tr><td colspan="4">
                                                <div class="empty-state">
                                                    <div class="icon-wrap">
                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                    </div>
                                                    <strong>Không có bản ghi nào</strong>
                                                    <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history">xóa lọc</a></span>
                                                    </c:if>
                                                </div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="log" items="${logList}">
                                                <tr>
                                                    <td class="mono"><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td><strong><c:out value="${log.user}"/></strong></td>
                                                    <td>
                                                        <span class="action-badge action-<c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">create</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${log.action == 'CANCEL'}">cancel</c:when>
                                                            <c:otherwise>cancel</c:otherwise>
                                                        </c:choose>">
                                                        <c:out value="${log.actionLabel}"/>
                                                        </span>
                                                    </td>
                                                    <td style="max-width:480px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                        <c:out value="${log.details}"/>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>

                            <c:if test="${logTotalPages > 1}">
                            <div class="pagination">
                                <div class="info">Hiển thị <strong>${(logPage-1)*20 + 1}</strong>–<strong>${logPage*20 > totalLogs ? totalLogs : logPage*20}</strong> / <strong>${totalLogs}</strong> bản ghi</div>
                                <div class="controls">
                                    <c:if test="${logPage > 1}">
                                        <a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${logTotalPages}" var="p">
                                        <c:choose>
                                            <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                            <c:otherwise><a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${logPage < logTotalPages}">
                                        <a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
                                    </c:if>
                                </div>
                            </div>
                            </c:if>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <%-- ============================================================
             MODALS
             ============================================================ --%>
        <c:if test="${canApproveNow}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt đơn hàng</h3>
                    <div class="modal-sub">Đơn hàng sẽ chuyển sang trạng thái "Đã duyệt". Vui lòng kiểm tra tồn kho trước khi xác nhận.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=approve">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canCancelNow}">
            <div class="modal-host" id="cancelModal">
                <div class="modal-card">
                    <h3>Hủy đơn hàng</h3>
                    <div class="modal-sub">Đơn hàng sẽ bị hủy. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=cancel">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('cancelModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRejectNow}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối đơn hàng</h3>
                    <div class="modal-sub">Đơn hàng sẽ bị huỷ. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=reject">
                        <input type="hidden" name="orderId" value="${order.orderId}" />
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="rejectReason" required placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, thông tin chưa hợp lệ..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRevisionNow}">
            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub">Gửi đơn hàng lại cho nhân viên tạo đơn kèm lý do để chỉnh sửa và gửi lại.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=requestRevision" id="revisionForm">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="reason" id="revisionReason" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <div class="toast-host" id="toastHost"></div>

        <script>
            <c:if test="${not empty sessionScope.message}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${sessionScope.message}"/>';
            window.SESSION_DATA.type = '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>';
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>
        </script>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script>
            if (window.SESSION_DATA && window.SESSION_DATA.message) {
                if (typeof showToast === 'function') {
                    showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                } else if (typeof toast === 'function') {
                    toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
                } else {
                    alert(window.SESSION_DATA.message);
                }
                window.SESSION_DATA = null;
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            function openModal(id) { var m = document.getElementById(id); if (m) m.classList.add('show'); }
            function closeModal(id) { var m = document.getElementById(id); if (m) m.classList.remove('show'); }
            document.querySelectorAll('.modal-host').forEach(function (m) {
                m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
                }
            });

            (function () {
                var tabs = document.querySelectorAll('.tab-bar .tab');
                var panels = document.querySelectorAll('.tab-panel');
                tabs.forEach(function (t) {
                    t.addEventListener('click', function (e) {
                        var target = t.getAttribute('data-tab');
                        if (target === 'history') {
                            return;
                        }
                        e.preventDefault();
                        tabs.forEach(function (x) { x.classList.remove('active'); });
                        panels.forEach(function (p) { p.classList.remove('active'); });
                        t.classList.add('active');
                        var panel = document.querySelector('.tab-panel[data-panel="' + target + '"]');
                        if (panel) panel.classList.add('active');
                        if (window.history && window.history.pushState) {
                            var url = window.location.href.split('?')[0];
                            window.history.pushState({}, '', url);
                        }
                    });
                });

                var search = document.getElementById('ordSearch');
                var table = document.getElementById('ordTable');
                if (table) {
                    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr[data-row-id]'));
                    function applyFilter() {
                        var q = (search && search.value ? search.value : '').toLowerCase().trim();
                        rows.forEach(function (r) {
                            var haystack = (r.getAttribute('data-search') || '').toLowerCase();
                            var matchText = !q || haystack.indexOf(q) !== -1;
                            r.style.display = matchText ? '' : 'none';
                        });
                    }
                    if (search) search.addEventListener('input', applyFilter);
                    applyFilter();
                }
            })();
        </script>
    </body>
</html>
