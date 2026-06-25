<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __poFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    java.time.format.DateTimeFormatter __poDateFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
    request.setAttribute("poFmt", __poFmt);
    request.setAttribute("poDateFmt", __poDateFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu mua — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
            .alert-warn { background: color-mix(in srgb, var(--warn) 12%, transparent); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 30%, transparent); }
            .alert-info { background: color-mix(in srgb, var(--accent) 12%, transparent); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent); }
            .btn-warn { background: var(--warn); color: #fff; border: 1px solid var(--warn); }
            .btn-warn:hover { background: color-mix(in srgb, var(--warn) 85%, black); border-color: color-mix(in srgb, var(--warn) 85%, black); }

            .product-table { width: 100%; border-collapse: collapse; }
            .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
            .product-table th { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); letter-spacing: 0.04em; }
            .product-table td { font-size: 13px; }
            .product-table tbody tr:hover { background: var(--surface-2); }
            .product-table tfoot td { background: var(--surface-2); font-weight: 700; }
            .text-center { text-align: center; }
            .text-right { text-align: right; }
            .mono { font-family: var(--font-mono); }

            .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
            .danger-note { background: color-mix(in srgb, var(--danger-soft) 70%, transparent); color: var(--danger); padding: 14px; border-radius: var(--radius-sm); border-left: 3px solid var(--danger); }

            .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; }
            .filter-active-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); font-weight: 600; font-size: 11px; }
            .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
            .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
            .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
            .empty-state strong { color: var(--fg); font-size: 14px; }

            .info-value .status-pill { white-space: nowrap; }

            .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
            .status-pill .pdot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

            .action-bar-top { display: flex; gap: 10px; flex-wrap: wrap; margin: 18px 0; }

            .modal-host { position: fixed; inset: 0; background: oklch(0% 0 0 / 0.4); z-index: 50; display: none; align-items: center; justify-content: center; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); width: 100%; max-width: 480px; padding: 20px 22px; box-shadow: 0 20px 50px oklch(0% 0 0 / 0.25); }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-sub { color: var(--muted); font-size: 13px; margin-bottom: 14px; }
            .modal-card label { display: block; font-size: 12px; font-weight: 600; color: var(--fg-soft); margin-bottom: 6px; }
            .modal-card textarea { width: 100%; min-height: 90px; padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface-2); color: var(--fg); font-family: var(--font-ui); font-size: 13px; resize: vertical; }
            .modal-card textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
            .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / <span><c:out value="${po.poCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <button type="button" class="btn" onclick="window.print()" title="In phiếu mua">
                            <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:1.8;"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                            In phiếu
                        </button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/purchase-order">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:choose>
                        <c:when test="${po.status == 'DRAFT'}">
                            <c:set var="statusLabel" value="Nháp"/>
                            <c:set var="statusBg" value="#e2e3e5"/>
                            <c:set var="statusFg" value="#383d41"/>
                        </c:when>
                        <c:when test="${po.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                            <c:set var="statusBg" value="#fff3cd"/>
                            <c:set var="statusFg" value="#856404"/>
                        </c:when>
                        <c:when test="${po.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt bởi CEO"/>
                            <c:set var="statusBg" value="#d4edda"/>
                            <c:set var="statusFg" value="#155724"/>
                        </c:when>
                        <c:when test="${po.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Cần chỉnh sửa đề xuất"/>
                            <c:set var="statusBg" value="#ede9fe"/>
                            <c:set var="statusFg" value="#5b21b6"/>
                        </c:when>
                        <c:when test="${po.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối bởi CEO"/>
                            <c:set var="statusBg" value="#f8d7da"/>
                            <c:set var="statusFg" value="#721c24"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusBg" value="#e2e3e5"/>
                            <c:set var="statusFg" value="#383d41"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="heroInitials">
                        <c:choose>
                            <c:when test="${not empty po.createdByName}">
                                <c:set var="nameParts" value="${fn:split(po.createdByName, ' ')}"/>
                                <c:choose>
                                    <c:when test="${fn:length(nameParts) == 1}">${fn:toUpperCase(fn:substring(po.createdByName, 0, 2))}</c:when>
                                    <c:otherwise>${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:toUpperCase(fn:substring(nameParts[fn:length(nameParts)-1], 0, 1))}</c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>??</c:otherwise>
                        </c:choose>
                    </c:set>

                    <div class="hero">
                        <div class="hero-avatar" style="background: oklch(58% 0.14 145);">${heroInitials}</div>
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${po.poCode}"/>
                                <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h2>
                            <div class="hero-meta">
                                <span class="id"><c:out value="${po.poCode}"/></span>
                                <span class="sep">·</span>
                                <span>#<c:out value="${po.poId}"/></span>
                                <span class="sep">·</span>
                                <span>Ngày tạo: ${po.createdAt.format(poFmt)}</span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${po.createdByName}"/></span>
                                <c:if test="${po.approvedBy != null}">
                                    <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${po.approvedByName != null ? po.approvedByName : '—'}"/></span>
                                </c:if>
                                <span class="pill warehouse"><span class="pdot"></span>Tổng tiền: <fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></span>
                            </div>
                        </div>
                    </div>

                    <c:set var="perms" value="${sessionScope.userPermissions}"/>
                    <c:set var="canApprovePo" value="${perms.contains('purchase_orders.approve')}"/>
                    <c:set var="canCreatePo" value="${perms.contains('purchase_orders.create')}"/>
                    <c:set var="isOwnerPo" value="${sessionScope.loggedUser.id == po.createdBy}"/>

                    <c:if test="${po.status == 'DRAFT' && canCreatePo}">
                        <div class="action-bar-top">
                            <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=sendToCeo" style="display:inline;">
                                <input type="hidden" name="id" value="${po.poId}"/>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
                                    Gửi duyệt
                                </button>
                            </form>
                            <c:if test="${isOwnerPo}">
                                <button type="button" class="btn btn-danger" onclick="openModal('cancelModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Hủy phiếu
                                </button>
                            </c:if>
                        </div>
                    </c:if>

                    <c:if test="${po.status == 'PENDING_CEO' && canApprovePo}">
                        <div class="action-bar-top">
                            <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Duyệt
                            </button>
                            <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                Yêu cầu chỉnh sửa đề xuất
                            </button>
                            <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                Từ chối
                            </button>
                        </div>
                    </c:if>

                    <c:if test="${po.status == 'NEEDS_REVISION' && not empty po.rejectReason}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            <span><strong>Lý do CEO yêu cầu chỉnh sửa đề xuất:</strong> <c:out value="${po.rejectReason}"/></span>
                        </div>
                        <div class="alert alert-info">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                            <span>Các đề xuất gốc đã được tách khỏi phiếu mua này và chuyển sang trạng thái <strong>Cần chỉnh sửa</strong>. Sale Manager cần sửa các đề xuất rồi gửi duyệt lại.</span>
                        </div>
                    </c:if>

                    <div class="tab-bar">
                        <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Thông tin & các dòng máy
                        </a>
                        <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${currentTab == 'history'}">
                            <div class="table-card history-card">
                                <form method="get" action="${pageContext.request.contextPath}/purchase-order" class="history-filter-bar">
                                    <input type="hidden" name="action" value="detail"/>
                                    <input type="hidden" name="id" value="${po.poId}"/>
                                    <input type="hidden" name="tab" value="history"/>
                                    <input type="hidden" name="page" value="1"/>

                                    <div class="search-input hf-search">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                    </div>
                                    <select name="logAction" class="filter-select">
                                        <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                        <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo phiếu mua</option>
                                        <option value="SEND_TO_CEO" ${logAction == 'SEND_TO_CEO' ? 'selected' : ''}>Gửi duyệt</option>
                                        <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                        <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                        <option value="REQUEST_REVISION" ${logAction == 'REQUEST_REVISION' ? 'selected' : ''}>Yêu cầu chỉnh sửa đề xuất</option>
                                        <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                        <option value="CANCEL" ${logAction == 'CANCEL' ? 'selected' : ''}>Hủy phiếu</option>
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
                                        <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}&amp;tab=history" class="btn">
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
                                        <th style="width:160px;">Hành động</th>
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}&amp;tab=history">xóa lọc</a></span>
                                                    </c:if>
                                                </div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="log" items="${logList}">
                                                <tr>
                                                    <td style="font-family:var(--font-mono);"><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td>
                                                        <div style="font-weight:600;color:var(--fg);"><c:out value="${log.user}"/></div>
                                                    </td>
                                                    <td>
                                                        <span class="action-badge action-<c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">create</c:when>
                                                            <c:when test="${log.action == 'SEND_TO_CEO'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'CANCEL'}">cancel</c:when>
                                                            <c:otherwise>default</c:otherwise>
                                                        </c:choose>">
                                                        <c:out value="${log.actionLabel}"/></span>
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
                                            <a href="${pageContext.request.contextPath}/purchase-order?action=detail&amp;id=${po.poId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${logTotalPages}" var="p">
                                            <c:choose>
                                                <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                <c:otherwise><a href="${pageContext.request.contextPath}/purchase-order?action=detail&amp;id=${po.poId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${logPage < logTotalPages}">
                                            <a href="${pageContext.request.contextPath}/purchase-order?action=detail&amp;id=${po.poId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                        <div class="info-label">Kỳ</div>
                                        <div class="info-value mono"><c:out value="${po.period}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Thời gian kỳ</div>
                                        <div class="info-value mono">${po.periodStart.format(poDateFmt)} → ${po.periodEnd.format(poDateFmt)}</div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Kho</div>
                                        <div class="info-value"><c:out value="${po.warehouseName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Số proposal gom</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${po.totalProposals}"/></div>
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
                                        <div class="info-label">Ngày tạo</div>
                                        <div class="info-value mono">${po.createdAt.format(poFmt)}</div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Người tạo</div>
                                        <div class="info-value"><c:out value="${po.createdByName}"/></div>
                                    </div>
                                    <c:if test="${po.sentToCeoAt != null}">
                                        <div class="info-field">
                                            <div class="info-label">Gửi CEO lúc</div>
                                            <div class="info-value mono">${po.sentToCeoAt.format(poFmt)}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${po.approvedBy != null}">
                                        <div class="info-field">
                                            <div class="info-label">Người duyệt</div>
                                            <div class="info-value"><c:out value="${po.approvedByName != null ? po.approvedByName : '—'}"/></div>
                                        </div>
                                        <div class="info-field">
                                            <div class="info-label">Duyệt lúc</div>
                                            <div class="info-value mono">${po.approvedAt.format(poFmt)}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${po.status == 'REJECTED'}">
                                        <div class="info-field">
                                            <div class="info-label">Người từ chối (CEO)</div>
                                            <div class="info-value"><c:out value="${po.rejectedByName != null ? po.rejectedByName : '—'}"/></div>
                                        </div>
                                        <div class="info-field">
                                            <div class="info-label">Từ chối lúc</div>
                                            <div class="info-value mono">${po.rejectedAt.format(poFmt)}</div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Tổng số lượng</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${po.totalQuantity}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Tổng tiền</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></div>
                                    </div>
                                </div>

                                <c:if test="${not empty po.rejectReason && po.status == 'REJECTED'}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">
                                            Lý do từ chối
                                        </div>
                                        <div class="danger-note"><c:out value="${po.rejectReason}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${po.status == 'CANCELLED' && not empty po.cancelReason}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do hủy</div>
                                        <div class="danger-note"><c:out value="${po.cancelReason}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty po.note}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú PO</div>
                                        <div class="note-soft"><c:out value="${po.note}"/></div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="table-card history-card" style="margin-top: 18px;">
                                <div class="result-summary">
                                    <span>Danh sách máy cần mua (<strong>${not empty po.details ? fn:length(po.details) : 0}</strong> dòng)</span>
                                    <span>Tổng tiền: <strong style="color:var(--fg);font-family:var(--font-mono);"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></strong></span>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                            <th>Mã máy</th>
                                            <th>Tên máy</th>
                                            <th>Thương hiệu</th>
                                            <th style="width: 90px;">SL đề xuất</th>
                                            <th style="width: 80px;">Tồn kho</th>
                                            <th style="width: 90px;">SL mua</th>
                                            <th style="width: 140px;" class="text-right">Đơn giá</th>
                                            <th style="width: 140px;" class="text-right">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty po.details}">
                                                <tr><td colspan="9">
                                                    <div class="empty-state">
                                                        <div class="icon-wrap">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                        </div>
                                                        <strong>Chưa có dòng máy nào trong phiếu mua</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${po.details}" varStatus="st">
                                                    <tr>
                                                        <td class="mono">${st.index + 1}</td>
                                                        <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                        <td><c:out value="${d.generatorName}"/></td>
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td class="mono"><fmt:formatNumber value="${d.proposedQuantity}"/></td>
                                                        <td class="mono"><fmt:formatNumber value="${d.currentStock}"/></td>
                                                        <td class="mono"><strong><fmt:formatNumber value="${d.finalQuantity}"/></strong></td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></c:when>
                                                                <c:otherwise>—</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice * d.finalQuantity}" type="currency" currencySymbol="₫"/></c:when>
                                                                <c:otherwise>—</c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty po.details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="8" class="text-right" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border);">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border); color: var(--accent);"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                            </div>

                            <c:if test="${not empty sourceProposals}">
                                <div class="table-card history-card" style="margin-top: 18px;">
                                    <div class="result-summary">
                                        <span>Đề xuất gốc từ sale staff (<strong>${fn:length(sourceProposals)}</strong> phiếu)</span>
                                    </div>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Mã phiếu</th>
                                                <th>Người tạo</th>
                                                <th>Kho</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sp" items="${sourceProposals}">
                                                <tr>
                                                    <td class="mono"><a href="${pageContext.request.contextPath}/proposal?action=detail&id=${sp.proposalId}"><c:out value="${sp.proposalCode}"/></a></td>
                                                    <td><c:out value="${sp.createdByName}"/></td>
                                                    <td><c:out value="${sp.warehouseName}"/></td>
                                                    <td><c:out value="${sp.status}"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>

        <c:if test="${po.status == 'DRAFT' && canCreatePo && isOwnerPo}">
            <div class="modal-host" id="cancelModal">
                <div class="modal-card">
                    <h3>Hủy phiếu mua</h3>
                    <div class="modal-sub">Phiếu mua sẽ bị hủy và các đề xuất liên kết sẽ được giải phóng. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=cancel">
                        <input type="hidden" name="id" value="${po.poId}"/>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('cancelModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Bạn có chắc muốn hủy phiếu mua này?');">Xác nhận hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${po.status == 'PENDING_CEO' && canApprovePo}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt</h3>
                    <div class="modal-sub">Xác nhận duyệt phiếu mua <strong><c:out value="${po.poCode}"/></strong>?</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=approve">
                        <input type="hidden" name="id" value="${po.poId}"/>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary" onclick="return confirm('Bạn có chắc muốn duyệt phiếu mua này?');">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa đề xuất</h3>
                    <div class="modal-sub">Các đề xuất gốc sẽ được tách khỏi phiếu mua này và chuyển sang trạng thái <strong>Cần chỉnh sửa</strong> để Sale Manager chỉnh sửa (ghi chú, nhà cung cấp, kho, tháng...). Không áp dụng cho sai máy/giá/số lượng - trường hợp đó hãy dùng <strong>Từ chối</strong>.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=requestRevision">
                        <input type="hidden" name="id" value="${po.poId}"/>
                        <label for="revisionReason">Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea id="revisionReason" name="revisionReason" required placeholder="Ví dụ: Ghi chú chưa rõ, chọn nhầm kho, cần đổi nhà cung cấp..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu cho Sale Manager</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối</h3>
                    <div class="modal-sub">Phiếu mua sẽ bị từ chối và các đề xuất liên kết sẽ được giải phóng. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=reject">
                        <input type="hidden" name="id" value="${po.poId}"/>
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="rejectReason" required placeholder="Ví dụ: Vượt ngân sách, sai số lượng, thiếu thông tin..." style="margin-top:8px;"></textarea>
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
            <c:if test="${not empty sessionScope.message}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${sessionScope.message}"/>';
            window.SESSION_DATA.type = '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>';
            <c:remove var="message" scope="session"/>
            <c:remove var="messageType" scope="session"/>
            </c:if>
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
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    }
                }
            });
        </script>
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