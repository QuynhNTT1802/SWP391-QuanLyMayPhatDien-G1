
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/proposal-detail.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal?action=list">Đề xuất nhập kho</a> / <span><c:out value="${proposal.proposalCode}"/></span></span>
<div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M12 2.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
<c:choose>
                    <c:when test="${proposal.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                            <c:set var="statusPillClass" value="status-pending"/>
                        </c:when>
                        <c:when test="${proposal.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chờ CEO duyệt"/>
                            <c:set var="statusPillClass" value="status-pending_ceo"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED' and not empty proposal.purchaseOrderId}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="Đã duyệt"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Từ chối"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:when test="${proposal.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Cần chỉnh sửa"/>
                            <c:set var="statusPillClass" value="status-revision"/>
                        </c:when>
                        <c:when test="${proposal.status == 'DELETED'}">
                            <c:set var="statusLabel" value="Đã xoá"/>
                            <c:set var="statusPillClass" value="status-deleted"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="Đã hủy"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApprove" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.approve')}" />
                    <c:set var="canReject" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.reject')}" />
                    <c:set var="hasLockedPO" value="${not empty proposal.purchaseOrderId}" />


                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại danh sách
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Phiếu đề xuất -</span>
                                <span><c:out value="${proposal.proposalCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${proposal.proposalCode}"/>
                                <span class="status-pill ${statusPillClass}"><span class="pdot"></span>${statusLabel}</span>
                            </h2>
                        </div>
                        <div class="right">


                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && isOwner && !isViewingDeleted}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Chỉnh sửa
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gửi duyệt lại
                                </button>
                            </c:if>

                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && proposal.revisionRequestedByRole == 'CEO' && canApprove && !isViewingDeleted}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Sửa đề xuất (yêu cầu từ CEO)
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gửi duyệt lại
                                </button>
                            </c:if>

                            <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
                                <button type="button" class="btn btn-danger" onclick="openModal('deleteModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                    Xoá
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canApprove && !isViewingDeleted}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Xác nhận
                                </button>
                                <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Yêu cầu chỉnh sửa
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canReject && !isViewingDeleted}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
                                </button>
                            </c:if>

                         
                        </div>
                    </div>

                    <c:set var="canViewPoDetail" value="${canViewPo or (not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('purchase_orders.view'))}" />
                    <c:if test="${not empty proposal.purchaseOrderId}">
                        <c:choose>
                            <c:when test="${canViewPoDetail}">
                                <div class="alert alert-info">
                                    <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                    <span>Đã gom vào <strong>Phiếu mua</strong>: <strong><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${proposal.purchaseOrderId}" style="font-family: 'JetBrains Mono', monospace; color: var(--accent); text-decoration: none; font-weight: 700;" title="Xem chi tiết phiếu mua">${proposal.poCode}</a></strong>. Phiếu này bị khóa sửa.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                    <span>Đã gom vào <strong>Phiếu mua</strong> (<strong style="font-family: 'JetBrains Mono', monospace; color: var(--muted);"><c:out value="${proposal.poCode}"/></strong>). Phiếu này bị khóa sửa.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <c:set var="showDeadlineBanner" value="${not empty proposal.period}" />
                    <c:if test="${isViewingDeleted}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                            <span>
                                <strong>Phiếu này đã bị xoá.</strong>
                                <c:choose>
                                    <c:when test="${not empty proposal.cancelledAt}">
                                        Đã xoá lúc <strong style="font-family:'JetBrains Mono',monospace;">${proposal.cancelledAt.format(propFmt)}</strong>.
                                    </c:when>
                                </c:choose>
                                Phiếu đã được ẩn khỏi danh sách chung, chỉ bạn (người tạo) có thể xem lại ở chế độ chỉ đọc.
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${showDeadlineBanner}">
                        <div class="alert ${isWithinDeadline ? 'alert-info' : 'alert-warn'}">
                            <svg viewBox="0 0 24 24" width="20" height="20"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <span>
                                <strong>Hạn chót gom đơn / duyệt cho kỳ ${proposal.period}:</strong>
                                <c:choose>
                                    <c:when test="${isWithinDeadline}">
                                        còn hiệu lực đến <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>
                                        (5 ngày đầu tháng kế tiếp).
                                    </c:when>
                                    <c:otherwise>
                                        đã <strong style="color:var(--danger);">quá hạn</strong> từ
                                        <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>.
                                        Các thao tác duyệt/từ chối/yêu cầu chỉnh sửa đã bị khóa.
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>


                    <div class="section">
                        <div class="section-head">
                            <h3>Thông tin chung</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Mã phiếu đề xuất</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Tên phiếu đề xuất</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày đề xuất</label>
                                    <input class="info-input" type="date" disabled value="${proposalDateInput}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng số lượng máy</label>
                                    <input class="info-input mono" type="number" disabled value="${totalQty}">
                                </div>
                                <div class="info-field">
                                    <label>Tổng kinh phí dự kiến (VNĐ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${grandTotal}' pattern='#,##0'/> ₫">
                                </div>
                            </div>
                            <div class="form-grid cols-4" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>Cán bộ đầu mối lập phiếu</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${proposal.createdByName}"/></option>
                                    </select>
                                    <span class="info-icon" title="Người tạo phiếu đề xuất">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Kho đề xuất nhập</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${not empty proposal.warehouseName ? proposal.warehouseName : '—'}"/></option>
                                    </select>
                                </div>
                                <div class="info-field">
                                    <label>Người xác nhận</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty proposal.approvedByName ? proposal.approvedByName : ""}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Ngày xác nhận</label>
                                    <input class="info-input" type="datetime-local" disabled value="${approvedAtInput}">
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
                                Máy phát điện đăng ký
                            </a>
                            <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <span class="tab-badge">${totalHistory}</span>
                            </a>
                        </div>


                        <div class="tab-panel ${currentTab != 'history' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="genSearch" placeholder="Tìm kiếm thông tin..." autocomplete="off"/>
                                </div>

                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="genTable">
                                    <thead>
                                        <tr>
                                            <th>Mã máy phát</th>
                                            
                                            <th>Hãng</th>
                                            <th>Công suất</th>
                                            <th class="text-right">SL</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                            <th>Nhà cung cấp</th>
                                            <th>Lý do chỉnh sửa/từ chối</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty proposal.details}">
                                                <tr><td colspan="10">
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
                                                    <tr data-row-id="${d.proposalDetailId}"
                                                        data-search="<c:out value='${d.generatorCode} ${d.generatorName} ${d.brandName} ${d.supplierName}'/>"
                                                        data-status="${proposal.status}">
                                                        <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                        
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td class="mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.powerRating}"><c:out value="${d.powerRating}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice * d.quantity}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.supplierName}"><c:out value="${d.supplierName}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.note}"><c:out value="${d.note}"/></c:when>
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
                                    <c:if test="${not empty proposal.details}">
                                        <tfoot>
                                            <tr>
                                                <td colspan="6" class="text-right" style="padding: 12px 14px;">Tổng cộng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> ₫
                                                </td>
                                                <td colspan="3"></td>
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
                        </div>


                        <div class="tab-panel ${currentTab == 'history' ? 'active' : ''}" data-panel="history">
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
                    </div>
                </main>
            </div>
        </div>

 
        <c:if test="${proposal.status == 'PENDING' && canApprove}">
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

            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu đề xuất sẽ chuyển sang trạng thái "Đã duyệt" và có thể được gom vào phiếu mua.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && canReject}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối</h3>
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

        <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
            <div class="modal-host" id="deleteModal">
                <div class="modal-card">
                    <h3>Xoá phiếu đề xuất</h3>
                    <div class="modal-sub">Phiếu sẽ được chuyển sang trạng thái <strong>Đã xoá</strong> và ẩn khỏi danh sách chung. Bạn vẫn có thể xem lại ở chế độ chỉ đọc.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('deleteModal')">Đóng</button>
                            <button type="submit" class="btn btn-danger">Xác nhận xoá</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && !isViewingDeleted && (isOwner || (proposal.revisionRequestedByRole == 'CEO' && canApprove))}">
            <div class="modal-host" id="resubmitModal">
                <div class="modal-card">
                    <h3>Gửi duyệt lại</h3>
                    <div class="modal-sub">Phiếu sẽ chuyển sang trạng thái "Chờ duyệt" để Quản lý Bán hàng xem xét lại sau khi đã chỉnh sửa.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <input type="hidden" name="submitType" value="submit" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('resubmitModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Gửi duyệt lại</button>
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
        <script src="${pageContext.request.contextPath}/assets/js/proposal-detail.js"></script>
    </body>
</html>