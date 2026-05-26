<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết đơn hàng — Warehouse OS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        :root {
            --bg: #f8fafc; --card-bg: #ffffff; --text: #0f172a; --muted: #64748b;
            --border: #e2e8f0; --accent: #3b82f6; --radius: 8px;
            --success: #10b981; --warning: #f59e0b; --danger: #ef4444;
        }
        body { margin: 0; font-family: 'Inter', system-ui, sans-serif; background: var(--bg); color: var(--text); }
        .app { display: flex; min-height: 100vh; }
        main { flex: 1; padding: 24px; }
        
        .topbar { background: var(--card-bg); padding: 16px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; }
        .topbar h1 { margin: 0; font-size: 20px; font-weight: 700; }
        .crumb { font-size: 13px; color: var(--muted); }
        .crumb a { color: var(--accent); text-decoration: none; }

        .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 24px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 24px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 12px; }
        .card-header h3 { margin: 0; font-size: 16px; font-weight: 600; }
        
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
        .info-item { margin-bottom: 12px; }
        .info-label { font-size: 12px; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .info-value { font-size: 15px; font-weight: 500; }

        /* Status Badges */
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; }
        .badge-pending { background: #fef3c7; color: #b45309; }
        .badge-approved { background: #d1fae5; color: #047857; }
        .badge-rejected { background: #fee2e2; color: #b91c1c; }
        .badge-cancelled { background: #f3f4f6; color: #4b5563; }

        /* Table */
        table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid var(--border); }
        th { font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600; background: #f9fafb; }
        td { font-size: 14px; }
        .text-right { text-align: right; }
        .total-row { font-size: 18px; font-weight: 700; color: var(--accent); }

        .btn { padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; transition: 0.2s; display: inline-flex; align-items: center; justify-content: center; background: #f1f5f9; color: var(--text); border-color: var(--border); }
        .btn:hover { background: #e2e8f0; }
    </style>
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>
        <div style="flex: 1; display: flex; flex-direction: column;">
            <header class="topbar">
                <h1>Chi tiết đơn hàng</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/order">Đơn hàng</a> / ${order.orderCode}</span>
            </header>
            
            <main>
                <div class="card">
                    <div class="card-header">
                        <h3>Thông tin chung</h3>
                        <c:choose>
                            <c:when test="${order.status == 'PENDING'}"><span class="badge badge-pending">Chờ duyệt</span></c:when>
                            <c:when test="${order.status == 'APPROVED'}"><span class="badge badge-approved">Đã duyệt</span></c:when>
                            <c:when test="${order.status == 'REJECTED'}"><span class="badge badge-rejected">Từ chối</span></c:when>
                            <c:otherwise><span class="badge badge-cancelled">Đã hủy</span></c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="info-grid">
                        <div>
                            <h4 style="margin: 0 0 12px 0; color: var(--accent);">Khách hàng</h4>
                            <div class="info-item"><div class="info-label">Họ tên</div><div class="info-value">${order.customerName}</div></div>
                            <div class="info-item"><div class="info-label">Số điện thoại</div><div class="info-value">${order.customerPhone}</div></div>
                            <div class="info-item"><div class="info-label">Email</div><div class="info-value">${order.customerEmail}</div></div>
                            <div class="info-item"><div class="info-label">Địa chỉ</div><div class="info-value">${order.customerAddress}</div></div>
                            <c:if test="${not empty order.customerCompany}">
                                <div class="info-item"><div class="info-label">Công ty</div><div class="info-value">${order.customerCompany}</div></div>
                            </c:if>
                        </div>
                        <div>
                            <h4 style="margin: 0 0 12px 0; color: var(--accent);">Xử lý đơn hàng</h4>
                            <div class="info-item"><div class="info-label">Ngày đặt</div><div class="info-value"><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></div></div>
                            <div class="info-item"><div class="info-label">Người tạo</div><div class="info-value">ID: ${order.createdBy}</div></div>
                            <c:if test="${order.approvedBy != 0}">
                                <div class="info-item"><div class="info-label">Người duyệt</div><div class="info-value">ID: ${order.approvedBy}</div></div>
                            </c:if>
                            <c:if test="${not empty order.rejectReason}">
                                <div class="info-item"><div class="info-label" style="color: var(--danger);">Lý do từ chối</div><div class="info-value" style="color: var(--danger);">${order.rejectReason}</div></div>
                            </c:if>
                            <c:if test="${not empty order.note}">
                                <div class="info-item"><div class="info-label">Ghi chú nội bộ</div><div class="info-value">${order.note}</div></div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3>Sản phẩm đã đặt</h3>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Tên sản phẩm / Mã</th>
                                <th style="width: 80px;">SL</th>
                                <th class="text-right">Đơn giá</th>
                                <th class="text-right">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${details}">
                                <tr>
                                    <td>Máy phát điện (ID: ${d.generatorId})</td>
                                    <td>${d.quantity}</td>
                                    <td class="text-right"><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                    <td class="text-right"><fmt:formatNumber value="${d.quantity * d.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty details}">
                                <tr><td colspan="4" style="text-align: center; padding: 20px; color: var(--muted);">Chưa có sản phẩm nào trong đơn hàng.</td></tr>
                            </c:if>
                            <c:if test="${not empty details}">
                                <tr>
                                    <td colspan="3" class="text-right total-row">Tổng cộng:</td>
                                    <td class="text-right total-row"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <a href="${pageContext.request.contextPath}/order" class="btn">← Quay lại danh sách</a>
            </main>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
