<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Xem trước dữ liệu đề xuất — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            a.btn { text-decoration: none; }
            .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 13px; margin-bottom: 14px; }
            .back-link:hover { color: var(--accent); }
            .back-link svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; }

            .import-wrap { max-width: 1080px; margin: 0 auto; padding: 12px 4px 40px; }

            .import-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                box-shadow: 0 1px 2px rgba(0,0,0,0.03);
                margin-bottom: 18px;
            }
            .import-card-head {
                display: flex; align-items: center; gap: 12px;
                padding: 18px 24px;
                border-bottom: 1px solid var(--border);
            }
            .import-card-head .head-icon {
                width: 36px; height: 36px; border-radius: 8px;
                background: var(--accent-soft); color: var(--accent);
                display: grid; place-items: center; flex-shrink: 0;
            }
            .import-card-head .head-icon svg {
                width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 1.8;
            }
            .import-card-head h2 { margin: 0; font-size: 17px; font-weight: 700; color: var(--fg); }
            .import-card-head p { margin: 2px 0 0; font-size: 12.5px; color: var(--muted); }

            .import-card-body { padding: 22px 24px 26px; }

            .form-section {
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                padding: 16px 18px;
                margin-bottom: 18px;
            }
            .form-section-title {
                font-size: 12.5px; font-weight: 700; text-transform: uppercase;
                letter-spacing: 0.06em; color: var(--muted);
                margin: 0 0 10px;
            }
            .form-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 14px; }
            .field-label { font-size: 12px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px; display: block; }
            .field-value { font-size: 13.5px; color: var(--fg); padding: 8px 12px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); }

            .summary-row {
                display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 16px;
            }
            .summary-pill {
                display: inline-flex; align-items: center; gap: 6px;
                padding: 6px 12px; border-radius: 999px;
                font-size: 12.5px; font-weight: 600;
                border: 1px solid var(--border);
            }
            .summary-pill .pill-num { font-weight: 700; }
            .summary-pill.ok { background: var(--accent-soft); color: var(--accent); border-color: color-mix(in srgb, var(--accent) 25%, transparent); }
            .summary-pill.err { background: var(--danger-soft); color: var(--danger); border-color: color-mix(in srgb, var(--danger) 25%, transparent); }

            .preview-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                font-size: 13px;
            }
            .preview-table thead th {
                text-align: left;
                font-size: 11.5px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                color: var(--muted);
                padding: 10px 12px;
                background: var(--surface-2);
                border-bottom: 1px solid var(--border);
            }
            .preview-table tbody td {
                padding: 10px 12px;
                border-bottom: 1px solid var(--border);
                vertical-align: top;
            }
            .preview-table tbody tr:last-child td { border-bottom: none; }
            .preview-table .col-check { width: 38px; text-align: center; }
            .preview-table .col-stt { width: 50px; }
            .preview-table .col-qty { width: 100px; }
            .preview-table .model-cell { font-weight: 600; color: var(--fg); }
            .preview-table .name-cell { color: var(--muted); font-size: 12.5px; }
            .preview-table input[type="checkbox"] { width: 16px; height: 16px; cursor: pointer; }
            .preview-table input[type="number"] {
                width: 80px; padding: 6px 8px;
                border: 1px solid var(--border); border-radius: var(--radius-sm);
                background: var(--bg); color: var(--fg); font-size: 13px;
                font-family: inherit; box-sizing: border-box;
            }
            .preview-table input[type="text"] {
                width: 100%; padding: 6px 8px;
                border: 1px solid var(--border); border-radius: var(--radius-sm);
                background: var(--bg); color: var(--fg); font-size: 13px;
                font-family: inherit; box-sizing: border-box;
            }
            .error-msg {
                color: var(--danger);
                font-size: 12px;
                font-weight: 600;
                margin-top: 4px;
            }
            .row-invalid { background: color-mix(in srgb, var(--danger) 6%, transparent); }
            .row-invalid input { opacity: 0.6; }
            .row-warning { background: color-mix(in srgb, #f59e0b 8%, transparent); }
            .warning-msg { color: #b45309; font-size: 12px; font-weight: 600; margin-top: 4px; }

            .import-actions {
                display: flex; gap: 10px; justify-content: flex-end;
                margin-top: 22px; flex-wrap: wrap;
            }
            .import-actions .btn {
                display: inline-flex; align-items: center; gap: 8px;
                padding: 10px 20px; font-size: 13.5px; font-weight: 600;
                border-radius: var(--radius-sm);
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                cursor: pointer;
            }
            .import-actions .btn svg { width: 16px; height: 16px; stroke: currentColor; fill: none; stroke-width: 1.8; }
            .btn-primary { background: var(--accent); color: #fff; border-color: var(--accent); }
            .btn-primary:hover { filter: brightness(1.05); }
            .btn-warning { background: #f59e0b; color: #fff; border-color: #f59e0b; }
            .btn-warning:hover { filter: brightness(1.05); }

            .empty-state {
                padding: 28px; text-align: center; color: var(--muted); font-size: 13px;
                background: var(--surface-2); border: 1px dashed var(--border); border-radius: var(--radius-sm);
            }
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
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=create">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại tải file
                    </a>

                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : 'alert-success'}">
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>

                    <div class="import-wrap">
                        <div class="import-card">
                            <div class="import-card-head">
                                <div class="head-icon">
                                    <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="9" y1="15" x2="15" y2="15"/><line x1="9" y1="11" x2="15" y2="11"/></svg>
                                </div>
                                <div>
                                    <h2>Xem trước dữ liệu đề xuất nhập</h2>
                                    <p>Kiểm tra các dòng dưới đây, bỏ tick những dòng không muốn lưu, sau đó chọn Lưu nháp hoặc Gửi duyệt.</p>
                                </div>
                            </div>

                            <div class="import-card-body">
                                <div class="form-section">
                                    <div class="form-section-title">Thông tin chung</div>
                                    <div class="form-grid">
                                        <div>
                                            <span class="field-label">Kho nhập</span>
                                            <div class="field-value">
                                                <c:set var="whId" value="${currentWarehouseId}"/>
                                                <c:set var="whName" value=""/>
                                                <c:forEach var="w" items="${warehouses}">
                                                    <c:if test="${w.warehouseId == whId}">
                                                        <c:set var="whName" value="${w.name}"/>
                                                    </c:if>
                                                </c:forEach>
                                                <c:choose>
                                                    <c:when test="${not empty whName}"><c:out value="${whName}"/></c:when>
                                                    <c:otherwise>#${whId}</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div>
                                            <span class="field-label">Ghi chú</span>
                                            <div class="field-value"><c:out value="${empty currentNote ? '(không có)' : currentNote}"/></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="summary-row">
                                    <span class="summary-pill ok">
                                        <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" fill="none" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                        <span class="pill-num"><c:out value="${fn:length(validRows)}"/></span> dòng hợp lệ
                                    </span>
                                    <c:if test="${not empty warningRows}">
                                        <span class="summary-pill" style="background: #fef3c7; color: #b45309; border-color: color-mix(in srgb, #f59e0b 30%, transparent);">
                                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" fill="none" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                            <span class="pill-num"><c:out value="${fn:length(warningRows)}"/></span> máy chưa có trong kho (cần báo cáo Manager)
                                        </span>
                                    </c:if>
                                    <c:if test="${not empty invalidRows}">
                                        <span class="summary-pill err">
                                            <svg viewBox="0 0 24 24" width="14" height="14" stroke="currentColor" fill="none" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                            <span class="pill-num"><c:out value="${fn:length(invalidRows)}"/></span> dòng lỗi (sẽ bị bỏ qua)
                                        </span>
                                    </c:if>
                                </div>

                                <form id="confirmForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=importConfirm">
                                    <input type="hidden" name="warehouseId" value="<c:out value='${currentWarehouseId}'/>"/>
                                    <input type="hidden" name="note" value="<c:out value='${currentNote}'/>"/>
                                    <input type="hidden" name="submitType" id="submitType" value="pending"/>

                                    <c:if test="${not empty validRows}">
                                        <h3 style="font-size:13.5px; font-weight:700; color:var(--fg); margin:0 0 10px;">Dòng hợp lệ — bỏ tick để bỏ qua</h3>
                                        <table class="preview-table">
                                            <thead>
                                                <tr>
                                                    <th class="col-check">Chọn</th>
                                                    <th class="col-stt">STT</th>
                                                    <th>Mã máy phát</th>
                                                    <th>Tên máy (tham khảo)</th>
                                                    <th class="col-qty">Số lượng</th>
                                                    <th>Ghi chú dòng</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="row" items="${validRows}">
                                                    <tr>
                                                        <td class="col-check">
                                                            <input type="checkbox" class="row-check" checked
                                                                   data-id="${row['__generatorId']}"
                                                                   data-qty="${row['__quantity']}"
                                                                   data-note="${row['__lineNote']}"/>
                                                        </td>
                                                        <td class="col-stt"><c:out value="${row['stt']}"/></td>
                                                        <td class="model-cell"><c:out value="${row['__resolvedModel']}"/></td>
                                                        <td class="name-cell"><c:out value="${row['__generatorName']}"/></td>
                                                        <td>
                                                            <input type="number" class="row-qty" min="1" max="9999" value="${row['__quantity']}" disabled/>
                                                        </td>
                                                        <td>
                                                            <input type="text" class="row-note" value="${row['__lineNote']}" disabled/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:if>

                                    <c:if test="${empty validRows and empty warningRows}">
                                        <div class="empty-state">Không có dòng hợp lệ nào để lưu. Vui lòng quay lại và chỉnh sửa file Excel.</div>
                                    </c:if>

                                    <c:if test="${not empty warningRows}">
                                        <h3 style="font-size:13.5px; font-weight:700; color:#b45309; margin:24px 0 10px;">Máy chưa có trong kho — cần Manager duyệt</h3>
                                        <table class="preview-table">
                                            <thead>
                                                <tr>
                                                    <th class="col-check">Chọn</th>
                                                    <th class="col-stt">STT</th>
                                                    <th>Mã máy phát</th>
                                                    <th>Tên máy (tham khảo)</th>
                                                    <th class="col-qty">Số lượng</th>
                                                    <th>Ghi chú dòng</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="row" items="${warningRows}">
                                                    <tr class="row-warning">
                                                        <td class="col-check">
                                                            <input type="checkbox" class="row-check" checked
                                                                   data-id="${row['__generatorId']}"
                                                                   data-qty="${row['__quantity']}"
                                                                   data-note="${row['__lineNote']}"/>
                                                        </td>
                                                        <td class="col-stt"><c:out value="${row['stt']}"/></td>
                                                        <td class="model-cell"><c:out value="${row['__resolvedModel']}"/></td>
                                                        <td class="name-cell"><c:out value="${row['__generatorName']}"/></td>
                                                        <td>
                                                            <input type="number" class="row-qty" min="1" max="9999" value="${row['__quantity']}" disabled/>
                                                        </td>
                                                        <td>
                                                            <input type="text" class="row-note" value="${row['__lineNote']}" disabled/>
                                                            <div class="warning-msg"><c:out value="${row['_warnings']}"/></div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:if>

                                    <c:if test="${not empty invalidRows}">
                                        <h3 style="font-size:13.5px; font-weight:700; color:var(--danger); margin:24px 0 10px;">Dòng lỗi — sẽ tự động bị bỏ qua</h3>
                                        <table class="preview-table">
                                            <thead>
                                                <tr>
                                                    <th class="col-check">—</th>
                                                    <th class="col-stt">STT</th>
                                                    <th>Mã máy phát</th>
                                                    <th>Số lượng</th>
                                                    <th>Ghi chú dòng</th>
                                                    <th>Lỗi</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="row" items="${invalidRows}">
                                                    <tr class="row-invalid">
                                                        <td class="col-check">—</td>
                                                        <td class="col-stt"><c:out value="${row['stt']}"/></td>
                                                        <td class="model-cell"><c:out value="${row['Mã máy phát']}"/></td>
                                                        <td><c:out value="${row['Số lượng']}"/></td>
                                                        <td><c:out value="${row['__lineNote']}"/></td>
                                                        <td><div class="error-msg"><c:out value="${row['_errors']}"/></div></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:if>

                                    <div class="import-actions">
                                        <a class="btn" href="${pageContext.request.contextPath}/proposal?action=create">
                                            <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                            Hủy
                                        </a>
                                        <button type="button" class="btn btn-warning" id="btnDraft" ${(empty validRows and empty warningRows) ? 'disabled' : ''}>
                                            <svg viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                            Lưu nháp
                                        </button>
                                        <c:if test="${not empty warningRows}">
                                            <button type="button" class="btn" id="btnReport" style="background: #f59e0b; color: #fff; border-color: #f59e0b;">
                                                <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                                Báo cáo Manager
                                            </button>
                                        </c:if>
                                        <button type="button" class="btn btn-primary" id="btnPending" ${(empty validRows or not empty warningRows) ? 'disabled' : ''}>
                                            <svg viewBox="0 0 24 24"><path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4 20-7z"/></svg>
                                            Gửi duyệt
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            (function () {
                var form = document.getElementById('confirmForm');
                var submitTypeInput = document.getElementById('submitType');
                var btnDraft = document.getElementById('btnDraft');
                var btnPending = document.getElementById('btnPending');
                var btnReport = document.getElementById('btnReport');
                var checks = document.querySelectorAll('.row-check');

                function syncQtyAndNote() {
                    checks.forEach(function (cb) {
                        var tr = cb.closest('tr');
                        var qty = tr.querySelector('.row-qty');
                        var note = tr.querySelector('.row-note');
                        if (cb.checked) {
                            qty.disabled = false;
                            qty.name = 'quantity';
                            note.disabled = false;
                            note.name = 'detailNote';
                        } else {
                            qty.disabled = true;
                            qty.removeAttribute('name');
                            note.disabled = true;
                            note.removeAttribute('name');
                        }
                    });
                }

                function ensureAtLeastOne() {
                    var any = false;
                    checks.forEach(function (cb) { if (cb.checked) { any = true; } });
                    if (!any && typeof showToast === 'function') {
                        showToast('Bạn cần chọn ít nhất 1 dòng để lưu', 'danger');
                    }
                    return any;
                }

                function buildHiddenIds() {
                    document.querySelectorAll('input[name="generatorId"]').forEach(function (e) { e.remove(); });
                    checks.forEach(function (cb) {
                        if (cb.checked) {
                            var input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'generatorId';
                            input.value = cb.getAttribute('data-id');
                            form.appendChild(input);
                        }
                    });
                }

                checks.forEach(function (cb) {
                    cb.addEventListener('change', syncQtyAndNote);
                });
                syncQtyAndNote();

                function submit(submitValue) {
                    if (!ensureAtLeastOne()) { return; }
                    buildHiddenIds();
                    submitTypeInput.value = submitValue;
                    form.submit();
                }

                if (btnDraft) {
                    btnDraft.addEventListener('click', function () { submit('draft'); });
                }
                if (btnPending) {
                    btnPending.addEventListener('click', function () { submit('pending'); });
                }
                if (btnReport) {
                    btnReport.addEventListener('click', function () { submit('report'); });
                }
            })();
        </script>
    </body>
</html>
