<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        .cust-card {
            display: flex; gap: 10px; align-items: center;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm); padding: 8px 12px;
            margin-top: 4px;
            width: fit-content;
        }
        .cust-card-avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: var(--accent);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 700; font-size: 13px; flex-shrink: 0;
        }
        .cust-card-body { flex: 1; }
        .cust-card-name { font-size: 13px; font-weight: 700; color: var(--fg); margin-bottom: 2px; }
        .cust-card-rows { display: flex; flex-wrap: wrap; gap: 4px 12px; }
        .cust-card-row { font-size: 11.5px; color: var(--muted); display: flex; gap: 4px; align-items: center; }
        .cust-card-row svg { opacity: 0.6; width: 11px; height: 11px; }

        a.btn, a.back-link { text-decoration: none; }
        .product-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
        .product-table th { font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600; background: var(--surface-2); letter-spacing: 0.04em; }
        .product-table td { font-size: 13px; }
        .product-table tbody tr:hover { background: var(--surface-2); }
        .text-center { text-align: center; }
        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-pending { background: #fef3c7; color: #d97706; }
        .status-revision { background: #fee2e2; color: #dc2626; }
        .status-completed { background: #d1fae5; color: #059669; }
        [data-theme="dark"] .status-pending { background: var(--warn-soft); color: var(--warn); }
        [data-theme="dark"] .status-revision { background: var(--danger-soft); color: var(--danger); }
        [data-theme="dark"] .status-completed { background: var(--accent-soft); color: var(--accent); }
        .hero-avatar { background: oklch(58% 0.16 250); }

        .action-bar-bottom { display: flex; gap: 8px; flex-wrap: wrap; padding: 14px 18px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-top: 16px; position: sticky; bottom: 16px; z-index: 10; box-shadow: 0 -4px 16px rgba(0,0,0,0.08); }
        .btn-warn { background: var(--warn); color: white; border-color: var(--warn); }
        .btn-success { background: var(--accent); color: white; border-color: var(--accent); }
        .btn-danger { background: var(--danger); color: white; border-color: var(--danger); }

        .tabs { display: flex; gap: 2px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
        .tab { padding: 10px 18px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 13px; font-weight: 600; font-family: var(--font-ui); border-bottom: 2px solid transparent; margin-bottom: -1px; }
        .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }
        
        /* Customer Search UI */
        .cust-search-wrap { position: relative; margin-top: 6px; }
        .cust-dropdown {
            position: absolute; top: calc(100% + 4px); left: 0; right: 0;
            background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12); z-index: 50;
            max-height: 240px; overflow-y: auto; display: none;
        }
        .cust-dropdown.show { display: block; }
        .cust-option {
            padding: 10px 14px; cursor: pointer; font-size: 13px; border-bottom: 1px solid var(--border);
            display: flex; flex-direction: column; gap: 2px;
        }
        .cust-option:last-child { border-bottom: none; }
        .cust-option:hover { background: var(--surface-2); }
        .cust-option .cust-name { font-weight: 600; color: var(--fg); }
        .cust-clear {
            position: absolute; top: 10px; right: 12px;
            background: none; border: none; cursor: pointer; color: var(--muted); padding: 2px;
            border-radius: 4px;
        }
        .cust-clear:hover { color: var(--danger); background: var(--danger-soft); }
        .add-cust-btn {
            margin-top: 10px; font-size: 13px; gap: 6px;
            background: var(--surface-2); border-color: var(--border);
        }
        /* New customer modal */
        .nc-modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.5);
            display: none; align-items: center; justify-content: center;
            z-index: 2000; padding: 20px;
        }
        .nc-modal-overlay.show { display: flex; }
        .nc-modal {
            background: var(--bg); border: 1px solid var(--border);
            border-radius: var(--radius-md); width: 100%; max-width: 540px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.18); overflow: hidden;
        }
        .nc-modal-head {
            padding: 18px 22px 14px; border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center;
        }
        .nc-modal-head h3 { margin: 0; font-size: 16px; font-weight: 700; }
        .nc-modal-body { padding: 20px 22px; display: flex; flex-direction: column; gap: 14px; }
        .nc-field { display: flex; flex-direction: column; gap: 5px; }
        .nc-field label { font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; }
        .nc-field input, .nc-field select {
            width: 100%; padding: 9px 12px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg);
            color: var(--fg); font-size: 13px; font-family: var(--font-ui);
            box-sizing: border-box; transition: border-color 0.2s;
        }
        .nc-field input:focus, .nc-field select:focus { outline: none; border-color: var(--accent); }
        .nc-field input.error { border-color: var(--danger); }
        .nc-row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .nc-modal-foot {
            padding: 14px 22px; border-top: 1px solid var(--border);
            display: flex; justify-content: flex-end; gap: 8px; align-items: center;
        }
        .nc-error { font-size: 12px; color: var(--danger); display: none; }
        .nc-error.show { display: block; }

        
        .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
        .modal-host.show { display: flex; }
        .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
        .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
        .modal-card select { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; margin-bottom: 15px; margin-top: 10px; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Chi tiết đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / <span>${liquidation.liquidationCode}</span></span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>



            <c:if test="${liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'REJECTED_BY_CEO'}">
                <c:if test="${not empty liquidation.ceoFeedbackName}">
                    <div style="display: flex; gap: 10px; align-items: flex-start; background: var(--danger-soft); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); margin-bottom: 20px; color: var(--danger);">
                        <div>
                            <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Phản hồi từ Sếp (CEO)</div>
                            <div style="font-size: 13px;">${liquidation.ceoFeedbackName}</div>
                        </div>
                    </div>
                </c:if>
            </c:if>
            <c:if test="${liquidation.status == 'MANAGER_REQUEST_EDIT' or liquidation.status == 'REJECTED_BY_MANAGER'}">
                <c:if test="${not empty liquidation.managerFeedbackName}">
                    <div style="display: flex; gap: 10px; align-items: flex-start; background: var(--warn-soft); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); margin-bottom: 20px; color: var(--warn);">
                        <div>
                            <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Phản hồi từ Quản lý kho</div>
                            <div style="font-size: 13px;">${liquidation.managerFeedbackName}</div>
                        </div>
                    </div>
                </c:if>
            </c:if>

            <div class="tabs">
                <button type="button" class="tab active" onclick="switchTab('info')">Thông tin chi tiết</button>
                <button type="button" class="tab" onclick="switchTab('history')">Lịch sử xử lý (${totalHistory != null ? totalHistory : 0})</button>
            </div>

            <div id="tab-info" class="tab-panel active">
                <form action="${pageContext.request.contextPath}/liquidations" method="POST" id="mainForm">
                    <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />



                <div class="section" style="padding: 18px 22px; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Thông tin chung</h3>
                    <div class="info-grid">
                        <div class="info-field">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${liquidation.status == 'PENDING_MANAGER'}"><span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ Quản lý duyệt</span></c:when>
                                    <c:when test="${liquidation.status == 'PENDING_CEO'}"><span class="pill" style="color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft);"><span class="pdot" style="background: var(--purple);"></span>Chờ Sếp duyệt</span></c:when>
                                    <c:when test="${liquidation.status == 'APPROVED_BY_CEO'}"><span class="pill" style="color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft);"><span class="pdot" style="background: var(--accent);"></span>Đã duyệt (Đã xuất)</span></c:when>
                                    <c:when test="${liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT'}"><span class="pill" style="color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft);"><span class="pdot" style="background: var(--warn);"></span>Bị yêu cầu sửa</span></c:when>
                                    <c:when test="${liquidation.status == 'REJECTED_BY_MANAGER' or liquidation.status == 'REJECTED_BY_CEO'}"><span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Đã bị hủy</span></c:when>
                                    <c:otherwise><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>${liquidation.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Lý do thanh lý</div>
                            <div class="info-value">${liquidation.reasonName}</div>
                        </div>
                        <c:if test="${not empty liquidation.customerName and not (isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT'))}">
                        <div class="info-field">
                            <div class="info-label">Khách hàng nhận</div>
                            <div class="cust-card">
                                <div class="cust-card-avatar">
                                    ${fn:substring(liquidation.customerName,0,1)}
                                </div>
                                <div class="cust-card-body">
                                    <div class="cust-card-name">${liquidation.customerName}</div>
                                    <div class="cust-card-rows">
                                        <c:if test="${not empty liquidation.customerPhone}">
                                        <div class="cust-card-row">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 4 4.18 2 2 0 0 1 6 2h2.09a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 23 17v-.08z"/></svg>
                                            ${liquidation.customerPhone}
                                        </div>
                                        </c:if>
                                        <c:if test="${not empty liquidation.customerEmail}">
                                        <div class="cust-card-row">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,12 2,6"/></svg>
                                            ${liquidation.customerEmail}
                                        </div>
                                        </c:if>
                                        <c:if test="${not empty liquidation.customerAddress}">
                                        <div class="cust-card-row">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                            ${liquidation.customerAddress}
                                        </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </c:if>
                        <div class="info-field">
                            <div class="info-label">Kho hàng</div>
                            <div class="info-value">${liquidation.warehouseName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Người tạo</div>
                            <div class="info-value">${liquidation.createdByName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Ngày tạo</div>
                            <div class="info-value mono">${liquidation.createdAt}</div>
                        </div>
                    </div>
                </div>

                <c:if test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')}">
                <div class="section" style="padding: 18px 22px; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 12px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Thông tin Khách hàng</h3>
                    <p style="margin-bottom: 16px; color: var(--muted); font-size: 13px;">Vui lòng chọn hoặc thêm mới khách hàng mua thanh lý để làm cơ sở tạo phiếu xuất sau này.</p>
                    <div style="max-width: 400px;" id="managerCustomerArea">
                        <input type="hidden" name="customerId" id="customerIdHidden" value="${liquidation.customerId}" required/>
                        
                        <div class="cust-search-wrap" id="custSearchWrap" style="${not empty liquidation.customerId ? 'display:none;' : ''}">
                            <input type="text" id="custSearchInput" class="input" style="width:100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px;"
                                   placeholder="Nhập tên hoặc số điện thoại..."
                                   autocomplete="off" />
                            <div class="cust-dropdown" id="custDropdown"></div>
                        </div>
                        
                        <div class="cust-card" id="custCard" style="${not empty liquidation.customerId ? 'display:flex;' : 'display:none;'} width:100%;">
                            <div class="cust-card-avatar" id="custCardAvatar">${not empty liquidation.customerName ? fn:substring(liquidation.customerName,0,1) : ''}</div>
                            <div class="cust-card-body">
                                <div class="cust-card-name" id="custCardName">${liquidation.customerName}</div>
                                <div class="cust-card-rows">
                                    <div class="cust-card-row">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 4 4.18 2 2 0 0 1 6 2h2.09a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 23 17v-.08z"/></svg>
                                        <span id="custCardPhone">${liquidation.customerPhone}</span>
                                    </div>
                                    <div class="cust-card-row" id="custCardEmailRow" style="${empty liquidation.customerEmail ? 'display:none;' : ''}">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,12 2,6"/></svg>
                                        <span id="custCardEmail">${liquidation.customerEmail}</span>
                                    </div>
                                    <div class="cust-card-row" id="custCardAddrRow" style="${empty liquidation.customerAddress ? 'display:none;' : ''}">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                        <span id="custCardAddr">${liquidation.customerAddress}</span>
                                    </div>
                                </div>
                            </div>
                            <button type="button" class="cust-clear" onclick="clearCustomer()" title="Bỏ chọn">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                            </button>
                        </div>
                        
                        <button type="button" class="btn add-cust-btn" id="addNewCustBtn" onclick="openNewCustomerModal()" style="${not empty liquidation.customerId ? 'display:none;' : ''}">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                            Thêm khách hàng mới
                        </button>
                    </div>
                </div>
                </c:if>

                <div class="section" style="padding: 18px 22px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Danh sách máy phát điện</h3>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>Dòng máy</th>
                                    <th>Số Serial</th>
                                    <th>Giá gốc (VNĐ)</th>
                                    <th>Giá thanh lý (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${details}">
                                    <tr>
                                        <td><strong>${d.generatorModelName}</strong></td>
                                        <td class="mono">${d.serialNumber}</td>
                                        <td class="mono">${d.originalPrice}</td>
                                        <td>
                                            <input type="hidden" name="detailId" value="${d.liquidationDetailId}" />
                                            <c:choose>
                                                <c:when test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')}">
                                                    <input type="number" name="liquidationPrice" value="${d.liquidationPrice}" placeholder="Điền giá đề xuất..." required style="padding: 6px; width: 100%; border: 1px solid var(--border); border-radius: 4px;" />
                                                </c:when>
                                                <c:otherwise>
                                                    <strong class="mono">${d.liquidationPrice}</strong>
                                                    <input type="hidden" name="liquidationPrice" value="${d.liquidationPrice}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${(isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')) or (isCeo and liquidation.status == 'PENDING_CEO') or (isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT')}">
                        <div class="section" style="padding: 18px 22px; margin-top: 20px;">
                            <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Xử lý đơn thanh lý</h3>
                            <p style="margin-bottom: 16px; color: var(--muted); font-size: 13px;">Hãy xem kỹ các chi tiết thiết bị và giá đề xuất ở phía trên trước khi ra quyết định.</p>
                            
                            <c:if test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')}">
                                <!-- Manager Customer Area has been moved to its own section above -->
                            </c:if>
                            
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <c:if test="${isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT'}">
                                    <a href="${pageContext.request.contextPath}/liquidations?action=edit_view&id=${liquidation.liquidationId}" class="btn btn-primary">Sửa đơn (Cập nhật lại)</a>
                                </c:if>
                                <c:if test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT')}">
                                    <button type="submit" name="action" value="approve_manager" class="btn btn-primary">Lưu giá & Gửi sếp duyệt</button>
                                    <button type="button" class="btn btn-warn" onclick="openFeedbackModal('request_edit_manager', 'Quản lý yêu cầu sửa', 'managerFeedbackId', 'btn-warn', 'select_manager_edit')">Yêu cầu sửa</button>
                                    <button type="button" class="btn btn-danger" onclick="openFeedbackModal('reject_manager', 'Từ chối đơn thanh lý', 'managerFeedbackId', 'btn-danger', 'select_manager_reject')">Từ chối (Hủy đơn)</button>
                                </c:if>
                                <c:if test="${isCeo and liquidation.status == 'PENDING_CEO'}">
                                    <button type="submit" name="action" value="approve_ceo" class="btn btn-success" onclick="return confirm('Bạn có chắc chắn muốn duyệt và tạo Phiếu Xuất Kho cho đơn này?');">Duyệt & Xuất Kho</button>
                                    <button type="button" class="btn btn-warn" onclick="openFeedbackModal('request_edit_ceo', 'Sếp yêu cầu sửa', 'ceoFeedbackId', 'btn-warn', 'select_ceo_edit')">Yêu cầu sửa</button>
                                    <button type="button" class="btn btn-danger" onclick="openFeedbackModal('reject_ceo', 'Từ chối đơn thanh lý', 'ceoFeedbackId', 'btn-danger', 'select_ceo_reject')">Từ chối (Hủy đơn)</button>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                </form>
            </div> <!-- end tab-info -->

            <div id="tab-history" class="tab-panel">
                <div class="section" style="padding: 18px 22px;">
                    <c:if test="${empty liquidationHistory}">
                        <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">Chưa có lịch sử xử lý.</p>
                    </c:if>
                    <c:if test="${not empty liquidationHistory}">
                        <div style="display: flex; flex-direction: column; gap: 16px; margin-top: 8px;">
                            <c:forEach var="log" items="${liquidationHistory}">
                                <div style="display: flex; gap: 12px;">
                                    <div style="display: flex; flex-direction: column; align-items: center; width: 24px; flex-shrink: 0;">
                                        <div style="width: 10px; height: 10px; border-radius: 50%; background: var(--accent); margin-top: 4px;"></div>
                                        <div style="flex: 1; width: 2px; background: var(--border); margin-top: 4px;"></div>
                                    </div>
                                    <div style="padding-bottom: 16px;">
                                        <div style="font-size: 13px; color: var(--muted); margin-bottom: 2px;">
                                            <fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm" /> - <strong>${log.action}</strong> 
                                            (bởi <b>${log.username}</b> - #${log.userId})
                                        </div>
                                        <div style="font-size: 14px; color: var(--fg); line-height: 1.5;">${log.details}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div> <!-- end tab-history -->
        </main>
    </div>
</div>

<div class="modal-host" id="feedbackModal">
    <div class="modal-card">
        <h3 id="feedbackModalTitle">Phản hồi</h3>
        <form method="POST" action="${pageContext.request.contextPath}/liquidations">
            <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
            <input type="hidden" name="action" id="feedbackModalAction" value="" />
            
            <select id="select_manager_reject" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_manager_edit" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_reject" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_edit" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            
            <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px;">
                <button type="button" class="btn" onclick="closeModal('feedbackModal')">Huỷ</button>
                <button type="submit" class="btn" id="feedbackModalSubmit">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<!-- New Customer Modal -->
<div class="nc-modal-overlay" id="ncModalOverlay">
    <div class="nc-modal">
        <div class="nc-modal-head">
            <h3>Thêm khách hàng mới</h3>
            <button type="button" class="close-modal" onclick="closeNewCustomerModal()" style="background:none; border:none; font-size:20px; cursor:pointer;">×</button>
        </div>
        <div class="nc-modal-body">
            <span class="nc-error" id="ncError"></span>
            <div class="nc-field">
                <label>Họ và tên <span style="color:var(--danger)">*</span></label>
                <input type="text" id="ncName" placeholder="Nguyễn Văn A" />
            </div>
            <div class="nc-row2">
                <div class="nc-field">
                    <label>Số điện thoại <span style="color:var(--danger)">*</span></label>
                    <input type="tel" id="ncPhone" placeholder="0901234567" />
                </div>
                <div class="nc-field">
                    <label>Email</label>
                    <input type="email" id="ncEmail" placeholder="email@example.com" />
                </div>
            </div>
            <div class="nc-field">
                <label>Địa chỉ</label>
                <input type="text" id="ncAddress" placeholder="Số nhà, đường, quận, tỉnh..." />
            </div>
            <div class="nc-row2">
                <div class="nc-field">
                    <label>Tên công ty</label>
                    <input type="text" id="ncCompanyName" placeholder="Công ty TNHH..." />
                </div>
                <div class="nc-field">
                    <label>Loại khách hàng</label>
                    <select id="ncTypeId">
                        <option value="">-- Chọn loại --</option>
                        <c:forEach var="ct" items="${customerTypes}">
                            <option value="${ct.id}">${ct.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
        <div class="nc-modal-foot">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function openFeedbackModal(actionValue, title, paramName, btnClass, selectId) {
        document.getElementById('feedbackModalTitle').innerText = title;
        document.getElementById('feedbackModalAction').value = actionValue;
        document.getElementById('feedbackModalSubmit').className = 'btn ' + btnClass;
        
        document.querySelectorAll('.fb-select').forEach(function(el) {
            el.style.display = 'none';
            el.disabled = true;
            el.removeAttribute('name');
            el.removeAttribute('required');
        });
        
        var activeSelect = document.getElementById(selectId);
        activeSelect.style.display = 'block';
        activeSelect.disabled = false;
        activeSelect.name = paramName;
        activeSelect.required = true;
        
        openModal('feedbackModal');
    }

    function switchTab(tabId) {
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.tab').forEach(function(t) { t.classList.remove('active'); });
        document.getElementById('tab-' + tabId).classList.add('active');
        var clickedTab = document.querySelector('.tab[onclick="switchTab(\'' + tabId + '\')"]');
        if (clickedTab) clickedTab.classList.add('active');
    }
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });

    /* ============ CUSTOMER SEARCH ============ */
    var custSearchInput = document.getElementById('custSearchInput');
    if (custSearchInput) {
        var custSearchTimer = null;
        var ctxPath = '${pageContext.request.contextPath}';

        custSearchInput.addEventListener('input', function() {
            clearTimeout(custSearchTimer);
            var q = this.value.trim();
            if (q.length < 1) { hideCustDropdown(); return; }
            custSearchTimer = setTimeout(function() { searchCustomers(q); }, 280);
        });

        custSearchInput.addEventListener('focus', function() {
            var q = this.value.trim();
            if (q.length >= 1) searchCustomers(q);
        });

        document.addEventListener('click', function(e) {
            var wrap = document.getElementById('custSearchWrap');
            if (wrap && !wrap.contains(e.target)) {
                hideCustDropdown();
            }
        });
    }

    function searchCustomers(q) {
        fetch('${pageContext.request.contextPath}/liquidations?action=search_customer&q=' + encodeURIComponent(q))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                renderCustDropdown(data);
            }).catch(function() { hideCustDropdown(); });
    }

    function renderCustDropdown(data) {
        var dd = document.getElementById('custDropdown');
        dd.innerHTML = '';
        if (!data || data.length === 0) {
            dd.innerHTML = '<div style="padding:12px 14px; color:var(--muted); font-size:13px;">Không tìm thấy khách hàng</div>';
            dd.classList.add('show');
            return;
        }
        data.forEach(function(c) {
            var div = document.createElement('div');
            div.className = 'cust-option';
            div.innerHTML = '<span class="cust-name">' + escHtml(c.name) + '</span>'
                + '<span class="cust-sub">' + escHtml(c.phone)
                + (c.companyName ? ' · ' + escHtml(c.companyName) : '') + '</span>';
            div.addEventListener('click', function() { selectCustomer(c); });
            dd.appendChild(div);
        });
        dd.classList.add('show');
    }

    function hideCustDropdown() {
        var dd = document.getElementById('custDropdown');
        if (dd) dd.classList.remove('show');
    }

    function selectCustomer(c) {
        document.getElementById('customerIdHidden').value = c.id;
        document.getElementById('custSearchInput').value = c.name;
        hideCustDropdown();
        showCustCard(c);
    }

    function showCustCard(c) {
        document.getElementById('custSearchWrap').style.display = 'none';
        document.getElementById('addNewCustBtn').style.display = 'none';
        
        document.getElementById('custCardAvatar').textContent = c.name.charAt(0).toUpperCase();
        document.getElementById('custCardName').textContent = c.name;
        document.getElementById('custCardPhone').textContent = c.phone;
        
        var emailRow = document.getElementById('custCardEmailRow');
        document.getElementById('custCardEmail').textContent = c.email || '';
        emailRow.style.display = c.email ? 'flex' : 'none';
        
        var addrRow = document.getElementById('custCardAddrRow');
        document.getElementById('custCardAddr').textContent = c.address || '';
        addrRow.style.display = c.address ? 'flex' : 'none';
        
        document.getElementById('custCard').style.display = 'flex';
    }

    function clearCustomer() {
        document.getElementById('customerIdHidden').value = '';
        document.getElementById('custSearchInput').value = '';
        document.getElementById('custCard').style.display = 'none';
        document.getElementById('custSearchWrap').style.display = 'block';
        document.getElementById('addNewCustBtn').style.display = 'inline-flex';
    }

    /* ============ NEW CUSTOMER MODAL ============ */
    function openNewCustomerModal() {
        document.getElementById('ncName').value = '';
        document.getElementById('ncPhone').value = document.getElementById('custSearchInput').value;
        document.getElementById('ncEmail').value = '';
        document.getElementById('ncAddress').value = '';
        document.getElementById('ncCompanyName').value = '';
        document.getElementById('ncTypeId').selectedIndex = 0;
        hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }

    function closeNewCustomerModal() {
        document.getElementById('ncModalOverlay').classList.remove('show');
    }

    function showNcError(msg) {
        var el = document.getElementById('ncError');
        el.textContent = msg; el.classList.add('show');
    }
    function hideNcError() {
        document.getElementById('ncError').classList.remove('show');
    }

    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        if (!name) { showNcError('Vui lòng nhập họ tên.'); document.getElementById('ncName').focus(); return; }
        if (!phone) { showNcError('Vui lòng nhập số điện thoại.'); document.getElementById('ncPhone').focus(); return; }
        hideNcError();

        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';

        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', document.getElementById('ncEmail').value.trim());
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', document.getElementById('ncCompanyName').value.trim());
        fd.append('custTypeId', document.getElementById('ncTypeId').value);

        fetch('${pageContext.request.contextPath}/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    var c = {
                        id: data.id, name: data.name, phone: data.phone,
                        email: data.email, address: data.address, companyName: data.companyName
                    };
                    if (data.existing) {
                        showNcError('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                        setTimeout(function() {
                            closeNewCustomerModal();
                            selectCustomer(c);
                        }, 1500);
                    } else {
                        closeNewCustomerModal();
                        selectCustomer(c);
                    }
                } else {
                    showNcError(data.error || 'Lỗi không xác định');
                }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }

    function escHtml(str) {
        var d = document.createElement('div'); d.appendChild(document.createTextNode(str || '')); return d.innerHTML;
    }

    var ncOverlay = document.getElementById('ncModalOverlay');
    if (ncOverlay) {
        ncOverlay.addEventListener('click', function(e) {
            if (e.target === this) closeNewCustomerModal();
        });
    }
    
    document.getElementById('mainForm').addEventListener('submit', function(e) {
        var actionBtn = e.submitter;
        if (actionBtn && actionBtn.value === 'approve_manager') {
            var custId = document.getElementById('customerIdHidden').value;
            if (!custId) {
                e.preventDefault();
                alert('Vui lòng tìm và chọn Khách hàng hoặc Thêm mới trước khi gửi Sếp duyệt.');
            }
        }
    });
</script>
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
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
