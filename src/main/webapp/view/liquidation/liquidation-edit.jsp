<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        /* Side Panel UI for Serial Selection */
        .side-panel-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 1000;
            opacity: 0; visibility: hidden; transition: opacity 0.3s;
        }
        .side-panel-overlay.show { opacity: 1; visibility: visible; }
        
        .side-panel {
            position: fixed; top: 0; right: -420px; width: 400px; max-width: 100%; height: 100%;
            background: var(--bg); box-shadow: -8px 0 32px rgba(0,0,0,0.1); z-index: 1001;
            transition: right 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex; flex-direction: column;
        }
        .side-panel.show { right: 0; }
        
        .side-panel-head {
            padding: 24px; border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center;
        }
        .side-panel-title { font-size: 18px; font-weight: 700; color: var(--fg); margin: 0; }
        .side-panel-close {
            background: var(--surface-2); border: none; width: 32px; height: 32px;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            cursor: pointer; color: var(--muted); transition: 0.2s; font-size: 20px;
        }
        .side-panel-close:hover { background: var(--danger-soft); color: var(--danger); }
        
        .side-panel-body { flex: 1; overflow-y: auto; padding: 24px; }
        
        .serial-search-box {
            width: 100%; padding: 12px 16px; margin-bottom: 20px;
            border: 1px solid var(--border); border-radius: var(--radius);
            background: var(--bg); color: var(--fg); font-size: 14px; font-family: var(--font-ui);
            box-sizing: border-box; transition: border-color 0.2s;
        }
        .serial-search-box:focus { outline: none; border-color: var(--accent); }

        .serial-list-wrap { display: flex; flex-direction: column; gap: 12px; }
        
        .serial-card {
            padding: 16px; border: 1px solid var(--border); border-radius: var(--radius-md);
            background: var(--surface); cursor: pointer; transition: all 0.2s;
            display: flex; justify-content: space-between; align-items: center;
        }
        .serial-card:hover { border-color: var(--accent); box-shadow: 0 4px 12px rgba(13, 110, 253, 0.1); transform: translateY(-1px); }
        [data-theme="dark"] .serial-card:hover { box-shadow: 0 4px 12px rgba(96, 165, 250, 0.1); }
        
        .serial-card-left { display: flex; flex-direction: column; gap: 6px; }
        .serial-number-text { font-family: var(--font-mono); font-size: 15px; font-weight: 700; color: var(--fg); }
        .serial-meta { font-size: 12px; color: var(--muted); display: flex; gap: 12px; align-items: center; }
        
        .serial-card-icon { color: var(--accent); opacity: 0; transition: 0.2s; transform: translateX(-8px); }
        .serial-card:hover .serial-card-icon { opacity: 1; transform: translateX(0); }
        
        .empty-msg { padding: 40px 20px; color: var(--muted); text-align: center; font-size: 14px; }
        
        .badge-avail {
            display: inline-flex; align-items: center; gap: 4px; padding: 2px 6px;
            border-radius: 12px; font-size: 10px; font-weight: 700;
            background: #d1fae5; color: #059669; text-transform: uppercase;
        }
        [data-theme="dark"] .badge-avail { background: var(--accent-soft); color: var(--accent); }
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

            <div class="form-layout">
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <c:if test="${not empty liquidation.managerFeedbackName}">
                        <div style="display: flex; gap: 10px; align-items: flex-start; background: var(--warn-soft); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); color: var(--warn);">
                            <div>
                                <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Phản hồi từ Quản lý kho</div>
                                <div style="font-size: 13px;">${liquidation.managerFeedbackName}</div>
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
                            <!-- Kho hàng -->
                            <div class="field">
                                <label class="field-label">Kho hàng <span class="req">*</span></label>
                                <select class="input" name="warehouseId" id="warehouseId" required>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" ${w.warehouseId == liquidation.warehouseId ? 'selected' : ''}>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <!-- Lý do thanh lý -->
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
            </div>
        </main>
    </div>
</div>

<!-- Side Panel cho Serial -->
<div class="side-panel-overlay" id="sidePanelOverlay" onclick="closeSerialPanel()"></div>
<div class="side-panel" id="sidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn Số Serial</h3>
        <button class="side-panel-close" onclick="closeSerialPanel()">×</button>
    </div>
    <div class="side-panel-body">
        <div style="display:flex; gap: 8px; margin-bottom: 20px;">
            <input type="text" id="serialSearchInput" class="serial-search-box" style="margin-bottom:0;" placeholder="Tìm nhanh Serial..." autocomplete="off"/>
            <select id="serialSortOrder" class="serial-search-box" style="margin-bottom:0; width: 130px; padding: 0 8px; cursor: pointer;" title="Sắp xếp theo ngày nhập">
                <option value="desc">Mới nhất</option>
                <option value="asc">Cũ nhất</option>
            </select>
        </div>
        
        <div id="serialLoading" style="display:none; text-align:center; padding:40px 20px; color:var(--muted);">
            <svg style="animation: spin 1s linear infinite; margin-bottom: 10px;" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
            <br/>Đang tải dữ liệu...
            <style>@keyframes spin { 100% { transform: rotate(360deg); } }</style>
        </div>
        
        <div class="serial-list-wrap" id="serialList"></div>
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
        var searchInput = document.getElementById('serialSearchInput');
        var sortSelect = document.getElementById('serialSortOrder');
        searchInput.value = '';
        sortSelect.value = 'desc';
        
        document.getElementById('sidePanelOverlay').classList.add('show');
        document.getElementById('sidePanel').classList.add('show');
        
        document.getElementById('serialList').innerHTML = '';
        document.getElementById('serialLoading').style.display = 'block';
        
        // Wait for CSS transition
        setTimeout(function() { searchInput.focus(); }, 300);

        fetch('${pageContext.request.contextPath}/liquidations?action=get_serials&warehouseId=' + warehouseId + '&generatorId=' + generatorId)
            .then(response => response.json())
            .then(data => {
                document.getElementById('serialLoading').style.display = 'none';
                var listWrap = document.getElementById('serialList');
                
                if (data.length === 0) {
                    listWrap.innerHTML = '<div class="empty-msg">Không có máy nào trong kho đang rảnh.</div>';
                    return;
                }
                
                // Get all already selected serials to exclude them
                var selectedSerials = Array.from(document.querySelectorAll('input[name="serialNumber"]'))
                    .map(inp => inp.value)
                    .filter(val => val !== '');

                var count = 0;
                data.forEach(sn => {
                    if (!selectedSerials.includes(sn.serialNumber)) {
                        // Format date
                        var dateStr = 'Chưa xác định';
                        var timestamp = 0;
                        if (sn.createdAt) {
                            var d = new Date(sn.createdAt);
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
                        card.setAttribute('data-serial', sn.serialNumber.toLowerCase());
                        card.setAttribute('data-date', dateStr);
                        card.setAttribute('data-time', timestamp);

                        card.innerHTML = `
                            <div class="serial-card-left">
                                <div class="serial-number-text">` + sn.serialNumber + `</div>
                                <div class="serial-meta">
                                    <span class="badge-avail"><span style="width:5px;height:5px;border-radius:50%;background:currentColor;"></span> IN STOCK</span>
                                    ` + (sn.generatorName ? `<span style="display:flex;align-items:center;gap:4px;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>` + sn.generatorName + `</span>` : '') + `
                                    <span style="display:flex;align-items:center;gap:4px;"><svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>` + dateStr + `</span>
                                </div>
                            </div>
                            <div class="serial-card-icon">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                            </div>
                        `;
                        
                        card.onclick = function() {
                            currentSerialInput.value = sn.serialNumber;
                            closeSerialPanel();
                        };
                        listWrap.appendChild(card);
                        count++;
                    }
                });
                
                if (count === 0) {
                    listWrap.innerHTML = '<div class="empty-msg">Tất cả máy khả dụng đã được chọn.</div>';
                }
                // Initially sort desc
                filterAndSortSerials();
            })
            .catch(error => {
                document.getElementById('serialLoading').style.display = 'none';
                document.getElementById('serialList').innerHTML = '<div class="empty-msg" style="color:var(--danger)">Lỗi kết nối khi tải dữ liệu</div>';
            });
    }

    function filterAndSortSerials() {
        var query = document.getElementById('serialSearchInput').value.toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;
        
        var listWrap = document.getElementById('serialList');
        var items = Array.from(listWrap.querySelectorAll('.serial-card'));

        // Sắp xếp
        items.sort(function(a, b) {
            var timeA = parseInt(a.getAttribute('data-time') || '0', 10);
            var timeB = parseInt(b.getAttribute('data-time') || '0', 10);
            if (sortOrder === 'desc') {
                return timeB - timeA;
            } else {
                return timeA - timeB;
            }
        });

        // Lọc và append lại
        items.forEach(function(item) {
            var serial = item.getAttribute('data-serial');
            if (serial.indexOf(query) > -1) {
                item.style.display = 'flex';
                listWrap.appendChild(item); // appendChild sẽ di chuyển element xuống cuối (giữ thứ tự sort)
            } else {
                item.style.display = 'none';
            }
        });
    }

    document.getElementById('serialSearchInput')?.addEventListener('input', filterAndSortSerials);
    document.getElementById('serialSortOrder')?.addEventListener('change', filterAndSortSerials);

    function closeSerialPanel() {
        document.getElementById('sidePanel').classList.remove('show');
        document.getElementById('sidePanelOverlay').classList.remove('show');
        currentSerialInput = null;
    }
</script>
</body>
</html>
