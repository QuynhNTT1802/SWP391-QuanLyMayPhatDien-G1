<%-- 
    Document   : order-list
    Created on : May 26, 2026
--%>

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
        <title>Quản lý đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            /* Bổ sung thêm style đặc thù cho Order nếu cần, nhưng ưu tiên dùng class có sẵn */
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
            .status-cancelled {
                background: #e2e3e5;
                color: #383d41;
            }
            .amount-cell {
                font-weight: 600;
                color: var(--accent);
            }
            .order-code {
                font-family: 'JetBrains Mono', monospace;
                font-size: 13px;
                color: var(--muted);
            }
            .col-creator {
                white-space: nowrap;
                width: 100px;
            }
            .col-actions { white-space: nowrap; }
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
                min-width: 170px;
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
            .col-status {
                white-space: nowrap;
                width: 110px;
            }
            .col-address {
                max-width: 160px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .col-actions {
                white-space: nowrap;
            }
            .table-card {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
            .user-name.customer-link {
                cursor: pointer;
                color: var(--accent);
                text-decoration: none;
            }
            .user-name.customer-link:hover {
                text-decoration: underline;
            }
            .customer-modal-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,.45);
                z-index: 1000;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .customer-modal-backdrop.open {
                display: flex;
            }
            .customer-modal {
                background: var(--surface);
                border-radius: 8px;
                width: 100%;
                max-width: 480px;
                box-shadow: 0 10px 40px rgba(0,0,0,.25);
                overflow: hidden;
                animation: modalPop .18s ease-out;
            }
            @keyframes modalPop {
                from { transform: scale(.96); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
            }
            .customer-modal-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 18px;
                border-bottom: 1px solid var(--border);
            }
            .customer-modal-header h3 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
            }
            .customer-modal-close {
                background: transparent;
                border: none;
                font-size: 22px;
                line-height: 1;
                cursor: pointer;
                color: var(--muted);
                padding: 0 4px;
            }
            .customer-modal-close:hover { color: var(--fg); }
            .customer-modal-body {
                padding: 16px 18px;
            }
            .cust-info-row {
                display: flex;
                gap: 10px;
                padding: 8px 0;
                border-bottom: 1px dashed var(--border);
                font-size: 13.5px;
            }
            .cust-info-row:last-child { border-bottom: none; }
            .cust-info-row .lbl {
                flex: 0 0 110px;
                color: var(--muted);
                font-weight: 500;
            }
            .cust-info-row .val {
                flex: 1;
                color: var(--fg);
                word-break: break-word;
            }
            .customer-modal-footer {
                padding: 12px 18px;
                border-top: 1px solid var(--border);
                display: flex;
                justify-content: flex-end;
                gap: 8px;
                background: var(--surface-2);
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Đơn hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/order">Kinh doanh</a> / Đơn hàng</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <c:if test="${canCreateOrder}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/order?action=create">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                Tạo đơn hàng
                            </a>
                        </c:if>

                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Đơn hàng</div>
                            <h2 class="page-title">Quản lý đơn hàng</h2>
                            <div class="page-sub">${totalOrders} đơn hàng</div>
                        </div>
                    </div>

                    <div class="stats-row">
                        <div class="stat"><div class="lbl">Chờ duyệt</div><div class="val">${pendingCount}</div></div>
                        <div class="stat"><div class="lbl">Đã duyệt</div><div class="val">${approvedCount}</div></div>
                        <div class="stat"><div class="lbl">Từ chối</div><div class="val">${rejectedCount}</div></div>
                        <div class="stat"><div class="lbl">Đã hủy</div><div class="val">${cancelledCount}</div></div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {
                            message: '<c:out value="${sessionScope.message}"/>',
                            type: '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>'
                        };
                            <c:remove var="message" scope="session"/>
                            <c:remove var="messageType" scope="session"/>
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/order" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value="${searchFilter}"/>" placeholder="Tìm theo mã đơn hoặc tên khác" autocomplete="off" />
                        </div>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="PENDING" <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="APPROVED" <c:if test="${statusFilter == 'APPROVED'}">selected</c:if>>Đã duyệt</option>
                            <option value="REJECTED" <c:if test="${statusFilter == 'REJECTED'}">selected</c:if>>Từ chối</option>
                            <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </select>

                            <div class="spacer"></div>
                            <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/order?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <table class="users" id="ordersTable">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Ngày đặt</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th>Tổng tiền</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-address">Địa chỉ</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="ordersBody">
                                <c:choose>
                                    <c:when test="${empty orders}">

                                        <tr><td colspan="8" style="text-align:center; padding:20px; color:var(--muted);">Không có đơn hàng nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="order" items="${orders}" varStatus="loop">
                                            <tr data-id="${order.orderId}" style="cursor:pointer;">
                                                <td>
                                                    <div class="order-code"><c:out value="${order.orderCode}"/></div>
                                                </td>
                                                <td>
                                                    <div class="user-cell">
                                                        <div class="user-name-block">
                                                            <a href="javascript:void(0);" class="user-name customer-link"
                                                               onclick="showCustomerModal(this)"
                                                               data-cust-id="<c:out value='${order.customer.id}'/>"
                                                               data-cust-name="<c:out value='${order.customer.name}'/>"
                                                               data-cust-phone="<c:out value='${order.customer.phone}'/>"
                                                               data-cust-email="<c:out value='${order.customer.email}'/>"
                                                               data-cust-address="<c:out value='${order.customer.address}'/>"
                                                               data-cust-company="<c:out value='${order.customer.companyName}'/>"
                                                               title="Xem thông tin khách hàng">
                                                                <c:out value="${order.customer.name}"/>
                                                            </a>
                                                            <div class="user-email"><c:out value="${order.customer.phone}"/></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td class="col-creator">
                                                    <c:out value="${order.createdByName}"/>
                                                </td>
                                                <td class="amount-cell">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                </td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                        <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                                        <c:when test="${order.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${order.status}"/></span></c:otherwise>
                                                        </c:choose>
                                                </td>
                                                <td class="col-address"><span class="pill role-staff"><span class="pdot"></span> ${order.customer.address}</span></td>
                                                <td class="col-actions">
                                                    <div class="dropdown">
                                                        <button class="dropdown-btn" onclick="toggleDropdown(this)" type="button">
                                                            Hành động <span class="arrow">▾</span>
                                                        </button>
                                                        <div class="dropdown-menu">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                                <span class="label">Chi tiết</span>
                                                            </a>
                                                            <c:if test="${order.status == 'PENDING' && canApproveOrder}">
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item approve" onclick="openApproveModal(${order.orderId}, '<c:out value="${fn:escapeXml(order.orderCode)}"/>')" type="button">
                                                                    <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                                                    <span class="label">Duyệt</span>
                                                                </button>
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item reject" onclick="openRejectModal(${order.orderId}, '<c:out value="${fn:escapeXml(order.orderCode)}"/>')" type="button">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                                                    <span class="label">Từ chối</span>
                                                                </button>
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item revision" onclick="openRevisionModal(${order.orderId}, '<c:out value="${fn:escapeXml(order.orderCode)}"/>')" type="button">
                                                                    <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                                    <span class="label">Yêu cầu chỉnh sửa</span>
                                                                </button>
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
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${currentPage * 10 > totalOrders ? totalOrders : currentPage * 10}</strong> / <strong>${totalOrders}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty searchFilter}">&search=<c:out value="${searchFilter}"/></c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <c:if test="${canApproveOrder}">
            <div class="modal-host" id="approveModalList">
                <div class="modal-card">
                    <h3>Duyệt đơn hàng</h3>
                    <div class="modal-sub" id="approveModalSub">Xác nhận duyệt đơn hàng?</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=approve">
                        <input type="hidden" name="id" id="approveOrderId" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-primary" onclick="return confirmApproveAction()">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="rejectModalList">
                <div class="modal-card">
                    <h3>Từ chối đơn hàng</h3>
                    <div class="modal-sub" id="rejectModalSub">Đơn hàng sẽ bị huỷ.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=reject">
                        <input type="hidden" name="orderId" id="rejectOrderId" />
                        <label for="rejectReasonList">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReasonList" name="rejectReason" required placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, thông tin chưa hợp lệ..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="revisionModalList">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub" id="revisionModalSub">Gửi đơn hàng lại cho nhân viên chỉnh sửa.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/order?action=requestRevision">
                        <input type="hidden" name="id" id="revisionOrderId" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="reason" id="revisionReasonList" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <div class="toast-host" id="toastHost"></div>

        <div class="customer-modal-backdrop" id="customerModal" onclick="if (event.target === this) closeCustomerModal();">
            <div class="customer-modal" role="dialog" aria-modal="true" aria-labelledby="customerModalTitle">
                <div class="customer-modal-header">
                    <h3 id="customerModalTitle">Thông tin khách hàng</h3>
                    <button type="button" class="customer-modal-close" onclick="closeCustomerModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="customer-modal-body">
                    <div class="cust-info-row">
                        <div class="lbl">Mã khách hàng</div>
                        <div class="val" id="cm-id">—</div>
                    </div>
                    <div class="cust-info-row">
                        <div class="lbl">Họ và tên</div>
                        <div class="val" id="cm-name">—</div>
                    </div>
                    <div class="cust-info-row">
                        <div class="lbl">Số điện thoại</div>
                        <div class="val" id="cm-phone">—</div>
                    </div>
                    <div class="cust-info-row">
                        <div class="lbl">Email</div>
                        <div class="val" id="cm-email">—</div>
                    </div>
                    <div class="cust-info-row">
                        <div class="lbl">Công ty</div>
                        <div class="val" id="cm-company">—</div>
                    </div>
                    <div class="cust-info-row">
                        <div class="lbl">Địa chỉ</div>
                        <div class="val" id="cm-address">—</div>
                    </div>
                </div>
                <div class="customer-modal-footer">
                    <button type="button" class="btn" onclick="closeCustomerModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="cm-detail-link">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

    <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            if (window.SESSION_DATA && window.SESSION_DATA.message) {
                if (typeof showToast === 'function') {
                    showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                }
            }
        });
    </script>
    <script>
            function openApproveModal(orderId, orderCode) {
                document.getElementById('approveOrderId').value = orderId;
                document.getElementById('approveModalSub').innerHTML = 'Xác nhận duyệt đơn hàng <strong>' + orderCode + '</strong>?';
                openModal('approveModalList');
            }
            function openRejectModal(orderId, orderCode) {
                document.getElementById('rejectOrderId').value = orderId;
                document.getElementById('rejectModalSub').innerHTML = 'Từ chối đơn hàng <strong>' + orderCode + '</strong>? Hành động này không thể hoàn tác.';
                document.getElementById('rejectReasonList').value = '';
                openModal('rejectModalList');
            }
            function openRevisionModal(orderId, orderCode) {
                document.getElementById('revisionOrderId').value = orderId;
                document.getElementById('revisionModalSub').innerHTML = 'Gửi đơn hàng <strong>' + orderCode + '</strong> lại cho nhân viên chỉnh sửa.';
                document.getElementById('revisionReasonList').value = '';
                openModal('revisionModalList');
            }

            function openModal(id) { var m = document.getElementById(id); if (m) m.classList.add('show'); }
            function closeModal(id) { var m = document.getElementById(id); if (m) m.classList.remove('show'); }
            document.querySelectorAll('.modal-host').forEach(function (m) {
                m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
                    closeCustomerModal();
                }
            });

            function confirmApproveAction() {
                return confirm('Bạn có chắc muốn duyệt đơn hàng này?');
            }

            function toggleDropdown(btn) {
                var menu = btn.nextElementSibling;
                var isOpen = menu.classList.contains('open');
                document.querySelectorAll('.dropdown-menu.open').forEach(function (m) {
                    if (m !== menu) {
                        m.classList.remove('open');
                        m.previousElementSibling.classList.remove('open');
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
                menu.style.minWidth = Math.max(170, rect.width) + 'px';
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

            function showCustomerModal(el) {
            event.stopPropagation();
            var id = el.getAttribute('data-cust-id') || '';
            var name = el.getAttribute('data-cust-name') || '—';
            var phone = el.getAttribute('data-cust-phone') || '—';
            var email = el.getAttribute('data-cust-email') || '';
            var address = el.getAttribute('data-cust-address') || '';
            var company = el.getAttribute('data-cust-company') || '';

            document.getElementById('cm-id').textContent = id || '—';
            document.getElementById('cm-name').textContent = name;
            document.getElementById('cm-phone').textContent = phone;
            document.getElementById('cm-email').textContent = email || '—';
            document.getElementById('cm-company').textContent = company || '—';
            document.getElementById('cm-address').textContent = address || '—';
            document.getElementById('cm-detail-link').href = window.APP_CTX + '/warehouse/customers?action=view&id=' + id;

            document.getElementById('customerModal').classList.add('open');
        }
        function closeCustomerModal() {
            document.getElementById('customerModal').classList.remove('open');
        }
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                closeCustomerModal();
            }
        });
    </script>
</body>
</html>
