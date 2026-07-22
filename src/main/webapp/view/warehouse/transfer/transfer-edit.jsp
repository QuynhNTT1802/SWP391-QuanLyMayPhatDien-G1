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
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    <style>
        .detail-table { width:100%; border-collapse:collapse; margin-top:8px; }
        .req { color: var(--danger); font-weight: 700; }
        .form-field label .req { color: var(--danger); font-weight: 700; }
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
        .alert-warn { display:flex; align-items:flex-start; gap:10px; padding:12px 14px; border-radius:var(--radius); background:var(--warn-soft); color:var(--warn); border:1px solid color-mix(in srgb, var(--warn) 25%, transparent); font-size:13px; line-height:1.5; margin-bottom:12px; }
        .alert-warn svg { flex-shrink:0; margin-top:2px; }
        .alert-warn .alert-body { flex:1; }
        .alert-warn pre { margin:6px 0 0; font-family:inherit; font-size:13px; white-space:pre-wrap; word-break:break-word; }
        .confirm-summary {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 14px 16px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            margin: 6px 0 4px;
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
        .confirm-row span {
            color: var(--muted);
            font-weight: 500;
        }
        .confirm-row strong {
            color: var(--fg);
            font-weight: 600;
            text-align: right;
            word-break: break-word;
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
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="receipt-back-link" href="javascript:void(0)" onclick="confirmCancelEdit()">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại chi tiết
            </a>

            <div class="hero-body">
                <div class="hero-meta">
                    <span>Cập nhật phiếu luân chuyển <span class="id">#${transfer.transferCode}</span></span>
                </div>
            </div>

            <c:if test="${isRevision && (not empty transfer.managerNote or not empty transfer.ceoNote)}">
                <div class="alert alert-warn" style="margin: 16px 0;">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <div class="alert-title">Yêu cầu chỉnh sửa từ người duyệt</div>
                        <pre style="margin:6px 0 0;font-family:inherit;font-size:13px;white-space:pre-wrap;word-break:break-word;"><c:out value="${not empty transfer.managerNote ? transfer.managerNote : transfer.ceoNote}"/></pre>
                    </div>
                </div>
            </c:if>

            <c:set var="inStockJson" value=""/>
            <c:forEach var="entry" items="${inStockByGen}">
                <c:set var="inStockJson" value="${inStockJson}${entry.key}:${entry.value},"/>
            </c:forEach>

            <form id="transferForm" action="${pageContext.request.contextPath}/transfers" method="POST">
                <input type="hidden" name="action" value="edit_submit" />
                <input type="hidden" name="id" value="${transfer.transferId}" />

                <div class="content">
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="section-title">Kho nguồn, kho đích và ghi chú</h3>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-field">
                                <label>Kho nguồn <span class="req">*</span></label>
                                <select class="input" name="sourceWarehouseId" id="sourceWarehouseId" required onchange="onSourceWarehouseChange()">
                                    <option value="">-- Chọn kho nguồn --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${w.warehouseId == transfer.sourceWarehouseId ? 'selected' : ''}><c:out value="${w.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-field">
                                <label>Kho đích <span class="req">*</span></label>
                                <select class="input" name="destWarehouseId" id="destWarehouseId" required onchange="onDestWarehouseChange()">
                                    <option value="">-- Chọn kho đích --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" data-warehouse-name="<c:out value='${w.name}'/>" ${w.warehouseId == transfer.destWarehouseId ? 'selected' : ''}><c:out value="${w.name}"/></option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-field full">
                                <label>Ghi chú phiếu</label>
                                <textarea class="input" name="note" maxlength="500" rows="2"
                                          style="min-height: 64px; resize: vertical; font-family: var(--font-ui);"><c:out value="${transfer.note}"/></textarea>
                            </div>
                        </div>

                        <div id="warehouseWarning" class="alert alert-warn" style="display:none; margin-top: 10px;">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span id="warehouseWarningText"></span>
                        </div>
                    </section>

                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — ĐỀ XUẤT SỐ LƯỢNG</div>
                                <h3 class="section-title">Số lượng từng dòng máy cần chuyển</h3>
                            </div>
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
                    </section>
                </div>
            </form>

            <div class="modal-host" id="saveConfirmModal" onclick="if (event.target === this) closeSaveConfirm();">
                <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="saveConfirmTitle">
                    <h3 id="saveConfirmTitle">
                        <c:choose>
                            <c:when test="${isRevision}">Xác nhận lưu &amp; gửi lại duyệt</c:when>
                            <c:otherwise>Xác nhận cập nhật phiếu</c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="modal-sub">Vui lòng kiểm tra thông tin trước khi lưu phiếu.</p>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeSaveConfirm()">Hủy</button>
                        <button type="button" class="btn btn-primary" id="saveConfirmBtn" onclick="doConfirmSave()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            <span id="saveConfirmBtnLabel">
                                <c:choose>
                                    <c:when test="${isRevision}">Lưu &amp; gửi lại</c:when>
                                    <c:otherwise>Xác nhận cập nhật</c:otherwise>
                                </c:choose>
                            </span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="bottom-actions">
                <a class="btn" href="javascript:void(0)" onclick="confirmCancelEdit()">Huỷ</a>
                <button type="submit" form="transferForm" class="btn btn-primary" onclick="return openSaveConfirm()">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    <c:choose>
                        <c:when test="${isRevision}">Lưu &amp; gửi lại duyệt</c:when>
                        <c:otherwise>Cập nhật phiếu</c:otherwise>
                    </c:choose>
                </button>
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
<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function confirmCancelEdit() {
        if (confirm('Bạn có chắc muốn huỷ sửa phiếu luân chuyển?')) {
            location.href = window.APP_CTX + '/transfers?action=detail&id=${transfer.transferId}';
        }
    }

    // ========== Confirm Save Modal ==========
    function openSaveConfirm() {
        if (typeof validateForm === 'function' && !validateForm()) {
            return false;
        }
        populateSaveSummary();
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.add('show');
        return false;
    }

    function closeSaveConfirm() {
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.remove('show');
    }

    function doConfirmSave() {
        closeSaveConfirm();
        var form = document.getElementById('transferForm');
        if (form) form.submit();
    }

    function populateSaveSummary() {
        var srcEl = document.getElementById('saveSummarySource');
        var destEl = document.getElementById('saveSummaryDest');
        var rowsEl = document.getElementById('saveSummaryRows');
        var srcSel = document.getElementById('sourceWarehouseId');
        var destSel = document.getElementById('destWarehouseId');
        if (srcEl && srcSel) {
            srcEl.textContent = srcSel.options[srcSel.selectedIndex]
                ? srcSel.options[srcSel.selectedIndex].textContent.trim() : '—';
        }
        if (destEl && destSel) {
            destEl.textContent = destSel.options[destSel.selectedIndex]
                ? destSel.options[destSel.selectedIndex].textContent.trim() : '—';
        }
        if (rowsEl) {
            var tbody = document.getElementById('detailBody');
            rowsEl.textContent = tbody ? tbody.querySelectorAll('tr').length : 0;
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeSaveConfirm();
    });

    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        }
    });
</script>
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
        filterDestWarehouseOptions(src);
        validatePairRealtime();
    }

    function filterDestWarehouseOptions(srcId) {
        var destSel = document.getElementById('destWarehouseId');
        if (!destSel) return;
        var prev = destSel.value;
        var srcText = '';
        for (var i = 0; i < destSel.options.length; i++) {
            var opt = destSel.options[i];
            if (opt.value === srcId) {
                srcText = opt.getAttribute('data-warehouse-name') || opt.textContent;
                opt.disabled = true;
                opt.hidden = true;
            } else {
                opt.disabled = false;
                opt.hidden = false;
            }
        }
        if (prev && prev === srcId) {
            destSel.value = '';
        } else if (prev) {
            destSel.value = prev;
        }
        if (srcId && srcText) {
            var hint = destSel.parentNode.querySelector('.dest-hint');
            if (!hint) {
                hint = document.createElement('small');
                hint.className = 'dest-hint';
                hint.style.color = 'var(--muted)';
                hint.style.fontSize = '11.5px';
                destSel.parentNode.appendChild(hint);
            }
        } else {
            var hint = destSel.parentNode.querySelector('.dest-hint');
            if (hint) hint.remove();
        }
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
    window.validateForm = validateForm;
    window.repopulateGeneratorSelects = repopulateGeneratorSelects;
    window.filterDestWarehouseOptions = filterDestWarehouseOptions;
    window.validatePairRealtime = validatePairRealtime;
    window.updateRowMax = updateRowMax;
    window.renumberRows = renumberRows;

    document.addEventListener('DOMContentLoaded', function () {
        renumberRows();
        document.querySelectorAll('#detailBody tr').forEach(updateRowMax);
        var initialSrc = document.getElementById('sourceWarehouseId').value;
        repopulateGeneratorSelects(initialSrc);
        filterDestWarehouseOptions(initialSrc);
        validatePairRealtime();
    });
})();
</script>
</body>
</html>
