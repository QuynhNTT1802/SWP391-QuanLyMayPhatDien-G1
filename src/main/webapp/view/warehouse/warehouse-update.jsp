<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa kho — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert-error { background: var(--danger-soft); color: var(--danger);
            border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
        .alert-success { background: var(--accent-soft); color: var(--accent);
            border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); }
        .req { color: var(--danger); font-weight: 700; }
        .form-field label .req { color: var(--danger); font-weight: 700; }

        .confirm-summary {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 14px 16px;
            background: var(--surface-2);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            margin: 6px 0 4px;
        }
        .confirm-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
        .confirm-row span { color: var(--muted); font-weight: 500; }
        .confirm-row strong { color: var(--fg); font-weight: 600; text-align: right; word-break: break-word; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chỉnh sửa kho</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse?action=list">Kho hàng</a> / <a href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}"><c:out value="${warehouse.name}"/></a> / Chỉnh sửa</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
            </div>
        </header>

        <main>
            <a class="receipt-back-link" href="javascript:void(0)" onclick="confirmCancelUpdate()">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Huỷ và quay lại chi tiết
            </a>


            <c:if test="${not empty error}">
                <div class="alert alert-error" style="margin: 16px 0;">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <div class="alert-title">Lỗi</div>
                        <c:out value="${error}"/>
                    </div>
                </div>
            </c:if>

            <form id="warehouseForm" method="POST" action="${pageContext.request.contextPath}/warehouse?action=update">
                <input type="hidden" name="id" value="${warehouse.warehouseId}" />

                <div class="content">
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <h3 class="section-title">Tên, địa chỉ và mô tả</h3>
                            </div>
                        </div>
                        <div class="form-grid">
                            <div class="form-field full">
                                <label>Tên kho <span class="req">*</span></label>
                                <input name="name" value="<c:out value='${warehouse.name}'/>" required />
                            </div>
                            <div class="form-field full">
                                <label>Địa chỉ</label>
                                <textarea name="address" rows="3"><c:out value="${warehouse.address}"/></textarea>
                            </div>
                            <div class="form-field full">
                                <label>Mô tả</label>
                                <textarea name="description" rows="4" placeholder="Mô tả về kho..."><c:out value="${warehouse.description}"/></textarea>
                            </div>
                        </div>
                    </section>
                </div>
            </form>

            <div class="bottom-actions">
                <a class="btn" href="javascript:void(0)" onclick="confirmCancelUpdate()">Huỷ</a>
                <button type="submit" form="warehouseForm" class="btn btn-primary" onclick="return openSaveConfirm()">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                    Lưu thay đổi
                </button>
            </div>

            <div class="modal-host" id="saveConfirmModal" onclick="if (event.target === this) closeSaveConfirm();">
                <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="saveConfirmTitle">
                    <h3 id="saveConfirmTitle">Xác nhận lưu thay đổi</h3>
                    <p class="modal-sub">Vui lòng kiểm tra thông tin trước khi lưu chỉnh sửa.</p>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeSaveConfirm()">Hủy</button>
                        <button type="button" class="btn btn-primary" onclick="doConfirmSave()">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 2 11 13"/><path d="M22 2 15 22 11 13 2 9 22 2z"/></svg>
                            Xác nhận lưu
                        </button>
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
    function confirmCancelUpdate() {
        if (confirm('Bạn có chắc muốn huỷ chỉnh sửa kho này?')) {
            location.href = window.APP_CTX + '/warehouse?action=view&id=${warehouse.warehouseId}';
        }
    }

    function openSaveConfirm() {
        populateSaveSummary();
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.add('show');
        return false;
    }

    function closeSaveConfirm() {
        var modal = document.getElementById('saveConfirmModal');
        if (modal) modal.classList.remove('show');
    }

    function doConfirmSave() {
        closeSaveConfirm();
        var form = document.getElementById('warehouseForm');
        if (form) form.submit();
    }

    function populateSaveSummary() {
        var nameEl = document.getElementById('saveSummaryName');
        var addrEl = document.getElementById('saveSummaryAddress');
        var descEl = document.getElementById('saveSummaryDescription');
        var nameInput = document.querySelector('input[name="name"]');
        var addrInput = document.querySelector('textarea[name="address"]');
        var descInput = document.querySelector('textarea[name="description"]');
        if (nameEl && nameInput) {
            nameEl.textContent = nameInput.value.trim() || '—';
        }
        if (addrEl && addrInput) {
            var addrVal = addrInput.value.trim();
            addrEl.textContent = addrVal ? addrVal : '(trống)';
        }
        if (descEl && descInput) {
            var descVal = descInput.value.trim();
            if (descVal) {
                var trimmed = descVal.length > 80 ? descVal.substring(0, 80) + '…' : descVal;
                descEl.textContent = trimmed;
            } else {
                descEl.textContent = '(trống)';
            }
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeSaveConfirm();
    });

    document.addEventListener('DOMContentLoaded', function () {
        if (window.SESSION_DATA && window.SESSION_DATA.message && typeof showToast === 'function') {
            showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
        }
    });
</script>
</body>
</html>
