<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Từ chối bởi CEO — Warehouse OS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        :root {
            --bg: #f8fafc; --card-bg: #ffffff; --text: #0f172a; --muted: #64748b;
            --border: #e2e8f0; --accent: #3b82f6; --danger: #ef4444; --danger-hover: #dc2626;
            --radius: 8px;
        }
        body { margin: 0; font-family: 'Inter', system-ui, sans-serif; background: var(--bg); color: var(--text); }
        .app { display: flex; min-height: 100vh; }
        main { flex: 1; padding: 24px; display: flex; justify-content: center; align-items: flex-start; padding-top: 60px; }

        .topbar { background: var(--card-bg); padding: 16px 24px; border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 12px; }
        .topbar h1 { margin: 0; font-size: 20px; font-weight: 700; }

        .card { background: var(--card-bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 32px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); width: 100%; max-width: 600px; }
        .card h3 { margin: 0 0 8px 0; font-size: 20px; font-weight: 700; color: var(--danger); }
        .card p { margin: 0 0 24px 0; color: var(--muted); font-size: 14px; }

        label { display: block; margin-bottom: 8px; font-weight: 500; font-size: 14px; }
        textarea { width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 14px; resize: vertical; min-height: 100px; box-sizing: border-box; }
        textarea:focus { outline: none; border-color: var(--danger); box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }

        .btn-group { display: flex; gap: 12px; margin-top: 24px; }
        .btn { padding: 12px 24px; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; border: none; transition: 0.2s; text-align: center; }
        .btn-danger { background: var(--danger); color: #fff; }
        .btn-danger:hover { background: var(--danger-hover); }
        .btn-secondary { background: #f1f5f9; color: var(--text); }
        .btn-secondary:hover { background: #e2e8f0; }
    </style>
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>
        <div style="flex: 1; display: flex; flex-direction: column;">
            <header class="topbar">
                <h1>Từ chối bởi CEO</h1>
            </header>

            <main>
                <div class="card">
                    <h3>Từ chối (CEO) phiếu mua ${po.poCode}</h3>
                    <p>Vui lòng cung cấp lý do từ chối. Lý do này sẽ được ghi vào các đề xuất gốc của sale staff.</p>

                    <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=reject">
                        <input type="hidden" name="id" value="${po.poId}"/>

                        <div style="margin-bottom: 16px;">
                            <label for="reason">Lý do từ chối <span style="color:var(--danger)">*</span></label>
                            <textarea id="reason" name="rejectReason" required placeholder="Ví dụ: Chưa đủ ngân sách tháng này, v.v..."></textarea>
                        </div>

                        <div class="btn-group">
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối (CEO)</button>
                            <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
