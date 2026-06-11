<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đơn thanh lý mới — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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

        /* Customer section */
        .cust-search-wrap { position: relative; }
        .cust-dropdown {
            position: absolute; top: calc(100% + 4px); left: 0; right: 0;
            background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12); z-index: 50;
            max-height: 240px; overflow-y: auto; display: none;
        }
        .cust-dropdown.show { display: block; }
        .cust-option {
            padding: 10px 14px; cursor: pointer; font-size: 13px; border-bottom: 1px solid var(--border);
            display: flex; flex-direction: column; gap: 2px;
        }
        .cust-option:last-child { border-bottom: none; }
        .cust-option:hover { background: var(--surface-2); }
        .cust-option .cust-name { font-weight: 600; color: var(--fg); }
        .cust-card {
            display: none; margin-top: 10px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius); padding: 14px 16px;
            position: relative;
        }
        .cust-card.show { display: flex; gap: 14px; align-items: flex-start; }
        .cust-card-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: var(--accent);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-weight: 700; font-size: 16px; flex-shrink: 0;
        }
        .cust-card-body { flex: 1; }
        .cust-card-name { font-size: 14px; font-weight: 700; color: var(--fg); margin-bottom: 4px; }
        .cust-card-rows { display: flex; flex-wrap: wrap; gap: 6px 20px; }
        .cust-card-row { font-size: 12px; color: var(--muted); display: flex; gap: 5px; align-items: center; }
        .cust-card-row svg { opacity: 0.6; }
        .cust-clear {
            position: absolute; top: 10px; right: 12px;
            background: none; border: none; cursor: pointer; color: var(--muted); padding: 2px;
            border-radius: 4px;
        }
        .cust-clear:hover { color: var(--danger); background: var(--danger-soft); }
        .add-cust-btn {
            margin-top: 10px; font-size: 13px; gap: 6px;
            background: var(--surface-2); border-color: var(--border);
        }
        /* New customer modal */
        .nc-modal-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.5);
            display: none; align-items: center; justify-content: center;
            z-index: 2000; padding: 20px;
        }
        .nc-modal-overlay.show { display: flex; }
        .nc-modal {
            background: var(--bg); border: 1px solid var(--border);
            border-radius: var(--radius-md); width: 100%; max-width: 540px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.18); overflow: hidden;
        }
        .nc-modal-head {
            padding: 18px 22px 14px; border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center;
        }
        .nc-modal-head h3 { margin: 0; font-size: 16px; font-weight: 700; }
        .nc-modal-body { padding: 20px 22px; display: flex; flex-direction: column; gap: 14px; }
        .nc-field { display: flex; flex-direction: column; gap: 5px; }
        .nc-field label { font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; }
        .nc-field input, .nc-field select {
            width: 100%; padding: 9px 12px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg);
            color: var(--fg); font-size: 13px; font-family: var(--font-ui);
            box-sizing: border-box; transition: border-color 0.2s;
        }
        .nc-field input:focus, .nc-field select:focus { outline: none; border-color: var(--accent); }
        .nc-field input.error { border-color: var(--danger); }
        .nc-row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .nc-modal-foot {
            padding: 14px 22px; border-top: 1px solid var(--border);
            display: flex; justify-content: flex-end; gap: 8px; align-items: center;
        }
        .nc-error { font-size: 12px; color: var(--danger); display: none; }
        .nc-error.show { display: block; }
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); display: none;
            justify-content: center; align-items: center; z-index: 1000;
        }
        .modal-content {
            background: var(--bg); padding: 20px; border-radius: var(--radius-md);
            width: 400px; max-width: 90%;
        }
        .modal-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 8px;
        }
        .modal-title { font-size: 16px; font-weight: 600; }
        .close-modal { cursor: pointer; border: none; background: none; font-size: 18px; }
        .serial-list {
            max-height: 300px; overflow-y: auto; list-style: none; padding: 0; margin: 0;
        }
        .serial-item {
            padding: 10px; border-bottom: 1px solid var(--border);
            cursor: pointer; transition: background 0.2s;
        }
        .serial-item:hover { background: var(--surface-2); }
        .empty-msg { padding: 10px; color: var(--muted); text-align: center; }
    </style>
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

            <div class="form-layout">
                <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                    <input type="hidden" name="action" value="create" />
                    <input type="hidden" name="customerId" id="customerIdHidden" />

                    <!-- SECTION 01: THÔNG TIN CHUNG -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                            <h3 class="form-section-title">Khách hàng và Lý do thanh lý</h3>
                        </div>
                        
                        <div class="form-grid">
                            <!-- Khách hàng -->
                            <div class="field span-2">
                                <label class="field-label">Khách hàng (Tùy chọn, tìm theo Tên / SĐT)</label>
                                <div class="cust-search-wrap">
                                    <input type="text" id="custSearchInput" class="input"
                                           placeholder="Nhập tên hoặc số điện thoại..."
                                           autocomplete="off" />
                                    <div class="cust-dropdown" id="custDropdown"></div>
                                </div>
                                <!-- Customer card -->
                                <div class="cust-card" id="custCard">
                                    <div class="cust-card-avatar" id="custCardAvatar"></div>
                                    <div class="cust-card-body">
                                        <div class="cust-card-name" id="custCardName"></div>
                                        <div class="cust-card-rows">
                                            <div class="cust-card-row">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92V19a2 2 0 0 1-2.18 2A19.79 19.79 0 0 1 4 4.18 2 2 0 0 1 6 2h2.09a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 23 17v-.08z"/></svg>
                                                <span id="custCardPhone"></span>
                                            </div>
                                            <div class="cust-card-row" id="custCardEmailRow">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,12 2,6"/></svg>
                                                <span id="custCardEmail"></span>
                                            </div>
                                            <div class="cust-card-row" id="custCardAddrRow">
                                                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                                <span id="custCardAddr"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <button type="button" class="cust-clear" onclick="clearCustomer()" title="Bỏ chọn">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    </button>
                                </div>
                                <!-- Add new button -->
                                <div>
                                    <button type="button" class="btn add-cust-btn" id="addNewCustBtn" onclick="openNewCustomerModal()">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                                        Thêm khách hàng mới
                                    </button>
                                </div>
                            </div>

                            <!-- Kho hàng -->
                            <div class="field">
                                <label class="field-label">Kho hàng <span class="req">*</span></label>
                                <select class="input" name="warehouseId" id="warehouseId" required>
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}">${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Lý do thanh lý -->
                            <div class="field">
                                <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                <select class="input" name="reasonId" required>
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${reasons}">
                                        <option value="${r.id}">${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 02: CHI TIẾT MÁY -->
                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — CHI TIẾT MÁY</div>
                            <h3 class="form-section-title">Danh sách máy phát điện</h3>
                        </div>
                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th class="col-num">#</th>
                                    <th>Mã dòng máy (Model)</th>
                                    <th>Số Serial</th>
                                    <th>Giá gốc (VNĐ)</th>
                                    <th class="col-del"></th>
                                </tr>
                            </thead>
                            <tbody id="detailBody">
                                <tr>
                                    <td class="col-num"><span class="row-num">1</span></td>
                                    <td>
                                        <select name="generatorId" onchange="updatePrice(this)" required>
                                            <option value="" data-price="">-- Chọn máy phát --</option>
                                            <c:forEach var="gen" items="${generators}">
                                                <option value="${gen.id}" data-price="${gen.unitPrice}">${gen.model}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly style="cursor: pointer; background: var(--surface-2);" onclick="openSerialModal(this)"/></td>
                                    <td><input type="number" name="originalPrice" placeholder="Giá gốc" readonly style="background: var(--surface-2); color: var(--muted); cursor: not-allowed;" required/></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
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
                                    <select name="generatorId" onchange="updatePrice(this)" required>
                                        <option value="" data-price="">-- Chọn máy phát --</option>
                                        <c:forEach var="gen" items="${generators}">
                                            <option value="${gen.id}" data-price="${gen.unitPrice}">${gen.model}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly style="cursor: pointer; background: var(--surface-2);" onclick="openSerialModal(this)"/></td>
                                <td><input type="number" name="originalPrice" placeholder="Giá gốc" readonly style="background: var(--surface-2); color: var(--muted); cursor: not-allowed;" required/></td>
                                <td class="col-del">
                                    <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                    </button>
                                </td>
                            </tr>
                        </template>

                        <button type="button" class="btn add-row-btn" onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>
                    </div>
                    
                    <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/liquidations">Huỷ bỏ</a>
                        <button type="submit" form="liquidationForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Lưu & Đề xuất
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<!-- Serial Modal -->
<div class="modal-overlay" id="serialModalOverlay">
    <div class="modal-content">
        <div class="modal-header">
            <h3 class="modal-title">Chọn Số Serial</h3>
            <button class="close-modal" onclick="closeSerialModal()">×</button>
        </div>
        <div id="serialLoading" style="display:none; text-align:center; padding:10px;">Đang tải...</div>
        <ul class="serial-list" id="serialList"></ul>
    </div>
</div>

<!-- New Customer Modal -->
<div class="nc-modal-overlay" id="ncModalOverlay">
    <div class="nc-modal">
        <div class="nc-modal-head">
            <h3>Thêm khách hàng mới</h3>
            <button type="button" class="close-modal" onclick="closeNewCustomerModal()">×</button>
        </div>
        <div class="nc-modal-body">
            <span class="nc-error" id="ncError"></span>
            <div class="nc-field">
                <label>Họ và tên <span style="color:var(--danger)">*</span></label>
                <input type="text" id="ncName" placeholder="Nguyễn Văn A" />
            </div>
            <div class="nc-row2">
                <div class="nc-field">
                    <label>Số điện thoại <span style="color:var(--danger)">*</span></label>
                    <input type="tel" id="ncPhone" placeholder="0901234567" />
                </div>
                <div class="nc-field">
                    <label>Email</label>
                    <input type="email" id="ncEmail" placeholder="email@example.com" />
                </div>
            </div>
            <div class="nc-field">
                <label>Địa chỉ</label>
                <input type="text" id="ncAddress" placeholder="Số nhà, đường, quận, tỉnh..." />
            </div>
            <div class="nc-row2">
                <div class="nc-field">
                    <label>Tên công ty</label>
                    <input type="text" id="ncCompanyName" placeholder="Công ty TNHH..." />
                </div>
                <div class="nc-field">
                    <label>Loại khách hàng</label>
                    <select id="ncTypeId">
                        <option value="">-- Chọn loại --</option>
                        <c:forEach var="ct" items="${customerTypes}">
                            <option value="${ct.id}">${ct.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
        <div class="nc-modal-foot">
            <button type="button" class="btn" onclick="closeNewCustomerModal()">Huỷ</button>
            <button type="button" class="btn btn-primary" id="ncSaveBtn" onclick="saveNewCustomer()">Lưu khách hàng</button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function addRow() {
        var tpl = document.getElementById('rowTemplate');
        var clone = tpl.content.cloneNode(true);
        document.getElementById('detailBody').appendChild(clone);
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

    function updatePrice(selectElem) {
        var priceInput = selectElem.closest('tr').querySelector('input[name="originalPrice"]');
        var serialInput = selectElem.closest('tr').querySelector('input[name="serialNumber"]');
        var selectedOption = selectElem.options[selectElem.selectedIndex];
        if (selectedOption && selectedOption.getAttribute('data-price')) {
            priceInput.value = selectedOption.getAttribute('data-price');
        } else {
            priceInput.value = "";
        }
        serialInput.value = ""; // Clear serial when changing generator
    }

    var currentSerialInput = null;

    function openSerialModal(inputElem) {
        var warehouseId = document.getElementById('warehouseId').value;
        if (!warehouseId) {
            alert('Vui lòng chọn Kho hàng trước!');
            return;
        }
        
        var tr = inputElem.closest('tr');
        var generatorSelect = tr.querySelector('select[name="generatorId"]');
        var generatorId = generatorSelect.value;
        if (!generatorId) {
            alert('Vui lòng chọn Mã dòng máy trước!');
            return;
        }

        currentSerialInput = inputElem;
        document.getElementById('serialModalOverlay').style.display = 'flex';
        document.getElementById('serialList').innerHTML = '';
        document.getElementById('serialLoading').style.display = 'block';

        fetch('${pageContext.request.contextPath}/liquidations?action=get_serials&warehouseId=' + warehouseId + '&generatorId=' + generatorId)
            .then(response => response.json())
            .then(data => {
                document.getElementById('serialLoading').style.display = 'none';
                var ul = document.getElementById('serialList');
                ul.innerHTML = '';
                if (data.length === 0) {
                    ul.innerHTML = '<li class="empty-msg">Không có máy nào trong kho đang rảnh.</li>';
                    return;
                }
                
                // Get all already selected serials to exclude them
                var selectedSerials = Array.from(document.querySelectorAll('input[name="serialNumber"]'))
                    .map(inp => inp.value)
                    .filter(val => val !== '');

                var count = 0;
                data.forEach(sn => {
                    if (!selectedSerials.includes(sn.serialNumber)) {
                        var li = document.createElement('li');
                        li.className = 'serial-item';
                        li.textContent = sn.serialNumber;
                        li.onclick = function() {
                            currentSerialInput.value = sn.serialNumber;
                            closeSerialModal();
                        };
                        ul.appendChild(li);
                        count++;
                    }
                });
                if (count === 0) {
                    ul.innerHTML = '<li class="empty-msg">Tất cả máy khả dụng đã được chọn.</li>';
                }
            })
            .catch(error => {
                document.getElementById('serialLoading').style.display = 'none';
                document.getElementById('serialList').innerHTML = '<li class="empty-msg">Lỗi tải dữ liệu</li>';
            });
    }

    function closeSerialModal() {
        document.getElementById('serialModalOverlay').style.display = 'none';
        currentSerialInput = null;
    }

    /* ============ CUSTOMER SEARCH ============ */
    var custSearchTimer = null;
    var ctxPath = '${pageContext.request.contextPath}';

    document.getElementById('custSearchInput').addEventListener('input', function() {
        clearTimeout(custSearchTimer);
        var q = this.value.trim();
        if (q.length < 1) { hideCustDropdown(); return; }
        custSearchTimer = setTimeout(function() { searchCustomers(q); }, 280);
    });

    document.getElementById('custSearchInput').addEventListener('focus', function() {
        var q = this.value.trim();
        if (q.length >= 1) searchCustomers(q);
    });

    document.addEventListener('click', function(e) {
        if (!document.querySelector('.cust-search-wrap').contains(e.target)) {
            hideCustDropdown();
        }
    });

    function searchCustomers(q) {
        fetch(ctxPath + '/liquidations?action=search_customer&q=' + encodeURIComponent(q))
            .then(function(r) { return r.json(); })
            .then(function(data) {
                renderCustDropdown(data);
            }).catch(function() { hideCustDropdown(); });
    }

    function renderCustDropdown(data) {
        var dd = document.getElementById('custDropdown');
        dd.innerHTML = '';
        if (!data || data.length === 0) {
            dd.innerHTML = '<div style="padding:12px 14px; color:var(--muted); font-size:13px;">Không tìm thấy khách hàng</div>';
            dd.classList.add('show');
            return;
        }
        data.forEach(function(c) {
            var div = document.createElement('div');
            div.className = 'cust-option';
            div.innerHTML = '<span class="cust-name">' + escHtml(c.name) + '</span>'
                + '<span class="cust-sub">' + escHtml(c.phone)
                + (c.companyName ? ' · ' + escHtml(c.companyName) : '') + '</span>';
            div.addEventListener('click', function() { selectCustomer(c); });
            dd.appendChild(div);
        });
        dd.classList.add('show');
    }

    function hideCustDropdown() {
        document.getElementById('custDropdown').classList.remove('show');
    }

    function selectCustomer(c) {
        document.getElementById('customerIdHidden').value = c.id;
        document.getElementById('custSearchInput').value = c.name;
        hideCustDropdown();
        showCustCard(c);
    }

    function showCustCard(c) {
        document.getElementById('custCardAvatar').textContent = c.name.charAt(0).toUpperCase();
        document.getElementById('custCardName').textContent = c.name;
        document.getElementById('custCardPhone').textContent = c.phone;
        var emailRow = document.getElementById('custCardEmailRow');
        document.getElementById('custCardEmail').textContent = c.email || '';
        emailRow.style.display = c.email ? 'flex' : 'none';
        var addrRow = document.getElementById('custCardAddrRow');
        document.getElementById('custCardAddr').textContent = c.address || '';
        addrRow.style.display = c.address ? 'flex' : 'none';
        document.getElementById('custCard').classList.add('show');
        document.getElementById('addNewCustBtn').style.display = 'none';
    }

    function clearCustomer() {
        document.getElementById('customerIdHidden').value = '';
        document.getElementById('custSearchInput').value = '';
        document.getElementById('custCard').classList.remove('show');
        document.getElementById('addNewCustBtn').style.display = '';
    }

    /* ============ NEW CUSTOMER MODAL ============ */
    function openNewCustomerModal() {
        document.getElementById('ncName').value = '';
        document.getElementById('ncPhone').value = document.getElementById('custSearchInput').value;
        document.getElementById('ncEmail').value = '';
        document.getElementById('ncAddress').value = '';
        document.getElementById('ncCompanyName').value = '';
        document.getElementById('ncTypeId').selectedIndex = 0;
        hideNcError();
        document.getElementById('ncModalOverlay').classList.add('show');
        document.getElementById('ncName').focus();
    }

    function closeNewCustomerModal() {
        document.getElementById('ncModalOverlay').classList.remove('show');
    }

    function showNcError(msg) {
        var el = document.getElementById('ncError');
        el.textContent = msg; el.classList.add('show');
    }
    function hideNcError() {
        document.getElementById('ncError').classList.remove('show');
    }

    function saveNewCustomer() {
        var name = document.getElementById('ncName').value.trim();
        var phone = document.getElementById('ncPhone').value.trim();
        if (!name) { showNcError('Vui lòng nhập họ tên.'); document.getElementById('ncName').focus(); return; }
        if (!phone) { showNcError('Vui lòng nhập số điện thoại.'); document.getElementById('ncPhone').focus(); return; }
        hideNcError();

        var btn = document.getElementById('ncSaveBtn');
        btn.disabled = true; btn.textContent = 'Đang lưu...';

        var fd = new FormData();
        fd.append('action', 'create_customer');
        fd.append('custName', name);
        fd.append('custPhone', phone);
        fd.append('custEmail', document.getElementById('ncEmail').value.trim());
        fd.append('custAddress', document.getElementById('ncAddress').value.trim());
        fd.append('custCompanyName', document.getElementById('ncCompanyName').value.trim());
        fd.append('custTypeId', document.getElementById('ncTypeId').value);

        fetch(ctxPath + '/liquidations', { method: 'POST', body: fd })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                if (data.success) {
                    var c = {
                        id: data.id, name: data.name, phone: data.phone,
                        email: data.email, address: data.address, companyName: data.companyName
                    };
                    if (data.existing) {
                        showNcError('SĐT này đã tồn tại — đã tự động chọn khách hàng: ' + data.name);
                        setTimeout(function() {
                            closeNewCustomerModal();
                            selectCustomer(c);
                        }, 1500);
                    } else {
                        closeNewCustomerModal();
                        selectCustomer(c);
                    }
                } else {
                    showNcError(data.error || 'Lỗi không xác định');
                }
            }).catch(function() {
                btn.disabled = false; btn.textContent = 'Lưu khách hàng';
                showNcError('Lỗi kết nối máy chủ');
            });
    }

    function escHtml(str) {
        var d = document.createElement('div'); d.appendChild(document.createTextNode(str || '')); return d.innerHTML;
    }

    // Close nc modal on overlay click
    document.getElementById('ncModalOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeNewCustomerModal();
    });

    document.getElementById('liquidationForm').addEventListener('submit', function(e) {
        var custId = document.getElementById('customerIdHidden').value;
        if (!custId) {
            e.preventDefault();
            alert('Vui lòng tìm và chọn Khách hàng hoặc Thêm mới trước khi lưu.');
        }
    });
</script>
</body>
</html>
