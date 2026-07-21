<%-- 
    Document   : admin-user-edit
    Created on : May 17, 2026, 2:05:50 PM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa người dùng — Quản lý máy phát điện</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user-edit.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp" />

            <div>
                <header class="topbar">
                    <h1>Chỉnh sửa người dùng</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/users?action=list">Người dùng</a> / ${user.name}</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/admin/users?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="edit-hero">
                        <div class="edit-avatar">
                            ${user.name.substring(0, 1)}
                            <button class="avatar-edit-btn" title="Đổi ảnh"><svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg></button>
                        </div>
                        <div class="edit-hero-body">
                            <h2 class="edit-hero-title">${user.name}</h2>
                            <div class="edit-hero-meta">
                                <span class="mono">ID: ${user.id}</span>
                                <span class="sep">·</span>
                                <span>@${user.username}</span>
                                <span class="sep">·</span>
                                <span>${user.email}</span>
                                <span class="sep">·</span>
                                <c:choose>
                                    <c:when test="${user.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Hoạt động</span></c:when>
                                    <c:when test="${user.status == 'inactive'}"><span class="pill"><span class="pdot"></span>Chưa kích hoạt</span></c:when>
                                    <c:when test="${user.status == 'pending'}"><span class="pill"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                    <c:when test="${user.status == 'locked'}"><span class="pill"><span class="pdot"></span>Khoá</span></c:when>
                                    <c:otherwise><span class="pill"><span class="pdot"></span>${user.status}</span></c:otherwise>
                                    </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" id="editForm" action="${pageContext.request.contextPath}/admin/users?action=update&amp;id=${user.id}" method="POST" autocomplete="off">
                            <input type="hidden" name="page" value="${param.page != null ? param.page : 1}" />
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-head-left">
                                        <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                                        <h3 class="form-section-title">Họ tên &amp; liên hệ</h3>
                                        <div class="form-section-desc">Email không thể đổi sau khi tạo tài khoản — đó là khóa đăng nhập của người dùng.</div>
                                    </div>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Họ và tên <span class="req">*</span></label>
                                        <input class="input <c:if test='${not empty errors["name"]}'>error</c:if>" name="name" data-orig="${user.name}" value="${not empty formData ? formData['name'][0] : user.name}" />
                                            <div class="field-help">Tối đa 60 ký tự</div>
                                        <c:if test="${not empty errors['name']}"><div class="field-error" style="display:block">${errors['name']}</div></c:if>
                                        <c:if test="${empty errors['name']}"><div class="field-error">Họ tên phải có ít nhất 2 ký tự</div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">
                                                Email đăng nhập
                                                <span class="lock"><svg viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>Khoá</span>
                                            </label>
                                            <input class="input mono" name="email" value="${user.email}" readonly />
                                        <div class="field-help">Email là khóa đăng nhập, không thể đổi.</div>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                        <input class="input mono <c:if test='${not empty errors["phone"]}'>error</c:if>" name="phone" data-orig="${user.phone}" value="${not empty formData ? formData['phone'][0] : user.phone}" />
                                            <div class="field-help">Dùng cho 2FA SMS và thông báo khẩn</div>
                                        <c:if test="${not empty errors['phone']}"><div class="field-error" style="display:block">${errors['phone']}</div></c:if>
                                        <c:if test="${empty errors['phone']}"><div class="field-error">Số điện thoại không hợp lệ</div></c:if>
                                        </div>
                                        <div class="field">
                                            <label class="field-label">Địa chỉ</label>
                                            <input class="input" name="address" data-orig="${user.address}" value="${not empty formData ? formData['address'][0] : user.address}" />
                                        <div class="field-help">Địa chỉ liên hệ</div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-head-left">
                                        <div class="form-section-num">02 — VAI TRÒ &amp; KHO</div>
                                        <h3 class="form-section-title">Phân quyền hệ thống</h3>
                                        <div class="form-section-desc">Chọn nhiều vai trò để phân quyền linh hoạt. Bỏ check để gỡ bỏ vai trò.</div>
                                    </div>
                                </div>
                                <div class="form-grid single">
                                    <div class="field">
                                        <label class="field-label">Vai trò <span class="req">*</span></label>
                                        <div class="role-grid">
                                            <c:forEach var="role" items="${allRoles}">
                                                <c:if test="${role.status == 'active'}">
                                                    <c:set var="isSelected" value="false" />
                                                    <c:if test="${not empty user.roles}">
                                                        <c:forEach var="userRole" items="${user.roles}">
                                                            <c:if test="${userRole.roleId == role.roleId}">
                                                                <c:set var="isSelected" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                    <label class="role-card ${isSelected ? 'selected' : ''}" data-role-id="${role.roleId}" data-orig-checked="${isSelected}">
                                                        <input type="radio" name="roleIds" value="${role.roleId}" ${isSelected ? 'checked' : ''} />
                                                        <div class="role-card-name">${role.roleName}</div>
                                                        <div class="role-card-desc">${role.description}</div>
                                                    </label>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Trạng thái tài khoản</label>
                                        <div class="seg" data-name="status" data-orig="${user.status}">
                                            <button type="button" class="seg-opt <c:if test='${user.status == "active"}'>active</c:if>" data-val="active"><span class="sdot"></span>Hoạt động</button>
                                            <button type="button" class="seg-opt <c:if test='${user.status == "inactive"}'>active</c:if>" data-val="inactive"><span class="sdot"></span>Chưa kích hoạt</button>
                                            </div>
                                            <input type="hidden" name="status" value="${user.status}" />
                                        <div class="field-help">"Khoá" tạm thời không thể đăng nhập.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-head-left">
                                        <div class="form-section-num">03 — KHO PHỤ TRÁCH</div>
                                        <h3 class="form-section-title">Phân kho làm việc</h3>
                                        <div class="form-section-desc">Chỉ áp dụng cho nhân viên kho / quản lý kho. Để trống nếu chưa phân công.</div>
                                    </div>
                                </div>
                                <div class="form-grid single">
                                    <div class="field">
                                        <label class="field-label">Kho phụ trách</label>
                                        <select class="select" name="warehouseId" data-orig="${user.warehouseId}">
                                            <option value="">-- Chưa phân kho --</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <c:if test="${wh.status == 'active'}">
                                                    <option value="${wh.warehouseId}" ${user.warehouseId == wh.warehouseId ? 'selected' : ''}><c:out value="${wh.name}"/></option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                        <div class="field-help">Chỉ áp dụng cho vai trò nhân viên kho / quản lý kho.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-head-left">
                                        <div class="form-section-num">04 — QUYỀN CÁ NHÂN</div>
                                        <h3 class="form-section-title">Ghi đè quyền người dùng</h3>
                                        <div class="form-section-desc">CẤP cấp thêm quyền, TỪ CHỐI từ chối quyền (ưu tiên cao hơn role). Để trống = theo role.</div>
                                    </div>
                                </div>
                                <input type="hidden" name="perOverride_submitted" value="1" />
                                <div class="form-grid single">
                                    <div class="field">
                                        <c:set var="overrideMap" value="${requestScope.userOverrides}" />
                                        <c:forEach var="entry" items="${groupedPerms}">
                                            <div style="margin-bottom: 16px; border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 12px 14px;">
                                                <div style="font-weight: 700; font-size: 13px; margin-bottom: 10px; color: var(--accent);">${entry.key}</div>
                                                <div style="display: flex; flex-direction: column; gap: 6px;">
                                                    <c:forEach var="perm" items="${entry.value}">
                                                        <c:set var="ovType" value="" />
                                                        <c:forEach var="ov" items="${overrideMap}">
                                                            <c:if test="${ov[0] == perm.resource.concat('.').concat(perm.action)}">
                                                                <c:set var="ovType" value="${ov[1]}" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <div style="display: flex; align-items: center; gap: 12px; padding: 4px 0; border-bottom: 1px dashed var(--border);">
                                                            <span style="flex: 1; font-size: 12px; font-weight: 600;">${perm.description != null ? perm.description : perm.action}</span>
                                                            <label style="font-size: 11px; cursor: pointer; display: flex; align-items: center; gap: 3px; color: var(--muted);">
                                                                <input type="radio" name="perOverride_${perm.permissionId}" value="default" data-resource="${perm.resource}" data-action="${perm.action}" ${empty ovType ? 'checked' : ''} /> Mặc định
                                                            </label>
                                                            <label style="font-size: 11px; cursor: pointer; display: flex; align-items: center; gap: 3px; color: var(--accent); font-weight: 600;">
                                                                <input type="radio" name="perOverride_${perm.permissionId}" value="GRANT" data-resource="${perm.resource}" data-action="${perm.action}" ${ovType == 'GRANT' ? 'checked' : ''} /> CẤP
                                                            </label>
                                                            <label style="font-size: 11px; cursor: pointer; display: flex; align-items: center; gap: 3px; color: var(--danger); font-weight: 600;">
                                                                <input type="radio" name="perOverride_${perm.permissionId}" value="DENY" data-resource="${perm.resource}" data-action="${perm.action}" ${ovType == 'DENY' ? 'checked' : ''} /> TỪ CHỐI
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:forEach>
                                        <c:if test="${empty groupedPerms}">
                                            <div style="font-size: 12px; color: var(--muted); padding: 16px; text-align: center;">Không có quyền nào trong hệ thống.</div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>


                        </form>

                    </div>
                </main>
            </div>
        </div>

        <div class="save-bar">
            <div class="info">
                <div>Có thay đổi chưa lưu <span class="dirty-pill" id="dirtyPill">0 trường</span></div>
                <div class="sub">⌘S để lưu · Esc để huỷ</div>
            </div>
            <button class="btn" id="cancelBtn">Huỷ</button>
            <button class="btn btn-primary" id="saveBtn">
                <svg class="icon" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><path d="M17 21v-8H7v8M7 3v5h8"/></svg>
                Lưu thay đổi
            </button>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <div class="modal-host" id="confirmModal">
            <div class="modal">
                <h3 id="modalTitle">Xác nhận hành động</h3>
                <p id="modalText">Bạn có chắc muốn thực hiện hành động này?</p>
                <div class="actions">
                    <button class="btn" id="modalCancel">Huỷ</button>
                    <button class="btn btn-danger" id="modalConfirm">Xác nhận</button>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            window.CTX = '${pageContext.request.contextPath}';
            window.USER_DATA = {
                name: '<c:out value="${user.name}"/>',
                phone: '<c:out value="${user.phone}"/>',
                address: '<c:out value="${user.address}"/>',
                status: '<c:out value="${user.status}"/>'
            };
            window.SESSION_DATA = {};
            <c:if test="${not empty sessionScope.message}">
            window.SESSION_DATA.message = '<c:out value="${sessionScope.message}"/>';
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errors}">
            window.SESSION_DATA.error = true;
                <c:remove var="errors" scope="session"/>
                <c:remove var="formData" scope="session"/>
            </c:if>
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/admin-user-edit.js"></script>
    </body>
</html>