<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sửa đơn thanh lý — Warehouse OS</title>
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
            <h1>Sửa đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / Sửa đơn #${liquidation.liquidationCode}</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết
            </a>

            <div class="page-head">
                <div class="eyebrow">Thanh lý · Cập nhật đơn thanh lý</div>
                <h2 class="page-title">Sửa đơn #${liquidation.liquidationCode}</h2>
            </div>

            <div class="form-layout form-layout--full">
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <c:if test="${not empty liquidation.managerFeedbackName}">
                        <div class="feedback-banner feedback-banner--from-mgr">
                            <div class="body">
                                <div class="feedback-banner__label">Phản hồi từ Quản lý kho</div>
                                <div class="feedback-banner__body">${liquidation.managerFeedbackName}</div>
                            </div>
                        </div>
                    </c:if>

                    <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                        <input type="hidden" name="action" value="edit_submit" />
                        <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
                        <input type="hidden" name="customerId" id="customerIdHidden" value="${liquidation.customerId}" />

                        <!-- SECTION 01: THÔNG TIN CHUNG -->
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="form-section-title">Kho hàng và Lý do thanh lý</h3>
                            </div>

                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Kho hàng</label>
                                    <select class="input" disabled>
                                        <c:forEach var="w" items="${warehouses}">
                                            <c:if test="${w.warehouseId == liquidation.warehouseId}"><option selected>${w.name}</option></c:if>
                                        </c:forEach>
                                    </select>
                                    <input type="hidden" name="warehouseId" id="warehouseId" value="${liquidation.warehouseId}" />
                                </div>

                                <div class="field">
                                    <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                    <select class="input" name="reasonId" required>
                                        <c:forEach var="r" items="${reasons}">
                                            <option value="${r.id}" ${r.id == liquidation.reasonId ? 'selected' : ''}>${r.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- SECTION 02: CHỌN MÁY (List 1 cột + sticky bar) -->
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — CHỌN MÁY</div>
                                <h3 class="form-section-title">Chọn máy phát điện thanh lý</h3>
                            </div>

                            <div class="liq-pick">
                                <div class="liq-pick-tools">
                                    <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm S/N hoặc model..." autocomplete="off"/>
                                </div>
                                <div class="liq-pick-body" id="pickBody">
                                    <c:choose>
                                        <c:when test="${empty genGroups}">
                                            <div class="pick-empty">Kho này chưa có máy phát điện khả dụng.</div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="g" items="${genGroups}">
                                                <div class="pick-group" data-model="<c:out value='${g.model}'/>">
                                                    <div class="pick-group-head">
                                                        <span class="model"><c:out value="${g.model}"/></span>
                                                        <span class="count">${g.serials.size()} máy</span>
                                                        <span class="price"><fmt:formatNumber value="${g.unitPrice}" type="number" maxFractionDigits="0"/> đ</span>
                                                    </div>
                                                    <div class="pick-group-body">
                                                        <c:forEach var="s" items="${g.serials}">
                                                            <label class="pick-row ${s.selected ? 'is-checked' : ''}">
                                                                <input type="checkbox" class="pick-cb" name="serialNumber"
                                                                       value="<c:out value='${s.serialNumber}'/>"
                                                                       data-gen="${g.generatorId}"
                                                                       data-price="${g.unitPrice}"
                                                                       ${s.selected ? 'checked' : ''}/>
                                                                <input type="hidden" class="gen-hidden" name="generatorId" value="${g.generatorId}" ${s.selected ? '' : 'disabled'}/>
                                                                <span class="age-dot"></span>
                                                                <span class="row-serial"><c:out value="${s.serialNumber}"/></span>
                                                                <span class="row-price"><fmt:formatNumber value="${g.unitPrice}" type="number" maxFractionDigits="0"/> đ</span>
                                                            </label>
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="liq-pick-bar">
                                    <div class="bar-summary">
                                        <div class="bar-count">Đã chọn <strong id="barSelectedCount">0</strong> máy<span id="barModelCount" style="color:var(--muted);font-weight:500;"></span></div>
                                        <div class="bar-total">Tổng giá gốc: <span class="total-val" id="formTotalVal">0 đ</span></div>
                                    </div>
                                    <div class="bar-actions">
                                        <a class="btn" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">Huỷ bỏ</a>
                                        <button type="submit" form="liquidationForm" class="btn btn-primary">
                                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                            Lưu &amp; Đề xuất lại
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    // JS tối thiểu: chỉ cập nhật số máy đã chọn + tổng giá khi tick checkbox.
    // Danh sách máy được render sẵn ở server (JSP/JSTL), JS không dựng danh sách.
    (function () {
        var checkboxes = Array.prototype.slice.call(document.querySelectorAll('.pick-cb'));

        function fmt(n) { return Number(n || 0).toLocaleString('vi-VN'); }

        function recalc() {
            var count = 0, total = 0;
            var models = {};
            checkboxes.forEach(function (cb) {
                var row = cb.closest('.pick-row');
                var genHidden = row ? row.querySelector('.gen-hidden') : null;
                if (cb.checked) {
                    count++;
                    total += parseFloat(cb.getAttribute('data-price') || '0') || 0;
                    models[cb.getAttribute('data-gen')] = true;
                    if (row) row.classList.add('is-checked');
                    if (genHidden) genHidden.disabled = false; // bật để submit kèm serial
                } else {
                    if (row) row.classList.remove('is-checked');
                    if (genHidden) genHidden.disabled = true;  // tắt để không submit
                }
            });
            document.getElementById('barSelectedCount').textContent = count;
            var modelCount = Object.keys(models).length;
            document.getElementById('barModelCount').textContent = modelCount > 0 ? ' · ' + modelCount + ' model' : '';
            document.getElementById('formTotalVal').textContent = fmt(total) + ' đ';
        }

        checkboxes.forEach(function (cb) {
            cb.addEventListener('change', recalc);
        });

        // Tìm kiếm S/N hoặc model (lọc các nhóm/dòng đã render sẵn)
        var search = document.getElementById('serialSearchInput');
        if (search) {
            search.addEventListener('input', function () {
                var q = (this.value || '').toLowerCase().trim();
                document.querySelectorAll('.pick-group').forEach(function (group) {
                    var model = (group.getAttribute('data-model') || '').toLowerCase();
                    var modelMatch = model.indexOf(q) > -1;
                    var anyRow = false;
                    group.querySelectorAll('.pick-row').forEach(function (row) {
                        var serial = (row.querySelector('.row-serial').textContent || '').toLowerCase();
                        var show = !q || modelMatch || serial.indexOf(q) > -1;
                        row.style.display = show ? '' : 'none';
                        if (show) anyRow = true;
                    });
                    group.style.display = anyRow ? '' : 'none';
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
