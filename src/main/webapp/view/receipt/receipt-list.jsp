<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phiếu nhập/xuất — Warehouse OS</title>
        <!-- fonts + css giữ nguyên -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .user-name.link-ref {
                cursor: pointer;
                color: var(--accent);
                text-decoration: none;
            }
            .user-name.link-ref:hover {
                text-decoration: underline;
            }
            .ref-modal-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,.45);
                z-index: 1000;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .ref-modal-backdrop.open {
                display: flex;
            }
            .ref-modal {
                background: var(--surface);
                border-radius: 8px;
                width: 100%;
                max-width: 480px;
                box-shadow: 0 10px 40px rgba(0,0,0,.25);
                overflow: hidden;
                animation: refModalPop .18s ease-out;
            }
            @keyframes refModalPop {
                from { transform: scale(.96); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
            }
            .ref-modal-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 18px;
                border-bottom: 1px solid var(--border);
            }
            .ref-modal-header h3 {
                margin: 0;
                font-size: 16px;
                font-weight: 700;
            }
            .ref-modal-close {
                background: transparent;
                border: none;
                font-size: 22px;
                line-height: 1;
                cursor: pointer;
                color: var(--muted);
                padding: 0 4px;
            }
            .ref-modal-close:hover { color: var(--fg); }
            .ref-modal-body {
                padding: 16px 18px;
            }
            .ref-info-row {
                display: flex;
                gap: 10px;
                padding: 8px 0;
                border-bottom: 1px dashed var(--border);
                font-size: 13.5px;
            }
            .ref-info-row:last-child { border-bottom: none; }
            .ref-info-row .lbl {
                flex: 0 0 110px;
                color: var(--muted);
                font-weight: 500;
            }
            .ref-info-row .val {
                flex: 1;
                color: var(--fg);
                word-break: break-word;
            }
            .ref-modal-footer {
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
                        <h1>Phiếu nhập/xuất</h1>
                        <span class="crumb">/ Kho / Phiếu nhập/xuất</span>
                        <div class="top-actions">
                            <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                                <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                                <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            </button>
                            <a class="btn" href="${pageContext.request.contextPath}/receipt?action=selectOrder">
                            Xem phiếu mua đã duyệt
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/receipt?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu mới
                        </a>
                    </div>
                </header>
                <main>
                    <!-- page-head giữ nguyên -->
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho</div>
                            <h2 class="page-title">Quản lý phiếu nhập/xuất</h2>
                            <div class="page-sub">${totalItems} phiếu</div>
                        </div>
                    </div>
                    <div class="toast-host" id="toastHost"></div>
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
                    <!-- filter giữ nguyên -->
                    <form method="get" action="${pageContext.request.contextPath}/receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, đơn, khách hàng, người tạo" autocomplete="off" />
                        </div>
                        <select class="filter-select" name="type" onchange="this.form.submit()">
                            <option value="">Loại: Tất cả</option>
                            <option value="IMPORT" <c:if test="${typeFilter == 'IMPORT'}">selected</c:if>>Nhập kho</option>
                            <option value="EXPORT" <c:if test="${typeFilter == 'EXPORT'}">selected</c:if>>Xuất kho</option>
                            </select>
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
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            Tìm kiếm
                        </button>
                        <c:if test="${not empty typeFilter or not empty statusFilter or not empty whFilter or not empty search}">
                            <a href="${pageContext.request.contextPath}/receipt" class="btn">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                Xoá lọc
                            </a>
                        </c:if>
                    </form>
                    <!-- bảng -->
                    <div class="table-card" style="margin-top:16px;">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Loại</th>
                                    <th>Kho</th>
                                    <th>Đơn liên quan</th>
                                    <th>Lý do</th>
                                    <th>Người tạo</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty receiptList}">
                                        <tr><td colspan="10">
                                                <div class="empty-state"><strong>Không tìm thấy phiếu nào</strong></div>
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="r" items="${receiptList}">
                                            <tr>
                                                <td><strong>${r.receiptCode}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.receiptType == 'IMPORT'}">
                                                            <span style="color:#155724;background:#d4edda;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;">Nhập kho</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:#004085;background:#cce5ff;padding:3px 10px;border-radius:12px;font-size:12px;font-weight:600;">Xuất kho</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.warehouseName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty r.orderCode}">
                                                            <a href="javascript:void(0);" class="user-name link-ref"
                                                               onclick="showRefModal(this)"
                                                               data-ref-type="order"
                                                               data-ref-id="<c:out value='${r.orderId}'/>"
                                                               data-ref-code="<c:out value='${r.orderCode}'/>"
                                                               data-ref-name="<c:out value='${r.customerName}'/>"
                                                               title="Xem thông tin đơn hàng">
                                                                <c:out value="${r.orderCode}"/>
                                                            </a>
                                                            <div style="font-size:11px;color:var(--muted);"><c:out value="${r.customerName}"/></div>
                                                        </c:when>
                                                        <c:when test="${not empty r.proposalCode}">
                                                            <a href="javascript:void(0);" class="user-name link-ref"
                                                               onclick="showRefModal(this)"
                                                               data-ref-type="proposal"
                                                               data-ref-id="<c:out value='${r.proposalId}'/>"
                                                               data-ref-code="<c:out value='${r.proposalCode}'/>"
                                                               data-ref-name="<c:out value='${r.warehouseName}'/>"
                                                               title="Xem thông tin đề xuất nhập">
                                                                <c:out value="${r.proposalCode}"/>
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty r.reasonName}">
                                                            <span class="status-pill status-pending"><span class="pdot"></span>${r.reasonName}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.createdByName}</td>
                                                <td class="mono">
                                                    <c:choose>
                                                        <c:when test="${not empty r.totalAmount}">
                                                            <fmt:formatNumber value="${r.totalAmount}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                                        </c:when>
                                                        <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.status == 'DRAFT'}">
                                                            <span class="status active" style="--dot:var(--info);background:var(--info-soft);color:var(--info);"><span class="sdot"></span>Bản nháp</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'PENDING'}">
                                                            <span class="status active" style="--dot:var(--warn);"><span class="sdot"></span>Chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'NEEDS_REVISION'}">
                                                            <span class="status active" style="--dot:var(--warn);background:var(--warn-soft);color:var(--warn);"><span class="sdot"></span>Yêu cầu chỉnh sửa</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'COMPLETED'}">
                                                            <span class="status active"><span class="sdot"></span>Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${r.status == 'CANCELLED'}">
                                                            <span class="status locked"><span class="sdot"></span>Đã từ chối</span>
                                                        </c:when>
                                                        <c:otherwise>${r.status}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${r.createdAt}</td>
                                                <td class="col-actions">
                                                    <div class="row-actions">
                                                        <a href="${pageContext.request.contextPath}/receipt?action=detail&id=${r.receiptId}" class="icon-mini" title="Xem chi tiết">
                                                            <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                        </a>
                                                        <c:if test="${(r.status == 'NEEDS_REVISION' || r.status == 'DRAFT') && r.createdBy == sessionScope.loggedUser.id}">
                                                            <a href="${pageContext.request.contextPath}/receipt?action=edit&id=${r.receiptId}" class="icon-mini" title="Chỉnh sửa" style="color:var(--warn);">
                                                                <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <!-- pagination -->
                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty typeFilter}">
                            <c:set var="filterParams" value="${filterParams}&type=${typeFilter}" />
                        </c:if>
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

        <div class="ref-modal-backdrop" id="refModal" onclick="if (event.target === this) closeRefModal();">
            <div class="ref-modal" role="dialog" aria-modal="true" aria-labelledby="refModalTitle">
                <div class="ref-modal-header">
                    <h3 id="refModalTitle">Thông tin đơn liên quan</h3>
                    <button type="button" class="ref-modal-close" onclick="closeRefModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="ref-modal-body">
                    <div class="ref-info-row">
                        <div class="lbl">Loại</div>
                        <div class="val" id="rm-type">—</div>
                    </div>
                    <div class="ref-info-row">
                        <div class="lbl">Mã</div>
                        <div class="val" id="rm-code">—</div>
                    </div>
                    <div class="ref-info-row">
                        <div class="lbl" id="rm-name-lbl">Tên</div>
                        <div class="val" id="rm-name">—</div>
                    </div>
                </div>
                <div class="ref-modal-footer">
                    <button type="button" class="btn" onclick="closeRefModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="rm-detail-link">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            function showRefModal(el) {
                var type = el.getAttribute('data-ref-type');
                var id = el.getAttribute('data-ref-id') || '';
                var code = el.getAttribute('data-ref-code') || '—';
                var name = el.getAttribute('data-ref-name') || '—';

                document.getElementById('rm-type').textContent = type === 'order' ? 'Đơn hàng bán' : 'Phiếu đề xuất nhập';
                document.getElementById('rm-code').textContent = code;
                document.getElementById('rm-name').textContent = name;
                document.getElementById('rm-name-lbl').textContent = type === 'order' ? 'Khách hàng' : 'Kho nhập';

                var detailUrl = type === 'order'
                    ? window.APP_CTX + '/order?action=detail&id=' + id
                    : window.APP_CTX + '/proposal?action=detail&id=' + id;
                document.getElementById('rm-detail-link').href = detailUrl;

                document.getElementById('refModal').classList.add('open');
            }
            function closeRefModal() {
                document.getElementById('refModal').classList.remove('open');
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeRefModal();
                }
            });
        </script>
    </body>
</html>
