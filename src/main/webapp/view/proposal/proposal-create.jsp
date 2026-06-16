<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tạo đề xuất nhập kho - Warehouse OS</title>
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
            main{padding:24px 32px 60px;max-width:880px;margin:0 auto}
            .page-head{margin-bottom:20px}
            .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
            .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
            .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
            .page-head .lede{color:var(--muted);margin-top:6px;max-width:640px;font-size:14px}
            .section{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;margin-bottom:16px}
            .section-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 20px;border-bottom:1px solid var(--border)}
            .section-head h3{font-size:14px;font-weight:700;margin:0}
            .section-head .sub{font-size:11.5px;color:var(--muted);font-family:var(--font-mono)}
            .section-body{padding:22px 20px}
            .field-grid{display:grid;grid-template-columns:1fr 1fr;gap:18px 20px}
            .field{display:flex;flex-direction:column;gap:6px;min-width:0}
            .field.full{grid-column:1/-1}
            .field-label{font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.04em;display:flex;align-items:center;justify-content:space-between}
            .field-label .req{color:var(--danger);margin-inline-start:2px}
            .input,.select{font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;line-height:1.4;box-sizing:border-box}
            .input:focus,.select:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .select{appearance:none;background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");background-repeat:no-repeat;background-position:right 10px center;background-size:14px;padding-inline-end:32px;cursor:pointer}
            textarea.input{min-height:80px;resize:vertical}
            .dropzone{position:relative;border:2px dashed var(--border);border-radius:var(--radius);background:var(--surface-2);padding:48px 24px 36px;text-align:center;transition:all .18s ease;cursor:pointer;margin-bottom:14px}
            .dropzone:hover{border-color:var(--accent);background:var(--accent-soft)}
            .dropzone.drag-over,.dropzone.has-file{border-color:var(--accent);background:var(--accent-soft)}
            .dropzone input[type=file]{position:absolute;inset:0;opacity:0;cursor:pointer}
            .dz-icon{width:64px;height:64px;margin:0 auto 14px;border-radius:50%;background:var(--surface);color:var(--accent);display:grid;place-items:center;border:1px solid var(--border)}
            .dz-icon svg{width:28px;height:28px;stroke:currentColor;fill:none;stroke-width:1.6}
            .dz-title{font-size:15px;font-weight:600;color:var(--fg);margin:0 0 4px}
            .dz-title strong{color:var(--accent);font-weight:700}
            .dz-sub{font-size:12.5px;color:var(--muted);margin:0}
            .file-info{display:none;align-items:center;gap:12px;padding:12px 16px;background:var(--surface);border:1px solid color-mix(in srgb,var(--accent) 30%,transparent);border-radius:var(--radius-sm);margin-bottom:14px;text-align:left}
            .file-info.show{display:flex}
            .file-info .fi-icon{width:36px;height:36px;border-radius:8px;background:var(--accent-soft);color:var(--accent);display:grid;place-items:center;flex-shrink:0}
            .file-info .fi-icon svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:1.8}
            .file-info .fi-body{flex:1;min-width:0}
            .file-info .fi-name{font-size:13.5px;font-weight:600;color:var(--fg);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
            .file-info .fi-meta{font-size:11.5px;color:var(--muted);margin-top:2px}
            .file-info .fi-remove{background:0 0;border:0;color:var(--danger);cursor:pointer;padding:6px;border-radius:var(--radius-sm)}
            .file-info .fi-remove:hover{background:var(--danger-soft)}
            .file-info .fi-remove svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2}
            .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
            .btn:hover{background:var(--surface-2)}
            .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
            .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
            .btn:disabled{opacity:.4;cursor:not-allowed}
            .actions{display:flex;gap:10px;justify-content:flex-end;margin-top:20px;flex-wrap:wrap}
            .notice{padding:14px 18px;border-radius:var(--radius-sm);margin-top:16px;font-size:13px;font-weight:500;background:var(--info-soft);color:var(--info);border:1px solid color-mix(in srgb,var(--info) 25%,transparent);line-height:1.7}
            .notice ul{margin:6px 0 0;padding-left:18px}
            .notice ul li{margin-bottom:2px}
            .topbar{position:sticky;top:0;z-index:10;background:color-mix(in srgb,var(--bg) 85%,transparent);backdrop-filter:blur(8px);border-bottom:1px solid var(--border);display:flex;align-items:center;gap:16px;padding:12px 24px}
            .topbar h1{font-size:16px;font-weight:700;margin:0;letter-spacing:-0.01em}
            .crumb{color:var(--muted);font-size:13px;font-weight:500}
            .top-actions{margin-inline-start:auto;display:flex;align-items:center;gap:8px}
            .icon-btn{width:32px;height:32px;border:1px solid var(--border);background:var(--surface);color:var(--fg-soft);border-radius:var(--radius-sm);display:grid;place-items:center;cursor:pointer}
            .icon-btn:hover{background:var(--surface-2);color:var(--fg)}
            .icon-btn svg{width:15px;height:15px;stroke:currentColor;fill:none;stroke-width:1.6}
            .alert{padding:12px 16px;border-radius:var(--radius-sm);margin-bottom:16px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;border:1px solid}
            .alert svg{width:18px;height:18px;stroke:currentColor;fill:none;stroke-width:2;flex-shrink:0}
            .alert-error{background:var(--danger-soft);color:var(--danger);border-color:color-mix(in srgb,var(--danger) 30%,transparent)}
            .back-link{display:inline-flex;align-items:center;gap:6px;color:var(--muted);text-decoration:none;font-size:13px;font-weight:600;margin-bottom:14px}
            .back-link:hover{color:var(--fg)}
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
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal">Quay lại danh sách</a>
                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>
                    <c:if test="${quarterBlocked}">
                        <div class="alert alert-error" style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 14px 18px; border-radius: 6px; margin-bottom: 16px; display: flex; align-items: center; gap: 10px;">
                            <svg viewBox="0 0 24 24" style="width:20px;height:20px;flex-shrink:0;stroke:currentColor;fill:none;stroke-width:2;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div>
                                <strong>Quý ${blockedPeriod}</strong> tại kho này đã bị CEO từ chối PO.
                                Không thể tạo đề xuất mới cho quý này.
                            </div>
                        </div>
                    </c:if>
                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Tạo mới</div>
                        <h1 class="title">Tải lên file Excel để tạo phiếu</h1>
                        <div class="lede">Chọn kho nhập, ghi chú và file Excel theo biểu mẫu. Hệ thống sẽ tách dòng hợp lệ, dòng máy mới và dòng lỗi để bạn xem trước.</div>
                    </div>
                    <form id="importForm" method="POST" action="${pageContext.request.contextPath}/proposal?action=importExcel" enctype="multipart/form-data">
                        <div class="section">
                            <div class="section-head">
                                <h3>Thông tin chung</h3>
                                <span class="sub">Bước 1</span>
                            </div>
                            <div class="section-body">
                                <div class="field-grid">
                                    <div class="field">
                                        <label class="field-label" for="warehouseId">Kho nhập <span class="req">*</span></label>
                                        <select class="select" id="warehouseId" name="warehouseId" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.warehouseId}"><c:out value="${w.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field full">
                                        <label class="field-label" for="note">Ghi chú</label>
                                        <textarea class="input" id="note" name="note" rows="2" placeholder="VD: Đề xuất nhập máy phát cho kho HCM..."></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="section">
                            <div class="section-head">
                                <h3>File Excel</h3>
                                <span class="sub">Bước 2</span>
                            </div>
                            <div class="section-body">
                                <div class="dropzone" id="dropzone">
                                    <input type="file" name="excelFile" id="excelFile" accept=".xlsx,.xls" />
                                    <div class="dz-icon">
                                        <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                    </div>
                                    <p class="dz-title">Kéo thả file Excel vào đây hoặc <strong>chọn file từ máy tính</strong></p>
                                    <p class="dz-sub">Định dạng .xlsx, .xls - tối đa 10MB</p>
                                </div>
                                <div class="file-info" id="fileInfo">
                                    <div class="fi-icon">
                                        <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                    </div>
                                    <div class="fi-body">
                                        <div class="fi-name" id="fileName">filename.xlsx</div>
                                        <div class="fi-meta" id="fileMeta">0 KB - Sẵn sàng tải lên</div>
                                    </div>
                                    <button type="button" class="fi-remove" id="fileRemove" title="Bỏ chọn file">
                                        <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    </button>
                                </div>
                                <div class="actions">
                                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=downloadTemplate">Tải biểu mẫu</a>
                                    <button type="submit" class="btn btn-primary" id="btnUpload" disabled>Tải lên &amp; Xem trước</button>
                                </div>
                            </div>
                        </div>
                    </form>
                    <div class="notice">
                        <strong>Lưu ý:</strong>
                        <ul>
                            <li>File Excel phải theo đúng biểu mẫu, không thay đổi cấu trúc cột.</li>
                            
                            <li>Số lượng phải là số nguyên dương, không vượt quá 9999</li>
                            <li>Ở bước xem trước, bạn có thể chọn <strong>Lưu nháp</strong> hoặc <strong>Gửi duyệt</strong> tùy nhu cầu.</li>
                        </ul>
                    </div>
                </main>
            </div>
        </div>
        <script>
            (function () {
                var dropzone = document.getElementById('dropzone');
                var fileInput = document.getElementById('excelFile');
                var fileInfo = document.getElementById('fileInfo');
                var fileName = document.getElementById('fileName');
                var fileMeta = document.getElementById('fileMeta');
                var fileRemove = document.getElementById('fileRemove');
                var btnUpload = document.getElementById('btnUpload');
                var warehouseSelect = document.getElementById('warehouseId');

                function refreshUploadBtn() {
                    var hasFile = fileInput.files && fileInput.files.length > 0;
                    var hasWarehouse = warehouseSelect && warehouseSelect.value && warehouseSelect.value !== '';
                    btnUpload.disabled = !(hasFile && hasWarehouse);
                }
                function formatSize(b) {
                    if (b < 1024) return b + ' B';
                    if (b < 1024 * 1024) return (b / 1024).toFixed(1) + ' KB';
                    return (b / 1024 / 1024).toFixed(2) + ' MB';
                }
                function showFile(file) {
                    if (!file) return;
                    if (!/\.xlsx?$/i.test(file.name)) { alert('Chỉ chấp nhận file Excel (.xlsx, .xls)'); return; }
                    if (file.size > 10 * 1024 * 1024) { alert('File vượt quá 10MB'); return; }
                    fileName.textContent = file.name;
                    fileMeta.textContent = formatSize(file.size) + ' - Sẵn sàng tải lên';
                    fileInfo.classList.add('show');
                    dropzone.classList.add('has-file');
                    refreshUploadBtn();
                }
                function clearFile() {
                    fileInput.value = '';
                    fileInfo.classList.remove('show');
                    dropzone.classList.remove('has-file');
                    refreshUploadBtn();
                }
                fileInput.addEventListener('change', function () {
                    if (fileInput.files && fileInput.files[0]) showFile(fileInput.files[0]);
                });
                if (warehouseSelect) warehouseSelect.addEventListener('change', refreshUploadBtn);
                fileRemove.addEventListener('click', clearFile);
                ['dragenter','dragover'].forEach(function (e) {
                    dropzone.addEventListener(e, function (ev) { ev.preventDefault(); ev.stopPropagation(); dropzone.classList.add('drag-over'); });
                });
                ['dragleave','drop'].forEach(function (e) {
                    dropzone.addEventListener(e, function (ev) { ev.preventDefault(); ev.stopPropagation(); dropzone.classList.remove('drag-over'); });
                });
                dropzone.addEventListener('drop', function (e) {
                    if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]) {
                        fileInput.files = e.dataTransfer.files;
                        showFile(e.dataTransfer.files[0]);
                    }
                });
                refreshUploadBtn();
            })();
        </script>
    </body>
</html>