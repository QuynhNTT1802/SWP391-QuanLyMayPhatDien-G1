
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
        <title>Chi tiáº¿t Ä‘á» xuáº¥t nháº­p kho â€” Warehouse OS</title>
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
                    <h1>Chi tiáº¿t Ä‘á» xuáº¥t nháº­p kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal?action=list">Äá» xuáº¥t nháº­p kho</a> / <span><c:out value="${proposal.proposalCode}"/></span></span>
<div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M12 2.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
<c:choose>
                    <c:when test="${proposal.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chá» duyá»‡t"/>
                            <c:set var="statusPillClass" value="status-pending"/>
                        </c:when>
                        <c:when test="${proposal.status == 'PENDING_CEO'}">
                            <c:set var="statusLabel" value="Chá» CEO duyá»‡t"/>
                            <c:set var="statusPillClass" value="status-pending_ceo"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED' and not empty proposal.purchaseOrderId}">
                            <c:set var="statusLabel" value="ÄÃ£ duyá»‡t"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'APPROVED'}">
                            <c:set var="statusLabel" value="ÄÃ£ duyá»‡t"/>
                            <c:set var="statusPillClass" value="status-approved"/>
                        </c:when>
                        <c:when test="${proposal.status == 'REJECTED'}">
                            <c:set var="statusLabel" value="Tá»« chá»‘i"/>
                            <c:set var="statusPillClass" value="status-rejected"/>
                        </c:when>
                        <c:when test="${proposal.status == 'NEEDS_REVISION'}">
                            <c:set var="statusLabel" value="Cáº§n chá»‰nh sá»­a"/>
                            <c:set var="statusPillClass" value="status-revision"/>
                        </c:when>
                        <c:when test="${proposal.status == 'DELETED'}">
                            <c:set var="statusLabel" value="ÄÃ£ xoÃ¡"/>
                            <c:set var="statusPillClass" value="status-deleted"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="ÄÃ£ há»§y"/>
                            <c:set var="statusPillClass" value="status-cancelled"/>
                        </c:otherwise>
                    </c:choose>

                    <c:set var="canApprove" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.approve')}" />
                    <c:set var="canReject" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.reject')}" />
                    <c:set var="canCancelProp" value="${not empty sessionScope.userPermissions && sessionScope.userPermissions.contains('proposals.cancel')}" />
                    <c:set var="hasLockedPO" value="${not empty proposal.purchaseOrderId}" />


                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay láº¡i danh sÃ¡ch
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Phiáº¿u Ä‘á» xuáº¥t -</span>
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
                                    Chá»‰nh sá»­a
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gá»­i duyá»‡t láº¡i
                                </button>
                            </c:if>

                            <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && proposal.revisionRequestedByRole == 'CEO' && canApprove && !isViewingDeleted}">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Sá»­a Ä‘á» xuáº¥t (yÃªu cáº§u tá»« CEO)
                                </a>
                                <button type="button" class="btn btn-primary" onclick="openModal('resubmitModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                    Gá»­i duyá»‡t láº¡i
                                </button>
                            </c:if>

                            <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
                                <button type="button" class="btn btn-danger" onclick="openModal('deleteModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                    XoÃ¡
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canApprove && !isViewingDeleted}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    XÃ¡c nháº­n
                                </button>
                                <button type="button" class="btn btn-warn" onclick="openModal('revisionModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    YÃªu cáº§u chá»‰nh sá»­a
                                </button>
                            </c:if>

                            <c:if test="${proposal.status == 'PENDING' && canReject && !isViewingDeleted}">
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Tá»« chá»‘i
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
                                    <span>ÄÃ£ gom vÃ o <strong>Phiáº¿u mua</strong>: <strong><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${proposal.purchaseOrderId}" style="font-family: 'JetBrains Mono', monospace; color: var(--accent); text-decoration: none; font-weight: 700;" title="Xem chi tiáº¿t phiáº¿u mua">${proposal.poCode}</a></strong>. Phiáº¿u nÃ y bá»‹ khÃ³a sá»­a.</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <svg viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                                    <span>ÄÃ£ gom vÃ o <strong>Phiáº¿u mua</strong> (<strong style="font-family: 'JetBrains Mono', monospace; color: var(--muted);"><c:out value="${proposal.poCode}"/></strong>). Phiáº¿u nÃ y bá»‹ khÃ³a sá»­a.</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <c:set var="showDeadlineBanner" value="${not empty proposal.period}" />
                    <c:if test="${isViewingDeleted}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24" width="20" height="20"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                            <span>
                                <strong>Phiáº¿u nÃ y Ä‘Ã£ bá»‹ xoÃ¡.</strong>
                                <c:choose>
                                    <c:when test="${not empty proposal.cancelledAt}">
                                        ÄÃ£ xoÃ¡ lÃºc <strong style="font-family:'JetBrains Mono',monospace;">${proposal.cancelledAt.format(propFmt)}</strong>.
                                    </c:when>
                                </c:choose>
                                Phiáº¿u Ä‘Ã£ Ä‘Æ°á»£c áº©n khá»i danh sÃ¡ch chung, chá»‰ báº¡n (ngÆ°á»i táº¡o) cÃ³ thá»ƒ xem láº¡i á»Ÿ cháº¿ Ä‘á»™ chá»‰ Ä‘á»c.
                            </span>
                        </div>
                    </c:if>
                    <c:if test="${showDeadlineBanner}">
                        <div class="alert ${isWithinDeadline ? 'alert-info' : 'alert-warn'}">
                            <svg viewBox="0 0 24 24" width="20" height="20"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            <span>
                                <strong>Deadline gom Ä‘Æ¡n / duyá»‡t cho period ${proposal.period}:</strong>
                                <c:choose>
                                    <c:when test="${isWithinDeadline}">
                                        cÃ²n hiá»‡u lá»±c Ä‘áº¿n <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>
                                        (5 ngÃ y Ä‘áº§u thÃ¡ng káº¿ tiáº¿p).
                                    </c:when>
                                    <c:otherwise>
                                        Ä‘Ã£ <strong style="color:var(--danger);">quÃ¡ háº¡n</strong> tá»«
                                        <strong style="font-family:'JetBrains Mono',monospace;">${deadlineDate}</strong>.
                                        CÃ¡c thao tÃ¡c duyá»‡t/tá»« chá»‘i/yÃªu cáº§u chá»‰nh sá»­a Ä‘Ã£ bá»‹ khÃ³a.
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>


                    <div class="section">
                        <div class="section-head">
                            <h3>ThÃ´ng tin chung</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>MÃ£ phiáº¿u Ä‘á» xuáº¥t</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>TÃªn phiáº¿u Ä‘á» xuáº¥t</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${proposal.proposalCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>NgÃ y Ä‘á» xuáº¥t</label>
                                    <input class="info-input" type="date" disabled value="${proposalDateInput}">
                                </div>
                                <div class="info-field">
                                    <label>Tá»•ng sá»‘ lÆ°á»£ng mÃ¡y</label>
                                    <input class="info-input mono" type="number" disabled value="${totalQty}">
                                </div>
                                <div class="info-field">
                                    <label>Tá»•ng kinh phÃ­ dá»± kiáº¿n (VNÄ)</label>
                                    <input class="info-input mono" type="text" disabled value="<fmt:formatNumber value='${grandTotal}' pattern='#,##0'/> â‚«">
                                </div>
                            </div>
                            <div class="form-grid cols-4" style="margin-top: 14px;">
                                <div class="info-field with-info-icon">
                                    <label>CÃ¡n bá»™ Ä‘áº§u má»‘i láº­p phiáº¿u</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${proposal.createdByName}"/></option>
                                    </select>
                                    <span class="info-icon" title="NgÆ°á»i táº¡o phiáº¿u Ä‘á» xuáº¥t">i</span>
                                </div>
                                <div class="info-field">
                                    <label>Kho Ä‘á» xuáº¥t nháº­p</label>
                                    <select class="info-select" disabled>
                                        <option selected><c:out value="${not empty proposal.warehouseName ? proposal.warehouseName : 'â€”'}"/></option>
                                    </select>
                                </div>
                                <div class="info-field">
                                    <label>NgÆ°á»i xÃ¡c nháº­n</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${not empty proposal.approvedByName ? proposal.approvedByName : ""}'/>">
                                </div>
                                <div class="info-field">
                                    <label>NgÃ y xÃ¡c nháº­n</label>
                                    <input class="info-input" type="datetime-local" disabled value="${approvedAtInput}">
                                </div>
                            </div>
                        </div>
                    </div>

      
                    <div class="section">
                        <div class="section-head">
                            <h3>Danh sÃ¡ch mÃ¡y phÃ¡t Ä‘Äƒng kÃ½</h3>
                        </div>

                        <div class="tab-bar">
                            <a href="#" class="tab ${currentTab != 'history' ? 'active' : ''}" data-tab="generators">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                MÃ¡y phÃ¡t Ä‘iá»‡n Ä‘Äƒng kÃ½
                            </a>
                            <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}" data-tab="history">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lá»‹ch sá»­ cáº­p nháº­t
                                <span class="tab-badge">${totalHistory}</span>
                            </a>
                        </div>


                        <div class="tab-panel ${currentTab != 'history' ? 'active' : ''}" data-panel="generators">
                            <div class="table-toolbar">
                                <div class="search-input">
                                    <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    <input id="genSearch" placeholder="TÃ¬m kiáº¿m thÃ´ng tin..." autocomplete="off"/>
                                </div>
                                <div class="spacer"></div>
                                <button type="button" class="btn" title="Xuáº¥t file (Ä‘ang phÃ¡t triá»ƒn)">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    Xuáº¥t file
                                </button>
                            </div>

                            <div style="overflow-x:auto;">
                                <table class="product-table" id="genTable">
                                    <thead>
                                        <tr>
                                            <th>MÃ£ mÃ¡y phÃ¡t</th>
                                            <th>TÃªn mÃ¡y phÃ¡t</th>
                                            <th>HÃ£ng</th>
                                            <th>CÃ´ng suáº¥t</th>
                                            <th class="text-right">SL</th>
                                            <th class="text-right">ÄÆ¡n giÃ¡</th>
                                            <th class="text-right">ThÃ nh tiá»n</th>
                                            <th>NhÃ  cung cáº¥p</th>
                                            <th>LÃ½ do chá»‰nh sá»­a/tá»« chá»‘i</th>
                                            <th>Tráº¡ng thÃ¡i</th>
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
                                                        <strong>ChÆ°a cÃ³ mÃ¡y phÃ¡t nÃ o trong phiáº¿u Ä‘á» xuáº¥t</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr data-row-id="${d.proposalDetailId}"
                                                        data-search="<c:out value='${d.generatorCode} ${d.generatorName} ${d.brandName} ${d.supplierName}'/>"
                                                        data-status="${proposal.status}">
                                                        <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                        <td><strong><c:out value="${d.generatorName}"/></strong></td>
                                                        <td><c:out value="${d.brandName}"/></td>
                                                        <td class="mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.powerRating}"><c:out value="${d.powerRating}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">â€”</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                        <td class="text-right mono">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">â€”</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right mono" style="font-weight:600;">
                                                            <c:choose>
                                                                <c:when test="${not empty d.unitPrice}"><fmt:formatNumber value="${d.unitPrice * d.quantity}" pattern="#,##0"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">â€”</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.supplierName}"><c:out value="${d.supplierName}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">â€”</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty d.note}"><c:out value="${d.note}"/></c:when>
                                                                <c:otherwise><span style="color:var(--muted);">â€”</span></c:otherwise>
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
                                                <td colspan="6" class="text-right" style="padding: 12px 14px;">Tá»•ng cá»™ng:</td>
                                                <td class="text-right mono" style="padding: 12px 14px; color: var(--accent);">
                                                    <fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> â‚«
                                                </td>
                                                <td colspan="3"></td>
                                            </tr>
                                        </tfoot>
                                    </c:if>
                                </table>
                            </div>

                            <div class="pagination">
                                <div class="info">
                                    Hiá»ƒn thá»‹ <strong>1</strong> â€“ <strong>${totalRows}</strong> cá»§a <strong>${totalRows}</strong> báº£n ghi
                                </div>
                                <div class="controls">
                                    <button class="page-btn" disabled>â€¹ TrÆ°á»›c</button>
                                    <span class="page-btn active">1</span>
                                    <button class="page-btn" disabled>Sau â€º</button>
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
                                    <input name="logSearch" value="${logSearch}" placeholder="TÃ¬m ngÆ°á»i dÃ¹ng, chi tiáº¿t..." autocomplete="off"/>
                                </div>
                                <select name="logAction" class="filter-select">
                                    <option value="" ${empty logAction ? 'selected' : ''}>Táº¥t cáº£ hÃ nh Ä‘á»™ng</option>
                                    <option value="CREATE"     ${logAction == 'CREATE' ? 'selected' : ''}>Táº¡o phiáº¿u</option>
                                    <option value="UPDATE"     ${logAction == 'UPDATE' ? 'selected' : ''}>Cáº­p nháº­t</option>
                                    <option value="APPROVE"    ${logAction == 'APPROVE' ? 'selected' : ''}>Duyá»‡t</option>
                                    <option value="REJECT"     ${logAction == 'REJECT' ? 'selected' : ''}>Tá»« chá»‘i</option>
                                    <option value="REVISION"   ${logAction == 'REVISION' ? 'selected' : ''}>YÃªu cáº§u chá»‰nh sá»­a</option>
                                    
                                </select>
                                <div class="date-range">
                                    <label class="date-label">Tá»«</label>
                                    <input type="date" name="dateFrom" value="${dateFrom}" class="date-input"/>
                                    <label class="date-label">Ä‘áº¿n</label>
                                    <input type="date" name="dateTo"   value="${dateTo}"   class="date-input"/>
                                </div>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                    Ãp dá»¥ng
                                </button>
                                <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                    <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history" class="btn">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                        XÃ³a lá»c
                                    </a>
                                </c:if>
                            </form>

                            <div class="result-summary">
                                TÃ¬m tháº¥y <strong>${totalLogs}</strong> báº£n ghi
                                <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                    &nbsp;â€”&nbsp;<span class="filter-active-badge">Bá»™ lá»c Ä‘ang hoáº¡t Ä‘á»™ng</span>
                                </c:if>
                            </div>

                            <table class="product-table">
                                <thead>
                                    <tr>
                                        <th style="width:170px;">Thá»i gian</th>
                                        <th style="width:200px;">NgÆ°á»i thá»±c hiá»‡n</th>
                                        <th style="width:170px;">HÃ nh Ä‘á»™ng</th>
                                        <th>Chi tiáº¿t thay Ä‘á»•i</th>
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
                                                    <strong>KhÃ´ng cÃ³ báº£n ghi nÃ o</strong>
                                                    <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                        <span style="color:var(--muted);font-size:0.88rem;">Thá»­ Ä‘iá»u chá»‰nh bá»™ lá»c hoáº·c <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}&amp;tab=history">xÃ³a lá»c</a></span>
                                                    </c:if>
                                                </div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="h" items="${logList}">
                                                <tr>
                                                    <td class="mono">
                                                        <c:choose>
                                                            <c:when test="${h.createdAt == null}">â€”</c:when>
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
                                                            <c:when test="${h.action == 'CREATE'}">Táº¡o phiáº¿u</c:when>
                                                            <c:when test="${h.action == 'UPDATE'}">Cáº­p nháº­t</c:when>
                                                            <c:when test="${h.action == 'APPROVE'}">Duyá»‡t</c:when>
                                                            <c:when test="${h.action == 'REJECT'}">Tá»« chá»‘i</c:when>
                                                            <c:when test="${h.action == 'REVISION'}">YÃªu cáº§u sá»­a</c:when>
                                                            
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
                                <div class="info">Hiá»ƒn thá»‹ <strong>${(logPage-1)*20 + 1}</strong>â€“<strong>${logPage*20 > totalLogs ? totalLogs : logPage*20}</strong> / <strong>${totalLogs}</strong> báº£n ghi</div>
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
                    <h3>YÃªu cáº§u chá»‰nh sá»­a</h3>
                    <div class="modal-sub">Gá»­i phiáº¿u láº¡i cho nhÃ¢n viÃªn táº¡o Ä‘á» xuáº¥t kÃ¨m lÃ½ do Ä‘á»ƒ chá»‰nh sá»­a vÃ  gá»­i láº¡i.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=revision" id="revisionForm">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <label>LÃ½ do yÃªu cáº§u chá»‰nh sá»­a <span style="color:var(--danger)">*</span></label>
                        <textarea name="revisionReason" id="revisionReason" required placeholder="MÃ´ táº£ chi tiáº¿t pháº§n cáº§n chá»‰nh sá»­a..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huá»·</button>
                            <button type="submit" class="btn btn-warn">Gá»­i yÃªu cáº§u</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyá»‡t phiáº¿u Ä‘á» xuáº¥t</h3>
                    <div class="modal-sub">Phiáº¿u Ä‘á» xuáº¥t sáº½ chuyá»ƒn sang tráº¡ng thÃ¡i "ÄÃ£ duyá»‡t" vÃ  cÃ³ thá»ƒ Ä‘Æ°á»£c gom vÃ o phiáº¿u mua.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">ÄÃ³ng</button>
                            <button type="submit" class="btn btn-primary">XÃ¡c nháº­n duyá»‡t</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && canReject}">
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Tá»« chá»‘i</h3>
                    <div class="modal-sub">Phiáº¿u sáº½ bá»‹ tá»« chá»‘i vÃ  khÃ´ng thá»ƒ hoÃ n tÃ¡c.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=reject">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <label for="rejectReason">LÃ½ do tá»« chá»‘i <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="rejectReason" required placeholder="VÃ­ dá»¥: Sá»‘ lÆ°á»£ng vÆ°á»£t nhu cáº§u, mÃ¡y chÆ°a cÃ³ trong kho..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huá»·</button>
                            <button type="submit" class="btn btn-danger">XÃ¡c nháº­n tá»« chá»‘i</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${proposal.status == 'PENDING' && canCancelProp}">
            <div class="modal-host" id="cancelModal">
                <div class="modal-card">
                    <h3>Huá»· phiáº¿u Ä‘á» xuáº¥t</h3>
                    <div class="modal-sub">Phiáº¿u Ä‘á» xuáº¥t sáº½ bá»‹ huá»·. HÃ nh Ä‘á»™ng nÃ y khÃ´ng thá»ƒ hoÃ n tÃ¡c.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('cancelModal')">ÄÃ³ng</button>
                            <button type="submit" class="btn btn-danger">XÃ¡c nháº­n huá»·</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${!hasLockedPO && proposal.status == 'PENDING' && isOwner && !isViewingDeleted}">
            <div class="modal-host" id="deleteModal">
                <div class="modal-card">
                    <h3>XoÃ¡ phiáº¿u Ä‘á» xuáº¥t</h3>
                    <div class="modal-sub">Phiáº¿u sáº½ Ä‘Æ°á»£c chuyá»ƒn sang tráº¡ng thÃ¡i <strong>ÄÃ£ xoÃ¡</strong> vÃ  áº©n khá»i danh sÃ¡ch chung. Báº¡n váº«n cÃ³ thá»ƒ xem láº¡i á»Ÿ cháº¿ Ä‘á»™ chá»‰ Ä‘á»c.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('deleteModal')">ÄÃ³ng</button>
                            <button type="submit" class="btn btn-danger">XÃ¡c nháº­n xoÃ¡</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${!hasLockedPO && proposal.status == 'NEEDS_REVISION' && !isViewingDeleted && (isOwner || (proposal.revisionRequestedByRole == 'CEO' && canApprove))}">
            <div class="modal-host" id="resubmitModal">
                <div class="modal-card">
                    <h3>Gá»­i duyá»‡t láº¡i</h3>
                    <div class="modal-sub">Phiáº¿u sáº½ chuyá»ƒn sang tráº¡ng thÃ¡i "Chá» duyá»‡t" Ä‘á»ƒ Sale Manager xem xÃ©t láº¡i sau khi Ä‘Ã£ chá»‰nh sá»­a.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                        <input type="hidden" name="submitType" value="submit" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('resubmitModal')">ÄÃ³ng</button>
                            <button type="submit" class="btn btn-primary">Gá»­i duyá»‡t láº¡i</button>
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
