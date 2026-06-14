<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo đơn thanh lý mới — Warehouse OS</title>
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
                            <h3 class="form-section-title">Kho hàng và Lý do thanh lý</h3>
                        </div>

                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Kho hàng <span class="req">*</span></label>
                                <select class="input" name="warehouseId" id="warehouseId" required>
                                    <option value="">-- Chọn kho hàng --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}">${w.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

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
                                    <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly onclick="openSerialModal(this)"/></td>
                                    <td><input type="number" name="originalPrice" placeholder="Giá gốc" readonly required/></td>
                                    <td class="col-del">
                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                            <svg viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
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
                                <td><input type="text" name="serialNumber" placeholder="Click để chọn S/N" required readonly onclick="openSerialModal(this)"/></td>
                                <td><input type="number" name="originalPrice" placeholder="Giá gốc" readonly required/></td>
                                <td class="col-del">
                                    <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                        <svg viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                    </button>
                                </td>
                            </tr>
                        </template>

                        <button type="button" class="btn add-row-btn" id="addRowBtn" onclick="addRow()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm dòng
                        </button>

                        <div class="liq-form-total" id="formTotalBox" style="display:none;">
                            <div class="lbl">Tổng giá gốc (đơn dự kiến)</div>
                            <div class="val"><span id="formTotalVal">0</span><span class="unit">VNĐ</span></div>
                        </div>
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

<!-- Side Panel cho Serial -->
<div class="side-panel-overlay" id="sidePanelOverlay" onclick="closeSerialPanel()"></div>
<div class="side-panel" id="sidePanel">
    <div class="side-panel-head">
        <h3 class="side-panel-title">Chọn Số Serial</h3>
        <button class="side-panel-close" onclick="closeSerialPanel()" title="Đóng">
            <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </button>
    </div>
    <div class="side-panel-body">
        <div class="side-panel-tools">
            <input type="text" id="serialSearchInput" class="serial-search-box" placeholder="Tìm nhanh Serial..." autocomplete="off"/>
            <select id="serialSortOrder" class="serial-sort-select" title="Sắp xếp theo ngày nhập">
                <option value="asc">Cũ nhất (ưu tiên)</option>
                <option value="desc">Mới nhất</option>
            </select>
        </div>

        <div id="serialLoading" class="serial-loading">
            <svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
            <div>Đang tải dữ liệu...</div>
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
        recalcFormTotal();
    }
    function removeRow(btn) {
        var tbody = document.getElementById('detailBody');
        if (tbody.querySelectorAll('tr').length <= 1) return;
        btn.closest('tr').remove();
        updateRowNumbers();
        recalcFormTotal();
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
        serialInput.value = "";
        recalcFormTotal();
    }

    function recalcFormTotal() {
        var total = 0;
        document.querySelectorAll('#detailBody input[name="originalPrice"]').forEach(function(inp) {
            var v = parseFloat(inp.value || '0');
            if (!isNaN(v)) total += v;
        });
        var box = document.getElementById('formTotalBox');
        var val = document.getElementById('formTotalVal');
        if (total > 0) {
            box.style.display = 'flex';
            val.textContent = total.toLocaleString('vi-VN');
        } else {
            box.style.display = 'none';
        }
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
        sortSelect.value = 'asc';

        document.getElementById('sidePanelOverlay').classList.add('show');
        document.getElementById('sidePanel').classList.add('show');

        document.getElementById('serialList').innerHTML = '';
        document.getElementById('serialLoading').classList.add('show');

        setTimeout(function() { searchInput.focus(); }, 300);

        fetch('${pageContext.request.contextPath}/liquidations?action=get_serials&warehouseId=' + warehouseId + '&generatorId=' + generatorId)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                document.getElementById('serialLoading').classList.remove('show');
                var listWrap = document.getElementById('serialList');

                if (data.length === 0) {
                    listWrap.innerHTML = '<div class="empty-msg">Không có máy nào trong kho đang rảnh.</div>';
                    return;
                }

                var selectedSerials = Array.from(document.querySelectorAll('input[name="serialNumber"]'))
                    .map(function(inp) { return inp.value; })
                    .filter(function(val) { return val !== ''; });

                var count = 0;
                data.forEach(function(sn) {
                    if (!selectedSerials.includes(sn.serialNumber)) {
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

                        // Tinh tuoi ton kho
                        var ageMonths = 0;
                        var ageClass = 'age-fresh';
                        var ageText = '';
                        if (timestamp > 0) {
                            ageMonths = Math.floor((Date.now() - timestamp) / (1000 * 60 * 60 * 24 * 30));
                            ageText = ageMonths + ' th\u00e1ng';
                            if (ageMonths >= 12) ageClass = 'age-old';
                            else if (ageMonths >= 6) ageClass = 'age-mid';
                        } else {
                            ageText = 'Ch\u01b0a x\u00e1c \u0111\u1ecbnh';
                        }

                        var card = document.createElement('div');
                        card.className = 'serial-card';
                        card.setAttribute('data-serial', sn.serialNumber.toLowerCase());
                        card.setAttribute('data-time', timestamp);

                        var html = '<div class="serial-card-left">'
                                 + '  <div class="serial-number-text">' + sn.serialNumber + '</div>'
                                 + '  <div class="serial-meta">'
                                 + '    <span class="age-chip ' + ageClass + '"><span class="pdot"></span>' + ageText + '</span>'
                                 + '    <span class="serial-meta-item">' + dateStr + '</span>'
                                 + '  </div>'
                                 + '</div>'
                                 + '<div class="serial-card-icon">'
                                 + '  <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>'
                                 + '</div>';
                        card.innerHTML = html;

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
                filterAndSortSerials();
            })
            .catch(function() {
                document.getElementById('serialLoading').classList.remove('show');
                document.getElementById('serialList').innerHTML = '<div class="empty-msg" style="color:var(--danger)">Lỗi kết nối khi tải dữ liệu</div>';
            });
    }

    function filterAndSortSerials() {
        var query = document.getElementById('serialSearchInput').value.toLowerCase().trim();
        var sortOrder = document.getElementById('serialSortOrder').value;

        var listWrap = document.getElementById('serialList');
        var items = Array.from(listWrap.querySelectorAll('.serial-card'));

        items.sort(function(a, b) {
            var timeA = parseInt(a.getAttribute('data-time') || '0', 10);
            var timeB = parseInt(b.getAttribute('data-time') || '0', 10);
            return sortOrder === 'desc' ? timeB - timeA : timeA - timeB;
        });

        items.forEach(function(item) {
            var text = item.getAttribute('data-serial');
            item.style.display = text.indexOf(query) > -1 ? 'flex' : 'none';
            listWrap.appendChild(item);
        });
    }

    document.getElementById('serialSearchInput').addEventListener('input', filterAndSortSerials);
    document.getElementById('serialSortOrder').addEventListener('change', filterAndSortSerials);

    function getVisibleSerialCards() {
        return Array.from(document.querySelectorAll('#serialList .serial-card'))
            .filter(function(el) { return el.style.display !== 'none'; });
    }
    function focusSerialCard(idx) {
        var cards = getVisibleSerialCards();
        cards.forEach(function(c) { c.classList.remove('serial-card--focused'); });
        if (idx < 0 || idx >= cards.length) return;
        cards[idx].classList.add('serial-card--focused');
        cards[idx].scrollIntoView({ block: 'nearest' });
    }
    document.getElementById('serialSearchInput').addEventListener('keydown', function(e) {
        var cards = getVisibleSerialCards();
        var current = cards.findIndex(function(c) { return c.classList.contains('serial-card--focused'); });
        if (e.key === 'ArrowDown') {
            e.preventDefault();
            focusSerialCard(current < cards.length - 1 ? current + 1 : 0);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            focusSerialCard(current > 0 ? current - 1 : cards.length - 1);
        } else if (e.key === 'Enter') {
            e.preventDefault();
            var idx = current >= 0 ? current : 0;
            if (cards[idx]) cards[idx].click();
        }
    });

    function closeSerialPanel() {
        document.getElementById('sidePanelOverlay').classList.remove('show');
        document.getElementById('sidePanel').classList.remove('show');
        currentSerialInput = null;
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeSerialPanel();
    });
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
