<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết kho — Warehouse OS</title>
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
        .alert-success { background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }
        .action-badge.action-lock   { background: var(--danger-soft); color: var(--danger); }
        .action-badge.action-unlock { background: var(--accent-soft); color: var(--accent); }
        .result-summary { padding: 10px 14px; font-size: 12.5px; color: var(--muted); background: var(--surface-2); border-bottom: 1px solid var(--border); }
        .filter-active-badge { display: inline-block; padding: 2px 8px; border-radius: 999px; background: var(--accent-soft); color: var(--accent); font-weight: 600; font-size: 11px; }
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 48px 16px; gap: 8px; color: var(--muted); }
        .empty-state .icon-wrap { width: 44px; height: 44px; border-radius: 50%; background: var(--surface-2); display: flex; align-items: center; justify-content: center; }
        .empty-state .icon-wrap svg { width: 22px; height: 22px; stroke: var(--muted); }
        .empty-state strong { color: var(--fg); font-size: 14px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse?action=list">Kho hàng</a> / <span><c:out value="${warehouse.name}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <c:choose>
                    <c:when test="${warehouse.status == 'locked'}">
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse?action=unlock&id=${warehouse.warehouseId}" onclick="return confirm('Mở khóa kho này? Các máy trong kho sẽ hiển thị lại trong tồn kho.');">
                            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 9.9-1"/></svg>
                            Mở khóa kho
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse?action=lock&id=${warehouse.warehouseId}" onclick="return confirm('Khóa kho này? Các máy trong kho sẽ bị ẩn khỏi tồn kho cho đến khi mở khóa lại.');">
                            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            Khóa kho
                        </a>
                    </c:otherwise>
                </c:choose>
                <a class="btn" href="${pageContext.request.contextPath}/warehouse?action=update&id=${warehouse.warehouseId}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-success">
                    <svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                    <span>Cập nhật thông tin kho thành công!</span>
                </div>
            </c:if>

            <div class="hero">
                <div class="hero-avatar" style="background: oklch(58% 0.12 80);">
                    <c:set var="nameParts" value="${fn:split(warehouse.name, ' ')}"/>
                    <c:choose>
                        <c:when test="${fn:length(nameParts) == 1}">${fn:toUpperCase(fn:substring(warehouse.name, 0, 2))}</c:when>
                        <c:otherwise>${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:toUpperCase(fn:substring(nameParts[fn:length(nameParts)-1], 0, 1))}</c:otherwise>
                    </c:choose>
                </div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${warehouse.name}"/>
                        <c:choose>
                            <c:when test="${warehouse.status == 'active'}"><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#d4edda;color:#155724;">Hoạt động</span></c:when>
                            <c:when test="${warehouse.status == 'locked'}"><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#f8d7da;color:#721c24;">Bị khóa</span></c:when>
                            <c:otherwise><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#f8d7da;color:#721c24;">Ngưng hoạt động</span></c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="hero-meta">
                        <span>Kho hàng</span>
                        <span class="sep">·</span>
                        <span class="id">#${warehouse.warehouseId}</span>
                    </div>
                    <div class="hero-pills">
                        <span class="pill warehouse"><span class="pdot"></span><c:out value="${warehouse.address}"/></span>
                        <span class="pill status-active"><span class="pdot"></span>Tồn kho: <fmt:formatNumber value="${warehouse.totalInventory}"/></span>
                        <span class="pill role-admin"><span class="pdot"></span><c:out value="${warehouse.itemCount}"/> mặt hàng</span>
                    </div>
                </div>
            </div>

            <div class="tab-bar">
                <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Thông tin chung
                </a>
                <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    Lịch sử
                </a>
            </div>

            <c:choose>
                <c:when test="${currentTab == 'history'}">
                    <div class="table-card history-card">
                        <form method="get" action="${pageContext.request.contextPath}/warehouse" class="history-filter-bar">
                            <input type="hidden" name="action" value="view"/>
                            <input type="hidden" name="id" value="${warehouse.warehouseId}"/>
                            <input type="hidden" name="tab" value="history"/>
                            <input type="hidden" name="page" value="1"/>

                            <div class="search-input hf-search">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input name="logSearch" value="${logSearch}" placeholder="Tìm tên kho, người dùng..." autocomplete="off"/>
                            </div>
                            <select name="logAction" class="filter-select">
                                <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                <option value="LOCK" ${logAction == 'LOCK' ? 'selected' : ''}>Khóa kho</option>
                                <option value="UNLOCK" ${logAction == 'UNLOCK' ? 'selected' : ''}>Mở khóa kho</option>
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
                                <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}&amp;tab=history" class="btn">
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
                                <th style="width:180px;">Người dùng</th>
                                <th style="width:140px;">Hành động</th>
                                <th>Đối tượng</th>
                                <th>Chi tiết</th>
                            </tr></thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty logList}">
                                    <tr><td colspan="5">
                                        <div class="empty-state">
                                            <div class="icon-wrap">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                            </div>
                                            <strong>Không có bản ghi nào</strong>
                                            <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}&amp;tab=history">xóa lọc</a></span>
                                            </c:if>
                                        </div>
                                    </td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${logList}">
                                        <tr>
                                            <td><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>
                                                <div style="font-weight:600;color:var(--fg);">${log.username}</div>
                                            </td>
                                            <td>
                                                <span class="action-badge action-<c:choose><c:when test="${log.action == 'UPDATE'}">update</c:when><c:when test="${log.action == 'LOCK'}">lock</c:when><c:when test="${log.action == 'UNLOCK'}">unlock</c:when><c:otherwise>default</c:otherwise></c:choose>"><c:choose><c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when><c:when test="${log.action == 'LOCK'}">Khóa kho</c:when><c:when test="${log.action == 'UNLOCK'}">Mở khóa kho</c:when><c:otherwise>${log.action}</c:otherwise></c:choose></span>
                                            </td>
                                            <td style="font-weight:600;color:var(--fg);">${log.entityName}</td>
                                            <td style="max-width:380px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                ${log.details}
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
                                    <a href="${pageContext.request.contextPath}/warehouse?action=view&amp;id=${warehouse.warehouseId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                </c:if>
                                <c:forEach begin="1" end="${logTotalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="${pageContext.request.contextPath}/warehouse?action=view&amp;id=${warehouse.warehouseId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${logPage < logTotalPages}">
                                    <a href="${pageContext.request.contextPath}/warehouse?action=view&amp;id=${warehouse.warehouseId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                <div class="info-label">Tên kho</div>
                                <div class="info-value mono"><c:out value="${warehouse.name}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Địa chỉ</div>
                                <div class="info-value"><c:out value="${warehouse.address}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${warehouse.status == 'active'}"><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#d4edda;color:#155724;">Hoạt động</span></c:when>
                                        <c:when test="${warehouse.status == 'locked'}"><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#f8d7da;color:#721c24;">Bị khóa</span></c:when>
                                        <c:otherwise><span style="display:inline-flex;align-items:center;gap:6px;padding:4px 10px;border-radius:20px;font-size:12px;font-weight:600;background:#f8d7da;color:#721c24;">Ngưng hoạt động</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Tổng tồn kho</div>
                                <div class="info-value mono"><fmt:formatNumber value="${warehouse.totalInventory}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Số mặt hàng</div>
                                <div class="info-value mono">${warehouse.itemCount}</div>
                            </div>
                            <c:if test="${not empty warehouse.createdAt}">
                                <div class="info-field">
                                    <div class="info-label">Ngày tạo</div>
                                    <div class="info-value mono">${warehouse.createdAt}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty warehouse.updatedAt}">
                                <div class="info-field">
                                    <div class="info-label">Cập nhật cuối</div>
                                    <div class="info-value mono">${warehouse.updatedAt}</div>
                                </div>
                            </c:if>
                            <c:if test="${not empty warehouse.description}">
                                <div class="info-field" style="grid-column: span 2;">
                                    <div class="info-label">Mô tả</div>
                                    <div style="font-size:13px;color:var(--fg-soft);white-space:pre-wrap;line-height:1.55;padding:14px;background:var(--surface-2);border-radius:var(--radius-sm);"><c:out value="${warehouse.description}"/></div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
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
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
