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

        /* Modal Styles */
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

            <c:if test="${not empty liquidation.managerFeedbackName}">
                <div style="background: var(--warn-soft); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); padding: 12px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; color: var(--warn);">
                    Quản lý yêu cầu sửa: ${liquidation.managerFeedbackName}
                </div>
            </c:if>

            <div class="form-layout">
                <form id="liquidationForm" class="form-card" action="${pageContext.request.contextPath}/liquidations" method="POST">
                    <input type="hidden" name="action" value="edit_submit" />
                    <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CHUNG</div>
                            <h3 class="form-section-title">Lý do thanh lý</h3>
                        </div>
                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Kho hàng <span class="req">*</span></label>
                                <select class="input" name="warehouseId" id="warehouseId" required>
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${w.warehouseId == liquidation.warehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="field">
                                <label class="field-label">Lý do thanh lý <span class="req">*</span></label>
                                <select class="input" name="reasonId" required>
                                    <option value="">-- Chọn lý do --</option>
                                    <c:forEach var="r" items="${reasons}">
                                        <option value="${r.id}" ${r.id == liquidation.reasonId ? 'selected' : ''}>${r.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

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
                                <c:forEach var="d" items="${details}" varStatus="status">
                                <tr>
                                    <td class="col-num"><span class="row-num">${status.index + 1}</span></td>
                                    <td>
                                        <select name="generatorId" onchange="updatePrice(this)" required>
                                            <option value="" data-price="">-- Chọn máy phát --</option>
                                            <c:forEach var="gen" items="${generators}">
                                                <option value="${gen.id}" data-price="${gen.unitPrice}" ${gen.id == d.generatorId ? 'selected' : ''}>${gen.model}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" value="${d.serialNumber}" required readonly style="cursor: pointer; background: var(--surface-2);" onclick="openSerialModal(this)"/></td>
                                    <td><input type="number" name="originalPrice" placeholder="Giá gốc" value="${d.originalPrice}" readonly style="background: var(--surface-2); color: var(--muted); cursor: not-allowed;" required/></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                        </button>
                                    </td>
                                </tr>
                                </c:forEach>
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
                        <a class="btn" href="${pageContext.request.contextPath}/liquidations?action=detail&id=${liquidation.liquidationId}">Huỷ bỏ</a>
                        <button type="submit" form="liquidationForm" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Lưu & Đề xuất lại
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
                
                // Allow selecting the currently assigned serial number even if its status is PENDING_LIQUIDATION
                // Actually, the currently assigned serial numbers are technically not 'IN_STOCK'. 
                // Wait, if it's currently assigned, we don't want to lose it. But for simplicity, the user can just leave the existing value alone. 
                // If they click, we show IN_STOCK ones. 
                
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
</script>
</body>
</html>
