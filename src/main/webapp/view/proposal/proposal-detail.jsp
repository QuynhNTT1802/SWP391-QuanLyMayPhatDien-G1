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
            a.btn, a.back-link {
                text-decoration: none;
            }
            .product-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 12px;
            }
            .product-table th, .product-table td {
                padding: 12px 16px;
                text-align: left;
                border-bottom: 1px solid var(--border);
            }
            .product-table th {
                font-size: 12px;
                color: var(--muted);
                text-transform: uppercase;
                font-weight: 600;
                background: var(--surface-2);
                letter-spacing: 0.04em;
            }
            .product-table td {
                font-size: 13px;
            }
            .product-table tbody tr:hover {
                background: var(--surface-2);
            }
            .text-center {
                text-align: center;
            }
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-draft {
                background: #e2e3e5;
                color: #383d41;
            }
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            .status-approved {
                background: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background: #f8d7da;
                color: #721c24;
            }
            .status-converted {
                background: #cce5ff;
                color: #004085;
            }
            .status-cancelled {
                background: #d6d8db;
                color: #1d2129;
            }
            [data-theme="dark"] .status-pending {
                background: var(--warn-soft);
                color: var(--warn);
            }
            [data-theme="dark"] .status-rejected {
                background: var(--danger-soft);
                color: var(--danger);
            }
            [data-theme="dark"] .status-approved {
                background: var(--accent-soft);
                color: var(--accent);
            }
            [data-theme="dark"] .status-converted {
                background: rgba(0, 64, 133, 0.25);
                color: #66b0ff;
            }
            .hero-avatar.proposal {
                background: oklch(58% 0.16 290);
            }
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
            .alert-warn {
                background: var(--warn-soft);
                color: var(--warn);
                border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent);
            }
            .action-bar-top {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                padding: 12px 16px;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                margin-bottom: 16px;
            }
            .btn-warn {
                background: var(--warn);
                color: white;
                border-color: var(--warn);
            }
            .btn-warn:hover {
                filter: brightness(1.05);
            }
            .btn-success {
                background: var(--accent);
                color: white;
                border-color: var(--accent);
            }
            .btn-success:hover {
                filter: brightness(1.05);
            }
            .btn-danger {
                background: var(--danger);
                color: white;
                border-color: var(--danger);
            }
            .btn-danger:hover {
                filter: brightness(1.05);
            }
            .tabs {
                display: flex;
                gap: 2px;
                border-bottom: 1px solid var(--border);
                margin-bottom: 18px;
            }
            .tab {
                padding: 10px 18px;
                border: none;
                background: transparent;
                color: var(--muted);
                cursor: pointer;
                font-size: 13px;
                font-weight: 600;
                font-family: var(--font-ui);
                border-bottom: 2px solid transparent;
                margin-bottom: -1px;
            }
            .tab:hover {
                color: var(--fg);
            }
            .tab.active {
                color: var(--fg);
                border-bottom-color: var(--accent);
            }
            .tab-panel {
                display: none;
            }
            .tab-panel.active {
                display: block;
            }
            .detail-pager {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-top: 14px;
                font-size: 13px;
            }
            .modal-host {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.45);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 1000;
            }
            .modal-card {
                background: var(--surface);
                border-radius: var(--radius);
                padding: 22px 24px;
                width: 460px;
                max-width: 90vw;
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
            }
            .modal-card h3 {
                margin: 0 0 6px 0;
                font-size: 17px;
            }
            .modal-sub {
                font-size: 12.5px;
                color: var(--muted);
                margin-bottom: 14px;
            }
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
            }
            .modal-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: 14px;
            }
            .info-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 16px 24px;
            }
            .info-field {
                min-width: 0;
            }
            .info-label {
                font-size: 11px;
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-bottom: 4px;
            }
            .info-value {
                font-size: 13.5px;
                color: var(--fg);
                word-wrap: break-word;
            }
            .info-value.mono {
                font-family: var(--font-mono);
            }
            .info-value a {
                color: var(--accent);
            }
            .note-soft {
                padding: 10px 14px;
                background: var(--surface-2);
                border-radius: var(--radius-sm);
                font-size: 13px;
                color: var(--fg);
                line-height: 1.55;
            }
            .pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                background: var(--surface-2);
                color: var(--fg);
            }
            .pdot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
                display: inline-block;
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
            .table-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                overflow: hidden;
            }
            .empty-state {
                text-align: center;
                padding: 30px 12px;
                color: var(--muted);
            }
            .history-table {
                width: 100%;
                border-collapse: collapse;
            }
            .history-table th {
                padding: 11px 14px;
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
                padding: 11px 14px;
                font-size: 13px;
                color: var(--fg);
                border-bottom: 1px solid var(--border);
                vertical-align: middle;
            }
            .history-table tbody tr:hover {
                background: var(--surface-2);
            }
            .history-table .detail-cell {
                color: var(--fg-soft);
                line-height: 1.55;
                max-width: 360px;
            }
            .history-table .mono {
                font-family: var(--font-mono);
                font-size: 12px;
                color: var(--fg);
            }
            .result-summary {
                font-size: 12.5px;
                color: var(--muted);
            }
            .reject-banner {
                margin-bottom: 18px;
                padding: 12px 16px;
                background: var(--danger-soft);
                border-radius: var(--radius-sm);
                border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent);
            }
            .reject-banner .info-label {
                color: var(--danger);
            }
            .convert-banner {
                margin-bottom: 18px;
                padding: 12px 16px;
                background: rgba(0, 64, 133, 0.08);
                border-radius: var(--radius-sm);
                border: 1px solid color-mix(in srgb, #004085 25%, transparent);
            }
            .convert-banner .info-label {
                color: #004085;
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
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <div class="hero">
                        <div class="hero-avatar proposal">P</div>
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${proposal.proposalCode}"/>
                                <c:choose>
                                    <c:when test="${proposal.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Nháp</span></c:when>
                                    <c:when test="${proposal.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${proposal.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                    <c:when test="${proposal.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                    <c:when test="${proposal.status == 'CONVERTED'}"><span class="status-pill status-converted"><span class="pdot"></span>Đã chuyển phiếu nhập</span></c:when>
                                    <c:when test="${proposal.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã huỷ</span></c:when>
                                    <c:otherwise><span class="status-pill"><c:out value="${proposal.status}"/></span></c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="hero-meta">
                                <span>Phiếu đề xuất nhập kho</span>
                                <span class="sep">·</span>
                                <span class="id">#${proposal.proposalId}</span>
                                <span class="sep">·</span>
                                <span>Ngày đề xuất: <c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose></span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill"><span class="pdot"></span><c:out value="${proposal.warehouseName}"/></span>
                                <span class="pill"><span class="pdot"></span>Người tạo: <c:out value="${proposal.createdByName}"/></span>
                                <c:if test="${not empty proposal.approvedByName}">
                                    <span class="pill"><span class="pdot"></span>Người duyệt: <c:out value="${proposal.approvedByName}"/></span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <c:set var="isOwner" value="${sessionScope.loggedUser.id == proposal.createdBy}" />
                    <c:set var="perms" value="${sessionScope.userPermissions}" />

                    <c:if test="${proposal.status == 'DRAFT' && isOwner}">
                        <div class="action-bar-top">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Chỉnh sửa
                            </a>
                            <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                <input type="hidden" name="id" value="${proposal.proposalId}" />
                                <input type="hidden" name="submitType" value="submit" />
                                <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Gửi duyệt
                                </button>
                            </form>
                            <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:inline;">
                                <input type="hidden" name="id" value="${proposal.proposalId}" />
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này? Hành động không thể hoàn tác.')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-2 14a2 2 0 0 1-2 2H9a2 2 0 0 1-2-2L5 6"/></svg>
                                    Xoá
                                </button>
                            </form>
                        </div>
                    </c:if>

                    <c:if test="${proposal.status == 'PENDING'}">
                        <div class="action-bar-top">
                            <c:if test="${perms.contains('proposals.approve')}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận duyệt phiếu đề xuất này?')">
                                        <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                        Duyệt phiếu
                                    </button>
                                </form>
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>
                            <c:if test="${perms.contains('proposals.cancel')}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">
                                        <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                        Huỷ phiếu
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </c:if>

                    <c:if test="${proposal.status == 'APPROVED'}">
                        <div class="action-bar-top">
                            <c:if test="${perms.contains('proposals.convert')}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=convert" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-success">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M9 11l3 3 8-8"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                                        Tạo phiếu nhập từ đề xuất
                                    </button>
                                </form>
                            </c:if>
                            <c:if test="${perms.contains('proposals.cancel')}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất đã duyệt?')">
                                        <svg class="icon" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                        Huỷ phiếu
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </c:if>

                    <div class="section" style="padding: 18px 22px;">
                        <div class="tabs">
                            <button type="button" class="tab active" data-tab="info">Thông tin chung</button>
                            <button type="button" class="tab" data-tab="details">Chi tiết dòng hàng</button>
                            <button type="button" class="tab" data-tab="history">Lịch sử cập nhật</button>
                        </div>

                        <div class="tab-panel active" id="tab-info">
                            <c:if test="${proposal.status == 'REJECTED'}">
                                <div class="reject-banner">
                                    <div class="info-label">Lý do từ chối</div>
                                    <div style="margin-top:4px;font-size:13px;color:var(--fg);">
                                        <c:out value="${not empty proposal.rejectReason ? proposal.rejectReason : '(Không có lý do)'}"/>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${proposal.status == 'CONVERTED' && not empty proposal.convertedReceiptCode}">
                                <div class="convert-banner">
                                    <div class="info-label">Đã chuyển thành phiếu nhập</div>
                                    <div style="margin-top:4px;font-size:13px;color:var(--fg);">
                                        <a href="${pageContext.request.contextPath}/receipt?action=detail&id=${proposal.convertedReceiptId}" class="mono" style="color:#004085;font-weight:700;">
                                            <c:out value="${proposal.convertedReceiptCode}"/>
                                        </a>
                                    </div>
                                </div>
                            </c:if>

                            <div class="info-grid">
                                <div class="info-field">
                                    <div class="info-label">Mã phiếu</div>
                                    <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Kho</div>
                                    <div class="info-value"><c:out value="${proposal.warehouseName}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Người tạo</div>
                                    <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Ngày đề xuất</div>
                                    <div class="info-value mono"><c:choose><c:when test="${proposal.proposalDate == null}">—</c:when><c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise></c:choose></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Trạng thái</div>
                                    <div class="info-value">
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
                                <c:if test="${not empty proposal.approvedByName}">
                                    <div class="info-field">
                                        <div class="info-label">Người duyệt</div>
                                        <div class="info-value"><c:out value="${proposal.approvedByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Ngày duyệt</div>
                                        <div class="info-value mono"><c:choose><c:when test="${proposal.approvedAt == null}">—</c:when><c:otherwise>${proposal.approvedAt.format(propFmt)}</c:otherwise></c:choose></div>
                                    </div>
                                </c:if>
                                <c:if test="${proposal.status == 'REJECTED' && not empty proposal.rejectedByName}">
                                    <div class="info-field">
                                        <div class="info-label">Người từ chối</div>
                                        <div class="info-value"><c:out value="${proposal.rejectedByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Ngày từ chối</div>
                                        <div class="info-value mono"><c:choose><c:when test="${proposal.rejectedAt == null}">—</c:when><c:otherwise>${proposal.rejectedAt.format(propFmt)}</c:otherwise></c:choose></div>
                                    </div>
                                </c:if>
                            </div>

                            <c:if test="${not empty proposal.note}">
                                <div style="margin-top: 18px;">
                                    <div class="info-label">Ghi chú</div>
                                    <div class="note-soft"><c:out value="${proposal.note}"/></div>
                                </div>
                            </c:if>
                        </div>

                        <div class="tab-panel" id="tab-details">
                            <c:set var="details" value="${proposal.details}" />
                            <table class="product-table" id="detailTable">
                                <thead>
                                    <tr>
                                        <th style="width: 40px;">#</th>
                                        <th>Máy phát / Hãng</th>
                                        <th style="width: 90px;">Số lượng</th>
                                        <th style="width: 110px;">Tồn kho hiện tại</th>
                                        <th>Ghi chú</th>
                                    </tr>
                                </thead>
                                <tbody id="detailBody">
                                    <c:choose>
                                        <c:when test="${empty details}">
                                            <tr><td colspan="5" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${details}" varStatus="st">
                                                <tr class="detail-row">
                                                    <td class="mono">${st.index + 1}</td>
                                                    <td>
                                                        <strong><c:out value="${d.generatorName}"/></strong>
                                                        <span style="color: var(--muted);"> · <c:out value="${d.brandName}"/></span>
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
                                <div class="detail-pager" id="detailPagination">
                                    <button type="button" class="btn" id="prevDetailPage">‹ Trước</button>
                                    <span class="page-info" id="detailPageInfo"></span>
                                    <button type="button" class="btn" id="nextDetailPage">Sau ›</button>
                                </div>
                            </c:if>
                        </div>

                        <div class="tab-panel" id="tab-history">
                            <div class="table-card">
                                <div style="padding: 12px 14px;">
                                    <div class="result-summary">Tìm thấy <strong>${totalHistory}</strong> bản ghi</div>
                                </div>
                                <table class="history-table">
                                    <thead><tr>
                                        <th style="width:150px;">Thời gian</th>
                                        <th style="width:180px;">Người thực hiện</th>
                                        <th style="width:140px;">Hành động</th>
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
                    </div>
                </main>
            </div>
        </div>

        <c:if test="${proposal.status == 'PENDING' && perms.contains('proposals.reject')}">
            <div class="modal-host" id="rejectModal" style="display:none;">
                <div class="modal-card">
                    <h3>Từ chối phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu sẽ bị từ chối và không thể chỉnh sửa. Vui lòng nhập lý do để người tạo biết.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=reject">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <label>Lý do từ chối <span style="color:var(--danger);">*</span></label>
                        <textarea name="rejectReason" placeholder="Mô tả chi tiết lý do từ chối..." required></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

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
                if (m) m.style.display = 'flex';
            }
            function closeModal(id) {
                var m = document.getElementById(id);
                if (m) m.style.display = 'none';
            }
        </script>
    </body>
</html>
