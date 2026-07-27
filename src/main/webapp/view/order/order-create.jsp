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
        <title>Tạo đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-create.css">
    </head>
    <body>
        <script>
            var contextPath = '${pageContext.request.contextPath}';
        </script>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Tạo đơn hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / Thêm mới</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M12 2.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
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

                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Kinh doanh · Đơn hàng mới</div>
                        <h2 class="page-title">Tạo đơn hàng bán ra</h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/order?action=create">
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

                                <input type="hidden" name="customerId" id="sdHiddenId" value="<c:out value='${preselectCustomer != null ? preselectCustomer.id : ""}'/>" />
                                <c:set var="preName"    value="${(preselectCustomer != null) ? preselectCustomer.name    : param.customerName}" />
                                <c:set var="prePhone"   value="${(preselectCustomer != null) ? preselectCustomer.phone   : param.customerPhone}" />
                                <c:set var="preEmail"   value="${(preselectCustomer != null) ? preselectCustomer.email   : param.customerEmail}" />
                                <c:set var="preAddress" value="${(preselectCustomer != null) ? preselectCustomer.address : param.customerAddress}" />
                                <c:set var="preCompany" value="${(preselectCustomer != null) ? preselectCustomer.companyName : param.customerCompany}" />
                                <c:set var="preTypeId"  value="${(preselectCustomer != null) ? preselectCustomer.customerTypeId : param.customerTypeId}" />
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
                                        <input class="input mono" name="orderCode" placeholder="VD: ORD-20260526-001" value="<c:out value="${param.orderCode}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Ngày đặt hàng</label>
                                        <%
                                            java.text.SimpleDateFormat __ordDateFmt = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                            java.util.Date __now = new java.util.Date();
                                        %>
                                        <input class="input mono" type="text" value="<%= __ordDateFmt.format(__now) %>" readonly />
                                        <small style="color:var(--muted); font-size:11px; margin-top:4px; display:block;">Ngày đặt hàng tự động lấy ngày hiện tại, không thể chỉnh sửa.</small>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú của khách hàng</label>
                                        <textarea class="input" name="customerNote" rows="3" placeholder="VD: Giao giờ hành chính, gọi trước khi giao..."><c:out value="${param.customerNote}"/></textarea>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú nội bộ (Chỉ nhân viên thấy)</label>
                                        <textarea class="input" name="note" rows="2" placeholder="VD: Khách quen, giảm giá 5%..."><c:out value="${param.note}"/></textarea>
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
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
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
                                <a class="btn" href="${pageContext.request.contextPath}/order?action=list">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                    Tạo đơn hàng
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
            window.STOCK_MAP = {
            <c:forEach var="entry" items="${stockMap}">${entry.key}: ${entry.value},</c:forEach>
            };
            if (typeof setStockMap === 'function')
                setStockMap(window.STOCK_MAP);
            </script>

            <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
        <script src="${pageContext.request.contextPath}/assets/js/order-create.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var orig = window.clearCustomerSelection;
                if (typeof orig === 'function') {
                    window.clearCustomerSelection = function () {
                        orig();
                        if (typeof refreshCustomerCard === 'function')
                            refreshCustomerCard();
                    };
                }
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
                        priceInput.value = price;
                    }
                }
                if (!hasValid) {
                    e.preventDefault();
                    alert('Vui lòng chọn ít nhất 1 máy phát điện.');
                    return false;
                }
            });
        </script>
    </body>
</html>