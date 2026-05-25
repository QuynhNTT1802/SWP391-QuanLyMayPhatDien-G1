<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa vai trò</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/role/rbac-role-edit.css">
</head>
<body>
<div class="app">

   <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar topbar-edit">
            <a href="${pageContext.request.contextPath}/admin/roles" class="btn btn-back" title="Quay lại danh sách vai trò">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Hủy
            </a>
            <div class="topbar-info">
                <h1>${empty role ? 'Tạo vai trò mới' : 'Chỉnh sửa vai trò'}</h1>
                <span class="crumb">/ <a href="#">Quản trị</a> / <a href="${pageContext.request.contextPath}/admin/roles">Phân quyền</a></span>
            </div>
            <button type="submit" form="roleForm" class="btn btn-primary">Lưu thay đổi</button>
        </header>

        <form id="roleForm" action="${pageContext.request.contextPath}/admin/role/save" method="POST">
            <input type="hidden" name="id" value="${role.roleId}">

            <c:if test="${not empty errors}">
                <div class="error-box">
                    <div class="error-box-title">Vui lòng sửa các lỗi sau:</div>
                    <ul>
                        <c:forEach var="err" items="${errors}">
                            <li>${err}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <main>
                <div class="page-head">
                    <div class="head-left">
                        <div class="eyebrow">RBAC · Chỉnh sửa</div>
                        <h2 id="roleTitle">${empty role ? 'Vai trò mới' : role.roleName}</h2>
                        <p>Tinh chỉnh phạm vi quyền hạn và thông tin định danh của vai trò trong hệ thống.</p>
                    </div>
                </div>

                <div class="layout">
                    <div>
                        <div class="section">
                            <div class="section-head"><h3>Thông tin vai trò</h3></div>
                            <div class="section-body">
                                <div class="field-row-2">
                                    <div class="field">
                                        <label>Tên vai trò</label>
                                        <input type="text" name="name" value="${role.roleName}" required />
                                    </div>
                                    <div class="field">
                                        <label>Trạng thái</label>
                                        <select name="status">
                                            <option value="active" ${role.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${role.status == 'inactive' ? 'selected' : ''}>Khóa</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="field">
                                    <label>Mô tả vai trò</label>
                                    <textarea name="description">${role.description}</textarea>
                                </div>
                            </div>
                        </div>

                        <div class="section">
                            <div class="section-head">
                                <h3>Danh sách các quyền</h3>
                                <div class="input has-icon" style="width:220px;">
                                    <span class="leading">
                                        <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>
                                    </span>
                                    <input type="text" id="permSearch" placeholder="Tìm kiếm quyền..." value="${param.permSearch}" autocomplete="off">
                                </div>
                            </div>
                            <div class="perm-table" id="permTable">

                                <c:forEach var="entry" items="${groupedPerms}">
                                    <div class="perm-row">
                                        <div class="res-info">
<!--                                            <div class="res-icon">Edit</div>-->
                                            <div>
                                                <div class="res-name">${entry.key}</div>
                                            </div>
                                        </div>

                                        <c:forEach var="perm" items="${entry.value}">
                                            <c:set var="isChecked" value="false" />
                                            <c:forEach var="rPerm" items="${rolePermissions}">
                                                <c:if test="${rPerm.permissionId == perm.permissionId}">
                                                    <c:set var="isChecked" value="true" />
                                                </c:if>
                                            </c:forEach>

                                            <div style="text-align: center;">
                                                <span style="font-size: 10px; color: gray; display:block; margin-bottom:4px;">${perm.action}</span>
                                                <label class="perm-toggle ${isChecked ? 'on' : ''}">
                                                    <input type="checkbox" name="perIds" value="${perm.permissionId}" style="display:none;" ${isChecked ? 'checked' : ''}>
                                                    <svg viewBox="0 0 24 24"><polyline points="4 12 10 18 20 6"/></svg>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:forEach>

                            </div>
                        </div>
                    </div>

                    <aside class="summary">
                        <div class="summary-card">
                            <h4>Tổng quan</h4>
                            <div class="summary-stat"><span>Loại vai trò</span><span class="v" style="color:var(--info);">Tùy chỉnh</span></div>
                            <div class="summary-stat"><span>Phạm vi kho</span><span class="v">Được phân công</span></div>
                        </div>
                    </aside>
                </div>
            </main>

        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/role/rbac-role-edit.js"></script>
</body>
</html>