<%--
    Document   : user-detail
    Created on : May 17, 2026, 3:32:53 PM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết người dùng — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết người dùng</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/users?action=list">Người dùng</a> / <span id="crumbId"><c:out value="${user.username}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="${pageContext.request.contextPath}/admin/users?action=update&id=${user.id}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
                <c:choose>
                    <c:when test="${user.status == 'active'}">
                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/admin/users?action=deactivate&id=${user.id}">
                            Vô hiệu hoá
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/admin/users?action=activate&id=${user.id}">
                            Kích hoạt
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/admin/users?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar purple"><c:out value="${userInitials}"/></div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${user.name}"/>
                        <c:if test="${user.status == 'active'}">
                            <span class="verified"><svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg> Đã xác thực</span>
                        </c:if>
                    </h2>
                    <div class="hero-meta">
                        <span><c:out value="${user.username}"/></span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${user.id}"/></span>
                        <span class="sep">·</span>
                        <span>Tham gia <c:out value="${createdDate}"/></span>
                    </div>
                    <div class="hero-pills">
                        <c:forEach var="role" items="${user.roles}">
                            <span class="pill role-admin"><span class="pdot"></span>
                                <c:choose>
                                    <c:when test="${role.roleName == 'admin'}">Quản trị viên</c:when>
                                    <c:when test="${role.roleName == 'warehouse_manager'}">Quản lý kho</c:when>
                                    <c:when test="${role.roleName == 'warehouse_staff'}">Thủ kho</c:when>
                                    <c:when test="${role.roleName == 'sales_staff'}">Nhân viên bán hàng</c:when>
                                    <c:when test="${role.roleName == 'sale_manager'}">Trưởng phòng bán hàng</c:when>
                                    <c:otherwise><c:out value="${role.roleName}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${user.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${user.status == 'locked'}"><span class="pill status-active" style="color:var(--muted)"><span class="pdot"></span>Bị khóa</span></c:when>
                        </c:choose>
                    </div>
                </div>
                <div class="hero-actions">

                </div>
            </div>

            <%-- Tab bar --%>
            <div class="tab-bar">
                <a href="javascript:void(0)" id="tabInfoBtn" class="tab ${activeTab != 'history' ? 'active' : ''}" onclick="switchTab('info')">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                    Thông tin
                </a>
                <a href="javascript:void(0)" id="tabHistoryBtn" class="tab ${activeTab == 'history' ? 'active' : ''}" onclick="switchTab('history')">
                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    Lịch sử
                    <c:if test="${histTotalLogs > 0}"><span class="tab-badge">${histTotalLogs}</span></c:if>
                </a>
            </div>

            <%-- ===== TAB: THÔNG TIN ===== --%>
            <div id="tab-info" class="tab-content ${activeTab == 'history' ? 'tab-hidden' : ''}">
                <section class="section" id="info">
                    <div class="section-head">
                        <div>
                            <div class="section-num">01 — THÔNG TIN CÁ NHÂN</div>
                            <h3 class="section-title">Hồ sơ liên hệ &amp; nhân sự</h3>
                        </div>
                        <div class="section-update">Cập nhật <c:out value="${updatedDate}"/></div>
                    </div>
                    <div class="info-grid">
                        <div class="info-field">
                            <div class="info-label">Họ và tên</div>
                            <div class="info-value"><c:out value="${user.name}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Tên đăng nhập</div>
                            <div class="info-value mono"><c:out value="${user.username}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Email</div>
                            <div class="info-value mono"><c:out value="${user.email}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value mono"><c:out value="${user.phone}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value"><c:out value="${user.address}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Vai trò</div>
                            <div class="info-value">
                                <c:forEach var="role" items="${user.roles}">
                                    <span class="pill role-admin"><span class="pdot"></span>
                                        <c:choose>
                                            <c:when test="${role.roleName == 'admin'}">Admin</c:when>
                                            <c:when test="${role.roleName == 'warehouse_manager'}">Quản lý kho</c:when>
                                            <c:when test="${role.roleName == 'warehouse_staff'}">Thủ kho</c:when>
                                            <c:when test="${role.roleName == 'accountant'}">Kế toán</c:when>
                                            <c:when test="${role.roleName == 'sales_staff'}">Nhân viên</c:when>
                                            <c:when test="${role.roleName == 'technician'}">Kỹ thuật</c:when>
                                            <c:when test="${role.roleName == 'customer'}">Khách hàng</c:when>
                                            <c:when test="${role.roleName == 'driver'}">Tài xế</c:when>
                                            <c:otherwise><c:out value="${role.roleName}"/></c:otherwise>
                                        </c:choose>
                                    </span>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${user.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                                    <c:when test="${user.status == 'locked'}"><span class="pill status-active" style="color:var(--muted)"><span class="pdot"></span>Bị khóa</span></c:when>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Ngày tạo</div>
                            <div class="info-value mono"><c:out value="${createdDate}"/></div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Cập nhật cuối</div>
                            <div class="info-value mono"><c:out value="${updatedDate}"/></div>
                        </div>
                    </div>
                </section>
            </div><%-- end tab-info --%>

            <%-- ===== TAB: LỊCH SỬ ===== --%>
            <div id="tab-history" class="tab-content ${activeTab == 'history' ? '' : 'tab-hidden'}">

                <div class="table-card history-card">

                    <%-- Filter theo hành động --%>
                    <form method="get" action="${pageContext.request.contextPath}/admin/users" class="history-filter-bar">
                        <input type="hidden" name="action" value="view"/>
                        <input type="hidden" name="id" value="${user.id}"/>
                        <input type="hidden" name="activeTab" value="history"/>
                        <input type="hidden" name="histPage" value="1"/>

                        <div class="search-input hf-search">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                            <input type="text" name="histSearch" placeholder="Tìm theo tên người dùng..." value="<c:out value="${histSearch}"/>" onkeypress="if(event.keyCode==13) this.form.submit();"/>
                        </div>

                        <select name="historyAction" id="historyActionSelect" class="filter-select" onchange="this.form.submit()">
                            <option value=""          ${empty historyAction ? 'selected' : ''}>Tất cả hành động</option>
                            <option value="CREATE"           ${historyAction == 'CREATE'           ? 'selected' : ''}>Thêm mới</option>
                            <option value="UPDATE"           ${historyAction == 'UPDATE'           ? 'selected' : ''}>Cập nhật (admin)</option>
                            <option value="UPDATE_PROFILE"   ${historyAction == 'UPDATE_PROFILE'   ? 'selected' : ''}>Tự cập nhật hồ sơ</option>
                            <option value="CHANGE_PASSWORD"  ${historyAction == 'CHANGE_PASSWORD'  ? 'selected' : ''}>Đổi mật khẩu</option>
                            <option value="ACTIVATE"         ${historyAction == 'ACTIVATE'         ? 'selected' : ''}>Kích hoạt</option>
                            <option value="DEACTIVATE"       ${historyAction == 'DEACTIVATE'       ? 'selected' : ''}>Vô hiệu hoá</option>
                        </select>

                        <div class="date-range">
                            <span class="date-label">Từ:</span>
                            <input type="date" name="histDateFrom" class="date-input" value="<c:out value="${histDateFrom}"/>" onchange="this.form.submit()"/>
                            <span class="date-label">Đến:</span>
                            <input type="date" name="histDateTo" class="date-input" value="<c:out value="${histDateTo}"/>" onchange="this.form.submit()"/>
                        </div>

                        <c:if test="${not empty historyAction or not empty histSearch or not empty histDateFrom or not empty histDateTo}">
                            <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&activeTab=history" class="btn">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                Xóa lọc
                            </a>
                        </c:if>
                    </form>

                    <%-- Thông tin tổng số --%>
                    <div class="result-summary">
                        Tìm thấy <strong>${histTotalLogs}</strong> bản ghi
                        <c:if test="${not empty historyAction or not empty histSearch or not empty histDateFrom or not empty histDateTo}">
                            &nbsp;—&nbsp;<span class="filter-active-badge">Bộ lọc đang hoạt động</span>
                        </c:if>
                    </div>

                    <table>
                        <thead><tr>
                            <th style="width:150px;">Thời gian</th>
                            <th style="width:160px;">Người dùng</th>
                            <th style="width:160px;">Hành động</th>
                            <th>Chi tiết</th>
                        </tr></thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty historyLogs}">
                                <tr><td colspan="4">
                                    <div class="empty-state">
                                        <div class="icon-wrap">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                        </div>
                                        <strong>Chưa có lịch sử nào</strong>
                                        <c:if test="${not empty historyAction or not empty histSearch or not empty histDateFrom or not empty histDateTo}">
                                            <span style="color:var(--muted);font-size:0.88rem;">Thử <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&activeTab=history">xóa bộ lọc</a></span>
                                        </c:if>
                                    </div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="hlog" items="${historyLogs}">
                                    <tr>
                                        <td><fmt:formatDate value="${hlog.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><div style="font-weight:600;color:var(--fg);">${hlog.username}</div></td>
                                        <td>
                                            <span class="action-badge action-<c:choose><c:when test="${hlog.action == 'CREATE'}">create</c:when><c:when test="${hlog.action == 'UPDATE'}">update</c:when><c:when test="${hlog.action == 'UPDATE_PROFILE'}">update_profile</c:when><c:when test="${hlog.action == 'CHANGE_PASSWORD'}">change_password</c:when><c:when test="${hlog.action == 'ACTIVATE'}">activate</c:when><c:when test="${hlog.action == 'DEACTIVATE'}">deactivate</c:when><c:otherwise>default</c:otherwise></c:choose>">
                                                <c:choose>
                                                    <c:when test="${hlog.action == 'CREATE'}">Thêm mới</c:when>
                                                    <c:when test="${hlog.action == 'UPDATE'}">Cập nhật</c:when>
                                                    <c:when test="${hlog.action == 'UPDATE_PROFILE'}">Tự sửa hồ sơ</c:when>
                                                    <c:when test="${hlog.action == 'CHANGE_PASSWORD'}">Đổi mật khẩu</c:when>
                                                    <c:when test="${hlog.action == 'ACTIVATE'}">Kích hoạt</c:when>
                                                    <c:when test="${hlog.action == 'DEACTIVATE'}">Vô hiệu hoá</c:when>
                                                    <c:otherwise>${hlog.action}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td style="max-width:340px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                            <c:out value="${hlog.details}"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>

                    <%-- Phân trang lịch sử --%>
                    <c:if test="${histTotalPages > 1}">
                    <c:set var="filterParams" value=""/>
                    <c:if test="${not empty histSearch}"><c:set var="filterParams" value="${filterParams}&histSearch=${histSearch}"/></c:if>
                    <c:if test="${not empty historyAction}"><c:set var="filterParams" value="${filterParams}&historyAction=${historyAction}"/></c:if>
                    <c:if test="${not empty histDateFrom}"><c:set var="filterParams" value="${filterParams}&histDateFrom=${histDateFrom}"/></c:if>
                    <c:if test="${not empty histDateTo}"><c:set var="filterParams" value="${filterParams}&histDateTo=${histDateTo}"/></c:if>

                    <div class="pagination">
                        <div class="info">Trang <strong>${histPage}</strong> / <strong>${histTotalPages}</strong></div>
                        <div class="controls">
                            <c:if test="${histPage > 1}">
                                <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&activeTab=history&histPage=${histPage - 1}${filterParams}" class="page-btn">&lsaquo;</a>
                            </c:if>
                            <c:forEach begin="1" end="${histTotalPages}" var="hp">
                                <c:choose>
                                    <c:when test="${hp == histPage}"><span class="page-btn active">${hp}</span></c:when>
                                    <c:otherwise><a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&activeTab=history&histPage=${hp}${filterParams}" class="page-btn">${hp}</a></c:otherwise>
                                </c:choose>
                            </c:forEach>
                            <c:if test="${histPage < histTotalPages}">
                                <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&activeTab=history&histPage=${histPage + 1}${filterParams}" class="page-btn">&rsaquo;</a>
                            </c:if>
                        </div>
                    </div>
                    </c:if>

                </div><%-- end table-card --%>
            </div><%-- end tab-history --%>
        </main>
    </div>
</div>

<script>
// ===== Tab switching =====
function switchTab(tab) {
    var infoEl  = document.getElementById('tab-info');
    var histEl  = document.getElementById('tab-history');
    var btnInfo = document.getElementById('tabInfoBtn');
    var btnHist = document.getElementById('tabHistoryBtn');

    if (tab === 'history') {
        if (infoEl)  infoEl.classList.add('tab-hidden');
        if (histEl)  histEl.classList.remove('tab-hidden');
        if (btnInfo) btnInfo.classList.remove('active');
        if (btnHist) btnHist.classList.add('active');
    } else {
        if (infoEl)  infoEl.classList.remove('tab-hidden');
        if (histEl)  histEl.classList.add('tab-hidden');
        if (btnInfo) btnInfo.classList.add('active');
        if (btnHist) btnHist.classList.remove('active');
    }
}
</script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
