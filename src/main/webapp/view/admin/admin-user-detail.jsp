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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory-check.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết người dùng</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/users?action=list">Người dùng</a> / <span id="crumbId"><c:out value="${user.username}"/></span></span>
            <div class="top-actions">
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
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${user.name}"/>
                    </h2>
                    <div class="hero-pills">
                        <c:forEach var="role" items="${user.roles}">
                            <span class="pill role-admin"><span class="pdot"></span>
                                <c:choose>
                                    <c:when test="${role.roleName == 'admin'}">Quản trị viên</c:when>
                                    <c:when test="${role.roleName == 'warehouse_manager'}">Quản lý kho</c:when>
                                    <c:when test="${role.roleName == 'warehouse_staff'}">Nhân viên kho</c:when>
                                    <c:when test="${role.roleName == 'sales_staff'}">Nhân viên kinh doanh</c:when>
                                    <c:when test="${role.roleName == 'sale_manager'}">Quản lý kinh doanh</c:when>
                                    <c:when test="${role.roleName == 'ceo'}">CEO</c:when>
                                    <c:otherwise><c:out value="${role.roleName}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </c:forEach>
                    </div>
                </div>
                <div class="hero-actions">

                </div>
            </div>

            <c:set var="rolesStr" value=""/>
            <c:forEach var="role" items="${user.roles}" varStatus="st">
                <c:if test="${st.index > 0}"><c:set var="rolesStr" value="${rolesStr}, "/></c:if>
                <c:choose>
                    <c:when test="${role.roleName == 'admin'}"><c:set var="rolesStr" value="${rolesStr}Quản trị viên"/></c:when>
                    <c:when test="${role.roleName == 'warehouse_manager'}"><c:set var="rolesStr" value="${rolesStr}Quản lý kho"/></c:when>
                    <c:when test="${role.roleName == 'warehouse_staff'}"><c:set var="rolesStr" value="${rolesStr}Thủ kho"/></c:when>
                    <c:when test="${role.roleName == 'accountant'}"><c:set var="rolesStr" value="${rolesStr}Kế toán"/></c:when>
                    <c:when test="${role.roleName == 'sales_staff'}"><c:set var="rolesStr" value="${rolesStr}Nhân viên"/></c:when>
                    <c:when test="${role.roleName == 'technician'}"><c:set var="rolesStr" value="${rolesStr}Kỹ thuật"/></c:when>
                    <c:when test="${role.roleName == 'customer'}"><c:set var="rolesStr" value="${rolesStr}Khách hàng"/></c:when>
                    <c:when test="${role.roleName == 'driver'}"><c:set var="rolesStr" value="${rolesStr}Tài xế"/></c:when>
                    <c:otherwise><c:set var="rolesStr" value="${rolesStr}${role.roleName}"/></c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="section" id="info">
                <div class="section-head">
                    <h3>Thông tin cá nhân</h3>
                    <div class="section-update">Cập nhật <c:out value="${updatedDate}"/></div>
                </div>
                <div class="section-body">
                    <div class="form-grid cols-5">
                        <div class="info-field">
                            <label>Họ và tên</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${user.name}'/>">
                        </div>
                        <div class="info-field">
                            <label>Tên đăng nhập</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${user.username}'/>">
                        </div>
                        <div class="info-field">
                            <label>Email</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${user.email}'/>">
                        </div>
                        <div class="info-field">
                            <label>Số điện thoại</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${user.phone}'/>">
                        </div>
                        <div class="info-field">
                            <label>Địa chỉ</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${user.address}'/>">
                        </div>
                    </div>
                    <div class="form-grid cols-5 grid-mt-14">
                        <div class="info-field">
                            <label>Vai trò</label>
                            <input class="info-input" type="text" disabled value="<c:out value='${rolesStr}'/>">
                        </div>
                        <div class="info-field">
                            <label>Trạng thái</label>
                            <input class="info-input" type="text" disabled value="${user.status == 'active' ? 'Đang hoạt động' : (user.status == 'locked' ? 'Bị khóa' : '')}">
                        </div>
                        <div class="info-field">
                            <label>Ngày tạo</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${createdDate}'/>">
                        </div>
                        <div class="info-field">
                            <label>Cập nhật cuối</label>
                            <input class="info-input mono" type="text" disabled value="<c:out value='${updatedDate}'/>">
                        </div>
                    </div>
                </div>
            </div>

            <div class="section" id="logs">
                <div class="section-head">
                    <h3>Lịch sử hoạt động</h3>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="history-filter-bar">
                    <input type="hidden" name="action" value="view"/>
                    <input type="hidden" name="id" value="${user.id}"/>
                    <input type="hidden" name="histPage" value="1"/>

                    <div class="search-input hf-search">
                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
                        <input type="text" name="histSearch" placeholder="Tìm theo tên người dùng..." value="<c:out value="${histSearch}"/>" onkeypress="if(event.keyCode==13) this.form.submit();"/>
                    </div>

                    <select name="historyAction" id="historyActionSelect" class="filter-select" onchange="this.form.submit()">
                        <option value=""          ${empty historyAction ? 'selected' : ''}>Tất cả hành động</option>
                        <option value="CREATE"           ${historyAction == 'CREATE'           ? 'selected' : ''}>Thêm mới</option>
                        <option value="UPDATE"           ${historyAction == 'UPDATE'           ? 'selected' : ''}>Cập nhật (quản trị viên)</option>
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
                        <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}" class="btn">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                            Xóa lọc
                        </a>
                    </c:if>
                </form>

                <div class="result-summary">
                    Tìm thấy <strong>${histTotalLogs}</strong> bản ghi
                    <c:if test="${not empty historyAction or not empty histSearch or not empty histDateFrom or not empty histDateTo}">
                        &nbsp;—&nbsp;<span class="filter-active-badge">Bộ lọc đang hoạt động</span>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${empty historyLogs}">
                        <div class="actlog-empty">Chưa có lịch sử nào.</div>
                    </c:when>
                    <c:otherwise>
                        <table class="actlog-table">
                            <thead>
                                <tr>
                                    <th class="col-time">Thời gian</th>
                                    <th class="col-user">Người dùng</th>
                                    <th>Hành động</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="hlog" items="${historyLogs}">
                                    <tr>
                                        <td class="col-time"><fmt:formatDate value="${hlog.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="col-user"><c:out value="${hlog.username}"/></td>
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
                                        <td><c:out value="${hlog.details}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>

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
                            <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&histPage=${histPage - 1}${filterParams}" class="page-btn">&lsaquo;</a>
                        </c:if>
                        <c:forEach begin="1" end="${histTotalPages}" var="hp">
                            <c:choose>
                                <c:when test="${hp == histPage}"><span class="page-btn active">${hp}</span></c:when>
                                <c:otherwise><a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&histPage=${hp}${filterParams}" class="page-btn">${hp}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${histPage < histTotalPages}">
                            <a href="${pageContext.request.contextPath}/admin/users?action=view&id=${user.id}&histPage=${histPage + 1}${filterParams}" class="page-btn">&rsaquo;</a>
                        </c:if>
                    </div>
                </div>
                </c:if>

            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
