<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết phiếu luân chuyển — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .alert-error { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }

        .action-bar-top { display: flex; gap: 8px; flex-wrap: wrap; padding: 12px 16px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-bottom: 16px; }
        .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); }
        .filter-active-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); font-weight: 600; font-size: 11px; }
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
        .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
        .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
        .empty-state strong { color: var(--fg); font-size: 14px; }

        .product-table { width: 100%; border-collapse: collapse; }
        .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
        .product-table th { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); letter-spacing: 0.04em; }
        .product-table td { font-size: 13px; }
        .product-table tbody tr:hover { background: var(--surface-2); }
        .text-center { text-align: center; }

        .btn-warn { background: var(--warn); color: white; border-color: var(--warn); }
        .btn-success { background: var(--accent); color: white; border-color: var(--accent); }
        .btn-outline-warn { background: transparent; color: var(--warn); border-color: var(--warn); }
        .btn-outline-warn:hover { background: var(--warn-soft); }
        .btn-outline-danger { background: transparent; color: var(--danger); border-color: var(--danger); }
        .btn-outline-danger:hover { background: var(--danger-soft); }

        .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
        .reject-note-box { background: var(--danger-soft); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); color: var(--danger); margin-bottom: 16px; }
        .reject-note-box strong { font-weight: 700; font-size: 14px; margin-bottom: 4px; display: block; }
        .reject-note-box span { font-size: 13px; }

        .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
        .modal-host.show { display: flex; }
        .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
        .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
        .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; margin-bottom: 15px; margin-top: 10px; resize: vertical; min-height: 80px; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển <c:out value="${transfer.transferCode}"/></h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/transfers">Luân chuyển</a> / <span><c:out value="${transfer.transferCode}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/transfers">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <c:if test="${empty transfer}">
                <div class="section" style="padding: 18px 22px;">
                    <p style="color: var(--muted); font-size: 14px;">${error != null ? error : 'Không tìm thấy phiếu'}</p>
                </div>
            </c:if>
            <c:if test="${not empty transfer}">
            <c:set var="t" value="${transfer}"/>
            <c:set var="status" value="${t.status}"/>
            <c:set var="isMgrRound1" value="${status == 'PENDING_MANAGER' && empty t.ceoReviewedAt}"/>
            <c:set var="isMgrRound2" value="${status == 'PENDING_MANAGER' && not empty t.ceoReviewedAt}"/>

            <c:choose>
                <c:when test="${status == 'DRAFT'}">
                    <c:set var="statusLabel" value="Nháp"/>
                    <c:set var="statusBg" value="#e2e3e5"/>
                    <c:set var="statusFg" value="#383d41"/>
                </c:when>
                <c:when test="${status == 'PENDING_MANAGER' && isMgrRound1}">
                    <c:set var="statusLabel" value="Chờ Manager duyệt lần 1"/>
                    <c:set var="statusBg" value="#cce5ff"/>
                    <c:set var="statusFg" value="#004085"/>
                </c:when>
                <c:when test="${status == 'PENDING_MANAGER' && isMgrRound2}">
                    <c:set var="statusLabel" value="Chờ Manager xác nhận cuối"/>
                    <c:set var="statusBg" value="#cce5ff"/>
                    <c:set var="statusFg" value="#004085"/>
                </c:when>
                <c:when test="${status == 'PENDING_CEO'}">
                    <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                    <c:set var="statusBg" value="#e2d5f3"/>
                    <c:set var="statusFg" value="#5a2a82"/>
                </c:when>
                <c:when test="${status == 'COMPLETED'}">
                    <c:set var="statusLabel" value="Hoàn tất"/>
                    <c:set var="statusBg" value="#d4edda"/>
                    <c:set var="statusFg" value="#155724"/>
                </c:when>
                <c:when test="${status == 'NEEDS_REVISION'}">
                    <c:set var="statusLabel" value="Yêu cầu chỉnh sửa"/>
                    <c:set var="statusBg" value="#ffe0b2"/>
                    <c:set var="statusFg" value="#b15c00"/>
                </c:when>
                <c:when test="${status == 'REJECTED'}">
                    <c:set var="statusLabel" value="Bị từ chối"/>
                    <c:set var="statusBg" value="#f8d7da"/>
                    <c:set var="statusFg" value="#721c24"/>
                </c:when>
                <c:when test="${status == 'CANCELLED'}">
                    <c:set var="statusLabel" value="Đã hủy"/>
                    <c:set var="statusBg" value="#fff3cd"/>
                    <c:set var="statusFg" value="#856404"/>
                </c:when>
                <c:otherwise>
                    <c:set var="statusLabel" value="${status}"/>
                    <c:set var="statusBg" value="#e2e3e5"/>
                    <c:set var="statusFg" value="#383d41"/>
                </c:otherwise>
            </c:choose>

            <div class="hero">
                <div class="hero-avatar" style="background: oklch(58% 0.16 290);">L</div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${t.transferCode}"/>
                        <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                            <span class="pdot"></span>${statusLabel}
                        </span>
                    </h2>
                    <div class="hero-meta">
                        <span>Phiếu luân chuyển</span>
                        <span class="sep">·</span>
                        <span class="id">#${t.transferId}</span>
                        <c:if test="${not empty t.createdAt}">
                            <span class="sep">·</span>
                            <span>Ngày tạo: <fmt:formatDate value="${t.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </c:if>
                    </div>
                    <div class="hero-pills">
                        <span class="pill warehouse"><span class="pdot"></span>${t.sourceWarehouseName} → ${t.destWarehouseName}</span>
                        <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${t.createdByName}"/></span>
                        <span class="pill role-admin"><span class="pdot"></span>${empty t.details ? 0 : t.details.size()} dòng hàng</span>
                    </div>
                </div>
            </div>

            <c:if test="${status == 'REJECTED'}">
                <c:if test="${not empty t.managerNote}">
                    <div class="reject-note-box">
                        <strong>Phản hồi từ Quản lý kho</strong>
                        <span>${t.managerNote}</span>
                    </div>
                </c:if>
                <c:if test="${not empty t.ceoNote}">
                    <div class="reject-note-box">
                        <strong>Phản hồi từ CEO</strong>
                        <span>${t.ceoNote}</span>
                    </div>
                </c:if>
            </c:if>

            <c:if test="${status == 'DRAFT' || status == 'PENDING_MANAGER' || status == 'PENDING_CEO' || status == 'NEEDS_REVISION'}">
                <div class="action-bar-top">
                    <c:if test="${isOwner && status == 'DRAFT'}">
                        <a class="btn" href="${pageContext.request.contextPath}/transfers?action=edit_view&id=${t.transferId}">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                            Sửa phiếu
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=submit" style="display:inline;">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-primary">
                                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                Gửi duyệt (Manager)
                            </button>
                        </form>
                    </c:if>

                    <c:if test="${isOwner && (status == 'DRAFT' || isMgrRound1)}">
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=cancel" style="display:inline;" onsubmit="return confirm('Hủy phiếu này?');">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-outline-warn">Hủy phiếu</button>
                        </form>
                    </c:if>

                    <c:if test="${isMgrRound1}">
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=approve_manager" style="display:inline;">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-primary" onclick="return confirm('Duyệt phiếu và chuyển CEO?');">Duyệt → CEO</button>
                        </form>
                        <button type="button" class="btn" onclick="openRequestRevisionModal('request_revision_manager', 'Yêu cầu chỉnh sửa (Manager)', 'managerNote')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                            Yêu cầu chỉnh sửa
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('reject_manager', 'Từ chối phiếu (Manager)', 'managerNote')">Từ chối</button>
                    </c:if>

                    <c:if test="${isMgrRound2}">
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=final_approve" style="display:inline;">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận cuối và THỰC HIỆN chuyển kho?');">Xác nhận cuối &amp; Chuyển kho</button>
                        </form>
                        <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('final_reject', 'Từ chối xác nhận cuối', 'managerNote')">Từ chối (Hủy phiếu)</button>
                    </c:if>

                    <c:if test="${status == 'PENDING_CEO'}">
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=approve_ceo" style="display:inline;">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-primary" onclick="return confirm('Duyệt phiếu và trả về Manager xác nhận cuối?');">Duyệt → Manager</button>
                        </form>
                        <button type="button" class="btn" onclick="openRequestRevisionModal('request_revision_ceo', 'Yêu cầu chỉnh sửa (CEO)', 'ceoNote')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                            Yêu cầu chỉnh sửa
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('reject_ceo', 'Từ chối phiếu (CEO)', 'ceoNote')">Từ chối</button>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${status == 'NEEDS_REVISION' && isOwner}">
                <div class="reject-note-box" style="background: var(--warn-soft); border-color: color-mix(in srgb, var(--warn) 25%, transparent); color: var(--warn);">
                    <strong>Yêu cầu chỉnh sửa từ người duyệt</strong>
                    <span><c:out value="${not empty t.managerNote ? t.managerNote : t.ceoNote}"/></span>
                </div>
                <div class="action-bar-top">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/transfers?action=edit_view&id=${t.transferId}">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                        Sửa phiếu &amp; gửi lại
                    </a>
                </div>
            </c:if>

            <div class="tab-bar">
                <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Thông tin & các máy
                </a>
                <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    Lịch sử cập nhật
                </a>
            </div>

            <c:choose>
                <c:when test="${currentTab == 'history'}">
                    <div class="table-card history-card">
                        <form method="get" action="${pageContext.request.contextPath}/transfers" class="history-filter-bar">
                            <input type="hidden" name="action" value="detail"/>
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <input type="hidden" name="tab" value="history"/>
                            <input type="hidden" name="page" value="1"/>

                            <div class="search-input hf-search">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                            </div>
                            <select name="logAction" class="filter-select">
                                <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo phiếu</option>
                                <option value="SUBMIT" ${logAction == 'SUBMIT' ? 'selected' : ''}>Gửi duyệt</option>
                                <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                <option value="CANCEL" ${logAction == 'CANCEL' ? 'selected' : ''}>Hủy phiếu</option>
                                <option value="MANAGER_APPROVE" ${logAction == 'MANAGER_APPROVE' ? 'selected' : ''}>Manager duyệt lần 1</option>
                                <option value="MANAGER_REJECT" ${logAction == 'MANAGER_REJECT' ? 'selected' : ''}>Manager từ chối lần 1</option>
                                <option value="CEO_APPROVE" ${logAction == 'CEO_APPROVE' ? 'selected' : ''}>CEO duyệt</option>
                                <option value="CEO_REJECT" ${logAction == 'CEO_REJECT' ? 'selected' : ''}>CEO từ chối</option>
                                <option value="FINAL_APPROVE" ${logAction == 'FINAL_APPROVE' ? 'selected' : ''}>Xác nhận cuối</option>
                                <option value="MANAGER_REJECT_R2" ${logAction == 'MANAGER_REJECT_R2' ? 'selected' : ''}>Từ chối xác nhận cuối</option>
                                <option value="REQUEST_REVISION" ${logAction == 'REQUEST_REVISION' ? 'selected' : ''}>Yêu cầu sửa</option>
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
                                <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}&amp;tab=history" class="btn">
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

                        <table>
                            <thead><tr>
                                <th style="width:150px;">Thời gian</th>
                                <th style="width:180px;">Người thực hiện</th>
                                <th style="width:200px;">Hành động</th>
                                <th>Chi tiết thay đổi</th>
                            </tr></thead>
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
                                                <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}&amp;tab=history">xóa lọc</a></span>
                                            </c:if>
                                        </div>
                                    </td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${logList}">
                                        <tr>
                                            <td style="font-family:var(--font-mono);"><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <div style="font-weight:600;color:var(--fg);"><c:out value="${log.username}"/></div>
                                            </td>
                                            <td>
                                                <span class="action-badge action-<c:choose>
                                                    <c:when test="${log.action == 'CREATE'}">create</c:when>
                                                    <c:when test="${log.action == 'SUBMIT'}">update</c:when>
                                                    <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                    <c:when test="${log.action == 'CANCEL'}">reject</c:when>
                                                    <c:when test="${log.action == 'MANAGER_APPROVE'}">approve</c:when>
                                                    <c:when test="${log.action == 'MANAGER_REJECT'}">reject</c:when>
                                                    <c:when test="${log.action == 'CEO_APPROVE'}">approve</c:when>
                                                    <c:when test="${log.action == 'CEO_REJECT'}">reject</c:when>
                                                    <c:when test="${log.action == 'FINAL_APPROVE'}">approve</c:when>
                                                    <c:when test="${log.action == 'MANAGER_REJECT_R2'}">reject</c:when>
                                                    <c:when test="${log.action == 'REQUEST_REVISION'}">update</c:when>
                                                    <c:otherwise>default</c:otherwise>
                                                </c:choose>">
                                                <c:choose>
                                                    <c:when test="${log.action == 'CREATE'}">Tạo phiếu</c:when>
                                                    <c:when test="${log.action == 'SUBMIT'}">Gửi duyệt</c:when>
                                                    <c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when>
                                                    <c:when test="${log.action == 'CANCEL'}">Hủy phiếu</c:when>
                                                    <c:when test="${log.action == 'MANAGER_APPROVE'}">Manager duyệt lần 1</c:when>
                                                    <c:when test="${log.action == 'MANAGER_REJECT'}">Manager từ chối lần 1</c:when>
                                                    <c:when test="${log.action == 'CEO_APPROVE'}">CEO duyệt</c:when>
                                                    <c:when test="${log.action == 'CEO_REJECT'}">CEO từ chối</c:when>
                                                    <c:when test="${log.action == 'FINAL_APPROVE'}">Xác nhận cuối</c:when>
                                                    <c:when test="${log.action == 'MANAGER_REJECT_R2'}">Từ chối xác nhận cuối</c:when>
                                                    <c:when test="${log.action == 'REQUEST_REVISION'}">Yêu cầu chỉnh sửa</c:when>
                                                    <c:otherwise>${log.action}</c:otherwise>
                                                </c:choose></span>
                                            </td>
                                            <td style="max-width:380px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
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
                                    <a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                </c:if>
                                <c:forEach begin="1" end="${logTotalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${logPage < logTotalPages}">
                                    <a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                        <span class="pdot"></span>${statusLabel}
                                    </span>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Mã phiếu</div>
                                <div class="info-value mono">${t.transferCode}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Kho nguồn</div>
                                <div class="info-value">${t.sourceWarehouseName}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Kho đích</div>
                                <div class="info-value">${t.destWarehouseName}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Người tạo</div>
                                <div class="info-value">${t.createdByName}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Ngày tạo</div>
                                <div class="info-value mono">
                                     <c:if test="${not empty t.createdAt}"><fmt:formatDate value="${t.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></c:if>
                                </div>
                            </div>
                            <c:if test="${not empty t.executedAt}">
                                <div class="info-field">
                                    <div class="info-label">Ngày hoàn tất</div>
                                    <div class="info-value mono"><fmt:formatDate value="${t.executedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                                </div>
                            </c:if>
                        </div>
                        <c:if test="${not empty t.note}">
                            <div style="margin-top: 18px;">
                                <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú phiếu</div>
                                <div class="note-soft">${t.note}</div>
                            </div>
                        </c:if>
                    </div>

                    <c:if test="${not empty t.managerReviewedAt or not empty t.ceoReviewedAt or not empty t.finalReviewedAt}">
                        <div class="section" style="padding: 18px 22px; margin-top: 18px;">
                            <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:10px;">Lịch sử duyệt</div>
                            <div class="info-grid">
                                <c:if test="${not empty t.managerReviewedAt}">
                                    <div class="info-field">
                                        <div class="info-label">Manager duyệt lần 1</div>
                                        <div class="info-value">
                                            ${t.managerReviewedByName}
                                            <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.managerReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty t.ceoReviewedAt}">
                                    <div class="info-field">
                                        <div class="info-label">CEO duyệt</div>
                                        <div class="info-value">
                                            ${t.ceoReviewedByName}
                                            <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.ceoReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty t.finalReviewedAt}">
                                    <div class="info-field">
                                        <div class="info-label">Manager xác nhận cuối</div>
                                        <div class="info-value">
                                            ${t.finalReviewedByName}
                                            <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.finalReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <div class="table-card history-card" style="margin-top: 18px;">
                        <div class="result-summary" style="display:flex;align-items:center;justify-content:space-between;">
                            <span>Danh sách máy phát điện (<strong>${empty t.details ? 0 : t.details.size()}</strong> dòng)</span>
                            <span>Hành động: luân chuyển <strong style="font-family:var(--font-mono);">${t.sourceWarehouseName} → ${t.destWarehouseName}</strong></span>
                        </div>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th style="width: 40px;">#</th>
                                    <th>Dòng máy</th>
                                    <th style="width: 80px;">Số lượng</th>
                                    <th>Số Serial</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty t.details}">
                                        <tr><td colspan="5" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có chi tiết</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${t.details}" varStatus="st">
                                            <tr>
                                                <td class="mono">${st.count}</td>
                                                <td><strong>${d.generatorModel}</strong></td>
                                                <td class="mono">${d.quantity}</td>
                                                <td class="mono">${d.serialNumber != null ? d.serialNumber : '—'}</td>
                                                <td>${d.note != null ? d.note : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
            </c:if>
        </main>
    </div>
</div>

<div class="modal-host" id="rejectModal">
    <div class="modal-card">
        <h3 id="rejectModalTitle">Từ chối</h3>
        <form method="POST" action="${pageContext.request.contextPath}/transfers" id="rejectForm">
            <input type="hidden" name="id" value="${transfer.transferId}" />
            <input type="hidden" name="action" id="rejectFormAction" value="" />
            <textarea name="REPLACE_NOTE" id="rejectFormNote" required maxlength="500" rows="4" placeholder="Nhập lý do từ chối..."></textarea>
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                <button type="submit" class="btn btn-danger" id="rejectFormSubmit">Xác nhận từ chối</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-host" id="requestRevisionModal">
    <div class="modal-card">
        <h3 id="revisionModalTitle">Yêu cầu chỉnh sửa</h3>
        <form method="POST" action="${pageContext.request.contextPath}/transfers" id="revisionForm">
            <input type="hidden" name="id" value="${transfer.transferId}" />
            <input type="hidden" name="action" id="revisionFormAction" value="" />
            <textarea name="REPLACE_NOTE" id="revisionFormNote" required maxlength="500" rows="4" placeholder="Nhập lý do yêu cầu chỉnh sửa..."></textarea>
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('requestRevisionModal')">Huỷ</button>
                <button type="submit" class="btn btn-primary" id="revisionFormSubmit">Gửi yêu cầu</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }

    function openRejectModal(action, title, noteFieldName) {
        document.getElementById('rejectModalTitle').innerText = title;
        document.getElementById('rejectFormAction').value = action;
        var ta = document.getElementById('rejectFormNote');
        ta.value = '';
        ta.setAttribute('name', noteFieldName);
        openModal('rejectModal');
    }

    function openRequestRevisionModal(action, title, noteFieldName) {
        document.getElementById('revisionModalTitle').innerText = title;
        document.getElementById('revisionFormAction').value = action;
        var ta = document.getElementById('revisionFormNote');
        ta.value = '';
        ta.setAttribute('name', noteFieldName);
        openModal('requestRevisionModal');
    }

    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
        }
    });
</script>
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
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
