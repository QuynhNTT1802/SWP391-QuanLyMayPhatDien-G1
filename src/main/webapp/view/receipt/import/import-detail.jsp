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
        <title>Chi tiết phiếu nhập — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu nhập</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / <span><c:out value="${receipt.receiptCode}"/></span></span>
                    <div class="top-actions">
                        <jsp:include page="../../common/admin/bell.jsp"/>
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <a class="receipt-back-link" href="${pageContext.request.contextPath}/import-receipt">
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
                        <c:when test="${receipt.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                        </c:when>
                        <c:when test="${receipt.status == 'COMPLETED'}">
                            <c:set var="statusLabel" value="Hoàn thành"/>
                        </c:when>
                        <c:when test="${receipt.status == 'CANCELLED'}">
                            <c:set var="statusLabel" value="Đã từ chối"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="${receipt.status}"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="receipt-header-bar">
                        <div class="left">
                            <span class="receipt-code-tag">
                                <span class="ct-label">Mã phiếu nhập</span>
                                <c:out value="${receipt.receiptCode}"/>
                            </span>
                            <h1 class="receipt-page-title">
                                Phiếu nhập kho #${receipt.receiptId}
                                <span class="status-pill ${receipt.status == 'PENDING' ? 'status-pending' : receipt.status == 'COMPLETED' ? 'status-completed' : receipt.status == 'CANCELLED' ? 'status-cancelled' : 'status-draft'}">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h1>
                            <div style="display:flex;gap:14px;flex-wrap:wrap;font-size:13px;color:var(--muted);">
                                <span><strong style="color:var(--fg);">Kho:</strong> <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}"><c:out value="${receipt.warehouseName}"/></a></span>
                                <span><strong style="color:var(--fg);">Người tạo:</strong> <c:out value="${receipt.createdByName}"/></span>
                                <c:if test="${not empty receipt.approvedByName}">
                                    <span><strong style="color:var(--fg);">Người duyệt:</strong> <c:out value="${receipt.approvedByName}"/></span>
                                </c:if>
                                <c:if test="${not empty receipt.createdAt}">
                                    <span><strong style="color:var(--fg);">Ngày tạo:</strong> ${receipt.createdAt}</span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="tabs">
                        <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                            Thông tin & các máy
                        </a>
                        <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Lịch sử cập nhật
                            <c:if test="${not empty totalLogs and totalLogs > 0}"><span class="tab-badge">${totalLogs}</span></c:if>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${currentTab == 'history'}">
                            <div class="table-card history-card">
                                <form method="get" action="${pageContext.request.contextPath}/import-receipt" class="history-filter-bar">
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
                                        <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                        <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                        <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                        <option value="REVISION" ${logAction == 'REVISION' ? 'selected' : ''}>Yêu cầu sửa</option>
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
                                        <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="btn">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history">xóa lọc</a></span>
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
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${log.action == 'REVISION'}">revision</c:when>
                                                            <c:otherwise>default</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">Tạo phiếu</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">Duyệt</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">Từ chối</c:when>
                                                            <c:when test="${log.action == 'REVISION'}">Yêu cầu sửa</c:when>
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
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${logTotalPages}" var="p">
                                            <c:choose>
                                                <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                <c:otherwise><a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${logPage < logTotalPages}">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
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
                                        <div class="info-value">Nhập kho</div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Mã phiếu</div>
                                        <div class="info-value mono"><c:out value="${receipt.receiptCode}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Kho nhập</div>
                                        <div class="info-value"><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}"><c:out value="${receipt.warehouseName}"/></a></div>
                                    </div>
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
                                    <div class="info-field">
                                        <div class="info-label">Người tạo</div>
                                        <div class="info-value"><c:out value="${receipt.createdByName}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Ngày tạo</div>
                                        <div class="info-value mono">${receipt.createdAt}</div>
                                    </div>
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
                                <span class="status-pill ${receipt.status == 'PENDING' ? 'status-pending' : receipt.status == 'COMPLETED' ? 'status-completed' : 'status-cancelled'}">
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
                                                        <td class="mono">${st.index + 1}</td>
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
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    }
                }
            });
        </script>
    </body>
</html>