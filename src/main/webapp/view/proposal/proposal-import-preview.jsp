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
            main{padding:24px 32px 60px;max-width:1200px;margin:0 auto}
            .page-head{margin-bottom:20px}
            .eyebrow{display:inline-flex;align-items:center;gap:6px;font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:var(--accent);margin-bottom:8px}
            .eyebrow::before{content:'';width:5px;height:5px;border-radius:50%;background:var(--accent)}
            .page-head h1.title{font-size:26px;font-weight:700;letter-spacing:-0.02em;margin:0}
            .page-head .lede{color:var(--muted);margin-top:6px;max-width:720px;font-size:14px}
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
            table.data-table .row-unitprice{width:140px;padding:6px 8px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box;text-align:right}
            .supplier-cell{font-size:12.5px;font-weight:600;color:var(--fg)}
            .supplier-cell .supplier-phone{display:block;font-size:11px;font-weight:500;color:var(--muted);margin-top:2px}
            .btn{display:inline-flex;align-items:center;gap:6px;border:1px solid var(--border);background:var(--surface);color:var(--fg);padding:8px 16px;border-radius:var(--radius-sm);font-size:13px;font-weight:600;cursor:pointer;font-family:var(--font-ui);text-decoration:none}
            .btn:hover{background:var(--surface-2)}
            .btn-primary{background:var(--fg);color:var(--bg);border-color:var(--fg)}
            .btn-primary:hover{background:var(--fg-soft);border-color:var(--fg-soft)}
            .btn-danger{background:var(--danger);color:#fff;border-color:var(--danger)}
            .btn-danger:hover{opacity:.92}
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

            /* Slide-out panel - sao chép pattern từ liquidation-edit.jsp */
            .side-panel-overlay{position:fixed;inset:0;background:rgba(0,0,0,0.4);opacity:0;visibility:hidden;transition:.2s;z-index:50}
            .side-panel-overlay.show{opacity:1;visibility:visible}
            .side-panel{position:fixed;top:0;right:-540px;width:520px;max-width:100vw;height:100vh;background:var(--bg);border-left:1px solid var(--border);box-shadow:-6px 0 24px rgba(0,0,0,0.08);transition:right .25s ease;z-index:51;display:flex;flex-direction:column}
            .side-panel.show{right:0}
            .side-panel-head{display:flex;align-items:center;justify-content:space-between;padding:18px 22px;border-bottom:1px solid var(--border);background:var(--surface-2)}
            .side-panel-title{font-size:16px;font-weight:700;color:var(--fg);margin:0;letter-spacing:-0.01em}
            .side-panel-close{background:0 0;border:0;color:var(--muted);font-size:24px;cursor:pointer;line-height:1;width:32px;height:32px;border-radius:var(--radius-sm);display:grid;place-items:center}
            .side-panel-close:hover{background:var(--danger-soft);color:var(--danger)}
            .side-panel-body{flex:1;overflow-y:auto;padding:20px 22px}
            .supplier-search-box{width:100%;padding:9px 12px;border:1px solid var(--border);border-radius:var(--radius-sm);background:var(--bg);color:var(--fg);font-size:13px;font-family:inherit;box-sizing:border-box;margin-bottom:16px}
            .supplier-search-box:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px var(--accent-soft)}
            .supplier-list-wrap{display:flex;flex-direction:column;gap:10px}
            .supplier-card{border:1px solid var(--border);border-radius:8px;padding:12px 14px;background:var(--surface);display:flex;align-items:center;gap:10px;cursor:pointer;transition:all .15s ease}
            .supplier-card:hover{border-color:var(--accent);box-shadow:0 4px 12px rgba(13,110,253,0.08);transform:translateY(-1px)}
            .supplier-card-left{flex:1;min-width:0}
            .supplier-card-name{font-size:13.5px;font-weight:700;color:var(--fg);margin-bottom:4px}
            .supplier-card-meta{font-size:11.5px;color:var(--muted);display:flex;flex-wrap:wrap;gap:6px 14px}
            .supplier-card-meta span{display:inline-flex;align-items:center;gap:4px}
            .supplier-card-meta svg{width:11px;height:11px;opacity:0.6}
            .supplier-card-icon{color:var(--accent);opacity:0;transition:.2s;transform:translateX(-8px)}
            .supplier-card:hover .supplier-card-icon{opacity:1;transform:translateX(0)}
            .supplier-card-icon svg{width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:2}
            .empty-msg{text-align:center;color:var(--muted);padding:30px 16px;font-size:13px}
            .loading-msg{text-align:center;color:var(--muted);padding:30px 16px;font-size:13px}
            @keyframes spin { 100% { transform: rotate(360deg); } }
            .spin-svg{animation: spin 1s linear infinite; margin-bottom: 8px;}

            .unresolved-card-row td{background:color-mix(in srgb,var(--warn) 6%,transparent)}
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
                        <div class="lede">Hệ thống đã tách dòng hợp lệ, dòng cảnh báo máy mới, dòng cần chọn nhà cung cấp và dòng lỗi.</div>
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
                        <c:if test="${not empty unresolvedSupplierRows}">
                            <span class="pill bad"><span class="pill-num"><c:out value="${fn:length(unresolvedSupplierRows)}"/></span> chưa chọn được NCC</span>
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
                        <c:if test="${not empty unresolvedSupplierRows}">
                            <div class="alert alert-error" id="unresolvedAlert" style="margin-bottom:12px">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                <span>Có <strong>${fn:length(unresolvedSupplierRows)}</strong> dòng chưa chọn được nhà cung cấp. Bạn cần xử lý từng dòng trong bảng bên dưới trước khi lưu.</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty validRows}">
                            <div class="section" style="padding:0">
                                <div class="section-head" style="padding:14px 18px"><div class="section-head-left"><h3>Dòng hợp lệ</h3><span class="sub">${fn:length(validRows)} dòng</span></div></div>
                                <table class="data-table">
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Tên máy</th><th style="width:200px">Nhà cung cấp</th><th style="width:140px" class="text-right">Đơn giá (VNĐ)</th><th style="width:110px" class="text-right">Số lượng</th><th>Ghi chú dòng</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${validRows}">
                                            <tr data-id="<c:out value='${row.gid}'/>" data-supplier-id="<c:out value='${row.supplierId}'/>">
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['gmodel']}"/></td>
                                                <td class="name-cell"><c:out value="${row['gname']}"/></td>
                                                <td>
                                                    <span class="supplier-cell">
                                                        <c:out value="${row.supplierNameResolved}"/>
                                                        <span class="supplier-phone" data-supplier-display-phone><c:out value="${row.supplierPhone}"/></span>
                                                    </span>
                                                </td>
                                                <td><input type="number" class="row-unitprice" min="0" step="1000" value="<c:out value='${row.gunitPrice}'/>" /></td>
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
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Tên máy</th><th style="width:200px">Nhà cung cấp</th><th style="width:140px" class="text-right">Đơn giá (VNĐ)</th><th style="width:110px" class="text-right">Số lượng</th><th>Ghi chú dòng</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${warningRows}">
                                            <tr data-id="<c:out value='${row.gid}'/>" data-supplier-id="<c:out value='${row.supplierId}'/>">
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['gmodel']}"/></td>
                                                <td class="name-cell"><c:out value="${row['gname']}"/></td>
                                                <td>
                                                    <span class="supplier-cell">
                                                        <c:out value="${row.supplierNameResolved}"/>
                                                        <span class="supplier-phone"><c:out value="${row.supplierPhone}"/></span>
                                                    </span>
                                                </td>
                                                <td><input type="number" class="row-unitprice" min="0" step="1000" value="<c:out value='${row.gunitPrice}'/>" /></td>
                                                <td><input type="number" class="row-qty" min="1" max="9999" value="<c:out value='${row.gqty}'/>" /></td>
                                                <td><input type="text" class="row-note" value="<c:out value='${row.gline}'/>" /></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                        <c:if test="${not empty unresolvedSupplierRows}">
                            <div class="section" style="padding:0">
                                <div class="section-head" style="padding:14px 18px"><div class="section-head-left"><h3>Cần chọn nhà cung cấp</h3><span class="sub">${fn:length(unresolvedSupplierRows)} dòng</span></div></div>
                                <table class="data-table">
                                    <thead><tr><th style="width:50px">#</th><th>Mã máy phát</th><th>Tên máy</th><th>Tên NCC đã gõ</th><th>Lý do</th><th style="width:280px" class="text-right">Hành động</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="row" items="${unresolvedSupplierRows}" varStatus="st">
                                            <tr class="unresolved-card-row" data-row-index="<c:out value='${st.index}'/>" data-gid="<c:out value='${row.gid}'/>" data-gmodel="<c:out value='${row.gmodel}'/>" data-gname="<c:out value='${row.gname}'/>">
                                                <td class="mono"><c:out value="${row['stt']}"/></td>
                                                <td class="model-cell"><c:out value="${row['gmodel']}"/></td>
                                                <td class="name-cell"><c:out value="${row['gname']}"/></td>
                                                <td><c:out value="${row['supplierQuery']}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${row['supplierMultiple'] == 'true'}">
                                                            Có <strong>${row['supplierMultipleCount']}</strong> NCC trùng tên trong hệ thống.
                                                        </c:when>
                                                        <c:otherwise>
                                                            Không tìm thấy NCC trong hệ thống.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align:right">
                                                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=redirectCreateSupplier&amp;supplierQuery=<c:out value='${row.supplierQuery}'/>&amp;returnUrl=${pageContext.request.contextPath}/proposal?action%3DimportConfirm&amp;rowIndex=<c:out value='${st.index}'/>" target="_self">Tạo NCC mới</a>
                                                    <button type="button" class="btn btn-primary" onclick="openSupplierPanel(<c:out value='${st.index}'/>, '<c:out value='${row.supplierQuery}'/>', this.closest('tr'))">Chọn lại từ DS</button>
                                                </td>
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
                            <button type="button" class="btn" id="btnDraft" disabled>Lưu nháp</button>
                            <button type="button" class="btn btn-primary" id="btnPending" disabled>Gửi duyệt</button>
                        </div>
                    </form>
                </main>
            </div>
        </div>

        <!-- Slide-out panel cho chọn lại nhà cung cấp (pattern từ liquidation-edit.jsp) -->
        <div class="side-panel-overlay" id="sidePanelOverlay" onclick="closeSupplierPanel()"></div>
        <div class="side-panel" id="sidePanel">
            <div class="side-panel-head">
                <h3 class="side-panel-title">Chọn nhà cung cấp</h3>
                <button class="side-panel-close" onclick="closeSupplierPanel()" aria-label="Đóng">×</button>
            </div>
            <div class="side-panel-body">
                <div style="display:flex; gap:8px; margin-bottom:16px;">
                    <input type="text" id="supplierSearchInput" class="supplier-search-box" placeholder="Tìm theo tên, SĐT, email..." autocomplete="off" style="margin-bottom:0;"/>
                </div>
                <div id="supplierLoading" class="loading-msg" style="display:none;">
                    <svg class="spin-svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 12a9 9 0 1 1-6.219-8.56"/></svg>
                    <div>Đang tải dữ liệu...</div>
                </div>
                <div class="supplier-list-wrap" id="supplierList"></div>
            </div>
        </div>

        <script>
            (function () {
                var form = document.getElementById('confirmForm');
                var submitTypeInput = document.getElementById('submitType');
                var btnDraft = document.getElementById('btnDraft');
                var btnPending = document.getElementById('btnPending');
                var rows = document.querySelectorAll('tr[data-id]');
                var unresolvedCount = document.querySelectorAll('tr.unresolved-card-row').length;

                function refreshSubmitState() {
                    var disabled = rows.length === 0 || unresolvedCount > 0;
                    if (btnDraft) btnDraft.disabled = disabled;
                    if (btnPending) btnPending.disabled = disabled;
                }
                refreshSubmitState();

                function buildPayload() {
                    form.querySelectorAll('input[name="generatorId"], input[name="quantity"], input[name="detailNote"], input[name="supplierId"], input[name="unitPrice"]').forEach(function (e) { e.remove(); });
                    var count = 0;
                    rows.forEach(function (tr) {
                        var id = tr.getAttribute('data-id');
                        if (!id) return;
                        var supplierId = tr.getAttribute('data-supplier-id');
                        var qty = tr.querySelector('.row-qty');
                        var note = tr.querySelector('.row-note');
                        var unitPriceInput = tr.querySelector('.row-unitprice');
                        var q = qty ? parseInt(qty.value) : 1;
                        if (isNaN(q) || q < 1) q = 1;
                        if (q > 9999) q = 9999;
                        var up = unitPriceInput ? unitPriceInput.value.replace(/[,.]/g, '') : '';
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
                        if (supplierId) {
                            var supInput = document.createElement('input');
                            supInput.type = 'hidden';
                            supInput.name = 'supplierId';
                            supInput.value = supplierId;
                            form.appendChild(supInput);
                        }
                        if (up) {
                            var upInput = document.createElement('input');
                            upInput.type = 'hidden';
                            upInput.name = 'unitPrice';
                            upInput.value = up;
                            form.appendChild(upInput);
                        }
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
                    if (unresolvedCount > 0) {
                        alert('Vẫn còn ' + unresolvedCount + ' dòng chưa chọn nhà cung cấp. Vui lòng xử lý trước khi lưu.');
                        return;
                    }
                    var count = buildPayload();
                    if (!count) { alert('Không có dòng hợp lệ nào để lưu.'); return; }
                    submitTypeInput.value = value;
                    form.submit();
                }

                if (btnDraft) btnDraft.addEventListener('click', function () { submitForm('draft'); });
                if (btnPending) btnPending.addEventListener('click', function () { submitForm('pending'); });

                // Auto reload nếu vừa tạo NCC mới xong
                var newSupplierId = new URLSearchParams(window.location.search).get('newSupplierId');
                var newSupplierName = new URLSearchParams(window.location.search).get('newSupplierName');
                if (newSupplierId && newSupplierName) {
                    var idxStr = new URLSearchParams(window.location.search).get('rowIndex');
                    if (idxStr != null) {
                        var idx = parseInt(idxStr);
                        if (!isNaN(idx) && idx >= 0) {
                            fetch('${pageContext.request.contextPath}/proposal?action=assignSupplier', {
                                method: 'POST',
                                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                                body: 'rowIndex=' + encodeURIComponent(idx) + '&supplierId=' + encodeURIComponent(newSupplierId)
                            }).then(function (r) { return r.json(); }).then(function (data) {
                                if (data && data.ok) {
                                    window.location.href = '${pageContext.request.contextPath}/proposal?action=importConfirm';
                                }
                            }).catch(function () {
                                window.location.href = '${pageContext.request.contextPath}/proposal?action=importConfirm';
                            });
                        }
                    }
                }
            })();

            // === Slide-out panel logic (copy pattern từ liquidation-edit.jsp) ===
            var currentRowIndex = null;
            var currentUnresolvedRow = null;

            function openSupplierPanel(rowIndex, query, tr) {
                currentRowIndex = rowIndex;
                currentUnresolvedRow = tr || null;
                var searchInput = document.getElementById('supplierSearchInput');
                searchInput.value = query || '';
                document.getElementById('sidePanelOverlay').classList.add('show');
                document.getElementById('sidePanel').classList.add('show');
                document.getElementById('supplierList').innerHTML = '';
                document.getElementById('supplierLoading').style.display = 'block';
                setTimeout(function () { searchInput.focus(); }, 280);
                loadSuppliers(searchInput.value);
            }

            function closeSupplierPanel() {
                document.getElementById('sidePanelOverlay').classList.remove('show');
                document.getElementById('sidePanel').classList.remove('show');
                currentRowIndex = null;
                currentUnresolvedRow = null;
            }

            function loadSuppliers(q) {
                document.getElementById('supplierLoading').style.display = 'block';
                fetch('${pageContext.request.contextPath}/proposal?action=searchSupplier&q=' + encodeURIComponent(q || ''))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        document.getElementById('supplierLoading').style.display = 'none';
                        var listWrap = document.getElementById('supplierList');
                        listWrap.innerHTML = '';
                        if (!data || data.length === 0) {
                            listWrap.innerHTML = '<div class="empty-msg">Không tìm thấy nhà cung cấp nào.</div>';
                            return;
                        }
                        data.forEach(function (s) {
                            var card = document.createElement('div');
                            card.className = 'supplier-card';
                            card.setAttribute('data-name', (s.name || '').toLowerCase());
                            card.setAttribute('data-phone', (s.phone || '').toLowerCase());
                            card.setAttribute('data-email', (s.email || '').toLowerCase());
                            var metaHtml = '';
                            if (s.phone) {
                                metaHtml += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>'
                                        + escapeHtml(s.phone) + '</span>';
                            }
                            if (s.email) {
                                metaHtml += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>'
                                        + escapeHtml(s.email) + '</span>';
                            }
                            if (s.company) {
                                metaHtml += '<span><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21h18M3 7v14M21 7v14M6 7V3h12v4M9 11h.01M15 11h.01M9 15h.01M15 15h.01"/></svg>'
                                        + escapeHtml(s.company) + '</span>';
                            }
                            card.innerHTML = ''
                                + '<div class="supplier-card-left">'
                                +   '<div class="supplier-card-name">' + escapeHtml(s.name) + '</div>'
                                +   '<div class="supplier-card-meta">' + metaHtml + '</div>'
                                + '</div>'
                                + '<div class="supplier-card-icon">'
                                +   '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>'
                                + '</div>';
                            card.onclick = function () { pickSupplier(s); };
                            listWrap.appendChild(card);
                        });
                    })
                    .catch(function (err) {
                        document.getElementById('supplierLoading').style.display = 'none';
                        document.getElementById('supplierList').innerHTML = '<div class="empty-msg" style="color:var(--danger)">Lỗi kết nối khi tải dữ liệu</div>';
                    });
            }

            function pickSupplier(supplier) {
                if (currentRowIndex == null) return;
                fetch('${pageContext.request.contextPath}/proposal?action=assignSupplier', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'rowIndex=' + encodeURIComponent(currentRowIndex) + '&supplierId=' + encodeURIComponent(supplier.id)
                })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (data && data.ok) {
                        // Move unresolved row to "Hợp lệ" by reloading the page
                        window.location.reload();
                    } else {
                        alert('Không thể gán nhà cung cấp: ' + (data && data.error ? data.error : 'unknown'));
                    }
                })
                .catch(function () {
                    alert('Lỗi kết nối khi gán nhà cung cấp');
                });
            }

            function escapeHtml(s) {
                if (!s) return '';
                return String(s)
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            }

            document.getElementById('supplierSearchInput').addEventListener('input', function () {
                var q = this.value.toLowerCase().trim();
                var cards = document.querySelectorAll('.supplier-card');
                cards.forEach(function (c) {
                    var match = (c.getAttribute('data-name') || '').indexOf(q) >= 0
                        || (c.getAttribute('data-phone') || '').indexOf(q) >= 0
                        || (c.getAttribute('data-email') || '').indexOf(q) >= 0;
                    c.style.display = match ? '' : 'none';
                });
            });

            // ESC để đóng panel
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeSupplierPanel();
            });
        </script>
    </body>
</html>
