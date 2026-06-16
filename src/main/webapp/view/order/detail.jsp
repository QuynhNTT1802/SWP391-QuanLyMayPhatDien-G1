<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }
            .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
            .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
            .alert-error { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }

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
                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusBg" value="#fff3cd"/>
                            <c:set var="statusFg" value="#856404"/>
                        </c:when>
                        <c:when test="${order.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusBg" value="#d4edda"/>
                            <c:set var="statusFg" value="#155724"/>
                        </c:when>
                        <c:when test="${order.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
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
                            <c:when test="${not empty order.customer.name}">
                                <c:set var="nameParts" value="${fn:split(order.customer.name, ' ')}"/>
                                <c:choose>
                                    <c:when test="${fn:length(nameParts) == 1}">${fn:toUpperCase(fn:substring(order.customer.name, 0, 2))}</c:when>
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
                                <c:out value="${order.customer.name}"/>
                                <span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:${statusBg};color:${statusFg};">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h2>
                            <div class="hero-meta">
                                <span class="id"><c:out value="${order.orderCode}"/></span>
                                <span class="sep">·</span>
                                <span>#<c:out value="${order.orderId}"/></span>
                                <span class="sep">·</span>
                                <span>Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${order.createdByName}"/></span>
                                <c:if test="${order.approvedBy != 0}">
                                    <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${order.approvedByName}"/></span>
                                </c:if>
                                <span class="pill warehouse"><span class="pdot"></span>Tổng tiền: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></span>
                            </div>
                        </div>
                    </div>

                    <div class="tab-bar">
                        <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Thông tin & các máy
                        </a>
                        <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${currentTab == 'history'}">
                            <div class="table-card history-card">
                                <form method="get" action="${pageContext.request.contextPath}/order" class="history-filter-bar">
                                    <input type="hidden" name="action" value="detail"/>
                                    <input type="hidden" name="id" value="${order.orderId}"/>
                                    <input type="hidden" name="tab" value="history"/>
                                    <input type="hidden" name="page" value="1"/>

                                    <div class="search-input hf-search">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                    </div>
                                    <select name="logAction" class="filter-select">
                                        <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                        <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo đơn hàng</option>
                                        <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                        <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                        <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                        <option value="CANCEL" ${logAction == 'CANCEL' ? 'selected' : ''}>Hủy đơn</option>
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
                                        <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history" class="btn">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history">xóa lọc</a></span>
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
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
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
                                            <a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${logTotalPages}" var="p">
                                            <c:choose>
                                                <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                <c:otherwise><a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${logPage < logTotalPages}">
                                            <a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                        <div class="info-label">Tên khách hàng</div>
                                        <div class="info-value"><c:out value="${order.customer.name}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Số điện thoại</div>
                                        <div class="info-value mono"><c:out value="${order.customer.phone}"/></div>
                                    </div>
                                    <c:if test="${not empty order.customer.email}">
                                        <div class="info-field">
                                            <div class="info-label">Email</div>
                                            <div class="info-value mono"><c:out value="${order.customer.email}"/></div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Địa chỉ giao hàng</div>
                                        <div class="info-value"><c:out value="${order.customer.address}"/></div>
                                    </div>
                                    <c:if test="${not empty customerTypeName}">
                                        <div class="info-field">
                                            <div class="info-label">Loại khách hàng</div>
                                            <div class="info-value"><c:out value="${customerTypeName}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.customer.companyName}">
                                        <div class="info-field">
                                            <div class="info-label">Công ty</div>
                                            <div class="info-value"><c:out value="${order.customer.companyName}"/></div>
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
                                    <div class="info-field">
                                        <div class="info-label">Ngày đặt</div>
                                        <div class="info-value mono"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </div>
                                    <c:if test="${not empty order.createdByName}">
                                        <div class="info-field">
                                            <div class="info-label">Người tạo</div>
                                            <div class="info-value"><c:out value="${order.createdByName}"/></div>
                                        </div>
                                    </c:if>
                                    <c:if test="${order.approvedBy != 0}">
                                        <div class="info-field">
                                            <div class="info-label">Người duyệt</div>
                                            <div class="info-value"><c:out value="${order.approvedByName}"/></div>
                                        </div>
                                    </c:if>
                                    <div class="info-field">
                                        <div class="info-label">Tổng tiền</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></div>
                                    </div>
                                </div>

                                <c:if test="${not empty order.rejectReason}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do từ chối</div>
                                        <div class="danger-note"><c:out value="${order.rejectReason}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty order.note}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú nội bộ</div>
                                        <div class="note-soft"><c:out value="${order.note}"/></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty order.customerNote}">
                                    <div style="margin-top: 18px;">
                                        <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú của khách hàng</div>
                                        <div class="note-soft"><c:out value="${order.customerNote}"/></div>
                                    </div>
                                </c:if>
                            </div>

                            <div class="table-card history-card" style="margin-top: 18px;">
                                <div class="result-summary">
                                    <span>Danh sách máy phát điện (<strong>${not empty details ? fn:length(details) : 0}</strong> sản phẩm)</span>
                                    <span>Tổng tiền: <strong style="color:var(--fg);font-family:var(--font-mono);"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></strong></span>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                            <th>Sản phẩm</th>
                                            <th style="width: 100px;">SL</th>
                                            <th style="width: 160px;" class="text-right">Đơn giá</th>
                                            <th style="width: 160px;" class="text-right">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty details}">
                                                <tr><td colspan="5">
                                                    <div class="empty-state">
                                                        <div class="icon-wrap">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                        </div>
                                                        <strong>Chưa có sản phẩm nào trong đơn hàng</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${details}" varStatus="st">
                                                    <tr>
                                                        <td class="mono">${st.index + 1}</td>
                                                        <td>
                                                            <strong><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${d.generatorId}"><c:out value="${d.generatorModel}"/></a></strong>
                                                        </td>
                                                        <td class="mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                        <td class="text-right mono" style="font-weight:600;"><fmt:formatNumber value="${d.quantity * d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="4" class="text-right" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border);">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border); color: var(--accent);"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

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
