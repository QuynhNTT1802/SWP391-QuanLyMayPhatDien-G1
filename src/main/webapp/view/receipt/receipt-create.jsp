<%-- 
    Document   : receipt-create
    Created on : May 27, 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo phiếu — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/role/rbac-role-edit.css">
    <style>
        .detail-section { margin-top: 24px; }
        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th { text-align: left; padding: 8px 10px; font-size: 12px;
            font-weight: 600; color: var(--muted); border-bottom: 1px solid var(--border);
            text-transform: uppercase; letter-spacing: 0.5px; }
        .detail-table td { padding: 8px 6px; vertical-align: top; }
        .detail-table select, .detail-table input { width: 100%; padding: 7px 8px;
            border: 1px solid var(--border); border-radius: var(--radius-sm);
            background: var(--bg); color: var(--fg); font-size: 13px;
            font-family: var(--font-ui); box-sizing: border-box; }
        .detail-table .col-num { width: 36px; text-align: center; color: var(--muted);
            font-size: 12px; font-weight: 600; padding-top: 14px; }
        .detail-table .col-gen { min-width: 150px; }
        .detail-table .col-serial { min-width: 130px; }
        .detail-table .col-qty { width: 90px; }
        .detail-table .col-note { min-width: 130px; }
        .detail-table .col-del { width: 40px; text-align: center; }
        .row-del-btn { width: 28px; height: 28px; border: none; background: none;
            color: var(--danger); cursor: pointer; border-radius: var(--radius-sm);
            display: inline-flex; align-items: center; justify-content: center; margin-top: 4px; }
        .row-del-btn:hover { background: var(--danger-soft); }
        .add-row-btn { margin-top: 8px; font-size: 13px; }
        .error-box { background: var(--danger-soft); color: var(--danger);
            border: 1px solid color-mix(in srgb,var(--danger) 30%,transparent);
            border-radius: var(--radius); padding: 10px 16px; margin-bottom: 16px; }
        .error-box ul { margin: 4px 0 0 16px; padding: 0; font-size: 13px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar topbar-edit">
            <a href="${pageContext.request.contextPath}/receipt" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Hủy
            </a>
            <div class="topbar-info">
                <h1>Tạo phiếu mới</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/receipt">Phiếu nhập/xuất</a></span>
            </div>
            <button type="button" class="btn btn-primary" onclick="document.getElementById('receiptForm').submit()">Lưu phiếu</button>
        </header>

        <form id="receiptForm" action="${pageContext.request.contextPath}/receipt?action=save" method="POST">
            <c:if test="${not empty errors}">
                <div class="error-box">
                    <strong>Vui lòng sửa các lỗi sau:</strong>
                    <ul>
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <main>
                <div class="page-head">
                    <div class="head-left">
                        <div class="eyebrow">Phiếu · Tạo mới</div>
                        <h2>Phiếu nhập/xuất kho</h2>
                        <p>Điền thông tin phiếu và chi tiết các dòng hàng.</p>
                    </div>
                </div>

                <div class="layout">
                    <div>
                        <div class="section">
                            <div class="section-head"><h3>Thông tin phiếu</h3></div>
                            <div class="section-body">
                                <div class="field-row-2">
                                    <div class="field">
                                        <label>Loại phiếu</label>
                                        <select name="receiptType" required>
                                            <option value="">-- Chọn loại --</option>
                                            <option value="IMPORT" <c:if test="${receipt.receiptType == 'IMPORT'}">selected</c:if>>Nhập kho</option>
                                            <option value="EXPORT" <c:if test="${receipt.receiptType == 'EXPORT'}">selected</c:if>>Xuất kho</option>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label>Kho</label>
                                        <select name="warehouseId" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.warehouseId}" <c:if test="${receipt.warehouseId == wh.warehouseId}">selected</c:if>>${wh.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="field">
                                    <label>Ghi chú phiếu</label>
                                    <textarea name="note">${receipt.note}</textarea>
                                </div>
                            </div>
                        </div>

                        <div class="section detail-section">
                            <div class="section-head"><h3>Chi tiết phiếu</h3></div>
                            <div class="section-body">
                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th class="col-gen">Máy phát</th>
                                            <th class="col-serial">Serial</th>
                                            <th class="col-qty">Số lượng</th>
                                            <th class="col-note">Ghi chú</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <tr>
                                            <td class="col-num"><span class="row-num">1</span></td>
                                            <td>
                                                <select name="generatorId" required>
                                                    <option value="">-- Chọn máy --</option>
                                                    <c:forEach var="g" items="${generators}">
                                                        <option value="${g.id}">${g.model}${not empty brandMap[g.id] ? ' ('.concat(brandMap[g.id]).concat(')') : ''}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input type="text" name="serialNumber" placeholder="S/N" /></td>
                                            <td><input type="number" name="quantity" value="1" min="1" required /></td>
                                            <td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>
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
                                            <select name="generatorId">
                                                <option value="">-- Chọn máy --</option>
                                                <c:forEach var="g" items="${generators}">
                                                    <option value="${g.id}">${g.model}${not empty brandMap[g.id] ? ' ('.concat(brandMap[g.id]).concat(')') : ''}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="text" name="serialNumber" placeholder="S/N" /></td>
                                        <td><input type="number" name="quantity" value="1" min="1" /></td>
                                        <td><input type="text" name="detailNote" placeholder="Ghi chú" /></td>
                                        <td class="col-del">
                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/></svg>
                                            </button>
                                        </td>
                                    </tr>
                                </template>

                                <button type="button" class="btn add-row-btn" onclick="addRow()">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm dòng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </form>
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
        document.querySelectorAll('#detailBody .row-num').forEach(function(el, i) {
            el.textContent = i + 1;
        });
    }
</script>
</body>
</html>
