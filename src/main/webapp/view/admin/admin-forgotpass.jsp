<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý cấp lại mật khẩu — Quản lý máy phát điện</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <style>
            main {
                padding: 20px 24px 100px;
                min-width: 0;
            }
            .stats-row {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 16px;
                margin-bottom: 20px;
            }
            .stat-card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                padding: 16px 20px;
            }
            .stat-label {
                font-size: 12px;
                color: var(--muted);
                font-weight: 600;
                letter-spacing: 0.02em;
                margin-bottom: 6px;
            }
            .stat-value {
                font-size: 26px;
                font-weight: 700;
                font-family: var(--font-mono);
                color: var(--fg);
                letter-spacing: -0.01em;
            }

            .card-table {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                overflow: hidden;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead {
                background: var(--surface-2);
            }
            th {
                padding: 11px 16px;
                text-align: left;
                font-size: 11.5px;
                font-weight: 700;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.03em;
                border-bottom: 1px solid var(--border);
            }
            td {
                padding: 12px 16px;
                border-bottom: 1px solid var(--border);
                font-size: 13px;
                color: var(--fg);
            }
            tbody tr:hover {
                background: var(--surface-2);
            }
            tbody tr:last-child td {
                border-bottom: 0;
            }
            .empty {
                text-align: center;
                padding: 40px 16px;
                color: var(--muted);
                font-weight: 500;
                font-size: 13px;
            }

            .pill {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 11.5px;
                font-weight: 600;
                padding: 2px 8px;
                border-radius: 999px;
                border: 1px solid;
            }
            .pill .pdot {
                width: 5px;
                height: 5px;
                border-radius: 50%;
            }
            .pill.pending {
                color: var(--warn);
                border-color: color-mix(in srgb, var(--warn) 30%, transparent);
                background: var(--warn-soft);
            }
            .pill.pending .pdot {
                background: var(--warn);
            }
            .pill.approved {
                color: var(--accent);
                border-color: color-mix(in srgb, var(--accent) 30%, transparent);
                background: var(--accent-soft);
            }
            .pill.approved .pdot {
                background: var(--accent);
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 14px;
                border-radius: var(--radius-sm);
                font-size: 12.5px;
                font-weight: 600;
                font-family: var(--font-ui);
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                cursor: pointer;
                transition: all .12s ease;
            }
            .btn:hover {
                background: var(--surface-2);
            }
            .btn-primary {
                background: var(--accent);
                color: var(--bg);
                border-color: var(--accent);
            }
            .btn-primary:hover {
                background: color-mix(in srgb, var(--accent) 88%, white);
            }
            .actions {
                display: flex;
                gap: 8px;
            }

            .alert {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 14px;
                border-radius: var(--radius-sm);
                font-size: 13px;
                font-weight: 600;
                margin-bottom: 18px;
            }
            .alert svg {
                width: 16px;
                height: 16px;
                stroke: currentColor;
                fill: none;
                stroke-width: 2;
                flex-shrink: 0;
            }
            .alert-success {
                background: var(--accent-soft);
                color: var(--accent);
                border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
            }
            .alert-error {
                background: var(--danger-soft);
                color: var(--danger);
                border: 1px solid color-mix(in srgb, var(--danger) 30%, transparent);
            }

            .modal-host {
                position: fixed;
                inset: 0;
                background: oklch(0% 0 0 / 0.4);
                z-index: 50;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .modal-host.open {
                display: flex;
            }
            .modal {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: var(--radius);
                width: 100%;
                max-width: 440px;
                padding: 22px;
            }
            .modal h3 {
                font-size: 16px;
                font-weight: 700;
                margin: 0 0 4px;
            }
            .modal .sub {
                font-size: 12.5px;
                color: var(--muted);
                font-weight: 500;
                margin-bottom: 18px;
                line-height: 1.45;
            }
            .field {
                display: flex;
                flex-direction: column;
                gap: 5px;
                margin-bottom: 14px;
            }
            .field-label {
                font-size: 12px;
                color: var(--fg-soft);
                font-weight: 600;
            }
            .input, .modal textarea {
                width: 100%;
                border: 1px solid var(--border);
                background: var(--surface);
                color: var(--fg);
                border-radius: var(--radius-sm);
                padding: 9px 12px;
                font-size: 13.5px;
                font-family: var(--font-ui);
                font-weight: 500;
                transition: border-color .12s ease;
            }
            .input:focus, .modal textarea:focus {
                outline: none;
                border-color: var(--accent);
                box-shadow: 0 0 0 3px var(--accent-soft);
            }
            .input[readonly] {
                background: var(--surface-2);
                color: var(--muted);
                cursor: not-allowed;
            }
            .modal textarea {
                resize: none;
                height: 80px;
            }
            .modal .modal-actions {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
                margin-top: 18px;
            }

            @media (max-width: 760px) {
                .app {
                    grid-template-columns: 1fr;
                }
                aside.sidebar {
                    display: none;
                }
                main {
                    padding: 16px 16px 100px;
                }
                .stats-row {
                    grid-template-columns: 1fr;
                }
            }
            /* === FILTER TABS === */
            .filter-tabs {
                display: flex;
                gap: 8px;
                margin-bottom: 16px;
            }
            .filter-tab {
                padding: 7px 16px;
                border-radius: 999px;
                border: 1px solid var(--border);
                font-size: 12.5px;
                font-weight: 600;
                color: var(--muted);
                background: var(--surface);
                cursor: pointer;
                text-decoration: none;
            }
            .filter-tab.active {
                background: var(--fg);
                color: var(--bg);
                border-color: var(--fg);
            }
            /* === PAGINATION === */
            .pagination {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                padding: 14px 0;
                border-top: 1px solid var(--border);
            }
            .page-btn {
                min-width: 32px;
                height: 30px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border: 1px solid var(--border);
                border-radius: 6px;
                font-size: 12.5px;
                font-weight: 600;
                background: var(--surface);
                color: var(--fg);
                cursor: pointer;
                text-decoration: none;
                padding: 0 10px;
            }
            .page-btn.active {
                background: var(--fg);
                color: var(--bg);
                border-color: var(--fg);
            }
            .page-btn.disabled {
                opacity: 0.35;
                cursor: default;
                pointer-events: none;
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp" />

            <div>
                <header class="topbar">
                    <h1>Quản lý cấp lại mật khẩu</h1>
                    <span class="crumb">/ Yêu cầu quên mật khẩu</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-success">
                            <svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                            <span>${sessionScope.message}</span>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span>${sessionScope.error}</span>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-label">Tổng yêu cầu</div>
                            <div class="stat-value">${totalRequests}</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Đang chờ</div>
                            <div class="stat-value">${pendingCount}</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Đã cấp lại</div>
                            <div class="stat-value">${doneRequests}</div>
                        </div>
                    </div>
                    <!-- FILTER TABS -->
                    <div class="filter-tabs">
                        <a href="forgot-password" class="filter-tab ${empty statusFilter ? 'active' : ''}">Tất cả</a>
                        <a href="forgot-password?status=pending" class="filter-tab ${statusFilter == 'pending' ? 'active' : ''}">Chờ xử lý</a>
                        <a href="forgot-password?status=approved" class="filter-tab ${statusFilter == 'approved' ? 'active' : ''}">Đã cấp lại</a>
                    </div>
                    <div class="card-table">
                        <table>
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
                                        <td class="mono">#${req.id}</td>
                                        <td>${req.username}</td>
                                        <td>
                                            <span class="pill ${req.status}"><span class="pdot"></span>
                                                <c:choose>
                                                    <c:when test="${req.status == 'pending'}">Chờ xử lý</c:when>
                                                    <c:when test="${req.status == 'approved'}">Đã cấp lại</c:when>
                                                    <c:otherwise>${req.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>${req.createdAt}</td>
                                        <td>
                                            <div class="actions">
                                                <c:if test="${req.status == 'pending'}">
                                                    <button class="btn btn-primary" onclick="openModal(${req.id}, '${req.username}')">Cấp lại</button>
                                                </c:if>
                                                <c:if test="${req.status != 'pending'}">
                                                    <button class="btn" onclick="openDetailModal('${req.username}', '${req.status}', '${req.note}', '${req.processedAt}')">Chi tiết</button>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty listRequests}">
                                    <tr><td colspan="5" class="empty">Không có yêu cầu nào</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                        <!-- PAGINATION -->
                        <c:set var="statusParam" value="" />
                        <c:if test="${not empty statusFilter}">
                            <c:set var="statusParam" value="&amp;status=${statusFilter}" />
                        </c:if>
                        <div class="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}${statusParam}" class="page-btn">← Trước</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">← Trước</span>
                                </c:otherwise>
                            </c:choose>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:choose>
                                    <c:when test="${p == currentPage}">
                                        <span class="page-btn active">${p}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="?page=${p}${statusParam}" class="page-btn">${p}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}${statusParam}" class="page-btn">Sau →</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">Sau →</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="modal-host" id="detailModal">
            <div class="modal">
                <h3>Chi tiết yêu cầu</h3>
                <div class="sub">Thông tin cấp lại mật khẩu</div>
                <div class="field">
                    <label class="field-label">Username</label>
                    <input class="input" id="detailUsername" readonly>
                </div>
                <div class="field">
                    <label class="field-label">Trạng thái</label>
                    <input class="input" id="detailStatus" readonly>
                </div>
                <div class="field">
                    <label class="field-label">Ghi chú</label>
                    <textarea id="detailNote" readonly></textarea>
                </div>
                <div class="field">
                    <label class="field-label">Ngày xử lý</label>
                    <input class="input" id="detailProcessedAt" readonly>
                </div>
                <div class="modal-actions">
                    <button class="btn" onclick="closeDetailModal()">Đóng</button>
                </div>
            </div>
        </div>

        <div class="modal-host" id="resetModal">
            <div class="modal">
                <h3>Cấp lại mật khẩu</h3>
                <div class="sub">Tạo mật khẩu mới cho người dùng</div>
                <form action="${pageContext.request.contextPath}/admin/forgot-password" method="post">
                    <input type="hidden" name="requestId" id="requestId">
                    <div class="field">
                        <label class="field-label">Username</label>
                        <input class="input" type="text" id="username" readonly>
                    </div>
                    <div class="field">
                        <label class="field-label">Ghi chú</label>
                        <textarea name="note" placeholder="Ví dụ: vui lòng đổi mật khẩu sau lần đăng nhập đầu tiên"></textarea>
                    </div>
                    <div class="modal-actions">
                        <button class="btn" type="button" onclick="closeModal()">Huỷ</button>
                        <button class="btn btn-primary" type="submit">Xác nhận cấp lại</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
                            function toggleTheme() {
                                const html = document.documentElement;
                                const current = html.getAttribute('data-theme');
                                html.setAttribute('data-theme', current === 'dark' ? 'light' : 'dark');
                            }
                            document.getElementById('themeToggle').addEventListener('click', toggleTheme);

                            const resetModal = document.getElementById('resetModal');
                            function openModal(id, username) {
                                resetModal.classList.add('open');
                                document.getElementById('requestId').value = id;
                                document.getElementById('username').value = username;
                            }
                            function closeModal() {
                                resetModal.classList.remove('open');
                            }

                            const detailModal = document.getElementById('detailModal');
                            function openDetailModal(username, status, note, processedAt) {
                                detailModal.classList.add('open');
                                document.getElementById('detailUsername').value = username;
                                document.getElementById('detailStatus').value = status === 'approved' ? 'Đã cấp lại' : status;
                                document.getElementById('detailNote').value = note || '';
                                document.getElementById('detailProcessedAt').value = processedAt || '';
                            }
                            function closeDetailModal() {
                                detailModal.classList.remove('open');
                            }

                            window.addEventListener('click', e => {
                                if (e.target === resetModal)
                                    closeModal();
                                if (e.target === detailModal)
                                    closeDetailModal();
                            });
        </script>
    </body>
</html>