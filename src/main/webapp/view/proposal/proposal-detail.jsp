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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }

            /* ============== Status pill ============== */
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-draft     { background: #e2e3e5; color: #383d41; }
            .status-pending   { background: #fff3cd; color: #856404; }
            .status-approved  { background: #d4edda; color: #155724; }
            .status-rejected  { background: #f8d7da; color: #721c24; }
            .status-converted { background: #cce5ff; color: #004085; }
            .status-cancelled { background: #d6d8db; color: #1d2129; }
            [data-theme="dark"] .status-pending   { background: var(--warn-soft); color: var(--warn); }
            [data-theme="dark"] .status-rejected  { background: var(--danger-soft); color: var(--danger); }
            [data-theme="dark"] .status-approved  { background: var(--accent-soft); color: var(--accent); }
            [data-theme="dark"] .status-converted { background: rgba(0, 64, 133, 0.25); color: #66b0ff; }
            .pdot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
                display: inline-block;
                opacity: 0.55;
            }

            /* ============== 1) Header Bar (top code strip) ============== */
            .header-bar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 12px;
                width: 100%;
                padding: 10px 18px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                margin-bottom: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
            }
            .header-bar .hb-left {
                display: flex;
                align-items: center;
                gap: 10px;
                min-width: 0;
            }
            .header-bar .hb-left .hb-icon {
                width: 30px;
                height: 30px;
                border-radius: 8px;
                background: var(--accent-soft);
                color: var(--accent);
                display: inline-flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
            }
            .header-bar .hb-left .hb-icon svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .header-bar .hb-left .hb-text {
                display: flex;
                flex-direction: column;
                line-height: 1.25;
                min-width: 0;
            }
            .header-bar .hb-left .hb-label {
                font-size: 11px;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.04em;
                font-weight: 600;
            }
            .header-bar .hb-left .hb-code {
                font-family: var(--font-mono);
                font-size: 14px;
                font-weight: 700;
                color: var(--fg);
                letter-spacing: 0.02em;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .header-bar .hb-right {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            /* ============== 2) Action Bar (button group) ============== */
            .action-bar {
                display: flex;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
                width: 100%;
                padding: 10px 14px;
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                margin-bottom: 16px;
            }
            .action-bar .ab-group {
                display: flex;
                align-items: center;
                gap: 8px;
                flex-wrap: wrap;
            }
            .action-bar .ab-divider {
                width: 1px;
                height: 22px;
                background: var(--border);
                margin: 0 4px;
            }

            /* ============== 3) Title & Status Section ============== */
            .title-status {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 14px;
                flex-wrap: wrap;
                width: 100%;
                padding: 4px 4px 14px 4px;
                margin-bottom: 6px;
            }
            .title-status .ts-title {
                display: flex;
                flex-direction: column;
                gap: 4px;
                min-width: 0;
            }
            .title-status .ts-title .ts-eyebrow {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.06em;
                color: var(--muted);
            }
            .title-status .ts-title .ts-h {
                font-size: 22px;
                font-weight: 700;
                color: var(--fg);
                line-height: 1.3;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
            }
            .title-status .ts-title .ts-h .ts-code {
                font-family: var(--font-mono);
                color: var(--accent);
                font-weight: 700;
            }
            .title-status .ts-title .ts-sub {
                font-size: 12.5px;
                color: var(--muted);
            }
            .title-status .ts-status {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .title-status .ts-status .status-pill {
                font-size: 12.5px;
                padding: 6px 12px;
            }

            /* ============== 4) Tab Navigation ============== */
            .tabs {
                display: flex;
                gap: 4px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 18px;
            }
            .tab {
                padding: 10px 20px;
                border: none;
                background: transparent;
                color: var(--muted);
                cursor: pointer;
                font-size: 13px;
                font-weight: 600;
                font-family: var(--font-ui);
                border-bottom: 2px solid transparent;
                margin-bottom: -1px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: color 0.15s, border-color 0.15s;
            }
            .tab:hover { color: var(--fg); }
            .tab.active {
                color: var(--fg);
                border-bottom-color: var(--accent);
            }
            .tab svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .tab .tab-count {
                background: var(--surface-2);
                color: var(--muted);
                font-size: 11px;
                padding: 1px 8px;
                border-radius: 10px;
                font-weight: 700;
            }
            .tab.active .tab-count {
                background: var(--accent-soft);
                color: var(--accent);
            }
            .tab-panel { display: none; }
            .tab-panel.active { display: block; }

            /* ============== 5) Detail Content Area (Read-only Grid) ============== */
            .detail-content {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 20px;
                width: 100%;
            }
            .detail-content .dc-section-title {
                font-size: 14px;
                font-weight: 700;
                color: var(--fg);
                margin: 0 0 16px 0;
                padding-bottom: 12px;
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .detail-content .dc-section-title svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
                color: var(--accent);
            }
            .detail-grid {
                display: grid;
                gap: 16px 20px;
            }
            .detail-grid.row-4 { grid-template-columns: repeat(4, 1fr); }
            .detail-grid.row-2 { grid-template-columns: repeat(2, 1fr); }
            .detail-grid.row-1 { grid-template-columns: 1fr; }
            .detail-field { min-width: 0; }
            .detail-field .df-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-bottom: 6px;
            }
            .detail-field .df-value {
                font-size: 14px;
                color: var(--fg);
                word-wrap: break-word;
                font-weight: 500;
                padding: 10px 12px;
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                min-height: 40px;
                display: flex;
                align-items: center;
            }
            .detail-field .df-value.mono {
                font-family: var(--font-mono);
            }
            .detail-field .df-value.empty {
                color: var(--muted);
                font-style: italic;
            }
            @media (max-width: 1024px) {
                .detail-grid.row-4 { grid-template-columns: repeat(2, 1fr); }
            }
            @media (max-width: 600px) {
                .detail-grid.row-4,
                .detail-grid.row-2 { grid-template-columns: 1fr; }
            }

            /* ============== Info label (dùng trong banner) ============== */
            .info-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-bottom: 6px;
            }

            /* ============== Note soft box (read-only) ============== */
            .note-soft {
                padding: 12px 16px;
                background: var(--surface-2);
                border-radius: var(--radius-sm);
                font-size: 13.5px;
                color: var(--fg);
                line-height: 1.6;
                white-space: pre-wrap;
                border: 1px solid var(--border);
            }

            .note-soft {
                padding: 12px 16px;
                background: var(--surface-2);
                border-radius: var(--radius-sm);
                font-size: 13.5px;
                color: var(--fg);
                line-height: 1.6;
                white-space: pre-wrap;
            }

            /* ============== Bảng chi tiết (card Chi tiết máy phát) ============== */
            .product-table {
                width: 100%;
                border-collapse: collapse;
            }
            .product-table th, .product-table td {
                padding: 12px 16px;
                text-align: left;
                border-bottom: 1px solid var(--border);
            }
            .product-table th {
                font-size: 11px;
                color: var(--muted);
                text-transform: uppercase;
                font-weight: 700;
                background: var(--surface-2);
                letter-spacing: 0.04em;
            }
            .product-table td { font-size: 13.5px; }
            .product-table tbody tr:hover { background: var(--surface-2); }
            .product-table tbody tr:last-child td { border-bottom: 0; }
            .text-center { text-align: center; }
            .detail-pager {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-top: 16px;
                font-size: 13px;
                color: var(--muted);
            }

            /* ============== Banners (reject / convert) ============== */
            .reject-banner {
                margin-bottom: 16px;
                padding: 14px 18px;
                background: var(--danger-soft);
                border-radius: var(--radius-sm);
                border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent);
                display: flex;
                gap: 12px;
                align-items: flex-start;
            }
            .reject-banner .info-label {
                color: var(--danger);
                margin-bottom: 4px;
            }
            .reject-banner svg {
                width: 18px;
                height: 18px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                color: var(--danger);
                flex-shrink: 0;
                margin-top: 1px;
            }
            .convert-banner {
                margin-bottom: 16px;
                padding: 14px 18px;
                background: rgba(0, 64, 133, 0.08);
                border-radius: var(--radius-sm);
                border: 1px solid color-mix(in srgb, #004085 25%, transparent);
                display: flex;
                gap: 12px;
                align-items: flex-start;
            }
            .convert-banner .info-label {
                color: #004085;
                margin-bottom: 4px;
            }
            .convert-banner svg {
                width: 18px;
                height: 18px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                color: #004085;
                flex-shrink: 0;
                margin-top: 1px;
            }

            /* ============== Lịch sử cập nhật ============== */
            .table-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                overflow: hidden;
            }
            .empty-state {
                text-align: center;
                padding: 40px 12px;
                color: var(--muted);
            }
            .history-table {
                width: 100%;
                border-collapse: collapse;
            }
            .history-table th {
                padding: 12px 16px;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                color: var(--muted);
                font-weight: 700;
                background: var(--surface-2);
                text-align: left;
                border-bottom: 2px solid var(--border);
            }
            .history-table td {
                padding: 12px 16px;
                font-size: 13px;
                color: var(--fg);
                border-bottom: 1px solid var(--border);
                vertical-align: middle;
            }
            .history-table tbody tr:hover { background: var(--surface-2); }
            .history-table tbody tr:last-child td { border-bottom: 0; }
            .history-table .detail-cell {
                color: var(--fg-soft);
                line-height: 1.55;
                max-width: 400px;
            }
            .history-table .mono {
                font-family: var(--font-mono);
                font-size: 12px;
            }
            .result-summary {
                padding: 12px 16px;
                font-size: 12.5px;
                color: var(--muted);
                border-bottom: 1px solid var(--border);
                background: var(--surface-2);
            }
            .action-badge {
                display: inline-block;
                padding: 3px 9px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.03em;
            }
            .action-create   { background: #e2e3e5; color: #383d41; }
            .action-update   { background: #cce5ff; color: #004085; }
            .action-approve  { background: #d4edda; color: #155724; }
            .action-reject   { background: #f8d7da; color: #721c24; }
            .action-cancel   { background: #d6d8db; color: #1d2129; }
            .action-convert  { background: #cce5ff; color: #004085; }
            .action-default  { background: var(--surface-2); color: var(--muted); }

            /* ============== Modal (nếu cần) ============== */
            .modal-host {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.45);
                display: none;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }
            .modal-host.show { display: flex; }
            .modal-card {
                background: var(--surface);
                border-radius: var(--radius);
                padding: 22px 24px;
                width: 460px;
                max-width: 90vw;
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
            }
            .modal-card h3 { margin: 0 0 6px 0; font-size: 17px; }
            .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; }
            .modal-card label {
                display: block;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                color: var(--muted);
                margin-bottom: 6px;
            }
            .modal-card textarea {
                width: 100%;
                min-height: 80px;
                padding: 8px 10px;
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                background: var(--surface);
                color: var(--fg);
                font-family: var(--font-ui);
                font-size: 13px;
                resize: vertical;
                box-sizing: border-box;
            }
            .modal-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: 14px;
            }

            /* ============== Buttons (Beautified) ============== */
            /* Override base .btn chỉ trong scope trang detail */
            .header-bar .btn,
            .action-bar .btn,
            .detail-pager .btn {
                position: relative;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
                height: 34px;
                padding: 0 14px;
                font-size: 12.5px;
                font-weight: 600;
                line-height: 1;
                border-radius: 8px;
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04),
                            inset 0 -1px 0 rgba(15, 23, 42, 0.04);
                transition: transform .12s ease, box-shadow .15s ease,
                            background .15s ease, border-color .15s ease, color .15s ease;
                white-space: nowrap;
                cursor: pointer;
            }
            .header-bar .btn svg,
            .action-bar .btn svg,
            .detail-pager .btn svg {
                width: 14px;
                height: 14px;
                stroke-width: 2;
            }
            .header-bar .btn:hover,
            .action-bar .btn:hover,
            .detail-pager .btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08),
                            inset 0 -1px 0 rgba(15, 23, 42, 0.04);
                background: var(--surface-2);
                border-color: color-mix(in srgb, var(--fg) 18%, var(--border));
            }
            .header-bar .btn:active,
            .action-bar .btn:active,
            .detail-pager .btn:active {
                transform: translateY(0);
                box-shadow: 0 1px 2px rgba(15, 23, 42, 0.06);
            }
            .header-bar .btn:focus-visible,
            .action-bar .btn:focus-visible,
            .detail-pager .btn:focus-visible {
                outline: none;
                box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 25%, transparent);
            }
            .header-bar .btn:disabled,
            .action-bar .btn:disabled,
            .detail-pager .btn:disabled {
                opacity: .55;
                cursor: not-allowed;
                transform: none;
                box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
            }

            /* Primary (gradient tím → xanh dương) */
            .header-bar .btn-primary,
            .action-bar .btn-primary {
                background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
                color: #fff;
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(79, 70, 229, 0.25),
                            0 4px 12px rgba(79, 70, 229, 0.18),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-primary:hover,
            .action-bar .btn-primary:hover {
                background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(79, 70, 229, 0.3),
                            0 8px 18px rgba(79, 70, 229, 0.28),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-primary:focus-visible,
            .action-bar .btn-primary:focus-visible {
                box-shadow: 0 0 0 3px color-mix(in srgb, #6366f1 35%, transparent),
                            0 4px 12px rgba(79, 70, 229, 0.18);
            }

            /* Success (gradient xanh lá) */
            .header-bar .btn-success,
            .action-bar .btn-success,
            .detail-pager .btn-success {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: #fff;
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(5, 150, 105, 0.25),
                            0 4px 12px rgba(5, 150, 105, 0.18),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-success:hover,
            .action-bar .btn-success:hover,
            .detail-pager .btn-success:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(5, 150, 105, 0.3),
                            0 8px 18px rgba(5, 150, 105, 0.28),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-success:focus-visible,
            .action-bar .btn-success:focus-visible,
            .detail-pager .btn-success:focus-visible {
                box-shadow: 0 0 0 3px color-mix(in srgb, #10b981 35%, transparent),
                            0 4px 12px rgba(5, 150, 105, 0.18);
            }

            /* Danger (gradient đỏ) */
            .header-bar .btn-danger,
            .action-bar .btn-danger,
            .detail-pager .btn-danger {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                color: #fff;
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(220, 38, 38, 0.25),
                            0 4px 12px rgba(220, 38, 38, 0.18),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-danger:hover,
            .action-bar .btn-danger:hover,
            .detail-pager .btn-danger:hover {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(220, 38, 38, 0.3),
                            0 8px 18px rgba(220, 38, 38, 0.28),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-danger:focus-visible,
            .action-bar .btn-danger:focus-visible,
            .detail-pager .btn-danger:focus-visible {
                box-shadow: 0 0 0 3px color-mix(in srgb, #ef4444 35%, transparent),
                            0 4px 12px rgba(220, 38, 38, 0.18);
            }

            /* Warn (gradient vàng/cam) */
            .header-bar .btn-warn,
            .action-bar .btn-warn,
            .detail-pager .btn-warn {
                background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                color: #fff;
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(217, 119, 6, 0.25),
                            0 4px 12px rgba(217, 119, 6, 0.18),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-warn:hover,
            .action-bar .btn-warn:hover,
            .detail-pager .btn-warn:hover {
                background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
                border-color: transparent;
                box-shadow: 0 1px 2px rgba(217, 119, 6, 0.3),
                            0 8px 18px rgba(217, 119, 6, 0.28),
                            inset 0 1px 0 rgba(255, 255, 255, 0.15);
            }
            .header-bar .btn-warn:focus-visible,
            .action-bar .btn-warn:focus-visible,
            .detail-pager .btn-warn:focus-visible {
                box-shadow: 0 0 0 3px color-mix(in srgb, #f59e0b 35%, transparent),
                            0 4px 12px rgba(217, 119, 6, 0.18);
            }

            /* Back link button (subtle ghost) */
            .action-bar .back-link {
                height: 34px;
                padding: 0 14px;
                font-size: 12.5px;
                font-weight: 600;
                color: var(--muted);
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 8px;
                box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04);
                margin-bottom: 0;
                transition: transform .12s ease, box-shadow .15s ease, color .15s ease, background .15s ease;
            }
            .action-bar .back-link:hover {
                color: var(--fg);
                background: var(--surface-2);
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(15, 23, 42, 0.08);
            }
            .action-bar .back-link svg { width: 14px; height: 14px; stroke-width: 2; }

            /* ============== Buttons (Dark mode tweaks) ============== */
            [data-theme="dark"] .header-bar .btn,
            [data-theme="dark"] .action-bar .btn,
            [data-theme="dark"] .detail-pager .btn {
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.3),
                            inset 0 1px 0 rgba(255, 255, 255, 0.04);
            }
            [data-theme="dark"] .header-bar .btn:hover,
            [data-theme="dark"] .action-bar .btn:hover,
            [data-theme="dark"] .detail-pager .btn:hover {
                box-shadow: 0 4px 14px rgba(0, 0, 0, 0.45),
                            inset 0 1px 0 rgba(255, 255, 255, 0.05);
            }
            [data-theme="dark"] .header-bar .btn-primary,
            [data-theme="dark"] .action-bar .btn-primary,
            [data-theme="dark"] .header-bar .btn-success,
            [data-theme="dark"] .action-bar .btn-success,
            [data-theme="dark"] .detail-pager .btn-success,
            [data-theme="dark"] .header-bar .btn-danger,
            [data-theme="dark"] .action-bar .btn-danger,
            [data-theme="dark"] .detail-pager .btn-danger,
            [data-theme="dark"] .header-bar .btn-warn,
            [data-theme="dark"] .action-bar .btn-warn,
            [data-theme="dark"] .detail-pager .btn-warn {
                box-shadow: 0 1px 2px rgba(0, 0, 0, 0.35),
                            0 6px 16px rgba(0, 0, 0, 0.35),
                            inset 0 1px 0 rgba(255, 255, 255, 0.12);
            }

            /* ============== Back link ============== */
            .back-link {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                color: var(--muted);
                text-decoration: none;
                font-size: 13px;
                margin-bottom: 14px;
                transition: color 0.15s;
            }
            .back-link:hover { color: var(--accent); }
            .back-link svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }

            /* ============== Alert (error từ controller) ============== */
            .alert {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 14px;
                border-radius: var(--radius);
                margin-bottom: 14px;
                font-size: 13px;
                font-weight: 600;
            }
            .alert svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                flex-shrink: 0;
            }
            .alert-error {
                background: var(--danger-soft);
                color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent);
            }

            /* ============== In ấn ============== */
            @media print {
                aside, .topbar, .back-link, .tabs, .toast-host,
                .header-bar, .action-bar {
                    display: none !important;
                }
                .detail-content { box-shadow: none; border: 1px solid #ddd; }
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
                            <span class="hb-icon">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                            </span>
                            <div class="hb-text">
                                <span class="hb-label">Đang xem phiếu</span>
                                <span class="hb-code"><c:out value="${proposal.proposalCode}"/></span>
                            </div>
                        </div>
                        <div class="hb-right">
                            <button type="button" class="btn" onclick="window.print()" title="In phiếu">
                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                                In phiếu
                            </button>
                        </div>
                    </div>

                    <%-- ============== 2) Action Bar (button group: back + business actions) ============== --%>
                    <div class="action-bar">
                        <div class="ab-group">
                            <a class="btn back-link" href="${pageContext.request.contextPath}/proposal" title="Quay lại danh sách">
                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
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
                                        <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                        Chỉnh sửa
                                    </a>
                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                                        <input type="hidden" name="submitType" value="submit" />
                                        <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">
                                            <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="20 6 9 17 4 12"/></svg>
                                            Gửi duyệt
                                        </button>
                                    </form>
                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:inline;">
                                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này? Hành động không thể hoàn tác.')">
                                            <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-2 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L5 6"/></svg>
                                            Xoá
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${proposal.status == 'PENDING'}">
                                    <c:if test="${perms.contains('proposals.approve')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận duyệt phiếu đề xuất này?')">
                                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="20 6 9 17 4 12"/></svg>
                                                Duyệt phiếu
                                            </button>
                                        </form>
                                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/proposal?action=reject&id=${proposal.proposalId}">
                                            <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                            Từ chối
                                        </a>
                                    </c:if>
                                    <c:if test="${perms.contains('proposals.cancel')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">
                                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
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
                                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><path d="M9 11l3 3 8-8"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                                                Tạo phiếu nhập từ đề xuất
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${perms.contains('proposals.cancel')}">
                                        <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                                            <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất đã duyệt?')">
                                                <svg viewBox="0 0 24 24" style="width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8;"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                                Huỷ phiếu
                                            </button>
                                        </form>
                                    </c:if>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <%-- ============== 3) Title & Status Section ============== --%>
                    <div class="title-status">
                        <div class="ts-title">
                            <span class="ts-eyebrow">Phiếu đề xuất nhập kho</span>
                            <h2 class="ts-h">
                                <span>Chi tiết đề xuất</span>
                                <span class="ts-code">#${proposal.proposalId}</span>
                            </h2>
                            <span class="ts-sub">
                                Ngày đề xuất: <c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose>
                                <span style="margin: 0 8px; color: var(--border);">·</span>
                                Kho: <c:out value="${proposal.warehouseName}"/>
                            </span>
                        </div>
                        <div class="ts-status">
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
                            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
                            Tổng quan
                        </button>
                        <button type="button" class="tab" data-tab="history">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                            <span class="tab-count">${totalHistory}</span>
                        </button>
                    </div>

                    <%-- ============== Tab Tổng quan (gộp Thông tin + Chi tiết) ============== --%>
                    <div class="tab-panel active" id="tab-overview">
                        <%-- 5) Detail Content Area: Thông tin chung (read-only grid 4 cột) --%>
                        <div class="detail-content" style="margin-bottom: 16px;">
                            <h3 class="dc-section-title">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                Thông tin chung
                            </h3>

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
                            <h3 class="dc-section-title" style="padding: 20px 20px 14px 20px; margin: 0; border-bottom: 1px solid var(--border);">
                                <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/></svg>
                                Chi tiết máy phát đề xuất
                            </h3>
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
                            <h3 class="dc-section-title" style="padding: 20px 20px 14px 20px; margin: 0; border-bottom: 1px solid var(--border);">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                            </h3>
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
