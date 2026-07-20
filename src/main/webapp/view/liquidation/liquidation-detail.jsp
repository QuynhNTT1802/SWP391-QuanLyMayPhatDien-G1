<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết thanh lý — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css?v=20260703">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
        .alert-info { background: var(--info-soft); color: var(--info); border: 1px solid color-mix(in srgb, var(--info) 25%, transparent); }
        .alert-danger { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }

        /* ===== HEADER BAR ===== */
        .header-bar { display: flex; gap: 20px; align-items: flex-start; justify-content: space-between; flex-wrap: wrap; margin-bottom: 18px; }
        .header-bar .left { flex: 1; min-width: 240px; display: flex; flex-direction: column; gap: 10px; }
        .code-tag { display: inline-flex; align-items: center; gap: 8px; padding: 7px 14px; border: 1px solid var(--border); border-radius: 8px; font-family: var(--font-mono); font-size: 12.5px; font-weight: 600; background: var(--surface); color: var(--fg); width: fit-content; }
        .code-tag .ct-label { color: var(--muted); font-weight: 500; }
        .page-main-title { font-size: 24px; font-weight: 700; margin: 0; letter-spacing: -0.02em; display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
        .header-bar .right { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; align-content: flex-start; }
        /* Đồng bộ kích thước các nút thao tác (gồm cả <a> lẫn <button>) trong header */
        .header-bar .right .btn { min-height: 34px; padding: 6px 12px; line-height: 1.4; box-sizing: border-box; white-space: nowrap; }
        .header-bar .right .btn .icon { width: 15px; height: 15px; flex-shrink: 0; }

        /* ===== SECTIONS ===== */
        .liqd .section { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; margin-bottom: 16px; }
        .liqd .section-head { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 14px 20px; border-bottom: 1px solid var(--border); background: var(--surface); }
        .liqd .section-head h3 { font-size: 14px; font-weight: 700; margin: 0; }
        .liqd .section-body { padding: 20px; }

        /* ===== FORM GRID ===== */
        .form-grid { display: grid; gap: 14px 18px; }
        .form-grid.cols-4 { grid-template-columns: repeat(4, 1fr); }
        .form-grid.cols-2 { grid-template-columns: repeat(2, 1fr); }
        @media (max-width: 1280px) { .form-grid.cols-4 { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 760px) { .form-grid.cols-4, .form-grid.cols-2 { grid-template-columns: 1fr; } }
        .liqd .info-field { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
        .liqd .info-field label { font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
        .liqd .info-input { font-family: var(--font-ui); font-size: 13px; color: var(--fg); background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 9px 11px; width: 100%; line-height: 1.4; box-sizing: border-box; }
        .liqd .info-input:disabled { opacity: 0.9; cursor: not-allowed; }
        .liqd .info-input.mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }
        .liqd .info-input.neg { color: var(--danger); font-weight: 600; }

        /* ===== TAB BAR ===== */
        .liqd .tab-bar { display: flex; gap: 4px; padding: 0 16px; border-bottom: 1px solid var(--border); background: var(--surface); }
        .liqd .tab-bar .tab { display: inline-flex; align-items: center; gap: 8px; padding: 12px 16px; font-size: 13px; font-weight: 600; color: var(--muted); text-decoration: none; border: none; background: none; border-bottom: 2px solid transparent; margin-bottom: -1px; transition: all .12s ease; cursor: pointer; }
        .liqd .tab-bar .tab:hover { color: var(--fg); }
        .liqd .tab-bar .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
        .liqd .tab-icon { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2; }
        .liqd .tab-badge { display: inline-flex; align-items: center; justify-content: center; min-width: 18px; height: 18px; padding: 0 6px; font-family: var(--font-mono); font-size: 11px; font-weight: 700; background: var(--surface-2); border: 1px solid var(--border); color: var(--muted); border-radius: 999px; }
        .liqd .tab-bar .tab.active .tab-badge { background: var(--accent-soft); color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); }
        .liqd .tab-panel { display: none; }
        .liqd .tab-panel.active { display: block; }

        /* ===== TABLE ===== */
        .liqd .table-toolbar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; padding: 12px 14px; background: var(--surface); border-bottom: 1px solid var(--border); }
        .liqd .table-toolbar .spacer { flex: 1; }
        .liqd .search-input { position: relative; display: inline-flex; align-items: center; min-width: 240px; }
        .liqd .search-input svg { position: absolute; left: 10px; width: 16px; height: 16px; stroke: var(--muted); fill: none; stroke-width: 2; pointer-events: none; }
        .liqd .search-input input { width: 100%; padding: 8px 12px 8px 32px; font-size: 13px; font-family: var(--font-ui); color: var(--fg); background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); box-sizing: border-box; }
        .liqd .search-input input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .liqd .product-table { width: 100%; border-collapse: collapse; }
        .liqd .product-table th, .liqd .product-table td { padding: 11px 14px; text-align: left; border-bottom: 1px solid var(--border); vertical-align: middle; }
        .liqd .product-table th { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); letter-spacing: 0.04em; }
        .liqd .product-table td { font-size: 13px; }
        .liqd .product-table tbody tr:hover { background: var(--surface-2); }
        .liqd .product-table tfoot td { background: var(--surface-2); font-weight: 700; border-top: 2px solid var(--border); }
        .text-center { text-align: center; }
        .text-right { text-align: right; }
        .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }

        /* ===== STATUS PILL ===== */
        .status-pill { display: inline-flex; align-items: center; gap: 5px; font-size: 11.5px; font-weight: 600; padding: 3px 9px; border-radius: 999px; border: 1px solid; white-space: nowrap; }
        .status-pill .pdot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
        .status-pending { background: #fff3cd; color: #856404; border-color: color-mix(in srgb, #856404 25%, transparent); }
        .status-approved { background: #d4edda; color: #155724; border-color: color-mix(in srgb, #155724 25%, transparent); }
        .status-info { background: #cfe2ff; color: #084298; border-color: color-mix(in srgb, #084298 25%, transparent); }
        .status-rejected { background: #f8d7da; color: #721c24; border-color: color-mix(in srgb, #721c24 25%, transparent); }
        .status-revision { background: #ede9fe; color: #5b21b6; border-color: color-mix(in srgb, #5b21b6 25%, transparent); }
        .status-cancelled { background: #e2e3e5; color: #383d41; border-color: #c4c5c7; }

        /* ===== EMPTY STATE ===== */
        .liqd .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
        .liqd .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
        .liqd .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
        .liqd .empty-state strong { color: var(--fg); font-size: 14px; }

        /* ===== HISTORY FILTER BAR ===== */
        .history-filter-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; padding: 12px 14px; background: var(--surface); border-bottom: 1px solid var(--border); }
        .history-filter-bar .hf-search { flex: 1; min-width: 200px; max-width: 320px; }
        .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }

        /* ===== ACTION BADGE (history) ===== */
        .liqd .action-badge { display: inline-flex; align-items: center; gap: 5px; font-size: 11px; font-weight: 700; padding: 2px 9px; border-radius: 999px; border: 1px solid; }
        .liqd .action-badge.action-create   { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent); background: var(--accent-soft); }
        .liqd .action-badge.action-update   { color: var(--info);   border-color: color-mix(in srgb, var(--info) 32%, transparent);   background: var(--info-soft); }
        .liqd .action-badge.action-approve  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent); background: var(--accent-soft); }
        .liqd .action-badge.action-reject   { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 32%, transparent); background: var(--danger-soft); }
        .liqd .action-badge.action-revision { color: #7c3aed; border-color: color-mix(in srgb, #7c3aed 32%, transparent); background: color-mix(in srgb, #7c3aed 8%, transparent); }
        .liqd .action-badge.action-cancel   { color: var(--muted); border-color: var(--border); background: var(--surface-2); }

        .liqd .pagination { display: flex; align-items: center; justify-content: space-between; gap: 12px; padding: 12px 14px; flex-wrap: wrap; }
        .liqd .pagination .info { font-size: 12.5px; color: var(--muted); }
        .liqd .pagination .controls { display: flex; gap: 4px; align-items: center; }

        /* ===== CUSTOMER BANNER ===== */
        .liqd .cust-banner { display: flex; align-items: center; gap: 14px; }
        .liqd .cust-banner-avatar { width: 48px; height: 48px; border-radius: 50%; background: var(--accent-soft); color: var(--accent); display: grid; place-items: center; font-size: 20px; font-weight: 700; flex-shrink: 0; text-transform: uppercase; }
        .liqd .cust-banner-name { font-size: 16px; font-weight: 700; color: var(--fg); line-height: 1.2; }
        .liqd .cust-banner-tag { font-size: 12px; color: var(--muted); margin-top: 2px; }
        .liqd .cust-empty { display: flex; align-items: center; gap: 14px; padding: 8px 0; }
        .liqd .cust-empty-icon { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); border: 1px solid var(--border); display: grid; place-items: center; flex-shrink: 0; }
        .liqd .cust-empty-icon svg { width: 22px; height: 22px; stroke: var(--muted); }
        .liqd .cust-empty-text { display: flex; flex-direction: column; gap: 3px; }
        .liqd .cust-empty-text strong { font-size: 14px; color: var(--fg); }
        .liqd .cust-empty-text span { font-size: 12.5px; color: var(--muted); }
        .theme-toggle .icon-sun, .theme-toggle .icon-moon { display: none; }
        [data-theme="light"] .theme-toggle .icon-moon { display: block; }
        [data-theme="dark"] .theme-toggle .icon-sun { display: block; }

        /* ===== PRINT ===== */
        @media print {
            aside, .sidebar, .topbar, .side-panel, .side-panel-overlay,
            .modal-host, .toast-host, .header-bar .right, .table-toolbar,
            .history-filter-bar, .tab-bar, .liqd .pagination,
            #managerCustomerArea, .cust-newbtn-row { display: none !important; }
            .app { display: block !important; }
            .liqd { padding: 0 !important; }
            .liqd .section { border: 1px solid #ccc !important; box-shadow: none !important; break-inside: avoid; }
            .liqd .tab-panel { display: block !important; }
            body { background: #fff !important; }
        }

        /* ===== EDIT MODE: fix for select elements using info-input ===== */
        .liqd .info-input[required] { cursor: pointer; }
        .liqd .info-input:not([disabled]):not([readonly]) {
            background: var(--surface);
        }
        .liqd select.info-input {
            appearance: auto;
            padding-right: 8px;
        }
        /* ===== EDIT MODE: product-table styles ===== */
        .product-table .col-cb { width: 36px; text-align: center; }
        .product-table .col-date { white-space: nowrap; }
        .product-table .col-price { text-align: right; white-space: nowrap; }
        .product-table .row-serial { font-family: var(--font-mono); font-size: 12.5px; font-weight: 500; }
        .product-table .row-model { max-width: 180px; overflow: hidden; text-overflow: ellipsis; }
        .product-table .row-price { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }
        .product-table #editPickAll { width: 16px; height: 16px; margin: 0; cursor: pointer; accent-color: var(--accent); }
        .product-table .pick-trow.is-checked { background: color-mix(in srgb, var(--accent) 8%, var(--surface)); }
        .product-table .pick-trow.is-checked:hover { background: color-mix(in srgb, var(--accent) 12%, var(--surface)); }
        .pick-cb {
            width: 16px; height: 16px; margin: 0; cursor: pointer;
            accent-color: var(--accent);
        }
        .gen-hidden { display: none; }

        .section-action-bar { display: flex; align-items: center; justify-content: space-between; gap: 16px; padding: 16px 20px; border-top: 1px solid var(--border); background: var(--surface-2); flex-wrap: wrap; }
        .action-bar-left { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; font-size: 13px; color: var(--fg); }
        .action-bar-right { display: flex; align-items: center; gap: 8px; }
        .action-bar-left .bar-count { font-size: 13px; color: var(--fg); font-weight: 600; }
        .action-bar-left .bar-count strong { font-family: var(--font-mono); color: var(--accent); }
        .action-bar-left .bar-total { font-size: 12px; color: var(--muted); }
        .action-bar-left .bar-total .total-val { font-family: var(--font-mono); color: var(--fg); font-weight: 700; }
        .liq-price-wrap { display: inline-flex; align-items: center; gap: 4px; }
        .liq-price-wrap .liq-price-input:disabled { opacity: 0.5; cursor: not-allowed; }

        .customer-info-card { border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 14px 16px; background: var(--surface-2); margin-top: 10px; }
        .cic-header { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .cic-name { font-size: 14px; font-weight: 700; color: var(--fg); line-height: 1.4; }
        .cic-actions { display: flex; gap: 4px; align-items: center; flex-shrink: 0; }
        .cic-btn { display: inline-flex; align-items: center; gap: 4px; padding: 4px 8px; font-size: 12px; font-family: var(--font-ui); color: var(--muted); background: none; border: 1px solid var(--border); border-radius: var(--radius-sm); cursor: pointer; white-space: nowrap; line-height: 1.4; }
        .cic-btn:hover { color: var(--fg); border-color: var(--accent); }
        .cic-btn-remove { padding: 4px; border: none; color: var(--muted); background: none; cursor: pointer; }
        .cic-btn-remove:hover { color: var(--danger); }
        .cic-btn-remove svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2.2; stroke-linecap: round; stroke-linejoin: round; }
        .cic-details { display: flex; flex-wrap: wrap; gap: 4px 18px; margin-top: 10px; }
        .cic-detail-item { display: inline-flex; align-items: center; gap: 4px; font-size: 12.5px; color: var(--muted); line-height: 1.4; }
        .cic-detail-item svg { width: 14px; height: 14px; flex-shrink: 0; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Chi tiết đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / <span>${liquidation.liquidationCode}</span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <button type="button" class="btn" onclick="window.print()" title="In đơn thanh lý">
                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                    In phiếu
                </button>
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main class="liqd">
            
            <c:set var="st" value="${liquidation.status}"/>
            <c:choose>
                <c:when test="${st == 'PENDING_CEO'}"><c:set var="statusLabel" value="Chờ Sếp duyệt"/><c:set var="statusPillClass" value="liq-pending-ceo"/></c:when>
                <c:when test="${st == 'APPROVED'}"><c:set var="statusLabel" value="Đã duyệt"/><c:set var="statusPillClass" value="liq-pending-mgr"/></c:when>
                <c:when test="${st == 'COMPLETED'}"><c:set var="statusLabel" value="Đã xuất kho"/><c:set var="statusPillClass" value="liq-approved"/></c:when>
                <c:when test="${st == 'CEO_REQUEST_EDIT'}"><c:set var="statusLabel" value="Bị yêu cầu sửa"/><c:set var="statusPillClass" value="liq-edit"/></c:when>
                <c:when test="${st == 'CANCELLED'}"><c:set var="statusLabel" value="Đã hủy"/><c:set var="statusPillClass" value="liq-cancelled"/></c:when>
                <c:otherwise><c:set var="statusLabel" value="Không xác định"/><c:set var="statusPillClass" value="liq-muted"/></c:otherwise>
            </c:choose>

            <c:set var="isEditMode" value="${st == 'CEO_REQUEST_EDIT'}"/>
            <c:set var="isCeoEdit" value="${st == 'CEO_REQUEST_EDIT'}"/>

         
            <div class="header-bar">
                <div class="left">
                    <span class="code-tag">
                        <span class="ct-label">Đơn thanh lý -</span>
                        <span class="code-copy" data-copy="${liquidation.liquidationCode}">${liquidation.liquidationCode}</span>
                    </span>
                    <h2 class="page-main-title">
                        #${liquidation.liquidationCode}
                        <span class="pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                    </h2>
                </div>
                <div class="right">
                    <a class="btn" href="${pageContext.request.contextPath}/liquidations">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại
                    </a>
                    <button type="button" class="btn" onclick="location.reload()">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M23 4v6h-6M1 20v-6h6"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg>
                        Làm mới
                    </button>

                </div>
            </div>

         
            <c:if test="${(st == 'CEO_REQUEST_EDIT' or st == 'CANCELLED') and not empty liquidation.ceoFeedbackName}">
                <div class="alert ${st == 'CANCELLED' ? 'alert-danger' : 'alert-warn'}">
                    <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <span><strong>Phản hồi từ Sếp (CEO):</strong> ${liquidation.ceoFeedbackName}</span>
                </div>
            </c:if>
            
            <c:set var="usingEditForm" value="${isEditMode and isStaff}" />
            <c:choose>
                <c:when test="${usingEditForm}">
                    <form action="${pageContext.request.contextPath}/liquidations" method="POST" id="editForm">
                    <input type="hidden" name="action" value="edit_submit" />
                    <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/liquidations" method="POST" id="mainForm">
                    <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
                </c:otherwise>
            </c:choose>

                <div class="section">
                    <div class="section-head"><h3>Thông tin chung</h3></div>
                    <div class="section-body">
                        <c:choose>
                            <%-- EDIT MODE: editable fields --%>
                            <c:when test="${usingEditForm}">
                                <div class="form-grid cols-4">
                                    <div class="info-field">
                                        <label>Kho hàng <span style="color:var(--danger)">*</span></label>
                                        <select class="info-input" id="editWarehouseSelect" disabled>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.warehouseId}" ${w.warehouseId == selectedWarehouseId ? 'selected' : ''}>${w.name}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="hidden" name="warehouseId" id="editWarehouseId" value="${selectedWarehouseId}" />
                                    </div>
                                    <div class="info-field">
                                        <label>Lý do thanh lý <span style="color:var(--danger)">*</span></label>
                                        <select class="info-input" disabled>
                                            <option value="">-- Chọn lý do --</option>
                                            <c:forEach var="r" items="${reasons}">
                                                <option value="${r.id}" ${r.id == liquidation.reasonId ? 'selected' : ''}>${r.name}</option>
                                            </c:forEach>
                                        </select>
                                        <input type="hidden" name="reasonId" value="${liquidation.reasonId}" />
                                    </div>
                                    <div class="info-field">
                                        <label>Ngày tạo</label>
                                        <input class="info-input mono" type="text" disabled value="${liquidation.createdAt}">
                                    </div>
                                    <div class="info-field">
                                        <label>Người tạo</label>
                                        <input class="info-input" type="text" disabled value="<c:out value='${liquidation.createdByName}'/>">
                                    </div>
                                    <div class="info-field">
                                        <label>Số máy</label>
                                        <input class="info-input mono" type="text" disabled value="${empty liquidation.detailCount ? 0 : liquidation.detailCount} máy">
                                    </div>
                                    <div class="info-field">
                                        <label>Giá nhập (VNĐ)</label>
                                        <input class="info-input mono" type="text" disabled value="<c:choose><c:when test='${not empty liquidation.totalOriginalPrice}'><fmt:formatNumber value='${liquidation.totalOriginalPrice}' pattern='#,##0'/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose>">
                                    </div>
                                    <div class="info-field">
                                        <label>Giá thanh lý (VNĐ)</label>
                                        <input class="info-input mono" type="text" disabled value="<c:choose><c:when test='${not empty liquidation.totalLiquidationPrice and liquidation.totalLiquidationPrice > 0}'><fmt:formatNumber value='${liquidation.totalLiquidationPrice}' pattern='#,##0'/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose>">
                                    </div>
                                    <div class="info-field">
                                        <label>&nbsp;</label>
                                        <input class="info-input" type="text" disabled value="" style="opacity:0;">
                                    </div>
                                </div>
                            </c:when>
                     
                            <c:otherwise>
                                <div class="form-grid cols-4">
                                    <div class="info-field">
                                        <label>Mã đơn</label>
                                        <input class="info-input mono" type="text" disabled value="${liquidation.liquidationCode}">
                                    </div>
                                    <div class="info-field">
                                        <label>Lý do thanh lý</label>
                                        <input class="info-input" type="text" disabled value="<c:out value='${liquidation.reasonName}'/>">
                                    </div>
                                    <div class="info-field">
                                        <label>Kho hàng</label>
                                        <input class="info-input" type="text" disabled value="<c:out value='${liquidation.warehouseName}'/>">
                                    </div>
                                    <div class="info-field">
                                        <label>Ngày tạo</label>
                                        <input class="info-input mono" type="text" disabled value="${liquidation.createdAt}">
                                    </div>
                                    <div class="info-field">
                                        <label>Người tạo</label>
                                        <input class="info-input" type="text" disabled value="<c:out value='${liquidation.createdByName}'/>">
                                    </div>
                                    <div class="info-field">
                                        <label>Số máy</label>
                                        <input class="info-input mono" type="text" disabled value="${empty liquidation.detailCount ? 0 : liquidation.detailCount} máy">
                                    </div>
                                    <div class="info-field">
                                        <label>Giá nhập (VNĐ)</label>
                                        <input class="info-input mono" type="text" disabled value="<c:choose><c:when test='${not empty liquidation.totalOriginalPrice}'><fmt:formatNumber value='${liquidation.totalOriginalPrice}' pattern='#,##0'/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose>">
                                    </div>
                                    <div class="info-field">
                                        <label>Giá thanh lý (VNĐ)</label>
                                        <input class="info-input mono" type="text" disabled value="<c:choose><c:when test='${not empty liquidation.totalLiquidationPrice and liquidation.totalLiquidationPrice > 0}'><fmt:formatNumber value='${liquidation.totalLiquidationPrice}' pattern='#,##0'/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose>">
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                      
                        <div class="cust-subhead" style="margin-top:22px; padding-top:16px; border-top:1px solid var(--border);">
                            <h4 style="font-size:13px; font-weight:700; margin:0 0 14px;">Khách hàng nhận</h4>
                        </div>
                        <c:choose>
                            <c:when test="${usingEditForm}">
                                <input type="hidden" name="customerId" value="${liquidation.customerId}" />
                                <c:choose>
                                    <c:when test="${not empty liquidation.customerName}">
                                        <div class="customer-info-card">
                                            <div class="cic-header">
                                                <span class="cic-name"><c:out value='${liquidation.customerName}'/></span>
                                            </div>
                                            <div class="cic-details">
                                                <c:if test="${not empty liquidation.customerPhone}">
                                                    <span class="cic-detail-item">
                                                        <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                                        <c:out value='${liquidation.customerPhone}'/>
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty liquidation.customerEmail}">
                                                    <span class="cic-detail-item">
                                                        <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                                                        <c:out value='${liquidation.customerEmail}'/>
                                                    </span>
                                                </c:if>
                                                <c:if test="${not empty liquidation.customerAddress}">
                                                    <span class="cic-detail-item">
                                                        <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                        <c:out value='${liquidation.customerAddress}'/>
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="cust-empty">
                                            <div class="cust-empty-icon">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                                            </div>
                                            <div class="cust-empty-text">
                                                <strong>Chưa có khách hàng nhận</strong>
                                                <span>Khách hàng sẽ được thêm khi tạo đơn thanh lý.</span>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${not empty liquidation.customerName}">
                                <div class="customer-info-card">
                                    <div class="cic-header">
                                        <span class="cic-name"><c:out value='${liquidation.customerName}'/></span>
                                    </div>
                                    <div class="cic-details">
                                        <c:if test="${not empty liquidation.customerPhone}">
                                            <span class="cic-detail-item">
                                                <svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                                                <c:out value='${liquidation.customerPhone}'/>
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty liquidation.customerEmail}">
                                            <span class="cic-detail-item">
                                                <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                                                <c:out value='${liquidation.customerEmail}'/>
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty liquidation.customerAddress}">
                                            <span class="cic-detail-item">
                                                <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                <c:out value='${liquidation.customerAddress}'/>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="cust-empty">
                                    <div class="cust-empty-icon">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                                    </div>
                                    <div class="cust-empty-text">
                                        <strong>Chưa có khách hàng nhận</strong>
                                        <span>Khách hàng sẽ được thêm khi tạo đơn thanh lý.</span>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="section">
                    <div class="section-head"><h3>Danh sách máy phát điện</h3></div>
                    <div class="tab-bar">
                        <button type="button" class="tab active" onclick="switchTab('machines')">
                            <svg class="tab-icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Danh sách máy
                        </button>
                        <button type="button" class="tab" onclick="switchTab('history')">
                            <svg class="tab-icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử xử lý
                            <span class="tab-badge">${totalHistory != null ? totalHistory : 0}</span>
                        </button>
                    </div>

                    <%-- ===== Tab 1: Danh sách máy ===== --%>
                    <div id="tab-machines" class="tab-panel active">
                        <c:choose>
                            <%-- EDIT MODE: checkbox table with machine picker --%>
                            <c:when test="${usingEditForm}">
                                <div class="section-body">
                                    <div class="table-toolbar">
                                        <div class="search-input">
                                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                            <input type="text" id="editSerialSearch" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                                        </div>
                                        <div class="spacer"></div>
                                    </div>
                                    <table class="product-table" id="editPickTable">
                                        <thead>
                                            <tr>
                                                <th class="col-cb"></th>
                                                <th>Serial</th>
                                                <th>Model</th>
                                                <th>Tình trạng</th>
                                                <th class="col-date">Ngày nhập</th>
                                                <th class="col-price">Giá gốc</th>
                                                <th class="col-price">Giá thanh lý <span style="color:var(--danger)">*</span></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="r" items="${pickRows}">
                                                <tr class="pick-trow ${r.selected ? 'is-checked' : ''}" data-model="<c:out value='${r.model}'/>">
                                                    <td class="col-cb">
                                                        <input type="checkbox" class="pick-cb"
                                                               value="<c:out value='${r.serialNumber}'/>"
                                                               data-gen="${r.generatorId}"
                                                               data-price="${r.unitPrice}"
                                                               data-condition="${r.condition}"
                                                               data-old-liq-price="${r.liquidationPrice}"
                                                               ${r.selected ? 'checked' : ''} disabled/>
                                                        <input type="hidden" class="gen-hidden" name="generatorId" value="${r.generatorId}" ${r.selected ? '' : 'disabled'}/>
                                                        <input type="hidden" name="serialNumber" value="<c:out value='${r.serialNumber}'/>" ${r.selected ? '' : 'disabled'}/>
                                                    </td>
                                                    <td class="row-serial"><c:out value="${r.serialNumber}"/></td>
                                                    <td class="row-model"><c:out value="${r.model}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${r.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                            <c:when test="${r.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                            <c:when test="${r.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                            <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="col-date row-date"><c:out value="${r.createdAtStr}"/></td>
                                                    <td class="col-price row-price"><fmt:formatNumber value="${r.unitPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                                    <td class="col-price">
                                                        <div class="liq-price-wrap">
                                                            <input type="text" inputmode="numeric" class="liq-price-input" name="liquidationPrice"
                                                                   value="<c:if test='${r.liquidationPrice > 0}'><fmt:formatNumber value='${r.liquidationPrice}' type='number' maxFractionDigits='0' groupingUsed='true'/></c:if>"
                                                                   placeholder="Nhập giá..." ${r.selected ? '' : 'disabled'}/>
                                                            <span class="liq-price-suffix">đ</span>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <div class="section-action-bar">
                                        <div class="action-bar-left">
                                            <span class="bar-count">Đã chọn <strong id="editBarSelectedCount">0</strong> máy</span>
                                            <span class="bar-total">Tổng giá gốc: <span class="total-val" id="editFormTotalVal">0 đ</span></span>
                                            <span class="bar-total">Tổng giá thanh lý: <span class="total-val" id="editFormLiqTotalVal">0 đ</span></span>
                                        </div>
                                        <div class="action-bar-right">
                                            <a class="btn" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">Huỷ bỏ</a>
                                            <button type="submit" form="editForm" class="btn btn-primary">
                                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                                Lưu &amp; Gửi lại
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:when>
                       
                            <c:otherwise>
                                <div class="table-toolbar">
                                    <div class="search-input">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        <input id="machineSearch" placeholder="Tìm theo dòng máy, serial..." autocomplete="off"/>
                                    </div>
                                    <div class="spacer"></div>
                                </div>
                                <div style="overflow-x:auto;">
                                    <table class="product-table" id="machineTable">
                                        <thead>
                                            <tr>
                                                <th>Dòng máy</th>
                                                <th>Số Serial</th>
                                                <th>Tình trạng</th>
                                                <th class="text-right">Giá gốc (VNĐ)</th>
                                                <th class="text-right">Giá thanh lý (VNĐ)</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="d" items="${details}">
                                                <tr data-search="<c:out value='${d.generatorModelName} ${d.serialNumber}'/>">
                                                    <td><strong>${d.generatorModelName}</strong></td>
                                                    <td class="mono">${d.serialNumber}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${d.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                            <c:when test="${d.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                            <c:when test="${d.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                            <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-right mono"><fmt:formatNumber value="${d.originalPrice}" type="number" maxFractionDigits="0"/></td>
                                                    <td class="text-right">
                                                        <input type="hidden" name="detailId" value="${d.liquidationDetailId}" />
                                                        <strong class="mono"><fmt:formatNumber value="${d.liquidationPrice}" type="number" maxFractionDigits="0"/></strong>
                                                        <input type="hidden" name="liquidationPrice" value="${d.liquidationPrice}" />
                                                    </td>
                                                    <td><span class="pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="3" class="text-right">Tổng cộng:</td>
                                                <td class="text-right mono"><c:if test="${not empty liquidation.totalOriginalPrice}"><fmt:formatNumber value="${liquidation.totalOriginalPrice}" type="number" maxFractionDigits="0"/></c:if></td>
                                                <td class="text-right mono" style="color:var(--accent);"><c:if test="${not empty liquidation.totalLiquidationPrice and liquidation.totalLiquidationPrice > 0}"><fmt:formatNumber value="${liquidation.totalLiquidationPrice}" type="number" maxFractionDigits="0"/></c:if></td>
                                                <td></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <c:if test="${isCeo and st == 'PENDING_CEO'}">
                                    <div class="section-action-bar">
                                        <div class="action-bar-left">
                                            Hãy xem kỹ các chi tiết thiết bị và giá đề xuất ở trên trước khi ra quyết định.
                                        </div>
                                        <div class="action-bar-right">
                                            <button type="button" class="btn btn-success-solid" onclick="openConfirmApproveModal()">
                                                <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                                Duyệt đơn
                                            </button>
                                            <button type="button" class="btn btn-warn" onclick="openFeedbackModal('request_edit_ceo', 'Sếp yêu cầu sửa', 'ceoFeedbackId', 'btn-warn', 'select_ceo_edit')">
                                                <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                Yêu cầu sửa
                                            </button>
                                            <button type="button" class="btn btn-danger" onclick="openFeedbackModal('reject_ceo', 'Từ chối đơn thanh lý', 'ceoFeedbackId', 'btn-danger', 'select_ceo_reject')">
                                                <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                                Từ chối đơn
                                            </button>
                                            <button type="submit" name="action" value="approve_ceo" id="hiddenApproveCeoBtn" style="display:none;"></button>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${st == 'COMPLETED' and not empty liquidation.convertedReceiptId}">
                                    <div class="section-action-bar completed-bar">
                                        <div class="action-bar-left">
                                            Đơn đã thanh lý hoàn tất.
                                            <a href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${liquidation.convertedReceiptId}" class="btn" style="margin-left:8px;">
                                                Xem phiếu xuất kho
                                            </a>
                                        </div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
       
                    <div id="tab-history" class="tab-panel">
                        <c:choose>
                            <c:when test="${empty liquidationHistory}">
                                <div class="empty-state">
                                    <div class="icon-wrap"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>
                                    <strong>Chưa có lịch sử xử lý</strong>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="history-filter-bar">
                                    <div class="search-input hf-search">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        <input type="text" id="historySearch" placeholder="Tìm theo người làm, ghi chú..." autocomplete="off"/>
                                    </div>
                                    <select id="historyFilter" class="history-filter">
                                        <option value="">Tất cả hành động</option>
                                        <option value="CREATE">Tạo đơn</option>
                                        <option value="EDIT_SUBMIT">Đã sửa &amp; gửi lại</option>
                                        <option value="CEO_APPROVE">Sếp duyệt</option>
                                        <option value="CEO_REQUEST_EDIT">Sếp yêu cầu sửa</option>
                                        <option value="CANCELLED">Đã hủy</option>
                                        <option value="EXPORT_APPROVE">Đã xuất kho</option>
                                    </select>
                                </div>
                                <div class="result-summary">
                                    <span id="historyCounter">${fn:length(liquidationHistory)} bản ghi</span>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width:140px;">Thời gian</th>
                                            <th style="width:170px;">Hành động</th>
                                            <th style="width:200px;">Người thực hiện</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody id="historyBody">
                                        <c:forEach var="log" items="${liquidationHistory}">
                                            <c:set var="actClass">
                                                <c:choose>
                                                    <c:when test="${log.action == 'CEO_APPROVE' or log.action == 'EXPORT_APPROVE'}">approve</c:when>
                                                    <c:when test="${log.action == 'CEO_REQUEST_EDIT'}">revision</c:when>
                                                    <c:when test="${log.action == 'CANCELLED'}">reject</c:when>
                                                    <c:when test="${log.action == 'EDIT_SUBMIT'}">update</c:when>
                                                    <c:when test="${log.action == 'CREATE' or log.action == 'AUTO_CREATE'}">create</c:when>
                                                    <c:otherwise>cancel</c:otherwise>
                                                </c:choose>
                                            </c:set>
                                            <tr data-action="${log.action}">
                                                <td class="mono"><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM HH:mm" /></td>
                                                <td>
                                                    <span class="action-badge action-${fn:trim(actClass)}">
                                                        <c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">Tạo đơn</c:when>
                                                            <c:when test="${log.action == 'AUTO_CREATE'}">Tự động tạo</c:when>
                                                            <c:when test="${log.action == 'CEO_APPROVE'}">Sếp duyệt</c:when>
                                                            <c:when test="${log.action == 'CEO_REQUEST_EDIT'}">Sếp yêu cầu sửa</c:when>
                                                            <c:when test="${log.action == 'CANCELLED'}">Đã hủy</c:when>
                                                            <c:when test="${log.action == 'EDIT_SUBMIT'}">Đã sửa &amp; gửi lại</c:when>
                                                            <c:when test="${log.action == 'EXPORT_APPROVE'}">Đã xuất kho</c:when>
                                                            <c:otherwise>${log.action}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td><strong>${log.username}</strong> <span style="color:var(--muted);font-size:11px;">#${log.userId}</span></td>
                                                <td style="color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                    <c:choose>
                                                        <c:when test="${log.action == 'CEO_APPROVE'}">${log.details}</c:when>
                                                        <c:otherwise><c:out value="${log.details}"/></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <tr id="historyEmptyRow" style="display:none;">
                                            <td colspan="4" style="text-align:center; color:var(--muted); padding:24px 12px; font-size:13px;">Không có kết quả phù hợp.</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="pagination"><div class="controls" id="historyPager"></div></div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </form>
        </main>
    </div>
</div>

<div class="modal-host" id="confirmApproveModal">
    <div class="modal">
        <h3>Xác nhận duyệt đơn</h3>
        <p>Bạn có chắc chắn muốn <strong>duyệt</strong> đơn thanh lý này và <strong>tạo Phiếu Xuất Kho</strong>? Hành động này không thể hoàn tác.</p>
        <div class="modal-actions" style="display:flex; justify-content:flex-end; gap:8px; margin-top:8px;">
            <button type="button" class="btn" onclick="closeModal('confirmApproveModal')">Huỷ</button>
            <button type="button" class="btn btn-success-solid" onclick="document.getElementById('hiddenApproveCeoBtn').click();">Xác nhận duyệt &amp; xuất</button>
        </div>
    </div>
</div>

<div class="modal-host" id="feedbackModal">
    <div class="modal modal-lg">
        <h3 id="feedbackModalTitle">Phản hồi</h3>
        <form method="POST" action="${pageContext.request.contextPath}/liquidations">
            <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
            <input type="hidden" name="action" id="feedbackModalAction" value="" />
            <select id="select_ceo_reject" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_edit" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <div class="modal-actions" style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
                <button type="button" class="btn" onclick="closeModal('feedbackModal')">Huỷ</button>
                <button type="submit" class="btn" id="feedbackModalSubmit">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<!-- Side panel chọn khách hàng (dùng searchable-dropdown.js) -->
<div class="side-panel-overlay" id="custPanelOverlay" onclick="closeCustomerPanel()"></div>
<div class="side-panel" id="custSidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn Khách Hàng</h3>
        <button type="button" class="side-panel-close" onclick="closeCustomerPanel()">&times;</button>
    </div>
    <div class="side-panel-body">
        <div style="display:flex; gap:8px; margin-bottom:20px;">
            <input type="text" id="custSearchInput" class="serial-search-box" placeholder="Tìm nhanh theo tên, SĐT, email..."/>
            <select id="custSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                <option value="name_asc">Tên A-Z</option>
                <option value="name_desc">Tên Z-A</option>
                <option value="newest">Mới nhất</option>
            </select>
        </div>
        <div id="custLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
            </svg><br>Đang tải...
        </div>
        <div class="cust-list-wrap" id="custList"></div>
    </div>
</div>

<!-- Modal tạo khách hàng mới -->
<div class="modal-host" id="ncModalOverlay">
    <div class="modal modal-lg">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
            <h3 style="margin:0;">Thêm khách hàng mới</h3>
            <button type="button" class="side-panel-close" onclick="closeNewCustomerModal()" title="Đóng">&times;</button>
        </div>
        <p style="font-size:13px;color:var(--muted);margin:0 0 4px;">Nhập thông tin khách hàng để tạo nhanh và gán vào đơn.</p>
        <div class="modal-error" id="ncError" style="display:none;"></div>
        <div class="modal-grid">
            <div class="field">
                <label class="field-label">Họ và tên <span class="req">*</span></label>
                <input type="text" id="ncName" class="input" placeholder="VD: Nguyễn Văn A" autocomplete="off" />
                <span class="field-error" id="ncNameErr">Vui lòng nhập họ và tên.</span>
            </div>
            <div class="field">
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input type="tel" id="ncPhone" class="input mono" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" autocomplete="off" />
                <span class="field-error" id="ncPhoneErr">SĐT phải gồm 10–11 chữ số.</span>
            </div>
            <div class="field">
                <label class="field-label">Email</label>
                <input type="email" id="ncEmail" class="input mono" placeholder="email@example.com" autocomplete="off" />
                <span class="field-error" id="ncEmailErr">Email không hợp lệ.</span>
            </div>
            <div class="field">
                <label class="field-label">Loại khách hàng</label>
                <select id="ncTypeId" class="select" onchange="ncOnTypeChange()">
                    <option value="">-- Chọn loại --</option>
                    <c:forEach var="ct" items="${customerTypes}">
                        <option value="${ct.id}" data-name="${ct.name}"><c:out value="${ct.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Tên công ty <span class="req nc-company-req" style="display:none;">*</span></label>
                <input type="text" id="ncCompanyName" class="input" placeholder="VD: Công ty TNHH ABC" autocomplete="off" />
                <span class="field-error" id="ncCompanyErr">Vui lòng nhập tên công ty.</span>
            </div>
            <div class="field span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea id="ncAddress" class="textarea" rows="2" placeholder="VD: Số 1, Đường ABC, Quận 1, TP.HCM"></textarea>
            </div>
        </div>
        <div class="modal-actions" style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
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
    <c:if test="${not empty param.error}">
    window.SESSION_DATA = window.SESSION_DATA || {};
    window.SESSION_DATA.message = '<c:out value="${param.error}"/>';
    window.SESSION_DATA.type = 'danger';
    </c:if>
    <c:if test="${not empty param.success}">
    window.SESSION_DATA = window.SESSION_DATA || {};
    window.SESSION_DATA.message = '<c:out value="${param.success}"/>';
    window.SESSION_DATA.type = 'success';
    </c:if>
</script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script>
    if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
    }
</script>
<%-- __PART5__ --%>
<script>
    function openModal(id) { var m = document.getElementById(id); if (m) m.classList.add('show'); }
    function closeModal(id) { var m = document.getElementById(id); if (m) m.classList.remove('show'); }
    function openConfirmApproveModal() { openModal('confirmApproveModal'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-host.show').forEach(function(m) { m.classList.remove('show'); });
        }
    });

    function switchTab(tabId) {
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.tab-bar .tab').forEach(function(t) { t.classList.remove('active'); });
        var panel = document.getElementById('tab-' + tabId);
        if (panel) panel.classList.add('active');
        var clickedTab = document.querySelector('.tab-bar .tab[onclick="switchTab(\'' + tabId + '\')"]');
        if (clickedTab) clickedTab.classList.add('active');
        if (tabId === 'history') applyHistoryFilter();
    }

    function openFeedbackModal(actionValue, title, paramName, btnClass, selectId) {
        document.getElementById('feedbackModalTitle').innerText = title;
        document.getElementById('feedbackModalAction').value = actionValue;
        document.getElementById('feedbackModalSubmit').className = 'btn ' + btnClass;
        document.querySelectorAll('.fb-select').forEach(function(el) {
            el.style.display = 'none'; el.disabled = true; el.removeAttribute('name'); el.removeAttribute('required');
        });
        var activeSelect = document.getElementById(selectId);
        activeSelect.style.display = 'block'; activeSelect.disabled = false;
        activeSelect.name = paramName; activeSelect.required = true;
        openModal('feedbackModal');
    }

    // ===== Tìm kiếm bảng máy =====
    (function() {
        var search = document.getElementById('machineSearch');
        var table = document.getElementById('machineTable');
        if (!table) return;
        var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr[data-search]'));
        function applyFilter() {
            var q = (search && search.value ? search.value : '').toLowerCase().trim();
            rows.forEach(function (r) {
                var hay = (r.getAttribute('data-search') || '').toLowerCase();
                r.style.display = (!q || hay.indexOf(q) !== -1) ? '' : 'none';
            });
        }
        if (search) search.addEventListener('input', applyFilter);
    })();

    // ===== Format giá thanh lý =====
    function formatPriceInput(el) {
        var digits = (el.value || '').replace(/[^0-9]/g, '');
        el.value = digits ? Number(digits).toLocaleString('vi-VN') : '';
    }
    document.querySelectorAll('.liq-price-input').forEach(function (el) {
        formatPriceInput(el);
        el.addEventListener('input', function () { formatPriceInput(el); });
    });

    var mainForm = document.getElementById('mainForm');
    if (mainForm) {
        mainForm.addEventListener('submit', function(e) {
            document.querySelectorAll('.liq-price-input').forEach(function (el) {
                el.value = (el.value || '').replace(/[^0-9]/g, '');
            });
        });
    }

    // ===== Lọc + phân trang lịch sử =====
    var HISTORY_PAGE_SIZE = 8;
    var historyState = { page: 1 };
    function getHistoryRows() {
        var body = document.getElementById('historyBody');
        if (!body) return [];
        return Array.from(body.querySelectorAll('tr[data-action]'));
    }
    function applyHistoryFilter() {
        var rows = getHistoryRows();
        if (rows.length === 0) return;
        var qInput = document.getElementById('historySearch');
        var fSel = document.getElementById('historyFilter');
        var q = qInput ? qInput.value.toLowerCase().trim() : '';
        var f = fSel ? fSel.value : '';
        var matched = [];
        rows.forEach(function(tr) {
            var act = tr.getAttribute('data-action') || '';
            var text = tr.innerText.toLowerCase();
            var ok = (!f || act === f) && (!q || text.indexOf(q) !== -1);
            if (ok) matched.push(tr);
        });
        var totalPages = Math.max(1, Math.ceil(matched.length / HISTORY_PAGE_SIZE));
        if (historyState.page > totalPages) historyState.page = totalPages;
        if (historyState.page < 1) historyState.page = 1;
        var start = (historyState.page - 1) * HISTORY_PAGE_SIZE;
        rows.forEach(function(tr) { tr.style.display = 'none'; });
        matched.slice(start, start + HISTORY_PAGE_SIZE).forEach(function(tr) { tr.style.display = ''; });
        var emptyRow = document.getElementById('historyEmptyRow');
        if (emptyRow) emptyRow.style.display = matched.length === 0 ? '' : 'none';
        var counter = document.getElementById('historyCounter');
        if (counter) counter.textContent = matched.length + ' bản ghi';
        renderHistoryPager(matched.length, totalPages);
    }
    function renderHistoryPager(total, totalPages) {
        var pager = document.getElementById('historyPager');
        if (!pager) return;
        if (total <= HISTORY_PAGE_SIZE) { pager.innerHTML = ''; return; }
        var html = '';
        var p = historyState.page;
        html += '<button type="button" class="page-btn" data-go="prev"' + (p <= 1 ? ' disabled' : '') + '>‹ Trước</button>';
        for (var i = 1; i <= totalPages; i++) {
            html += '<button type="button" class="page-btn ' + (i === p ? 'active' : '') + '" data-go="' + i + '">' + i + '</button>';
        }
        html += '<button type="button" class="page-btn" data-go="next"' + (p >= totalPages ? ' disabled' : '') + '>Sau ›</button>';
        pager.innerHTML = html;
        pager.querySelectorAll('button[data-go]').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var go = btn.getAttribute('data-go');
                if (go === 'prev') historyState.page = Math.max(1, historyState.page - 1);
                else if (go === 'next') historyState.page = historyState.page + 1;
                else historyState.page = parseInt(go, 10);
                applyHistoryFilter();
            });
        });
    }
    (function initHistory() {
        var search = document.getElementById('historySearch');
        var filter = document.getElementById('historyFilter');
        if (search) search.addEventListener('input', function() { historyState.page = 1; applyHistoryFilter(); });
        if (filter) filter.addEventListener('change', function() { historyState.page = 1; applyHistoryFilter(); });
    })();

    // ===== Modal tạo khách hàng mới =====
    function openNewCustomerModal() {
        ['ncName','ncPhone','ncEmail','ncAddress','ncCompanyName'].forEach(function(id){ document.getElementById(id).value = ''; });
        document.getElementById('ncTypeId').selectedIndex = 0;
        ncClearInvalid(); ncOnTypeChange(); hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }
    function closeNewCustomerModal() { document.getElementById('ncModalOverlay').classList.remove('show'); }
    function showNcError(msg) { var el = document.getElementById('ncError'); el.textContent = msg; el.style.display = 'block'; }
    function hideNcError() { document.getElementById('ncError').style.display = 'none'; }
    function ncOnTypeChange() {
        var sel = document.getElementById('ncTypeId');
        var opt = sel.options[sel.selectedIndex];
        var name = (opt && opt.getAttribute('data-name') || '').toLowerCase();
        var isCompany = name.indexOf('doanh nghi') >= 0 || name.indexOf('công ty') >= 0;
        var req = document.querySelector('.nc-company-req');
        if (req) req.style.display = isCompany ? '' : 'none';
    }
    function ncSetInvalid(inputId, invalid) {
        var el = document.getElementById(inputId); if (!el) return;
        var field = el.closest('.field'); if (field) field.classList.toggle('invalid', !!invalid);
    }
    function ncClearInvalid() { ['ncName','ncPhone','ncEmail','ncCompanyName'].forEach(function(id){ ncSetInvalid(id, false); }); }
    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        var email = document.getElementById('ncEmail').value.trim();
        var company = document.getElementById('ncCompanyName').value.trim();
        var sel = document.getElementById('ncTypeId');
        var typeName = (sel.options[sel.selectedIndex] && sel.options[sel.selectedIndex].getAttribute('data-name') || '').toLowerCase();
        var isCompany = typeName.indexOf('doanh nghi') >= 0 || typeName.indexOf('công ty') >= 0;
        ncClearInvalid(); hideNcError();
        var firstBad = null;
        var phoneRe = /^[0-9]{10,11}$/;
        var emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!name) { ncSetInvalid('ncName', true); firstBad = firstBad || 'ncName'; }
        if (!phone || !phoneRe.test(phone)) { ncSetInvalid('ncPhone', true); firstBad = firstBad || 'ncPhone'; }
        if (email && !emailRe.test(email)) { ncSetInvalid('ncEmail', true); firstBad = firstBad || 'ncEmail'; }
        if (isCompany && !company) { ncSetInvalid('ncCompanyName', true); firstBad = firstBad || 'ncCompanyName'; }
        if (firstBad) { document.getElementById(firstBad).focus(); return; }
        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';
        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', email);
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', company);
        fd.append('custTypeId', sel.value);
        fetch('${pageContext.request.contextPath}/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    applyChosenCustomer(data);
                    closeNewCustomerModal();
                    if (typeof closeCustomerPanel === 'function') closeCustomerPanel();
                    if (data.existing) alert('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                } else { showNcError(data.error || 'Lỗi không xác định'); }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }
    function applyChosenCustomer(c) {
        var set = function(id, val) { var el = document.getElementById(id); if (el) el.value = val || ''; };
        set('sdHiddenId', c.id);
        set('inpCustName', c.name);
        set('inpCustPhone', c.phone);
        set('inpCustEmail', c.email);
        set('inpCustAddress', c.address);
        set('customerCompany', c.companyName);
        var label = document.getElementById('custTriggerLabel');
        if (label) { label.textContent = c.name || c.phone || ''; label.classList.add('has-value'); }
        refreshCustomerCard();
    }

    // ===== Customer info card =====
    function htmlEsc(s) {
        if (s == null) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    }
    function refreshCustomerCard() {
        var container = document.getElementById('customerCardContainer');
        var picker = document.getElementById('custPickerArea');
        if (!container) return;
        var hid = document.getElementById('sdHiddenId');
        var custId = hid ? hid.value : '';
        if (!custId || !custId.trim()) {
            container.style.display = 'none';
            if (picker) picker.style.display = '';
            return;
        }
        if (picker) picker.style.display = 'none';
        var name = document.getElementById('inpCustName');
        var phone = document.getElementById('inpCustPhone');
        var email = document.getElementById('inpCustEmail');
        var address = document.getElementById('inpCustAddress');
        var company = document.getElementById('customerCompany');
        var nameVal = name ? name.value : '';
        var phoneVal = phone ? phone.value : '';
        var emailVal = email ? email.value : '';
        var addressVal = address ? address.value : '';
        var companyVal = company ? company.value : '';
        var html = '<div class="cic-header">';
        html += '<span class="cic-name">' + htmlEsc(nameVal || '') + '</span>';
        html += '<div class="cic-actions">';
        html += '<button type="button" class="cic-btn-remove" onclick="clearCustomerSelection();refreshCustomerCard();" title="Hủy chọn khách hàng" aria-label="Hủy chọn">';
        html += '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg>';
        html += '</button>';
        html += '</div></div>';
        html += '<div class="cic-details">';
        if (phoneVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>' + htmlEsc(phoneVal) + '</span>';
        if (companyVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>' + htmlEsc(companyVal) + '</span>';
        if (emailVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>' + htmlEsc(emailVal) + '</span>';
        if (addressVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>' + htmlEsc(addressVal) + '</span>';
        html += '</div>';
        container.innerHTML = html;
        container.style.display = '';
    }

    // ===== Override clearCustomerSelection to refresh card =====
    var origClearCustomerSelection = window.clearCustomerSelection;
    window.clearCustomerSelection = function() {
        if (typeof origClearCustomerSelection === 'function') origClearCustomerSelection();
        refreshCustomerCard();
    };

    // ===== Watch customer selection from searchable-dropdown.js =====
    (function() {
        var list = document.getElementById('custList');
        if (list) {
            list.addEventListener('click', function(e) {
                if (e.target.closest('.cust-card')) {
                    setTimeout(refreshCustomerCard, 0);
                }
            });
        }
    })();

    // ===== Init on page load =====
    refreshCustomerCard();

    // ===== EDIT MODE: machine picker logic =====
    (function() {
        var cbs = Array.prototype.slice.call(document.querySelectorAll('.pick-cb'));
        if (cbs.length === 0) return;

        function fmt(n) { return Number(n || 0).toLocaleString('vi-VN'); }

        function recalc() {
            var count = 0, total = 0, liqTotal = 0;
            cbs.forEach(function(cb) {
                var row = cb.closest('.pick-trow');
                var genHidden = row ? row.querySelector('.gen-hidden') : null;
                var priceInput = row ? row.querySelector('.liq-price-input') : null;
                if (cb.checked) {
                    count++;
                    total += parseFloat(cb.getAttribute('data-price') || '0') || 0;
                    if (row) row.classList.add('is-checked');
                    if (genHidden) genHidden.disabled = false;
                    if (priceInput) {
                        priceInput.disabled = false;
                        liqTotal += parseFloat((priceInput.value || '').replace(/[^0-9]/g, '')) || 0;
                    }
                } else {
                    if (row) row.classList.remove('is-checked');
                    if (genHidden) genHidden.disabled = true;
                    if (priceInput) priceInput.disabled = true;
                }
            });
            var countEl = document.getElementById('editBarSelectedCount');
            if (countEl) countEl.textContent = count;
            var totalEl = document.getElementById('editFormTotalVal');
            if (totalEl) totalEl.textContent = fmt(total) + ' đ';
            var liqTotalEl = document.getElementById('editFormLiqTotalVal');
            if (liqTotalEl) liqTotalEl.textContent = fmt(liqTotal) + ' đ';
        }

        cbs.forEach(function(cb) { cb.addEventListener('change', recalc); });

        document.querySelectorAll('#editPickTable .liq-price-input').forEach(function(el) {
            function formatPriceInput(el) {
                var digits = (el.value || '').replace(/[^0-9]/g, '');
                el.value = digits ? Number(digits).toLocaleString('vi-VN') : '';
            }
            formatPriceInput(el);
            el.addEventListener('input', function() { formatPriceInput(el); recalc(); });
        });

        var pickAll = document.getElementById('editPickAll');
        if (pickAll) {
            pickAll.addEventListener('change', function() {
                cbs.forEach(function(cb) {
                    var row = cb.closest('.pick-trow');
                    if (row && row.style.display !== 'none') cb.checked = pickAll.checked;
                });
                recalc();
            });
        }

        var search = document.getElementById('editSerialSearch');
        if (search) {
            search.addEventListener('input', function() {
                var q = (this.value || '').toLowerCase().trim();
                document.querySelectorAll('#editPickTable .pick-trow').forEach(function(row) {
                    var model = (row.getAttribute('data-model') || '').toLowerCase();
                    var serialEl = row.querySelector('.row-serial');
                    var serial = serialEl ? (serialEl.textContent || '').toLowerCase() : '';
                    var show = !q || model.indexOf(q) > -1 || serial.indexOf(q) > -1;
                    row.style.display = show ? '' : 'none';
                });
            });
        }

        var editForm = document.getElementById('editForm');
        if (editForm) {
            editForm.addEventListener('submit', function(e) {
                var checked = cbs.filter(function(cb) { return cb.checked; });
                if (checked.length === 0) {
                    e.preventDefault();
                    showToast('Phải chọn ít nhất 1 máy phát điện.', 'danger');
                    return;
                }
                var missingPrice = checked.some(function(cb) {
                    var row = cb.closest('.pick-trow');
                    var priceInput = row ? row.querySelector('.liq-price-input') : null;
                    var v = priceInput ? (priceInput.value || '').replace(/[^0-9]/g, '') : '';
                    return !v || Number(v) <= 0;
                });
                if (missingPrice) {
                    e.preventDefault();
                    showToast('Phải nhập giá thanh lý (lớn hơn 0) cho tất cả máy đã chọn.', 'danger');
                    return;
                }
                var allSamePrice = checked.every(function(cb) {
                    var row = cb.closest('.pick-trow');
                    var priceInput = row ? row.querySelector('.liq-price-input') : null;
                    var newPrice = priceInput ? (priceInput.value || '').replace(/[^0-9]/g, '') : '';
                    var oldPrice = cb.getAttribute('data-old-liq-price');
                    return oldPrice && newPrice && Number(oldPrice) === Number(newPrice);
                });
                if (allSamePrice) {
                    e.preventDefault();
                    showToast('Giá thanh lý không thay đổi so với giá cũ. Vui lòng điều chỉnh giá trước khi gửi lại.', 'danger');
                    return;
                }
                document.querySelectorAll('#editPickTable .liq-price-input').forEach(function(el) {
                    el.value = (el.value || '').replace(/[^0-9]/g, '');
                });
            });
        }

        recalc();
    })();

    // ===== EDIT MODE: warehouse change =====
    function changeEditWarehouse(whId) {
        if (!whId) return;
        var anyChecked = document.querySelectorAll('.pick-cb:checked').length > 0;
        if (anyChecked && !confirm('Đổi kho sẽ bỏ các máy đã chọn ở kho hiện tại. Tiếp tục?')) {
            var sel = document.getElementById('editWarehouseSelect');
            sel.value = document.getElementById('editWarehouseId').value;
            return;
        }
        var id = '${liquidation.liquidationId}';
        window.location.href = '${pageContext.request.contextPath}/liquidations?action=detail&id=' + encodeURIComponent(id) + '&warehouseId=' + encodeURIComponent(whId);
    }
</script>
</body>
</html>