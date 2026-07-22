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
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .alert-error { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }

        .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
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

        .status-purple { background:#ede9fe; color:#6d28d9; }
        .status-orange { background:#fff3e0; color:#b15c00; }
        .status-teal   { background:#e0f2f1; color:#00695c; }
        .status-pink   { background:#fce4ec; color:#a13d63; }

        .confirm-summary {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 14px 16px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            margin: 6px 0 4px;
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
        .confirm-row span { color: var(--muted); font-weight: 500; }
        .confirm-row strong { color: var(--fg); font-weight: 600; text-align: right; word-break: break-word; }
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
            <c:if test="${empty transfer}">
                <div class="section" style="padding: 18px 22px;">
                    <p style="color: var(--muted); font-size: 14px;">${error != null ? error : 'Không tìm thấy phiếu'}</p>
                </div>
            </c:if>
            <c:if test="${not empty transfer}">
            <c:set var="t" value="${transfer}"/>
            <c:set var="status" value="${t.status}"/>

            <c:choose>
                <c:when test="${status == 'PENDING_CEO'}">
                    <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                    <c:set var="statusClass" value="status-pending"/>
                </c:when>
                <c:when test="${status == 'APPROVED'}">
                    <c:set var="statusLabel" value="Đã duyệt - chờ tạo phiếu xuất"/>
                    <c:set var="statusClass" value="status-completed"/>
                </c:when>
                <c:when test="${status == 'EXPORTED'}">
                    <c:set var="statusLabel" value="Đã xuất - chờ phiếu nhập"/>
                    <c:set var="statusClass" value="status-revision"/>
                </c:when>
                <c:when test="${status == 'AWAITING_DEST_ACCEPT'}">
                    <c:set var="statusLabel" value="Chờ kho đích xác nhận (cũ)"/>
                    <c:set var="statusClass" value="status-pending"/>
                </c:when>
                <c:when test="${status == 'COMPLETED'}">
                    <c:set var="statusLabel" value="Hoàn tất"/>
                    <c:set var="statusClass" value="status-completed"/>
                </c:when>
                <c:when test="${status == 'REJECTED'}">
                    <c:set var="statusLabel" value="Bị từ chối"/>
                    <c:set var="statusClass" value="status-cancelled"/>
                </c:when>
                <c:when test="${status == 'REQUEST_REVISION'}">
                    <c:set var="statusLabel" value="Yêu cầu chỉnh sửa"/>
                    <c:set var="statusClass" value="status-revision"/>
                </c:when>
                <c:otherwise>
                    <c:set var="statusLabel" value="${status}"/>
                    <c:set var="statusClass" value="status-draft"/>
                </c:otherwise>
            </c:choose>

            <div class="header-bar">
                <div class="left">
                    <a class="back-link" href="${pageContext.request.contextPath}/transfers">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>
                    <span class="code-tag">
                        <span class="ct-label">Phiếu luân chuyển -</span>
                        <span><c:out value="${t.transferCode}"/></span>
                    </span>
                    <h2 class="page-main-title">
                        #<c:out value="${t.transferCode}"/>
                        <span class="status-pill ${statusClass}">
                            <span class="pdot"></span>${statusLabel}
                        </span>
                    </h2>
                </div>
                <div class="right">
                    <c:if test="${canCeApprove or canCeReject or canCeRequestRevision}">
                        <button type="button" class="btn btn-primary" onclick="openApproveModal()">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
                            Duyệt
                        </button>
                        <button type="button" class="btn btn-outline-warn" onclick="openRejectModal('ce_request_revision', 'Yêu cầu chỉnh sửa', 'ceoNote', 'Nhập lý do yêu cầu chỉnh sửa...', 'Xác nhận yêu cầu')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            Yêu cầu chỉnh sửa
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('ce_reject', 'Từ chối phiếu', 'ceoNote', 'Nhập lý do từ chối...', 'Xác nhận từ chối')">Từ chối</button>
                    </c:if>
                    <c:if test="${canEditRevision}">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/transfers?action=edit_view&amp;id=${t.transferId}">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            Sửa &amp; gửi lại duyệt
                        </a>
                    </c:if>
                    <c:if test="${canCreateExport}">
                        <button type="button" class="btn btn-success" onclick="openCreateReceiptConfirm('export')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7h18M9 7v12M15 7v12M3 7l3-4h12l3 4"/></svg>
                            Tạo phiếu xuất
                        </button>
                    </c:if>
                    <c:if test="${canCreateImport}">
                        <button type="button" class="btn btn-success" onclick="openCreateReceiptConfirm('import')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 7v12H3V7M3 7l3-4h12l3 4M9 12h6"/></svg>
                            Tạo phiếu nhập
                        </button>
                    </c:if>
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

            <c:if test="${status == 'REQUEST_REVISION'}">
                <div style="background: var(--warn-soft); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); color: var(--warn); margin-bottom: 16px;">
                    <strong style="font-weight: 700; font-size: 14px; margin-bottom: 4px; display: block;">Yêu cầu chỉnh sửa từ CEO</strong>
                    <c:if test="${not empty t.ceoNote}">
                        <span style="font-size: 13px; white-space: pre-wrap; line-height: 1.55;">${t.ceoNote}</span>
                    </c:if>
                    <c:if test="${empty t.ceoNote}">
                        <span style="font-size: 13px;">CEO yêu cầu chỉnh sửa phiếu này.</span>
                    </c:if>
                </div>
            </c:if>

            <c:if test="${not empty t.exportReceiptCode or not empty t.importReceiptCode}">
                <div class="section">
                    <div class="section-head">
                        <h3>Phiếu liên quan</h3>
                    </div>
                    <div class="section-body">
                        <c:if test="${not empty t.exportReceiptCode}">
                            <div style="display:flex;gap:8px;align-items:center; padding: 4px 0;">
                                <span style="color:var(--muted); min-width: 90px;">Phiếu xuất:</span>
                                <a class="code-link" href="${pageContext.request.contextPath}/export-receipt?action=detail&amp;id=${t.exportReceiptId}">
                                    <c:out value="${t.exportReceiptCode}"/>
                                </a>
                            </div>
                        </c:if>
                        <c:if test="${not empty t.importReceiptCode}">
                            <div style="display:flex;gap:8px;align-items:center; padding: 4px 0;">
                                <span style="color:var(--muted); min-width: 90px;">Phiếu nhập:</span>
                                <a class="code-link" href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${t.importReceiptId}">
                                    <c:out value="${t.importReceiptCode}"/>
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <div class="section">
                <div class="section-head">
                    <h3>Thông tin chung</h3>
                </div>
                <div class="section-body">
                    <div class="form-grid cols-5">
                        <div class="info-field">
                            <label>Trạng thái</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${statusLabel}'/>">
                        </div>
                        <div class="info-field">
                            <label>Mã phiếu</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${t.transferCode}'/>">
                        </div>
                        <div class="info-field">
                            <label>Kho nguồn</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${t.sourceWarehouseName}'/>">
                        </div>
                        <div class="info-field">
                            <label>Kho đích</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${t.destWarehouseName}'/>">
                        </div>
                        <div class="info-field">
                            <label>Người tạo</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${t.createdByName}'/>">
                        </div>
                    </div>
                    <div class="form-grid cols-5" style="margin-top: 14px;">
                        <div class="info-field">
                            <label>Ngày tạo</label>
                            <input class="info-input mono" type="text" disabled value="<c:if test='${not empty t.createdAt}'><fmt:formatDate value='${t.createdAtAsDate}' pattern='dd/MM/yyyy HH:mm'/></c:if>">
                        </div>
                        <c:if test="${not empty t.executedAt}">
                            <div class="info-field">
                                <label>Ngày hoàn tất</label>
                                <input class="info-input mono" type="text" disabled value="<fmt:formatDate value='${t.executedAtAsDate}' pattern='dd/MM/yyyy HH:mm'/>">
                            </div>
                        </c:if>
                        <div class="info-field">
                            <label>Loại phiếu</label>
                            <input class="info-input" type="text" disabled value="Luân chuyển kho">
                        </div>
                        <div class="info-field">
                            <label>Số dòng hàng</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${totalDetails}'/>">
                        </div>
                        <div class="info-field">
                            <label>Hành động</label>
                            <input class="info-input" type="text" disabled value="Luân chuyển: ${t.sourceWarehouseName} → ${t.destWarehouseName}">
                        </div>
                    </div>
                    <c:if test="${not empty t.note}">
                        <div style="margin-top: 18px;">
                            <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú</div>
                            <div class="note-soft"><c:out value="${t.note}"/></div>
                        </div>
                    </c:if>
                </div>
            </div>


            <div class="section" style="margin-top: 18px;">
                <div class="tabs" style="margin-bottom: 16px;">
                    <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                        <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                        Thông tin các máy
                    </a>
                    <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                        <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                        Lịch sử cập nhật
                        <c:if test="${not empty totalLogs and totalLogs > 0}"><span class="tab-badge">${totalLogs}</span></c:if>
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
                                    <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                    <option value="CE_APPROVE" ${logAction == 'CE_APPROVE' ? 'selected' : ''}>CEO duyệt</option>
                                    <option value="CE_REJECT" ${logAction == 'CE_REJECT' ? 'selected' : ''}>CEO từ chối</option>
                                    <option value="EXPORT_CREATED" ${logAction == 'EXPORT_CREATED' ? 'selected' : ''}>Tạo phiếu xuất</option>
                                    <option value="IMPORT_CREATED" ${logAction == 'IMPORT_CREATED' ? 'selected' : ''}>Tạo phiếu nhập</option>
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
                                                        <c:when test="${log.action == 'CE_APPROVE'}">approve</c:when>
                                                        <c:when test="${log.action == 'CE_REJECT'}">reject</c:when>
                                                        <c:when test="${log.action == 'CEO_APPROVE'}">approve</c:when>
                                                        <c:when test="${log.action == 'CEO_REJECT'}">reject</c:when>
                                                        <c:when test="${log.action == 'EXPORT_CREATED'}">update</c:when>
                                                        <c:when test="${log.action == 'IMPORT_CREATED'}">approve</c:when>
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
                                                        <c:when test="${log.action == 'CE_APPROVE'}">CEO duyệt</c:when>
                                                        <c:when test="${log.action == 'CE_REJECT'}">CEO từ chối</c:when>
                                                        <c:when test="${log.action == 'EXPORT_CREATED'}">Tạo phiếu xuất</c:when>
                                                        <c:when test="${log.action == 'IMPORT_CREATED'}">Tạo phiếu nhập</c:when>
                                                        <c:when test="${log.action == 'CEO_APPROVE'}">CEO duyệt</c:when>
                                                        <c:when test="${log.action == 'CEO_REJECT'}">CEO từ chối</c:when>
                                                        <c:when test="${log.action == 'MANAGER_APPROVE'}">Manager duyệt lần 1</c:when>
                                                        <c:when test="${log.action == 'MANAGER_REJECT'}">Manager từ chối lần 1</c:when>
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
                        <div class="section-head" style="margin-top: 0;">
                            <h3>Danh sách máy phát điện (<strong>${totalDetails}</strong> dòng)</h3>
                        </div>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th style="width: 40px;">#</th>
                                    <th>Dòng máy</th>
                                    <th style="width: 80px;">Số lượng</th>
                                    <th>Số serial</th>
                                    <th>Tình trạng</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty pagedDetails}">
                                        <tr><td colspan="6" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có chi tiết</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${pagedDetails}" varStatus="st">
                                            <tr>
                                                <td class="mono">${(detailPage - 1) * 10 + st.index + 1}</td>
                                                <td><strong>${d.generatorModel}</strong></td>
                                                <td class="mono">${d.quantity}</td>
                                                <td class="mono">${d.serialNumber != null ? d.serialNumber : '—'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${d.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                        <c:when test="${d.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                        <c:when test="${d.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                        <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${d.note != null ? d.note : '—'}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <c:if test="${detailTotalPages > 0}">
                        <div class="pagination" style="margin-top: 16px;">
                            <div class="info">Hiển thị <strong>${(detailPage-1)*10 + 1}</strong>–<strong>${detailPage*10 > totalDetails ? totalDetails : detailPage*10}</strong> / <strong>${totalDetails}</strong> bản ghi</div>
                            <div class="controls">
                                <c:if test="${detailPage > 1}">
                                    <a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;detailPage=${detailPage - 1}" class="page-btn">&lsaquo;</a>
                                </c:if>
                                <c:forEach begin="1" end="${detailTotalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == detailPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;detailPage=${p}" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${detailPage < detailTotalPages}">
                                    <a href="${pageContext.request.contextPath}/transfers?action=detail&amp;id=${t.transferId}&amp;detailPage=${detailPage + 1}" class="page-btn">&rsaquo;</a>
                                </c:if>
                            </div>
                        </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
            </c:if>
        </main>
    </div>
</div>

<div class="modal-host" id="createReceiptConfirmModal" onclick="if (event.target === this) closeCreateReceiptConfirm();">
    <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="createReceiptConfirmTitle">
        <h3 id="createReceiptConfirmTitle">Xác nhận tạo phiếu</h3>
        <p class="modal-sub">Vui lòng xác nhận trước khi chuyển sang bước tiếp theo.</p>
        <div class="confirm-summary">
            <div class="confirm-row"><span>Loại phiếu</span><strong id="crcType">—</strong></div>
            <div class="confirm-row"><span>Kho nguồn</span><strong id="crcSource">—</strong></div>
            <div class="confirm-row"><span>Kho đích</span><strong id="crcDest">—</strong></div>
        </div>
        <div class="modal-actions">
            <button type="button" class="btn" onclick="closeCreateReceiptConfirm()">Hủy</button>
            <button type="button" class="btn btn-primary" id="crcConfirmBtn" onclick="doCreateReceiptConfirm()">
                <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                Xác nhận
            </button>
        </div>
    </div>
</div>

<div class="modal-host" id="rejectModal">
    <div class="modal-card">
        <h3 id="rejectModalTitle">Từ chối</h3>
        <form method="POST" action="${pageContext.request.contextPath}/transfers" id="rejectForm">
            <input type="hidden" name="id" value="${transfer.transferId}" />
            <input type="hidden" name="action" id="rejectFormAction" value="" />
            <textarea name="REPLACE_NOTE" id="rejectFormNote" required maxlength="500" rows="4" placeholder="Nhập lý do..."></textarea>
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                <button type="submit" class="btn btn-danger" id="rejectFormSubmit">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-host" id="approveModal">
    <div class="modal-card">
        <h3 style="color: var(--accent);">Duyệt phiếu luân chuyển</h3>
        <p style="margin: 12px 0 4px; font-size: 13px; color: var(--fg-soft);">Bạn xác nhận duyệt cho phép phiếu luân chuyển này được thực hiện?</p>
        <p style="margin: 0; font-size: 12px; color: var(--muted);">Sau khi duyệt, kho nguồn có thể tạo phiếu xuất.</p>
        <form method="POST" action="${pageContext.request.contextPath}/transfers?action=ce_approve" id="approveForm" style="margin-top: 18px;">
            <input type="hidden" name="id" value="${transfer.transferId}" />
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }

    function openApproveModal() {
        openModal('approveModal');
    }

    function openRejectModal(action, title, noteFieldName, placeholder, submitLabel) {
        document.getElementById('rejectModalTitle').innerText = title;
        document.getElementById('rejectFormAction').value = action;
        var ta = document.getElementById('rejectFormNote');
        ta.value = '';
        ta.setAttribute('name', noteFieldName);
        ta.setAttribute('placeholder', placeholder || 'Nhập lý do...');
        document.getElementById('rejectFormSubmit').innerText = submitLabel || 'Xác nhận';
        var submitBtn = document.getElementById('rejectFormSubmit');
        if (action === 'ce_request_revision') {
            submitBtn.className = 'btn btn-warn';
        } else {
            submitBtn.className = 'btn btn-danger';
        }
        openModal('rejectModal');
    }

    // ========== Create-receipt confirmation ==========
    var pendingReceiptUrl = null;
    function openCreateReceiptConfirm(type) {
        var url = '';
        var title = 'Xác nhận tạo phiếu';
        if (type === 'export') {
            url = '${pageContext.request.contextPath}/transfers?action=create_export_receipt&transferId=${t.transferId}';
            document.getElementById('crcType').textContent = 'Phiếu xuất kho';
        } else if (type === 'import') {
            url = '${pageContext.request.contextPath}/transfers?action=create_import_receipt&transferId=${t.transferId}';
            document.getElementById('crcType').textContent = 'Phiếu nhập kho';
        }
        document.getElementById('createReceiptConfirmTitle').textContent = title;
        document.getElementById('crcSource').textContent = '<c:out value="${t.sourceWarehouseName}"/>';
        document.getElementById('crcDest').textContent = '<c:out value="${t.destWarehouseName}"/>';
        pendingReceiptUrl = url;
        openModal('createReceiptConfirmModal');
    }

    function closeCreateReceiptConfirm() {
        closeModal('createReceiptConfirmModal');
        pendingReceiptUrl = null;
    }

    function doCreateReceiptConfirm() {
        var url = pendingReceiptUrl;
        closeCreateReceiptConfirm();
        if (url) window.location.href = url;
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
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            if (typeof showToast === 'function') {
                showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
            } else if (typeof toast === 'function') {
                toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
            }
            window.SESSION_DATA = null;
        }
    });
</script>
</body>
</html>