<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tạo đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            a.btn { text-decoration: none; }
            .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 13px; margin-bottom: 14px; }
            .back-link:hover { color: var(--accent); }
            .back-link svg { width: 14px; height: 14px; stroke: currentColor; fill: none; stroke-width: 1.8; }

            /* ============== Layout tổng thể ============== */
            .import-wrap {
                max-width: 880px;
                margin: 0 auto;
                padding: 12px 4px 40px;
            }

            /* ============== Card chức năng ============== */
            .import-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                box-shadow: 0 1px 2px rgba(0,0,0,0.03);
            }

            .import-card-head {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 18px 24px;
                border-bottom: 1px solid var(--border);
            }
            .import-card-head .head-icon {
                width: 36px;
                height: 36px;
                border-radius: 8px;
                background: var(--accent-soft);
                color: var(--accent);
                display: grid;
                place-items: center;
                flex-shrink: 0;
            }
            .import-card-head .head-icon svg {
                width: 18px;
                height: 18px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .import-card-head .head-text h2 {
                margin: 0;
                font-size: 17px;
                font-weight: 700;
                color: var(--fg);
            }
            .import-card-head .head-text p {
                margin: 2px 0 0;
                font-size: 12.5px;
                color: var(--muted);
                line-height: 1.4;
            }

            .import-card-body {
                padding: 32px 24px 28px;
            }

            /* ============== Form thông tin chung (kho + ghi chú) ============== */
            .form-section {
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                padding: 18px 20px;
                margin-bottom: 20px;
            }
            .form-section-title {
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.06em;
                color: var(--muted);
                margin: 0 0 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .form-section-title svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
                color: var(--accent);
            }
            .form-grid { display: grid; grid-template-columns: 1fr; gap: 14px; }
            .field { display: flex; flex-direction: column; gap: 6px; }
            .field-label { font-size: 12px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
            .input { padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13.5px; font-family: inherit; box-sizing: border-box; width: 100%; }
            .input:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
            textarea.input { min-height: 70px; resize: vertical; }
            .req { color: #dc3545; }

            /* ============== Drag & Drop Zone ============== */
            .dropzone {
                position: relative;
                border: 2px dashed var(--border);
                border-radius: var(--radius);
                background: var(--surface-2);
                padding: 48px 24px 36px;
                text-align: center;
                transition: all 0.18s ease;
                cursor: pointer;
            }
            .dropzone:hover {
                border-color: var(--accent);
                background: var(--accent-soft);
            }
            .dropzone.drag-over {
                border-color: var(--accent);
                background: var(--accent-soft);
                transform: scale(1.005);
            }
            .dropzone.has-file {
                border-style: solid;
                border-color: var(--accent);
                background: var(--accent-soft);
            }
            .dropzone .dz-icon {
                width: 72px;
                height: 72px;
                margin: 0 auto 18px;
                border-radius: 50%;
                background: var(--surface);
                color: var(--accent);
                display: grid;
                place-items: center;
                border: 1px solid var(--border);
                transition: transform 0.18s ease;
            }
            .dropzone.drag-over .dz-icon { transform: translateY(-4px); }
            .dropzone .dz-icon svg {
                width: 32px;
                height: 32px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.6;
            }
            .dropzone .dz-title {
                font-size: 15px;
                font-weight: 600;
                color: var(--fg);
                margin: 0 0 4px;
            }
            .dropzone .dz-title strong {
                color: var(--accent);
                font-weight: 700;
            }
            .dropzone .dz-sub {
                font-size: 12.5px;
                color: var(--muted);
                margin: 0 0 18px;
            }
            .dropzone .dz-hints {
                display: inline-flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 6px 16px;
                font-size: 11.5px;
                color: var(--muted);
            }
            .dropzone .dz-hints span {
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }
            .dropzone .dz-hints svg {
                width: 12px;
                height: 12px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
            }
            .dropzone input[type="file"] {
                position: absolute;
                inset: 0;
                opacity: 0;
                cursor: pointer;
            }

            /* File đã chọn */
            .file-info {
                display: none;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                background: var(--surface);
                border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
                border-radius: var(--radius-sm);
                margin-top: 18px;
                text-align: left;
            }
            .file-info.show { display: flex; }
            .file-info .fi-icon {
                width: 38px;
                height: 38px;
                border-radius: 8px;
                background: var(--accent-soft);
                color: var(--accent);
                display: grid;
                place-items: center;
                flex-shrink: 0;
            }
            .file-info .fi-icon svg {
                width: 18px;
                height: 18px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .file-info .fi-body { flex: 1; min-width: 0; }
            .file-info .fi-name {
                font-size: 13.5px;
                font-weight: 600;
                color: var(--fg);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .file-info .fi-meta {
                font-size: 11.5px;
                color: var(--muted);
                margin-top: 2px;
            }
            .file-info .fi-remove {
                background: none;
                border: none;
                color: var(--danger);
                cursor: pointer;
                padding: 6px;
                border-radius: var(--radius-sm);
            }
            .file-info .fi-remove:hover { background: var(--danger-soft); }
            .file-info .fi-remove svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
            }

            /* ============== Action buttons ============== */
            .import-actions {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 22px;
                flex-wrap: wrap;
            }
            .import-actions .btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                font-size: 13.5px;
                font-weight: 600;
            }
            .import-actions .btn svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.8;
            }
            .btn-primary {
                background: var(--accent);
                color: #fff;
                border: 1px solid var(--accent);
            }
            .btn-primary:hover { filter: brightness(1.05); }

            /* ============== Notice Box ============== */
            .import-notice {
                background: var(--info-soft);
                border: 1px solid color-mix(in srgb, var(--info) 25%, transparent);
                border-radius: var(--radius);
                padding: 18px 22px;
                margin-top: 24px;
                display: flex;
                gap: 14px;
                align-items: flex-start;
            }
            .import-notice .ni-icon {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                background: var(--info);
                color: #fff;
                display: grid;
                place-items: center;
                flex-shrink: 0;
            }
            .import-notice .ni-icon svg {
                width: 14px;
                height: 14px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2.2;
            }
            .import-notice .ni-body { flex: 1; min-width: 0; }
            .import-notice .ni-title {
                font-size: 13.5px;
                font-weight: 700;
                color: var(--fg);
                margin: 0 0 8px;
                text-transform: uppercase;
                letter-spacing: 0.04em;
            }
            .import-notice ul {
                margin: 0;
                padding-left: 18px;
                color: var(--fg-soft);
                font-size: 12.5px;
                line-height: 1.7;
            }
            .import-notice ul li { margin-bottom: 2px; }
            .import-notice ul li::marker { color: var(--info); }

            /* ============== Alert ============== */
            .alert {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 14px;
                border-radius: var(--radius);
                margin-bottom: 14px;
                font-size: 13px;
                font-weight: 600;
            }
            .alert svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                flex-shrink: 0;
            }
            .alert-error {
                background: var(--danger-soft);
                color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent);
            }
            .alert-success {
                background: var(--accent-soft);
                color: var(--accent);
                border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent);
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Tạo đề xuất</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / Tạo mới</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : 'alert-success'}">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
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
                                <div class="head-text">
                                    <h2>Nhập dữ liệu đề xuất</h2>
                                    <p>Tạo nhanh phiếu đề xuất nhập kho bằng cách tải lên tệp Excel theo mẫu.</p>
                                </div>
                            </div>

                            <div class="import-card-body">
                                <form id="importForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=importExcel" enctype="multipart/form-data">
                                    <%-- Thông tin chung: kho + ghi chú --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <svg viewBox="0 0 24 24"><path d="M3 7h18M3 12h18M3 17h18"/></svg>
                                            Thông tin chung
                                        </div>
                                        <div class="form-grid">
                                            <div class="field">
                                                <label class="field-label">Kho nhập <span class="req">*</span></label>
                                                <select class="input" name="warehouseId" required>
                                                    <option value="">-- Chọn kho --</option>
                                                    <c:forEach var="w" items="${warehouses}">
                                                        <option value="${w.warehouseId}"><c:out value="${w.name}"/></option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="field">
                                                <label class="field-label">Ghi chú</label>
                                                <textarea class="input" name="note" rows="2" placeholder="VD: Đề xuất nhập máy phát 100kW cho kho HCM..."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- Drop zone --%>
                                    <div class="dropzone" id="dropzone">
                                        <input type="file" name="excelFile" id="excelFile" accept=".xlsx,.xls" />

                                        <div class="dz-icon">
                                            <svg viewBox="0 0 24 24">
                                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                                <polyline points="17 8 12 3 7 8"/>
                                                <line x1="12" y1="3" x2="12" y2="15"/>
                                            </svg>
                                        </div>

                                        <p class="dz-title">
                                            Kéo thả file Excel vào đây hoặc <strong>chọn file từ máy tính</strong>
                                        </p>
                                        <p class="dz-sub">Tệp Excel chứa danh sách máy phát điện cần đề xuất nhập kho</p>

                                        <div class="dz-hints">
                                            <span>
                                                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                                Định dạng: .xlsx, .xls
                                            </span>
                                            <span>
                                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                Dung lượng tối đa: 10MB
                                            </span>
                                            <span>
                                                <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                                Trạng thái: Sẵn sàng nhận file
                                            </span>
                                        </div>
                                    </div>

                                    <%-- File đã chọn --%>
                                    <div class="file-info" id="fileInfo">
                                        <div class="fi-icon">
                                            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                        </div>
                                        <div class="fi-body">
                                            <div class="fi-name" id="fileName">filename.xlsx</div>
                                            <div class="fi-meta" id="fileMeta">0 KB · Sẵn sàng tải lên</div>
                                        </div>
                                        <button type="button" class="fi-remove" id="fileRemove" title="Bỏ chọn file">
                                            <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                        </button>
                                    </div>

                                    <%-- Action buttons --%>
                                    <div class="import-actions">
                                        <button type="button" class="btn btn-primary" id="btnChooseFile">
                                            <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                            Chọn file Excel
                                        </button>
                                        <a class="btn" href="${pageContext.request.contextPath}/proposal?action=downloadTemplate" id="btnDownloadTemplate">
                                            <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                            Tải biểu mẫu
                                        </a>
                                    </div>
                                </form>

                                <%-- Notice box --%>
                                <div class="import-notice">
                                    <div class="ni-icon">
                                        <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                    </div>
                                    <div class="ni-body">
                                        <p class="ni-title">Lưu ý quan trọng</p>
                                        <ul>
                                            <li>File Excel phải theo đúng biểu mẫu được cung cấp, không thay đổi cấu trúc cột.</li>
                                            <li>Mã máy phát (ID) phải tồn tại trong hệ thống, nếu không dòng đó sẽ bị bỏ qua.</li>
                                            <li>Số lượng phải là số nguyên dương, không vượt quá 9.999.</li>
                                            <li>Sau khi tải lên, đề xuất sẽ ở trạng thái <strong>Chờ duyệt</strong> và cần quản lý phê duyệt.</li>
                                            <li>Bạn có thể tải biểu mẫu để xem đúng cấu trúc cột cần điền.</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
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
            (function () {
                var dropzone = document.getElementById('dropzone');
                var fileInput = document.getElementById('excelFile');
                var fileInfo = document.getElementById('fileInfo');
                var fileName = document.getElementById('fileName');
                var fileMeta = document.getElementById('fileMeta');
                var fileRemove = document.getElementById('fileRemove');
                var btnChoose = document.getElementById('btnChooseFile');

                function formatSize(bytes) {
                    if (bytes < 1024) return bytes + ' B';
                    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
                    return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
                }

                function showFile(file) {
                    if (!file) return;
                    var validExt = /\.xlsx?$/i.test(file.name);
                    if (!validExt) {
                        if (typeof showToast === 'function') {
                            showToast('Chỉ chấp nhận file Excel (.xlsx, .xls)', 'danger');
                        } else {
                            alert('Chỉ chấp nhận file Excel (.xlsx, .xls)');
                        }
                        return;
                    }
                    if (file.size > 10 * 1024 * 1024) {
                        if (typeof showToast === 'function') {
                            showToast('File vượt quá dung lượng tối đa 10MB', 'danger');
                        } else {
                            alert('File vượt quá dung lượng tối đa 10MB');
                        }
                        return;
                    }
                    fileName.textContent = file.name;
                    fileMeta.textContent = formatSize(file.size) + ' · Sẵn sàng tải lên';
                    fileInfo.classList.add('show');
                    dropzone.classList.add('has-file');
                }

                function clearFile() {
                    fileInput.value = '';
                    fileInfo.classList.remove('show');
                    dropzone.classList.remove('has-file');
                }

                fileInput.addEventListener('change', function () {
                    if (fileInput.files && fileInput.files[0]) {
                        showFile(fileInput.files[0]);
                    }
                });

                btnChoose.addEventListener('click', function () {
                    fileInput.click();
                });

                fileRemove.addEventListener('click', function (e) {
                    e.stopPropagation();
                    clearFile();
                });

                ['dragenter', 'dragover'].forEach(function (ev) {
                    dropzone.addEventListener(ev, function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        dropzone.classList.add('drag-over');
                    });
                });

                ['dragleave', 'drop'].forEach(function (ev) {
                    dropzone.addEventListener(ev, function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        dropzone.classList.remove('drag-over');
                    });
                });

                dropzone.addEventListener('drop', function (e) {
                    var dt = e.dataTransfer;
                    if (dt && dt.files && dt.files[0]) {
                        fileInput.files = dt.files;
                        showFile(dt.files[0]);
                    }
                });
            })();
        </script>
    </body>
</html>
