<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Xem trước dữ liệu đề xuất - Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>
            h1,h2,h3,h4{font-weight:700;letter-spacing:-0.01em}
            label,.label{font-weight:600}
            input,select,textarea,button{font-weight:500}
            .mono{font-family:var(--font-mono);font-variant-numeric:tabular-nums}
            main{padding:24px 32px 60px;max-width:1080px;margin:0 auto}
            .page-head{margin-bottom:20px}
            .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
            .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
            .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
            .page-head .lede{color:var(--muted);margin-top:6px;max-width:640px;font-size:14px}
            .section{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;margin-bottom:16px}
            .section-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border)}
            .section-head-left{display:flex;align-items:baseline;gap:12px;min-width:0}
            .section-head h3{font-size:14px;font-weight:700;margin:0}
            .section-head .sub{font-size:11.5px;color:var(--muted);font-family:var(--font-mono)}
            .section-body{padding:22px 20px}
            .form-grid{display:grid;grid-template-columns:1fr 2fr;gap:14px}
            .info-field .info-label{font-size:11px;color:var(--muted);font-weight:600;text-transform:uppercase;letter-spacing:0.02em;margin-bottom:4px;display:block}
            .info-field .info-value{font-size:13.5px;color:var(--fg);padding:8px 12px;background:var(--surface-2);border:1px solid var(--border);border-radius:var(--radius-sm)}
            .summary-row{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px}
            .pill{display:inline-flex;align-items:center;gap:5px;font-size:12px;font-weight:600;padding:4px 12px;border-radius:999px;border:1px solid}
            .pill .pill-num{font-weight:700}
            .pill.ok{color:var(--accent);border-color:color-mix(in srgb,var(--accent) 25%,transparent);background:var(--accent-soft)}
            .pill.warn{color:var(--warn);border-color:color-mix(in srgb,var(--warn) 25%,transparent);background:var(--warn-soft)}
            .pill.bad{color:var(--danger);border-color:color-mix(in srgb,var(--danger) 25%,transparent);background:var(--danger-soft)}
            table.data-table{width:100%;border-collapse:separate;border-spacing:0;font-size:13px}
            table.data-table thead th{text-align:left;font-size:11px;color:var(--muted);text-transform:uppercase;font-weight:700;background:var(--surface-2);padding:11px 14px;border-bottom:1px solid var(--border);letter-spacing:0.04em}
            table.data-table tbody td{padding:11px 14px;border-bottom:1px solid var(--border);vertical-align:middle}
            table.data-table tbody tr:last-child td{border-bottom:0}
            .text-right{text-align:right}
            .text-center{text-align:center}
            .model-cell{font-weight:600}
            .name-cell{color:var(--muted);font-size:12.5px}
            .error-msg{color:var(--danger);font-size:12px;font-weight:600;margin-top:4px}
            table.data-table .row-qty{width:90px;padding:6px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box;text-align:right}
            table.data-table .row-qty:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            table.data-table .row-note{width:100%;padding:6px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box}
            table.data-table .row-note:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
            .btn:hover{background:var(--surface-2)}
            .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
            .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
            .btn:disabled{opacity:0.4;cursor:not-allowed}
            .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:22px;flex-wrap:wrap}
            .alert{padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:16px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;border:1px solid}
            .alert svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0}
            .alert-warn{background:var(--warn-soft);color:var(--warn);border-color:color-mix(in srgb,var(--warn) 30%,transparent)}
            .alert-error{background:var(--danger-soft);color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
            .alert-success{background:var(--accent-soft);color:var(--accent);border-color:color-mix(in srgb,var(--accent) 30%,transparent)}
            .topbar{position:sticky;top:0;z-index:10;background:color-mix(in srgb,var(--bg) 85%,transparent);backdrop-filter:blur(8px);border-bottom:1px solid var(--border);display:flex;align-items:center;gap:16px;padding:12px 24px}
            .topbar h1{font-size:16px;font-weight:700;margin:0;letter-spacing:-0.01em}
            .crumb{color:var(--muted);font-size:13px;font-weight:500}
            .top-actions{margin-inline-start:auto;display:flex;align-items:center;gap:8px}
            .icon-btn{width:32px;height:32px;border:1px solid var(--border);background:var(--surface);color:var(--fg-soft);border-radius:var(--radius-sm);display:grid;place-items:center;cursor:pointer}
            .icon-btn:hover{background:var(--surface-2);color:var(--fg)}
            .icon-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.6}
            .back-link{display:inline-flex;align-items:center;gap:6px;color:var(--muted);text-decoration:none;font-size:13px;font-weight:600;margin-bottom:14px}
            .back-link:hover{color:var(--fg)}
            .back-link svg{width:14px;height:14px;stroke:currentColor;fill:none;stroke-width:1.8}
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
            <div>
                <header class="topbar">
                    <h1>Xem trước dữ liệu</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / Tạo mới / Xem trước</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=create">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại tải file
                    </a>
                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : (sessionScope.toastType == 'success' ? 'alert-success' : 'alert-warn')}">
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>
                    <c:if test="${not empty requestScope.toastMessage}">
                        <div class="alert ${requestScope.toastType == 'danger' ? 'alert-error' : (requestScope.toastType == 'success' ? 'alert-success' : 'alert-warn')}">
                            <span><c:out value="${requestScope.toastMessage}"/></span>
                        </div>
                    </c:if>
                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Xem trước</div>
                        <h1 class="title">Kiểm tra dữ liệu trước khi lưu</h1>
                        <div class="lede">Hệ thống đã tách dòng hợp lệ, dòng cảnh báo máy mới và dòng lỗi. Bấm Lưu nháp hoặc Gửi duyệt.</div>
                    </div>
                    <div class="section">
                        <div class="section-head">
                            <div class="section-head-left"><h3>Thông tin chung</h3></div>
                        </div>
                        <div class="section-body">
                            <div class="form-grid">
                                <div class="info-field">
                                    <span class="info-label">Kho nhập</span>
                                    <div class="info-value">
                                        <c:set var="whId" value="${currentWarehouseId}"/>
                                        <c:set var="whName" value=""/>
                                        <c:forEach var="w" items="${warehouses}">
                                            <c:if test="${w.warehouseId == whId}"><c:set var="whName" value="${w.name}"/></c:if>
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${not empty whName}"><c:out value="${whName}"/></c:when>
                                            <c:otherwise>#${whId}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-field">
                                    <span class="info-label">Ghi chú</span>
                                    <div class="info-value"><c:out value="${empty currentNote ? '(không có)' : currentNote}"/></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="summary-row">
                        <c:if test="${not empty validRows}">
                            <span class="pill ok"><span class="pill-num"><c:out value="${fn:length(validRows)}"/></span> dòng hợp lệ</span>
                        </c:if>
                        <c:if test="${not empty warningRows}">
                            <span class="pill warn"><span class="pill-num"><c:out value="${fn:length(warningRows)}"/></span> máy chưa có trong kho</span>
                        </c:if>
                        <c:if test="${not empty invalidRows}">
                            <span class="pill bad"><span class="pill-num"><c:out value="${fn:length(invalidRows)}"/></span> dòng lỗi</span>
                        </c:if>
                    </div>
                    <form id="confirmForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=importConfirm">
                        <input type="hidden" name="warehouseId" value="<c:out value='${currentWarehouseId}'/>"/>
                        <input type="hidden" name="note" value="<c:out value='${currentNote}'/>"/>
                        <input type="hidden" name="submitType" id="submitType" value="pending"/>
                        <c:if test="${not empty warningRows}">
                            <div class="alert alert-warn" style="margin-bottom:12px">
                                <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                <span>Có <strong>${fn:length(warningRows)}</strong> máy phát chưa có trong kho. Manager sẽ thấy cảnh báo khi duyệt, warehouse tự thêm category sau.</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty validRows}">
                            <div class="section" style="padding:0">
                                <div class="section-head" style="padding:14px 18px"><div class="section-head-left"><h3>Dòng hợp lệ</h3><span class="sub">${fn:length(validRows)} dòng</span></div></div>
                                <table class="data-table">
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Tên máy</th><th style="width:110px" class="text-right">Số lượng</th><th>Ghi chú dòng</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${validRows}">
                                            <tr data-id="<c:out value='${row.gid}'/>">
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['gmodel']}"/></td>
                                                <td class="name-cell"><c:out value="${row['gname']}"/></td>
                                                <td><input type="number" class="row-qty" min="1" max="9999" value="<c:out value='${row.gqty}'/>" /></td>
                                                <td><input type="text" class="row-note" value="<c:out value='${row.gline}'/>" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${not empty warningRows}">
                            <div class="section" style="padding:0">
                                <div class="section-head" style="padding:14px 18px"><div class="section-head-left"><h3>Máy chưa có trong kho</h3><span class="sub">${fn:length(warningRows)} dòng</span></div></div>
                                <table class="data-table">
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Tên máy</th><th style="width:110px" class="text-right">Số lượng</th><th>Ghi chú dòng</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${warningRows}">
                                            <tr data-id="<c:out value='${row.gid}'/>">
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['gmodel']}"/></td>
                                                <td class="name-cell"><c:out value="${row['gname']}"/></td>
                                                <td><input type="number" class="row-qty" min="1" max="9999" value="<c:out value='${row.gqty}'/>" /></td>
                                                <td><input type="text" class="row-note" value="<c:out value='${row.gline}'/>" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${not empty invalidRows}">
                            <div class="section" style="padding:0">
                                <div class="section-head" style="padding:14px 18px"><div class="section-head-left"><h3>Dòng lỗi - bỏ qua</h3><span class="sub">${fn:length(invalidRows)} dòng</span></div></div>
                                <table class="data-table">
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Số lượng</th><th>Lỗi</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${invalidRows}">
                                            <tr>
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['Mã máy phát']}"/></td>
                                                <td><c:out value="${row['Số lượng']}"/></td>
                                                <td><div class="error-msg"><c:out value="${row['gerrors']}"/></div></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${empty validRows and empty warningRows}">
                            <div class="section"><div class="section-body text-center" style="color:var(--muted)">Không có dòng hợp lệ nào để lưu. Vui lòng quay lại và chỉnh sửa file Excel.</div></div>
                        </c:if>
                        <div class="actions">
                            <a class="btn" href="${pageContext.request.contextPath}/proposal?action=create">Hủy</a>
                            <button type="button" class="btn" id="btnDraft" ${(empty validRows and empty warningRows) ? 'disabled' : ''}>Lưu nháp</button>
                            <button type="button" class="btn btn-primary" id="btnPending" ${(empty validRows and empty warningRows) ? 'disabled' : ''}>Gửi duyệt</button>
                        </div>
                    </form>
                </main>
            </div>
        </div>
        <script>
            (function () {
                var form = document.getElementById('confirmForm');
                var submitTypeInput = document.getElementById('submitType');
                var btnDraft = document.getElementById('btnDraft');
                var btnPending = document.getElementById('btnPending');
                var rows = document.querySelectorAll('tr[data-id]');
                if (!rows.length) return;

                function buildPayload() {
                    form.querySelectorAll('input[name="generatorId"], input[name="quantity"], input[name="detailNote"]').forEach(function (e) { e.remove(); });
                    var count = 0;
                    rows.forEach(function (tr) {
                        var id = tr.getAttribute('data-id');
                        if (!id) return;
                        var qty = tr.querySelector('.row-qty');
                        var note = tr.querySelector('.row-note');
                        var q = qty ? parseInt(qty.value) : 1;
                        if (isNaN(q) || q < 1) q = 1;
                        if (q > 9999) q = 9999;
                        var idInput = document.createElement('input');
                        idInput.type = 'hidden';
                        idInput.name = 'generatorId';
                        idInput.value = id;
                        form.appendChild(idInput);
                        var qtyInput = document.createElement('input');
                        qtyInput.type = 'hidden';
                        qtyInput.name = 'quantity';
                        qtyInput.value = String(q);
                        form.appendChild(qtyInput);
                        if (note) {
                            var noteInput = document.createElement('input');
                            noteInput.type = 'hidden';
                            noteInput.name = 'detailNote';
                            noteInput.value = note.value || '';
                            form.appendChild(noteInput);
                        }
                        count++;
                    });
                    return count;
                }

                function submitForm(value) {
                    var count = buildPayload();
                    if (!count) { alert('Không có dòng hợp lệ nào để lưu.'); return; }
                    submitTypeInput.value = value;
                    form.submit();
                }

                if (btnDraft) btnDraft.addEventListener('click', function () { submitForm('draft'); });
                if (btnPending) btnPending.addEventListener('click', function () { submitForm('pending'); });
            })();
        </script>
    </body>
</html>