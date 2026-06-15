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
        .alert-info {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 10px 14px; border-radius: var(--radius);
            background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
            font-size: 12.5px;
            margin-bottom: 12px;
        }

        /* Side panel styles */
        .side-panel-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 1000; opacity: 0; visibility: hidden; transition: opacity 0.3s; }
        .side-panel-overlay.show { opacity: 1; visibility: visible; }
        .side-panel { position: fixed; top: 0; right: -420px; width: 400px; max-width: 100%; height: 100%; background: var(--bg); box-shadow: -8px 0 32px rgba(0,0,0,0.1); z-index: 1001; transition: right 0.3s cubic-bezier(0.16, 1, 0.3, 1); display: flex; flex-direction: column; }
        .side-panel.show { right: 0; }
        .side-panel-head { display: flex; justify-content: space-between; align-items: center; padding: 24px; border-bottom: 1px solid var(--border); flex-shrink: 0; }
        .side-panel-title { font-size: 18px; font-weight: 700; margin: 0; }
        .side-panel-close { width: 32px; height: 32px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 22px; display: grid; place-items: center; border-radius: var(--radius-sm); }
        .side-panel-close:hover { background: var(--surface-2); color: var(--fg); }
        .side-panel-body { flex: 1; overflow-y: auto; padding: 24px; }
        .serial-search-box { width: 100%; padding: 12px 16px; border: 1px solid var(--border); border-radius: var(--radius); background: var(--bg); color: var(--fg); font-size: 14px; font-family: var(--font-ui); box-sizing: border-box; }
        .serial-search-box:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .serial-list-wrap { display: flex; flex-direction: column; gap: 12px; }
        .serial-card { padding: 16px; border: 1px solid var(--border); border-radius: var(--radius); background: var(--surface); cursor: pointer; transition: all 0.2s; display: flex; justify-content: space-between; align-items: center; }
        .serial-card:hover { border-color: var(--accent); box-shadow: 0 4px 12px rgba(13,110,253,0.1); transform: translateY(-1px); }
        .serial-card-left { display: flex; flex-direction: column; gap: 6px; }
        .serial-number-text { font-family: var(--font-mono); font-size: 15px; font-weight: 700; }
        .serial-meta { font-size: 12px; color: var(--muted); display: flex; gap: 12px; align-items: center; }
        .serial-card-icon { color: var(--accent); opacity: 0; transition: 0.2s; transform: translateX(-8px); }
        .serial-card:hover .serial-card-icon { opacity: 1; transform: translateX(0); }
        .badge-avail { display: inline-flex; align-items: center; gap: 4px; padding: 2px 6px; border-radius: 12px; font-size: 10px; font-weight: 700; background: #d1fae5; color: #059669; text-transform: uppercase; }
        .empty-msg { text-align: center; padding: 40px 20px; color: var(--muted); font-size: 14px; }
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
                                    <th>Dòng máy</th>
                                    <th style="width:45%;">Serial (S/N)</th>
                                    <th>Ghi chú dòng</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <tr>
                                    <td class="col-num"><span class="row-num">1</span></td>
                                    <td>
                                        <select class="serial-select generator-select" required disabled onchange="onGeneratorChange(this)">
                                            <option value="">-- Chọn kho nguồn trước --</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly
                                               style="cursor: pointer; background: var(--surface-2);"
                                               onclick="openSerialModal(this)"/>
                                    </td>
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
                                    <select class="serial-select generator-select" required disabled onchange="onGeneratorChange(this)">
                                        <option value="">-- Chọn dòng máy --</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly
                                           style="cursor: pointer; background: var(--surface-2);"
                                           onclick="openSerialModal(this)"/>
                                </td>
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

            <!-- Side panel for serial selection -->
            <div class="side-panel-overlay" id="sidePanelOverlay" onclick="closeSerialPanel()"></div>
            <div class="side-panel" id="sidePanel">
                <div class="side-panel-head">
                    <h3 class="side-panel-title">Chọn Số Serial</h3>
                    <button class="side-panel-close" onclick="closeSerialPanel()">&times;</button>
                </div>
                <div class="side-panel-body">
                    <div style="display:flex; gap: 8px; margin-bottom: 20px;">
                        <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm nhanh Serial..."/>
                        <select id="serialSortOrder" class="serial-search-box" style="width:auto;min-width:120px;">
                            <option value="desc">Mới nhất</option>
                            <option value="asc">Cũ nhất</option>
                        </select>
                    </div>
                    <div id="serialLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10" stroke-dasharray="31.4 31.4" stroke-dashoffset="10"><animateTransform attributeName="transform" type="rotate" from="0 12 12" to="360 12 12" dur="0.8s" repeatCount="indefinite"/></circle>
                        </svg><br>Đang tải...
                    </div>
                    <div class="serial-list-wrap" id="serialList"></div>
                </div>
            </div>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    // Danh sach cac generator (dòng máy) cho dropdown
    var generators = [
        <c:forEach var="g" items="${generators}" varStatus="st">
        { id: ${g.id}, model: '<c:out value="${g.model}"/>' }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    // Tat ca serial IN_STOCK duoc load tu server
    var allSerials = [
        <c:forEach var="inv" items="${allSerials}" varStatus="st">
        {
            inventoryId: ${inv.inventoryId},
            serialNumber: '<c:out value="${inv.serialNumber}"/>',
            generatorId: ${inv.generatorId},
            generatorModel: '<c:out value="${inv.generatorModel}"/>',
            warehouseId: ${inv.warehouseId},
            warehouseName: '<c:out value="${inv.warehouseName}"/>',
            createdAt: '<c:out value="${inv.createdAt}"/>'
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    var currentSerialInput = null;

    // Cap nhat generator dropdowns khi thay doi kho nguon
    function refreshGeneratorSelects() {
        var whId = document.getElementById('sourceWarehouseId').value;
        var selects = document.querySelectorAll('#detailBody .generator-select');
        for (var i = 0; i < selects.length; i++) {
            var sel = selects[i];
            sel.disabled = !whId;
            if (whId) {
                var html = '<option value="">-- Chọn dòng máy --</option>';
                for (var j = 0; j < generators.length; j++) {
                    html += '<option value="' + generators[j].id + '">' + escapeHtml(generators[j].model) + '</option>';
                }
                sel.innerHTML = html;
            } else {
                sel.innerHTML = '<option value="">-- Chọn kho nguồn trước --</option>';
            }
        }
        var addBtn = document.getElementById('addRowBtn');
        if (addBtn) addBtn.disabled = !whId;
        // Xoa serial da chon khi doi kho nguon
        var serialInputs = document.querySelectorAll('#detailBody input[name="serialNumber"]');
        for (var i = 0; i < serialInputs.length; i++) {
            serialInputs[i].value = '';
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
        refreshGeneratorSelects();
    }

    function onDestWarehouseChange() {
        var src = document.getElementById('sourceWarehouseId');
        var dst = document.getElementById('destWarehouseId');
        if (src.value && dst.value && src.value === dst.value) {
            toast('Kho nguồn và kho đích phải khác nhau', 'danger');
            dst.value = '';
        }
    }

    // Khi thay doi generator trong 1 dong
    function onGeneratorChange(sel) {
        // Xoa serial da chon neu doi generator
        var tr = sel.closest('tr');
        var serialInput = tr.querySelector('input[name="serialNumber"]');
        if (serialInput) serialInput.value = '';
    }

    // Mo side panel chon serial
    function openSerialModal(inputElem) {
        var srcWarehouse = document.getElementById('sourceWarehouseId').value;
        if (!srcWarehouse) { toast('Vui lòng chọn Kho nguồn trước!', 'danger'); return; }

        var tr = inputElem.closest('tr');
        var generatorSelect = tr.querySelector('.generator-select');
        var generatorId = generatorSelect.value;
        if (!generatorId) { toast('Vui lòng chọn Dòng máy trước!', 'danger'); return; }

        currentSerialInput = inputElem;
        document.getElementById('serialSearchInput').value = '';
        document.getElementById('serialSortOrder').value = 'desc';
        document.getElementById('sidePanelOverlay').classList.add('show');
        document.getElementById('sidePanel').classList.add('show');
        document.getElementById('serialList').innerHTML = '';
        document.getElementById('serialLoading').style.display = 'block';
        setTimeout(function() { document.getElementById('serialSearchInput').focus(); }, 300);

        var whId = parseInt(srcWarehouse, 10);
        var gId = parseInt(generatorId, 10);
        var filtered = [];
        for (var k = 0; k < allSerials.length; k++) {
            var s = allSerials[k];
            if (s.warehouseId === whId && s.generatorId === gId) {
                filtered.push(s);
            }
        }

        document.getElementById('serialLoading').style.display = 'none';
        var listWrap = document.getElementById('serialList');
        if (filtered.length === 0) {
            listWrap.innerHTML = '<div class="empty-msg">Không có serial nào trong kho đang rảnh.</div>';
            return;
        }
        var selectedSerials = Array.from(document.querySelectorAll('input[name="serialNumber"]'))
            .map(function(inp) { return inp.value; }).filter(function(val) { return val !== ''; });
        var count = 0;
        for (var i = 0; i < filtered.length; i++) {
            var sn = filtered[i];
            if (selectedSerials.indexOf(sn.serialNumber) === -1) {
                (function(serialNumber, createdAt) {
                    var dateStr = 'Chưa xác định';
                    var timestamp = 0;
                    if (createdAt) {
                        var d = new Date(createdAt);
                        if (!isNaN(d.getTime())) {
                            timestamp = d.getTime();
                            var dd = String(d.getDate()).padStart(2, '0');
                            var mm = String(d.getMonth() + 1).padStart(2, '0');
                            var yyyy = d.getFullYear();
                            dateStr = dd + '/' + mm + '/' + yyyy;
                        }
                    }
                    var card = document.createElement('div');
                    card.className = 'serial-card';
                    card.setAttribute('data-serial', serialNumber.toLowerCase());
                    card.setAttribute('data-date', dateStr);
                    card.setAttribute('data-time', timestamp);
                    card.innerHTML = '<div class="serial-card-left">'
                        + '<div class="serial-number-text">' + escapeHtml(serialNumber) + '</div>'
                        + '<div class="serial-meta"><span>' + dateStr + '</span><span class="badge-avail">IN STOCK</span></div>'
                        + '</div>'
                        + '<div class="serial-card-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg></div>';
                    card.onclick = function() {
                        currentSerialInput.value = serialNumber;
                        closeSerialPanel();
                    };
                    listWrap.appendChild(card);
                    count++;
                })(sn.serialNumber, sn.createdAt);
            }
        }
        if (count === 0) {
            listWrap.innerHTML = '<div class="empty-msg">Tất cả serial khả dụng đã được chọn.</div>';
        }
        filterAndSortSerials();
    }

    function filterAndSortSerials() {
        var query = document.getElementById('serialSearchInput').value.toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;
        var listWrap = document.getElementById('serialList');
        var items = Array.from(listWrap.querySelectorAll('.serial-card'));
        items.sort(function(a, b) {
            var timeA = parseInt(a.getAttribute('data-time') || '0', 10);
            var timeB = parseInt(b.getAttribute('data-time') || '0', 10);
            if (sortOrder === 'desc') return timeB - timeA;
            return timeA - timeB;
        });
        for (var i = 0; i < items.length; i++) {
            var text = items[i].getAttribute('data-serial');
            items[i].style.display = text.indexOf(query) !== -1 ? 'flex' : 'none';
            listWrap.appendChild(items[i]);
        }
    }

    function closeSerialPanel() {
        document.getElementById('sidePanelOverlay').classList.remove('show');
        document.getElementById('sidePanel').classList.remove('show');
        currentSerialInput = null;
    }

    function addRow() {
        var tbody = document.getElementById('detailBody');
        var tpl = document.getElementById('rowTemplate');
        var clone = tpl.content.cloneNode(true);
        tbody.appendChild(clone);
        var whId = document.getElementById('sourceWarehouseId').value;
        var lastGenSelect = tbody.lastElementChild.querySelector('.generator-select');
        if (whId) {
            lastGenSelect.disabled = false;
            var html = '<option value="">-- Chọn dòng máy --</option>';
            for (var j = 0; j < generators.length; j++) {
                html += '<option value="' + generators[j].id + '">' + escapeHtml(generators[j].model) + '</option>';
            }
            lastGenSelect.innerHTML = html;
        }
        updateRowNumbers();
    }

    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
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

    function escapeHtml(s) {
        if (!s) return '';
        return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
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

        var rows = document.querySelectorAll('#detailBody tr');
        var hasSerial = false;
        var seenSerials = {};
        for (var i = 0; i < rows.length; i++) {
            var genSelect = rows[i].querySelector('.generator-select');
            var serialInput = rows[i].querySelector('input[name="serialNumber"]');
            if (!genSelect.value) {
                toast('Dòng ' + (i + 1) + ': Vui lòng chọn dòng máy', 'danger');
                return false;
            }
            if (serialInput && serialInput.value) {
                if (seenSerials[serialInput.value]) {
                    toast('Serial "' + serialInput.value + '" bị trùng', 'danger');
                    return false;
                }
                seenSerials[serialInput.value] = true;
                hasSerial = true;
            }
        }
        if (!hasSerial) { toast('Vui lòng chọn ít nhất 1 serial', 'danger'); return false; }
        return true;
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateRowNumbers();
    });

    document.getElementById('serialSearchInput').addEventListener('input', filterAndSortSerials);
    document.getElementById('serialSortOrder').addEventListener('change', filterAndSortSerials);

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
