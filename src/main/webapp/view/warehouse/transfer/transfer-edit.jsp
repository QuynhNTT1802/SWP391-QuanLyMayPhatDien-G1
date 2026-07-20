<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        .detail-table { width:100%; border-collapse:collapse; margin-top:8px; }
        .detail-table th { text-align:left; padding:8px 10px; font-size:12px; font-weight:600; color:var(--muted); border-bottom:1px solid var(--border); text-transform:uppercase; letter-spacing:0.5px; }
        .detail-table td { padding:8px 6px; vertical-align:top; }
        .detail-table select, .detail-table input { width:100%; padding:7px 8px; border:1px solid var(--border); border-radius:var(--radius-sm); background:var(--bg); color:var(--fg); font-size:13px; box-sizing:border-box; font-family:var(--font-ui); }
        .col-num { width:36px; text-align:center; color:var(--muted); font-weight:600; padding-top:14px; }
        .col-del { width:40px; text-align:center; }
        .col-qty { width:130px; }
        .qty-input { width:100%; padding:7px 8px; border:1px solid var(--border); border-radius:var(--radius-sm); background:var(--bg); color:var(--fg); font-size:13px; box-sizing:border-box; font-family:var(--font-ui); }
        .qty-input.is-invalid { border-color:var(--danger); color:var(--danger); }
        .row-del-btn { width:28px; height:28px; border:none; background:none; color:var(--danger); cursor:pointer; border-radius:var(--radius-sm); margin-top:4px; }
        .row-del-btn:hover { background:var(--danger-soft); }
        .add-row-btn { margin-top:8px; font-size:13px; }
        .alert-info { display:flex; align-items:flex-start; gap:10px; padding:10px 14px; border-radius:var(--radius); background:var(--accent-soft); color:var(--accent); border:1px solid color-mix(in srgb, var(--accent) 25%, transparent); font-size:12.5px; margin-bottom:12px; }
        .alert-warn { display:flex; align-items:flex-start; gap:10px; padding:12px 14px; border-radius:var(--radius); background:var(--warn-soft); color:var(--warn); border:1px solid color-mix(in srgb, var(--warn) 25%, transparent); font-size:13px; line-height:1.5; margin-bottom:12px; }
        .alert-warn svg { flex-shrink:0; margin-top:2px; }
        .alert-warn .alert-body { flex:1; }
        .alert-warn pre { margin:6px 0 0; font-family:inherit; font-size:13px; white-space:pre-wrap; word-break:break-word; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Sửa phiếu luân chuyển</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/transfers">Luân chuyển</a> / Sửa đơn #${transfer.transferCode}</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/transfers?action=detail&id=${transfer.transferId}">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết
            </a>

            <c:if test="${isRevision && (not empty transfer.managerNote or not empty transfer.ceoNote)}">
                <div class="alert-warn" style="margin-top:14px;">
                    <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <strong>Yêu cầu chỉnh sửa từ người duyệt</strong>
                        <pre><c:out value="${not empty transfer.managerNote ? transfer.managerNote : transfer.ceoNote}"/></pre>
                    </div>
                </div>
            </c:if>

            <div class="page-head">
                <div class="eyebrow">Luân chuyển · Cập nhật phiếu</div>
                <h2 class="page-title">Sửa phiếu #${transfer.transferCode}</h2>
            </div>

            <c:set var="inStockJson" value=""/>
            <c:forEach var="entry" items="${inStockByGen}">
                <c:set var="inStockJson" value="${inStockJson}${entry.key}:${entry.value},"/>
            </c:forEach>

            <div class="form-layout">
                <form id="transferForm" class="form-card" action="${pageContext.request.contextPath}/transfers" method="POST">
                    <input type="hidden" name="action" value="edit_submit" />
                    <input type="hidden" name="id" value="${transfer.transferId}" />

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
                                        <option value="${w.warehouseId}" ${w.warehouseId == transfer.sourceWarehouseId ? 'selected' : ''}><c:out value="${w.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="field">
                                <label class="field-label">Kho đích <span class="req">*</span></label>
                                <select class="input" name="destWarehouseId" id="destWarehouseId" required onchange="onDestWarehouseChange()">
                                    <option value="">-- Chọn kho đích --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${w.warehouseId == transfer.destWarehouseId ? 'selected' : ''}><c:out value="${w.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div id="warehouseWarning" class="alert-warn" style="display:none; margin-top:10px;">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span id="warehouseWarningText"></span>
                        </div>

                        <div class="field" style="margin-top:14px;">
                            <label class="field-label">Ghi chú phiếu</label>
                            <textarea class="input" name="note" maxlength="500" rows="2"
                                      style="min-height:64px;resize:vertical;font-family:var(--font-ui);">${transfer.note}</textarea>
                        </div>
                    </div>

                    <!-- SECTION 02: SO LUONG DE XUAT -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — ĐỀ XUẤT SỐ LƯỢNG</div>
                            <h3 class="form-section-title">Số lượng từng dòng máy cần chuyển</h3>
                        </div>

                        <div class="alert-info">
                            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span>Mỗi dòng chỉ cần chọn dòng máy và số lượng. <strong>Số serial cụ thể sẽ được quét khi tạo phiếu xuất</strong> sau khi CEO duyệt phiếu đề xuất này.</span>
                        </div>

                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th>Dòng máy (tồn kho)</th>
                                    <th class="col-qty">Số lượng đề xuất</th>
                                    <th>Ghi chú dòng</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${not empty detailQtyMap}">
                                        <c:set var="genIds" value=""/>
                                        <c:forEach var="entry" items="${detailQtyMap}" varStatus="st">
                                            <c:set var="gid" value="${entry.key}"/>
                                            <c:set var="qty" value="${entry.value}"/>
                                            <c:set var="note" value="${detailNoteMap[gid]}"/>
                                        <tr>
                                            <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                            <td>
                                                <select class="serial-select generator-select" name="generatorId" required onchange="onGeneratorChange(this)">
                                                    <option value="">-- Chọn dòng máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}" data-stock="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}" ${g.id == gid ? 'selected' : ''}><c:out value="${g.model}"/> (<c:out value="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}"/>)</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" min="1" max="100000" value="${qty}" required class="qty-input" oninput="onQuantityChange(this)" />
                                            </td>
                                            <td><input type="text" name="detailNote" maxlength="500" placeholder="Ghi chú dòng (tùy chọn)" value="<c:out value='${note}'/>"/></td>
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
                                                <select class="serial-select generator-select" name="generatorId" required onchange="onGeneratorChange(this)">
                                                    <option value="">-- Chọn dòng máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}" data-stock="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}"><c:out value="${g.model}"/> (<c:out value="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}"/>)</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" min="1" max="100000" value="1" required class="qty-input" oninput="onQuantityChange(this)" />
                                            </td>
                                            <td><input type="text" name="detailNote" maxlength="500" placeholder="Ghi chú dòng (tùy chọn)"/></td>
                                            <td class="col-del">
                                                <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <button type="button" class="btn add-row-btn" onclick="addRow()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </div>

                    <div class="form-actions" style="margin-top:24px;display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/transfers?action=detail&id=${transfer.transferId}">Huỷ bỏ</a>
                        <button type="submit" class="btn btn-primary" onclick="return validateForm()">
                            <c:choose>
                                <c:when test="${isRevision}">Lưu &amp; gửi lại duyệt</c:when>
                                <c:otherwise>Cập nhật phiếu</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<select id="genOptionsTpl" style="display:none">
    <c:forEach var="g" items="${generators}">
        <option value="${g.id}" data-stock="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}"><c:out value="${g.model}"/> (còn <c:out value="${inStockByGen[g.id] != null ? inStockByGen[g.id] : 0}"/>)</option>
    </c:forEach>
</select>

<div class="toast-host" id="toastHost"></div>
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
window.WAREHOUSE_DATA = ${warehouseDataJson};

(function () {
    function escapeHtml(s) {
        if (s == null) return '';
        var d = document.createElement('div');
        d.textContent = String(s);
        return d.innerHTML;
    }

    function buildOptionsHtml(items) {
        var html = '<option value="">-- Chọn dòng máy --</option>';
        for (var i = 0; i < items.length; i++) {
            var g = items[i];
            var qty = g.q != null ? g.q : 0;
            html += '<option value="' + g.id + '" data-stock="' + qty + '">' + escapeHtml(g.m) + ' (còn ' + qty + ' máy)</option>';
        }
        return html;
    }

    function getWarehouseGenerators(whId) {
        if (!whId) return [];
        var data = window.WAREHOUSE_DATA || {};
        return data[whId] || data[String(whId)] || [];
    }

    function repopulateGeneratorSelects(whId) {
        var items = getWarehouseGenerators(whId);
        var html = whId
            ? buildOptionsHtml(items)
            : '<option value="">-- Chọn kho nguồn trước --</option>';
        var tpl = document.getElementById('genOptionsTpl');
        if (tpl) tpl.innerHTML = html;
        var selects = document.querySelectorAll('select.generator-select');
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            var prev = sel.value;
            sel.innerHTML = html;
            if (prev) {
                var stillExists = false;
                for (var j = 0; j < sel.options.length; j++) {
                    if (sel.options[j].value === prev) { stillExists = true; break; }
                }
                if (stillExists) sel.value = prev;
                else sel.value = '';
            } else {
                sel.value = '';
            }
            updateRowMax(sel.closest('tr'));
        }
    }

    function updateRowMax(tr) {
        var sel = tr.querySelector('.generator-select');
        var qtyInput = tr.querySelector('input[name="quantity"]');
        if (!sel || !qtyInput) return;
        if (!sel.value) {
            qtyInput.removeAttribute('max');
            qtyInput.setCustomValidity('');
            qtyInput.classList.remove('is-invalid');
            return;
        }
        var opt = sel.options[sel.selectedIndex];
        var stock = opt ? parseInt(opt.getAttribute('data-stock') || '0', 10) : 0;
        qtyInput.max = stock > 0 ? stock : 1;
        var qty = parseInt(qtyInput.value || '0', 10);
        if (stock <= 0) {
            qtyInput.setCustomValidity('Máy này hiện không có tồn kho');
            qtyInput.classList.add('is-invalid');
        } else if (qty > stock) {
            qtyInput.setCustomValidity('Số lượng vượt quá tồn kho (' + stock + ' máy)');
            qtyInput.classList.add('is-invalid');
        } else {
            qtyInput.setCustomValidity('');
            qtyInput.classList.remove('is-invalid');
        }
    }

    function onGeneratorChange(sel) {
        var tr = sel.closest('tr');
        updateRowMax(tr);
        validatePairRealtime();
    }

    function onQuantityChange(qtyInput) {
        updateRowMax(qtyInput.closest('tr'));
    }

    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.children.length <= 1) return;
        var tr = btn.closest('tr');
        tr.parentNode.removeChild(tr);
        renumberRows();
    }

    function renumberRows() {
        var rows = document.querySelectorAll('#detailBody tr');
        rows.forEach(function (row, idx) {
            var num = row.querySelector('.row-num');
            if (num) num.textContent = (idx + 1);
        });
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        var src = document.getElementById('sourceWarehouseId').value;
        var tpl = document.getElementById('genOptionsTpl');
        var selOptions;
        if (src) {
            selOptions = buildOptionsHtml(getWarehouseGenerators(src));
            if (tpl) tpl.innerHTML = selOptions;
        } else if (tpl) {
            selOptions = tpl.innerHTML;
        } else {
            selOptions = '<option value="">-- Chọn dòng máy --</option>';
        }
        var tr = document.createElement('tr');
        var selectDisabled = src ? '' : ' disabled';
        tr.innerHTML = ''
            + '<td class="col-num"><span class="row-num"></span></td>'
            + '<td><select class="serial-select generator-select" name="generatorId" required onchange="onGeneratorChange(this)"' + selectDisabled + '>'
            + selOptions
            + '</select></td>'
            + '<td><input type="number" name="quantity" min="1" max="100000" value="1" required class="qty-input" oninput="onQuantityChange(this)" /></td>'
            + '<td><input type="text" name="detailNote" maxlength="500" placeholder="Ghi chú dòng (tùy chọn)" /></td>'
            + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">'
            + '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>'
            + '</button></td>';
        tbody.appendChild(tr);
        renumberRows();
        updateRowMax(tr);
    }

    function getSubmitBtn() {
        return document.querySelector('form#transferForm button[type="submit"]');
    }

    function validatePairRealtime() {
        var src = document.getElementById('sourceWarehouseId').value;
        var dst = document.getElementById('destWarehouseId').value;
        var warning = document.getElementById('warehouseWarning');
        var warningText = document.getElementById('warehouseWarningText');
        var submitBtn = getSubmitBtn();
        if (src && dst && src === dst) {
            warningText.textContent = 'Kho nguồn và kho đích phải khác nhau';
            warning.style.display = 'flex';
            if (submitBtn) submitBtn.disabled = true;
            return false;
        }
        if (src && dst) {
            warning.style.display = 'none';
        }
        if (submitBtn) submitBtn.disabled = false;
        return true;
    }

    function onSourceWarehouseChange() {
        var src = document.getElementById('sourceWarehouseId').value;
        repopulateGeneratorSelects(src);
        validatePairRealtime();
    }

    function onDestWarehouseChange() {
        validatePairRealtime();
    }

    function validateForm() {
        var src = document.getElementById('sourceWarehouseId').value;
        var dst = document.getElementById('destWarehouseId').value;
        if (!src || !dst) {
            showToast('Vui lòng chọn kho nguồn và kho đích', 'danger');
            return false;
        }
        if (!validatePairRealtime()) {
            showToast('Kho nguồn và kho đích phải khác nhau', 'danger');
            return false;
        }
        var rows = document.querySelectorAll('#detailBody tr');
        var messages = [];
        rows.forEach(function (tr) {
            var genId = tr.querySelector('.generator-select').value;
            var qty = parseInt(tr.querySelector('input[name="quantity"]').value || '0', 10);
            if (genId && qty > 0) {
                var sel = tr.querySelector('.generator-select');
                var opt = sel.options[sel.selectedIndex];
                var stock = opt ? parseInt(opt.getAttribute('data-stock') || '0', 10) : 0;
                var label = opt ? opt.textContent.split('(')[0].trim() : 'dòng ' + (tr.querySelector('.row-num') ? tr.querySelector('.row-num').textContent : '?');
                if (stock <= 0) {
                    messages.push('Dòng "' + label + '" hiện không có tồn kho');
                } else if (qty > stock) {
                    messages.push('Dòng "' + label + '" yêu cầu ' + qty + ' nhưng chỉ còn ' + stock);
                }
            }
        });
        if (messages.length > 0) {
            showToast(messages.join(' | '), 'danger');
            return false;
        }
        return true;
    }

    window.addRow = addRow;
    window.removeRow = removeRow;
    window.onGeneratorChange = onGeneratorChange;
    window.onSourceWarehouseChange = onSourceWarehouseChange;
    window.onDestWarehouseChange = onDestWarehouseChange;

    document.addEventListener('DOMContentLoaded', function () {
        renumberRows();
        document.querySelectorAll('#detailBody tr').forEach(updateRowMax);
        var initialSrc = document.getElementById('sourceWarehouseId').value;
        repopulateGeneratorSelects(initialSrc);
        validatePairRealtime();
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
})();
</script>
</body>
</html>
