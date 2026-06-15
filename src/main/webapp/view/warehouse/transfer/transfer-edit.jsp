<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sửa phiếu luân chuyển — Warehouse OS</title>
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
            <h1>Sửa phiếu luân chuyển</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/transfers">Luân chuyển</a> / Sửa đơn #${transfer.transferCode}</span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/transfers?action=detail&id=${transfer.transferId}">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết
            </a>

            <div class="page-head">
                <div class="eyebrow">Luân chuyển · Cập nhật phiếu</div>
                <h2 class="page-title">Sửa phiếu #${transfer.transferCode}</h2>
            </div>

            <div class="form-layout">
                <form id="transferForm" class="form-card" action="${pageContext.request.contextPath}/transfers" method="POST" onsubmit="return validateTransferForm()">
                    <input type="hidden" name="action" value="edit_submit" />
                    <input type="hidden" name="id" value="${transfer.transferId}" />

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
                                        <option value="${w.warehouseId}" ${w.warehouseId == transfer.sourceWarehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label">Kho đích <span class="req">*</span></label>
                                <select class="input" name="destWarehouseId" id="destWarehouseId" required onchange="onDestWarehouseChange()">
                                    <option value="">-- Chọn kho đích --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${w.warehouseId == transfer.destWarehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="field" style="margin-top: 14px;">
                            <label class="field-label">Ghi chú phiếu</label>
                            <textarea class="input" name="note" maxlength="500" rows="2" style="min-height: 64px; resize: vertical; font-family: var(--font-ui);">${transfer.note}</textarea>
                        </div>
                    </div>

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
                                <c:choose>
                                    <c:when test="${not empty transfer.details}">
                                        <c:forEach var="d" items="${transfer.details}" varStatus="status">
                                        <tr>
                                            <td class="col-num"><span class="row-num">${status.index + 1}</span></td>
                                            <td>
                                                <select name="serialNumber" class="serial-select" required onchange="onSerialChange(this)">
                                                    <option value="${d.serialNumber}" data-warehouse-id="${transfer.sourceWarehouseId}" data-generator-id="${d.generatorId}" data-current-serial="${d.serialNumber}">${d.serialNumber}</option>
                                                </select>
                                                <span class="gen-info"></span>
                                            </td>
                                            <td><span class="gen-info">${d.generatorModel != null ? d.generatorModel : '—'}</span></td>
                                            <td><input type="text" name="detailNote" maxlength="500" value="${d.note}" placeholder="Ghi chú dòng (tùy chọn)"/></td>
                                            <td class="col-del">
                                                <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
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
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 6 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
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

                        <button type="button" class="btn add-row-btn" id="addRowBtn" onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </div>

                    <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/transfers?action=detail&id=${transfer.transferId}">Huỷ bỏ</a>
                        <button type="submit" form="transferForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Cập nhật phiếu
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

    function renderSerialOptions(selectEl, warehouseId) {
        var current = selectEl.getAttribute('data-current-serial') || selectEl.value || '';
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

    function filterAlreadySelected() {
        var selectedSerials = {};
        var selects = document.querySelectorAll('#detailBody .serial-select');
        for (var i = 0; i < selects.length; i++) {
            var v = selects[i].value;
            if (v) selectedSerials[v] = true;
        }
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            var currentVal = sel.value;
            for (var j = 0; j < sel.options.length; j++) {
                var opt = sel.options[j];
                if (!opt.value) continue;
                if (selectedSerials[opt.value] && opt.value !== currentVal) {
                    opt.disabled = true;
                    if (opt.textContent.indexOf(' 🔒') === -1) opt.textContent += ' 🔒';
                } else {
                    opt.disabled = false;
                    opt.textContent = opt.textContent.replace(' 🔒', '');
                }
            }
        }
    }

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

    function onSerialChange(sel) {
        var row = sel.closest('tr');
        var opt = sel.options[sel.selectedIndex];
        var info = row.querySelectorAll('.gen-info');
        if (opt && opt.value) {
            var model = opt.getAttribute('data-generator-model');
            if (info[1]) info[1].textContent = model || '—';
        } else {
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
        var delBtns = document.querySelectorAll('#detailBody .row-del-btn');
        for (var i = 0; i < delBtns.length; i++) {
            delBtns[i].disabled = (delBtns.length <= 1);
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

    // Khoi tao
    document.addEventListener('DOMContentLoaded', function() {
        refreshAllSerialSelects();
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
