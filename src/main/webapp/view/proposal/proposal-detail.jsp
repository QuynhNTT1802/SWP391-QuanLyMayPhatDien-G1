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
        <style>
            a.btn, a.back-link { text-decoration: none; }
            .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
            .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
            .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
            .alert-info { background: var(--info-soft); color: var(--info); border: 1px solid color-mix(in srgb, var(--info) 25%, transparent); }

            .product-table { width: 100%; border-collapse: collapse; }
            .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); vertical-align: middle; }
            .product-table th { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); letter-spacing: 0.04em; }
            .product-table td { font-size: 13px; }
            .product-table tbody tr:hover { background: var(--surface-2); }
            .product-table tfoot td { background: var(--surface-2); font-weight: 700; }
            .text-center { text-align: center; }
            .text-right { text-align: right; }
            .mono { font-family: var(--font-mono); }

            .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
            .danger-note { background: color-mix(in srgb, var(--danger-soft) 70%, transparent); color: var(--danger); padding: 14px; border-radius: var(--radius-sm); border-left: 3px solid var(--danger); white-space: pre-wrap; line-height: 1.55; }

            .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
            .filter-active-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); font-weight: 600; font-size: 11px; }
            .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
            .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
            .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
            .empty-state strong { color: var(--fg); font-size: 14px; }

            .info-value .status-pill { white-space: nowrap; }

            .action-bar-top { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; }
            .action-bar-secondary { display: flex; gap: 8px; flex-wrap: wrap; margin-top: -8px; margin-bottom: 16px; }

            .tab-bar { display: flex; gap: 4px; border-bottom: 1px solid var(--border); margin-bottom: 16px; }
            .tab { display: inline-flex; align-items: center; gap: 8px; padding: 10px 16px; font-size: 13px; font-weight: 600; color: var(--muted); text-decoration: none; border-bottom: 2px solid transparent; margin-bottom: -1px; transition: all .12s ease; }
            .tab:hover { color: var(--fg); }
            .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
            .tab-icon { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2; }
            .tab-badge { display: inline-flex; align-items: center; justify-content: center; min-width: 18px; height: 18px; padding: 0 6px; font-family: var(--font-mono); font-size: 11px; font-weight: 700; background: var(--surface-2); border: 1px solid var(--border); color: var(--muted); border-radius: 999px; }
            .tab.active .tab-badge { background: var(--accent-soft); color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); }

            .history-filter-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; padding: 12px 14px; background: var(--surface); border: 1px solid var(--border); border-bottom: 0; border-radius: var(--radius) var(--radius) 0 0; }
            .history-filter-bar .hf-search { flex: 1; min-width: 200px; max-width: 320px; }
            .history-filter-bar .date-range { display: inline-flex; align-items: center; gap: 6px; }
            .history-filter-bar .date-label { font-size: 11px; color: var(--muted); font-weight: 600; }
            .history-filter-bar .date-input { border: 1px solid var(--border); background: var(--surface-2); color: var(--fg); border-radius: var(--radius-sm); padding: 6px 10px; font-size: 12.5px; font-family: var(--font-ui); font-weight: 600; }

            .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-card .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; line-height: 1.5; }
            .modal-card label { display: block; font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 6px; }
            .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; min-height: 80px; resize: vertical; }
            .modal-card textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
            .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }

            .action-badge { display: inline-flex; align-items: center; gap: 5px; font-size: 11px; font-weight: 700; padding: 2px 9px; border-radius: 999px; border: 1px solid; text-transform: uppercase; letter-spacing: 0.02em; font-family: var(--font-ui); }
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
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:choose>
                        <c:when test="${proposal.status == 'DRAFT'}">
                            <c:set var="statusLabel" value="Nháp"/>
                            <c:set var="statusBg" value="#e2e3e5"/>
                            <c:set var="statusFg" value="#383d41"/>
                        </c:when>
                        <c:when test="${proposal.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusBg" value="#fff3cd"/>
                            <c:set var="statusFg" value="#856404"/>
                        </c:when>
                        <c:when test="${proposal.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                            <c:set var="statusBg" value="#fff3cd"/>
                            <c:set var="statusFg" value="#856404"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusBg" value="#d4edda"/>
                            <c:set var="statusFg" value="#155724"/>
                        </c:when>
                        <c:when test="${proposal.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
                            <c:set var="statusBg" value="#f8d7da"/>
                            <c:set var="statusFg" value="#721c24"/>
                        </c:when>
                        <c:when test="${proposal.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Cần chỉnh sửa"/>
                            <c:set var="statusBg" value="#ede9fe"/>
                            <c:set var="statusFg" value="#5b21b6"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusBg" value="#e2e3e5"/>
                            <c:set var="statusFg" value="#383d41"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="heroInitials">
                        <c:choose>
                            <c:when test="${not empty proposal.createdByName}">
                                <c:set var="nameParts" value="${fn:split(proposal.createdByName, ' ')}"/>
                                <c:choose>
                                    <c:when test="${fn:length(nameParts) == 1}">${fn:toUpperCase(fn:substring(proposal.createdByName, 0, 2))}</c:when>
                                    <c:otherwise>${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:toUpperCase(fn:substring(nameParts[fn:length(nameParts)-1], 0, 1))}</c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>??</c:otherwise>
                        </c:choose>
                    </c:set>

                    <div class="hero">
                        <div class="hero-avatar" style="background: oklch(58% 0.14 250);">${heroInitials}</div>
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${proposal.proposalCode}"/>
                                <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h2>
                            <div class="hero-meta">
                                <span class="id">#<c:out value="${proposal.proposalId}"/></span>
                                <span class="sep">·</span>
                                <span>Ngày đề xuất:
                                    <c:choose>
                                        <c:when test="${proposal.proposalDate == null}">—</c:when>
                                        <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill warehouse"><span class="pdot"></span>Kho: <c:out value="${proposal.warehouseName}"/></span>
                                <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${proposal.createdByName}"/></span>
                                <c:if test="${not empty proposal.approvedByName}">
                                    <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${proposal.approvedByName}"/></span>
                                </c:if>
                                <span class="pill warehouse"><span class="pdot"></span>Tổng tiền: <fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫</span>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty proposal.purchaseOrderId}">
                        <div class="alert alert-info">
                            <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                            <span>Đã gom vào <strong>Phiếu mua</strong>: <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${proposal.purchaseOrderId}" style="color:var(--info); font-weight:600;">${proposal.poCode}</a>. Phiếu này bị khóa sửa.</span>
                        </div>
                    </c:if>

                    <c:set var="isOwner" value="${sessionScope.loggedUser.id == proposal.createdBy}" />
                    <c:set var="perms" value="${sessionScope.userPermissions}" />
                    <c:set var="canApprove" value="${perms.contains('proposals.approve')}" />
                    <c:set var="canReject" value="${perms.contains('proposals.reject')}" />
                    <c:set var="canCancelProp" value="${perms.contains('proposals.cancel')}" />
                    <c:set var="hasLockedPO" value="${not empty proposal.purchaseOrderId}" />

                    <div class="action-bar-top">
                        <a class="btn" href="${pageContext.request.contextPath}/proposal?action=list">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                            Quay lại
                        </a>

                        <c:if test="${!hasLockedPO}">
                            <c:if test="${proposal.status == 'DRAFT' && isOwner}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Chỉnh sửa
                                </a>
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <input type="hidden" name="submitType" value="submit" />
                                    <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                        Gửi duyệt
                                    </button>
                                </form>
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này?')">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                        Xoá
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${proposal.status == 'NEEDS_REVISION' && isOwner}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Chỉnh sửa
                                </a>
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <input type="hidden" name="submitType" value="submit" />
                                    <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận gửi duyệt lại?')">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                        Gửi duyệt lại
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canApprove}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Duyệt phiếu
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canReject}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canCancelProp}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                        Huỷ phiếu
                                    </button>
                                </form>
                            </c:if>
                        </c:if>
                    </div>

                    <div class="tab-bar">
                        <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Thông tin & các máy
                        </a>
                        <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                            <span class="tab-badge">${totalHistory}</span>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${currentTab == 'history'}">
                            <div class="table-card history-card">
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
                                        <option value="CANCEL"     ${logAction == 'CANCEL' ? 'selected' : ''}>Huỷ</option>
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
                                                                <c:when test="${h.action == 'CANCEL'}">Huỷ</c:when>
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
                        </c:when>
                        <c:otherwise>
                            <div class="section" style="padding: 18px 22px;">
                                <div class="info-grid">
                                    <div class="info-field">
                                        <div class="info-label">Mã phiếu</div>
                                        <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Kho nhập</div>
                                        <div class="info-value"><c:out value="${proposal.warehouseName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Cán bộ đầu mối</div>
                                        <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Người duyệt</div>
                                        <div class="info-value"><c:out value="${not empty proposal.approvedByName ? proposal.approvedByName : '—'}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Trạng thái</div>
                                        <div class="info-value">
                                            <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                                <span class="pdot"></span>${statusLabel}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Ngày đề xuất</div>
                                        <div class="info-value mono">
                                            <c:choose>
                                                <c:when test="${proposal.proposalDate == null}">—</c:when>
                                                <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${proposal.approvedAt != null}">
                                        <div class="info-field">
                                            <div class="info-label">Ngày duyệt</div>
                                            <div class="info-value mono">${proposal.approvedAt.format(propFmt)}</div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Tổng tiền</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫</div>
                                    </div>
                                </div>

                                <c:if test="${proposal.status == 'REJECTED' && not empty proposal.rejectReason}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do từ chối</div>
                                        <div class="danger-note"><c:out value="${proposal.rejectReason}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty proposal.note}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú nội bộ</div>
                                        <div class="note-soft"><c:out value="${proposal.note}"/></div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="table-card history-card" style="margin-top: 18px;">
                                <div class="result-summary">
                                    <span>Danh sách máy phát điện (<strong>${not empty proposal.details ? fn:length(proposal.details) : 0}</strong> dòng)</span>
                                    <span>Tổng tiền: <strong style="color:var(--fg);font-family:var(--font-mono);"><fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫</strong></span>
                                </div>
                                <div style="overflow-x:auto;">
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                            <th>Máy phát</th>
                                            <th>Hãng</th>
                                            <th>Xuất xứ</th>
                                            <th>Tình trạng</th>
                                            <th>Nhiên liệu</th>
                                            <th>Số pha</th>
                                            <th>Loại MP</th>
                                            <th style="width: 90px;">C.suất</th>
                                            <th style="width: 80px;">Tần số</th>
                                            <th style="width: 80px;">T.lượng</th>
                                            <th style="width: 170px;">Nhà cung cấp</th>
                                            <th style="width: 110px;" class="text-right">Đơn giá</th>
                                            <th style="width: 60px;" class="text-right">SL</th>
                                            <th style="width: 80px;" class="text-right">Tồn</th>
                                            <th style="width: 120px;" class="text-right">Thành tiền</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty proposal.details}">
                                                <tr><td colspan="17">
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
                                                    <tr>
                                                        <td class="mono">${st.index + 1}</td>
                                                        <td><strong><c:out value="${d.generatorName}"/></strong></td>
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td><c:out value="${d.originName}"/></td>
                                                        <td><c:out value="${d.conditionName}"/></td>
                                                        <td><c:out value="${d.fuelName}"/></td>
                                                        <td><c:out value="${d.phaseName}"/></td>
                                                        <td><c:out value="${d.genTypeName}"/></td>
                                                        <td class="mono"><c:out value="${d.powerRating}"/></td>
                                                        <td class="mono"><c:out value="${d.frequency}"/></td>
                                                        <td class="mono"><c:out value="${d.weight}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.supplierName}">
                                                                    <c:out value="${d.supplierName}"/>
                                                                    <c:if test="${not empty d.supplierPhone}">
                                                                        <div style="font-size:11px;color:var(--muted);font-family:var(--font-mono);"><c:out value="${d.supplierPhone}"/></div>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.currentStock}"/></td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice * d.quantity}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><c:out value="${d.note}"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty proposal.details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="15" class="text-right" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border);">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border); color: var(--accent);"><fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫</td>
                                                <td style="border-top: 2px solid var(--border);"></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>

        <c:if test="${proposal.status == 'PENDING' && !hasLockedPO && canApprove}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu đề xuất</h3>
                    <div class="modal-sub">Xác nhận duyệt phiếu đề xuất <strong><c:out value="${proposal.proposalCode}"/></strong>?</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve" id="approveForm">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>

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
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && !hasLockedPO && canReject}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối phiếu đề xuất</h3>
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
        </script>
    </body>
</html>
