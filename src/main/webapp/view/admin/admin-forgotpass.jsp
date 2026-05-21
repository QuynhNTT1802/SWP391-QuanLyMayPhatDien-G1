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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-forgotpass.css">
       
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
        <script src="${pageContext.request.contextPath}/assets/js/admin-forgotpass.js"></script>
        
    </body>
</html>