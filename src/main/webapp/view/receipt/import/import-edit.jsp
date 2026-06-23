<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa phiếu nhập — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; }
        .form-field { display: flex; flex-direction: column; gap: 6px; }
        .form-field.full { grid-column: 1 / -1; }
        .form-field label { font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-field input, .form-field select, .form-field textarea {
            width: 100%; padding: 9px 12px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); box-sizing: border-box;
        }
        .form-field input:focus, .form-field select:focus, .form-field textarea:focus {
            outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent);
        }
        .form-field textarea { min-height: 70px; resize: vertical; font-family: var(--font-ui); }
        .form-field input:disabled, .form-field select:disabled { background: var(--surface-2); color: var(--muted); cursor: not-allowed; }

        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th { text-align: left; padding: 10px 12px; font-size: 11px;
            font-weight: 700; color: var(--muted); border-bottom: 1px solid var(--border);
            text-transform: uppercase; letter-spacing: 0.04em; background: var(--surface-2); }
        .detail-table td { padding: 8px 8px; vertical-align: top; border-bottom: 1px solid var(--border); }
        .detail-table tbody tr:last-child td { border-bottom: 0; }
        .detail-table select, .detail-table input {
            width: 100%; padding: 7px 10px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); box-sizing: border-box;
        }
        .detail-table select:focus, .detail-table input:focus {
            outline: none; border-color: var(--accent);
        }
        .detail-table .col-num { width: 36px; text-align: center; color: var(--muted);
            font-size: 12px; font-weight: 600; padding-top: 14px; font-family: var(--font-mono); }
        .detail-table .col-gen { min-width: 200px; }
        .detail-table .col-serial { min-width: 130px; }
        .detail-table .col-note { min-width: 130px; }
        .detail-table .col-del { width: 40px; text-align: center; }

        .row-del-btn { width: 28px; height: 28px; border: 1px solid transparent;
            background: transparent; color: var(--danger); cursor: pointer;
            border-radius: var(--radius-sm); display: inline-flex; align-items: center;
            justify-content: center; margin-top: 4px; }
        .row-del-btn:hover { background: var(--danger-soft); border-color: color-mix(in srgb, var(--danger) 25%, transparent); }
        .add-row-btn { margin-top: 12px; font-size: 13px; }

        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert ul { margin: 4px 0 0 18px; padding: 0; }
        .alert pre { margin: 6px 0 0; font-family: inherit; font-size: 13px;
            white-space: pre-wrap; word-break: break-word; line-height: 1.5; }
        .alert-warn { background: var(--warn-soft); color: var(--warn);
            border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); }

        a.btn { text-decoration: none; }
        .hero-avatar.edit { background: oklch(58% 0.16 145); }
        .field-error { display: none; font-size: 11px; color: #dc3545; margin-top: 3px; }
        .stock-info { font-size: 11px; color: var(--muted); margin-top: 3px; font-family: var(--font-mono); display: block; min-height: 14px; }
        .stock-info .stock-label { color: var(--muted); }
        .stock-info .stock-value { color: var(--accent); font-weight: 600; }

        @media (max-width: 760px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chỉnh sửa phiếu nhập</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / <c:out value="${receipt.receiptCode}"/> / Chỉnh sửa</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}">Huỷ</a>
                <c:if test="${isDraft}">
                    <button type="submit" name="submitMode" value="draft" form="receiptForm" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                        Lưu nháp
                    </button>
                </c:if>
                <button type="submit" name="submitMode" value="submit" form="receiptForm" class="btn btn-primary">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    <c:choose>
                        <c:when test="${isDraft}">Gửi phiếu</c:when>
                        <c:otherwise>Gửi lại để duyệt</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại chi tiết phiếu
            </a>

            <div class="hero">
                <div class="hero-avatar edit">N</div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${receipt.receiptCode}"/>
                        <c:choose>
                            <c:when test="${isDraft}">
                                <span class="status-pill" style="background: oklch(94% 0.04 250); color: oklch(45% 0.13 250); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">Bản nháp</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-pill" style="background: oklch(94% 0.04 75); color: oklch(50% 0.13 75); padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600;">Yêu cầu chỉnh sửa</span>
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <div class="hero-meta">
                        <span>Phiếu nhập kho</span>
                        <span class="sep">·</span>
                        <span class="id">#${receipt.receiptId}</span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty receipt.reasonNote or not empty receipt.reasonName}">
                <div class="alert alert-warn">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <div class="alert-title">Lý do quản lý yêu cầu chỉnh sửa</div>
                        <c:if test="${not empty receipt.reasonName}">
                            <div><strong>Lý do:</strong> <c:out value="${receipt.reasonName}"/></div>
                        </c:if>
                        <c:if test="${not empty receipt.reasonNote}">
                            <pre><c:out value="${receipt.reasonNote}"/></pre>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <form id="receiptForm" action="${pageContext.request.contextPath}/import-receipt?action=update" method="POST" onsubmit="return validateReceiptForm()">
                <input type="hidden" name="receiptId" value="${receipt.receiptId}" />

                <div class="content">
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN PHIẾU</div>
                                <h3 class="section-title">Kho, lý do và ghi chú</h3>
                            </div>
                        </div>
                        <div class="form-grid">
                            <div class="form-field">
                                <label>Kho *</label>
                                <select id="warehouseSelect" name="warehouseId" required onchange="onWarehouseChange()">
                                    <option value="">-- Chọn kho --</option>
                                    <c:forEach var="wh" items="${warehouses}">
                                        <option value="${wh.warehouseId}" <c:if test="${receipt.warehouseId == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                                    </c:forEach>
                                </select>
                                <span class="field-error"></span>
                            </div>
                            <div class="form-field">
                                <label>Lý do *</label>
                                <select name="reasonId" class="input" required onchange="validateField(this)">
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${receiptReasons}">
                                        <option value="${r.id}" <c:if test="${receipt.reasonId == r.id}">selected</c:if>>${r.name}</option>
                                    </c:forEach>
                                </select>
                                <span class="field-error"></span>
                            </div>
                            <div class="form-field full">
                                <label>Ghi chú phiếu</label>
                                <textarea name="note" placeholder="Nhập ghi chú nếu có..."><c:out value="${receipt.note}"/></textarea>
                            </div>
                        </div>
                    </section>

                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — CHI TIẾT DÒNG HÀNG</div>
                                <h3 class="section-title">Danh sách máy phát điện</h3>
                            </div>
                        </div>
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th class="col-gen">Máy phát</th>
                                    <th class="col-serial">Serial</th>
                                    <th class="col-note">Ghi chú</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <c:choose>
                                    <c:when test="${not empty receipt.details}">
                                        <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                            <tr data-current="${d.generatorId}">
                                                <td class="col-num"><span class="row-num">${st.index + 1}</span></td>
                                                <td>
                                                    <select name="generatorId" required onchange="onGeneratorChange(this)">
                                                        <option value="">-- Chọn máy --</option>
                                                    </select>
                                                    <span class="stock-info" data-stock-info></span>
                                                    <span class="field-error"></span>
                                                </td>
                                                <td><input type="text" name="serialNumber" placeholder="S/N (bắt buộc)" value="<c:out value='${d.serialNumber}'/>" required onblur="validateField(this)"/><span class="field-error"></span></td>
                                                <td><input type="text" name="detailNote" placeholder="Ghi chú" value="<c:out value='${d.note}'/>" /></td>
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
                                                <select name="generatorId" required onchange="onGeneratorChange(this)">
                                                    <option value="">-- Chọn máy --</option>
                                                </select>
                                                <span class="stock-info" data-stock-info></span>
                                                <span class="field-error"></span>
                                            </td>
                                            <td><input type="text" name="serialNumber" placeholder="S/N (bắt buộc)" required onblur="validateField(this)"/><span class="field-error"></span></td>
                                            <td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>
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
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </section>
                </div>
            </form>
        </main>
    </div>
</div>

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
    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message) {
            if (typeof showToast === 'function') {
                showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
            }
        }
    });
</script>
<script>
    var ctx = window.APP_CTX;
    var generatorCache = [];

    function formatVND(num) {
        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(num || 0);
    }

    function renderGeneratorOptions(selectEl) {
        var cur = selectEl.getAttribute('data-current');
        var html = '<option value="">-- Chọn máy --</option>';
        for (var i = 0; i < generatorCache.length; i++) {
            var g = generatorCache[i];
            var label = g.model + (g.brand ? ' (' + g.brand + ')' : '') + ' — Tồn: ' + (g.stockQty || 0);
            var sel = (cur && String(g.id) === String(cur)) ? ' selected' : '';
            html += '<option value="' + g.id + '" data-stock="' + (g.stockQty || 0) + '"' + sel + '>' + label + '</option>';
        }
        selectEl.innerHTML = html;
    }

    function updateStockInfo(selectEl) {
        var row = selectEl.closest('tr');
        if (!row) return;
        var info = row.querySelector('[data-stock-info]');
        if (!info) return;
        var opt = selectEl.options[selectEl.selectedIndex];
        if (!opt || !opt.value) {
            info.innerHTML = '';
            return;
        }
        var stock = parseInt(opt.getAttribute('data-stock')) || 0;
        info.innerHTML = '<span class="stock-label">Tồn kho hiện tại:</span> <span class="stock-value">' + stock + '</span> máy';
    }

    function onWarehouseChange() {
        var whId = document.getElementById('warehouseSelect').value;
        if (!whId) {
            generatorCache = [];
            refreshAllGeneratorSelects();
            document.querySelectorAll('#detailBody tr [data-stock-info]').forEach(function (el) { el.innerHTML = ''; });
            return;
        }
        fetch(ctx + '/import-receipt?action=loadGenerators&warehouseId=' + encodeURIComponent(whId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                generatorCache = data || [];
                refreshAllGeneratorSelects();
                document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
                    if (sel.value) onGeneratorChange(sel);
                });
            });
    }

    function refreshAllGeneratorSelects() {
        document.querySelectorAll('#detailBody tr select[name="generatorId"]').forEach(function (sel) {
            renderGeneratorOptions(sel);
        });
    }

    function onGeneratorChange(sel) {
        updateStockInfo(sel);
    }

    function buildEmptyRow() {
        var tr = document.createElement('tr');
        tr.innerHTML = '<td class="col-num"><span class="row-num"></span></td>'
                + '<td><select name="generatorId" required onchange="onGeneratorChange(this)"><option value="">-- Chọn máy --</option></select><span class="stock-info" data-stock-info></span><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="serialNumber" placeholder="S/N (bắt buộc)" required onblur="validateField(this)"/><span class="field-error" style="display:none;"></span></td>'
                + '<td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>'
                + '<td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg></button></td>';
        renderGeneratorOptions(tr.querySelector('select[name="generatorId"]'));
        return tr;
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        tbody.appendChild(buildEmptyRow());
        updateRowNumbers();
    }
    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
    }
    function updateRowNumbers() {
        document.querySelectorAll('#detailBody .row-num').forEach(function (el, i) {
            el.textContent = i + 1;
        });
    }

    function validateField(el) {
        var err = el.parentElement.querySelector('.field-error');
        if (err === null) return true;
        if (el.required && !el.value.trim()) {
            el.style.borderColor = '#dc3545';
            err.style.display = 'block';
            return false;
        }
        el.style.borderColor = '';
        err.style.display = 'none';
        return true;
    }

    function validateReceiptForm() {
        var submitter = (typeof event !== 'undefined' && event && event.submitter) ? event.submitter : null;
        var isDraft = submitter && submitter.value === 'draft';
        if (isDraft) return true;
        var valid = true;
        var firstInvalid = null;
        document.querySelectorAll('#receiptForm [required]').forEach(function (el) {
            if (!validateField(el)) {
                valid = false;
                if (firstInvalid === null) firstInvalid = el;
            }
        });
        if (document.querySelectorAll('#detailBody tr').length === 0) {
            toast('Vui lòng thêm ít nhất 1 dòng chi tiết', 'danger');
            valid = false;
        }
        if (!valid) {
            toast('Vui lòng điền đầy đủ các trường bắt buộc', 'danger');
            if (firstInvalid) firstInvalid.focus();
        }
        return valid;
    }

    document.addEventListener('DOMContentLoaded', function () {
        var whId = document.getElementById('warehouseSelect').value;
        if (whId) {
            onWarehouseChange();
        }
    });
</script>
</body>
</html>