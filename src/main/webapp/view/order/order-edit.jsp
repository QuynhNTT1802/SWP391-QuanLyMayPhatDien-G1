<%-- 
    Document   : create-order
    Created on : May 26, 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
    </head>
    <style>
        .form-layout {
            grid-template-columns: 1fr;
            max-width: none;
        }

        /* ── Customer postcard (bưu thiếp) ── */
        .customer-info-card { border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 14px 16px; background: var(--surface-2); margin-top: 10px; }
        .cic-header { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
        .cic-name { font-size: 14px; font-weight: 700; color: var(--fg); line-height: 1.4; }
        .cic-actions { display: flex; gap: 4px; align-items: center; flex-shrink: 0; }
        .cic-btn-remove { padding: 4px; border: none; color: var(--muted); background: none; cursor: pointer; }
        .cic-btn-remove:hover { color: var(--danger); }
        .cic-btn-remove svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 2.2; stroke-linecap: round; stroke-linejoin: round; }
        .cic-details { display: flex; flex-wrap: wrap; gap: 4px 18px; margin-top: 10px; }
        .cic-detail-item { display: inline-flex; align-items: center; gap: 4px; font-size: 12.5px; color: var(--muted); line-height: 1.4; }
        .cic-detail-item svg { width: 14px; height: 14px; flex-shrink: 0; stroke: currentColor; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }

        /* ── Modal styles ── */
        .modal-host {
            position: fixed; inset: 0;
            background: rgba(15, 23, 42, 0.45);
            display: none; align-items: center; justify-content: center;
            z-index: 1000; padding: 20px;
        }
        .modal-host.show { display: flex; }
        .modal {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            width: 100%; max-width: 680px;
            max-height: 90vh; overflow: auto;
            padding: 24px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
        }
        .modal-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px; }
        .modal-head h3 { margin: 0; font-size: 18px; font-weight: 700; }
        .modal-close { background: none; border: none; color: var(--muted); cursor: pointer; font-size: 24px; line-height: 1; padding: 4px 8px; border-radius: var(--radius-sm); }
        .modal-close:hover { background: var(--surface-2); color: var(--fg); }
        .modal-sub { font-size: 13px; color: var(--muted); margin: 0 0 14px; }
        .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px 16px; }
        .modal-grid .span-2 { grid-column: span 2; }
        .modal-error {
            padding: 10px 14px;
            border-radius: var(--radius-sm);
            background: var(--danger-soft);
            color: var(--danger);
            border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent);
            font-size: 13px; font-weight: 600;
            margin-bottom: 12px;
            display: none;
        }
        .modal-error.show { display: block; }
        .modal-actions {
            display: flex; justify-content: flex-end; gap: 8px;
            margin-top: 18px; padding-top: 14px;
            border-top: 1px solid var(--border);
        }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
        }
        .detail-table th {
            text-align: left;
            padding: 8px 10px;
            font-size: 12px;
            font-weight: 600;
            color: var(--muted);
            border-bottom: 1px solid var(--border);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .detail-table td {
            padding: 8px 6px;
            vertical-align: top;
        }
        .detail-table select, .detail-table input {
            width: 100%;
            padding: 7px 8px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            background: var(--bg);
            color: var(--fg);
            font-size: 13px;
            box-sizing: border-box;
        }
        .col-num {
            width: 36px;
            text-align: center;
            color: var(--muted);
            font-weight: 600;
            padding-top: 14px;
        }
        .col-qty {
            width: 100px;
        }
        .col-stock {
            width: 90px;
            text-align: center;
            font-size: 12px;
            color: var(--muted);
            padding-top: 14px !important;
        }
        .col-price {
            width: 160px;
            text-align: right;
            font-size: 13px;
            padding-top: 6px !important;
        }
        .unit-price-input {
            width: 100%;
            padding: 7px 8px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            background: var(--bg);
            color: var(--fg);
            font-size: 13px;
            box-sizing: border-box;
            text-align: right;
        }
        .unit-price-input.is-invalid,
        .qty-input.is-invalid {
            border-color: var(--danger);
            background: var(--danger-soft);
            color: var(--danger);
        }
        .row-subtotal-cell {
            padding-top: 14px !important;
        }
        .col-del {
            width: 40px;
            text-align: center;
        }
        .row-unit-price {
            color: var(--muted);
        }
        .row-subtotal {
            color: var(--accent);
            font-weight: 600;
        }
        .grand-total-box {
            margin-top: 16px;
            padding: 14px 18px;
            background: var(--accent-soft);
            border-radius: var(--radius);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .grand-total-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            letter-spacing: 0.5px;
        }
        .grand-total-value {
            font-size: 20px;
            font-weight: 700;
            color: var(--accent);
        }
        .row-del-btn {
            width: 28px;
            height: 28px;
            border: none;
            background: none;
            color: var(--danger);
            cursor: pointer;
            border-radius: var(--radius-sm);
            margin-top: 4px;
        }
        .row-del-btn:hover {
            background: var(--danger-soft);
        }
        .add-row-btn {
            margin-top: 8px;
            font-size: 13px;
        }
        .customer-warn-banner {
            max-width: 600px;
            margin: 24px auto;
            padding: 16px 20px;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: #856404;
            font-size: 14px;
        }
        .customer-warn-banner .banner-icon {
            font-size: 24px;
            flex-shrink: 0;
        }
        .customer-warn-banner .banner-content {
            flex: 1;
        }
        .customer-warn-banner a {
            color: #3b82f6;
            font-weight: 600;
            text-decoration: underline;
            margin-left: 8px;
        }
        .revision-reason { background:var(--surface-2); border:1px solid color-mix(in srgb,#7c3aed 30%,transparent); border-radius:10px; padding:14px 18px; margin-bottom:16px; }
        .revision-reason .rr-label { font-weight:700; font-size:11px; color:#7c3aed; text-transform:uppercase; letter-spacing:.04em; margin-bottom:4px; }
        .revision-reason .rr-body { font-size:13px; color:var(--fg); }
    </style>
    <body>
        <script>
            var contextPath = '${pageContext.request.contextPath}';
        </script>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Chỉnh sửa đơn hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / <a href="${pageContext.request.contextPath}/order?action=detail&amp;id=${order.orderId}"><c:out value="${order.orderCode}"/></a> / Chỉnh sửa</span>
<div class="top-actions">
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>

                <main>
                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {
                            message: '<c:out value="${sessionScope.message}"/>',
                            type: '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>'
                        };
                            <c:remove var="message" scope="session"/>
                            <c:remove var="messageType" scope="session"/>
                        </c:if>
                        <c:if test="${not empty error}">
                        window.SESSION_DATA = window.SESSION_DATA || {};
                        window.SESSION_DATA.message = '<c:out value="${error}"/>';
                        window.SESSION_DATA.type = 'danger';
                        </c:if>
                    </script>

                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <c:if test="${order.status == 'NEEDS_REVISION' && not empty order.revisionReason}">
                        <div class="revision-reason">
                            <div class="rr-label">Lý do yêu cầu chỉnh sửa</div>
                            <div class="rr-body"><c:out value="${order.revisionReason}"/></div>
                        </div>
                    </c:if>

                    <div class="page-head">
                        <div class="eyebrow">Kinh doanh · Chỉnh sửa đơn hàng</div>
                        <h2 class="page-title">Chỉnh sửa đơn hàng bán ra</h2>
                        <p class="page-sub">Đơn hàng <c:out value="${order.orderCode}"/> · Ngày đặt: <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></p>
                    </div>

                    <c:if test="${param.error == 'customer_not_found' or not empty requestScope.customerNotFound}">
                        <div class="customer-warn-banner">
                            <div class="banner-icon">⚠</div>
                            <div class="banner-content">
                                <strong>Chưa có khách hàng với SĐT này trong hệ thống.</strong>
                                <a href="${pageContext.request.contextPath}/warehouse/customers?action=create&returnTo=order-create&phone=${param.customerPhone}">
                                    Tạo khách hàng mới →
                                </a>
                            </div>
                        </div>
                    </c:if>


                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/order?action=update" onsubmit="return validateForm()">
                            <input type="hidden" name="id" value="${order.orderId}" />
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN KHÁCH HÀNG</div>
                                    <h3 class="form-section-title">Người nhận hàng</h3>
                                </div>

                                <div id="custPickerArea">
                                    <div class="sd" id="customerDropdown"
                                         data-endpoint="${pageContext.request.contextPath}/warehouse/customers?action=search&q=">
                                        <div class="cust-trigger-wrap">
                                            <button type="button" class="cust-trigger" id="custTrigger"
                                                    onclick="openCustomerPanel()" aria-haspopup="dialog">
                                                <span class="cust-trigger-label" id="custTriggerLabel">-- Nhấp để chọn khách hàng --</span>
                                                <svg class="cust-trigger-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M21 21l-4.35-4.35M11 19a8 8 0 1 1 0-16 8 8 0 0 1 0 16z" stroke="currentColor" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                                </svg>
                                            </button>
                                            <button type="button" class="cust-clear-btn" id="custClearBtn"
                                                    onclick="clearCustomerSelection()" title="Hủy chọn khách hàng" aria-label="Hủy chọn">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M18 6L6 18M6 6l12 12"/>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>
                                    <c:if test="${canCreateCustomer}">
                                        <button type="button" class="btn btn-primary" onclick="openNewCustomerModal()" style="margin-top:10px;">
                                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                            Thêm khách hàng mới
                                        </button>
                                    </c:if>
                                </div>

                                <input type="hidden" name="customerId" id="sdHiddenId" value="<c:out value='${order.customer.id}'/>" />
                                <c:set var="preName"    value="${order.customer.name}" />
                                <c:set var="prePhone"   value="${order.customer.phone}" />
                                <c:set var="preEmail"   value="${order.customer.email}" />
                                <c:set var="preAddress" value="${order.customer.address}" />
                                <c:set var="preCompany" value="${order.customer.companyName}" />
                                <c:set var="preTypeId"  value="${order.customer.customerTypeId}" />
                                <input type="hidden" name="customerName"    id="inpCustName"    value="<c:out value='${preName}'/>" />
                                <input type="hidden" name="customerPhone"   id="inpCustPhone"   value="<c:out value='${prePhone}'/>" />
                                <input type="hidden" name="customerEmail"   id="inpCustEmail"   value="<c:out value='${preEmail}'/>" />
                                <input type="hidden" name="customerAddress" id="inpCustAddress" value="<c:out value='${preAddress}'/>" />
                                <input type="hidden" name="customerCompany" id="customerCompany" value="<c:out value='${preCompany}'/>" />
                                <input type="hidden" name="customerTypeId"  id="customerTypeId"  value="<c:out value='${preTypeId}'/>" />

                                <div id="customerCardContainer" class="customer-info-card" style="display:none;"></div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — THÔNG TIN ĐƠN HÀNG</div>
                                    <h3 class="form-section-title">Chi tiết giao dịch</h3>
                                    <div class="form-section-desc">Mã đơn hàng sẽ tự sinh nếu bạn để trống.</div>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Mã đơn hàng</label>
                                        <input class="input mono" name="orderCode" placeholder="VD: ORD-20260526-001" value="<c:out value="${order.orderCode}"/>" readonly />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Ngày đặt hàng</label>
                                        <%
                                            java.text.SimpleDateFormat __ordDateFmt = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                            java.util.Date __now = new java.util.Date();
                                        %>
                                        <input class="input mono" type="text" value="<fmt:formatDate value='${order.orderDate}' pattern='dd/MM/yyyy HH:mm'/>" readonly />
                                        <small style="color:var(--muted); font-size:11px; margin-top:4px; display:block;">Ngày đặt hàng không thể chỉnh sửa.</small>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú của khách hàng</label>
                                        <textarea class="input" name="customerNote" rows="3" placeholder="VD: Giao giờ hành chính, gọi trước khi giao..."><c:out value="${order.customerNote}"/></textarea>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú nội bộ (Chỉ nhân viên thấy)</label>
                                        <textarea class="input" name="note" rows="2" placeholder="VD: Khách quen, giảm giá 5%..."><c:out value="${order.note}"/></textarea>
                                    </div>
                                </div>
                            </div>


                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">03 — MÁY PHÁT ĐIỆN</div>
                                    <h3 class="form-section-title">Chi tiết sản phẩm</h3>
                                </div>

                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Máy phát</th>
                                            <th class="col-qty">Số lượng</th>
                                            <th class="col-stock">Tồn kho</th>
                                            <th class="col-price">Đơn giá bán</th>
                                            <th class="col-price">Thành tiền</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <c:forEach var="d" items="${details}" varStatus="vs">
                                        <tr>
                                            <td class="col-num"><span class="row-num">${vs.count}</span></td>
                                            <td>
                                                <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}" ${d.generatorId == g.id ? 'selected' : ''}>
                                                            <c:out value="${g.model}"/> (<c:out value="${g.powerRating}"/> kW)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input type="number" name="quantity" class="qty-input" placeholder="1" min="1" max="9999" step="1" oninput="validateQty(this); updateTotal()" onblur="validateQtyOnBlur(this)" required value="${d.quantity}" /></td>
                                            <td class="col-stock"><span class="row-stock mono">—</span></td>
                                            <td class="col-price">
                                                <input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="<fmt:formatNumber value='${d.unitPrice}' pattern='#0'/>" oninput="validateUnitPrice(this); updateTotal()" onfocus="unformatPrice(this)" onblur="formatPriceDisplay(this)" required />
                                            </td>
                                            <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                            <td class="col-del">
                                                <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                            </td>
                                        </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr class="total-row">
                                            <td colspan="5" class="text-right">Tổng cộng:</td>
                                            <td class="text-right mono" id="grandTotal">0₫</td>
                                            <td></td>
                                        </tr>
                                    </tfoot>
                                </table>

                                <template id="rowTemplate">
                                    <tr>
                                        <td class="col-num"><span class="row-num"></span></td>
                                        <td>
                                            <select name="generatorId" class="gen-select" required onchange="updateStockCell(this)">
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}">
                                                        <c:out value="${g.model}"/> (<c:out value="${g.powerRating}"/> kW)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="number" name="quantity" class="qty-input" placeholder="1" min="1" max="9999" step="1" oninput="validateQty(this); updateTotal()" onblur="validateQtyOnBlur(this)" required /></td>
                                        <td class="col-stock"><span class="row-stock mono">—</span></td>
                                        <td class="col-price">
                                            <input type="text" inputmode="numeric" name="unitPrice" class="unit-price-input mono" value="0" oninput="validateUnitPrice(this); updateTotal()" onfocus="unformatPrice(this)" onblur="formatPriceDisplay(this)" required />
                                        </td>
                                        <td class="col-price row-subtotal-cell"><span class="row-subtotal mono">0₫</span></td>
                                        <td class="col-del">
                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                        </td>
                                    </tr>
                                </template>

                                <button type="button" class="btn add-row-btn" onclick="addRow()">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm dòng
                                </button>

                            </div>



                            <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                <a class="btn" href="${pageContext.request.contextPath}/order?action=detail&id=${order.orderId}">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                    Gửi duyệt lại
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <!-- Modal: Thêm khách hàng mới -->
        <div class="modal-host" id="custModalOverlay">
            <div class="modal">
                <div class="modal-head">
                    <h3>Thêm khách hàng mới</h3>
                    <button type="button" class="modal-close" onclick="closeNewCustomerModal()">&times;</button>
                </div>
                <p class="modal-sub">Khách hàng sẽ được áp dụng cho toàn bộ phiếu.</p>
                <div class="modal-error" id="custModalError"></div>
                <div class="modal-grid">
                    <div>
                        <label class="field-label">Tên khách hàng <span class="req">*</span></label>
                        <input class="input" id="ncName" placeholder="VD: Nguyễn Văn A" />
                    </div>
                    <div>
                        <label class="field-label">Số điện thoại <span class="req">*</span></label>
                        <input class="input mono" id="ncPhone" type="tel" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" />
                    </div>
                    <div>
                        <label class="field-label">Email</label>
                        <input class="input mono" id="ncEmail" type="email" placeholder="email@example.com" />
                    </div>
                    <div>
                        <label class="field-label">Loại khách hàng</label>
                        <select class="select" id="ncTypeId">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="ct" items="${customerTypes}">
                                <option value="${ct.id}"><c:out value="${ct.name}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="span-2">
                        <label class="field-label">Tên công ty</label>
                        <input class="input" id="ncCompanyName" placeholder="VD: Công ty TNHH ABC" />
                    </div>
                    <div class="span-2">
                        <label class="field-label">Địa chỉ</label>
                        <textarea class="textarea" id="ncAddress" rows="2" placeholder="Địa chỉ khách hàng"></textarea>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
                    <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
                </div>
            </div>
        </div>

        <!-- Side panel for customer selection -->
        <div class="side-panel-overlay" id="custPanelOverlay" onclick="closeCustomerPanel()"></div>
        <div class="side-panel" id="custSidePanel">
            <div class="side-panel-head">
                <h3 class="side-panel-title">Chọn Khách Hàng</h3>
                <button type="button" class="side-panel-close" onclick="closeCustomerPanel()">&times;</button>
            </div>
            <div class="side-panel-body">
                <div style="display:flex; gap: 8px; margin-bottom: 20px;">
                    <input type="text" id="custSearchInput" class="serial-search-box" placeholder="Tìm nhanh theo tên, SĐT, email..."/>
                    <select id="custSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                        <option value="name_asc">Tên A-Z</option>
                        <option value="name_desc">Tên Z-A</option>
                        <option value="newest">Mới nhất</option>
                    </select>
                </div>
                <div id="custLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
                    </svg><br>Đang tải...
                </div>
                <div class="cust-list-wrap" id="custList"></div>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <script>
            <c:if test="${not empty sessionScope.message}">
            window.SESSION_DATA = window.SESSION_DATA || {};
            window.SESSION_DATA.message = '<c:out value="${sessionScope.message}"/>';
            window.SESSION_DATA.type = '<c:out value="${sessionScope.messageType != null ? sessionScope.messageType : 'success'}"/>';
                <c:remove var="message" scope="session"/>
                <c:remove var="messageType" scope="session"/>
            </c:if>
        </script>
        <script>
            function formatVND(num) {
                return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
            }
            function validateQty(input) {
                // Loại bỏ ký tự không phải số, cho phép xóa/empty khi đang nhập
                var v = input.value.replace(/[^0-9]/g, '');
                if (v === '' || v === '0') {
                    input.value = v;
                    return;
                }
                var n = parseInt(v);
                if (n > 9999) {
                    input.value = 9999;
                } else {
                    input.value = n;
                }
                validateQtyAgainstStock(input.closest('tr'));
            }
            function validateQtyOnBlur(input) {
                var n = parseInt(input.value);
                if (isNaN(n) || n < 1) {
                    input.value = 1;
                }
            }
            function validateUnitPrice(input) {
                var original = input.value;
                var cleaned = original.replace(/[^\d]/g, '');
                if (original && cleaned === '') {
                    alert('Đơn giá chỉ được nhập số, không nhập chữ!');
                    input.value = '0';
                    return;
                }
                input.value = cleaned;
            }
            function formatPriceDisplay(input) {
                var n = parseInt(input.value.replace(/[^\d]/g, '')) || 0;
                if (n > 0) {
                    input.value = n.toLocaleString('vi-VN');
                } else {
                    input.value = '0';
                }
            }
            function unformatPrice(input) {
                input.value = input.value.replace(/[^\d]/g, '');
                if (input.value === '') {
                    input.value = '0';
                }
            }
            
            var STOCK_MAP = {
                <c:forEach var="entry" items="${stockMap}">${entry.key}: ${entry.value},</c:forEach>
            };
            function getStockFor(generatorId) {
                if (!generatorId) return 0;
                return STOCK_MAP[generatorId] || 0;
            }
            function updateStockCell(selEl) {
                var row = selEl.closest('tr');
                var stockCell = row.querySelector('.row-stock');
                if (!stockCell) return;
                var gid = parseInt(selEl.value);
                if (!gid) {
                    stockCell.textContent = '—';
                    return;
                }
                var stock = getStockFor(gid);
                stockCell.textContent = stock;
                stockCell.style.color = stock === 0 ? 'var(--danger)' : 'var(--fg)';
                stockCell.style.fontWeight = stock === 0 ? '600' : '';
                validateQtyAgainstStock(row);
            }
            function validateQtyAgainstStock(row) {
                var sel = row.querySelector('.gen-select');
                var qtyInput = row.querySelector('.qty-input');
                if (!sel || !qtyInput) return;
                var gid = parseInt(sel.value);
                var qty = parseInt(qtyInput.value) || 0;
                var stock = getStockFor(gid);
                if (gid && qty > stock) {
                    qtyInput.classList.add('is-invalid');
                } else {
                    qtyInput.classList.remove('is-invalid');
                }
            }
            function updateTotal() {
                var grand = 0;
                Array.from(document.querySelectorAll('#detailBody tr')).forEach(function (row) {
                    var sel = row.querySelector('.gen-select');
                    var qty = parseInt(row.querySelector('.qty-input').value) || 0;
                    var priceInput = row.querySelector('.unit-price-input');
                    var price = parseInt(priceInput.value.replace(/[^\d]/g, '')) || 0;
                    var subtotal = price * qty;
                    row.querySelector('.row-subtotal').textContent = formatVND(subtotal);
                    grand += subtotal;
                });
                document.getElementById('grandTotal').textContent = formatVND(grand);
            }
            function addRow() {
                var tpl = document.getElementById('rowTemplate');
                var clone = tpl.content.cloneNode(true);
                document.getElementById('detailBody').appendChild(clone);
                updateRowNumbers();
                updateTotal();
            }
            function removeRow(btn) {
                var tbody = document.getElementById('detailBody');
                if (tbody.querySelectorAll('tr').length <= 1)
                    return;
                btn.closest('tr').remove();
                updateRowNumbers();
                updateTotal();
            }
            function updateRowNumbers() {
                Array.from(document.querySelectorAll('#detailBody .row-num')).forEach(function (el, i) {
                    el.textContent = i + 1;
                });
            }
            
            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('#detailBody tr').forEach(function (row) {
                    var sel = row.querySelector('.gen-select');
                    if (sel && sel.value) {
                        updateStockCell(sel);
                        var priceInput = row.querySelector('.unit-price-input');
                        if (priceInput) formatPriceDisplay(priceInput);
                    }
                });
                updateTotal();
            });

            document.querySelector('form.form-card').addEventListener('submit', function (e) {
                var rows = document.querySelectorAll('#detailBody tr');
                var hasValid = false;
                for (var i = 0; i < rows.length; i++) {
                    var sel = rows[i].querySelector('.gen-select');
                    var qtyInput = rows[i].querySelector('.qty-input');
                    var priceInput = rows[i].querySelector('.unit-price-input');
                    var qty = parseInt(qtyInput.value);
                    var price = parseInt(priceInput.value.replace(/[^\d]/g, '')) || 0;
                    if (sel.value && (isNaN(qty) || qty < 1)) {
                        e.preventDefault();
                        alert('Số lượng ở dòng ' + (i + 1) + ' phải lớn hơn 0.');
                        qtyInput.focus();
                        return false;
                    }
                    if (sel.value && price <= 0) {
                        e.preventDefault();
                        alert('Đơn giá ở dòng ' + (i + 1) + ' phải lớn hơn 0.');
                        priceInput.focus();
                        return false;
                    }
                    if (sel.value) {
                        hasValid = true;
                        // Unformat price before submit
                        priceInput.value = price;
                    }
                }
                if (!hasValid) {
                    e.preventDefault();
                    alert('Vui lòng chọn ít nhất 1 máy phát điện.');
                    return false;
                }
            });
            
            /* ── Customer postcard (bưu thiếp) ── */
            function htmlEsc(s) {
                if (s == null) return '';
                return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
            }
            function refreshCustomerCard() {
                var container = document.getElementById('customerCardContainer');
                var picker = document.getElementById('custPickerArea');
                if (!container) return;
                var hid = document.getElementById('sdHiddenId');
                var custId = hid ? hid.value : '';
                if (!custId || !custId.trim()) {
                    container.style.display = 'none';
                    if (picker) picker.style.display = '';
                    return;
                }
                if (picker) picker.style.display = 'none';
                var nameVal    = (document.getElementById('inpCustName')    || {}).value || '';
                var phoneVal   = (document.getElementById('inpCustPhone')   || {}).value || '';
                var emailVal   = (document.getElementById('inpCustEmail')   || {}).value || '';
                var addressVal = (document.getElementById('inpCustAddress') || {}).value || '';
                var companyVal = (document.getElementById('customerCompany')|| {}).value || '';
                var html = '<div class="cic-header">';
                html += '<span class="cic-name">' + htmlEsc(nameVal || '') + '</span>';
                html += '<div class="cic-actions">';
                html += '<button type="button" class="cic-btn-remove" onclick="clearCustomerSelection();refreshCustomerCard();" title="Hủy chọn khách hàng" aria-label="Hủy chọn">';
                html += '<svg viewBox="0 0 24 24"><path d="M18 6L6 18M6 6l12 12"/></svg>';
                html += '</button></div></div>';
                html += '<div class="cic-details">';
                if (phoneVal)   html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>' + htmlEsc(phoneVal) + '</span>';
                if (companyVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>' + htmlEsc(companyVal) + '</span>';
                if (emailVal)   html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>' + htmlEsc(emailVal) + '</span>';
                if (addressVal) html += '<span class="cic-detail-item"><svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>' + htmlEsc(addressVal) + '</span>';
                html += '</div>';
                container.innerHTML = html;
                container.style.display = '';
            }
            var _origClearSelection = window.clearCustomerSelection;
            window.clearCustomerSelection = function () {
                if (typeof _origClearSelection === 'function') _origClearSelection();
                refreshCustomerCard();
            };
            (function () {
                var list = document.getElementById('custList');
                if (list) {
                    list.addEventListener('click', function (e) {
                        if (e.target.closest('.cust-card')) {
                            setTimeout(refreshCustomerCard, 0);
                        }
                    });
                }
            })();
            document.addEventListener('DOMContentLoaded', refreshCustomerCard);

            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    }
                }
            });

            /* ── Thêm khách hàng mới (quick-create) ── */
            function openNewCustomerModal() {
                ['ncName', 'ncPhone', 'ncEmail', 'ncCompanyName', 'ncAddress', 'ncTypeId'].forEach(function (id) {
                    var el = document.getElementById(id);
                    if (el) el.value = '';
                });
                var err = document.getElementById('custModalError');
                if (err) { err.classList.remove('show'); err.textContent = ''; }
                document.getElementById('custModalOverlay').classList.add('show');
            }
            function closeNewCustomerModal() {
                document.getElementById('custModalOverlay').classList.remove('show');
            }
            function saveNewCustomer() {
                var name = document.getElementById('ncName').value.trim();
                var phone = document.getElementById('ncPhone').value.trim();
                if (!name) {
                    var err = document.getElementById('custModalError');
                    err.textContent = 'Vui lòng nhập tên khách hàng.';
                    err.classList.add('show');
                    return;
                }
                if (!phone || !/^[0-9]{10,11}$/.test(phone)) {
                    var err = document.getElementById('custModalError');
                    err.textContent = 'Vui lòng nhập SĐT hợp lệ (10-11 chữ số).';
                    err.classList.add('show');
                    return;
                }
                var btn = document.getElementById('ncSaveBtn');
                btn.disabled = true;
                btn.textContent = 'Đang lưu...';
                var params = new URLSearchParams();
                params.set('action', 'quickCreateCustomer');
                params.set('name', name);
                params.set('phone', phone);
                params.set('email', document.getElementById('ncEmail').value.trim());
                params.set('address', document.getElementById('ncAddress').value.trim());
                params.set('companyName', document.getElementById('ncCompanyName').value.trim());
                params.set('customerTypeId', document.getElementById('ncTypeId').value);
                fetch(contextPath + '/order', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    btn.disabled = false;
                    btn.textContent = 'Lưu khách hàng';
                    if (!data.ok) {
                        var err = document.getElementById('custModalError');
                        err.textContent = data.error || 'Lỗi';
                        err.classList.add('show');
                        return;
                    }
                    document.getElementById('sdHiddenId').value = data.id;
                    document.getElementById('inpCustName').value = data.name || '';
                    document.getElementById('inpCustPhone').value = data.phone || '';
                    document.getElementById('inpCustEmail').value = data.email || '';
                    document.getElementById('inpCustAddress').value = data.address || '';
                    document.getElementById('customerCompany').value = data.companyName || '';
                    if (data.customerTypeId) {
                        document.getElementById('customerTypeId').value = String(data.customerTypeId);
                    }
                    var label = document.getElementById('custTriggerLabel');
                    label.textContent = data.name || data.phone || '';
                    label.classList.add('has-value');
                    closeNewCustomerModal();
                    refreshCustomerCard();
                    if (typeof showToast === 'function') {
                        showToast(
                            data.existing ? 'SĐT đã có khách hàng: ' + data.name + ' — đã tự chọn.' : 'Đã thêm khách hàng "' + data.name + '"',
                            data.existing ? 'info' : 'success'
                        );
                    }
                })
                .catch(function () {
                    btn.disabled = false;
                    btn.textContent = 'Lưu khách hàng';
                    var err = document.getElementById('custModalError');
                    err.textContent = 'Lỗi kết nối';
                    err.classList.add('show');
                });
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeNewCustomerModal();
            });
        </script>

        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
    </body>
</html>