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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/liquidation.css">
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
                            <div class="form-section-num">02 — LÝ DO &amp; CHỌN MÁY</div>
                            <h3 class="form-section-title">Lý do thanh lý và máy phát điện</h3>
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
                                                    </tr>
                                                </c:forEach>

                                                <%-- Máy đang bị giữ chỗ bởi đơn thanh lý khác (không chọn được) --%>
                                                <c:forEach var="lk" items="${lockedRows}">
                                                    <tr class="pick-trow is-locked">
                                                        <td class="col-cb"></td>
                                                        <td class="row-serial"><c:out value="${lk.serialNumber}"/></td>
                                                        <td class="row-model"><c:out value="${lk.model}"/></td>
                                                        <td colspan="3">
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
                                </div>
                                <div class="bar-actions">
                                    <a class="btn" href="${pageContext.request.contextPath}/liquidations">Huỷ bỏ</a>
                                    <button type="submit" form="liquidationForm" class="btn btn-primary">
                                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                        Lưu &amp; Đề xuất
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
            var count = 0, total = 0, good = 0;
            var models = {};
            checkboxes.forEach(function (cb) {
                var row = cb.closest('.pick-trow');
                var genHidden = row ? row.querySelector('.gen-hidden') : null;
                if (cb.checked) {
                    count++;
                    total += parseFloat(cb.getAttribute('data-price') || '0') || 0;
                    models[cb.getAttribute('data-gen')] = true;
                    if (cb.getAttribute('data-condition') === 'GOOD') good++;
                    if (row) row.classList.add('is-checked');
                    if (row) row.classList.toggle('cond-warn-selected', cb.getAttribute('data-condition') === 'GOOD');
                    if (genHidden) genHidden.disabled = false; // bật để submit kèm serial
                } else {
                    if (row) row.classList.remove('is-checked');
                    if (row) row.classList.remove('cond-warn-selected');
                    if (genHidden) genHidden.disabled = true;  // tắt để không submit
                }
            });
            document.getElementById('barSelectedCount').textContent = count;
            var modelCount = Object.keys(models).length;
            document.getElementById('barModelCount').textContent = modelCount > 0 ? ' · ' + modelCount + ' model' : '';
            document.getElementById('formTotalVal').textContent = fmt(total) + ' đ';

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

        // Chặn submit nếu chưa chọn máy nào
        var form = document.getElementById('liquidationForm');
        if (form) {
            form.addEventListener('submit', function (e) {
                var anyChecked = checkboxes.some(function (cb) { return cb.checked; });
                if (!anyChecked) {
                    e.preventDefault();
                    alert('Phải chọn ít nhất 1 máy phát điện.');
                }
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
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
