<%-- 
    Document   : user-detail
    Created on : May 17, 2026, 3:32:53 PM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                        <c:choose>
                            <c:when test="${user.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${user.status == 'inactive'}"><span class="pill status-active" style="color:var(--muted)"><span class="pdot"></span>Không hoạt động</span></c:when>
                        </c:choose>
                    </div>
                </div>
                <!-- PHẦN THIẾU 1: hero-actions -->
                <div class="hero-actions">
                    
                </div>
            </div>

            <div class="layout">
                <!-- PHẦN THIẾU 2: toc (sidebar trái) -->
                <div class="toc">
                    <a class="toc-item active" data-toc="info"><span class="toc-num">01</span><span>Thông tin cá nhân</span></a>
                    <div class="toc-meta">
                        <strong>#<c:out value="${user.id}"/></strong><br>
                        Tạo: <c:out value="${createdDate}"/><br>
                        Cập nhật: <c:out value="${updatedDate}"/>
                    </div>
                </div>

                <div class="content">
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
                                        <c:when test="${user.status == 'inactive'}"><span class="pill status-active" style="color:var(--muted)"><span class="pdot"></span>Không hoạt động</span></c:when>
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

                    <section class="section" id="activity">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — NHẬT KÝ HOẠT ĐỘNG</div>
                                <h3 class="section-title">Lịch sử thao tác</h3>
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${empty activityLogs}">
                                <div class="actlog-empty">Chưa có hoạt động nào.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="actlog">
                                    <c:forEach var="log" items="${activityLogs}" varStatus="st">
                                        <div class="actlog-row">
                                            <div class="actlog-time"><c:out value="${logDates[st.index]}"/></div>
                                            <div class="actlog-user">
                                                <span class="avatar-dot"><c:out value="${fn:substring(log.username,0,1)}"/></span>
                                                <c:out value="${log.username}"/>
                                            </div>
                                            <div class="actlog-main">
                                                <c:choose>
                                                    <c:when test="${log.action == 'CREATE'}"><span class="act-badge act-create">Tạo mới</span></c:when>
                                                    <c:when test="${log.action == 'UPDATE'}"><span class="act-badge act-update">Cập nhật</span></c:when>
                                                    <c:when test="${log.action == 'ACTIVATE'}"><span class="act-badge act-activate">Kích hoạt</span></c:when>
                                                    <c:when test="${log.action == 'DEACTIVATE'}"><span class="act-badge act-deactivate">Khóa</span></c:when>
                                                    <c:otherwise><span class="act-badge act-update"><c:out value="${log.action}"/></span></c:otherwise>
                                                </c:choose>
                                                <div class="actlog-detail"><c:out value="${log.details}"/></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>