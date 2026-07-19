
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    java.time.format.DateTimeFormatter __propFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đề xuất nhập kho — Warehouse OS</title>
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
            .info-select {
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
            .info-select:disabled {
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
            .status-pending,
            .status-pending_ceo { background: #fff3cd; color: #856404; border-color: color-mix(in srgb, #856404 25%, transparent); }
            .status-approved { background: #d4edda; color: #155724; border-color: color-mix(in srgb, #155724 25%, transparent); }
            .status-rejected { background: #f8d7da; color: #721c24; border-color: color-mix(in srgb, #721c24 25%, transparent); }
            .status-revision { background: #ede9fe; color: #5b21b6; border-color: color-mix(in srgb, #5b21b6 25%, transparent); }
            .status-cancelled { background: #e2e3e5; color: #383d41; border-color: #c4c5c7; }
            .status-deleted { background: #6c757d; color: #ffffff; border-color: #565e64; }

            
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
                    <h1>Chi tiết đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal?action=list">Đề xuất nhập kho</a> / <span><c:out value="${proposal.proposalCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
<<<<<<< HEAD
                    <c:choose>
=======
<c:choose>
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                    <c:when test="${proposal.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusPillClass" value="status-pending"/>
                        </c:when>
                        <c:when test="${proposal.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                            <c:set var="statusPillClass" value="status-pending_ceo"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED' and not empty proposal.purchaseOrderId}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:when test="${proposal.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Cần chỉnh sửa"/>
                            <c:set var="statusPillClass" value="status-revision"/>
                        </c:when>
                        <c:when test="${proposal.status == 'DELETED'}">
                            <c:set var="statusLabel" value="Đã xoá"/>
                            <c:set var="statusPillClass" value="status-deleted"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApprove" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.approve')}" />
                    <c:set var="canReject" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.reject')}" />
                    <c:set var="canCancelProp" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.cancel')}" />
                    <c:set var="hasLockedPO" value="${not empty proposal.purchaseOrderId}" />


                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại danh sách
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Phiếu đề xuất -</span>
                                <span><c:out value="${proposal.proposalCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${proposal.proposalCode}"/>
                                <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                            </h2>
                        </div>
                        <div class="right">

<<<<<<< HEAD
                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && isOwner}">
=======

                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && isOwner && !isViewingDeleted}">
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Chỉnh sửa
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gửi duyệt lại
                                </button>
                            </c:if>

                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && proposal.revisionRequestedByRole == 'CEO' && canApprove && !isViewingDeleted}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Sửa đề xuất (yêu cầu từ CEO)
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gửi duyệt lại
                                </button>
                            </c:if>

<<<<<<< HEAD
                            <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner}">
=======
                            <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                                <button type="button" class="btn btn-danger" onclick="openModal('deleteModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                    Xoá
                                </button>
                            </c:if>

<<<<<<< HEAD
                            <c:if test="${proposal.status == 'PENDING' && canApprove}">
=======
                            <c:if test="${proposal.status == 'PENDING' && canApprove && !isViewingDeleted}">
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Xác nhận
                                </button>
                                <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Yêu cầu chỉnh sửa
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canReject && !isViewingDeleted}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>

                         
                        </div>
                    </div>

                    <c:set var="canViewPoDetail" value="${canViewPo or (not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('purchase_orders.view'))}" />
                    <c:if test="${not empty proposal.purchaseOrderId}">
                        <c:choose>
                            <c:when test="${canViewPoDetail}">
                                <div class="alert alert-info">
                                    <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                    <span>Đã gom vào <strong>Phiếu mua</strong>: <strong><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${proposal.purchaseOrderId}" style="font-family: 'JetBrains Mono', monospace; color: var(--accent); text-decoration: none; font-weight: 700;" title="Xem chi tiết phiếu mua">${proposal.poCode}</a></strong>. Phiếu này bị khóa sửa.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                    <span>Đã gom vào <strong>Phiếu mua</strong> (<strong style="font-family: 'JetBrains Mono', monospace; color: var(--muted);"><c:out value="${proposal.poCode}"/></strong>). Phiếu này bị khóa sửa.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <c:set var="showDeadlineBanner" value="${not empty proposal.period}" />
                    <c:if test="${isViewingDeleted}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                            <span>
                                <strong>Phiếu này đã bị xoá.</strong>
                                <c:choose>
                                    <c:when test="${not empty proposal.cancelledAt}">
                                        Đã xoá lúc <strong style="font-family:'JetBrains Mono',monospace;">${proposal.cancelledAt.format(propFmt)}</strong>.
                                    </c:when>
                                </c:choose>
                                Phiếu đã được ẩn khỏi danh sách chung, chỉ bạn (người tạo) có thể xem lại ở chế độ chỉ đọc.
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${showDeadlineBanner}">
                        <div class="alert ${isWithinDeadline ? 'alert-info' : 'alert-warn'}">
                            <svg viewBox="0 0 24 24" width="20" height="20"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <span>
                                <strong>Deadline gom đơn / duyệt cho period ${proposal.period}:</strong>
                                <c:choose>
                                    <c:when test="${isWithinDeadline}">
                                        còn hiệu lực đến <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>
                                        (5 ngày đầu tháng kế tiếp).
                                    </c:when>
                                    <c:otherwise>
                                        đã <strong style="color:var(--danger);">quá hạn</strong> từ
                                        <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>.
                                        Các thao tác duyệt/từ chối/yêu cầu chỉnh sửa đã bị khóa.
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>


                    <div class="section">
                        <div class="section-head">
                            <h3>Thông tin chung</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Mã phiếu đề xuất</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tên phiếu đề xuất</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày đề xuất</label>
                                    <input class="info-input" type="date" disabled value="${proposalDateInput}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng số lượng máy</label>
                                    <input class="info-input mono" type="number" disabled value="${totalQty}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng kinh phí dự kiến (VNĐ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${grandTotal}' pattern='#,##0'/> ₫">
                                </div>
                            </div>
                            <div class="form-grid cols-4" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>Cán bộ đầu mối lập phiếu</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${proposal.createdByName}"/></option>
                                    </select>
                                    <span class="info-icon" title="Người tạo phiếu đề xuất">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Kho đề xuất nhập</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${not empty proposal.warehouseName ? proposal.warehouseName : '—'}"/></option>
                                    </select>
                                </div>
                                <div class="info-field">
                                    <label>Người xác nhận</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty proposal.approvedByName ? proposal.approvedByName : ""}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày xác nhận</label>
                                    <input class="info-input" type="datetime-local" disabled value="${approvedAtInput}">
                                </div>
                            </div>
                        </div>
                    </div>

      
                    <div class="section">
                        <div class="section-head">
                            <h3>Danh sách máy phát đăng ký</h3>
                        </div>

                        <div class="tab-bar">
                            <a href="#" class="tab ${currentTab != 'history' ? 'active' : ''}" data-tab="generators">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                Máy phát điện đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <span class="tab-badge">${totalHistory}</span>
                            </a>
                        </div>


                        <div class="tab-panel ${currentTab != 'history' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="genSearch" placeholder="Tìm kiếm thông tin..." autocomplete="off"/>
                                </div>
                                <div class="spacer"></div>
                                <button type="button" class="btn" title="Xuất file (đang phát triển)">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    Xuất file
                                </button>
                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="genTable">
                                    <thead>
                                        <tr>
                                            <th>Mã máy phát</th>
                                            <th>Tên máy phát</th>
                                            <th>Hãng</th>
                                            <th>Công suất</th>
                                            <th class="text-right">SL</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Lý do chỉnh sửa/từ chối</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty proposal.details}">
                                                <tr><td colspan="10">
                                                    <div class="empty-state">
                                                        <div class="icon-wrap">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                        </div>
                                                        <strong>Chưa có máy phát nào trong phiếu đề xuất</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr data-row-id="${d.proposalDetailId}"
                                                        data-search="<c:out value='${d.generatorCode} ${d.generatorName} ${d.brandName} ${d.supplierName}'/>"
                                                        data-status="${proposal.status}">
                                                        <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                        <td><strong><c:out value="${d.generatorName}"/></strong></td>
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td class="mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.powerRating}"><c:out value="${d.powerRating}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice * d.quantity}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.supplierName}"><c:out value="${d.supplierName}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.note}"><c:out value="${d.note}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty proposal.details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="6" class="text-right" style="padding: 12px 14px;">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫
                                                </td>
                                                <td colspan="3"></td>
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
                        </div>


                        <div class="tab-panel ${currentTab == 'history' ? 'active' : ''}" data-panel="history">
                            <form method="get" action="${pageContext.request.contextPath}/proposal" class="history-filter-bar">
                                <input type="hidden" name="action" value="detail"/>
                                <input type="hidden" name="id" value="${proposal.proposalId}"/>
                                <input type="hidden" name="tab" value="history"/>
                                <input type="hidden" name="page" value="1"/>

                                <div class="search-input hf-search">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                </div>
                                <select name="logAction" class="filter-select">
                                    <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                    <option value="CREATE"     ${logAction == 'CREATE' ? 'selected' : ''}>Tạo phiếu</option>
                                    <option value="UPDATE"     ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                    <option value="APPROVE"    ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                    <option value="REJECT"     ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                    <option value="REVISION"   ${logAction == 'REVISION' ? 'selected' : ''}>Yêu cầu chỉnh sửa</option>
                                    
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
                                    <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="btn">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history">xóa lọc</a></span>
                                                    </c:if>
                                                </div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="h" items="${logList}">
                                                <tr>
                                                    <td class="mono">
                                                        <c:choose>
                                                            <c:when test="${h.createdAt == null}">—</c:when>
                                                            <c:otherwise>${h.createdAt.format(propFmt)}</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><strong><c:out value="${h.username}"/></strong></td>
                                                    <td>
                                                        <span class="action-badge action-<c:choose>
                                                            <c:when test="${h.action == 'CREATE'}">create</c:when>
                                                            <c:when test="${h.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${h.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${h.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${h.action == 'REVISION'}">revision</c:when>
                                                            <c:when test="${h.action == 'CANCEL'}">cancel</c:when>
                                                            <c:otherwise>cancel</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${h.action == 'CREATE'}">Tạo phiếu</c:when>
                                                            <c:when test="${h.action == 'UPDATE'}">Cập nhật</c:when>
                                                            <c:when test="${h.action == 'APPROVE'}">Duyệt</c:when>
                                                            <c:when test="${h.action == 'REJECT'}">Từ chối</c:when>
                                                            <c:when test="${h.action == 'REVISION'}">Yêu cầu sửa</c:when>
                                                            
                                                            <c:otherwise>${h.action}</c:otherwise>
                                                        </c:choose>
                                                        </span>
                                                    </td>
                                                    <td style="max-width:480px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                        <c:out value="${h.details}"/>
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
                                        <a href="${pageContext.request.contextPath}/proposal?action=detail&amp;id=${proposal.proposalId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${logTotalPages}" var="p">
                                        <c:choose>
                                            <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                            <c:otherwise><a href="${pageContext.request.contextPath}/proposal?action=detail&amp;id=${proposal.proposalId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${logPage < logTotalPages}">
                                        <a href="${pageContext.request.contextPath}/proposal?action=detail&amp;id=${proposal.proposalId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
                                    </c:if>
                                </div>
                            </div>
                            </c:if>
                        </div>
                    </div>
                </main>
            </div>
        </div>

 
        <c:if test="${proposal.status == 'PENDING' && canApprove}">
            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub">Gửi phiếu lại cho nhân viên tạo đề xuất kèm lý do để chỉnh sửa và gửi lại.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=revision" id="revisionForm">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="revisionReason" id="revisionReason" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu đề xuất sẽ chuyển sang trạng thái "Đã duyệt" và có thể được gom vào phiếu mua.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && canReject}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối</h3>
                    <div class="modal-sub">Phiếu sẽ bị từ chối và không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=reject">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <label for="rejectReason">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="rejectReason" required placeholder="Ví dụ: Số lượng vượt nhu cầu, máy chưa có trong kho..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && canCancelProp}">
            <div class="modal-host" id="cancelModal">
                <div class="modal-card">
                    <h3>Huỷ phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu đề xuất sẽ bị huỷ. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('cancelModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận huỷ</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

<<<<<<< HEAD
        <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner}">
            <div class="modal-host" id="deleteModal">
                <div class="modal-card">
                    <h3>Xoá phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu sẽ bị xoá hoàn toàn khỏi hệ thống. Hành động này không thể hoàn tác.</div>
=======
        <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
            <div class="modal-host" id="deleteModal">
                <div class="modal-card">
                    <h3>Xoá phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu sẽ được chuyển sang trạng thái <strong>Đã xoá</strong> và ẩn khỏi danh sách chung. Bạn vẫn có thể xem lại ở chế độ chỉ đọc.</div>
>>>>>>> 43e4ad0e5deebd88847eabeffbcf9cd1a13a3749
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('deleteModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận xoá</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && !isViewingDeleted && (isOwner || (proposal.revisionRequestedByRole == 'CEO' && canApprove))}">
            <div class="modal-host" id="resubmitModal">
                <div class="modal-card">
                    <h3>Gửi duyệt lại</h3>
                    <div class="modal-sub">Phiếu sẽ chuyển sang trạng thái "Chờ duyệt" để Sale Manager xem xét lại sau khi đã chỉnh sửa.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <input type="hidden" name="submitType" value="submit" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('resubmitModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Gửi duyệt lại</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <div class="toast-host" id="toastHost"></div>

        <script>
            <c:if test="${not empty sessionScope.toastMessage}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${sessionScope.toastMessage}"/>';
            window.SESSION_DATA.type = '<c:out value="${sessionScope.toastType != null ? sessionScope.toastType : 'success'}"/>';
                <c:remove var="toastMessage" scope="session"/>
                <c:remove var="toastType" scope="session"/>
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

                var search = document.getElementById('genSearch');
                var table = document.getElementById('genTable');
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