<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đơn thanh lý mới — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/searchable-dropdown.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css?v=20260703">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tạo đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / Thêm mới</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="page-head">
                <div class="eyebrow">Thanh lý · Đơn thanh lý mới</div>
                <h2 class="page-title">Tạo đơn thanh lý</h2>
            </div>

            <div class="form-layout form-layout--full">
                <!-- FORM 01: CHỌN KHO + LỌC (GET, tự nạp lại danh sách máy) -->
                <form id="filterForm" class="form-card" method="GET" action="${pageContext.request.contextPath}/liquidations">
                    <input type="hidden" name="action" value="create" />
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                            <h3 class="form-section-title">Kho hàng và Lý do thanh lý</h3>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Kho hàng <span class="req">*</span></label>
                                <select class="input" name="warehouseId" id="warehouseId" required onchange="document.getElementById('filterForm').submit();">
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${selectedWarehouseId == w.warehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label">Lọc theo tình trạng</label>
                                <select class="input" name="cond" id="condFilter" onchange="document.getElementById('filterForm').submit();" ${empty selectedWarehouseId ? 'disabled' : ''}>
                                    <option value="all" ${condFilter == 'all' ? 'selected' : ''}>Tất cả (${condCountAll})</option>
                                    <option value="DAMAGED" ${condFilter == 'DAMAGED' ? 'selected' : ''}>Hỏng (${condCountDamaged})</option>
                                    <option value="POOR" ${condFilter == 'POOR' ? 'selected' : ''}>Kém (${condCountPoor})</option>
                                    <option value="GOOD" ${condFilter == 'GOOD' ? 'selected' : ''}>Tốt (${condCountGood})</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </form>

                <!-- FORM 02: CHỌN MÁY + LƯU (POST) -->
                <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                    <input type="hidden" name="action" value="create" />
                    <input type="hidden" name="warehouseId" value="${selectedWarehouseId}" />

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — THÔNG TIN ĐƠN</div>
                            <h3 class="form-section-title">Lý do thanh lý và khách hàng nhận</h3>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                <select class="input" name="reasonId" required>
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${reasons}">
                                        <option value="${r.id}" ${selectedReasonId == r.id ? 'selected' : ''}>${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <div class="field-label-row">
                                    <label class="field-label">Khách hàng nhận <span class="req">*</span></label>
                                    <button type="button" class="link-add" onclick="openNewCustomerModal()">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                                        Tạo khách hàng mới
                                    </button>
                                </div>
                                <div class="sd" id="customerDropdown"
                                     data-endpoint="${pageContext.request.contextPath}/liquidations?action=search_customer&q=">
                                    <div class="cust-trigger-wrap">
                                        <button type="button" class="cust-trigger" id="custTrigger"
                                                onclick="openCustomerPanel()" aria-haspopup="dialog">
                                            <span class="cust-trigger-label" id="custTriggerLabel">-- Click để chọn khách hàng --</span>
                                        </button>
                                        <button type="button" class="cust-clear-btn" id="custClearBtn"
                                                onclick="clearCustomerSelection()" title="Hủy chọn khách hàng" aria-label="Hủy chọn">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                                <path d="M18 6L6 18M6 6l12 12"/>
                                            </svg>
                                        </button>
                                    </div>
                                    <input type="hidden" name="customerId" id="sdHiddenId" value="" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">03 — CHỌN MÁY &amp; BÁO GIÁ</div>
                            <h3 class="form-section-title">Máy phát điện và giá thanh lý đề xuất</h3>
                        </div>

                        <div class="liq-pick">
                            <div class="liq-pick-tools">
                                <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                            </div>
                            <div class="liq-pick-body" id="pickBody">
                                <c:choose>
                                    <c:when test="${empty selectedWarehouseId}">
                                        <div class="pick-empty">Chọn Kho hàng ở mục 01 để xem máy có sẵn.</div>
                                    </c:when>
                                    <c:when test="${empty pickRows and empty lockedRows}">
                                        <div class="pick-empty">Kho này chưa có máy phát điện đã kiểm kê khả dụng.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="pick-table">
                                            <thead>
                                                <tr>
                                                    <th class="col-cb"><input type="checkbox" id="pickAll"/></th>
                                                    <th>Serial</th>
                                                    <th>Model</th>
                                                    <th>Tình trạng</th>
                                                    <th class="col-date">Ngày nhập</th>
                                                    <th class="col-price">Giá gốc</th>
                                                    <th class="col-price">Giá thanh lý <span class="req">*</span></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${pickRows}">
                                                    <tr class="pick-trow" data-model="<c:out value='${r.model}'/>">
                                                        <td class="col-cb">
                                                            <input type="checkbox" class="pick-cb" name="serialNumber"
                                                                   value="<c:out value='${r.serialNumber}'/>"
                                                                   data-gen="${r.generatorId}"
                                                                   data-price="${r.unitPrice}"
                                                                   data-condition="${r.condition}"/>
                                                            <input type="hidden" class="gen-hidden" name="generatorId" value="${r.generatorId}" disabled/>
                                                        </td>
                                                        <td class="row-serial"><c:out value="${r.serialNumber}"/></td>
                                                        <td class="row-model"><c:out value="${r.model}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${r.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
                                                                <c:when test="${r.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                                <c:when test="${r.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
                                                                <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="col-date row-date"><c:out value="${r.createdAtStr}"/></td>
                                                        <td class="col-price row-price"><fmt:formatNumber value="${r.unitPrice}" type="number" maxFractionDigits="0"/> đ</td>
                                                        <td class="col-price">
                                                            <div class="liq-price-wrap">
                                                                <input type="text" inputmode="numeric" class="liq-price-input" name="liquidationPrice" placeholder="Nhập giá..." disabled/>
                                                                <span class="liq-price-suffix">đ</span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <%-- Máy đang bị giữ chỗ bởi đơn thanh lý khác (không chọn được) --%>
                                                <c:forEach var="lk" items="${lockedRows}">
                                                    <tr class="pick-trow is-locked">
                                                        <td class="col-cb"></td>
                                                        <td class="row-serial"><c:out value="${lk.serialNumber}"/></td>
                                                        <td class="row-model"><c:out value="${lk.model}"/></td>
                                                        <td colspan="4">
                                                            <a class="locked-pill" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${lk.liquidationId}" target="_blank">Trong đơn <c:out value="${lk.liquidationCode}"/></a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="liq-pick-bar">
                                <div id="condWarn" class="liq-cond-warn"></div>
                                <div class="bar-summary">
                                    <div class="bar-count">Đã chọn <strong id="barSelectedCount">0</strong> máy<span id="barModelCount" style="color:var(--muted);font-weight:500;"></span></div>
                                    <div class="bar-total">Tổng giá gốc: <span class="total-val" id="formTotalVal">0 đ</span></div>
                                    <div class="bar-total">Tổng giá thanh lý: <span class="total-val" id="formLiqTotalVal">0 đ</span></div>
                                </div>
                                <div class="bar-actions">
                                    <a class="btn" href="${pageContext.request.contextPath}/liquidations">Huỷ bỏ</a>
                                    <button type="submit" form="liquidationForm" class="btn btn-primary">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                        Lưu &amp; Gửi Sếp duyệt
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    // JS tối thiểu: cập nhật số máy đã chọn + tổng giá + cảnh báo máy "Tốt" khi tick.
    // Danh sách máy render sẵn ở server (JSTL); JS không dựng danh sách.
    (function () {
        var checkboxes = Array.prototype.slice.call(document.querySelectorAll('.pick-cb'));

        function fmt(n) { return Number(n || 0).toLocaleString('vi-VN'); }

        function recalc() {
            var count = 0, total = 0, liqTotal = 0, good = 0;
            var models = {};
            checkboxes.forEach(function (cb) {
                var row = cb.closest('.pick-trow');
                var genHidden = row ? row.querySelector('.gen-hidden') : null;
                var priceInput = row ? row.querySelector('.liq-price-input') : null;
                if (cb.checked) {
                    count++;
                    total += parseFloat(cb.getAttribute('data-price') || '0') || 0;
                    models[cb.getAttribute('data-gen')] = true;
                    if (cb.getAttribute('data-condition') === 'GOOD') good++;
                    if (row) row.classList.add('is-checked');
                    if (row) row.classList.toggle('cond-warn-selected', cb.getAttribute('data-condition') === 'GOOD');
                    if (genHidden) genHidden.disabled = false; // bật để submit kèm serial
                    if (priceInput) {
                        priceInput.disabled = false; // bật để submit kèm giá
                        liqTotal += parseFloat((priceInput.value || '').replace(/[^0-9]/g, '')) || 0;
                    }
                } else {
                    if (row) row.classList.remove('is-checked');
                    if (row) row.classList.remove('cond-warn-selected');
                    if (genHidden) genHidden.disabled = true;  // tắt để không submit
                    if (priceInput) priceInput.disabled = true; // tắt để không submit
                }
            });
            document.getElementById('barSelectedCount').textContent = count;
            var modelCount = Object.keys(models).length;
            document.getElementById('barModelCount').textContent = modelCount > 0 ? ' · ' + modelCount + ' model' : '';
            document.getElementById('formTotalVal').textContent = fmt(total) + ' đ';
            document.getElementById('formLiqTotalVal').textContent = fmt(liqTotal) + ' đ';

            var warnEl = document.getElementById('condWarn');
            if (warnEl) {
                if (good > 0) {
                    warnEl.textContent = '⚠ Đang chọn ' + good + ' máy tình trạng "Tốt" — cân nhắc trước khi thanh lý.';
                    warnEl.classList.add('is-shown');
                } else {
                    warnEl.classList.remove('is-shown');
                }
            }
        }

        checkboxes.forEach(function (cb) { cb.addEventListener('change', recalc); });

        // Format giá thanh lý: tự chèn dấu phẩy phân cách nghìn khi gõ + cập nhật tổng.
        function formatPriceInput(el) {
            var digits = (el.value || '').replace(/[^0-9]/g, '');
            el.value = digits ? Number(digits).toLocaleString('vi-VN') : '';
        }
        document.querySelectorAll('.liq-price-input').forEach(function (el) {
            el.addEventListener('input', function () { formatPriceInput(el); recalc(); });
        });

        // Checkbox header: chọn/bỏ tất cả các dòng đang hiển thị
        var pickAll = document.getElementById('pickAll');
        if (pickAll) {
            pickAll.addEventListener('change', function () {
                checkboxes.forEach(function (cb) {
                    var row = cb.closest('.pick-trow');
                    if (row && row.style.display !== 'none') cb.checked = pickAll.checked;
                });
                recalc();
            });
        }

        // Tìm kiếm S/N hoặc model (lọc các dòng đã render sẵn)
        var search = document.getElementById('serialSearchInput');
        if (search) {
            search.addEventListener('input', function () {
                var q = (this.value || '').toLowerCase().trim();
                document.querySelectorAll('.pick-trow').forEach(function (row) {
                    var model = (row.getAttribute('data-model') || '').toLowerCase();
                    var serialEl = row.querySelector('.row-serial');
                    var serial = serialEl ? (serialEl.textContent || '').toLowerCase() : '';
                    var show = !q || model.indexOf(q) > -1 || serial.indexOf(q) > -1;
                    row.style.display = show ? '' : 'none';
                });
            });
        }

        // Chặn submit nếu chưa chọn máy / thiếu giá / chưa chọn khách hàng
        var form = document.getElementById('liquidationForm');
        if (form) {
            form.addEventListener('submit', function (e) {
                var checked = checkboxes.filter(function (cb) { return cb.checked; });
                if (checked.length === 0) {
                    e.preventDefault();
                    alert('Phải chọn ít nhất 1 máy phát điện.');
                    return;
                }
                var missingPrice = checked.some(function (cb) {
                    var row = cb.closest('.pick-trow');
                    var priceInput = row ? row.querySelector('.liq-price-input') : null;
                    var v = priceInput ? (priceInput.value || '').replace(/[^0-9]/g, '') : '';
                    return !v || Number(v) <= 0;
                });
                if (missingPrice) {
                    e.preventDefault();
                    alert('Phải nhập giá thanh lý (lớn hơn 0) cho tất cả máy đã chọn.');
                    return;
                }
                var custId = (document.getElementById('sdHiddenId') || {}).value;
                if (!custId || !custId.trim()) {
                    e.preventDefault();
                    alert('Phải chọn khách hàng hoặc tạo khách hàng mới trước khi gửi Sếp duyệt.');
                    return;
                }
                // Bỏ dấu phẩy ở các ô giá để backend nhận số thuần
                document.querySelectorAll('.liq-price-input').forEach(function (el) {
                    el.value = (el.value || '').replace(/[^0-9]/g, '');
                });
            });
        }

        recalc();
    })();
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

<!-- Side panel chọn khách hàng (dùng searchable-dropdown.js) -->
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

<!-- Modal tạo khách hàng mới -->
<div class="modal-host" id="ncModalOverlay">
    <div class="modal modal-lg">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px;">
            <h3 style="margin:0;">Thêm khách hàng mới</h3>
            <button type="button" class="side-panel-close" onclick="closeNewCustomerModal()" title="Đóng">&times;</button>
        </div>
        <p style="font-size:13px;color:var(--muted);margin:0 0 4px;">Nhập thông tin khách hàng để tạo nhanh và gán vào đơn.</p>
        <div class="modal-error" id="ncError" style="display:none;"></div>
        <div class="modal-grid">
            <div class="field">
                <label class="field-label">Họ và tên <span class="req">*</span></label>
                <input type="text" id="ncName" class="input" placeholder="VD: Nguyễn Văn A" autocomplete="off" />
                <span class="field-error" id="ncNameErr">Vui lòng nhập họ và tên.</span>
            </div>
            <div class="field">
                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                <input type="tel" id="ncPhone" class="input mono" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" autocomplete="off" />
                <span class="field-error" id="ncPhoneErr">SĐT phải gồm 10–11 chữ số.</span>
            </div>
            <div class="field">
                <label class="field-label">Email</label>
                <input type="email" id="ncEmail" class="input mono" placeholder="email@example.com" autocomplete="off" />
                <span class="field-error" id="ncEmailErr">Email không hợp lệ.</span>
            </div>
            <div class="field">
                <label class="field-label">Loại khách hàng</label>
                <select id="ncTypeId" class="select" onchange="ncOnTypeChange()">
                    <option value="">-- Chọn loại --</option>
                    <c:forEach var="ct" items="${customerTypes}">
                        <option value="${ct.id}" data-name="${ct.name}"><c:out value="${ct.name}"/></option>
                    </c:forEach>
                </select>
            </div>
            <div class="field">
                <label class="field-label">Tên công ty <span class="req nc-company-req" style="display:none;">*</span></label>
                <input type="text" id="ncCompanyName" class="input" placeholder="VD: Công ty TNHH ABC" autocomplete="off" />
                <span class="field-error" id="ncCompanyErr">Vui lòng nhập tên công ty.</span>
            </div>
            <div class="field span-2">
                <label class="field-label">Địa chỉ</label>
                <textarea id="ncAddress" class="textarea" rows="2" placeholder="VD: Số 1, Đường ABC, Quận 1, TP.HCM"></textarea>
            </div>
        </div>
        <div class="modal-actions" style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/searchable-dropdown.js" charset="UTF-8"></script>
<script>
    // ===== Helper chọn khách hàng (đồng bộ với liquidation-detail.jsp) =====
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-host.show').forEach(function(m) { m.classList.remove('show'); });
        }
    });

    function clearCustomerSelectionLocal() {
        var hid = document.getElementById('sdHiddenId');
        if (hid) hid.value = '';
        var label = document.getElementById('custTriggerLabel');
        if (label) { label.textContent = '-- Click để chọn khách hàng --'; label.classList.remove('has-value'); }
    }
    // searchable-dropdown.js đã expose window.clearCustomerSelection; nếu thiếu thì dùng bản local.
    if (typeof window.clearCustomerSelection !== 'function') {
        window.clearCustomerSelection = clearCustomerSelectionLocal;
    }

    // ===== Modal tạo khách hàng mới (tái dùng action create_customer) =====
    function openNewCustomerModal() {
        ['ncName','ncPhone','ncEmail','ncAddress','ncCompanyName'].forEach(function(id){
            document.getElementById(id).value = '';
        });
        document.getElementById('ncTypeId').selectedIndex = 0;
        ncClearInvalid();
        ncOnTypeChange();
        hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }
    function closeNewCustomerModal() {
        document.getElementById('ncModalOverlay').classList.remove('show');
    }
    function showNcError(msg) {
        var el = document.getElementById('ncError');
        el.textContent = msg; el.style.display = 'block';
    }
    function hideNcError() {
        var el = document.getElementById('ncError');
        el.style.display = 'none';
    }

    function ncOnTypeChange() {
        var sel = document.getElementById('ncTypeId');
        var opt = sel.options[sel.selectedIndex];
        var name = (opt && opt.getAttribute('data-name') || '').toLowerCase();
        var isCompany = name.indexOf('doanh nghi') >= 0 || name.indexOf('công ty') >= 0;
        var req = document.querySelector('.nc-company-req');
        if (req) req.style.display = isCompany ? '' : 'none';
    }

    function ncSetInvalid(inputId, invalid) {
        var el = document.getElementById(inputId);
        if (!el) return;
        var field = el.closest('.field');
        if (field) field.classList.toggle('invalid', !!invalid);
    }
    function ncClearInvalid() {
        ['ncName','ncPhone','ncEmail','ncCompanyName'].forEach(function(id){ ncSetInvalid(id, false); });
    }

    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        var email = document.getElementById('ncEmail').value.trim();
        var company = document.getElementById('ncCompanyName').value.trim();
        var sel = document.getElementById('ncTypeId');
        var typeName = (sel.options[sel.selectedIndex] && sel.options[sel.selectedIndex].getAttribute('data-name') || '').toLowerCase();
        var isCompany = typeName.indexOf('doanh nghi') >= 0 || typeName.indexOf('công ty') >= 0;

        ncClearInvalid();
        hideNcError();

        var firstBad = null;
        var phoneRe = /^[0-9]{10,11}$/;
        var emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!name) { ncSetInvalid('ncName', true); firstBad = firstBad || 'ncName'; }
        if (!phone || !phoneRe.test(phone)) { ncSetInvalid('ncPhone', true); firstBad = firstBad || 'ncPhone'; }
        if (email && !emailRe.test(email)) { ncSetInvalid('ncEmail', true); firstBad = firstBad || 'ncEmail'; }
        if (isCompany && !company) { ncSetInvalid('ncCompanyName', true); firstBad = firstBad || 'ncCompanyName'; }

        if (firstBad) {
            document.getElementById(firstBad).focus();
            return;
        }

        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';

        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', email);
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', company);
        fd.append('custTypeId', sel.value);

        fetch('${pageContext.request.contextPath}/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    applyChosenCustomer(data);
                    closeNewCustomerModal();
                    if (typeof closeCustomerPanel === 'function') closeCustomerPanel();
                    if (data.existing) {
                        alert('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                    }
                } else {
                    showNcError(data.error || 'Lỗi không xác định');
                }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }

    // Điền KH vừa tạo/chọn vào form + cập nhật nhãn trigger
    function applyChosenCustomer(c) {
        var hid = document.getElementById('sdHiddenId');
        if (hid) hid.value = c.id;
        var label = document.getElementById('custTriggerLabel');
        if (label) { label.textContent = c.name || c.phone || ''; label.classList.add('has-value'); }
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
