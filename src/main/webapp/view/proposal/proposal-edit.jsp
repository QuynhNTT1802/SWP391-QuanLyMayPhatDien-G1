<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);

    int __sumQty = 0;
    java.math.BigDecimal __sumValue = java.math.BigDecimal.ZERO;
    java.util.List __details = (java.util.List) request.getAttribute("proposal") == null
            ? null : ((com.quanlymayphatdien.g1.entity.ImportProposal) request.getAttribute("proposal")).getDetails();
    if (__details != null) {
        for (Object o : __details) {
            com.quanlymayphatdien.g1.entity.ImportProposalDetail d =
                    (com.quanlymayphatdien.g1.entity.ImportProposalDetail) o;
            __sumQty += d.getQuantity();
            if (d.getUnitPrice() != null) {
                __sumValue = __sumValue.add(d.getUnitPrice().multiply(java.math.BigDecimal.valueOf(d.getQuantity())));
            }
        }
    }
    java.text.NumberFormat __moneyFmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
    request.setAttribute("sumQty", __sumQty);
    request.setAttribute("sumValueFmt", __moneyFmt.format(__sumValue));
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>
            h1,h2,h3,h4{
                font-weight:700;
                letter-spacing:-0.01em
            }
            label,.label{
                font-weight:600
            }
            input,select,textarea,button{
                font-weight:500
            }
            .mono{
                font-family:var(--font-mono);
                font-variant-numeric:tabular-nums
            }
            main{
                padding:24px 32px 60px;
                max-width:1200px;
                margin:0 auto
            }
            .page-head{
                margin-bottom:20px
            }
            .eyebrow{
                display:inline-flex;
                align-items:center;
                gap:6px;
                font-size:11px;
                font-weight:700;
                letter-spacing:0.08em;
                text-transform:uppercase;
                color:var(--accent);
                margin-bottom:8px
            }
            .eyebrow::before{
                content:'';
                width:5px;
                height:5px;
                border-radius:50%;
                background:var(--accent)
            }
            .page-head h1.title{
                font-size:26px;
                font-weight:700;
                letter-spacing:-0.02em;
                margin:0
            }
            .page-head .lede{
                color:var(--muted);
                margin-top:6px;
                max-width:720px;
                font-size:14px
            }
            .section{
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:10px;
                overflow:hidden;
                margin-bottom:16px
            }
            .section-head{
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:12px;
                padding:16px 20px;
                border-bottom:1px solid var(--border)
            }
            .section-head-left{
                display:flex;
                align-items:baseline;
                gap:12px;
                min-width:0
            }
            .section-head h3{
                font-size:14px;
                font-weight:700;
                margin:0
            }
            .section-head .sub{
                font-size:11.5px;
                color:var(--muted);
                font-family:var(--font-mono)
            }
            .section-body{
                padding:22px 20px
            }
            .form-grid{
                display:grid;
                grid-template-columns:1fr 2fr;
                gap:14px
            }
            .info-field .info-label{
                font-size:11px;
                color:var(--muted);
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:0.02em;
                margin-bottom:4px;
                display:block
            }
            .info-field .info-value{
                font-size:13.5px;
                color:var(--fg);
                padding:8px 12px;
                background:var(--surface-2);
                border:1px solid var(--border);
                border-radius:var(--radius-sm)
            }
            .info-input{
                font-family:var(--font-ui);
                font-size:13.5px;
                color:var(--fg);
                background:var(--bg);
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                padding:8px 12px;
                width:100%;
                line-height:1.4;
                box-sizing:border-box
            }
            .info-input:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            .info-select{
                appearance:none;
                background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23999' stroke-width='2'><path d='m6 9 6 6 6-6'/></svg>");
                background-repeat:no-repeat;
                background-position:right 10px center;
                background-size:14px;
                padding-inline-end:32px;
                cursor:pointer;
                font-family:var(--font-ui);
                font-size:13.5px;
                color:var(--fg);
                background-color:var(--bg);
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                padding:8px 12px;
                width:100%;
                line-height:1.4;
                box-sizing:border-box
            }
            .info-select:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            textarea.info-input{
                min-height:72px;
                resize:vertical
            }

            .summary-row{
                display:flex;
                gap:10px;
                flex-wrap:wrap;
                margin-bottom:16px
            }
            .pill{
                display:inline-flex;
                align-items:center;
                gap:5px;
                font-size:12px;
                font-weight:600;
                padding:4px 12px;
                border-radius:999px;
                border:1px solid
            }
            .pill .pill-num{
                font-weight:700
            }
            .pill.ok{
                color:var(--accent);
                border-color:color-mix(in srgb,var(--accent) 25%,transparent);
                background:var(--accent-soft)
            }
            .pill.warn{
                color:var(--warn);
                border-color:color-mix(in srgb,var(--warn) 25%,transparent);
                background:var(--warn-soft)
            }
            .pill.bad{
                color:var(--danger);
                border-color:color-mix(in srgb,var(--danger) 25%,transparent);
                background:var(--danger-soft)
            }

            .table-scroll{
                overflow-x:auto;
                -webkit-overflow-scrolling:touch;
                margin-bottom:0
            }
            table.data-table{
                width:100%;
                border-collapse:separate;
                border-spacing:0;
                font-size:13px
            }
            table.data-table thead th{
                text-align:left;
                font-size:11px;
                color:var(--muted);
                text-transform:uppercase;
                font-weight:700;
                background:var(--surface-2);
                padding:11px 14px;
                border-bottom:1px solid var(--border);
                letter-spacing:0.04em
            }
            table.data-table tbody td{
                padding:11px 14px;
                border-bottom:1px solid var(--border);
                vertical-align:middle
            }
            table.data-table tbody tr:last-child td{
                border-bottom:0
            }
            .text-right{
                text-align:right
            }
            .text-center{
                text-align:center
            }
            .model-cell{
                font-weight:600
            }
            .name-cell{
                color:var(--muted);
                font-size:12.5px
            }
            .col-min{
                white-space:nowrap;
                width:1%
            }
            .col-supplier{
                white-space:nowrap
            }
            .col-price{
                white-space:nowrap;
                width:110px
            }
            .col-qty{
                white-space:nowrap;
                width:80px
            }
            .col-note{
                min-width:120px
            }
            .col-del{
                white-space:nowrap;
                width:40px;
                text-align:center
            }
            .error-msg{
                color:var(--danger);
                font-size:12px;
                font-weight:600;
                margin-top:4px
            }

            table.data-table .row-qty{
                width:90px;
                padding:6px 8px;
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                background:var(--bg);
                color:var(--fg);
                font-size:13px;
                font-family:inherit;
                box-sizing:border-box;
                text-align:right
            }
            table.data-table .row-qty:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            table.data-table .row-note{
                width:100%;
                padding:6px 8px;
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                background:var(--bg);
                color:var(--fg);
                font-size:13px;
                font-family:inherit;
                box-sizing:border-box
            }
            table.data-table .row-note:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            table.data-table .row-unitprice{
                width:110px;
                padding:6px 8px;
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                background:var(--bg);
                color:var(--fg);
                font-size:13px;
                font-family:inherit;
                box-sizing:border-box;
                text-align:right;
                min-width:80px
            }
            table.data-table .row-unitprice:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            table.data-table .row-generator{
                width:160px;
                padding:6px 8px;
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                background:var(--bg);
                color:var(--fg);
                font-size:13px;
                font-family:inherit;
                box-sizing:border-box
            }
            table.data-table .row-generator:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            .stock-cell{
                display:inline-block;
                min-width:56px;
                padding:4px 8px;
                border-radius:var(--radius-sm);
                font-family:var(--font-mono);
                font-size:12.5px;
                font-weight:600;
                text-align:center;
                background:var(--surface-2);
                border:1px solid var(--border);
                color:var(--muted)
            }
            .stock-cell.has-stock{
                background:var(--accent-soft);
                color:var(--accent);
                border-color:color-mix(in srgb,var(--accent) 25%,transparent)
            }
            .stock-cell.zero-stock{
                background:var(--warn-soft);
                color:var(--warn);
                border-color:color-mix(in srgb,var(--warn) 25%,transparent)
            }
            .col-stock{
                white-space:nowrap;
                width:100px;
                text-align:center
            }

            .supplier-cell{
                font-size:12.5px;
                font-weight:600;
                color:var(--fg);
                display:block
            }
            .supplier-cell .supplier-phone{
                display:block;
                font-size:11px;
                font-weight:500;
                color:var(--muted);
                margin-top:2px
            }

            .row-del-btn{
                width:28px;
                height:28px;
                border:none;
                background:none;
                color:var(--danger);
                cursor:pointer;
                border-radius:var(--radius-sm);
                font-size:18px;
                line-height:1;
                display:inline-flex;
                align-items:center;
                justify-content:center
            }
            .row-del-btn:hover{
                background:var(--danger-soft)
            }

            .btn{
                display:inline-flex;
                align-items:center;
                gap:6px;
                border:1px solid var(--border);
                background:var(--surface);
                color:var(--fg);
                padding:8px 16px;
                border-radius:var(--radius-sm);
                font-size:13px;
                font-weight:600;
                cursor:pointer;
                font-family:var(--font-ui);
                text-decoration:none
            }
            .btn:hover{
                background:var(--surface-2)
            }
            .btn-primary{
                background:var(--fg);
                color:var(--bg);
                border-color:var(--fg)
            }
            .btn-primary:hover{
                background:var(--fg-soft);
                border-color:var(--fg-soft)
            }
            .btn-danger{
                background:var(--danger);
                color:#fff;
                border-color:var(--danger)
            }
            .btn-danger:hover{
                opacity:.92
            }
            .btn:disabled{
                opacity:0.4;
                cursor:not-allowed
            }
            .btn-sm{
                padding:5px 12px;
                font-size:12px
            }
            .actions{
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:22px;
                flex-wrap:wrap
            }

            .alert{
                padding:12px 16px;
                border-radius:var(--radius-sm);
                margin-bottom:16px;
                font-size:13px;
                font-weight:600;
                display:flex;
                align-items:center;
                gap:10px;
                border:1px solid
            }
            .alert svg{
                width:18px;
                height:18px;
                stroke:currentColor;
                fill:none;
                stroke-width:2;
                flex-shrink:0
            }
            .alert-warn{
                background:var(--warn-soft);
                color:var(--warn);
                border-color:color-mix(in srgb,var(--warn) 30%,transparent)
            }
            .alert-error{
                background:var(--danger-soft);
                color:var(--danger);
                border-color:color-mix(in srgb,var(--danger) 30%,transparent)
            }
            .alert-success{
                background:var(--accent-soft);
                color:var(--accent);
                border-color:color-mix(in srgb,var(--accent) 25%,transparent)
            }

            .topbar{
                position:sticky;
                top:0;
                z-index:10;
                background:color-mix(in srgb,var(--bg) 85%,transparent);
                backdrop-filter:blur(8px);
                border-bottom:1px solid var(--border);
                display:flex;
                align-items:center;
                gap:16px;
                padding:12px 24px
            }
            .topbar h1{
                font-size:16px;
                font-weight:700;
                margin:0;
                letter-spacing:-0.01em
            }
            .crumb{
                color:var(--muted);
                font-size:13px;
                font-weight:500
            }
            .top-actions{
                margin-inline-start:auto;
                display:flex;
                align-items:center;
                gap:8px
            }
            .icon-btn{
                width:32px;
                height:32px;
                border:1px solid var(--border);
                background:var(--surface);
                color:var(--fg-soft);
                border-radius:var(--radius-sm);
                display:grid;
                place-items:center;
                cursor:pointer
            }
            .icon-btn:hover{
                background:var(--surface-2);
                color:var(--fg)
            }
            .icon-btn svg{
                width:15px;
                height:15px;
                stroke:currentColor;
                fill:none;
                stroke-width:1.6
            }
            .back-link{
                display:inline-flex;
                align-items:center;
                gap:6px;
                color:var(--muted);
                text-decoration:none;
                font-size:13px;
                font-weight:600;
                margin-bottom:14px
            }
            .back-link:hover{
                color:var(--fg)
            }
            .back-link svg{
                width:14px;
                height:14px;
                stroke:currentColor;
                fill:none;
                stroke-width:1.8
            }

            .status-badge{
                display:inline-flex;
                align-items:center;
                gap:5px;
                font-size:11.5px;
                font-weight:600;
                padding:2px 9px;
                border-radius:999px;
                border:1px solid;
                margin-left:8px
            }
            .status-badge.draft{
                color:var(--muted);
                border-color:var(--border);
                background:var(--surface-2)
            }
            .status-badge.revision{
                color:#7c3aed;
                border-color:color-mix(in srgb,#7c3aed 30%,transparent);
                background:color-mix(in srgb,#7c3aed 8%,transparent)
            }

            .revision-reason{
                background:var(--surface-2);
                border:1px solid color-mix(in srgb,#7c3aed 30%,transparent);
                border-radius:10px;
                padding:14px 18px;
                margin-bottom:16px;
                display:flex;
                gap:12px;
                align-items:flex-start
            }
            .revision-reason .rr-icon{
                color:#7c3aed;
                flex-shrink:0;
                margin-top:2px
            }
            .revision-reason .rr-icon svg{
                width:18px;
                height:18px
            }
            .revision-reason .rr-body{
                font-size:13px;
                color:var(--fg)
            }
            .revision-reason .rr-label{
                font-weight:700;
                font-size:11px;
                color:#7c3aed;
                text-transform:uppercase;
                letter-spacing:0.04em;
                margin-bottom:4px
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
                <div>
                    <header class="topbar">
                        <h1>Chỉnh sửa đề xuất</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}"><c:out value="${proposal.proposalCode}"/></a> / Chỉnh sửa</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'danger' ? 'alert-error' : (sessionScope.toastType == 'success' ? 'alert-success' : 'alert-warn')}">
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>

                    <c:if test="${proposal.status == 'NEEDS_REVISION' && not empty proposal.rejectReason}">
                        <div class="revision-reason">
                            <div class="rr-icon">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            </div>
                            <div class="rr-body">
                                <div class="rr-label">Lý do ${proposal.revisionRequestedByRole == 'CEO' ? 'CEO' : 'Sale Manager'} yêu cầu chỉnh sửa</div>
                                <div><c:out value="${proposal.rejectReason}"/></div>
                            </div>
                        </div>
                    </c:if>

                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Chỉnh sửa</div>
                        <h1 class="title">
                            Chỉnh sửa phiếu đề xuất
                            <c:choose>
                                <c:when test="${proposal.status == 'DRAFT'}"><span class="status-badge draft">Nháp</span></c:when>
                                <c:when test="${proposal.status == 'NEEDS_REVISION'}"><span class="status-badge revision">Cần chỉnh sửa</span></c:when>
                            </c:choose>
                        </h1>
                        <div class="lede">Phiếu <c:out value="${proposal.proposalCode}"/> · Người tạo: <c:out value="${proposal.createdByName}"/></div>
                    </div>

                    <form id="uploadExcelForm" method="post" action="${pageContext.request.contextPath}/proposal?action=uploadEditExcel&id=${proposal.proposalId}" enctype="multipart/form-data" style="display:none">
                        <input type="file" name="excelFile" id="excelUpload" accept=".xlsx,.xls" onchange="this.form.submit()" />
                    </form>
                    <form id="editForm" method="post" action="${pageContext.request.contextPath}/proposal?action=update" onsubmit="return validateForm()">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />

                        <div class="section">
                            <div class="section-head">
                                <div class="section-head-left"><h3>Thông tin chung</h3></div>
                            </div>
                            <div class="section-body">
                                <div class="form-grid">
                                    <div class="info-field">
                                        <span class="info-label">Kho nhập <span style="color:var(--danger)">*</span></span>
                                        <select class="info-select" id="warehouseId" name="warehouseId" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.warehouseId}" <c:if test="${w.warehouseId == proposal.warehouseId}">selected</c:if>><c:out value="${w.name}"/></option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="info-field">
                                        <span class="info-label">Nhà cung cấp <span style="color:var(--danger)">*</span>
                                            <span style="font-weight:500;color:var(--muted);text-transform:none;letter-spacing:0"> &nbsp;(áp dụng cho cả phiếu)</span>
                                        </span>
                                        <div style="display:flex;gap:8px;align-items:center">
                                            <select class="info-select" id="supplierId" name="supplierId" required style="flex:1">
                                                <option value="">-- Chọn NCC --</option>
                                                <c:forEach var="s" items="${suppliers}">
                                                    <option value="${s.id}" data-phone="${s.phone}" data-email="${s.email}" data-company="${s.companyName}" <c:if test="${s.id == proposal.supplierId}">selected</c:if>><c:out value="${s.name}"/></option>
                                                </c:forEach>
                                            </select>
                                            <c:if test="${canCreateSupplier}">
                                                <button type="button" class="btn btn-sm" onclick="openNewSupplierModal()" title="Thêm nhà cung cấp mới">+ NCC</button>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="info-field" style="grid-column:1/-1">
                                        <span class="info-label">Ghi chú phiếu</span>
                                        <textarea class="info-input" id="note" name="note" rows="2" placeholder="Ghi chú cho phiếu..."><c:out value="${proposal.note}"/></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="summary-row">
                            <span class="pill ok"><span class="pill-num">${not empty proposal.details ? fn:length(proposal.details) : 0}</span> dòng máy phát</span>
                            <c:set var="_totalQty" value="0" />
                            <c:set var="_totalVal" value="0" />
                            <c:forEach var="d" items="${proposal.details}">
                                <c:set var="_totalQty" value="${_totalQty + d.quantity}" />
                                <c:if test="${not empty d.unitPrice}">
                                    <c:set var="_totalVal" value="${_totalVal + (d.unitPrice.doubleValue() * d.quantity)}" />
                                </c:if>
                            </c:forEach>
                            <span class="pill"><span class="pill-num"><c:out value="${_totalQty}"/></span> tổng SL</span>
                            <c:choose>
                                <c:when test="${_totalVal > 0}">
                                    <span class="pill"><strong style="font-family:var(--font-mono);">₫<fmt:formatNumber value="${_totalVal}" pattern="#,##0"/></strong> ước tính</span>
                                </c:when>
                            </c:choose>
                        </div>

                        <div class="section" style="padding:0">
                            <div class="section-head">
                                <div class="section-head-left"><h3>Danh sách máy phát</h3><span class="sub">${not empty proposal.details ? fn:length(proposal.details) : 0} dòng</span></div>
                                <div style="display:flex;gap:8px">
                                    <button type="button" class="btn btn-sm" onclick="document.getElementById('excelUpload').click()">Tải Excel thay thế</button>
                                    <a class="btn btn-sm btn-ghost" href="${pageContext.request.contextPath}/proposal?action=importExcel">Import từ Excel</a>
                                </div>
                            </div>
                            <div class="table-scroll">
                                <table class="data-table" style="min-width:780px">
                                    <thead>
                                        <tr>
                                            <th class="col-min">#</th>
                                            <th>Mẫu máy <span style="color:var(--danger)">*</span></th>
                                            <th class="col-stock">Tồn kho</th>
                                            <th class="col-qty text-right">Số lượng <span style="color:var(--danger)">*</span></th>
                                            <th class="col-price text-right">Đơn giá (VNĐ) <span style="color:var(--danger)">*</span></th>
                                            <th class="col-note">Ghi chú dòng</th>
                                            <th class="col-del"></th>
                                        </tr>
                                    </thead>
                                    <tbody id="detailBody">
                                        <c:choose>
                                            <c:when test="${not empty proposal.details}">
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr data-row-id="${d.proposalDetailId}">
                                                        <td class="mono">${st.index + 1}</td>
                                                        <td>
                                                            <div style="display:flex;gap:6px;align-items:center;min-width:240px">
                                                                <select name="generatorId" class="row-generator" required onchange="onGenChange(this)" style="flex:1">
                                                                    <option value="">-- Chọn máy --</option>
                                                                    <c:forEach var="g" items="${generators}">
                                                                        <option value="${g.id}" <c:if test="${g.id == d.generatorId}">selected</c:if>><c:out value="${g.model}"/></option>
                                                                    </c:forEach>
                                                                </select>
                                                                <c:if test="${canCreateGenerator}">
                                                                    <button type="button" class="btn btn-sm" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới" style="padding:4px 10px">+</button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td class="text-center"><span class="stock-cell" data-stock>—</span></td>
                                                        <td><input type="number" name="quantity" class="row-qty mono" value="${d.quantity}" min="1" max="9999" oninput="validateQty(this);recalcSummary()" required /></td>
                                                        <td><input type="number" name="unitPrice" class="row-unitprice mono" value="${d.unitPrice != null ? d.unitPrice : ''}" min="0" step="1000" placeholder="0" oninput="recalcSummary()" required /></td>
                                                        <td><input type="text" name="detailNote" class="row-note" value="<c:out value='${d.note}'/>" placeholder="Ghi chú dòng" /></td>
                                                        <td class="col-del">
                                                            <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td class="mono">1</td>
                                                    <td>
                                                        <div style="display:flex;gap:6px;align-items:center;min-width:240px">
                                                            <select name="generatorId" class="row-generator" required onchange="onGenChange(this)" style="flex:1">
                                                                <option value="">-- Chọn máy --</option>
                                                                <c:forEach var="g" items="${generators}">
                                                                    <option value="${g.id}"><c:out value="${g.model}"/></option>
                                                                </c:forEach>
                                                            </select>
                                                            <c:if test="${canCreateGenerator}">
                                                                <button type="button" class="btn btn-sm" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới" style="padding:4px 10px">+</button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                    <td class="text-center"><span class="stock-cell" data-stock>—</span></td>
                                                    <td><input type="number" name="quantity" class="row-qty mono" value="1" min="1" max="9999" oninput="validateQty(this);recalcSummary()" required /></td>
                                                    <td><input type="number" name="unitPrice" class="row-unitprice mono" min="0" step="1000" placeholder="0" oninput="recalcSummary()" required /></td>
                                                    <td><input type="text" name="detailNote" class="row-note" placeholder="Ghi chú dòng" /></td>
                                                    <td class="col-del">
                                                        <button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                            <div style="padding:12px 20px;border-top:1px solid var(--border);display:flex;gap:16px;align-items:center;flex-wrap:wrap">
                                <button type="button" class="btn btn-sm" onclick="addRow()">
                                    <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M12 5v14M5 12h14"/></svg>
                                    Thêm dòng
                                </button>
                                <span style="font-size:12.5px;color:var(--muted);margin-left:auto">
                                    Tổng: <strong id="sumRows">${not empty proposal.details ? fn:length(proposal.details) : 0}</strong> dòng ·
                                    <strong id="sumQty">${sumQty}</strong> máy ·
                                    <strong id="sumValue">${sumValueFmt}</strong> ₫
                                </span>
                            </div>
                        </div>

                        <div class="actions">
                            <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Huỷ</a>
                            <c:if test="${proposal.status == 'DRAFT'}">
                                <button type="button" class="btn btn-danger" onclick="confirmDelete()">Xoá phiếu</button>
                                <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                            </c:if>
                            <button type="submit" name="submitType" value="submit" class="btn btn-primary">
                                <svg viewBox="0 0 24 24" style="width:13px;height:13px;stroke:currentColor;fill:none;stroke-width:2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                ${proposal.status == 'NEEDS_REVISION' ? 'Gửi duyệt lại' : 'Gửi duyệt'}
                            </button>
                        </div>
                    </form>

                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:none;">
                        <input type="hidden" name="id" value="${proposal.proposalId}" />
                    </form>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <div class="modal-host" id="genModalOverlay">
            <div class="modal" style="max-width:680px;background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:24px;box-shadow:0 20px 50px rgba(0,0,0,.18);width:100%">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
                    <h3 style="margin:0;font-size:18px;font-weight:700">Thêm máy phát mới</h3>
                    <button type="button" onclick="closeNewGeneratorModal()" style="background:0 0;border:0;color:var(--muted);cursor:pointer;font-size:24px;line-height:1;padding:4px 8px">×</button>
                </div>
                <p style="font-size:13px;color:var(--muted);margin:0 0 14px">Máy phát sẽ được thêm ngay vào dropdown của dòng đang chọn.</p>
                <div class="modal-error" id="genModalError" style="display:none;padding:10px 14px;border-radius:var(--radius-sm);background:var(--danger-soft);color:var(--danger);border:1px solid;color-mix(in srgb,var(--danger) 25%,transparent);font-size:13px;font-weight:600;margin-bottom:12px"></div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px 16px">
                    <div class="field">
                        <label class="field-label">Mã máy phát (model) <span style="color:var(--danger)">*</span></label>
                        <input type="text" id="ngModel" class="input" placeholder="VD: Honda EU22i" autocomplete="off" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Công suất (kVA) <span style="color:var(--danger)">*</span></label>
                        <input type="number" id="ngPower" class="input mono" step="0.01" placeholder="VD: 50" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Tần số (Hz)</label>
                        <input type="text" id="ngFreq" class="input mono" placeholder="VD: 50" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Trọng lượng (kg)</label>
                        <input type="number" id="ngWeight" class="input mono" step="0.01" placeholder="VD: 120" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Thương hiệu</label>
                        <select id="ngBrandId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catBrands}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label class="field-label">Xuất xứ</label>
                        <select id="ngOriginId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catOrigins}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label class="field-label">Tình trạng</label>
                        <select id="ngConditionId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catConditions}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label class="field-label">Nhiên liệu</label>
                        <select id="ngFuelTypeId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catFuelTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label class="field-label">Số pha</label>
                        <select id="ngPhaseId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catPhases}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field">
                        <label class="field-label">Loại máy phát</label>
                        <select id="ngGenTypeId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="b" items="${catGenTypes}"><option value="${b.id}"><c:out value="${b.name}"/></option></c:forEach>
                        </select>
                    </div>
                </div>
                <div style="display:flex;justify-content:flex-end;gap:8px;margin-top:18px;padding-top:14px;border-top:1px solid var(--border)">
                    <button type="button" class="btn" onclick="closeNewGeneratorModal()">Huỷ</button>
                    <button type="button" class="btn btn-primary" id="ngSaveBtn" onclick="saveNewGenerator()">Lưu máy phát</button>
                </div>
            </div>
        </div>

        <div class="modal-host" id="supModalOverlay">
            <div class="modal" style="max-width:680px;background:var(--surface);border:1px solid var(--border);border-radius:12px;padding:24px;box-shadow:0 20px 50px rgba(0,0,0,.18);width:100%">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
                    <h3 style="margin:0;font-size:18px;font-weight:700">Thêm nhà cung cấp mới</h3>
                    <button type="button" onclick="closeNewSupplierModal()" style="background:0 0;border:0;color:var(--muted);cursor:pointer;font-size:24px;line-height:1;padding:4px 8px">×</button>
                </div>
                <p style="font-size:13px;color:var(--muted);margin:0 0 14px">Nhà cung cấp sẽ được áp dụng cho toàn bộ phiếu.</p>
                <div class="modal-error" id="supModalError" style="display:none;padding:10px 14px;border-radius:var(--radius-sm);background:var(--danger-soft);color:var(--danger);border:1px solid;color-mix(in srgb,var(--danger) 25%,transparent);font-size:13px;font-weight:600;margin-bottom:12px"></div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px 16px">
                    <div class="field">
                        <label class="field-label">Tên nhà cung cấp <span style="color:var(--danger)">*</span></label>
                        <input type="text" id="nsName" class="input" placeholder="VD: Nguyễn Văn B" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Số điện thoại <span style="color:var(--danger)">*</span></label>
                        <input type="tel" id="nsPhone" class="input mono" placeholder="VD: 0912345678" inputmode="numeric" maxlength="11" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Email</label>
                        <input type="email" id="nsEmail" class="input mono" placeholder="email@example.com" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field">
                        <label class="field-label">Loại NCC</label>
                        <select id="nsTypeId" class="select" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box">
                            <option value="">-- Chọn --</option>
                            <c:forEach var="t" items="${supplierTypeList}"><option value="${t.id}"><c:out value="${t.name}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="field" style="grid-column:1/-1">
                        <label class="field-label">Tên công ty</label>
                        <input type="text" id="nsCompanyName" class="input" placeholder="VD: Công ty TNHH ABC" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box" />
                    </div>
                    <div class="field" style="grid-column:1/-1">
                        <label class="field-label">Địa chỉ</label>
                        <textarea id="nsAddress" class="input" rows="2" placeholder="Địa chỉ NCC" style="font-family:var(--font-ui);font-size:14px;color:var(--fg);background:var(--surface);border:1px solid var(--border);border-radius:var(--radius-sm);padding:9px 12px;width:100%;box-sizing:border-box"></textarea>
                    </div>
                </div>
                <div style="display:flex;justify-content:flex-end;gap:8px;margin-top:18px;padding-top:14px;border-top:1px solid var(--border)">
                    <button type="button" class="btn" onclick="closeNewSupplierModal()">Huỷ</button>
                    <button type="button" class="btn btn-primary" id="nsSaveBtn" onclick="saveNewSupplier()">Lưu NCC</button>
                </div>
            </div>
        </div>

        <template id="rowTemplate">
            <tr>
                <td class="mono"></td>
                <td>
                    <div style="display:flex;gap:6px;align-items:center;min-width:240px">
                        <select name="generatorId" class="row-generator" required onchange="onGenChange(this)" style="flex:1">
                            <option value="">-- Chọn máy --</option>
                            <c:forEach var="g" items="${generators}">
                                <option value="${g.id}"><c:out value="${g.model}"/></option>
                            </c:forEach>
                        </select>
                        <c:if test="${canCreateGenerator}">
                            <button type="button" class="btn btn-sm" onclick="openNewGeneratorModal(this)" title="Thêm máy phát mới" style="padding:4px 10px">+</button>
                        </c:if>
                    </div>
                </td>
                <td class="text-center"><span class="stock-cell" data-stock>—</span></td>
                <td><input type="number" name="quantity" class="row-qty mono" value="1" min="1" max="9999" oninput="validateQty(this);recalcSummary()" required /></td>
                <td><input type="number" name="unitPrice" class="row-unitprice mono" min="0" step="1000" placeholder="0" oninput="recalcSummary()" required /></td>
                <td><input type="text" name="detailNote" class="row-note" placeholder="Ghi chú dòng" /></td>
                <td class="col-del"><button type="button" class="row-del-btn" onclick="removeRow(this)" title="Xoá dòng">×</button></td>
            </tr>
        </template>
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script>
        var STOCK_MAP = {};
        <c:forEach var="entry" items="${stockByGen}">
        STOCK_MAP['${entry.key}'] = ${entry.value};
        </c:forEach>
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script>
            (function () {
                function fmt(n) { return Math.round(n || 0).toLocaleString('vi-VN'); }
                window.recalcSummary = function () {
                    var trs = document.querySelectorAll('#detailBody tr');
                    var rows = 0, qty = 0, total = 0;
                    trs.forEach(function (tr) {
                        var sel = tr.querySelector('.row-generator');
                        if (sel && sel.value) rows++;
                        var q = parseInt(tr.querySelector('.row-qty').value) || 0;
                        var p = parseFloat((tr.querySelector('.row-unitprice').value || '').toString().replace(/[^0-9.]/g, '')) || 0;
                        qty += q;
                        total += q * p;
                    });
                    var sr = document.getElementById('sumRows');
                    var sq = document.getElementById('sumQty');
                    var sv = document.getElementById('sumValue');
                    if (sr) sr.textContent = rows;
                    if (sq) sq.textContent = qty;
                    if (sv) sv.textContent = fmt(total);
                };
                window.onGenChange = function (sel) {
                    var tr = sel.closest('tr');
                    var cell = tr.querySelector('[data-stock]');
                    if (!sel.value) { cell.textContent = '—'; cell.className = 'stock-cell'; return; }
                    var stock = STOCK_MAP[sel.value];
                    if (stock == null || stock === 0) {
                        cell.textContent = '0';
                        cell.className = 'stock-cell zero-stock';
                        cell.title = (stock === 0) ? 'Hiện hết hàng trong kho này. Vẫn có thể đề xuất nhập.' : '';
                    } else {
                        cell.textContent = stock + ' máy';
                        cell.className = 'stock-cell has-stock';
                        cell.title = 'Tồn kho tại kho đã chọn';
                    }
                };
                window.validateQty = function (input) {
                    var v = (input.value || '').replace(/[^0-9]/g, '');
                    var n = parseInt(v);
                    if (isNaN(n) || n < 1) input.value = 1;
                    else if (n > 9999) input.value = 9999;
                    else input.value = n;
                };
                window.addRow = function () {
                    var tpl = document.getElementById('rowTemplate');
                    var clone = tpl.content.cloneNode(true);
                    document.getElementById('detailBody').appendChild(clone);
                    updateRowNumbers();
                    recalcSummary();
                };
                window.removeRow = function (btn) {
                    var tbody = document.getElementById('detailBody');
                    if (tbody.querySelectorAll('tr').length <= 1) {
                        alert('Phải có ít nhất 1 dòng máy đề xuất.');
                        return;
                    }
                    btn.closest('tr').remove();
                    updateRowNumbers();
                    recalcSummary();
                };
                window.updateRowNumbers = function () {
                    document.querySelectorAll('#detailBody tr').forEach(function (tr, i) {
                        var td = tr.querySelector('td.mono');
                        if (td) td.textContent = i + 1;
                    });
                };
                window.validateForm = function () {
                    var rows = document.querySelectorAll('#detailBody tr');
                    if (rows.length === 0) return false;
                    var sup = document.getElementById('supplierId');
                    if (sup && !sup.value) {
                        alert('Vui lòng chọn nhà cung cấp.');
                        sup.focus();
                        return false;
                    }
                    var hasValid = false;
                    for (var i = 0; i < rows.length; i++) {
                        var sel = rows[i].querySelector('.row-generator');
                        var qtyInput = rows[i].querySelector('.row-qty');
                        var upInput = rows[i].querySelector('.row-unitprice');
                        var qty = parseInt(qtyInput.value);
                        var up = parseFloat((upInput.value || '').toString().replace(/[^0-9.]/g, ''));
                        if (sel.value) {
                            if (!qty || qty < 1) {
                                alert('Số lượng ở dòng ' + (i + 1) + ' phải là số nguyên dương.');
                                qtyInput.focus();
                                return false;
                            }
                            if (!up || up <= 0) {
                                alert('Đơn giá ở dòng ' + (i + 1) + ' phải lớn hơn 0.');
                                upInput.focus();
                                return false;
                            }
                            hasValid = true;
                        }
                    }
                    if (!hasValid) {
                        alert('Vui lòng chọn ít nhất 1 máy phát điện.');
                        return false;
                    }
                    return true;
                };
                window.confirmDelete = function () {
                    if (confirm('Xoá phiếu đề xuất này?')) {
                        document.getElementById('deleteForm').submit();
                    }
                };

                document.querySelectorAll('#detailBody tr').forEach(function (tr) {
                    var sel = tr.querySelector('.row-generator');
                    if (sel && sel.value) onGenChange(sel);
                });
                recalcSummary();

                var _ngSel = null;
                window.openNewGeneratorModal = function (btn) {
                    var tr = btn.closest('tr');
                    _ngSel = tr ? tr.querySelector('.row-generator') : null;
                    ['ngModel','ngPower','ngFreq','ngWeight','ngBrandId','ngOriginId','ngConditionId','ngFuelTypeId','ngPhaseId','ngGenTypeId']
                        .forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
                    var err = document.getElementById('genModalError');
                    err.classList.remove('show'); err.textContent = '';
                    document.getElementById('genModalOverlay').classList.add('show');
                    setTimeout(function () { document.getElementById('ngModel').focus(); }, 30);
                };
                window.closeNewGeneratorModal = function () {
                    document.getElementById('genModalOverlay').classList.remove('show');
                    _ngSel = null;
                };
                window.saveNewGenerator = function () {
                    var model = document.getElementById('ngModel').value.trim();
                    var power = document.getElementById('ngPower').value.trim();
                    if (!model || !power) {
                        var err = document.getElementById('genModalError');
                        err.textContent = 'Vui lòng nhập mã máy phát và công suất.';
                        err.classList.add('show');
                        return;
                    }
                    var btn = document.getElementById('ngSaveBtn');
                    btn.disabled = true; btn.textContent = 'Đang lưu...';
                    var fd = new FormData();
                    fd.append('action', 'quickCreateGenerator');
                    fd.append('model', model);
                    fd.append('powerRating', power);
                    fd.append('frequency', document.getElementById('ngFreq').value.trim());
                    fd.append('weight', document.getElementById('ngWeight').value.trim());
                    fd.append('brandId', document.getElementById('ngBrandId').value);
                    fd.append('originId', document.getElementById('ngOriginId').value);
                    fd.append('conditionId', document.getElementById('ngConditionId').value);
                    fd.append('fuelTypeId', document.getElementById('ngFuelTypeId').value);
                    fd.append('phaseId', document.getElementById('ngPhaseId').value);
                    fd.append('genTypeId', document.getElementById('ngGenTypeId').value);
                    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            btn.disabled = false; btn.textContent = 'Lưu máy phát';
                            if (data.ok) {
                                var sel = _ngSel || document.querySelector('#detailBody tr .row-generator');
                                if (sel) {
                                    var exists = false;
                                    for (var i = 0; i < sel.options.length; i++) {
                                        if (sel.options[i].value == data.id) { exists = true; break; }
                                    }
                                    if (!exists) {
                                        var opt = document.createElement('option');
                                        opt.value = data.id; opt.text = data.model;
                                        sel.appendChild(opt);
                                    }
                                    sel.value = data.id;
                                    onGenChange(sel);
                                }
                                closeNewGeneratorModal();
                                if (typeof toast !== 'undefined') {
                                    toast(data.existing
                                        ? 'Mã máy "' + data.model + '" đã có — đã tự chọn.'
                                        : 'Đã thêm máy phát "' + data.model + '"', data.existing ? 'info' : 'success');
                                }
                            } else {
                                var err = document.getElementById('genModalError');
                                err.textContent = data.error || 'Lỗi không xác định';
                                err.classList.add('show');
                            }
                        }).catch(function () {
                            btn.disabled = false; btn.textContent = 'Lưu máy phát';
                            var err = document.getElementById('genModalError');
                            err.textContent = 'Lỗi kết nối máy chủ';
                            err.classList.add('show');
                        });
                };

                window.openNewSupplierModal = function () {
                    ['nsName','nsPhone','nsEmail','nsCompanyName','nsAddress','nsTypeId'].forEach(function (id) {
                        var el = document.getElementById(id); if (el) el.value = '';
                    });
                    var err = document.getElementById('supModalError');
                    err.classList.remove('show'); err.textContent = '';
                    document.getElementById('supModalOverlay').classList.add('show');
                    setTimeout(function () { document.getElementById('nsName').focus(); }, 30);
                };
                window.closeNewSupplierModal = function () {
                    document.getElementById('supModalOverlay').classList.remove('show');
                };
                window.saveNewSupplier = function () {
                    var name = document.getElementById('nsName').value.trim();
                    var phone = document.getElementById('nsPhone').value.trim();
                    if (!name || !/^[0-9]{10,11}$/.test(phone)) {
                        var err = document.getElementById('supModalError');
                        err.textContent = 'Vui lòng nhập tên và SĐT hợp lệ (10-11 chữ số).';
                        err.classList.add('show');
                        return;
                    }
                    var btn = document.getElementById('nsSaveBtn');
                    btn.disabled = true; btn.textContent = 'Đang lưu...';
                    var fd = new FormData();
                    fd.append('action', 'quickCreateSupplier');
                    fd.append('name', name);
                    fd.append('phone', phone);
                    fd.append('email', document.getElementById('nsEmail').value.trim());
                    fd.append('address', document.getElementById('nsAddress').value.trim());
                    fd.append('companyName', document.getElementById('nsCompanyName').value.trim());
                    fd.append('supplierTypeId', document.getElementById('nsTypeId').value);
                    fetch(window.APP_CTX + '/proposal', { method: 'POST', body: fd })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            btn.disabled = false; btn.textContent = 'Lưu NCC';
                            if (data.ok) {
                                var sel = document.getElementById('supplierId');
                                var exists = false;
                                for (var i = 0; i < sel.options.length; i++) {
                                    if (sel.options[i].value == data.id) { exists = true; break; }
                                }
                                if (!exists) {
                                    var opt = document.createElement('option');
                                    opt.value = data.id; opt.text = data.name;
                                    opt.setAttribute('data-phone', data.phone || '');
                                    opt.setAttribute('data-email', '');
                                    opt.setAttribute('data-company', '');
                                    sel.appendChild(opt);
                                }
                                sel.value = data.id;
                                closeNewSupplierModal();
                                if (typeof toast !== 'undefined') {
                                    toast(data.existing
                                        ? 'SĐT đã có NCC: ' + data.name + ' — đã tự chọn.'
                                        : 'Đã thêm NCC "' + data.name + '"', data.existing ? 'info' : 'success');
                                }
                            } else {
                                var err = document.getElementById('supModalError');
                                err.textContent = data.error || 'Lỗi không xác định';
                                err.classList.add('show');
                            }
                        }).catch(function () {
                            btn.disabled = false; btn.textContent = 'Lưu NCC';
                            var err = document.getElementById('supModalError');
                            err.textContent = 'Lỗi kết nối máy chủ';
                            err.classList.add('show');
                        });
                };

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        closeNewGeneratorModal();
                        closeNewSupplierModal();
                    }
                });
            })();
        </script>
    </body>
</html>
