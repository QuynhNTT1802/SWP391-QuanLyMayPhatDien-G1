<%-- 
    Document   : order-list
    Created on : May 26, 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
                display: inline-flex; align-items: center; gap: 6px;
                padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;
            }
            .status-pending { background: #fff3cd; color: #856404; }
            .status-approved { background: #d4edda; color: #155724; }
            .status-rejected { background: #f8d7da; color: #721c24; }
            .status-cancelled { background: #e2e3e5; color: #383d41; }
            .amount-cell { font-weight: 600; color: var(--accent); }
            .order-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--muted); }
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
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/order?action=create">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                Tạo đơn hàng
                            </a>
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

                        <c:if test="${not empty sessionScope.message}">
                            <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                                <c:out value="${sessionScope.message}"/>
                            </div>
                            <c:remove var="message" scope="session"/>
                        </c:if>

                        <form method="get" action="${pageContext.request.contextPath}/order" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                            <input type="hidden" name="action" value="list" />
                            <div class="search-input">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input name="search" value="<c:out value="${searchFilter}"/>" placeholder="Tìm theo mã đơn hoặc tên khách…" autocomplete="off" />
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
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Người tạo</th>
                                        <th class="col-actions">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="ordersBody">
                                    <c:choose>
                                        <c:when test="${empty orders}">
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
                                                                <div class="user-name"><c:out value="${order.customerName}"/></div>
                                                                <div class="user-email"><c:out value="${order.customerPhone}"/></div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td class="amount-cell">
                                                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                            <c:when test="${order.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                            <c:when test="${order.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                                            <c:when test="${order.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                                            <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${order.status}"/></span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><span class="pill role-staff"><span class="pdot"></span>ID: ${order.createdBy}</span></td>
                                                    <td class="col-actions">
                                                        <div class="row-actions">
                                                            <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}'" title="Xem chi tiết">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                            </button>
                                                            
                                                            <c:if test="${order.status == 'PENDING'}">
                                                                <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/order?action=edit&id=${order.orderId}'" title="Chỉnh sửa">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                                </button>
                                                            </c:if>

                                                            <c:if test="${order.status == 'PENDING'}">
                                                                <button class="icon-mini" style="color: #28a745;" onclick="confirmApprove(${order.orderId})" title="Duyệt đơn">
                                                                    <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                                                </button>
                                                            </c:if>

                                                            <c:if test="${order.status == 'PENDING' || order.status == 'APPROVED'}">
                                                                <button class="icon-mini" style="color: #dc3545;" onclick="confirmCancel(${order.orderId})" title="Hủy đơn">
                                                                    <svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                            
                            <table>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty orders}">
                                            <tr><td colspan="7">
                                                    <div class="empty-state">
                                                        <strong>Không tìm thấy đơn hàng</strong>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </main>
                </div>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <div class="modal-host" id="confirmModal">
            <div class="modal">
                <h3 id="modalTitle">Xác nhận hành động</h3>
                <p id="modalText">Bạn có chắc muốn thực hiện hành động này?</p>
                <div class="actions">
                    <button class="btn" id="modalCancel">Huỷ</button>
                    <button class="btn btn-danger" id="modalConfirm">Xác nhận</button>
                </div>
            </div>
        </div>
        
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            function confirmApprove(orderId) {
                document.getElementById('modalTitle').textContent = 'Duyệt đơn hàng';
                document.getElementById('modalText').textContent = 'Bạn có chắc muốn duyệt đơn hàng này?';
                document.getElementById('confirmModal').classList.add('show');
                document.getElementById('modalConfirm').onclick = function () {
                    window.location.href = window.APP_CTX + '/order?action=approve&id=' + orderId;
                };
            }
            function confirmCancel(orderId) {
                document.getElementById('modalTitle').textContent = 'Hủy đơn hàng';
                document.getElementById('modalText').textContent = 'Bạn có chắc muốn hủy đơn hàng này? Hành động này không thể hoàn tác.';
                document.getElementById('confirmModal').classList.add('show');
                document.getElementById('modalConfirm').onclick = function () {
                    window.location.href = window.APP_CTX + '/order?action=cancel&id=' + orderId;
                };
            }
            document.getElementById('modalCancel').onclick = function() {
                document.getElementById('confirmModal').classList.remove('show');
            };
        </script>
    </body>
</html>
