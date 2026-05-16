<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Quản lý yêu cầu cấp lại mật khẩu — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <style>
        [data-theme="dark"] {
            --bg: oklch(16% 0.012 250);
            --surface: oklch(20% 0.014 250);
            --surface-2: oklch(22% 0.014 250);
            --surface-3: oklch(24% 0.014 250);
            --fg: oklch(96% 0.005 240);
            --fg-soft: oklch(82% 0.008 240);
            --muted: oklch(65% 0.012 240);
            --muted-2: oklch(50% 0.012 240);
            --border: oklch(28% 0.014 240);
            --border-strong: oklch(36% 0.016 240);
            --accent: oklch(70% 0.18 145);
            --accent-soft: oklch(28% 0.06 145);
            --danger: oklch(68% 0.20 25);
            --danger-soft: oklch(28% 0.06 25);
            --warn: oklch(75% 0.16 75);
            --warn-soft: oklch(28% 0.06 75);
            --info: oklch(70% 0.15 250);
            --info-soft: oklch(28% 0.05 250);
            --purple: oklch(72% 0.16 295);
            --purple-soft: oklch(28% 0.06 295);
        }

        main { padding: 20px 24px 60px; }
        .page-head { margin-bottom: 18px; }
        .page-head .left { flex: 1; }
        .eyebrow { font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); margin-bottom: 6px; display: inline-flex; align-items: center; gap: 6px; }
        .eyebrow::before { content: ''; width: 5px; height: 5px; border-radius: 50%; background: var(--accent); }
        .page-title { font-size: 22px; font-weight: 700; letter-spacing: -0.02em; margin: 0 0 4px; }
        .page-sub { font-size: 13px; color: var(--muted); font-weight: 500; }

        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 18px; }
        .stat { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); padding: 10px 14px; }
        .stat .lbl { font-size: 11px; color: var(--muted); font-weight: 600; letter-spacing: 0.02em; }
        .stat .val { font-family: var(--font-mono); font-size: 20px; font-weight: 700; letter-spacing: -0.02em; line-height: 1.2; margin-top: 4px; }

        .table-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        table.users { width: 100%; border-collapse: collapse; font-size: 13px; }
        table.users th, table.users td { text-align: start; padding: 11px 14px; border-bottom: 1px solid var(--border); }
        table.users th {
            font-size: 11px; font-weight: 700; color: var(--muted); text-transform: uppercase;
            letter-spacing: 0.04em; background: var(--surface-2);
            border-bottom: 1px solid var(--border-strong);
            position: sticky; top: 0; z-index: 1;
        }
        table.users tbody tr:hover { background: var(--surface-2); }

        .status { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; }
        .status .sdot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
        .status.pending .sdot { background: var(--warn); }
        .status.pending { color: var(--warn); }
        .status.approved .sdot { background: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .status.approved { color: var(--fg); }

        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            border: 1px solid var(--border); background: var(--surface); color: var(--fg);
            padding: 7px 12px; border-radius: var(--radius-sm); font-size: 13px;
            font-weight: 600; cursor: pointer; font-family: var(--font-ui);
            transition: background .12s ease;
        }
        .btn:hover { background: var(--surface-2); }
        .btn-primary { background: var(--fg); color: var(--bg); border-color: var(--fg); }
        .btn-primary:hover { background: var(--fg-soft); border-color: var(--fg-soft); }
        .action-group { display: flex; gap: 6px; }

        .modal-host {
            position: fixed; inset: 0; background: oklch(0% 0 0 / 0.4); z-index: 50;
            display: none; align-items: center; justify-content: center; padding: 20px;
        }
        .modal-host.open { display: flex; }
        .modal {
            background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius);
            width: 100%; max-width: 420px; padding: 22px 22px 18px; box-shadow: var(--shadow-md);
        }
        .modal h3 { font-size: 16px; font-weight: 700; margin: 0 0 6px; }
        .modal p { font-size: 13px; color: var(--muted); margin: 0 0 16px; line-height: 1.5; }
        .modal .form-group { margin-bottom: 14px; }
        .modal .form-group label { display: block; font-size: 12px; font-weight: 600; margin-bottom: 4px; color: var(--fg-soft); }
        .modal .form-group input,
        .modal .form-group textarea {
            width: 100%; padding: 8px 10px; border: 1px solid var(--border);
            background: var(--surface-2); color: var(--fg); border-radius: var(--radius-sm);
            font-size: 13px; font-family: var(--font-ui); font-weight: 500;
        }
        .modal .form-group textarea { resize: none; height: 80px; }
        .modal .form-group input:focus,
        .modal .form-group textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px var(--accent-soft); }
        .modal .actions { display: flex; gap: 8px; justify-content: flex-end; }
        .btn-cancel { background: var(--surface-2); border-color: var(--border); }
        .btn-cancel:hover { background: var(--surface-3); }

        .empty-state {
            padding: 60px 20px; text-align: center; color: var(--muted); font-size: 13px;
        }
        .empty-state strong { display: block; color: var(--fg); font-size: 14px; font-weight: 700; margin-bottom: 4px; }

        .toast-host { position: fixed; bottom: 24px; inset-inline-end: 24px; z-index: 60; display: flex; flex-direction: column; gap: 8px; }
        .toast {
            background: var(--fg); color: var(--bg); padding: 10px 14px; border-radius: var(--radius);
            font-size: 13px; font-weight: 600; box-shadow: var(--shadow-md);
            display: flex; align-items: center; gap: 10px;
            transform: translateY(8px); opacity: 0; transition: all .2s ease;
        }
        .toast.show { transform: translateY(0); opacity: 1; }
        .toast.success { background: var(--accent); color: var(--bg); }
        .toast.danger { background: var(--danger); color: var(--bg); }
        .toast svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 2.2; }

        @media (max-width: 760px) {
            .app { grid-template-columns: 1fr; }
            aside.sidebar { display: none; }
            main { padding: 16px; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/dashboard/aside.jsp" />

    <div>
        <header class="topbar">
            <h1>Quên mật khẩu</h1>
            <span class="crumb">/ <a href="#">Quản trị</a> / Yêu cầu cấp lại mật khẩu</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Quản trị · Admin</div>
                    <h2 class="page-title">Quản lý yêu cầu cấp lại mật khẩu</h2>
                    <div class="page-sub">Admin xử lý yêu cầu từ người dùng</div>
                </div>
            </div>

            <div class="stats-row">
                <div class="stat"><div class="lbl">Tổng yêu cầu</div><div class="val">${totalRequests}</div></div>
                <div class="stat"><div class="lbl">Đang chờ xử lý</div><div class="val">${pendingList.size()}</div></div>
                <div class="stat"><div class="lbl">Đã cấp lại</div><div class="val">${doneRequests}</div></div>
            </div>

            <div class="table-card">
                <table class="users">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Trạng thái</th>
                            <th>Ngày gửi</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listRequests}" var="req">
                            <tr>
                                <td>#FP${req.id}</td>
                                <td>${req.username}</td>
                                <td>
                                    <span class="status ${req.status}">
                                        <span class="sdot"></span>
                                        <c:choose>
                                            <c:when test="${req.status == 'pending'}">Chờ xử lý</c:when>
                                            <c:when test="${req.status == 'approved'}">Đã cấp lại</c:when>
                                            <c:otherwise>${req.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>${req.createdAt}</td>
                                <td>
                                    <div class="action-group">
                                        <c:if test="${req.status == 'pending'}">
                                            <button class="btn btn-primary"
                                                    onclick="openResetModal(${req.id}, '${req.username}')">
                                                Cấp lại
                                            </button>
                                        </c:if>
                                        <c:if test="${req.status != 'pending'}">
                                            <button class="btn"
                                                    onclick="openDetailModal('${req.username}', '${req.status}', '${req.newPassword}', '${req.note}', '${req.processedAt}')">
                                                Chi tiết
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listRequests}">
                            <tr>
                                <td colspan="5" class="empty-state">
                                    <strong>Không có yêu cầu nào</strong>
                                    Chưa có người dùng nào gửi yêu cầu cấp lại mật khẩu
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<div class="modal-host" id="resetModal">
    <div class="modal">
        <h3>Cấp lại mật khẩu</h3>
        <p>Nhập mật khẩu mới cho người dùng bên dưới.</p>
        <form action="${pageContext.request.contextPath}/admin/forgot-password" method="post">
            <input type="hidden" name="requestId" id="requestId">
            <div class="form-group">
                <label>Username</label>
                <input type="text" id="resetUsername" readonly>
            </div>
            <div class="form-group">
                <label>Mật khẩu mới</label>
                <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới..." required>
            </div>
            <div class="form-group">
                <label>Ghi chú cho người dùng</label>
                <textarea name="note" placeholder="Ví dụ: vui lòng đổi mật khẩu sau lần đăng nhập đầu tiên"></textarea>
            </div>
            <div class="actions">
                <button type="button" class="btn btn-cancel" onclick="closeResetModal()">Huỷ</button>
                <button type="submit" class="btn btn-primary">Xác nhận cấp lại</button>
            </div>
        </form>
    </div>
</div>

<div class="modal-host" id="detailModal">
    <div class="modal">
        <h3>Chi tiết yêu cầu</h3>
        <p>Thông tin yêu cầu cấp lại mật khẩu.</p>
        <div class="form-group">
            <label>Username</label>
            <input type="text" id="detailUsername" readonly>
        </div>
        <div class="form-group">
            <label>Trạng thái</label>
            <input type="text" id="detailStatus" readonly>
        </div>
        <div class="form-group">
            <label>Mật khẩu đã cấp</label>
            <input type="text" id="detailNewPassword" readonly>
        </div>
        <div class="form-group">
            <label>Ghi chú</label>
            <textarea id="detailNote" readonly></textarea>
        </div>
        <div class="form-group">
            <label>Ngày xử lý</label>
            <input type="text" id="detailProcessedAt" readonly>
        </div>
        <div class="actions">
            <button type="button" class="btn btn-cancel" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>

<c:if test="${not empty sessionScope.message}">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            toast('${sessionScope.message}', 'success');
        });
    </script>
    <c:remove var="message" scope="session" />
</c:if>
<c:if test="${not empty sessionScope.error}">
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            toast('${sessionScope.error}', 'danger');
        });
    </script>
    <c:remove var="error" scope="session" />
</c:if>

<script>
    const resetModal = document.getElementById("resetModal");
    const detailModal = document.getElementById("detailModal");

    function openResetModal(id, username) {
        resetModal.classList.add("open");
        document.getElementById("requestId").value = id;
        document.getElementById("resetUsername").value = username;
    }

    function closeResetModal() {
        resetModal.classList.remove("open");
    }

    function openDetailModal(username, status, newPassword, note, processedAt) {
        detailModal.classList.add("open");
        document.getElementById("detailUsername").value = username;
        document.getElementById("detailStatus").value = status === 'approved' ? 'Đã cấp lại' : status;
        document.getElementById("detailNewPassword").value = newPassword || '';
        document.getElementById("detailNote").value = note || '';
        document.getElementById("detailProcessedAt").value = processedAt || '';
    }

    function closeDetailModal() {
        detailModal.classList.remove("open");
    }

    window.onclick = function (e) {
        if (e.target === resetModal) closeResetModal();
        if (e.target === detailModal) closeDetailModal();
    }

    function toast(msg, type) {
        const host = document.getElementById("toastHost");
        const el = document.createElement("div");
        el.className = "toast " + (type || "");
        el.innerHTML = '<svg viewBox="0 0 24 24"><' + (type === 'success' ? 'path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="M22 4L12 14.01l-3-3"/>' : 'circle cx="12" cy="12" r="10"/><path d="M15 9l-6 6M9 9l6 6"/>') + '</svg>' + msg;
        host.appendChild(el);
        requestAnimationFrame(() => el.classList.add("show"));
        setTimeout(() => { el.classList.remove("show"); setTimeout(() => el.remove(), 200); }, 3000);
    }
</script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    (function() {
        const btn = document.getElementById('themeToggle');
        if (!btn) return;
        const html = document.documentElement;
        btn.addEventListener('click', function() {
            const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            try { localStorage.setItem('theme', next); } catch(e) {}
        });
        try {
            const saved = localStorage.getItem('theme');
            if (saved) html.setAttribute('data-theme', saved);
        } catch(e) {}
    })();
</script>
</body>
</html>
