<%-- 
    Document   : admin-category-edit
    Created on : May 24, 2026, 8:48:37 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${empty category ? 'Thêm danh mục' : 'Sửa danh mục'}</title>
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
            <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-back" title="Quay lại">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Hủy
            </a>
            <div class="topbar-info">
                <h1>${empty category ? 'Thêm danh mục mới' : 'Chỉnh sửa danh mục'}</h1>
                <span class="crumb">/ <a href="#">Quản trị</a> / <a href="${pageContext.request.contextPath}/admin/categories">Danh mục</a></span>
            </div>
            <button type="submit" form="categoryForm" class="btn btn-primary">Lưu</button>
        </header>

        <form id="categoryForm" action="${pageContext.request.contextPath}/admin/category/save" method="POST">
            <input type="hidden" name="id" value="${category.id}">

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
                        <div class="eyebrow">Danh mục · ${empty category ? 'Tạo mới' : 'Chỉnh sửa'}</div>
                        <h2>${empty category ? 'Danh mục mới' : category.name}</h2>
                        <p>${empty category ? 'Thêm một danh mục mới để phân loại máy phát điện.' : 'Chỉnh sửa thông tin danh mục.'}</p>
                    </div>
                </div>

                <div class="layout">
                    <div>
                        <div class="section">
                            <div class="section-head"><h3>Thông tin danh mục</h3></div>
                            <div class="section-body">
                                <div class="field-row-2">
                                    <div class="field">
                                        <label>Tên danh mục</label>
                                        <input type="text" name="name" value="${category.name}" required />
                                    </div>
                                    <div class="field">
                                        <label>Loại danh mục</label>
                                        <select name="type" required>
                                            <option value="">-- Chọn loại --</option>
                                            <option value="brand"          ${category.type == 'brand' ? 'selected' : ''}>Hãng sản xuất</option>
                                            <option value="fuel_type"      ${category.type == 'fuel_type' ? 'selected' : ''}>Loại nhiên liệu</option>
                                            <option value="power_range"    ${category.type == 'power_range' ? 'selected' : ''}>Dải công suất</option>
                                            <option value="generator_type" ${category.type == 'generator_type' ? 'selected' : ''}>Loại máy phát</option>
                                            <option value="phase"          ${category.type == 'phase' ? 'selected' : ''}>Loại pha</option>
                                            <option value="condition"      ${category.type == 'condition' ? 'selected' : ''}>Tình trạng</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="field-row-2">
                                    <div class="field">
                                        <label>Trạng thái</label>
                                        <select name="status">
                                            <option value="active" ${category.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="inactive" ${category.status == 'inactive' ? 'selected' : ''}>Khóa</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="field">
                                    <label>Mô tả</label>
                                    <textarea name="description">${category.description}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>