<%-- 
    Document   : receipt-detail
    Created on : May 27, 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết phiếu — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/role/rbac-role-edit.css">
    <style>
        .detail-header { display: flex; justify-content: space-between; align-items: flex-start;
            flex-wrap: wrap; gap: 16px; margin-bottom: 24px; }
        .detail-header h2 { margin: 0; font-size: 20px; }
        .status-pill { display: inline-flex; align-items: center; gap: 6px;
            padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .status-pill::before { content: ''; width: 8px; height: 8px; border-radius: 50%; }
        .status-pending { background: var(--warn-soft); color: var(--warn); }
        .status-pending::before { background: var(--warn); }
        .status-completed { background: var(--accent-soft); color: var(--accent); }
        .status-completed::before { background: var(--accent); }
        .status-cancelled { background: var(--danger-soft); color: var(--danger); }
        .status-cancelled::before { background: var(--danger); }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px; margin-bottom: 24px; }
        .info-item .info-label { font-size: 11px; text-transform: uppercase; letter-spacing: 0.5px;
            color: var(--muted); font-weight: 600; margin-bottom: 2px; }
        .info-item .info-value { font-size: 14px; font-weight: 500; color: var(--fg); }
        .detail-table { width: 100%; border-collapse: collapse; margin-bottom: 24px; }
        .detail-table th { text-align: left; padding: 10px 12px; font-size: 12px;
            font-weight: 600; color: var(--muted); border-bottom: 1px solid var(--border);
            text-transform: uppercase; letter-spacing: 0.5px; background: var(--surface-2); }
        .detail-table td { padding: 10px 12px; border-bottom: 1px solid var(--border); font-size: 13px; }
        .action-bar { display: flex; gap: 12px; align-items: center; margin-top: 24px;
            padding: 16px; background: var(--surface-2); border-radius: var(--radius); }
        .action-bar form { display: inline-flex; gap: 8px; align-items: center; }
        .action-bar input { padding: 7px 10px; border: 1px solid var(--border);
            border-radius: var(--radius-sm); background: var(--bg); color: var(--fg);
            font-size: 13px; font-family: var(--font-ui); min-width: 200px; }
        .btn-danger { background: var(--danger); color: white; border: none; }
        .btn-danger:hover { filter: brightness(1.1); }
        .note-block { margin-bottom: 24px; padding: 12px 16px; background: var(--surface-2);
            border-radius: var(--radius); font-size: 13px; color: var(--fg-soft); white-space: pre-wrap; }
        .note-block .note-label { font-weight: 600; color: var(--fg); margin-bottom: 4px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar topbar-edit">
            <a href="${pageContext.request.contextPath}/receipt" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại
            </a>
            <div class="topbar-info">
                <h1>${receipt.receiptCode}</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/receipt">Phiếu nhập/xuất</a> / Chi tiết</span>
            </div>
        </header>

        <main>
            <c:if test="${not empty param.msg}">
                <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:16px;font-weight:600;font-size:13px;">
                    <c:choose>
                        <c:when test="${param.msg == 'approved'}">Đã duyệt phiếu thành công.</c:when>
                        <c:when test="${param.msg == 'rejected'}">Đã từ chối phiếu.</c:when>
                        <c:otherwise>${param.msg}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 30%,transparent);border-radius:var(--radius);padding:10px 16px;margin-bottom:16px;font-size:13px;font-weight:600;">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <div class="detail-header">
                <div>
                    <div class="eyebrow" style="margin-bottom:4px;">Phiếu nhập/xuất kho</div>
                    <h2>${receipt.receiptCode}</h2>
                </div>
                <c:choose>
                    <c:when test="${receipt.status == 'PENDING_RECONCILIATION'}">
                        <span class="status-pill status-pending">Chờ duyệt</span>
                    </c:when>
                    <c:when test="${receipt.status == 'COMPLETED'}">
                        <span class="status-pill status-completed">Hoàn thành</span>
                    </c:when>
                    <c:when test="${receipt.status == 'CANCELLED'}">
                        <span class="status-pill status-cancelled">Đã từ chối</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-pill">${receipt.status}</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Loại phiếu</div>
                    <div class="info-value">${receipt.receiptType == 'IMPORT' ? 'Nhập kho' : 'Xuất kho'}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Kho</div>
                    <div class="info-value">${receipt.warehouseName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Người tạo</div>
                    <div class="info-value">${receipt.createdByName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Ngày tạo</div>
                    <div class="info-value">${receipt.createdAt}</div>
                </div>
                <c:if test="${not empty receipt.orderCode}">
                    <div class="info-item">
                        <div class="info-label">Đơn hàng</div>
                        <div class="info-value">${receipt.orderCode} — ${receipt.customerName}</div>
                    </div>
                </c:if>
                <c:if test="${not empty receipt.approvedByName}">
                    <div class="info-item">
                        <div class="info-label">Người duyệt</div>
                        <div class="info-value">${receipt.approvedByName}</div>
                    </div>
                </c:if>
                <c:if test="${not empty receipt.approvedAt}">
                    <div class="info-item">
                        <div class="info-label">Ngày duyệt</div>
                        <div class="info-value">${receipt.approvedAt}</div>
                    </div>
                </c:if>
            </div>

            <c:if test="${not empty receipt.note}">
                <div class="note-block">
                    <div class="note-label">Ghi chú</div>
                    ${receipt.note}
                </div>
            </c:if>

            <div class="section">
                <div class="section-head"><h3>Chi tiết dòng hàng</h3></div>
                <div class="section-body" style="padding: 0;">
                    <table class="detail-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Máy phát</th>
                                <th>Serial</th>
                                <th>Số lượng</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty receipt.details}">
                                    <tr><td colspan="5" style="text-align:center;color:var(--muted);padding:24px;">Không có dòng hàng nào</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="d" items="${receipt.details}" varStatus="st">
                                        <tr>
                                            <td>${st.index + 1}</td>
                                            <td><strong>${d.generatorModel}</strong> <span style="color:var(--muted);">${d.generatorBrand}</span></td>
                                            <td>${d.serialNumber}</td>
                                            <td>${d.quantity}</td>
                                            <td>${d.note}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <c:if test="${receipt.status == 'PENDING_RECONCILIATION' && isManager}">
                <div class="action-bar">
                    <form method="POST" action="${pageContext.request.contextPath}/receipt?action=approve">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận duyệt phiếu này? Hệ thống sẽ cập nhật tồn kho.')">
                            <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                            Duyệt phiếu
                        </button>
                    </form>
                    <form method="POST" action="${pageContext.request.contextPath}/receipt?action=reject">
                        <input type="hidden" name="id" value="${receipt.receiptId}" />
                        <input type="text" name="reason" placeholder="Lý do từ chối..." required />
                        <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận từ chối phiếu này?')">
                            <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                            Từ chối
                        </button>
                    </form>
                </div>
            </c:if>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
