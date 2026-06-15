<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo phiếu luân chuyển — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
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
            font-family: var(--font-ui);
        }
        .col-num {
            width: 36px;
            text-align: center;
            color: var(--muted);
            font-weight: 600;
            padding-top: 14px;
        }
        .col-del {
            width: 40px;
            text-align: center;
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
        .serial-select {
            font-family: var(--font-mono);
            font-size: 12px;
        }
        .gen-info {
            font-size: 11px;
            color: var(--muted);
            margin-top: 4px;
            display: block;
        }
        .alert-info {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 10px 14px; border-radius: var(--radius);
            background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
            font-size: 12.5px;
            margin-bottom: 12px;
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Tạo phiếu luân chuyển</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/transfers">Luân chuyển</a> / Thêm mới</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/transfers">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="page-head">
                <div class="eyebrow">Luân chuyển · Phiếu luân chuyển mới</div>
                <h2 class="page-title">Tạo phiếu luân chuyển</h2>
            </div>

            <div class="form-layout">
                <form id="transferForm" class="form-card" action="${pageContext.request.contextPath}/transfers" method="POST">
                    <input type="hidden" name="action" id="formAction" value="create" />

                    <!-- SECTION 01: THONG TIN CHUNG -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                            <h3 class="form-section-title">Kho nguồn, kho đích và ghi chú</h3>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Kho nguồn <span class="req">*</span></label>
                                <select class="input" name="sourceWarehouseId" id="sourceWarehouseId" required onchange="onSourceWarehouseChange()">
                                    <option value="">-- Chọn kho nguồn --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}">${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label">Kho đích <span class="req">*</span></label>
                                <select class="input" name="destWarehouseId" id="destWarehouseId" required onchange="onDestWarehouseChange()">
                                    <option value="">-- Chọn kho đích --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}">${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="field" style="margin-top: 14px;">
                            <label class="field-label">Ghi chú phiếu</label>
                            <textarea class="input" name="note" maxlength="500" rows="2" style="min-height: 64px; resize: vertical; font-family: var(--font-ui);" placeholder="Lý do luân chuyển, ghi chú thêm..."></textarea>
                        </div>
                    </div>

                    <!-- SECTION 02: CHI TIET SERIAL -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — CHI TIẾT SERIAL</div>
                            <h3 class="form-section-title">Danh sách serial cần chuyển (mỗi dòng = 1 serial)</h3>
                        </div>

                        <div class="alert-info">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span>Chọn kho nguồn trước, sau đó chọn serial từ danh sách bên dưới. Mỗi serial chỉ được chọn 1 lần.</span>
                        </div>

                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th style="width:60%;">Serial (S/N)</th>
                                    <th>Máy phát</th>
                                    <th>Ghi chú dòng</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <tr>
                                    <td class="col-num"><span class="row-num">1</span></td>
                                    <td>
                                        <select name="serialNumber" class="serial-select" required disabled onchange="onSerialChange(this)">
                                            <option value="">-- Chọn kho nguồn trước --</option>
                                        </select>
                                        <span class="gen-info"></span>
                                    </td>
                                    <td><span class="gen-info">—</span></td>
                                    <td><input type="text" name="detailNote" maxlength="500" placeholder="Ghi chú dòng (tùy chọn)"/></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" disabled onclick="removeRow(this)" title="Xoá dòng">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <template id="rowTemplate">
                            <tr>
                                <td class="col-num"><span class="row-num"></span></td>
                                <td>
                                    <select name="serialNumber" class="serial-select" required disabled onchange="onSerialChange(this)">
                                        <option value="">-- Chọn serial --</option>
                                    </select>
                                    <span class="gen-info"></span>
                                </td>
                                <td><span class="gen-info">—</span></td>
                                <td><input type="text" name="detailNote" maxlength="500" placeholder="Ghi chú dòng (tùy chọn)"/></td>
                                <td class="col-del">
                                    <button type="button" class="row-del-btn" disabled onclick="removeRow(this)" title="Xoá dòng">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                    </button>
                                </td>
                            </tr>
                        </template>

                        <button type="button" class="btn add-row-btn" id="addRowBtn" disabled onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </div>

                    <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/transfers">Huỷ bỏ</a>
                        <button type="button" class="btn" onclick="submitForm('create')">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Lưu phiếu (DRAFT)
                        </button>
                        <button type="button" class="btn btn-primary" onclick="submitForm('create_and_submit')">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            Tạo &amp; Gửi duyệt (Manager)
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    // Tat ca serial IN_STOCK da duoc load san tu server (request scope: allSerials)
    var allSerials = [
        <c:forEach var="sn" items="${allSerials}" varStatus="st">
        {
            inventoryId: ${sn.inventoryId},
            serialNumber: '<c:out value="${sn.serialNumber}"/>',
            generatorId: ${sn.generatorId},
            generatorModel: '<c:out value="${sn.generatorModel}"/>',
            warehouseId: ${sn.warehouseId},
            warehouseName: '<c:out value="${sn.warehouseName}"/>'
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    // Tao options cho 1 dropdown serial (chi hien thi serial cua 1 kho cu the)
    function renderSerialOptions(selectEl, warehouseId) {
        var current = selectEl.getAttribute('data-current') || '';
        var html = '<option value="">-- Chọn serial --</option>';
        for (var i = 0; i < allSerials.length; i++) {
            var s = allSerials[i];
            if (warehouseId && s.warehouseId !== parseInt(warehouseId)) continue;
            var label = s.serialNumber + ' (' + s.generatorModel + ')';
            var sel = (current && current === s.serialNumber) ? ' selected' : '';
            html += '<option value="' + s.serialNumber + '" data-warehouse-id="' + s.warehouseId + '" data-generator-id="' + s.generatorId + '" data-generator-model="' + escapeAttr(s.generatorModel) + '"' + sel + '>' + escapeHtml(label) + '</option>';
        }
        selectEl.innerHTML = html;
    }

    function escapeHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }
    function escapeAttr(s) {
        if (!s) return '';
        return String(s).replace(/"/g, '&quot;');
    }

    // Cap nhat trang thai enable/disable cua cac dropdown theo kho nguon
    function refreshAllSerialSelects() {
        var whId = document.getElementById('sourceWarehouseId').value;
        var selects = document.querySelectorAll('#detailBody .serial-select');
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            sel.disabled = !whId;
            if (whId) {
                renderSerialOptions(sel, whId);
            } else {
                sel.innerHTML = '<option value="">-- Chọn kho nguồn trước --</option>';
            }
        }
        var addBtn = document.getElementById('addRowBtn');
        if (addBtn) addBtn.disabled = !whId;
    }

    // Loc serial theo cac serial da chon o dong khac (tranh trung)
    function filterAlreadySelected() {
        var selectedSerials = {};
        var selects = document.querySelectorAll('#detailBody .serial-select');
        for (var i = 0; i < selects.length; i++) {
            var v = selects[i].value;
            if (v) selectedSerials[v] = (selects[i]);
        }
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            var currentVal = sel.value;
            for (var j = 0; j < sel.options.length; j++) {
                var opt = sel.options[j];
                if (!opt.value) continue;
                if (selectedSerials[opt.value] && opt.value !== currentVal) {
                    opt.disabled = true;
                    opt.textContent = opt.textContent.replace(' 🔒', '') + ' 🔒';
                } else {
                    opt.disabled = false;
                    opt.textContent = opt.textContent.replace(' 🔒', '');
                }
            }
        }
    }

    // Khi thay doi kho nguon
    function onSourceWarehouseChange() {
        var src = document.getElementById('sourceWarehouseId');
        var dst = document.getElementById('destWarehouseId');
        if (src.value && dst.value && src.value === dst.value) {
            toast('Kho nguồn và kho đích phải khác nhau', 'danger');
            src.value = '';
            return;
        }
        refreshAllSerialSelects();
    }

    function onDestWarehouseChange() {
        var src = document.getElementById('sourceWarehouseId');
        var dst = document.getElementById('destWarehouseId');
        if (src.value && dst.value && src.value === dst.value) {
            toast('Kho nguồn và kho đích phải khác nhau', 'danger');
            dst.value = '';
        }
    }

    // Khi chon serial trong 1 dong -> hien thi model + check trung
    function onSerialChange(sel) {
        var row = sel.closest('tr');
        var opt = sel.options[sel.selectedIndex];
        var info = row.querySelectorAll('.gen-info');
        if (opt && opt.value) {
            var model = opt.getAttribute('data-generator-model');
            if (info[0]) info[0].textContent = '';
            if (info[1]) info[1].textContent = model || '—';
        } else {
            if (info[0]) info[0].textContent = '';
            if (info[1]) info[1].textContent = '—';
        }
        filterAlreadySelected();
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        var tpl = document.getElementById('rowTemplate');
        var clone = tpl.content.cloneNode(true);
        tbody.appendChild(clone);
        var whId = document.getElementById('sourceWarehouseId').value;
        var lastSelect = tbody.lastElementChild.querySelector('.serial-select');
        if (whId) {
            lastSelect.disabled = false;
            renderSerialOptions(lastSelect, whId);
        }
        updateRowNumbers();
        filterAlreadySelected();
    }

    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
        filterAlreadySelected();
    }

    function updateRowNumbers() {
        var nums = document.querySelectorAll('#detailBody .row-num');
        for (var i = 0; i < nums.length; i++) {
            nums[i].textContent = i + 1;
        }
        // Cap nhat disabled cua button delete (row 1 khong duoc xoa)
        var delBtns = document.querySelectorAll('#detailBody .row-del-btn');
        for (var i = 0; i < delBtns.length; i++) {
            delBtns[i].disabled = (delBtns.length <= 1);
        }
    }

    function submitForm(action) {
        document.getElementById('formAction').value = action;
        if (validateTransferForm()) {
            document.getElementById('transferForm').submit();
        }
    }

    function validateTransferForm() {
        var src = document.getElementById('sourceWarehouseId').value;
        var dst = document.getElementById('destWarehouseId').value;
        if (!src) { toast('Vui lòng chọn kho nguồn', 'danger'); return false; }
        if (!dst) { toast('Vui lòng chọn kho đích', 'danger'); return false; }
        if (src === dst) { toast('Kho nguồn và kho đích phải khác nhau', 'danger'); return false; }

        var selects = document.querySelectorAll('#detailBody .serial-select');
        var hasSerial = false;
        var seenSerials = {};
        for (var i = 0; i < selects.length; i++) {
            if (selects[i].value) {
                if (seenSerials[selects[i].value]) {
                    toast('Serial "' + selects[i].value + '" bị trùng', 'danger');
                    return false;
                }
                seenSerials[selects[i].value] = true;
                hasSerial = true;
            }
        }
        if (!hasSerial) { toast('Vui lòng chọn ít nhất 1 serial', 'danger'); return false; }
        return true;
    }

    // Khoi tao: cap nhat trang thai row 1
    document.addEventListener('DOMContentLoaded', function() {
        updateRowNumbers();
    });

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
</body>
</html>
