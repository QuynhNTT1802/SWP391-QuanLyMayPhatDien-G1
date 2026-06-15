<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu nhập — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <style>
            a.btn, a.back-link { text-decoration: none; }
            .product-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
            .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
            .product-table th { font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600; background: var(--surface-2); letter-spacing: 0.04em; }
            .product-table td { font-size: 13px; }
            .product-table tbody tr:hover { background: var(--surface-2); }
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
            .hero-avatar { background: oklch(58% 0.16 145); }
            .alert { display: flex; align-items: center; gap: 10px; padding: 10px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; }
            .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
            .alert-error { background: var(--danger-soft); color: var(--danger); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
            .alert-warn { background: var(--warn-soft); color: var(--warn); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }
            .action-bar-top { display: flex; gap: 8px; flex-wrap: wrap; padding: 12px 16px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-bottom: 16px; }
            .tabs { display: flex; gap: 2px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
            .tab { padding: 10px 18px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 13px; font-weight: 600; font-family: var(--font-ui); border-bottom: 2px solid transparent; margin-bottom: -1px; }
            .tab:hover { color: var(--fg); }
            .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
            .tab-panel { display: none; }
            .tab-panel.active { display: block; }
            .note-soft { font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; line-height: 1.55; padding: 14px; background: var(--surface-2); border-radius: var(--radius-sm); }
            .history-item { display: grid; grid-template-columns: 36px 1fr; gap: 12px; padding: 12px 0; border-bottom: 1px dashed var(--border); }
            .history-item:last-child { border-bottom: 0; }
            .history-icon { width: 32px; height: 32px; border-radius: 50%; display: grid; place-items: center; flex-shrink: 0; }
            .history-icon svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 2; }
            .history-icon.create { background: var(--info-soft); color: var(--info); }
            .history-icon.approve { background: var(--accent-soft); color: var(--accent); }
            .history-icon.reject { background: var(--danger-soft); color: var(--danger); }
            .history-icon.revision { background: var(--warn-soft); color: var(--warn); }
            .history-body { line-height: 1.4; }
            .history-title { font-size: 13px; font-weight: 600; color: var(--fg); }
            .history-meta { font-size: 11.5px; color: var(--muted); margin-top: 2px; }
            .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
            .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
            .modal-card .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; line-height: 1.5; }
            .modal-card label { display: block; font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 6px; }
            .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; min-height: 80px; resize: vertical; }
            .modal-card textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
            .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
            .action-badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; white-space: nowrap; }
            .action-badge.action-create { background: #d4edda; color: #155724; }
            .action-badge.action-update { background: #fff3cd; color: #856404; }
            .action-badge.action-approve { background: #cce5ff; color: #004085; }
            .action-badge.action-reject { background: #f8d7da; color: #721c24; }
            .action-badge.action-revision { background: #fff3cd; color: #856404; }
            .action-badge.action-default { background: #e2e3e5; color: #383d41; }
            .history-card { border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; background: var(--bg); }
            .history-table { width: 100%; border-collapse: collapse; margin-top: 4px; }
            .history-table th { padding: 10px 14px; font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em; background: var(--surface-2); text-align: left; border-bottom: 2px solid var(--border); }
            .history-table td { padding: 11px 14px; font-size: 13px; color: var(--fg); border-bottom: 1px solid var(--border); vertical-align: middle; }
            .history-table tbody tr:hover { background: var(--surface-2); }
            .history-table .detail-cell { color: var(--fg-soft); line-height: 1.55; max-width: 360px; }
            .history-table .mono { font-family: var(--font-mono); font-size: 12px; color: var(--fg); }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu nhập</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / <span><c:out value="${receipt.receiptCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                        <c:if test="${(receipt.status == 'NEEDS_REVISION' || receipt.status == 'DRAFT') && isOwner}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/import-receipt?action=edit&id=${receipt.receiptId}">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Chỉnh sửa
                            </a>
                        </c:if>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/import-receipt">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <div class="hero">
                        <div class="hero-avatar">N</div>
                        <div class="hero-body">
                            <h2 class="hero-name">
                                <c:out value="${receipt.receiptCode}"/>
                                <c:choose>
                                    <c:when test="${receipt.status == 'DRAFT'}"><span class="status-pill" style="background: var(--info-soft); color: var(--info);"><span class="pdot"></span>Bản nháp</span></c:when>
                                    <c:when test="${receipt.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${receipt.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Yêu cầu chỉnh sửa</span></c:when>
                                    <c:when test="${receipt.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                                    <c:when test="${receipt.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                                    <c:otherwise><span class="status-pill"><c:out value="${receipt.status}"/></span></c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="hero-meta">
                                <span>Phiếu nhập kho</span>
                                <span class="sep">·</span>
                                <span class="id">#${receipt.receiptId}</span>
                                <span class="sep">·</span>
                                <span>Ngày tạo: ${receipt.createdAt}</span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill warehouse"><span class="pdot"></span><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}" style="color:inherit;text-decoration:underline;"><c:out value="${receipt.warehouseName}"/></a></span>
                                <span class="pill status-active"><span class="pdot"></span>Người tạo: <c:out value="${receipt.createdByName}"/></span>
                                <c:if test="${not empty receipt.approvedByName}">
                                    <span class="pill role-admin"><span class="pdot"></span>Người duyệt: <c:out value="${receipt.approvedByName}"/></span>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <c:if test="${receipt.status == 'PENDING' && isManager}">
                        <div class="action-bar-top">
                            <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Duyệt phiếu
                            </button>
                            <button type="button" class="btn" onclick="openModal('revisionModal')">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Yêu cầu chỉnh sửa
                            </button>
                            <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                Từ chối
                            </button>
                        </div>
                    </c:if>

                    <div class="section" style="padding: 18px 22px;">
                        <div class="tabs">
                            <button type="button" class="tab active" data-tab="info">Thông tin chung</button>
                            <button type="button" class="tab" data-tab="products">Chi tiết dòng hàng</button>
                            <button type="button" class="tab" data-tab="history">Lịch sử cập nhật</button>
                        </div>

                        <div class="tab-panel active" id="tab-info">
                            <div class="info-grid">
                                <div class="info-field">
                                    <div class="info-label">Loại phiếu</div>
                                    <div class="info-value">Nhập kho</div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Kho</div>
                                    <div class="info-value"><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${receipt.warehouseId}"><c:out value="${receipt.warehouseName}"/></a></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Người tạo</div>
                                    <div class="info-value"><c:out value="${receipt.createdByName}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Ngày tạo</div>
                                    <div class="info-value mono">${receipt.createdAt}</div>
                                </div>
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
                                            <c:when test="${receipt.status == 'DRAFT'}"><span class="status-pill" style="background: var(--info-soft); color: var(--info);"><span class="pdot"></span>Bản nháp</span></c:when>
                                            <c:when test="${receipt.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                            <c:when test="${receipt.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Yêu cầu chỉnh sửa</span></c:when>
                                            <c:when test="${receipt.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                                            <c:when test="${receipt.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                                            <c:otherwise><span class="status-pill"><c:out value="${receipt.status}"/></span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${not empty receipt.note}">
                                <div style="margin-top: 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú</div>
                                    <div class="note-soft"><c:out value="${receipt.note}"/></div>
                                </div>
                            </c:if>
                        </div>

                        <div class="tab-panel" id="tab-history">
                            <c:if test="${not empty receipt.reasonName}">
                                <div style="margin-bottom: 18px; padding: 12px 16px; background: var(--warn-soft); border-radius: var(--radius-sm);">
                                    <div style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:4px;">Lý do</div>
                                    <span class="status-pill status-pending"><span class="pdot"></span><c:out value="${receipt.reasonName}"/></span>
                                    <c:if test="${not empty receipt.reasonNote}">
                                        <div style="margin-top:4px;font-size:12.5px;color:var(--fg);"><c:out value="${receipt.reasonNote}"/></div>
                                    </c:if>
                                </div>
                            </c:if>
                            <div class="table-card history-card">
                                <div class="result-summary" style="margin-bottom:8px;">Tìm thấy <strong>${totalHistory}</strong> bản ghi</div>
                                <table class="history-table">
                                    <thead><tr>
                                        <th style="width:150px;">Thời gian</th>
                                        <th style="width:180px;">Người thực hiện</th>
                                        <th style="width:140px;">Hành động</th>
                                        <th>Chi tiết thay đổi</th>
                                    </tr></thead>
                                    <tbody>
                                    <c:choose>
                                        <c:when test="${empty receiptHistory}">
                                            <tr><td colspan="4"><div class="empty-state"><strong>Không có bản ghi nào</strong></div></td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="h" items="${receiptHistory}">
                                                <tr>
                                                    <td class="mono"><fmt:formatDate value="${h.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td><c:out value="${h.username}"/></td>
                                                    <td>
                                                        <span class="action-badge action-<c:choose>
                                                            <c:when test="${h.action == 'CREATE'}">create</c:when>
                                                            <c:when test="${h.action == 'UPDATE'}">update</c:when>
                                                            <c:when test="${h.action == 'APPROVE'}">approve</c:when>
                                                            <c:when test="${h.action == 'REJECT'}">reject</c:when>
                                                            <c:when test="${h.action == 'REVISION'}">revision</c:when>
                                                            <c:otherwise>default</c:otherwise>
                                                        </c:choose>">
                                                        <c:choose>
                                                            <c:when test="${h.action == 'CREATE'}">Tạo phiếu</c:when>
                                                            <c:when test="${h.action == 'UPDATE'}">Cập nhật</c:when>
                                                            <c:when test="${h.action == 'APPROVE'}">Duyệt</c:when>
                                                            <c:when test="${h.action == 'REJECT'}">Từ chối</c:when>
                                                            <c:when test="${h.action == 'REVISION'}">Yêu cầu sửa</c:when>
                                                            <c:otherwise>${h.action}</c:otherwise>
                                                        </c:choose></span>
                                                    </td>
                                                    <td class="detail-cell"><c:out value="${h.details}"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="tab-panel" id="tab-products">
                            <c:if test="${not empty receipt.details and fn:length(receipt.details) > 10}">
                                <div style="margin-bottom: 8px; font-size: 12px; color: var(--muted);" id="detailCount"></div>
                            </c:if>
                            <table class="product-table" id="detailTable">
                                <thead>
                                    <tr>
                                        <th style="width: 40px;">#</th>
                                        <th>Máy phát / Hãng</th>
                                        <th>Serial</th>
                                        <th style="width: 60px;">SL</th>
                                        <th style="width: 140px;">Đơn giá</th>
                                        <th style="width: 140px;">Thành tiền</th>
                                        <th>Ghi chú</th>
                                    </tr>
                                </thead>
                                <tbody id="detailBody">
                                    <c:choose>
                                        <c:when test="${empty receipt.details}">
                                            <tr><td colspan="7" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="grandTotal" value="0" />
                                            <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                                <c:set var="subtotal" value="${d.unitPrice * d.quantity}" />
                                                <c:set var="grandTotal" value="${grandTotal + subtotal}" />
                                                <tr class="detail-row">
                                                    <td class="mono">${st.index + 1}</td>
                                                    <td><strong><a href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${d.generatorId}"><c:out value="${d.generatorModel}"/></a></strong> <span style="color: var(--muted);"><c:out value="${d.generatorBrand}"/></span></td>
                                                    <td class="mono"><c:out value="${d.serialNumber}"/></td>
                                                    <td class="mono"><fmt:formatNumber value="${d.quantity}"/></td>
                                                    <td class="mono"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</td>
                                                    <td class="mono" style="font-weight: 600;"><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</td>
                                                    <td><c:out value="${d.note}"/></td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="5" style="text-align: right; padding: 12px; font-weight: 700; border-top: 2px solid var(--border);">Tổng cộng:</td>
                                        <td class="mono" style="padding: 12px; font-weight: 700; border-top: 2px solid var(--border);"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</td>
                                        <td style="border-top: 2px solid var(--border);"></td>
                                    </tr>
                                </tfoot>
                            </table>
                            <c:if test="${not empty receipt.details and fn:length(receipt.details) > 10}">
                                <div class="detail-pager" id="detailPagination">
                                    <button type="button" class="btn" id="prevDetailPage">‹ Trước</button>
                                    <span class="page-info" id="detailPageInfo"></span>
                                    <button type="button" class="btn" id="nextDetailPage">Sau ›</button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <c:if test="${receipt.status == 'PENDING' && isManager}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu nhập</h3>
                    <div class="modal-sub">Xác nhận duyệt phiếu <strong><c:out value="${receipt.receiptCode}"/></strong>? Hệ thống sẽ cập nhật tồn kho tương ứng.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/import-receipt?action=approve" id="approveForm">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Huỷ</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối phiếu</h3>
                    <div class="modal-sub">Phiếu sẽ bị huỷ và không cập nhật tồn kho. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/import-receipt?action=reject">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="reason" required placeholder="Ví dụ: Sai số lượng, thiếu chứng từ, hàng không đạt chất lượng..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="modal-host" id="revisionModal">
                <div class="modal-card">
                    <h3>Yêu cầu chỉnh sửa</h3>
                    <div class="modal-sub">Gửi phiếu lại cho nhân viên tạo phiếu kèm lý do để chỉnh sửa và gửi lại.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/import-receipt?action=requestRevision" id="revisionFormDetail">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <label>Lý do yêu cầu chỉnh sửa <span style="color:var(--danger)">*</span></label>
                        <textarea name="reason" id="revisionReasonDetail" required placeholder="Mô tả chi tiết phần cần chỉnh sửa..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('revisionModal')">Huỷ</button>
                            <button type="submit" class="btn btn-warn">Gửi yêu cầu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

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
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            (function () {
                var tabs = document.querySelectorAll('.tab');
                var panels = document.querySelectorAll('.tab-panel');
                tabs.forEach(function (t) {
                    t.addEventListener('click', function () {
                        var key = t.getAttribute('data-tab');
                        tabs.forEach(function (x) { x.classList.remove('active'); });
                        panels.forEach(function (p) { p.classList.remove('active'); });
                        t.classList.add('active');
                        var panel = document.getElementById('tab-' + key);
                        if (panel) panel.classList.add('active');
                    });
                });
            })();

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

            function openModal(id) { var m = document.getElementById(id); if (m) m.classList.add('show'); }
            function closeModal(id) { var m = document.getElementById(id); if (m) m.classList.remove('show'); }
            document.querySelectorAll('.modal-host').forEach(function (m) {
                m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
            });
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    document.querySelectorAll('.modal-host.show').forEach(function (m) { m.classList.remove('show'); });
                }
            });
        </script>
    </body>
</html>