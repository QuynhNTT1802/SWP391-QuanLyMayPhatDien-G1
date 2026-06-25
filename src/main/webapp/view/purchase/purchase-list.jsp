<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    java.time.format.DateTimeFormatter __poFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("poFmt", __poFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý phiếu mua — Warehouse OS</title>
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
            .status-draft { background: #e2e3e5; color: #383d41; }
            .status-pending_ceo { background: #fff3cd; color: #856404; }
            .status-approved { background: #d4edda; color: #155724; }
            .status-rejected { background: #f8d7da; color: #721c24; }
            .status-needs_revision { background: #ede9fe; color: #5b21b6; }
            .status-cancelled { background: #e2e3e5; color: #383d41; }
            .po-code {
                font-family: 'JetBrains Mono', monospace;
                font-size: 13px;
                color: var(--muted);
            }
            .col-status { white-space: nowrap; width: 140px; }
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
                    <h1>Phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Kinh doanh</a> / Phiếu mua</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Danh sách phiếu mua</h2>
                            <div class="page-sub">${totalPOs} phiếu mua</div>
                        </div>
                        <c:set var="perms" value="${sessionScope.userPermissions}"/>
                        <c:set var="canCreatePo" value="${perms.contains('purchase_orders.create')}"/>
                        
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.message}"/>', type: 'success'};
                            <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.toastMessage}">
                            window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/purchase-order" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />

                        <input type="date" class="filter-select" name="dateFrom" value="${dateFrom}"
                               title="Từ ngày" onchange="this.form.submit()" />
                        <input type="date" class="filter-select" name="dateTo" value="${dateTo}"
                               title="Đến ngày" onchange="this.form.submit()" />

                        <select class="filter-select" name="warehouseId" onchange="this.form.submit()">
                            <option value="">Kho: Tất cả</option>
                            <c:forEach var="w" items="${warehouses}">
                                <option value="${w.warehouseId}" <c:if test="${warehouseId == w.warehouseId}">selected</c:if>>${w.name}</option>
                            </c:forEach>
                        </select>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>

                            <%-- Sale Staff (chỉ có view): thấy trạng thái cuối, KHÔNG có Chờ CEO duyệt --%>
                            <c:if test="${perms.contains('purchase_orders.view') and !perms.contains('purchase_orders.create') and !perms.contains('purchase_orders.approve')}">
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="NEEDS_REVISION" <c:if test="${status == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa đề xuất</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>

                            <%-- CEO (chỉ có approve): thấy Chờ CEO, Đã duyệt, Từ chối, Cần chỉnh sửa --%>
                            <c:if test="${perms.contains('purchase_orders.approve') and !perms.contains('purchase_orders.create')}">
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="NEEDS_REVISION" <c:if test="${status == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa đề xuất</option>
                            </c:if>

                            <%-- Sale Manager (có create + view): thấy Nháp, Chờ CEO, Đã duyệt, Từ chối, Cần chỉnh sửa, Đã hủy --%>
                            <c:if test="${perms.contains('purchase_orders.create') and !perms.contains('purchase_orders.approve')}">
                                <option value="DRAFT" <c:if test="${status == 'DRAFT'}">selected</c:if>>Nháp</option>
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="NEEDS_REVISION" <c:if test="${status == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa đề xuất</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>

                            <%-- Có cả create + approve (admin/PM): thấy tất cả status --%>
                            <c:if test="${perms.contains('purchase_orders.approve') and perms.contains('purchase_orders.create')}">
                                <option value="DRAFT" <c:if test="${status == 'DRAFT'}">selected</c:if>>Nháp</option>
                                <option value="PENDING_CEO" <c:if test="${status == 'PENDING_CEO'}">selected</c:if>>Chờ CEO</option>
                                <option value="APPROVED" <c:if test="${status == 'APPROVED'}">selected</c:if>>Đã duyệt bởi CEO</option>
                                <option value="REJECTED" <c:if test="${status == 'REJECTED'}">selected</c:if>>Từ chối bởi CEO</option>
                                <option value="NEEDS_REVISION" <c:if test="${status == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa đề xuất</option>
                                <option value="CANCELLED" <c:if test="${status == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                            </c:if>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" onclick="location.href = '${pageContext.request.contextPath}/purchase-order?action=list'">
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <table class="users" id="poTable">
                            <thead>
                                <tr>
                                    <th>Mã PO</th>
                                    <th>Tháng</th>
                                    <th>Kho</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>SL đề xuất</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty purchaseOrders}">
                                        <tr><td colspan="8" style="text-align:center; padding:20px; color:var(--muted);">Chưa có phiếu mua nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="po" items="${purchaseOrders}">
                                            <tr>
                                                <td><div class="po-code"><c:out value="${po.poCode}"/></div></td>
                                                <td><c:out value="${po.period}"/></td>
                                                <td><c:out value="${po.warehouseName}"/></td>
                                                <td><c:out value="${po.createdByName}"/></td>
                                                <td>${po.createdAt.format(poFmt)}</td>
                                                <td>${po.totalQuantity}</td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${po.status == 'DRAFT'}"><span class="status-pill status-draft">Nháp</span></c:when>
                                                        <c:when test="${po.status == 'PENDING_CEO'}"><span class="status-pill status-pending_ceo">Chờ CEO duyệt</span></c:when>
                                                        <c:when test="${po.status == 'APPROVED'}"><span class="status-pill status-approved">Đã duyệt bởi CEO</span></c:when>
                                                        <c:when test="${po.status == 'REJECTED'}"><span class="status-pill status-rejected">Từ chối bởi CEO</span></c:when>
                                                        <c:when test="${po.status == 'NEEDS_REVISION'}"><span class="status-pill status-needs_revision">Cần chỉnh sửa đề xuất</span></c:when>
                                                        <c:when test="${po.status == 'CANCELLED'}"><span class="status-pill status-cancelled">Đã hủy</span></c:when>
                                                        <c:otherwise><span class="status-pill"><c:out value="${po.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-actions">
                                                    <div class="dropdown">
                                                        <button class="dropdown-btn" onclick="toggleDropdown(this)" type="button">
                                                            Hành động <span class="arrow">▾</span>
                                                        </button>
                                                        <div class="dropdown-menu">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                                <span class="label">Chi tiết</span>
                                                            </a>

                                                            <c:if test="${po.status == 'DRAFT' && canCreatePo}">
                                                                <div class="dropdown-divider"></div>
                                                                <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=sendToCeo" style="margin:0;">
                                                                    <input type="hidden" name="id" value="${po.poId}" />
                                                                    <button type="submit" class="dropdown-item approve" onclick="return confirm('Xác nhận gửi CEO duyệt phiếu mua này?')">
                                                                        <svg viewBox="0 0 24 24"><path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                                                        <span class="label">Gửi CEO duyệt</span>
                                                                    </button>
                                                                </form>
                                                                <c:if test="${currentUserId == po.createdBy}">
                                                                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=cancel" style="margin:0;">
                                                                        <input type="hidden" name="id" value="${po.poId}" />
                                                                        <button type="submit" class="dropdown-item cancel" onclick="return confirm('Xác nhận hủy phiếu mua này?')">
                                                                            <svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                                                            <span class="label">Hủy</span>
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                            </c:if>

                                                            <c:if test="${po.status == 'PENDING_CEO' && canApprovePo}">
                                                                <div class="dropdown-divider"></div>
                                                                <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=approve" style="margin:0;">
                                                                    <input type="hidden" name="id" value="${po.poId}" />
                                                                    <button type="submit" class="dropdown-item approve" onclick="return confirmApproveAction()">
                                                                        <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                                                        <span class="label">Duyệt bởi CEO</span>
                                                                    </button>
                                                                </form>
                                                                <div class="dropdown-divider"></div>
                                                                <button type="button" class="dropdown-item reject" onclick="openRejectModal(${po.poId}, '<c:out value="${fn:escapeXml(po.poCode)}"/>')">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                                                    <span class="label">Từ chối bởi CEO</span>
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
                            <div class="info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty dateFrom}">&dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&dateTo=${dateTo}</c:if><c:if test="${warehouseId > 0}">&warehouseId=${warehouseId}</c:if><c:if test="${not empty status}">&status=${status}</c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <c:if test="${canApprovePo}">
            <div class="modal-host" id="rejectModalList">
                <div class="modal-card">
                    <h3>Từ chối bởi CEO</h3>
                    <div class="modal-sub" id="rejectModalSub">Phiếu sẽ bị từ chối bởi CEO và trả về cho Sale Manager.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/purchase-order?action=reject">
                        <input type="hidden" name="id" id="rejectPoId" />
                        <label for="rejectReasonList">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReasonList" name="rejectReason" required placeholder="Ví dụ: Vượt ngân sách tháng, cần điều chỉnh số lượng..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModalList')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối (CEO)</button>
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
            function openRejectModal(id, code) {
                var el = document.getElementById('rejectPoId');
                if (el) el.value = id;
                var sub = document.getElementById('rejectModalSub');
                if (sub) sub.innerHTML = 'Từ chối (CEO) phiếu mua <strong>' + code + '</strong>? Hành động này không thể hoàn tác.';
                var reason = document.getElementById('rejectReasonList');
                if (reason) reason.value = '';
                openModal('rejectModalList');
            }

            function confirmApproveAction() {
                return confirm('Bạn có chắc muốn duyệt (CEO) phiếu mua này?');
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
            });
        </script>
    </body>
</html>
