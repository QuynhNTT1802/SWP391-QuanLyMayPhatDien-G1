<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __ordFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    java.time.format.DateTimeFormatter __ordDateFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
    java.time.format.DateTimeFormatter __ordDtFmt = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    request.setAttribute("ordFmt", __ordFmt);
    request.setAttribute("ordDateFmt", __ordDateFmt);
    request.setAttribute("ordDtFmt", __ordDtFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-detail.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết đơn hàng</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / <span><c:out value="${order.orderCode}"/></span></span>
                    <div class="top-actions">
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
                    <c:choose>
                        <c:when test="${order.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusPillClass" value="status-pending"/>
                        </c:when>
                        <c:when test="${order.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${order.status == 'COMPLETED'}">
                            <c:set var="statusLabel" value="Hoàn thành"/>
                            <c:set var="statusPillClass" value="status-completed"/>
                        </c:when>
                        <c:when test="${order.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:when test="${order.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Yêu cầu chỉnh sửa"/>
                            <c:set var="statusPillClass" value="status-revision"/>
                        </c:when>
                        <c:when test="${order.status == 'DELETED'}">
                            <c:set var="statusLabel" value="Đã xoá"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApproveNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canRejectNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canRevisionNow" value="${order.status == 'PENDING' && canApproveOrder}" />
                    <c:set var="canDeleteNow" value="${order.status == 'PENDING' && isOwner}" />
                    <c:set var="canEditNow" value="${order.status == 'NEEDS_REVISION' && isOwner}" />

                   
                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại danh sách
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Đơn hàng -</span>
                                <span><c:out value="${order.orderCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${order.orderCode}"/>
                                <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                            </h2>
                        </div>
                        <div class="right">

                            <c:if test="${canEditNow}">
                                <a class="btn btn-primary" href="${pageContext.request.contextPath}/order?action=edit&id=${order.orderId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Chỉnh sửa
                                </a>
                            </c:if>

                            <c:if test="${canApproveNow}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Xác nhận
                                </button>
                            </c:if>
                            <c:if test="${canRevisionNow}">
                                <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Yêu cầu chỉnh sửa
                                </button>
                            </c:if>
                            <c:if test="${canRejectNow}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>
                            <c:if test="${canDeleteNow}">
                                <button type="button" class="btn btn-danger" onclick="openModal('deleteModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                                    Xoá
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
                                    <label>Mã đơn hàng</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${order.orderCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tên đơn hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${order.orderCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày đặt</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatDate value='${order.orderDate}' pattern='dd/MM/yyyy HH:mm'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tổng số lượng máy</label>
                                    <input class="info-input mono" type="number" disabled value="${totalQty}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng kinh phí (VNĐ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${order.totalAmount}' pattern='#,##0'/> ₫">
                                </div>
                            </div>
                            <div class="form-grid cols-4" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>Khách hàng</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${not empty order.customer.name ? order.customer.name : '—'}"/></option>
                                    </select>
                                    <span class="info-icon" title="Khách hàng đặt đơn">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Số điện thoại</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${not empty order.customer.phone ? order.customer.phone : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Loại khách hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty customerTypeName ? customerTypeName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Địa chỉ giao hàng</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.customer.address ? order.customer.address : "—"}'/>">
                                </div>
                            </div>
                            <div class="form-grid cols-2" style="margin-top: 14px;">
                                <div class="info-field">
                                    <label>Email</label>
                                    <input class="info-input mono" type="email" disabled value="<c:out value='${not empty order.customer.email ? order.customer.email : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Công ty</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.customer.companyName ? order.customer.companyName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Người tạo</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty order.createdByName ? order.createdByName : "—"}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Người duyệt</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${order.approvedBy != 0 && not empty order.approvedByName ? order.approvedByName : "—"}'/>">
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="section">
                        <div class="section-head">
                            <h3>Danh sách máy phát đăng ký</h3>
                        </div>

                        <div class="tab-bar">
                            <a href="#" class="tab ${currentTab != 'history' ? 'active' : ''}" data-tab="generators">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                Sản phẩm đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <span class="tab-badge">${totalLogs}</span>
                            </a>
                        </div>

                        
                        <div class="tab-panel ${currentTab != 'history' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="ordSearch" placeholder="Tìm kiếm thông tin..." autocomplete="off"/>
                                </div>

                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="ordTable">
                                    <thead>
                                        <tr>
                                            
                                            <th>Mã máy</th>
                                            <th class="text-right">Số lượng</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                            <th>Ghi chú</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty details}">
                                                <tr><td colspan="7">
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
                                                    <tr data-row-id="${st.index}"
                                                        data-search="<c:out value='${d.generatorId} ${d.generatorModel}'/>"
                                                        data-status="${order.status}">
                                                        
                                                        <td><strong><a href="javascript:void(0);" class="gen-link"
                                                               onclick="showGeneratorModal(this)"
                                                               data-gen-id="${d.generatorId}"
                                                               data-gen-model="<c:out value='${d.generatorModel}'/>"
                                                               data-gen-power="<c:out value='${d.generatorPower}'/>"
                                                               data-gen-freq="<c:out value='${d.generatorFreq}'/>"
                                                               data-gen-weight="<c:out value='${d.generatorWeight}'/>"
                                                               data-gen-status="<c:out value='${d.generatorStatus}'/>"><c:out value="${d.generatorModel}"/></a></strong></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/> ₫</td>
                                                        <td class="text-right mono" style="font-weight:600;"><fmt:formatNumber value="${d.quantity * d.unitPrice}" pattern="#,##0"/> ₫</td>
                                                        <td><c:out value="${d.note}"/></td>
                                                        <td>
                                                            <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <c:if test="${not empty details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="4" class="text-right" style="padding: 12px 14px;">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> ₫
                                                </td>
                                                <td colspan="2"></td>
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

                            <c:choose>
                                <c:when test="${order.status == 'REJECTED' && not empty order.rejectReason}">
                                    <div style="padding: 18px 20px;">
                                        <div class="info-label" style="font-size:11px;color:var(--danger);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Lý do từ chối</div>
                                        <div class="danger-note"><c:out value="${order.rejectReason}"/></div>
                                    </div>
                                </c:when>
                                <c:when test="${order.status == 'NEEDS_REVISION' && not empty order.revisionReason}">
                                    <div style="padding: 18px 20px;">
                                        <div class="revision-reason">
                                            <div class="rr-label">Lý do yêu cầu chỉnh sửa</div>
                                            <div class="rr-body"><c:out value="${order.revisionReason}"/></div>
                                        </div>
                                    </div>
                                </c:when>
                            </c:choose>
                            <c:if test="${not empty order.note}">
                                <div style="padding: 0 20px 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú nội bộ</div>
                                    <div class="note-soft"><c:out value="${order.note}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty order.customerNote}">
                                <div style="padding: 0 20px 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú của khách hàng</div>
                                    <div class="note-soft"><c:out value="${order.customerNote}"/></div>
                                </div>
                            </c:if>
                        </div>

                        
                        <div class="tab-panel ${currentTab == 'history' ? 'active' : ''}" data-panel="history">
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
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}&amp;tab=history">xóa lọc</a></span>
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
                                                            <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${log.action == 'REJECT'}">reject</c:when>
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
                    </div>
                </main>
            </div>
        </div>

        <c:if test="${canApproveNow}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt đơn hàng</h3>
                    <div class="modal-sub">Đơn hàng sẽ chuyển sang trạng thái "Đã duyệt". Vui lòng kiểm tra tồn kho trước khi xác nhận.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=approve">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canDeleteNow}">
            <div class="modal-host" id="deleteModal">
                <div class="modal-card">
                    <h3>Xoá đơn hàng</h3>
                    <div class="modal-sub">Đơn sẽ bị xoá khỏi danh sách của Quản lý Bán hàng. Bạn vẫn có thể xem lại trong danh sách của mình.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=delete">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('deleteModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận xoá</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRejectNow}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối đơn hàng</h3>
                    <div class="modal-sub">Đơn hàng sẽ bị huỷ. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=reject">
                        <input type="hidden" name="orderId" value="${order.orderId}" />
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="rejectReason" required placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, thông tin chưa hợp lệ..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRevisionNow}">
            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub">Gửi đơn hàng lại cho nhân viên tạo đơn kèm lý do để chỉnh sửa và gửi lại.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=requestRevision" id="revisionForm">
                        <input type="hidden" name="id" value="${order.orderId}" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="reason" id="revisionReason" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        

        <div class="gen-modal-backdrop" id="generatorModal" onclick="if (event.target === this) closeGeneratorModal();">
            <div class="gen-modal" role="dialog" aria-modal="true">
                <div class="gen-modal-header">
                    <h3>Thông tin máy phát</h3>
                    <button type="button" class="gen-modal-close" onclick="closeGeneratorModal()">&times;</button>
                </div>
                <div class="gen-modal-body">
                    <div class="gen-info-row">
                        <div class="lbl">Mã máy</div>
                        <div class="val" id="gm-id">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Model</div>
                        <div class="val" id="gm-model">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Công suất</div>
                        <div class="val" id="gm-power">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Tần số</div>
                        <div class="val" id="gm-freq">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Trọng lượng</div>
                        <div class="val" id="gm-weight">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Trạng thái</div>
                        <div class="val" id="gm-status">—</div>
                    </div>
                </div>
                <div class="gen-modal-footer">
                    <button type="button" class="btn" onclick="closeGeneratorModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="gm-detail-link">
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
        </script>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/order-detail.js"></script>
    </body>
</html>