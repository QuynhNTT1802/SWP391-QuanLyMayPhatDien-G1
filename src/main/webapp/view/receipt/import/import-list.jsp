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
        <title>Phiếu nhập kho — Warehouse OS</title>
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
            .status-pending { background: #fff3cd; color: #856404; }
            .status-revision { background: #ffe5b4; color: #8a5a00; }
            .status-completed { background: #d4edda; color: #155724; }
            .status-cancelled { background: #f8d7da; color: #721c24; }
            .receipt-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--fg); font-weight: 600; }
            .amount-cell { font-weight: 600; color: var(--accent); }
            .col-creator { white-space: nowrap; width: 110px; }
            .col-status { white-space: nowrap; width: 140px; }
            .col-date { white-space: nowrap; width: 130px; color: var(--muted); font-size: 13px; }
            .col-reason { max-width: 200px; white-space: normal; word-wrap: break-word; }
            .col-actions { white-space: nowrap; }
            .table-card { overflow-x: auto; -webkit-overflow-scrolling: touch; }
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
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Phiếu nhập kho</h1>
                    <span class="crumb">/ Kho / Phiếu nhập</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/import-receipt?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu nhập
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho · Phiếu nhập</div>
                            <h2 class="page-title">Danh sách phiếu nhập kho</h2>
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

                    <form method="get" action="${pageContext.request.contextPath}/import-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, người tạo" autocomplete="off" />
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
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/import-receipt?action=list'">
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
                                        <tr><td colspan="8" style="text-align:center; padding:20px; color:var(--muted);">Không có phiếu nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${receiptList}">
                                            <tr data-id="${r.receiptId}">
                                                <td><span class="receipt-code"><c:out value="${r.receiptCode}"/></span></td>
                                                <td>${r.warehouseName}</td>
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
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${r.receiptId}">
                                                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                                <span class="label">Chi tiết</span>
                                                            </a>
                                                            <c:if test="${(r.status == 'NEEDS_REVISION' || r.status == 'DRAFT') && r.createdBy == sessionScope.loggedUser.id}">
                                                                <div class="dropdown-divider"></div>
                                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/import-receipt?action=edit&id=${r.receiptId}">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                                    <span class="label">Sửa</span>
                                                                </a>
                                                            </c:if>
                                                            <c:if test="${canApproveReceipt && r.status == 'PENDING'}">
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item approve" onclick="openApproveModal(${r.receiptId}, '<c:out value="${fn:escapeXml(r.receiptCode)}"/>')" type="button">
                                                                    <svg viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5"/></svg>
                                                                    <span class="label">Duyệt</span>
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${canRejectReceipt && r.status == 'PENDING'}">
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item reject" onclick="openRejectModal(${r.receiptId}, '<c:out value="${fn:escapeXml(r.receiptCode)}"/>')" type="button">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 9v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                                                    <span class="label">Từ chối</span>
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${canApproveReceipt && r.status == 'PENDING'}">
                                                                <div class="dropdown-divider"></div>
                                                                <button class="dropdown-item revision" onclick="openRevisionModal(${r.receiptId}, '<c:out value="${fn:escapeXml(r.receiptCode)}"/>')" type="button">
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

        <div class="modal-host" id="revisionModal">
            <div class="modal-card">
                <h3>Yêu cầu chỉnh sửa</h3>
                <div class="modal-sub">Gửi phiếu <strong id="revisionReceiptCode"></strong> lại cho nhân viên tạo phiếu kèm lý do để chỉnh sửa và gửi lại.</div>
                <form method="POST" action="${pageContext.request.contextPath}/import-receipt" id="revisionForm">
                    <input type="hidden" name="action" value="requestRevision" />
                    <input type="hidden" name="id" id="revisionReceiptId" value="" />
                    <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                    <textarea name="reason" id="revisionReason" placeholder="Mô tả chi tiết phần cần chỉnh sửa..." required></textarea>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeRevisionModal()">Huỷ</button>
                        <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-host" id="approveModal">
            <div class="modal-card">
                <h3>Duyệt phiếu nhập</h3>
                <div class="modal-sub">Xác nhận duyệt phiếu <strong id="approveReceiptCode"></strong>? Hệ thống sẽ cập nhật tồn kho tương ứng.</div>
                <form method="POST" action="${pageContext.request.contextPath}/import-receipt" id="approveForm">
                    <input type="hidden" name="action" value="approve" />
                    <input type="hidden" name="id" id="approveReceiptId" value="" />
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeApproveModal()">Huỷ</button>
                        <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-host" id="rejectModal">
            <div class="modal-card">
                <h3>Từ chối phiếu nhập</h3>
                <div class="modal-sub">Phiếu <strong id="rejectReceiptCode"></strong> sẽ bị huỷ và không cập nhật tồn kho. Hành động này không thể hoàn tác.</div>
                <form method="POST" action="${pageContext.request.contextPath}/import-receipt" id="rejectForm">
                    <input type="hidden" name="action" value="reject" />
                    <input type="hidden" name="id" id="rejectReceiptId" value="" />
                    <label>Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                    <textarea name="reason" id="rejectReason" placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, hàng không đạt chất lượng..." required></textarea>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeRejectModal()">Huỷ</button>
                        <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                    </div>
                </form>
            </div>
        </div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <style>
            .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 200; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-card .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; line-height: 1.5; }
            .modal-card label { display: block; font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 6px; }
            .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; min-height: 80px; resize: vertical; }
            .modal-card textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
            .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
        </style>
        <script>
            function openApproveModal(receiptId, receiptCode) {
                document.getElementById('approveReceiptId').value = receiptId;
                document.getElementById('approveReceiptCode').textContent = receiptCode || '';
                var m = document.getElementById('approveModal'); m.classList.add('show');
            }
            function closeApproveModal() { var m = document.getElementById('approveModal'); if (m) m.classList.remove('show'); }
            function openRejectModal(receiptId, receiptCode) {
                document.getElementById('rejectReceiptId').value = receiptId;
                document.getElementById('rejectReceiptCode').textContent = receiptCode || '';
                document.getElementById('rejectReason').value = '';
                var m = document.getElementById('rejectModal'); m.classList.add('show');
                setTimeout(function () { document.getElementById('rejectReason').focus(); }, 50);
            }
            function closeRejectModal() { var m = document.getElementById('rejectModal'); if (m) m.classList.remove('show'); }
            function openRevisionModal(receiptId, receiptCode) {
                document.getElementById('revisionReceiptId').value = receiptId;
                document.getElementById('revisionReceiptCode').textContent = receiptCode || '';
                document.getElementById('revisionReason').value = '';
                var m = document.getElementById('revisionModal'); m.classList.add('show');
                setTimeout(function () { document.getElementById('revisionReason').focus(); }, 50);
            }
            function closeRevisionModal() { var m = document.getElementById('revisionModal'); if (m) m.classList.remove('show'); }

            (function () {
                ['approveModal', 'rejectModal', 'revisionModal'].forEach(function (id) {
                    var modal = document.getElementById(id);
                    if (!modal) return;
                    modal.addEventListener('click', function (e) {
                        if (e.target === modal) modal.classList.remove('show');
                    });
                });
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
                    }
                });
                var rejectForm = document.getElementById('rejectForm');
                if (rejectForm) {
                    rejectForm.addEventListener('submit', function (e) {
                        var ta = document.getElementById('rejectReason');
                        if (ta && ta.value.trim() === '') { e.preventDefault(); ta.focus(); alert('Vui lòng nhập lý do từ chối.'); }
                    });
                }
                var revisionForm = document.getElementById('revisionForm');
                if (revisionForm) {
                    revisionForm.addEventListener('submit', function (e) {
                        var ta = document.getElementById('revisionReason');
                        if (ta && ta.value.trim() === '') { e.preventDefault(); ta.focus(); alert('Vui lòng nhập lý do yêu cầu chỉnh sửa.'); }
                    });
                }
            })();

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
        </script>
    </body>
</html>