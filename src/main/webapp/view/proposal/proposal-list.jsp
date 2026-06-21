<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
        <title>Quản lý đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-pending {
                background: #fff3cd;
                color: #856404;
            }
            .status-approved {
                background: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background: #f8d7da;
                color: #721c24;
            }
            .status-revision {
                background: #ede9fe;
                color: #5b21b6;
            }
            .status-cancelled {
                background: #e2e3e5;
                color: #383d41;
            }
            .status-draft {
                background: #e2e3e5;
                color: #383d41;
            }
            .status-pending_ceo {
                background: #fff3cd;
                color: #856404;
            }
            .order-code {
                font-family: 'JetBrains Mono', monospace;
                font-size: 13px;
                color: var(--muted);
            }
            .col-status {
                white-space: nowrap;
                width: 130px;
            }
            .col-actions {
                white-space: nowrap;
            }
            .col-check { width: 36px; text-align: center; }
            .row-check { cursor: pointer; }
            .row-check:disabled { cursor: not-allowed; opacity: 0.4; }
            .row-check:disabled:checked { background: var(--muted-2); border-color: var(--muted-2); }
            #groupBtn { display: none; }
            #groupBtn.show { display: inline-flex; }
            .dropdown { position: relative; display: inline-block; }
            .dropdown-btn {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 4px 10px;
                border: 1px solid var(--border);
                border-radius: 4px;
                background: var(--surface);
                color: var(--fg);
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all .12s ease;
                font-family: inherit;
                white-space: nowrap;
            }
            .dropdown-btn:hover {
                border-color: var(--accent);
                color: var(--accent);
            }
            .dropdown-btn .arrow {
                transition: transform .2s ease;
                margin-left: 2px;
                font-size: 10px;
            }
            .dropdown-btn.open .arrow {
                transform: rotate(180deg);
            }
            .dropdown-menu {
                position: fixed;
                z-index: 999;
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 6px;
                box-shadow: 0 4px 20px rgba(0,0,0,.12);
                padding: 4px;
                min-width: 190px;
                opacity: 0;
                visibility: hidden;
                transform: translateY(-4px);
                transition: all .15s ease;
                pointer-events: none;
            }
            .dropdown-menu.open {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
                pointer-events: auto;
            }
            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 7px 10px;
                border: none;
                border-radius: 4px;
                background: transparent;
                color: var(--fg);
                font-size: 12.5px;
                font-weight: 500;
                cursor: pointer;
                width: 100%;
                text-align: left;
                font-family: inherit;
                text-decoration: none;
                transition: background .1s ease;
                box-sizing: border-box;
                white-space: nowrap;
            }
            .dropdown-item:hover {
                background: var(--surface-2);
            }
            .dropdown-item svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                flex-shrink: 0;
            }
            .dropdown-item .label { flex: 1; }
            .dropdown-item.approve svg { stroke: #155724; }
            .dropdown-item.reject svg { stroke: #721c24; }
            .dropdown-item.revision svg { stroke: #b15c00; }
            .dropdown-item.cancel svg { stroke: var(--muted); }
            .dropdown-item.danger svg { stroke: var(--danger); }
            .dropdown-divider {
                height: 1px;
                background: var(--border);
                margin: 3px 0;
            }
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
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Kinh doanh</a> / Đề xuất nhập kho</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <c:if test="${canCreateProposal}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/proposal?action=create">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                Tạo phiếu đề xuất
                            </a>
                        </c:if>
                        <c:if test="${canCreatePo}">
                            <button type="button" id="groupBtn" class="btn btn-primary" onclick="document.getElementById('reviewForm').submit();">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z"/></svg>
                                Gom và Tổng hợp (<span id="tickedCount">0</span>)
                            </button>
                        </c:if>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Đề xuất nhập kho</div>
                            <h2 class="page-title">Quản lý phiếu đề xuất nhập kho</h2>
                            <div class="page-sub">${totalProposals} phiếu đề xuất</div>
                        </div>
                    </div>

                    <div class="stats-row">
                        <c:if test="${!canApproveProposal}">
                            <div class="stat"><div class="lbl">Nháp</div><div class="val">${draftCount}</div></div>
                        </c:if>
                        <div class="stat"><div class="lbl">Chờ duyệt</div><div class="val">${pendingCount}</div></div>
                        <div class="stat"><div class="lbl">Đã duyệt</div><div class="val">${approvedCount}</div></div>
                        <div class="stat"><div class="lbl">Từ chối</div><div class="val">${rejectedCount}</div></div>
                        <div class="stat"><div class="lbl">Đã hủy</div><div class="val">${cancelledCount}</div></div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.toastMessage}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/proposal" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value="${search}"/>" placeholder="Tìm theo mã phiếu hoặc ghi chú" autocomplete="off" />
                        </div>

                        <input type="date" class="filter-select" name="dateFrom" value="${dateFrom}"
                               title="Từ ngày" onchange="this.form.submit()" />
                        <input type="date" class="filter-select" name="dateTo" value="${dateTo}"
                               title="Đến ngày" onchange="this.form.submit()" />

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <c:if test="${!canApproveProposal}">
                                <option value="DRAFT" <c:if test="${statusFilter == 'DRAFT'}">selected</c:if>>Nháp</option>
                            </c:if>
                            <option value="PENDING"   <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="PENDING_CEO" <c:if test="${statusFilter == 'PENDING_CEO'}">selected</c:if>>Chờ CEO duyệt</option>
                            <option value="APPROVED"  <c:if test="${statusFilter == 'APPROVED'}">selected</c:if>>Đã duyệt</option>
                            <option value="REJECTED"  <c:if test="${statusFilter == 'REJECTED'}">selected</c:if>>Từ chối</option>
                            <option value="NEEDS_REVISION" <c:if test="${statusFilter == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa</option>
                            <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/proposal?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <form id="reviewForm" method="post" action="${pageContext.request.contextPath}/purchase-order?action=reviewCreate">
                        <table class="users" id="proposalsTable">
                            <thead>
                                <tr>
                                    <c:if test="${canCreatePo}">
                                        <th class="col-check"><input type="checkbox" class="checkbox" id="selectAll" title="Chọn tất cả"/></th>
                                    </c:if>
                                    <th>Mã phiếu</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Tháng</th>
                                    <th>Kho</th>
                                    <th>Phiếu mua</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="proposalsBody">
                                <c:choose>
                                    <c:when test="${empty proposals}">
                                        <tr><td colspan="${canCreatePo ? 9 : 8}" style="text-align:center; padding:20px; color:var(--muted);">Chưa có phiếu đề xuất nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="p" items="${proposals}" varStatus="loop">
                                            <tr data-id="${p.proposalId}">
                                                <c:if test="${canCreatePo}">
                                                    <td class="col-check">
                                                        <c:set var="canTick" value="${p.status == 'APPROVED' && empty p.poCode}"/>
                                                        <input type="checkbox" class="checkbox row-check" name="proposalIds" value="${p.proposalId}" data-period="${p.period}" data-warehouse="${p.warehouseId}" <c:if test="${!canTick}">disabled</c:if>/>
                                                    </td>
                                                </c:if>
                                                <td>
                                                    <div class="order-code"><c:out value="${p.proposalCode}"/></div>
                                                </td>
                                                <td><c:out value="${p.createdByName}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.proposalDate == null}">—</c:when>
                                                        <c:otherwise>${p.proposalDate.format(propFmt)}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong><c:out value="${p.period}"/></strong></td>
                                                <td><c:out value="${p.warehouseName}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty p.poCode}">
                                                            <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${p.purchaseOrderId}" class="po-link" style="font-family: 'JetBrains Mono', monospace; font-size: 12px; color: var(--accent);"><c:out value="${p.poCode}"/></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--muted); font-size: 12px;">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Nháp</span></c:when>
                                                        <c:when test="${p.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${p.status == 'PENDING_CEO'}"><span class="status-pill status-pending_ceo"><span class="pdot"></span>Chờ CEO duyệt</span></c:when>
                                                        <c:when test="${p.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                        <c:when test="${p.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                                        <c:when test="${p.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Cần chỉnh sửa</span></c:when>
                                                        <c:when test="${p.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${p.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-actions">
                                                    <div class="dropdown">
                                                        <button class="dropdown-btn" onclick="toggleDropdown(this)" type="button">
                                                            Hành động <span class="arrow">▾</span>
                                                        </button>
                                                        <div class="dropdown-menu">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/proposal?action=detail&id=${p.proposalId}">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                                <span class="label">Chi tiết</span>
                                                            </a>

                                                            <c:if test="${empty p.purchaseOrderId}">
                                                                <c:if test="${p.status == 'DRAFT' && currentUserId == p.createdBy}">
                                                                    <div class="dropdown-divider"></div>
                                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/proposal?action=edit&id=${p.proposalId}">
                                                                        <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                                        <span class="label">Chỉnh sửa</span>
                                                                    </a>
                                                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${p.proposalId}" />
                                                                        <input type="hidden" name="submitType" value="submit" />
                                                                        <button type="submit" class="dropdown-item approve" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                                                            <span class="label">Gửi duyệt</span>
                                                                        </button>
                                                                    </form>
                                                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${p.proposalId}" />
                                                                        <button type="submit" class="dropdown-item danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/></svg>
                                                                            <span class="label">Xoá</span>
                                                                        </button>
                                                                    </form>
                                                                </c:if>

                                                                <c:if test="${p.status == 'NEEDS_REVISION' && currentUserId == p.createdBy}">
                                                                    <div class="dropdown-divider"></div>
                                                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/proposal?action=edit&id=${p.proposalId}">
                                                                        <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                                        <span class="label">Chỉnh sửa</span>
                                                                    </a>
                                                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${p.proposalId}" />
                                                                        <input type="hidden" name="submitType" value="submit" />
                                                                        <button type="submit" class="dropdown-item approve" onclick="return confirm('Xác nhận gửi duyệt lại?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                                                            <span class="label">Gửi duyệt lại</span>
                                                                        </button>
                                                                    </form>
                                                                </c:if>

                                                                <c:if test="${p.status == 'PENDING' && canApproveProposal}">
                                                                    <div class="dropdown-divider"></div>
                                                                    <button class="dropdown-item approve" onclick="openApproveModal(${p.proposalId}, '<c:out value="${fn:escapeXml(p.proposalCode)}"/>')" type="button">
                                                                        <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                                                        <span class="label">Duyệt</span>
                                                                    </button>
                                                                    <div class="dropdown-divider"></div>
                                                                    <button class="dropdown-item revision" onclick="openRevisionModal(${p.proposalId}, '<c:out value="${fn:escapeXml(p.proposalCode)}"/>')" type="button">
                                                                        <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                                        <span class="label">Yêu cầu chỉnh sửa</span>
                                                                    </button>
                                                                </c:if>

                                                                <c:if test="${p.status == 'PENDING' && canRejectProposal}">
                                                                    <div class="dropdown-divider"></div>
                                                                    <button class="dropdown-item reject" onclick="openRejectModal(${p.proposalId}, '<c:out value="${fn:escapeXml(p.proposalCode)}"/>')" type="button">
                                                                        <svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                                                        <span class="label">Từ chối</span>
                                                                    </button>
                                                                </c:if>

                                                                <c:if test="${p.status == 'PENDING' && canCancelProposal}">
                                                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${p.proposalId}" />
                                                                        <div class="dropdown-divider"></div>
                                                                        <button type="submit" class="dropdown-item cancel" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                                                            <span class="label">Huỷ phiếu</span>
                                                                        </button>
                                                                    </form>
                                                                </c:if>

                                                                <c:if test="${p.status == 'APPROVED' && canCancelProposal}">
                                                                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${p.proposalId}" />
                                                                        <div class="dropdown-divider"></div>
                                                                        <button type="submit" class="dropdown-item cancel" onclick="return confirm('Xác nhận huỷ phiếu đề xuất đã duyệt?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                                                            <span class="label">Huỷ phiếu</span>
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </form>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${currentPage * 10 > totalProposals ? totalProposals : currentPage * 10}</strong> / <strong>${totalProposals}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <c:if test="${canApproveProposal || canRejectProposal}">
            <div class="modal-host" id="approveModalList">
                <div class="modal-card">
                    <h3>Duyệt phiếu đề xuất</h3>
                    <div class="modal-sub" id="approveModalSub">Xác nhận duyệt phiếu đề xuất?</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve">
                        <input type="hidden" name="id" id="approveProposalId" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-primary" onclick="return confirmApproveAction()">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canRejectProposal}">
            <div class="modal-host" id="rejectModalList">
                <div class="modal-card">
                    <h3>Từ chối phiếu đề xuất</h3>
                    <div class="modal-sub" id="rejectModalSub">Phiếu sẽ bị từ chối và không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=reject">
                        <input type="hidden" name="id" id="rejectProposalId" />
                        <label for="rejectReasonList">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReasonList" name="rejectReason" required placeholder="Ví dụ: Số lượng vượt nhu cầu, máy chưa có trong kho..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${canApproveProposal}">
            <div class="modal-host" id="revisionModalList">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub" id="revisionModalSub">Gửi phiếu lại cho nhân viên chỉnh sửa.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/proposal?action=revision">
                        <input type="hidden" name="id" id="revisionProposalId" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="revisionReason" id="revisionReasonList" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            function openApproveModal(id, code) {
                var el = document.getElementById('approveProposalId');
                if (el) el.value = id;
                var sub = document.getElementById('approveModalSub');
                if (sub) sub.innerHTML = 'Xác nhận duyệt phiếu đề xuất <strong>' + code + '</strong>?';
                openModal('approveModalList');
            }
            function openRejectModal(id, code) {
                var el = document.getElementById('rejectProposalId');
                if (el) el.value = id;
                var sub = document.getElementById('rejectModalSub');
                if (sub) sub.innerHTML = 'Từ chối phiếu đề xuất <strong>' + code + '</strong>? Hành động này không thể hoàn tác.';
                var reason = document.getElementById('rejectReasonList');
                if (reason) reason.value = '';
                openModal('rejectModalList');
            }
            function openRevisionModal(id, code) {
                var el = document.getElementById('revisionProposalId');
                if (el) el.value = id;
                var sub = document.getElementById('revisionModalSub');
                if (sub) sub.innerHTML = 'Gửi phiếu <strong>' + code + '</strong> lại cho nhân viên chỉnh sửa.';
                var reason = document.getElementById('revisionReasonList');
                if (reason) reason.value = '';
                openModal('revisionModalList');
            }

            function openModal(id) {
                var m = document.getElementById(id);
                if (m) m.classList.add('show');
            }
            function closeModal(id) {
                var m = document.getElementById(id);
                if (m) m.classList.remove('show');
            }
            document.querySelectorAll('.modal-host').forEach(function (m) {
                m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
                }
            });

            function confirmApproveAction() {
                return confirm('Bạn có chắc muốn duyệt phiếu đề xuất này?');
            }

            function toggleDropdown(btn) {
                var menu = btn.nextElementSibling;
                var isOpen = menu.classList.contains('open');
                document.querySelectorAll('.dropdown-menu.open').forEach(function (m) {
                    if (m !== menu) {
                        m.classList.remove('open');
                        if (m.previousElementSibling) m.previousElementSibling.classList.remove('open');
                    }
                });
                if (isOpen) {
                    menu.classList.remove('open');
                    btn.classList.remove('open');
                    return;
                }
                var rect = btn.getBoundingClientRect();
                menu.style.top = (rect.bottom + 4) + 'px';
                menu.style.left = rect.left + 'px';
                menu.style.minWidth = Math.max(190, rect.width) + 'px';
                menu.classList.add('open');
                btn.classList.add('open');
            }
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu.open').forEach(function (m) {
                        m.classList.remove('open');
                    });
                    document.querySelectorAll('.dropdown-btn.open').forEach(function (b) {
                        b.classList.remove('open');
                    });
                }
            });

            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    } else {
                        alert(window.SESSION_DATA.message);
                    }
                }

                const selectAll = document.getElementById('selectAll');
                const rowChecks = document.querySelectorAll('.row-check:not(:disabled)');
                const groupBtn = document.getElementById('groupBtn');
                const tickedCountEl = document.getElementById('tickedCount');
                const reviewForm = document.getElementById('reviewForm');

                function updateCount() {
                    const ticked = document.querySelectorAll('.row-check:checked').length;
                    tickedCountEl.textContent = ticked;
                    if (groupBtn) {
                        if (ticked > 0) {
                            groupBtn.classList.add('show');
                        } else {
                            groupBtn.classList.remove('show');
                        }
                    }
                    if (selectAll) {
                        const enabledCount = rowChecks.length;
                        selectAll.checked = enabledCount > 0 && ticked === enabledCount;
                        selectAll.indeterminate = ticked > 0 && ticked < enabledCount;
                    }
                }

                if (selectAll) {
                    selectAll.addEventListener('change', function () {
                        rowChecks.forEach(function (cb) {
                            cb.checked = selectAll.checked;
                        });
                        updateCount();
                    });
                }

                rowChecks.forEach(function (cb) {
                    cb.addEventListener('change', updateCount);
                });

                if (reviewForm) {
                    reviewForm.addEventListener('submit', function (e) {
                        const ticked = document.querySelectorAll('.row-check:checked');
                        if (ticked.length === 0) {
                            e.preventDefault();
                            alert('Vui lòng chọn ít nhất 1 phiếu đề xuất');
                            return;
                        }
                        const firstPeriod = ticked[0].getAttribute('data-period');
                        const firstWarehouse = ticked[0].getAttribute('data-warehouse');
                        const firstLabel = ticked[0].closest('tr').querySelector('.order-code').textContent.trim();
                        for (let i = 1; i < ticked.length; i++) {
                            const p = ticked[i].getAttribute('data-period');
                            const w = ticked[i].getAttribute('data-warehouse');
                            if (p !== firstPeriod || w !== firstWarehouse) {
                                e.preventDefault();
                                const lbl = ticked[i].closest('tr').querySelector('.order-code').textContent.trim();
                                alert('Không thể gom các phiếu khác tháng hoặc khác kho.\n\n'
                                        + 'Phiếu gốc: ' + firstLabel + ' (tháng ' + firstPeriod + ')\n'
                                        + 'Phiếu khác: ' + lbl + ' (tháng ' + p + ')');
                                return;
                            }
                        }
                    });
                }
            });
        </script>
    </body>
</html>
