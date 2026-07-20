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
    <style>
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 14px; }
        .form-field { display: flex; flex-direction: column; gap: 6px; }
        .form-field.full { grid-column: 1 / -1; }
        .form-field label { font-size: 11px; color: var(--muted); font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; }
        .form-field input, .form-field select, .form-field textarea {
            width: 100%; padding: 9px 12px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); box-sizing: border-box;
        }
        .form-field input:focus, .form-field select:focus, .form-field textarea:focus {
            outline: none; border-color: var(--accent);
            box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent);
        }
        .form-field textarea { min-height: 70px; resize: vertical; font-family: var(--font-ui); }
        .alert { display: flex; align-items: flex-start; gap: 10px; padding: 12px 14px;
            border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; }
        .alert svg { width: 16px; height: 16px; stroke: currentColor; fill: none;
            stroke-width: 2; flex-shrink: 0; margin-top: 1px; }
        .alert .alert-body { flex: 1; line-height: 1.5; }
        .alert .alert-title { font-weight: 700; margin-bottom: 4px; }
        .alert-error { background: var(--danger-soft); color: var(--danger);
            border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); }
        a.btn { text-decoration: none; }
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
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại chi tiết kho
            </a>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                    <div class="alert-body">
                        <div class="alert-title">Lỗi</div>
                        <c:out value="${error}"/>
                    </div>
                </div>
            </c:if>

            <div class="section" style="padding: 22px;">
                <h3 style="margin:0 0 18px;font-size:15px;font-weight:700;">Thông tin kho</h3>
                <form method="POST" action="${pageContext.request.contextPath}/warehouse?action=update">
                    <input type="hidden" name="id" value="${warehouse.warehouseId}" />

                    <div class="form-grid">
                        <div class="form-field full">
                            <label>Tên kho <span style="color:var(--danger);">*</span></label>
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

                    <div style="display:flex;gap:8px;margin-top:20px;">
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse?action=view&id=${warehouse.warehouseId}">Hủy</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
