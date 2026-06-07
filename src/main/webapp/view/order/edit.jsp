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
        <style>
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
            .col-price {
                width: 130px;
                text-align: right;
                font-size: 13px;
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
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Chỉnh sửa đơn hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / Chỉnh sửa</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = { message: '<c:out value="${sessionScope.message}"/>', type: 'success' };
                        <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty error}">
                        window.SESSION_DATA = window.SESSION_DATA || {};
                        window.SESSION_DATA.message = '<c:out value="${error}"/>';
                        window.SESSION_DATA.type = 'danger';
                        </c:if>
                    </script>

                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 
                                                       19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Kinh doanh · Đơn hàng #${order.orderId}</div>
                        <h2 class="page-title">Chỉnh sửa thông tin đơn hàng</h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/order?action=update">
                            <input type="hidden" name="orderId" value="${order.orderId}" />
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN KHÁCH HÀNG</div>
                                    <h3 class="form-section-title">Người nhận hàng</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Tên khách hàng <span class="req">*</span></label>
                                        <c:set var="preName" value="${(preselectCustomer != null) ? preselectCustomer.name : order.customer.name}" />
                                        <input class="input" name="customerName" value="<c:out value="${preName}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                        <c:set var="prePhone" value="${(preselectCustomer != null) ? preselectCustomer.phone : order.customer.phone}" />
                                        <input class="input mono" name="customerPhone" value="<c:out value="${prePhone}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Email</label>
                                        <c:set var="preEmail" value="${(preselectCustomer != null) ? preselectCustomer.email : order.customer.email}" />
                                        <input class="input mono" name="customerEmail" type="email" value="<c:out value="${preEmail}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Địa chỉ giao hàng <span class="req">*</span></label>
                                        <c:set var="preAddress" value="${(preselectCustomer != null) ? preselectCustomer.address : order.customer.address}" />
                                        <input class="input" name="customerAddress" value="<c:out value="${preAddress}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Loại khách hàng <span class="req">*</span></label>
                                        <c:set var="preTypeId" value="${(preselectCustomer != null) ? preselectCustomer.customerTypeId : order.customer.customerTypeId}" />
                                        <select class="input" id="customerTypeSelect" name="customerTypeId" onchange="onCustomerTypeChange()" required>
                                            <option value="">-- Chọn loại khách hàng --</option>
                                            <c:forEach var="ct" items="${customerTypes}">
                                                <option value="${ct.id}" data-name="${ct.name}"
                                                        <c:if test="${preTypeId == ct.id}">selected</c:if>>
                                                    <c:out value="${ct.name}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tên công ty <span class="req company-req" style="display:none;">*</span></label>
                                        <c:set var="preCompany" value="${(preselectCustomer != null) ? preselectCustomer.companyName : order.customer.companyName}" />
                                        <input class="input" id="customerCompany" name="customerCompany" value="<c:out value="${preCompany}"/>" />
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — GHI CHÚ ĐƠN HÀNG</div>
                                    <h3 class="form-section-title">Thông tin bổ sung</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú của khách hàng</label>
                                        <textarea class="input" name="customerNote" rows="3"><c:out value="${order.customerNote}"/></textarea>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú nội bộ</label>
                                        <textarea class="input" name="note" rows="2"><c:out value="${order.note}"/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">03 — MÁY PHÁT ĐIỆN</div>
                                    <h3 class="form-section-title">Cập nhật sản phẩm</h3>
                                </div>

                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Máy phát</th>
                                            <th class="col-qty">Số lượng</th>
                                            <th class="col-price">Đơn giá</th>
                                            <th class="col-price">Thành tiền</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <c:choose>
                                            <c:when test="${not empty existingDetails}">
                                                <c:forEach var="d" items="${existingDetails}" varStatus="st">
                                                    <tr>
                                                        <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                                        <td>
                                                            <select name="generatorId" class="gen-select" onchange="updateRowPrice(this)" required>
                                                                <option value="">-- Chọn máy --</option>
                                                                <c:forEach var="g" items="${generators}">
                                                                    <option value="${g.id}" data-price="${g.unitPrice}"
                                                                            <c:if test="${g.id == d.generatorId}">selected</c:if>>
                                                                        <c:out value="${g.model}"/> (<c:out value="${g.powerRating}"/> kW)
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td><input type="number" name="quantity" class="qty-input" value="${d.quantity}" min="1" max="9999" oninput="updateTotal()" required /></td>
                                                        <td class="col-price"><span class="row-unit-price mono">0₫</span></td>
                                                        <td class="col-price"><span class="row-subtotal mono">0₫</span></td>
                                                        <td class="col-del">
                                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td class="col-num"><span class="row-num">1</span></td>
                                                    <td>
                                                        <select name="generatorId" class="gen-select" onchange="updateRowPrice(this)" required>
                                                            <option value="">-- Chọn máy --</option>
                                                            <c:forEach var="g" items="${generators}">
                                                                <option value="${g.id}" data-price="${g.unitPrice}">
                                                                    <c:out value="${g.model}"/> (<c:out value="${g.powerRating}"/> kW)
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" oninput="updateTotal()" required /></td>
                                                    <td class="col-price"><span class="row-unit-price mono">0₫</span></td>
                                                    <td class="col-price"><span class="row-subtotal mono">0₫</span></td>
                                                    <td class="col-del">
                                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                    <tfoot>
                                        <tr class="total-row">
                                            <td colspan="4" class="text-right">Tổng cộng:</td>
                                            <td class="text-right mono" id="grandTotal">0₫</td>
                                            <td></td>
                                        </tr>
                                    </tfoot>
                                </table>

                                <template id="rowTemplate">
                                    <tr>
                                        <td class="col-num"><span class="row-num"></span></td>
                                        <td>
                                            <select name="generatorId" class="gen-select" onchange="updateRowPrice(this)" required>
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}" data-price="${g.unitPrice}">
                                                        <c:out value="${g.model}"/> (<c:out value="${g.powerRating}"/> kW)
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="number" name="quantity" class="qty-input" value="1" min="1" max="9999" oninput="updateTotal()" required /></td>
                                        <td class="col-price"><span class="row-unit-price mono">0₫</span></td>
                                        <td class="col-price"><span class="row-subtotal mono">0₫</span></td>
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
                                <a class="btn" href="${pageContext.request.contextPath}/order?action=list">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                    Cập nhật đơn hàng
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
                                    function formatVND(num) {
                                        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
                                    }
                                    function updateRowPrice(selectEl) {
                                        var row = selectEl.closest('tr');
                                        var opt = selectEl.options[selectEl.selectedIndex];
                                        var price = parseFloat(opt.getAttribute('data-price')) || 0;
                                        row.querySelector('.row-unit-price').textContent = formatVND(price);
                                        updateTotal();
                                    }
                                    function updateTotal() {
                                        var grand = 0;
                                        document.querySelectorAll('#detailBody tr').forEach(function (row) {
                                            var sel = row.querySelector('.gen-select');
                                            var qty = parseInt(row.querySelector('.qty-input').value) || 0;
                                            var opt = sel.options[sel.selectedIndex];
                                            var price = parseFloat(opt ? opt.getAttribute('data-price') : 0) || 0;
                                            var subtotal = price * qty;
                                            row.querySelector('.row-subtotal').textContent = formatVND(subtotal);
                                            row.querySelector('.row-unit-price').textContent = formatVND(price);
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
                                        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
                                            el.textContent = i + 1;
                                        });
                                    }
                                    // Tự tính ngay khi load (vì có dữ liệu pre-fill)
                                    document.addEventListener('DOMContentLoaded', updateTotal);

                                    // Khi đổi loại khách hàng: nếu chọn "Doanh nghiệp" => bắt buộc tên công ty
                                    function onCustomerTypeChange() {
                                        var sel = document.getElementById('customerTypeSelect');
                                        var opt = sel.options[sel.selectedIndex];
                                        var name = (opt && opt.getAttribute('data-name') || '').toLowerCase();
                                        var isCompany = name.indexOf('doanh nghiệp') >= 0 || name.indexOf('công ty') >= 0;
                                        document.getElementById('customerCompany').required = isCompany;
                                        document.querySelectorAll('.company-req').forEach(function (el) {
                                            el.style.display = isCompany ? 'inline' : 'none';
                                        });
                                    }
                                    document.addEventListener('DOMContentLoaded', onCustomerTypeChange);
        </script>
    </body>
</html>
