<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết phiếu — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        .product-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
        .product-table th { font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600; background: var(--surface-2); letter-spacing: 0.04em; }
        .product-table td { font-size: 13px; }
        .product-table tbody tr:hover { background: var(--surface-2); }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-revision { background: #ffe0b2; color: #b15c00; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        [data-theme="dark"] .status-pending { background: var(--warn-soft); color: var(--warn); }
        [data-theme="dark"] .status-revision { background: var(--warn-soft); color: var(--warn); }
        [data-theme="dark"] .status-completed { background: var(--accent-soft); color: var(--accent); }
        [data-theme="dark"] .status-cancelled { background: var(--danger-soft); color: var(--danger); }
        .hero-avatar.import { background: oklch(58% 0.16 145); }
        .hero-avatar.export { background: oklch(58% 0.16 250); }
        .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
        .alert-success { background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }
        .alert-error { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
        .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
        .action-row { display: flex; gap: 10px; flex-wrap: wrap; align-items: stretch; }
        .action-card { background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 14px; flex: 1; min-width: 280px; display: flex; flex-direction: column; }
        .action-card h4 { margin: 0 0 4px; font-size: 13px; font-weight: 700; color: var(--fg); }
        .action-card .action-sub { font-size: 11.5px; color: var(--muted); margin-bottom: 10px; line-height: 1.5; flex: 1; }
        .action-card form { display: flex; gap: 8px; flex-wrap: wrap; }
        .action-card input[type="text"] { flex: 1; min-width: 160px; padding: 7px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); }
        .action-card input[type="text"]:focus { outline: none; border-color: var(--accent); }
        .btn-warn { background: var(--warn); color: white; border-color: var(--warn); }
        .btn-warn:hover { filter: brightness(1.05); }
        .btn-success { background: var(--accent); color: white; border-color: var(--accent); }
        .btn-success:hover { filter: brightness(1.05); }
        .btn-danger { background: var(--danger); color: white; border-color: var(--danger); }
        .btn-danger:hover { filter: brightness(1.05); }
        .detail-pager { display: flex; justify-content: flex-end; gap: 8px; padding: 12px 0 0; align-items: center; }
        .detail-pager .page-info { font-size: 12px; color: var(--muted); font-family: var(--font-mono); }
        .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết phiếu</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/receipt">Phiếu nhập/xuất</a> / <span><c:out value="${receipt.receiptCode}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <c:if test="${receipt.status == 'NEEDS_REVISION' && isOwner}">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/receipt?action=edit&id=${receipt.receiptId}">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                        Chỉnh sửa
                    </a>
                </c:if>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/receipt">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">
                    <svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                    <span>
                        <c:choose>
                            <c:when test="${param.msg == 'approved'}">Đã duyệt phiếu thành công.</c:when>
                            <c:when test="${param.msg == 'rejected'}">Đã từ chối phiếu.</c:when>
                            <c:when test="${param.msg == 'revisionRequested'}">Đã gửi yêu cầu chỉnh sửa cho nhân viên tạo phiếu.</c:when>
                            <c:otherwise><c:out value="${param.msg}"/></c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <span><c:out value="${error}"/></span>
                </div>
            </c:if>

            <div class="hero">
                <div class="hero-avatar ${receipt.receiptType == 'IMPORT' ? 'import' : 'export'}">
                    <c:choose>
                        <c:when test="${receipt.receiptType == 'IMPORT'}">N</c:when>
                        <c:otherwise>X</c:otherwise>
                    </c:choose>
                </div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${receipt.receiptCode}"/>
                        <c:choose>
                            <c:when test="${receipt.status == 'PENDING_RECONCILIATION'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                            <c:when test="${receipt.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Cần chỉnh sửa</span></c:when>
                            <c:when test="${receipt.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                            <c:when test="${receipt.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                            <c:otherwise><span class="status-pill"><c:out value="${receipt.status}"/></span></c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="hero-meta">
                        <span>${receipt.receiptType == 'IMPORT' ? 'Phiếu nhập kho' : 'Phiếu xuất kho'}</span>
                        <span class="sep">·</span>
                        <span class="id">#${receipt.receiptId}</span>
                        <span class="sep">·</span>
                        <span>Ngày tạo: ${receipt.createdAt}</span>
                    </div>
                    <div class="hero-pills">
                        <span class="pill warehouse"><span class="pdot"></span><c:out value="${receipt.warehouseName}"/></span>
                        <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${receipt.createdByName}"/></span>
                        <c:if test="${not empty receipt.approvedByName}">
                            <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${receipt.approvedByName}"/></span>
                        </c:if>
                    </div>
                </div>
                <div class="hero-actions"></div>
            </div>

            <div class="layout">
                <div class="toc">
                    <a class="toc-item active" data-toc="info"><span class="toc-num">01</span><span>Thông tin phiếu</span></a>
                    <c:if test="${not empty receipt.note}">
                        <a class="toc-item" data-toc="note"><span class="toc-num">02</span><span>Ghi chú &amp; lịch sử</span></a>
                    </c:if>
                    <a class="toc-item" data-toc="products"><span class="toc-num"><c:choose><c:when test="${not empty receipt.note}">03</c:when><c:otherwise>02</c:otherwise></c:choose></span><span>Chi tiết dòng hàng</span></a>
                    <c:if test="${receipt.status == 'PENDING_RECONCILIATION' && isManager}">
                        <a class="toc-item" data-toc="actions"><span class="toc-num"><c:choose><c:when test="${not empty receipt.note}">04</c:when><c:otherwise>03</c:otherwise></c:choose></span><span>Hành động</span></a>
                    </c:if>
                    <div class="toc-meta">
                        <strong>#${receipt.receiptId}</strong><br>
                        Tạo: ${receipt.createdAt}<br>
                        <c:if test="${not empty receipt.approvedAt}">Duyệt: ${receipt.approvedAt}</c:if>
                    </div>
                </div>

                <div class="content">
                    <section class="section" id="info">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="section-title">Phiếu ${receipt.receiptType == 'IMPORT' ? 'nhập' : 'xuất'} kho &amp; tiến trình</h3>
                            </div>
                            <c:if test="${not empty receipt.approvedAt}">
                                <div class="section-update">Duyệt ${receipt.approvedAt}</div>
                            </c:if>
                        </div>
                        <div class="info-grid">
                            <div class="info-field">
                                <div class="info-label">Loại phiếu</div>
                                <div class="info-value">${receipt.receiptType == 'IMPORT' ? 'Nhập kho' : 'Xuất kho'}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Kho</div>
                                <div class="info-value"><c:out value="${receipt.warehouseName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Người tạo</div>
                                <div class="info-value"><c:out value="${receipt.createdByName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Ngày tạo</div>
                                <div class="info-value mono">${receipt.createdAt}</div>
                            </div>
                            <c:if test="${not empty receipt.orderCode}">
                                <div class="info-field">
                                    <div class="info-label">Đơn hàng</div>
                                    <div class="info-value mono"><c:out value="${receipt.orderCode}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Khách hàng</div>
                                    <div class="info-value"><c:out value="${receipt.customerName}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty receipt.approvedByName}">
                                <div class="info-field">
                                    <div class="info-label">Người duyệt</div>
                                    <div class="info-value"><c:out value="${receipt.approvedByName}"/></div>
                                </div>
                            </c:if>
                            <c:if test="${not empty receipt.approvedAt}">
                                <div class="info-field">
                                    <div class="info-label">Ngày duyệt</div>
                                    <div class="info-value mono">${receipt.approvedAt}</div>
                                </div>
                            </c:if>
                            <div class="info-field">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${receipt.status == 'PENDING_RECONCILIATION'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                        <c:when test="${receipt.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Cần chỉnh sửa</span></c:when>
                                        <c:when test="${receipt.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                                        <c:when test="${receipt.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                                        <c:otherwise><span class="status-pill"><c:out value="${receipt.status}"/></span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </section>

                    <c:if test="${not empty receipt.note}">
                        <section class="section" id="note">
                            <div class="section-head">
                                <div>
                                    <div class="section-num">02 — GHI CHÚ &amp; LỊCH SỬ</div>
                                    <h3 class="section-title">Ghi chú nội bộ</h3>
                                </div>
                            </div>
                            <c:if test="${receipt.status == 'NEEDS_REVISION'}">
                                <div class="alert alert-warn" style="margin-bottom: 12px;">
                                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                                    <span>Phiếu này đang chờ chỉnh sửa từ nhân viên tạo phiếu.</span>
                                </div>
                            </c:if>
                            <c:if test="${receipt.status == 'CANCELLED'}">
                                <div class="alert alert-error" style="margin-bottom: 12px;">
                                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                    <span>Phiếu đã bị từ chối.</span>
                                </div>
                            </c:if>
                            <div class="note-soft"><c:out value="${receipt.note}"/></div>
                        </section>
                    </c:if>

                    <section class="section" id="products">
                        <div class="section-head">
                            <div>
                                <div class="section-num"><c:choose><c:when test="${not empty receipt.note}">03</c:when><c:otherwise>02</c:otherwise></c:choose> — CHI TIẾT DÒNG HÀNG</div>
                                <h3 class="section-title">Danh sách máy phát điện</h3>
                            </div>
                            <c:if test="${not empty receipt.details and fn:length(receipt.details) > 10}">
                                <span class="section-update" id="detailCount"></span>
                            </c:if>
                        </div>
                        <table class="product-table" id="detailTable">
                            <thead>
                                <tr>
                                    <th style="width: 40px;">#</th>
                                    <th>Máy phát / Hãng</th>
                                    <th>Serial</th>
                                    <th class="text-center" style="width: 80px;">SL</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${empty receipt.details}">
                                        <tr><td colspan="5" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                            <tr class="detail-row">
                                                <td class="mono">${st.index + 1}</td>
                                                <td><strong><c:out value="${d.generatorModel}"/></strong> <span style="color: var(--muted);"><c:out value="${d.generatorBrand}"/></span></td>
                                                <td class="mono"><c:out value="${d.serialNumber}"/></td>
                                                <td class="text-center">${d.quantity}</td>
                                                <td><c:out value="${d.note}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <c:if test="${not empty receipt.details and fn:length(receipt.details) > 10}">
                            <div class="detail-pager" id="detailPagination">
                                <button type="button" class="btn" id="prevDetailPage">‹ Trước</button>
                                <span class="page-info" id="detailPageInfo"></span>
                                <button type="button" class="btn" id="nextDetailPage">Sau ›</button>
                            </div>
                        </c:if>
                    </section>

                    <c:if test="${receipt.status == 'PENDING_RECONCILIATION' && isManager}">
                        <section class="section" id="actions">
                            <div class="section-head">
                                <div>
                                    <div class="section-num"><c:choose><c:when test="${not empty receipt.note}">04</c:when><c:otherwise>03</c:otherwise></c:choose> — HÀNH ĐỘNG</div>
                                    <h3 class="section-title">Duyệt, từ chối hoặc yêu cầu chỉnh sửa</h3>
                                </div>
                            </div>
                            <div class="action-row">
                                <div class="action-card">
                                    <h4>Duyệt phiếu</h4>
                                    <div class="action-sub">Hệ thống sẽ cập nhật tồn kho ngay sau khi duyệt. Không thể hoàn tác.</div>
                                    <form method="POST" action="${pageContext.request.contextPath}/receipt?action=approve">
                                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                                        <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận duyệt phiếu này?')">
                                            <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                            Duyệt phiếu
                                        </button>
                                    </form>
                                </div>
                                <div class="action-card">
                                    <h4>Yêu cầu chỉnh sửa</h4>
                                    <div class="action-sub">Gửi phiếu lại cho nhân viên tạo kèm lý do để chỉnh sửa và gửi lại.</div>
                                    <form method="POST" action="${pageContext.request.contextPath}/receipt?action=requestRevision">
                                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                                        <input type="text" name="reason" placeholder="Lý do yêu cầu chỉnh sửa..." required />
                                        <button type="submit" class="btn btn-warn" onclick="return confirm('Yêu cầu nhân viên chỉnh sửa phiếu này?')">
                                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                            Gửi yêu cầu
                                        </button>
                                    </form>
                                </div>
                                <div class="action-card">
                                    <h4>Từ chối phiếu</h4>
                                    <div class="action-sub">Phiếu sẽ bị huỷ và không cập nhật tồn kho. Không thể hoàn tác.</div>
                                    <form method="POST" action="${pageContext.request.contextPath}/receipt?action=reject">
                                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                                        <input type="text" name="reason" placeholder="Lý do từ chối..." required />
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận từ chối phiếu này?')">
                                            <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                            Từ chối
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </section>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
(function () {
    var rows = document.querySelectorAll('#detailBody .detail-row');
    if (rows.length <= 10) return;
    var pageSize = 10;
    var current = 1;
    var totalPages = Math.ceil(rows.length / pageSize);
    var info = document.getElementById('detailPageInfo');
    var count = document.getElementById('detailCount');
    var prevBtn = document.getElementById('prevDetailPage');
    var nextBtn = document.getElementById('nextDetailPage');

    function render() {
        rows.forEach(function (r, i) {
            var page = Math.floor(i / pageSize) + 1;
            r.style.display = (page === current) ? '' : 'none';
        });
        info.textContent = 'Trang ' + current + ' / ' + totalPages;
        if (count) count.textContent = '(' + rows.length + ' dòng)';
        prevBtn.disabled = current === 1;
        nextBtn.disabled = current === totalPages;
    }
    prevBtn.addEventListener('click', function () { if (current > 1) { current--; render(); } });
    nextBtn.addEventListener('click', function () { if (current < totalPages) { current++; render(); } });
    render();
})();

(function () {
    var items = document.querySelectorAll('.toc-item');
    items.forEach(function (it) {
        var key = it.getAttribute('data-toc');
        var sec = document.getElementById(key);
        it.addEventListener('click', function (e) {
            e.preventDefault();
            items.forEach(function (x) { x.classList.remove('active'); });
            it.classList.add('active');
            if (sec) sec.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    });
})();
</script>
</body>
</html>
