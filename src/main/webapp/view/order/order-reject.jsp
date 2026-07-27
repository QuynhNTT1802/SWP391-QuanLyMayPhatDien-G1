<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Từ chối đơn hàng — Warehouse OS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-reject.css">
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>
        <div style="flex: 1; display: flex; flex-direction: column;">
<header class="topbar">
            <h1>Xác nhận từ chối</h1>
            <jsp:include page="../common/admin/bell.jsp"/>
        </header>
            
            <main>
                <div class="card">
                    <h3>Từ chối đơn hàng</h3>
                    <p>Vui lòng cung cấp lý do từ chối để nhân viên kinh doanh được biết. Lý do này sẽ được hiển thị trong lịch sử đơn hàng.</p>
                    
                    <form method="post" action="${pageContext.request.contextPath}/order?action=reject">
                        <input type="hidden" name="orderId" value="${orderId}" />
                        
                        <div style="margin-bottom: 16px;">
                            <label for="reason">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                            <textarea id="reason" name="rejectReason" required placeholder="Ví dụ: Khách hàng không liên lạc được, Giá không phù hợp..."></textarea>
                        </div>

                        <div class="btn-group">
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                            <a href="${pageContext.request.contextPath}/order" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
