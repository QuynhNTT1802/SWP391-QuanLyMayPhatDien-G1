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
        <title>Phiếu xuất kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; white-space: nowrap; }
            .status-pill .pdot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; display: inline-block; }
            .status-draft { background: #e2e3e5; color: #383d41; }
            .status-pending { background: #fff3cd; color: #856404; }
            .status-revision { background: #ffe5b4; color: #8a5a00; }
            .status-completed { background: #d4edda; color: #155724; }
            .status-cancelled { background: #f8d7da; color: #721c24; }
            .receipt-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--fg); font-weight: 600; }
            .amount-cell { font-weight: 600; color: var(--accent); white-space: nowrap; }
            .col-creator { white-space: nowrap; width: 110px; }
            .col-status { white-space: nowrap; width: 140px; }
            .col-date { white-space: nowrap; width: 130px; color: var(--muted); font-size: 13px; }
            .col-order { max-width: 180px; }
            .col-order a { font-family: 'JetBrains Mono', monospace; font-size: 12px; color: var(--accent); text-decoration: none; }
            .col-order a:hover { text-decoration: underline; }
            .col-order .cust { font-size: 11px; color: var(--muted); margin-top: 2px; }
            .col-reason { max-width: 160px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
            .col-actions { white-space: nowrap; }
            .table-card { overflow-x: auto; -webkit-overflow-scrolling: touch; }
            .empty-state { text-align: center; padding: 24px; color: var(--muted); }
            .muted { color: var(--muted); }
            .dropdown { position: relative; display: inline-block; }
            .dropdown-btn { background: var(--surface); border: 1px solid var(--border); padding: 5px 12px; border-radius: var(--radius-sm); cursor: pointer; font-size: 12px; font-weight: 600; color: var(--fg); display: inline-flex; align-items: center; gap: 6px; }
            .dropdown-btn:hover { background: var(--surface-2); }
            .dropdown-menu { position: fixed; background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius-sm); box-shadow: 0 4px 12px rgba(0,0,0,0.08); min-width: 160px; display: none; z-index: 50; }
            .dropdown-menu.open { display: block; }
            .dropdown-item { display: flex; align-items: center; gap: 8px; padding: 8px 12px; font-size: 13px; color: var(--fg); text-decoration: none; cursor: pointer; background: none; border: none; width: 100%; text-align: left; }
            .dropdown-item:hover { background: var(--surface-2); }
            .dropdown-item svg { width: 14px; height: 14px; flex-shrink: 0; }
            .dropdown-item.approve { color: var(--accent); }
            .dropdown-item.reject { color: var(--danger); }
            .dropdown-item.revision { color: var(--warn); }
            .dropdown-divider { height: 1px; background: var(--border); margin: 4px 0; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Phiếu xuất kho</h1>
                    <span class="crumb">/ Kho / Phiếu xuất</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <a class="btn" href="${pageContext.request.contextPath}/export-receipt?action=selectOrder">
                            Xem đơn hàng đã duyệt
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/export-receipt?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu xuất
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho · Phiếu xuất</div>
                            <h2 class="page-title">Danh sách phiếu xuất kho</h2>
                            <div class="page-sub">${totalItems} phiếu</div>
                        </div>
                    </div>

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

                    <form method="get" action="${pageContext.request.contextPath}/export-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, đơn, khách hàng, người tạo" autocomplete="off" />
                        </div>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="DRAFT" <c:if test="${statusFilter == 'DRAFT'}">selected</c:if>>Bản nháp</option>
                            <option value="PENDING" <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="NEEDS_REVISION" <c:if test="${statusFilter == 'NEEDS_REVISION'}">selected</c:if>>Yêu cầu chỉnh sửa</option>
                            <option value="COMPLETED" <c:if test="${statusFilter == 'COMPLETED'}">selected</c:if>>Hoàn thành</option>
                            <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã từ chối</option>
                        </select>

                        <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                            <option value="">Kho: Tất cả</option>
                            <c:forEach var="wh" items="${warehouses}">
                                <option value="${wh.warehouseId}" <c:if test="${whFilter == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                            </c:forEach>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/export-receipt?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card" style="margin-top:16px;">
                        <table class="users" id="receiptsTable">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Kho</th>
                                    <th class="col-order">Đơn liên quan</th>
                                    <th class="col-reason">Lý do</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th>Tổng tiền</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-date">Ngày tạo</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="receiptsBody">
                                <c:choose>
                                    <c:when test="${empty receiptList}">
                                        <tr><td colspan="9" style="text-align:center; padding:20px; color:var(--muted);">Không có phiếu nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${receiptList}">
                                            <tr data-id="${r.receiptId}">
                                                <td><span class="receipt-code"><c:out value="${r.receiptCode}"/></span></td>
                                                <td>${r.warehouseName}</td>
                                                <td class="col-order">
                                                    <c:choose>
                                                        <c:when test="${not empty r.orderCode}">
                                                            <a href="${pageContext.request.contextPath}/order?action=detail&id=${r.orderId}">${r.orderCode}</a>
                                                            <div class="cust">${r.customerName}</div>
                                                        </c:when>
                                                        <c:otherwise><span class="muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-reason">
                                                    <c:choose>
                                                        <c:when test="${not empty r.reasonName}">
                                                            <span class="status-pill status-revision"><span class="pdot"></span>${r.reasonName}</span>
                                                        </c:when>
                                                        <c:otherwise><span class="muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-creator"><c:out value="${r.createdByName}"/></td>
                                                <td class="amount-cell">
                                                    <c:choose>
                                                        <c:when test="${not empty r.totalAmount}">
                                                            <fmt:formatNumber value="${r.totalAmount}" type="currency" currencySymbol="₫"/>
                                                        </c:when>
                                                        <c:otherwise><span class="muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${r.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Bản nháp</span></c:when>
                                                        <c:when test="${r.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${r.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Yêu cầu chỉnh sửa</span></c:when>
                                                        <c:when test="${r.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                                                        <c:when test="${r.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${r.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-date">${r.createdAt}</td>
                                                <td class="col-actions">
                                                    <div class="dropdown">
                                                        <button class="dropdown-btn" onclick="toggleDropdown(this)" type="button">
                                                            Hành động <span class="arrow">▾</span>
                                                        </button>
                                                        <div class="dropdown-menu">
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${r.receiptId}">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                                <span class="label">Chi tiết</span>
                                                            </a>
                                                            <c:if test="${(r.status == 'NEEDS_REVISION' || r.status == 'DRAFT') && r.createdBy == sessionScope.loggedUser.id}">
                                                                <div class="dropdown-divider"></div>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/export-receipt?action=edit&id=${r.receiptId}">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                                    <span class="label">Sửa</span>
                                                                </a>
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
                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty statusFilter}">
                            <c:set var="filterParams" value="${filterParams}&status=${statusFilter}" />
                        </c:if>
                        <c:if test="${not empty whFilter}">
                            <c:set var="filterParams" value="${filterParams}&warehouse=${whFilter}" />
                        </c:if>
                        <c:if test="${not empty search}">
                            <c:set var="filterParams" value="${filterParams}&search=${search}" />
                        </c:if>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}${filterParams}" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            function toggleDropdown(btn) {
                var menu = btn.nextElementSibling;
                var isOpen = menu.classList.contains('open');
                document.querySelectorAll('.dropdown-menu.open').forEach(function (m) {
                    if (m !== menu) { m.classList.remove('open'); m.previousElementSibling.classList.remove('open'); }
                });
                if (isOpen) { menu.classList.remove('open'); btn.classList.remove('open'); return; }
                var rect = btn.getBoundingClientRect();
                menu.style.top = (rect.bottom + 4) + 'px';
                menu.style.left = rect.left + 'px';
                menu.style.minWidth = Math.max(150, rect.width) + 'px';
                menu.classList.add('open');
                btn.classList.add('open');
            }
            document.addEventListener('click', function (e) {
                if (!e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu.open').forEach(function (m) { m.classList.remove('open'); });
                    document.querySelectorAll('.dropdown-btn.open').forEach(function (b) { b.classList.remove('open'); });
                }
            });
        </script>
    </body>
</html>
