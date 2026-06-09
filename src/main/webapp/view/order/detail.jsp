<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }

            /* ============== Page head ============== */
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

            /* ============== Status pill ============== */
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
            .status-cancelled { color: var(--muted); border-color: var(--border); background: var(--surface-2); }
            .status-pending   { color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft); }
            .status-approved  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft); }
            .status-rejected  { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft); }

            /* ============== Header bar ============== */
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

            /* ============== Action bar ============== */
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

            /* ============== Buttons (scope override) ============== */
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

            /* ============== Detail grid ============== */
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

            /* ============== Tables ============== */
            .product-table {
                width: 100%; border-collapse: separate; border-spacing: 0;
                border: 1px solid var(--border); border-radius: var(--radius);
                overflow: hidden; font-size: 13px;
            }
            .product-table th, .product-table td {
                padding: 11px 14px; text-align: left;
                border-bottom: 1px solid var(--border);
            }
            .product-table th {
                font-size: 11px; color: var(--muted);
                text-transform: uppercase; font-weight: 700;
                background: var(--surface-2); letter-spacing: 0.04em;
            }
            .product-table td {
                font-size: 13.5px; color: var(--fg); vertical-align: middle;
            }
            .product-table tbody tr:hover { background: var(--surface-2); }
            .product-table tbody tr:last-child td { border-bottom: 0; }
            .text-right { text-align: right; }
            .text-center { text-align: center; }
            .product-table tfoot td {
                font-size: 14px; font-weight: 700;
                background: var(--surface-2);
                color: var(--accent);
                border-top: 1px solid var(--border);
            }
            .detail-pager {
                display: flex; align-items: center; justify-content: center;
                gap: 12px; margin-top: 16px;
                font-size: 13px; color: var(--muted);
            }
            .empty-state {
                text-align: center; padding: 40px 12px; color: var(--muted);
            }

            /* ============== Generator link (mở modal info máy) ============== */
            .gen-link {
                color: var(--accent);
                cursor: pointer;
                text-decoration: none;
                font-weight: 600;
            }
            .gen-link:hover {
                text-decoration: underline;
            }

            /* ============== Banners ============== */
            .reject-banner {
                display: flex; align-items: flex-start; gap: 10px;
                padding: 12px 16px; margin-bottom: 16px;
                border-radius: var(--radius-sm);
                font-size: 13px; font-weight: 500;
            }
            .reject-banner svg {
                width: 18px; height: 18px; stroke: currentColor; fill: none;
                stroke-width: 2; flex-shrink: 0; margin-top: 1px;
            }
            .reject-banner {
                background: var(--danger-soft); color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent);
            }
            .reject-banner .info-label { color: var(--danger); margin-bottom: 4px; }
            .info-label {
                font-size: 11px; font-weight: 700;
                text-transform: uppercase; letter-spacing: 0.04em;
                margin-bottom: 6px;
            }

            /* ============== Modal info máy phát ============== */
            .gen-modal-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,.45);
                z-index: 1000;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .gen-modal-backdrop.open {
                display: flex;
            }
            .gen-modal {
                background: var(--surface);
                border-radius: 8px;
                width: 100%;
                max-width: 480px;
                box-shadow: 0 10px 40px rgba(0,0,0,.25);
                overflow: hidden;
                animation: modalPop .18s ease-out;
            }
            @keyframes modalPop {
                from { transform: scale(.96); opacity: 0; }
                to   { transform: scale(1); opacity: 1; }
            }
            .gen-modal-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 18px;
                border-bottom: 1px solid var(--border);
            }
            .gen-modal-header h3 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
            }
            .gen-modal-close {
                background: transparent;
                border: none;
                font-size: 22px;
                line-height: 1;
                cursor: pointer;
                color: var(--muted);
                padding: 0 4px;
            }
            .gen-modal-close:hover { color: var(--fg); }
            .gen-modal-body {
                padding: 16px 18px;
            }
            .gen-info-row {
                display: flex;
                gap: 10px;
                padding: 8px 0;
                border-bottom: 1px dashed var(--border);
                font-size: 13.5px;
            }
            .gen-info-row:last-child { border-bottom: none; }
            .gen-info-row .lbl {
                flex: 0 0 120px;
                color: var(--muted);
                font-weight: 500;
            }
            .gen-info-row .val {
                flex: 1;
                color: var(--fg);
                word-break: break-word;
            }
            .gen-modal-footer {
                padding: 12px 18px;
                border-top: 1px solid var(--border);
                display: flex;
                justify-content: flex-end;
                gap: 8px;
                background: var(--surface-2);
            }

            /* ============== Alert ============== */
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
                aside, .topbar, .tabs, .toast-host,
                .header-bar, .action-bar,
                .gen-modal-backdrop {
                    display: none !important;
                }
                .detail-content { border: 1px solid #ddd; }
                body, .app > div:last-child, main { background: #fff !important; }
            }
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
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <c:set var="perms" value="${userPermissions != null ? userPermissions : sessionScope.userPermissions}" />

                    <%-- ============== 1) Header Bar ============== --%>
                    <div class="header-bar">
                        <div class="hb-left">
                            <div class="hb-text">
                                <span class="hb-num">00</span>
                                <span class="hb-label">Đang xem đơn hàng</span>
                                <span class="hb-code"><c:out value="${order.orderCode}"/></span>
                            </div>
                        </div>
                        <div class="hb-right">
                            <button type="button" class="btn" onclick="window.print()" title="In đơn hàng">
                                In đơn
                            </button>
                        </div>
                    </div>

                    <%-- ============== 2) Action Bar ============== --%>
                    <div class="action-bar">
                        <div class="ab-group">
                            <a class="btn back-link" href="${pageContext.request.contextPath}/order?action=list" title="Quay lại danh sách">
                                Quay lại danh sách
                            </a>
                        </div>

                        <c:set var="hasActions" value="false" />
                        <c:if test="${order.status == 'PENDING'}"><c:set var="hasActions" value="true" /></c:if>
                        <c:if test="${order.status == 'APPROVED' && perms != null && perms.contains('orders.cancel')}"><c:set var="hasActions" value="true" /></c:if>

                        <c:if test="${hasActions}">
                            <div class="ab-divider"></div>
                            <div class="ab-group">
                                <c:if test="${order.status == 'PENDING' && perms != null && perms.contains('orders.update')}">
                                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/order?action=edit&id=${order.orderId}">
                                        Chỉnh sửa
                                    </a>
                                </c:if>

                                <c:if test="${order.status == 'PENDING' && perms != null && perms.contains('orders.approve')}">
                                    <form method="POST" action="${pageContext.request.contextPath}/order" style="display:inline;">
                                        <input type="hidden" name="action" value="approve" />
                                        <input type="hidden" name="id" value="${order.orderId}" />
                                        <button type="submit" class="btn btn-success" onclick="return confirmApproveAction()">
                                            Duyệt đơn
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${order.status == 'PENDING' && perms != null && perms.contains('orders.reject')}">
                                    <a class="btn btn-danger" href="${pageContext.request.contextPath}/order?action=reject&id=${order.orderId}">
                                        Từ chối
                                    </a>
                                </c:if>

                                <c:if test="${(order.status == 'PENDING' || order.status == 'APPROVED') && perms != null && perms.contains('orders.cancel')}">
                                    <form method="POST" action="${pageContext.request.contextPath}/order" style="display:inline;">
                                        <input type="hidden" name="action" value="cancel" />
                                        <input type="hidden" name="id" value="${order.orderId}" />
                                        <button type="submit" class="btn btn-warn" onclick="return confirmCancelAction()">
                                            Hủy đơn
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <%-- ============== 3) Page Head ============== --%>
                    <div class="page-head">
                        <div class="eyebrow">Đơn hàng bán</div>
                        <h1 class="title">
                            <span>Chi tiết đơn hàng</span>
                            <span class="ts-code">#<c:out value="${order.orderId}"/></span>
                            <span class="ts-status">
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                    <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                    <c:when test="${order.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                    <c:otherwise><span class="status-pill"><c:out value="${order.status}"/></span></c:otherwise>
                                </c:choose>
                            </span>
                        </h1>
                        <div class="lede">
                            <span>Ngày đặt: <c:choose><c:when test="${order.orderDate == null}"><span style="color:var(--muted);">—</span></c:when><c:otherwise><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></c:otherwise></c:choose></span>
                            <span class="sep">·</span>
                            <span>Khách hàng: <c:out value="${order.customer.name}"/></span>
                            <span class="sep">·</span>
                            <span>Tổng tiền: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></span>
                        </div>
                    </div>

                    <%-- ============== Reject banner ============== --%>
                    <c:if test="${order.status == 'REJECTED' && not empty order.rejectReason}">
                        <div class="reject-banner">
                            <svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            <div style="flex:1;">
                                <div class="info-label">Đã bị từ chối</div>
                                <div style="margin-top:4px;font-size:13.5px;">
                                    <c:out value="${order.rejectReason}"/>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <%-- ============== Section 1: Thông tin đơn hàng + Khách hàng ============== --%>
                    <div class="detail-content">
                        <div class="dc-section-head">
                            <div class="dc-section-head-left">
                                <span class="dc-num">01</span>
                                <h3 class="dc-section-title">Thông tin đơn hàng &amp; khách hàng</h3>
                            </div>
                            <span class="dc-section-sub">Read-only</span>
                        </div>

                        <%-- Dòng 1 (4 cột): Mã đơn · Tên đơn · Ngày đặt · Trạng thái --%>
                        <div class="detail-grid row-4" style="margin-bottom: 16px;">
                            <div class="detail-field">
                                <div class="df-label">Mã đơn</div>
                                <div class="df-value mono"><c:out value="${order.orderCode}"/></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Tên đơn</div>
                                <div class="df-value">Đơn hàng #<c:out value="${order.orderId}"/></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Ngày đặt</div>
                                <div class="df-value mono"><c:choose><c:when test="${order.orderDate == null}"><span class="empty">—</span></c:when><c:otherwise><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></c:otherwise></c:choose></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Trạng thái</div>
                                <div class="df-value">
                                    <c:choose>
                                        <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                        <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                        <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                        <c:when test="${order.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                        <c:otherwise><span class="status-pill"><c:out value="${order.status}"/></span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <%-- Dòng 2 (4 cột): Người tạo · Người duyệt · Ngày duyệt · Tổng tiền --%>
                        <div class="detail-grid row-4" style="margin-bottom: 16px;">
                            <div class="detail-field">
                                <div class="df-label">Người tạo</div>
                                <div class="df-value"><c:out value="${order.createdByName}"/></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Người duyệt</div>
                                <div class="df-value"><c:out value="${not empty order.approvedByName ? order.approvedByName : '—'}"/></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Ngày duyệt</div>
                                <div class="df-value mono"><c:choose><c:when test="${order.approvedAt == null}"><span class="empty">—</span></c:when><c:otherwise><fmt:formatDate value="${order.approvedAt}" pattern="dd/MM/yyyy HH:mm"/></c:otherwise></c:choose></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Tổng tiền</div>
                                <div class="df-value mono" style="color: var(--accent);">
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                </div>
                            </div>
                        </div>

                        <c:if test="${order.status == 'REJECTED'}">
                            <div class="detail-grid row-4" style="margin-bottom: 16px;">
                                <div class="detail-field">
                                    <div class="df-label">Người từ chối</div>
                                    <div class="df-value"><c:out value="${not empty order.rejectedByName ? order.rejectedByName : '—'}"/></div>
                                </div>
                                <div class="detail-field" style="grid-column: span 3;">
                                    <div class="df-label">Lý do từ chối</div>
                                    <div class="df-value" style="color: var(--danger);"><c:out value="${not empty order.rejectReason ? order.rejectReason : '—'}"/></div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${order.status == 'CANCELLED'}">
                            <div class="detail-grid row-4" style="margin-bottom: 16px;">
                                <div class="detail-field">
                                    <div class="df-label">Người hủy</div>
                                    <div class="df-value"><c:out value="${not empty order.cancelledByName ? order.cancelledByName : '—'}"/></div>
                                </div>
                                <div class="detail-field">
                                    <div class="df-label">Ngày hủy</div>
                                    <div class="df-value mono"><c:choose><c:when test="${order.cancelledAt == null}"><span class="empty">—</span></c:when><c:otherwise><fmt:formatDate value="${order.cancelledAt}" pattern="dd/MM/yyyy HH:mm"/></c:otherwise></c:choose></div>
                                </div>
                            </div>
                        </c:if>

                        <%-- Dòng khách hàng --%>
                        <div class="detail-grid row-4" style="margin-top: 6px; padding-top: 16px; border-top: 1px dashed var(--border);">
                            <div class="detail-field">
                                <div class="df-label">Tên khách hàng</div>
                                <div class="df-value"><c:out value="${order.customer.name}"/></div>
                            </div>
                            <div class="detail-field">
                                <div class="df-label">Số điện thoại</div>
                                <div class="df-value mono"><c:out value="${order.customer.phone}"/></div>
                            </div>
                            <c:if test="${not empty order.customer.email}">
                                <div class="detail-field">
                                    <div class="df-label">Email</div>
                                    <div class="df-value mono"><c:out value="${order.customer.email}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.customer.companyName}">
                                <div class="detail-field">
                                    <div class="df-label">Công ty</div>
                                    <div class="df-value"><c:out value="${order.customer.companyName}"/></div>
                                </div>
                            </c:if>
                        </div>

                        <div class="detail-grid row-2" style="margin-top: 14px;">
                            <div class="detail-field">
                                <div class="df-label">Địa chỉ giao hàng</div>
                                <div class="df-value"><c:out value="${order.customer.address}"/></div>
                            </div>
                            <c:if test="${not empty customerTypeName}">
                                <div class="detail-field">
                                    <div class="df-label">Loại khách hàng</div>
                                    <div class="df-value"><c:out value="${customerTypeName}"/></div>
                                </div>
                            </c:if>
                        </div>

                        <c:if test="${not empty order.note || not empty order.customerNote}">
                            <div class="detail-grid row-1" style="margin-top: 14px; padding-top: 14px; border-top: 1px dashed var(--border);">
                                <c:if test="${not empty order.note}">
                                    <div class="detail-field" style="margin-bottom: 10px;">
                                        <div class="df-label">Ghi chú nội bộ</div>
                                        <div class="note-soft"><c:out value="${order.note}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty order.customerNote}">
                                    <div class="detail-field">
                                        <div class="df-label">Ghi chú của khách hàng</div>
                                        <div class="note-soft"><c:out value="${order.customerNote}"/></div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <%-- ============== Section 2: Danh sách máy phát điện ============== --%>
                    <div class="detail-content" style="padding: 0; margin-bottom: 0;">
                        <div class="dc-section-head" style="padding: 18px 22px 14px 22px; border-bottom: 1px solid var(--border);">
                            <div class="dc-section-head-left">
                                <span class="dc-num">02</span>
                                <h3 class="dc-section-title">Danh sách máy phát điện</h3>
                            </div>
                            <span class="dc-section-sub"><c:out value="${fn:length(details)}"/> dòng hàng</span>
                        </div>
                        <table class="product-table" id="detailTable">
                            <thead>
                                <tr>
                                    <th style="width:50px;">#</th>
                                    <th>Sản phẩm / Mã</th>
                                    <th style="width:80px;" class="text-center">SL</th>
                                    <th style="width:140px;" class="text-right">Đơn giá</th>
                                    <th style="width:160px;" class="text-right">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${empty details}">
                                        <tr><td colspan="5" class="text-center" style="padding:32px;color:var(--muted);">Chưa có sản phẩm nào trong đơn hàng.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${details}" varStatus="st">
                                            <tr class="detail-row">
                                                <td class="mono">${st.index + 1}</td>
                                                <td>
                                                    <a href="javascript:void(0);" class="gen-link"
                                                       onclick="showGenModal(this)"
                                                       data-gen-id="<c:out value='${d.generatorId}'/>"
                                                       data-gen-model="<c:out value='${d.generatorModel}'/>"
                                                       data-gen-unit-price="<fmt:formatNumber value='${d.unitPrice}' type='currency' currencySymbol='₫'/>"
                                                       data-gen-qty="<c:out value='${d.quantity}'/>"
                                                       title="Xem thông tin máy phát">
                                                        <c:out value="${d.generatorModel}"/>
                                                    </a>
                                                </td>
                                                <td class="text-center mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                <td class="text-right mono"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                <td class="text-right mono"><fmt:formatNumber value="${d.quantity * d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            <c:if test="${not empty details}">
                                <tfoot>
                                    <tr>
                                        <td colspan="4" class="text-right" style="text-transform:uppercase;font-size:11px;letter-spacing:0.04em;color:var(--muted);">Tổng cộng</td>
                                        <td class="text-right mono"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                    </tr>
                                </tfoot>
                            </c:if>
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
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <%-- ============== Modal thông tin máy phát ============== --%>
        <div class="gen-modal-backdrop" id="genModal" onclick="if (event.target === this) closeGenModal();">
            <div class="gen-modal" role="dialog" aria-modal="true" aria-labelledby="genModalTitle">
                <div class="gen-modal-header">
                    <h3 id="genModalTitle">Thông tin máy phát</h3>
                    <button type="button" class="gen-modal-close" onclick="closeGenModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="gen-modal-body">
                    <div class="gen-info-row">
                        <div class="lbl">Mã máy phát</div>
                        <div class="val" id="gm-id">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Tên model</div>
                        <div class="val" id="gm-model">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Số lượng đặt</div>
                        <div class="val" id="gm-qty">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Đơn giá</div>
                        <div class="val" id="gm-unit-price">—</div>
                    </div>
                </div>
                <div class="gen-modal-footer">
                    <button type="button" class="btn" onclick="closeGenModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="gm-detail-link">
                        <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <script>
            <c:if test="${not empty sessionScope.message}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${sessionScope.message}"/>';
            window.SESSION_DATA.type = '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>';
            </c:if>
        </script>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
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

            function showGenModal(el) {
                if (window.event) window.event.stopPropagation();
                var id = el.getAttribute('data-gen-id') || '';
                var model = el.getAttribute('data-gen-model') || '—';
                var qty = el.getAttribute('data-gen-qty') || '—';
                var unitPrice = el.getAttribute('data-gen-unit-price') || '—';

                document.getElementById('gm-id').textContent = id || '—';
                document.getElementById('gm-model').textContent = model;
                document.getElementById('gm-qty').textContent = qty;
                document.getElementById('gm-unit-price').textContent = unitPrice;
                document.getElementById('gm-detail-link').href = window.APP_CTX + '/warehouse/generators?action=view&id=' + id;

                document.getElementById('genModal').classList.add('open');
            }
            function closeGenModal() {
                document.getElementById('genModal').classList.remove('open');
            }

            function confirmApproveAction() {
                return confirm('Bạn có chắc muốn duyệt đơn hàng này?');
            }
            function confirmCancelAction() {
                return confirm('Bạn có chắc muốn hủy đơn hàng này? Hành động này không thể hoàn tác.');
            }

            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeGenModal();
            });
        </script>
    </body>
</html>
