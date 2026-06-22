<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css?v=20260614b">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Chi tiết đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / <span>${liquidation.liquidationCode}</span></span>
            <div class="top-actions">
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="liq-head">
                <div class="liq-head-main">
                    <span class="code-copy mono" data-copy="${liquidation.liquidationCode}" title="Click để sao chép">
                        ${liquidation.liquidationCode}
                        <svg class="copy-icon" viewBox="0 0 24 24"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
                    </span>
                    <c:choose>
                        <c:when test="${liquidation.status == 'PENDING_MANAGER'}"><span class="pill liq-pending-mgr"><span class="pdot"></span>Chờ Quản lý duyệt</span></c:when>
                        <c:when test="${liquidation.status == 'PENDING_CEO'}"><span class="pill liq-pending-ceo"><span class="pdot"></span>Chờ Sếp duyệt</span></c:when>
                        <c:when test="${liquidation.status == 'APPROVED_BY_CEO'}"><span class="pill liq-pending-mgr"><span class="pdot"></span>Đã duyệt · chờ xuất kho</span></c:when>
                        <c:when test="${liquidation.status == 'COMPLETED'}"><span class="pill liq-approved"><span class="pdot"></span>Đã xuất kho</span></c:when>
                        <c:when test="${liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT'}"><span class="pill liq-edit"><span class="pdot"></span>Bị yêu cầu sửa</span></c:when>
                        <c:when test="${liquidation.status == 'REJECTED_BY_MANAGER' or liquidation.status == 'REJECTED_BY_CEO'}"><span class="pill liq-rejected"><span class="pdot"></span>Đã hủy</span></c:when>
                        <c:when test="${liquidation.status == 'CANCELLED'}"><span class="pill liq-rejected"><span class="pdot"></span>Đã huỷ đơn</span></c:when>
                    </c:choose>
                    <span class="liq-head-sep"></span>
                    <span class="liq-head-meta">${liquidation.createdByName} · <span class="mono">${liquidation.createdAt}</span></span>
                </div>
                <div class="liq-head-stats">
                    <span class="metric-chip"><span class="lbl">Số máy</span><span class="val"><c:out value="${empty liquidation.detailCount ? 0 : liquidation.detailCount}"/></span></span>
                    <span class="metric-chip"><span class="lbl">Giá gốc</span><span class="val"><c:choose><c:when test="${not empty liquidation.totalOriginalPrice}"><fmt:formatNumber value="${liquidation.totalOriginalPrice}" type="number" maxFractionDigits="0"/></c:when><c:otherwise>—</c:otherwise></c:choose></span></span>
                    <span class="metric-chip"><span class="lbl">Giá TL</span><span class="val"><c:choose><c:when test="${not empty liquidation.totalLiquidationPrice and liquidation.totalLiquidationPrice > 0}"><fmt:formatNumber value="${liquidation.totalLiquidationPrice}" type="number" maxFractionDigits="0"/></c:when><c:otherwise>—</c:otherwise></c:choose></span></span>
                    <c:if test="${not empty liquidation.totalOriginalPrice and not empty liquidation.totalLiquidationPrice and liquidation.totalOriginalPrice > 0 and liquidation.totalLiquidationPrice > 0}">
                        <c:set var="diffPct" value="${(liquidation.totalLiquidationPrice - liquidation.totalOriginalPrice) * 100 / liquidation.totalOriginalPrice}"/>
                        <span class="metric-chip ${diffPct >= 0 ? 'pos' : 'neg'}"><span class="lbl">Chênh</span><span class="val"><fmt:formatNumber value="${diffPct}" maxFractionDigits="1"/>%</span></span>
                    </c:if>
                </div>
            </div>

            <c:set var="st" value="${liquidation.status}"/>
            <c:set var="isCancelled" value="${st == 'REJECTED_BY_MANAGER' or st == 'REJECTED_BY_CEO' or st == 'CANCELLED'}"/>
            <c:set var="isMgrEdit" value="${st == 'MANAGER_REQUEST_EDIT'}"/>
            <c:set var="isCeoEdit" value="${st == 'CEO_REQUEST_EDIT'}"/>
            <c:set var="isApproved" value="${st == 'APPROVED_BY_CEO'}"/>
            <c:set var="isCompleted" value="${st == 'COMPLETED'}"/>
            <c:set var="isPendingMgr" value="${st == 'PENDING_MANAGER'}"/>
            <c:set var="isPendingCeo" value="${st == 'PENDING_CEO'}"/>

            <%-- Step "is-current" chỉ áp cho step xa nhất đã đạt được --%>
            <c:set var="step1Cls" value="is-done"/>
            <c:set var="step2Cls" value=""/>
            <c:set var="step3Cls" value=""/>
            <c:set var="step4Cls" value=""/>
            <c:set var="step5Cls" value=""/>
            <c:choose>
                <c:when test="${isCompleted}">
                    <c:set var="step2Cls" value="is-done"/>
                    <c:set var="step3Cls" value="is-done"/>
                    <c:set var="step4Cls" value="is-done"/>
                    <c:set var="step5Cls" value="is-current"/>
                </c:when>
                <c:when test="${isApproved}">
                    <c:set var="step2Cls" value="is-done"/>
                    <c:set var="step3Cls" value="is-done"/>
                    <c:set var="step4Cls" value="is-current"/>
                </c:when>
                <c:when test="${st == 'REJECTED_BY_CEO'}">
                    <c:set var="step2Cls" value="is-done"/>
                    <c:set var="step3Cls" value="is-rejected"/>
                </c:when>
                <c:when test="${isCeoEdit}">
                    <c:set var="step2Cls" value="is-done"/>
                    <c:set var="step3Cls" value="is-edit-requested"/>
                </c:when>
                <c:when test="${isPendingCeo}">
                    <c:set var="step2Cls" value="is-done"/>
                    <c:set var="step3Cls" value="is-current"/>
                </c:when>
                <c:when test="${st == 'REJECTED_BY_MANAGER'}">
                    <c:set var="step2Cls" value="is-rejected"/>
                </c:when>
                <c:when test="${st == 'CANCELLED'}">
                    <c:set var="step2Cls" value="is-rejected"/>
                </c:when>
                <c:when test="${isMgrEdit}">
                    <c:set var="step2Cls" value="is-edit-requested"/>
                </c:when>
                <c:when test="${isPendingMgr}">
                    <c:set var="step2Cls" value="is-current"/>
                </c:when>
                <c:otherwise>
                    <c:set var="step1Cls" value="is-current"/>
                </c:otherwise>
            </c:choose>

            <div class="liq-stepper">
                <div class="liq-step ${step1Cls}">
                    <div class="step-num"><span class="dot"></span>01</div>
                    <div class="step-title">Tạo đơn</div>
                    <div class="step-meta">${liquidation.createdByName}</div>
                </div>
                <div class="liq-step ${step2Cls}">
                    <div class="step-num"><span class="dot"></span>02</div>
                    <div class="step-title">QL duyệt giá</div>
                    <div class="step-meta">
                        <c:choose>
                            <c:when test="${isMgrEdit}">Yêu cầu sửa</c:when>
                            <c:when test="${st == 'REJECTED_BY_MANAGER'}">Đã từ chối</c:when>
                            <c:when test="${not empty liquidation.managerReviewedByName}">${liquidation.managerReviewedByName}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="liq-step ${step3Cls}">
                    <div class="step-num"><span class="dot"></span>03</div>
                    <div class="step-title">Sếp duyệt</div>
                    <div class="step-meta">
                        <c:choose>
                            <c:when test="${isCeoEdit}">Yêu cầu sửa</c:when>
                            <c:when test="${st == 'REJECTED_BY_CEO'}">Đã từ chối</c:when>
                            <c:when test="${isApproved or isCompleted}">Đã duyệt</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="liq-step ${step4Cls}">
                    <div class="step-num"><span class="dot"></span>04</div>
                    <div class="step-title">QL duyệt phiếu xuất</div>
                    <div class="step-meta">
                        <c:choose>
                            <c:when test="${isApproved}">Đang chờ duyệt</c:when>
                            <c:when test="${isCompleted}">Đã duyệt</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="liq-step ${step5Cls}">
                    <div class="step-num"><span class="dot"></span>05</div>
                    <div class="step-title">Đã xuất kho</div>
                    <div class="step-meta">
                        <c:choose>
                            <c:when test="${isCompleted}">Hoàn tất</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <c:if test="${liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'REJECTED_BY_CEO' or liquidation.status == 'CANCELLED'}">
                <c:if test="${not empty liquidation.ceoFeedbackName}">
                    <div class="feedback-banner feedback-banner--from-ceo">
                        <div class="body">
                            <div class="feedback-banner__label">Phản hồi từ Sếp (CEO)</div>
                            <div class="feedback-banner__body">${liquidation.ceoFeedbackName}</div>
                        </div>
                    </div>
                </c:if>
            </c:if>
            <c:if test="${liquidation.status == 'MANAGER_REQUEST_EDIT' or liquidation.status == 'REJECTED_BY_MANAGER' or liquidation.status == 'CANCELLED'}">
                <c:if test="${not empty liquidation.managerFeedbackName}">
                    <div class="feedback-banner feedback-banner--from-mgr">
                        <div class="body">
                            <div class="feedback-banner__label">Phản hồi từ Quản lý kho</div>
                            <div class="feedback-banner__body">${liquidation.managerFeedbackName}</div>
                        </div>
                    </div>
                </c:if>
            </c:if>

            <div class="tabs">
                <button type="button" class="tab active" onclick="switchTab('info')">Thông tin chi tiết</button>
                <button type="button" class="tab" onclick="switchTab('history')">Lịch sử xử lý (${totalHistory != null ? totalHistory : 0})</button>
            </div>

            <div id="tab-info" class="tab-panel active">
                <form action="${pageContext.request.contextPath}/liquidations" method="POST" id="mainForm">
                    <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />

                    <div class="liq-info-grid">
                        <div class="section liq-info-block">
                            <h3 class="liq-info-title">Thông tin đơn</h3>
                            <div class="kv-list">
                                <div class="kv-row">
                                    <div class="kv-key">Lý do thanh lý</div>
                                    <div class="kv-val">${liquidation.reasonName}</div>
                                </div>
                                <div class="kv-row">
                                    <div class="kv-key">Kho hàng</div>
                                    <div class="kv-val">${liquidation.warehouseName}</div>
                                </div>
                                <div class="kv-row">
                                    <div class="kv-key">Người tạo</div>
                                    <div class="kv-val">${liquidation.createdByName}</div>
                                </div>
                                <div class="kv-row">
                                    <div class="kv-key">Ngày tạo</div>
                                    <div class="kv-val mono">${liquidation.createdAt}</div>
                                </div>
                                <c:if test="${not empty liquidation.managerReviewedByName}">
                                    <div class="kv-row">
                                        <div class="kv-key">Quản lý duyệt</div>
                                        <div class="kv-val">${liquidation.managerReviewedByName}</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <div class="section liq-info-block">
                            <h3 class="liq-info-title">Khách hàng nhận</h3>
                            <c:choose>
                                <c:when test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')}">
                                    <p class="kv-hint">Vui lòng chọn hoặc thêm khách hàng để làm cơ sở tạo phiếu xuất.</p>
                                    <div id="managerCustomerArea">
                                        <input type="hidden" name="customerId" id="customerIdHidden" value="${liquidation.customerId}" required/>

                                        <div class="cust-search-wrap" id="custSearchWrap" style="${not empty liquidation.customerId ? 'display:none;' : ''}">
                                            <input type="text" id="custSearchInput" class="cust-search-input"
                                                   placeholder="Nhập tên hoặc số điện thoại..." autocomplete="off" />
                                            <div class="cust-dropdown" id="custDropdown"></div>
                                        </div>

                                        <div class="cust-card" id="custCard" style="${not empty liquidation.customerId ? '' : 'display:none;'}">
                                            <div class="cust-card-avatar" id="custCardAvatar">${not empty liquidation.customerName ? fn:substring(liquidation.customerName,0,1) : ''}</div>
                                            <div class="cust-card-body">
                                                <div class="cust-card-name" id="custCardName">${liquidation.customerName}</div>
                                                <div class="cust-card-rows">
                                                    <div class="cust-card-row">
                                                        <svg viewBox="0 0 24 24"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 4 4.18 2 2 0 0 1 6 2h2.09a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 23 17v-.08z"/></svg>
                                                        <span id="custCardPhone">${liquidation.customerPhone}</span>
                                                    </div>
                                                    <div class="cust-card-row" id="custCardEmailRow" style="${empty liquidation.customerEmail ? 'display:none;' : ''}">
                                                        <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,12 2,6"/></svg>
                                                        <span id="custCardEmail">${liquidation.customerEmail}</span>
                                                    </div>
                                                    <div class="cust-card-row" id="custCardAddrRow" style="${empty liquidation.customerAddress ? 'display:none;' : ''}">
                                                        <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                        <span id="custCardAddr">${liquidation.customerAddress}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <button type="button" class="cust-clear" onclick="clearCustomer()" title="Bỏ chọn">
                                                <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                            </button>
                                        </div>

                                        <button type="button" class="btn add-cust-btn" id="addNewCustBtn" onclick="openNewCustomerModal()" style="${not empty liquidation.customerId ? 'display:none;' : ''}">
                                            <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                                            Thêm khách hàng mới
                                        </button>
                                    </div>
                                </c:when>
                                <c:when test="${not empty liquidation.customerName}">
                                    <div class="cust-card cust-card--full">
                                        <div class="cust-card-avatar">${fn:substring(liquidation.customerName,0,1)}</div>
                                        <div class="cust-card-body">
                                            <div class="cust-card-name">${liquidation.customerName}</div>
                                            <div class="cust-card-rows">
                                                <c:if test="${not empty liquidation.customerPhone}">
                                                <div class="cust-card-row">
                                                    <svg viewBox="0 0 24 24"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 4 4.18 2 2 0 0 1 6 2h2.09a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 23 17v-.08z"/></svg>
                                                    ${liquidation.customerPhone}
                                                </div>
                                                </c:if>
                                                <c:if test="${not empty liquidation.customerEmail}">
                                                <div class="cust-card-row">
                                                    <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,12 2,6"/></svg>
                                                    ${liquidation.customerEmail}
                                                </div>
                                                </c:if>
                                                <c:if test="${not empty liquidation.customerAddress}">
                                                <div class="cust-card-row">
                                                    <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                    ${liquidation.customerAddress}
                                                </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="kv-hint">Chưa có khách hàng. Sẽ được Quản lý kho gán khi duyệt đơn.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="section liq-product-section">
                        <h3 class="liq-info-title">Danh sách máy phát điện</h3>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>Dòng máy</th>
                                    <th>Số Serial</th>
                                    <th>Giá gốc (VNĐ)</th>
                                    <th>Giá thanh lý (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${details}">
                                    <tr>
                                        <td><strong>${d.generatorModelName}</strong></td>
                                        <td class="mono">${d.serialNumber}</td>
                                        <td class="mono"><fmt:formatNumber value="${d.originalPrice}" type="number" maxFractionDigits="0"/></td>
                                        <td>
                                            <input type="hidden" name="detailId" value="${d.liquidationDetailId}" />
                                            <c:choose>
                                                <c:when test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')}">
                                                    <input type="number" class="liq-price-input" name="liquidationPrice" value="${d.liquidationPrice}" placeholder="Điền giá đề xuất..." required />
                                                </c:when>
                                                <c:otherwise>
                                                    <strong class="mono"><fmt:formatNumber value="${d.liquidationPrice}" type="number" maxFractionDigits="0"/></strong>
                                                    <input type="hidden" name="liquidationPrice" value="${d.liquidationPrice}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:set var="canCancel" value="${sessionScope.userPermissions.contains('liquidations.cancel') and sessionScope.loggedUser.id == liquidation.createdBy and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'PENDING_CEO' or liquidation.status == 'MANAGER_REQUEST_EDIT' or liquidation.status == 'CEO_REQUEST_EDIT')}"/>
                    <c:if test="${(isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')) or (isCeo and liquidation.status == 'PENDING_CEO') or (isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT') or canCancel}">
                        <div class="liq-action-bar">
                            <div class="hint">Hãy xem kỹ các chi tiết thiết bị và giá đề xuất ở phía trên trước khi ra quyết định.</div>
                            <c:if test="${isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT'}">
                                <a href="${pageContext.request.contextPath}/liquidations?action=edit_view&id=${liquidation.liquidationId}" class="btn btn-primary">Sửa đơn (Cập nhật lại)</a>
                            </c:if>
                            <c:if test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT')}">
                                <button type="submit" name="action" value="approve_manager" class="btn btn-primary">Lưu giá &amp; Gửi sếp duyệt</button>
                                <button type="button" class="btn btn-outline-warn" onclick="openFeedbackModal('request_edit_manager', 'Quản lý yêu cầu sửa', 'managerFeedbackId', 'btn-warn', 'select_manager_edit')">Yêu cầu sửa</button>
                                <button type="button" class="btn btn-outline-danger" onclick="openFeedbackModal('reject_manager', 'Từ chối đơn thanh lý', 'managerFeedbackId', 'btn-danger-solid', 'select_manager_reject')">Từ chối (Hủy đơn)</button>
                            </c:if>
                            <c:if test="${isCeo and liquidation.status == 'PENDING_CEO'}">
                                <button type="button" class="btn btn-success-solid" onclick="openConfirmApproveModal()">Duyệt &amp; Xuất Kho</button>
                                <button type="button" class="btn btn-outline-warn" onclick="openFeedbackModal('request_edit_ceo', 'Sếp yêu cầu sửa', 'ceoFeedbackId', 'btn-warn', 'select_ceo_edit')">Yêu cầu sửa</button>
                                <button type="button" class="btn btn-outline-danger" onclick="openFeedbackModal('reject_ceo', 'Từ chối đơn thanh lý', 'ceoFeedbackId', 'btn-danger-solid', 'select_ceo_reject')">Từ chối (Hủy đơn)</button>
                                <button type="submit" name="action" value="approve_ceo" id="hiddenApproveCeoBtn" style="display:none;"></button>
                            </c:if>
                            <c:if test="${canCancel}">
                                <button type="button" class="btn btn-outline-danger" onclick="openModal('confirmCancelModal')">Huỷ đơn</button>
                            </c:if>
                        </div>
                    </c:if>

                </form>
            </div> <!-- end tab-info -->

            <div id="tab-history" class="tab-panel">
                <div class="section" style="padding: 18px 22px;">
                    <c:if test="${empty liquidationHistory}">
                        <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">Chưa có lịch sử xử lý.</p>
                    </c:if>
                    <c:if test="${not empty liquidationHistory}">
                        <div class="history-toolbar">
                            <div class="history-search">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input type="text" id="historySearch" placeholder="Tìm theo người làm, ghi chú..." autocomplete="off"/>
                            </div>
                            <select id="historyFilter" class="history-filter">
                                <option value="">Tất cả hành động</option>
                                <option value="CREATE">Tạo đơn</option>
                                <option value="EDIT_SUBMIT">Đã sửa &amp; gửi lại</option>
                                <option value="MANAGER_APPROVE">Quản lý duyệt</option>
                                <option value="MANAGER_REQUEST_EDIT">Quản lý yêu cầu sửa</option>
                                <option value="REJECTED_BY_MANAGER">Quản lý từ chối</option>
                                <option value="CEO_APPROVE">Sếp duyệt</option>
                                <option value="CEO_REQUEST_EDIT">Sếp yêu cầu sửa</option>
                                <option value="REJECTED_BY_CEO">Sếp từ chối</option>
                                <option value="CANCELLED">Đã huỷ đơn</option>
                                <option value="EXPORT_APPROVE">Đã xuất kho</option>
                                <option value="AUTO_CREATE">Tự động tạo</option>
                            </select>
                            <span class="history-counter" id="historyCounter"></span>
                        </div>
                        <table class="history-table">
                            <thead>
                                <tr>
                                    <th class="col-time">Thời gian</th>
                                    <th class="col-action">Hành động</th>
                                    <th class="col-actor">Người làm</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody id="historyBody">
                                <c:forEach var="log" items="${liquidationHistory}">
                                    <c:set var="actLow">
                                        <c:choose>
                                            <c:when test="${log.action == 'MANAGER_APPROVE'}">approve_manager</c:when>
                                            <c:when test="${log.action == 'CEO_APPROVE'}">approve_ceo</c:when>
                                            <c:when test="${log.action == 'EXPORT_APPROVE'}">approve_ceo</c:when>
                                            <c:when test="${log.action == 'MANAGER_REQUEST_EDIT'}">request_edit_manager</c:when>
                                            <c:when test="${log.action == 'CEO_REQUEST_EDIT'}">request_edit_ceo</c:when>
                                            <c:when test="${log.action == 'REJECTED_BY_MANAGER'}">reject_manager</c:when>
                                            <c:when test="${log.action == 'REJECTED_BY_CEO'}">reject_ceo</c:when>
                                            <c:when test="${log.action == 'CANCELLED'}">reject_manager</c:when>
                                            <c:when test="${log.action == 'EDIT_SUBMIT'}">edit_submit</c:when>
                                            <c:when test="${log.action == 'CREATE' or log.action == 'AUTO_CREATE'}">create</c:when>
                                            <c:otherwise>muted</c:otherwise>
                                        </c:choose>
                                    </c:set>
                                    <tr data-action="${log.action}">
                                        <td class="col-time mono"><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM HH:mm" /></td>
                                        <td class="col-action">
                                            <span class="act-badge act-${actLow}">
                                                <c:choose>
                                                    <c:when test="${log.action == 'CREATE'}">Tạo đơn</c:when>
                                                    <c:when test="${log.action == 'AUTO_CREATE'}">Tự động tạo</c:when>
                                                    <c:when test="${log.action == 'MANAGER_APPROVE'}">Quản lý duyệt</c:when>
                                                    <c:when test="${log.action == 'MANAGER_REQUEST_EDIT'}">Quản lý yêu cầu sửa</c:when>
                                                    <c:when test="${log.action == 'REJECTED_BY_MANAGER'}">Quản lý từ chối</c:when>
                                                    <c:when test="${log.action == 'CEO_APPROVE'}">Sếp duyệt</c:when>
                                                    <c:when test="${log.action == 'CEO_REQUEST_EDIT'}">Sếp yêu cầu sửa</c:when>
                                                    <c:when test="${log.action == 'REJECTED_BY_CEO'}">Sếp từ chối</c:when>
                                                    <c:when test="${log.action == 'CANCELLED'}">Đã huỷ đơn</c:when>
                                                    <c:when test="${log.action == 'EDIT_SUBMIT'}">Đã sửa &amp; gửi lại</c:when>
                                                    <c:when test="${log.action == 'EXPORT_APPROVE'}">Đã xuất kho</c:when>
                                                    <c:otherwise>${log.action}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="col-actor">
                                            <span class="actor-name">${log.username}</span>
                                            <span class="actor-id">#${log.userId}</span>
                                        </td>
                                        <td class="col-details">${log.details}</td>
                                    </tr>
                                </c:forEach>
                                <tr id="historyEmptyRow" style="display:none;">
                                    <td colspan="4" style="text-align:center; color:var(--muted); padding:24px 12px; font-size:13px;">Không có kết quả phù hợp.</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="history-pager" id="historyPager"></div>
                    </c:if>
                </div>
            </div> <!-- end tab-history -->
        </main>
    </div>
</div>

<div class="modal-host" id="confirmApproveModal">
    <div class="modal">
        <h3>Xác nhận duyệt đơn</h3>
        <p>Bạn có chắc chắn muốn <strong>duyệt</strong> đơn thanh lý này và <strong>tạo Phiếu Xuất Kho</strong>? Hành động này không thể hoàn tác.</p>
        <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px;">
            <button type="button" class="btn" onclick="closeModal('confirmApproveModal')">Huỷ</button>
            <button type="button" class="btn btn-success-solid" onclick="document.getElementById('hiddenApproveCeoBtn').click();">Xác nhận duyệt &amp; xuất</button>
        </div>
    </div>
</div>

<div class="modal-host" id="confirmCancelModal">
    <div class="modal">
        <h3>Xác nhận huỷ đơn</h3>
        <p>Bạn có chắc chắn muốn <strong>huỷ</strong> đơn thanh lý này? Các máy đã chọn sẽ được trả lại kho và đơn sẽ bị đóng. Hành động này không thể hoàn tác.</p>
        <form method="POST" action="${pageContext.request.contextPath}/liquidations">
            <input type="hidden" name="action" value="cancel" />
            <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
            <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 8px;">
                <button type="button" class="btn" onclick="closeModal('confirmCancelModal')">Đóng</button>
                <button type="submit" class="btn btn-danger-solid">Xác nhận huỷ đơn</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-host" id="feedbackModal">
    <div class="modal modal-lg">
        <h3 id="feedbackModalTitle">Phản hồi</h3>
        <form method="POST" action="${pageContext.request.contextPath}/liquidations">
            <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
            <input type="hidden" name="action" id="feedbackModalAction" value="" />

            <select id="select_manager_reject" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_manager_edit" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_reject" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_edit" class="fb-select feedback-select" style="display:none;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>

            <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px;">
                <button type="button" class="btn" onclick="closeModal('feedbackModal')">Huỷ</button>
                <button type="submit" class="btn" id="feedbackModalSubmit">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<!-- New Customer Modal -->
<div class="modal-host" id="ncModalOverlay">
    <div class="modal modal-lg">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
            <h3 style="margin: 0;">Thêm khách hàng mới</h3>
            <button type="button" class="cust-clear" onclick="closeNewCustomerModal()" title="Đóng">
                <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>

        <div class="modal-error" id="ncError"></div>

        <div class="modal-grid">
            <div class="field span-2">
                <label class="field-label">Họ và tên <span class="req">*</span></label>
                <input type="text" id="ncName" class="input" placeholder="Nguyễn Văn A" />
            </div>
            <div class="field">
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input type="tel" id="ncPhone" class="input" placeholder="0901234567" />
            </div>
            <div class="field">
                <label class="field-label">Email</label>
                <input type="email" id="ncEmail" class="input" placeholder="email@example.com" />
            </div>
            <div class="field span-2">
                <label class="field-label">Địa chỉ</label>
                <input type="text" id="ncAddress" class="input" placeholder="Số nhà, đường, quận, tỉnh..." />
            </div>
            <div class="field">
                <label class="field-label">Tên công ty</label>
                <input type="text" id="ncCompanyName" class="input" placeholder="Công ty TNHH..." />
            </div>
            <div class="field">
                <label class="field-label">Loại khách hàng</label>
                <select id="ncTypeId" class="feedback-select" style="margin: 0;">
                    <option value="">-- Chọn loại --</option>
                    <c:forEach var="ct" items="${customerTypes}">
                        <option value="${ct.id}">${ct.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px;">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function openFeedbackModal(actionValue, title, paramName, btnClass, selectId) {
        document.getElementById('feedbackModalTitle').innerText = title;
        document.getElementById('feedbackModalAction').value = actionValue;
        document.getElementById('feedbackModalSubmit').className = 'btn ' + btnClass;

        document.querySelectorAll('.fb-select').forEach(function(el) {
            el.style.display = 'none';
            el.disabled = true;
            el.removeAttribute('name');
            el.removeAttribute('required');
        });

        var activeSelect = document.getElementById(selectId);
        activeSelect.style.display = 'block';
        activeSelect.disabled = false;
        activeSelect.name = paramName;
        activeSelect.required = true;

        openModal('feedbackModal');
    }

    function switchTab(tabId) {
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.tab').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabId).classList.add('active');
        var clickedTab = document.querySelector('.tab[onclick="switchTab(\'' + tabId + '\')"]');
        if (clickedTab) clickedTab.classList.add('active');
        if (tabId === 'history') applyHistoryFilter();
    }

    var HISTORY_PAGE_SIZE = 8;
    var historyState = { page: 1 };

    function getHistoryRows() {
        var body = document.getElementById('historyBody');
        if (!body) return [];
        return Array.from(body.querySelectorAll('tr[data-action]'));
    }

    function applyHistoryFilter() {
        var rows = getHistoryRows();
        if (rows.length === 0) return;
        var qInput = document.getElementById('historySearch');
        var fSel = document.getElementById('historyFilter');
        var q = qInput ? qInput.value.toLowerCase().trim() : '';
        var f = fSel ? fSel.value : '';

        var matched = [];
        rows.forEach(function(tr) {
            var act = tr.getAttribute('data-action') || '';
            var text = tr.innerText.toLowerCase();
            var ok = (!f || act === f) && (!q || text.indexOf(q) !== -1);
            tr.dataset.match = ok ? '1' : '0';
            if (ok) matched.push(tr);
        });

        var totalPages = Math.max(1, Math.ceil(matched.length / HISTORY_PAGE_SIZE));
        if (historyState.page > totalPages) historyState.page = totalPages;
        if (historyState.page < 1) historyState.page = 1;
        var start = (historyState.page - 1) * HISTORY_PAGE_SIZE;
        var end = start + HISTORY_PAGE_SIZE;

        rows.forEach(function(tr) { tr.style.display = 'none'; });
        matched.slice(start, end).forEach(function(tr) { tr.style.display = ''; });

        var emptyRow = document.getElementById('historyEmptyRow');
        if (emptyRow) emptyRow.style.display = matched.length === 0 ? '' : 'none';

        var counter = document.getElementById('historyCounter');
        if (counter) {
            if (matched.length === 0) counter.textContent = '';
            else counter.textContent = matched.length + ' kết quả';
        }

        renderHistoryPager(matched.length, totalPages);
    }

    function renderHistoryPager(total, totalPages) {
        var pager = document.getElementById('historyPager');
        if (!pager) return;
        if (total <= HISTORY_PAGE_SIZE) { pager.innerHTML = ''; return; }
        var html = '';
        var p = historyState.page;
        html += '<button type="button" class="page-btn" data-go="prev"' + (p <= 1 ? ' disabled' : '') + '>‹</button>';
        var winStart = Math.max(1, p - 2);
        var winEnd = Math.min(totalPages, p + 2);
        if (winStart > 1) {
            html += '<button type="button" class="page-btn" data-go="1">1</button>';
            if (winStart > 2) html += '<span class="ellipsis">…</span>';
        }
        for (var i = winStart; i <= winEnd; i++) {
            html += '<button type="button" class="page-btn ' + (i === p ? 'active' : '') + '" data-go="' + i + '">' + i + '</button>';
        }
        if (winEnd < totalPages) {
            if (winEnd < totalPages - 1) html += '<span class="ellipsis">…</span>';
            html += '<button type="button" class="page-btn" data-go="' + totalPages + '">' + totalPages + '</button>';
        }
        html += '<button type="button" class="page-btn" data-go="next"' + (p >= totalPages ? ' disabled' : '') + '>›</button>';
        pager.innerHTML = html;

        pager.querySelectorAll('button[data-go]').forEach(function(btn) {
            btn.addEventListener('click', function() {
                var go = btn.getAttribute('data-go');
                if (go === 'prev') historyState.page = Math.max(1, historyState.page - 1);
                else if (go === 'next') historyState.page = historyState.page + 1;
                else historyState.page = parseInt(go, 10);
                applyHistoryFilter();
            });
        });
    }

    (function initHistory() {
        var search = document.getElementById('historySearch');
        var filter = document.getElementById('historyFilter');
        if (search) search.addEventListener('input', function() { historyState.page = 1; applyHistoryFilter(); });
        if (filter) filter.addEventListener('change', function() { historyState.page = 1; applyHistoryFilter(); });
        applyHistoryFilter();
    })();
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }
    function openConfirmApproveModal() { openModal('confirmApproveModal'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-host.show').forEach(function(m) { m.classList.remove('show'); });
        }
    });

    var custSearchInput = document.getElementById('custSearchInput');
    if (custSearchInput) {
        var custSearchTimer = null;

        custSearchInput.addEventListener('input', function() {
            clearTimeout(custSearchTimer);
            var q = this.value.trim();
            if (q.length < 1) { hideCustDropdown(); return; }
            custSearchTimer = setTimeout(function() { searchCustomers(q); }, 280);
        });

        custSearchInput.addEventListener('focus', function() {
            var q = this.value.trim();
            if (q.length >= 1) searchCustomers(q);
        });

        document.addEventListener('click', function(e) {
            var wrap = document.getElementById('custSearchWrap');
            if (wrap && !wrap.contains(e.target)) {
                hideCustDropdown();
            }
        });
    }

    function searchCustomers(q) {
        fetch('${pageContext.request.contextPath}/liquidations?action=search_customer&q=' + encodeURIComponent(q))
            .then(function(r) { return r.json(); })
            .then(function(data) { renderCustDropdown(data); })
            .catch(function() { hideCustDropdown(); });
    }

    function renderCustDropdown(data) {
        var dd = document.getElementById('custDropdown');
        dd.innerHTML = '';
        if (!data || data.length === 0) {
            dd.innerHTML = '<div class="cust-dropdown-empty">Không tìm thấy khách hàng</div>';
            dd.classList.add('show');
            return;
        }
        data.forEach(function(c) {
            var div = document.createElement('div');
            div.className = 'cust-option';
            div.innerHTML = '<span class="cust-name">' + escHtml(c.name) + '</span>'
                + '<span class="cust-sub">' + escHtml(c.phone)
                + (c.companyName ? ' · ' + escHtml(c.companyName) : '') + '</span>';
            div.addEventListener('click', function() { selectCustomer(c); });
            dd.appendChild(div);
        });
        dd.classList.add('show');
    }

    function hideCustDropdown() {
        var dd = document.getElementById('custDropdown');
        if (dd) dd.classList.remove('show');
    }

    function selectCustomer(c) {
        document.getElementById('customerIdHidden').value = c.id;
        document.getElementById('custSearchInput').value = c.name;
        hideCustDropdown();
        showCustCard(c);
    }

    function showCustCard(c) {
        document.getElementById('custSearchWrap').style.display = 'none';
        document.getElementById('addNewCustBtn').style.display = 'none';

        document.getElementById('custCardAvatar').textContent = c.name.charAt(0).toUpperCase();
        document.getElementById('custCardName').textContent = c.name;
        document.getElementById('custCardPhone').textContent = c.phone;

        var emailRow = document.getElementById('custCardEmailRow');
        document.getElementById('custCardEmail').textContent = c.email || '';
        emailRow.style.display = c.email ? 'flex' : 'none';

        var addrRow = document.getElementById('custCardAddrRow');
        document.getElementById('custCardAddr').textContent = c.address || '';
        addrRow.style.display = c.address ? 'flex' : 'none';

        document.getElementById('custCard').style.display = 'flex';
    }

    function clearCustomer() {
        document.getElementById('customerIdHidden').value = '';
        document.getElementById('custSearchInput').value = '';
        document.getElementById('custCard').style.display = 'none';
        document.getElementById('custSearchWrap').style.display = 'block';
        document.getElementById('addNewCustBtn').style.display = 'inline-flex';
    }

    function openNewCustomerModal() {
        document.getElementById('ncName').value = '';
        document.getElementById('ncPhone').value = document.getElementById('custSearchInput').value;
        document.getElementById('ncEmail').value = '';
        document.getElementById('ncAddress').value = '';
        document.getElementById('ncCompanyName').value = '';
        document.getElementById('ncTypeId').selectedIndex = 0;
        hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }

    function closeNewCustomerModal() {
        document.getElementById('ncModalOverlay').classList.remove('show');
    }

    function showNcError(msg) {
        var el = document.getElementById('ncError');
        el.textContent = msg;
        el.classList.add('show');
    }
    function hideNcError() {
        document.getElementById('ncError').classList.remove('show');
    }

    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        if (!name) { showNcError('Vui lòng nhập họ tên.'); document.getElementById('ncName').focus(); return; }
        if (!phone) { showNcError('Vui lòng nhập số điện thoại.'); document.getElementById('ncPhone').focus(); return; }
        hideNcError();

        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';

        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', document.getElementById('ncEmail').value.trim());
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', document.getElementById('ncCompanyName').value.trim());
        fd.append('custTypeId', document.getElementById('ncTypeId').value);

        fetch('${pageContext.request.contextPath}/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    var c = {
                        id: data.id, name: data.name, phone: data.phone,
                        email: data.email, address: data.address, companyName: data.companyName
                    };
                    if (data.existing) {
                        showNcError('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                        setTimeout(function() {
                            closeNewCustomerModal();
                            selectCustomer(c);
                        }, 1500);
                    } else {
                        closeNewCustomerModal();
                        selectCustomer(c);
                    }
                } else {
                    showNcError(data.error || 'Lỗi không xác định');
                }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }

    function escHtml(str) {
        var d = document.createElement('div'); d.appendChild(document.createTextNode(str || '')); return d.innerHTML;
    }

    var mainForm = document.getElementById('mainForm');
    if (mainForm) {
        mainForm.addEventListener('submit', function(e) {
            var actionBtn = e.submitter;
            if (actionBtn && actionBtn.value === 'approve_manager') {
                var custId = document.getElementById('customerIdHidden').value;
                if (!custId) {
                    e.preventDefault();
                    alert('Vui lòng tìm và chọn Khách hàng hoặc Thêm mới trước khi gửi Sếp duyệt.');
                }
            }
        });
    }
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
