<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __poFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    java.time.format.DateTimeFormatter __poDateFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
    java.time.format.DateTimeFormatter __poInputDateFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
    java.time.format.DateTimeFormatter __poInputDtFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    request.setAttribute("poFmt", __poFmt);
    request.setAttribute("poDateFmt", __poDateFmt);
    request.setAttribute("poInputDateFmt", __poInputDateFmt);
    request.setAttribute("poInputDtFmt", __poInputDtFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu mua — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-detail.css">
    </head>
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
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
                    <c:choose>
                        <c:when test="${po.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                            <c:set var="statusPillClass" value="status-pending_ceo"/>
                        </c:when>
                        <c:when test="${po.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt bởi CEO"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${po.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối bởi CEO"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApproveNow" value="${po.status == 'PENDING_CEO' && canApprovePo}" />
                    <c:set var="canRejectNow" value="${po.status == 'PENDING_CEO' && canApprovePo}" />

                   
                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/purchase-order">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại danh sách
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Phiếu mua -</span>
                                <span><c:out value="${po.poCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${po.poCode}"/>
                                <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                            </h2>
                        </div>
                        <div class="right">
                            <c:if test="${canApproveNow}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Xác nhận
                                </button>
                            </c:if>
                            
                            <c:if test="${canRejectNow}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <div class="section">
                        <div class="section-head">
                            <h3>Thông tin chung</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Mã phiếu mua</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${po.poCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tên phiếu mua</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${po.poCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày tạo</label>
                                    <input class="info-input mono" type="text" disabled value="${po.createdAt.format(poFmt)}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng số lượng máy</label>
                                    <input class="info-input mono" type="number" disabled value="${po.totalQuantity}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng kinh phí (VNĐ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${grandTotal}' pattern='#,##0'/> ₫">
                                </div>
                            </div>
                            <div class="form-grid cols-5" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>Kỳ</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${po.period}'/>">
                                    <span class="info-icon" title="Kỳ gom đề xuất">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Thời gian kỳ</label>
                                    <input class="info-input mono" type="text" disabled value="${po.periodStart.format(poDateFmt)} → ${po.periodEnd.format(poDateFmt)}">
                                </div>
                                <div class="info-field">
                                    <label>Kho</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${po.warehouseName}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Số proposal gom</label>
                                    <input class="info-input mono" type="number" disabled value="${po.totalProposals}">
                                </div>
                                <div class="info-field">
                                    <label>Người tạo</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${po.createdByName}'/>">
                                </div>
                            </div>
                            <div class="form-grid cols-2" style="margin-top: 14px;">
                                <div class="info-field">
                                    <label>Người duyệt</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${po.approvedBy != null && not empty po.approvedByName ? po.approvedByName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày duyệt</label>
                                    <input class="info-input mono" type="text" disabled value="<c:choose><c:when test='${po.approvedAt == null}'>—</c:when><c:otherwise>${po.approvedAt.format(poFmt)}</c:otherwise></c:choose>">
                                </div>
                            </div>
                        </div>
                    </div>

                    
                    <div class="section">
                        <div class="section-head">
                            <h3>Danh sách máy cần mua</h3>
                        </div>

                        <div class="tab-bar">
                            <a href="#" class="tab ${currentTab != 'history' && currentTab != 'proposals' ? 'active' : ''}" data-tab="generators">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                Danh sách máy
                            </a>
                            <a href="#" class="tab ${currentTab == 'proposals' ? 'active' : ''}" data-tab="proposals">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                Phiếu đề xuất gốc
                                <span class="tab-badge">${fn:length(sourceProposals)}</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <span class="tab-badge">${totalLogs}</span>
                            </a>
                        </div>

                        <div class="tab-panel ${currentTab != 'history' && currentTab != 'proposals' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="poSearch" placeholder="Tìm kiếm thông tin..." autocomplete="off"/>
                                </div>
                                <div class="spacer"></div>
                                <button type="button" class="btn" title="Xuất file (đang phát triển)">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    Xuất file
                                </button>
                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="poTable">
                                    <thead>
                                        <tr>
                                            <th>Mã máy</th>
                                            <th>Tên máy</th>
                                            <th>Thương hiệu</th>
                                            <th class="text-right">SL đề xuất</th>
                                            <th class="text-right">Tồn kho</th>
                                            <th class="text-right">SL mua</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                            <th>Trạng thái</th>
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
                                                    <tr data-row-id="${d.poDetailId != null ? d.poDetailId : st.index}"
                                                        data-search="<c:out value='${d.generatorCode} ${d.generatorName} ${d.brandName}'/>"
                                                        data-status="${po.status}">
                                                        <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                        <td><strong><c:out value="${d.generatorName}"/></strong></td>
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.proposedQuantity}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.currentStock}"/></td>
                                                        <td class="text-right mono"><strong><fmt:formatNumber value="${d.finalQuantity}"/></strong></td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/> ₫</c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice * d.finalQuantity}" pattern="#,##0"/> ₫</c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty po.details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="7" class="text-right" style="padding: 12px 14px;">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫
                                                </td>
                                                <td></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                            </div>

                            <div class="pagination">
                                <div class="info">
                                    Hiển thị <strong>1</strong> – <strong>${totalRows}</strong> của <strong>${totalRows}</strong> bản ghi
                                </div>
                                <div class="controls">
                                    <button class="page-btn" disabled>‹ Trước</button>
                                    <span class="page-btn active">1</span>
                                    <button class="page-btn" disabled>Sau ›</button>
                                </div>
                            </div>

                            <c:if test="${po.status == 'REJECTED' && not empty po.rejectReason}">
                                <div style="padding: 18px 20px;">
                                    <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do từ chối</div>
                                    <div class="danger-note"><c:out value="${po.rejectReason}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${po.status == 'CANCELLED' && not empty po.cancelReason}">
                                <div style="padding: 18px 20px;">
                                    <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do hủy</div>
                                    <div class="danger-note"><c:out value="${po.cancelReason}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty po.note}">
                                <div style="padding: 0 20px 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú PO</div>
                                    <div class="note-soft"><c:out value="${po.note}"/></div>
                                </div>
                            </c:if>
                        </div>

                    
                        <div class="tab-panel ${currentTab == 'proposals' ? 'active' : ''}" data-panel="proposals">
                            <div class="proposal-table-wrap">
                                <c:choose>
                                    <c:when test="${empty sourceProposals}">
                                        <div class="empty-state">
                                            <div class="icon-wrap">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                            </div>
                                            <strong>Không có phiếu đề xuất nào</strong>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="proposal-table">
                                            <thead>
                                                <tr>
                                                    <th>Phiếu đề xuất</th>
                                                    <th>Người tạo</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="sp" items="${sourceProposals}">
                                                    <c:set var="totalQty" value="0"/>
                                                    <c:forEach var="d" items="${sp.details}">
                                                        <c:set var="totalQty" value="${totalQty + d.quantity}"/>
                                                    </c:forEach>
                                                    <tr onclick="showProposalModal(this)"
                                                        data-proposal-id="${sp.proposalId}"
                                                        data-proposal-code="${sp.proposalCode}"
                                                        data-creator="${sp.createdByName}"
                                                        data-date="${sp.proposalDate.format(poDateFmt)}"
                                                        data-supplier="${sp.supplierName}"
                                                        data-status="${sp.status}"
                                                        data-total-details="${fn:length(sp.details)}"
                                                        data-total-qty="${totalQty}">
                                                        <td><button type="button" class="proposal-link">${sp.proposalCode}</button></td>
                                                        <td style="color:var(--muted);">${sp.createdByName}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                     
                        <div class="tab-panel ${currentTab == 'history' ? 'active' : ''}" data-panel="history">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}&amp;tab=history">xóa lọc</a></span>
                                                    </c:if>
                                                </div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="log" items="${logList}">
                                                <tr>
                                                    <td class="mono"><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td><strong><c:out value="${log.user}"/></strong></td>
                                                    <td>
                                                        <span class="action-badge action-<c:choose>
                                                            <c:when test="${log.action == 'CREATE'}">create</c:when>
                                                            <c:when test="${log.action == 'SEND_TO_CEO'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'CANCEL'}">cancel</c:when>
                                                            <c:otherwise>cancel</c:otherwise>
                                                        </c:choose>">
                                                        <c:out value="${log.actionLabel}"/>
                                                        </span>
                                                    </td>
                                                    <td style="max-width:480px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
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
                    </div>
                </main>
            </div>
        </div>

        
        <c:if test="${canApproveNow}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu mua</h3>
                    <div class="modal-sub">Phiếu mua sẽ chuyển sang trạng thái "Đã duyệt". Kho sẽ có thể tạo phiếu nhập từ phiếu mua này.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=approve">
                        <input type="hidden" name="id" value="${po.poId}"/>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRejectNow}">
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

        <div class="proposal-modal-backdrop" id="proposalModal" onclick="if (event.target === this) closeProposalModal();">
            <div class="proposal-modal" role="dialog" aria-modal="true">
                <div class="proposal-modal-header">
                    <h3>Thông tin phiếu đề xuất</h3>
                    <button type="button" class="proposal-modal-close" onclick="closeProposalModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="proposal-modal-body">
                    <div class="prow"><div class="lbl">Mã phiếu</div><div class="val mono" id="pm-code">—</div></div>
                    <div class="prow"><div class="lbl">Người tạo</div><div class="val" id="pm-creator">—</div></div>
                    <div class="prow"><div class="lbl">Ngày tạo</div><div class="val" id="pm-date">—</div></div>
                    <div class="prow"><div class="lbl">Nhà cung cấp</div><div class="val" id="pm-supplier">—</div></div>
                    <div class="prow"><div class="lbl">Trạng thái</div><div class="val" id="pm-status">—</div></div>
                    <div class="prow"><div class="lbl">Số dòng</div><div class="val" id="pm-details">—</div></div>
                    <div class="prow"><div class="lbl">Tổng SL</div><div class="val" id="pm-qty">—</div></div>
                </div>
                <div class="proposal-modal-footer">
                    <button type="button" class="btn" onclick="closeProposalModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="pm-detail-link" target="_blank">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

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
        <script>
            if (window.SESSION_DATA && window.SESSION_DATA.message) {
                if (typeof showToast === 'function') {
                    showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                } else if (typeof toast === 'function') {
                    toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
                } else {
                    alert(window.SESSION_DATA.message);
                }
                window.SESSION_DATA = null;
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-detail-modal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-detail-tabs.js"></script>
    </body>
</html>
