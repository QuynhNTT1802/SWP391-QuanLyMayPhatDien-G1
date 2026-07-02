<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu xuất — Warehouse OS</title>
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
            .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
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
            .product-table tfoot td { background: var(--surface-2); font-weight: 700; }
            .text-center { text-align: center; }
            .text-right { text-align: right; }

            .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
            .info-value .status-pill { white-space: nowrap; }

            .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-card .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; line-height: 1.5; }
            .modal-card label { display: block; font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 6px; }
            .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; min-height: 80px; resize: vertical; }
            .modal-card textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
            .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }


        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu xuất</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/export-receipt">Phiếu xuất</a> / <span><c:out value="${receipt.receiptCode}"/></span></span>
                    <div class="top-actions">
                        <jsp:include page="../../common/admin/bell.jsp"/>
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                        <c:if test="${(receipt.status == 'NEEDS_REVISION' || receipt.status == 'DRAFT') && isOwner}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/export-receipt?action=edit&id=${receipt.receiptId}">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Chỉnh sửa
                            </a>
                        </c:if>
                        <c:if test="${receipt.status == 'PENDING' && isOwner}">
                            <button type="button" class="btn btn-danger" onclick="confirmCancelDetail()">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                Rút phiếu
                            </button>
                        </c:if>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/export-receipt">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${receipt.status == 'DRAFT'}">
                            <c:set var="statusLabel" value="Bản nháp"/>
                            <c:set var="statusBg" value="#d1ecf1"/>
                            <c:set var="statusFg" value="#0c5460"/>
                        </c:when>
                        <c:when test="${receipt.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusBg" value="#fff3cd"/>
                            <c:set var="statusFg" value="#856404"/>
                        </c:when>
                        <c:when test="${receipt.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Yêu cầu chỉnh sửa"/>
                            <c:set var="statusBg" value="#ffe0b2"/>
                            <c:set var="statusFg" value="#b15c00"/>
                        </c:when>
                        <c:when test="${receipt.status == 'COMPLETED'}">
                            <c:set var="statusLabel" value="Hoàn thành"/>
                            <c:set var="statusBg" value="#d4edda"/>
                            <c:set var="statusFg" value="#155724"/>
                        </c:when>
                        <c:when test="${receipt.status == 'CANCELLED'}">
                            <c:set var="statusLabel" value="Đã từ chối"/>
                            <c:set var="statusBg" value="#f8d7da"/>
                            <c:set var="statusFg" value="#721c24"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="${receipt.status}"/>
                            <c:set var="statusBg" value="#e2e3e5"/>
                            <c:set var="statusFg" value="#383d41"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="hero">
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${receipt.receiptCode}"/>
                                <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h2>
                            <div class="hero-meta">
                                <span>Phiếu xuất kho</span>
                                <span class="sep">·</span>
                                <span class="id">#${receipt.receiptId}</span>
                                <c:if test="${not empty receipt.createdAt}">
                                    <span class="sep">·</span>
                                    <span>Ngày tạo: ${receipt.createdAt}</span>
                                </c:if>
                            </div>
                            <div class="hero-pills">
                                <span class="pill warehouse"><span class="pdot"></span><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}" style="color:inherit;text-decoration:underline;"><c:out value="${receipt.warehouseName}"/></a></span>
                                <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${receipt.createdByName}"/></span>
                                <c:if test="${not empty receipt.approvedByName}">
                                    <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${receipt.approvedByName}"/></span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <c:if test="${receipt.status == 'PENDING' && isManager}">
                        <div class="action-bar-top">
                            <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Duyệt phiếu
                            </button>
                            <button type="button" class="btn" onclick="openModal('revisionModal')">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Yêu cầu chỉnh sửa
                            </button>
                            <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                Từ chối
                            </button>
                        </div>
                    </c:if>

                    <div class="tab-bar">
                        <a href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${receipt.receiptId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Thông tin & các máy
                        </a>
                        <a href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${currentTab == 'history'}">

                            <div class="table-card history-card">
                                <form method="get" action="${pageContext.request.contextPath}/export-receipt" class="history-filter-bar">
                                    <input type="hidden" name="action" value="detail"/>
                                    <input type="hidden" name="id" value="${receipt.receiptId}"/>
                                    <input type="hidden" name="tab" value="history"/>
                                    <input type="hidden" name="page" value="1"/>

                                    <div class="search-input hf-search">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                    </div>
                                    <select name="logAction" class="filter-select">
                                        <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                        <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo phiếu</option>
                                        <option value="AUTO_CREATE" ${logAction == 'AUTO_CREATE' ? 'selected' : ''}>Tạo tự động</option>
                                        <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                        <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                        <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                        <option value="REVISION" ${logAction == 'REVISION' ? 'selected' : ''}>Yêu cầu sửa</option>
                                        <option value="DRAFT_UPDATE" ${logAction == 'DRAFT_UPDATE' ? 'selected' : ''}>Lưu nháp</option>
                                        <option value="SUBMIT_DRAFT" ${logAction == 'SUBMIT_DRAFT' ? 'selected' : ''}>Gửi duyệt</option>
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
                                        <a href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="btn">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history">xóa lọc</a></span>
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
                                                            <c:when test="${log.action == 'AUTO_CREATE'}">auto_create</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${log.action == 'REVISION'}">revision</c:when>
                                                            <c:when test="${log.action == 'DRAFT_UPDATE'}">draft_update</c:when>
                                                            <c:when test="${log.action == 'SUBMIT_DRAFT'}">submit_draft</c:when>
                                                            <c:otherwise>default</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">Tạo phiếu</c:when>
                                                            <c:when test="${log.action == 'AUTO_CREATE'}">Tạo tự động</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">Duyệt</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">Từ chối</c:when>
                                                            <c:when test="${log.action == 'REVISION'}">Yêu cầu sửa</c:when>
                                                            <c:when test="${log.action == 'DRAFT_UPDATE'}">Lưu nháp</c:when>
                                                            <c:when test="${log.action == 'SUBMIT_DRAFT'}">Gửi duyệt</c:when>
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
                                            <a href="${pageContext.request.contextPath}/export-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${logTotalPages}" var="p">
                                            <c:choose>
                                                <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                <c:otherwise><a href="${pageContext.request.contextPath}/export-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${logPage < logTotalPages}">
                                            <a href="${pageContext.request.contextPath}/export-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                        <div class="info-label">Loại phiếu</div>
                                        <div class="info-value">Xuất kho</div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Mã phiếu</div>
                                        <div class="info-value mono"><c:out value="${receipt.receiptCode}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Kho xuất</div>
                                        <div class="info-value"><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}"><c:out value="${receipt.warehouseName}"/></a></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Người tạo</div>
                                        <div class="info-value"><c:out value="${receipt.createdByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Ngày tạo</div>
                                        <div class="info-value mono">${receipt.createdAt}</div>
                                    </div>
                                    <c:if test="${not empty receipt.orderCode}">
                                        <div class="info-field">
                                            <div class="info-label">Đơn hàng</div>
                                            <div class="info-value mono"><a href="${pageContext.request.contextPath}/order?action=detail&id=${receipt.orderId}"><c:out value="${receipt.orderCode}"/></a></div>
                                        </div>
                                        <div class="info-field">
                                            <div class="info-label">Khách hàng</div>
                                            <div class="info-value"><c:out value="${receipt.customerName}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty receipt.purchaseOrderCode}">
                                        <div class="info-field">
                                            <div class="info-label">Phiếu mua nguồn</div>
                                            <div class="info-value mono">
                                                <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${receipt.purchaseOrderId}">
                                                    <c:out value="${receipt.purchaseOrderCode}"/>
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty receipt.approvedByName}">
                                        <div class="info-field">
                                            <div class="info-label">Người duyệt</div>
                                            <div class="info-value"><c:out value="${receipt.approvedByName}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty receipt.approvedAt}">
                                        <div class="info-field">
                                            <div class="info-label">Ngày duyệt</div>
                                            <div class="info-value mono">${receipt.approvedAt}</div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty receipt.reasonName}">
                                        <div class="info-field">
                                            <div class="info-label">Lý do</div>
                                            <div class="info-value"><c:out value="${receipt.reasonName}"/><c:if test="${not empty receipt.reasonNote}"> — <c:out value="${receipt.reasonNote}"/></c:if></div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Trạng thái</div>
                                        <div class="info-value">
                                            <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                                <span class="pdot"></span>${statusLabel}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${not empty receipt.note}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú</div>
                                        <div class="note-soft"><c:out value="${receipt.note}"/></div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="table-card history-card" style="margin-top: 18px;">
                                <div class="result-summary" style="display:flex;align-items:center;justify-content:space-between;">
                                    <span>Danh sách máy phát điện (<strong>${not empty receipt.details ? fn:length(receipt.details) : 0}</strong> dòng)</span>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                            <th>Máy phát / Hãng</th>
                                            <th>Serial</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty receipt.details}">
                                                <tr><td colspan="4" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                                    <tr>
                                                        <td class="mono" style="font-family:var(--font-mono);">${st.index + 1}</td>
                                                        <td>
                                                            <strong><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${d.generatorId}"><c:out value="${d.generatorModel}"/></a></strong>
                                                            <span style="color: var(--muted);"><c:out value="${d.generatorBrand}"/></span>
                                                        </td>
                                                        <td style="font-family:var(--font-mono);"><c:out value="${d.serialNumber}"/></td>
                                                        <td><c:out value="${d.note}"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>

        <c:if test="${receipt.status == 'PENDING' && isManager}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu xuất</h3>
                    <div class="modal-sub">Xác nhận duyệt phiếu <strong><c:out value="${receipt.receiptCode}"/></strong>? Hệ thống sẽ cập nhật tồn kho tương ứng.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/export-receipt?action=approve" id="approveForm">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối phiếu</h3>
                    <div class="modal-sub">Phiếu sẽ bị huỷ và không cập nhật tồn kho. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/export-receipt?action=reject">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="reason" required placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, hàng không đạt chất lượng..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub">Gửi phiếu lại cho nhân viên tạo phiếu kèm lý do để chỉnh sửa và gửi lại.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/export-receipt?action=requestRevision" id="revisionFormDetail">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="reason" id="revisionReasonDetail" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
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
        <script src="${pageContext.request.contextPath}/assets/js/export-scanner-actions.js"></script>
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
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
                    window.SESSION_DATA = null;
                }
            });

            var detailCancelLock = false;
            function confirmCancelDetail() {
                var ctx = window.APP_CTX;
                var receiptId = ${receipt.receiptId};
                if (!receiptId || !window.ExportScannerActions) return;
                if (detailCancelLock) return;
                window.ExportScannerActions.confirmAction({
                    modalId: 'cancelDetailModal',
                    title: 'Rút phiếu đang chờ duyệt',
                    body: 'Phiếu đang chờ duyệt sẽ bị rút lại, các serial sẽ trả về kho và người duyệt sẽ nhận thông báo.',
                    confirmLabel: 'Rút phiếu',
                    danger: true
                }).then(function () {
                    detailCancelLock = true;
                    return window.ExportScannerActions.cancelPending(receiptId);
                }).then(function (data) {
                    detailCancelLock = false;
                    if (!data || !data.success) {
                        toast((data && data.message) ? data.message : 'Lỗi', 'danger');
                        return;
                    }
                    toast(data.message || 'Đã huỷ phiếu', 'success');
                    setTimeout(function () { window.location.reload(); }, 700);
                }).catch(function (err) {
                    detailCancelLock = false;
                    if (err && err.message === 'cancelled') return;
                    console.error(err);
                    toast('Lỗi kết nối: ' + err.message, 'danger');
                });
            }
        </script>
    </body>
</html>