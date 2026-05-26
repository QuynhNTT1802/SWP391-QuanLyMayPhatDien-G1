<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa đơn hàng — Warehouse OS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        :root {
            --bg: #f8fafc; --card-bg: #ffffff; --text: #0f172a; --muted: #64748b;
            --border: #e2e8f0; --accent: #3b82f6; --accent-hover: #2563eb;
            --radius: 8px;
        }
        body { margin: 0; font-family: 'Inter', system-ui, sans-serif; background: var(--bg); color: var(--text); }
        .app { display: flex; min-height: 100vh; }
        main { flex: 1; padding: 24px; }
        
        .topbar { background: var(--card-bg); padding: 16px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; }
        .topbar h1 { margin: 0; font-size: 20px; font-weight: 700; }
        .crumb { font-size: 13px; color: var(--muted); }
        .crumb a { color: var(--accent); text-decoration: none; }

        .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 24px; box-shadow: 0 1px 2px rgba(0,0,0,0.05); margin-bottom: 24px; }
        .card h3 { margin: 0 0 16px 0; font-size: 16px; font-weight: 600; border-bottom: 1px solid var(--border); padding-bottom: 12px; }
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: span 2; }
        
        label { font-size: 13px; font-weight: 500; color: var(--muted); }
        input, textarea { padding: 10px 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px; outline: none; transition: 0.2s; background: #fff; color: var(--text); width: 100%; box-sizing: border-box; }
        input:focus, textarea:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(59,130,246,0.1); }
        input[readonly] { background: #f1f5f9; color: var(--muted); cursor: not-allowed; }
        
        .btn-group { display: flex; gap: 12px; margin-top: 8px; }
        .btn { padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; transition: 0.2s; display: inline-flex; align-items: center; justify-content: center; }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: var(--accent-hover); }
        .btn-secondary { background: #f1f5f9; color: var(--text); border-color: var(--border); }
        .btn-secondary:hover { background: #e2e8f0; }
        
        .error-msg { background: #fee2e2; color: #b91c1c; padding: 12px; border-radius: 6px; margin-bottom: 16px; border: 1px solid #fecaca; }
    </style>
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>
        <div style="flex: 1; display: flex; flex-direction: column;">
            <header class="topbar">
                <h1>Chỉnh sửa đơn hàng</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/order">Đơn hàng</a> / Sửa</span>
            </header>
            
            <main>
                <c:if test="${not empty error}">
                    <div class="error-msg"><c:out value="${error}"/></div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/order?action=update">
                    <input type="hidden" name="orderId" value="${order.orderId}" />
                    
                    <div class="card">
                        <h3>Thông tin khách hàng</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Tên khách hàng *</label>
                                <input type="text" name="customerName" value="${order.customerName}" required />
                            </div>
                            <div class="form-group">
                                <label>Số điện thoại *</label>
                                <input type="text" name="customerPhone" value="${order.customerPhone}" required />
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="customerEmail" value="${order.customerEmail}" />
                            </div>
                            <div class="form-group">
                                <label>Địa chỉ</label>
                                <input type="text" name="customerAddress" value="${order.customerAddress}" />
                            </div>
                            <div class="form-group">
                                <label>Mã số thuế</label>
                                <input type="text" name="customerTaxCode" value="${order.customerTaxCode}" />
                            </div>
                            <div class="form-group">
                                <label>Tên công ty</label>
                                <input type="text" name="customerCompany" value="${order.customerCompany}" />
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h3>Thông tin đơn hàng</h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Mã đơn hàng</label>
                                <input type="text" name="orderCode" value="${order.orderCode}" readonly />
                            </div>
                            <div class="form-group full">
                                <label>Ghi chú khách hàng</label>
                                <textarea name="customerNote" rows="3">${order.customerNote}</textarea>
                            </div>
                            <div class="form-group full">
                                <label>Ghi chú nội bộ</label>
                                <textarea name="internalNote" rows="2">${order.note}</textarea>
                            </div>
                        </div>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">Cập nhật thay đổi</button>
                        <a href="${pageContext.request.contextPath}/order" class="btn btn-secondary">Hủy bỏ</a>
                    </div>
                </form>
            </main>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
