<%-- 
    Document   : create-user
    Created on : May 17, 2026, 5:14:48 PM
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
        <title>Thêm người dùng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>


                <div>
                    <header class="topbar">
                        <h1>Thêm người dùng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/users?action=list">Người dùng</a> / Thêm mới</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.errors}">
                        <c:forEach var="err" items="${sessionScope.errors}">
                            <div style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 30%,transparent);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                                <c:out value="${err.value}"/>
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${not empty sessionScope.message}">
                        <div style="background:var(--accent);color:var(--bg);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                            <c:out value="${sessionScope.message}"/>
                        </div>
                        <c:remove var="errors" scope="session"/>
                        <c:remove var="message" scope="session"/>
                    </c:if>
                    <a class="back-link" href="${pageContext.request.contextPath}/admin/users?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Quản trị · Tài khoản mới</div>
                        <h2 class="page-title">Thêm người dùng</h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/admin/users?action=create">
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                                    <h3 class="form-section-title">Họ tên &amp; liên hệ</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Tên đăng nhập <span class="req">*</span></label>
                                        <input class="input" name="username" placeholder="VD: nguyenvana" value="<c:out value="${param.username}"/>" />
                                        <c:if test="${not empty errors.username}"><div class="field-error"><c:out value="${errors.username}"/></div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Mật khẩu <span class="req">*</span></label>
                                            <input class="input" type="password" name="password" placeholder="Ít nhất 6 ký tự" />
                                        <c:if test="${not empty errors.password}"><div class="field-error"><c:out value="${errors.password}"/></div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Họ và tên <span class="req">*</span></label>
                                            <input class="input" name="name" placeholder="Nguyễn Văn A" value="<c:out value="${param.name}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Email <span class="req">*</span></label>
                                        <input class="input mono" name="email" type="email" placeholder="ten@example.com" value="<c:out value="${param.email}"/>" />
                                        <c:if test="${not empty errors.email}"><div class="field-error"><c:out value="${errors.email}"/></div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                            <input class="input mono" name="phone" placeholder="VD: 0912345678" value="<c:out value="${param.phone}"/>" />
                                        <c:if test="${not empty errors.phone}"><div class="field-error"><c:out value="${errors.phone}"/></div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Địa chỉ</label>
                                            <input class="input" name="address" placeholder="VD: Hà Nội" value="<c:out value="${param.address}"/>" />
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — VAI TRÒ &amp; KHO</div>
                                    <h3 class="form-section-title">Phân quyền hệ thống</h3>
                                    <div class="form-section-desc">Chọn vai trò để gán bộ quyền mặc định. Có thể điều chỉnh quyền chi tiết sau khi tạo.</div>
                                </div>
                                <div class="form-grid single">
                                    <div class="field">
                                        <label class="field-label">Vai tro <span class="req">*</span></label>
                                        <div class="role-grid">
                                            <c:forEach var="role" items="${allRoles}">
                                                <c:if test="${role.status == 'active'}">
                                                    <label class="role-card">
                                                        <input type="radio" name="roleIds" value="${role.roleId}" />
                                                        <div class="role-card-name">${role.roleName}</div>
                                                        <div class="role-card-desc">${role.description}</div>
                                                    </label>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Trạng thái</label>
                                            <select class="select" name="status">
                                                <option value="active">Hoạt động</option>
                                                <option value="inactive">Không hoạt động</option>
                                                <option value="locked">Bị khoá</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                <a class="btn" href="${pageContext.request.contextPath}/admin/users?action=list">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                                    Tạo người dùng
                                </button>
                            </div>

                        </form>


                    </div>
                </main>
            </div>
        </div>


        <div class="toast-host" id="toastHost"></div>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
          ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (card) {
            card.addEventListener('click', function (e) {
              e.preventDefault()
              if (e.target.tagName === 'INPUT') return
              if (card.classList.contains('selected')) return
              ;[].slice.call(document.querySelectorAll('.role-card')).forEach(function (c) {
                c.classList.remove('selected')
                c.querySelector('input').checked = false
              })
              card.classList.add('selected')
              card.querySelector('input').checked = true
            })
          })
        </script>
    </body>
</html>