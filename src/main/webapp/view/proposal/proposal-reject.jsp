<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>Từ chối - Warehouse OS</title>
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
                max-width:760px;
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
                margin:0;
                display:flex;
                align-items:center;
                gap:10px;
                flex-wrap:wrap
            }
            .page-head .lede{
                color:var(--muted);
                margin-top:6px;
                max-width:640px;
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
            .info-grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:14px 20px
            }
            .info-field .info-label{
                font-size:11px;
                color:var(--muted);
                font-weight:600;
                text-transform:uppercase;
                letter-spacing:0.02em;
                margin-bottom:4px
            }
            .info-field .info-value{
                font-size:14px;
                color:var(--fg);
                font-weight:600
            }
            .info-field .info-value.mono{
                font-family:var(--font-mono);
                font-weight:500
            }
            .info-field .info-value.empty{
                color:var(--muted);
                font-style:italic;
                font-weight:500
            }
            .pill{
                display:inline-flex;
                align-items:center;
                gap:5px;
                font-size:11.5px;
                font-weight:600;
                padding:2px 9px;
                border-radius:999px;
                border:1px solid;
                font-family:var(--font-ui)
            }
            .pill .pdot{
                width:5px;
                height:5px;
                border-radius:50%;
                background:currentColor
            }
            .pill.pending{
                color:var(--warn);
                border-color:color-mix(in srgb,var(--warn) 30%,transparent);
                background:var(--warn-soft)
            }
            table.detail-table{
                width:100%;
                border-collapse:separate;
                border-spacing:0;
                font-size:13px
            }
            table.detail-table thead th{
                text-align:left;
                font-size:11px;
                color:var(--muted);
                text-transform:uppercase;
                font-weight:700;
                background:var(--surface-2);
                padding:10px 12px;
                border-bottom:1px solid var(--border);
                letter-spacing:0.04em
            }
            table.detail-table tbody td{
                padding:10px 12px;
                border-bottom:1px solid var(--border);
                vertical-align:middle
            }
            table.detail-table tbody tr:last-child td{
                border-bottom:0
            }
            .text-right{
                text-align:right
            }
            .text-center{
                text-align:center
            }
            .col-num{
                width:40px;
                text-align:center;
                color:var(--muted);
                font-weight:600
            }
            .col-qty{
                width:90px;
                text-align:right
            }
            .col-brand{
                width:140px
            }
            .field{
                display:flex;
                flex-direction:column;
                gap:6px;
                margin-top:12px
            }
            .field-label{
                font-size:12px;
                font-weight:600;
                color:var(--muted);
                text-transform:uppercase;
                letter-spacing:0.04em;
                display:flex;
                align-items:center;
                justify-content:space-between
            }
            .field-label .req{
                color:var(--danger);
                margin-inline-start:2px
            }
            .input{
                font-family:var(--font-ui);
                font-size:14px;
                color:var(--fg);
                background:var(--surface);
                border:1px solid var(--border);
                border-radius:var(--radius-sm);
                padding:9px 12px;
                width:100%;
                line-height:1.4;
                box-sizing:border-box
            }
            .input:focus{
                outline:none;
                border-color:var(--accent);
                box-shadow:0 0 0 3px var(--accent-soft)
            }
            textarea.input{
                min-height:110px;
                resize:vertical
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
            .btn-danger{
                color:var(--danger);
                border-color:color-mix(in srgb,var(--danger) 30%,transparent)
            }
            .btn-danger:hover{
                background:var(--danger-soft)
            }
            .form-actions{
                display:flex;
                gap:10px;
                justify-content:flex-end;
                margin-top:18px
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
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
                <div>
                    <header class="topbar">
                        <h1>Từ chối</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}"><c:out value="${proposal.proposalCode}"/></a> / Từ chối</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Quay lại chi tiết</a>
                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Từ chối</div>
                        <h1 class="title">
                            <span>Từ chối phiếu đề xuất</span>
                            <span class="pill pending"><span class="pdot"></span>Chờ duyệt</span>
                        </h1>
                        <div class="lede">Phiếu <c:out value="${proposal.proposalCode}"/> - vui lòng xem lại chi tiết và nhập lý do từ chối.</div>
                    </div>
                    <div class="section">
                        <div class="section-head"><h3>Thông tin phiếu</h3><span class="sub">Read-only</span></div>
                        <div class="section-body">
                            <div class="info-grid">
                                <div class="info-field">
                                    <div class="info-label">Mã phiếu</div>
                                    <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Người tạo</div>
                                    <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Ngày tạo</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${proposal.proposalDate == null}"><span class="empty">—</span></c:when>
                                            <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Kho nhập</div>
                                    <div class="info-value"><c:out value="${proposal.warehouseName}"/></div>
                                </div>
                                <div class="info-field" style="grid-column:1/-1">
                                    <div class="info-label">Ghi chú của nhân viên</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${empty proposal.note}"><span class="empty">—</span></c:when>
                                            <c:otherwise><c:out value="${proposal.note}"/></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="section">
                        <div class="section-head"><h3>Chi tiết máy phát đề xuất</h3><span class="sub"><c:out value="${fn:length(proposal.details)}"/> dòng</span></div>
                        <div class="section-body" style="padding:0">
                            <table class="detail-table">
                                <thead>
                                    <tr>
                                        <th class="col-num">#</th>
                                        <th>Mã máy</th>
                                        <th>Tên máy</th>
                                        <th class="col-brand">Thương hiệu</th>
                                        <th class="col-qty">Số lượng</th>
                                        <th class="col-qty">Tồn kho HT</th>
                                        <th>Ghi chú dòng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty proposal.details}">
                                            <tr><td colspan="7" class="text-center" style="padding:18px;color:var(--muted)">Không có dòng chi tiết nào.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                <tr>
                                                    <td class="col-num">${st.count}</td>
                                                    <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                    <td><c:out value="${d.generatorName}"/></td>
                                                    <td><c:out value="${d.brandName}"/></td>
                                                    <td class="col-qty mono"><c:out value="${d.quantity}"/></td>
                                                    <td class="col-qty mono"><c:out value="${d.currentStock}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty d.note}"><span class="empty">—</span></c:when>
                                                            <c:otherwise><c:out value="${d.note}"/></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <form class="section" method="post" action="${pageContext.request.contextPath}/proposal?action=reject" onsubmit="return validateRejectForm();">
                        <div class="section-head"><h3>Lý do từ chối</h3><span class="sub">Bắt buộc</span></div>
                        <div class="section-body">
                            <div class="alert alert-warn">
                                <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                <span><strong>Hành động này không thể hoàn tác.</strong> Phiếu sẽ chuyển sang trạng thái "Từ chối" và nhân viên tạo sẽ nhận được thông báo.</span>
                            </div>
                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                            <div class="field">
                                <label class="field-label" for="rejectReason">Lý do từ chối <span class="req">*</span></label>
                                <textarea class="input" id="rejectReason" name="rejectReason" rows="5" required placeholder="VD: Số lượng đề xuất vượt quá nhu cầu thực tế tại kho HCM tháng này..."></textarea>
                            </div>
                            <div class="form-actions">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Quay lại</a>
                                <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                            </div>
                        </div>
                    </form>
                </main>
            </div>
        </div>
        <script>
            function validateRejectForm() {
                var reason = document.getElementById('rejectReason').value.trim();
                if (reason.length < 5) {
                    alert('Vui lòng nhập lý do từ chối (tối thiểu 5 ký tự).');
                    document.getElementById('rejectReason').focus();
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>