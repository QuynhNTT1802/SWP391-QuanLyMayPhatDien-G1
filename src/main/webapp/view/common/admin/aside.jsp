
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="activePage" value="${requestScope.activePage}"/>

<c:set var="sidebarUser" value="${requestScope.sidebarUser}"/>
<c:if test="${empty sidebarUser}">
    <c:set var="sidebarUser" value="${sessionScope.loggedUser}"/>
</c:if>

<c:set var="perms" value="${requestScope.sidebarPermissions}"/>
<c:if test="${empty perms}">
    <c:set var="perms" value="${sessionScope.userPermissions}"/>
</c:if>

<c:if test="${not empty sidebarUser}">
    <c:set var="fullName" value="${sidebarUser.name}"/>
    <c:set var="nameParts" value="${fn:split(fullName, ' ')}"/>
    <c:set var="initials">
        <c:choose>
            <c:when test="${fn:length(nameParts) == 1}">
                ${fn:toUpperCase(fn:substring(fullName, 0, fn:length(fullName) < 2 ? fn:length(fullName) : 2))}
            </c:when>
            <c:otherwise>
                ${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:toUpperCase(fn:substring(nameParts[fn:length(nameParts)-1], 0, 1))}
            </c:otherwise>
        </c:choose>
    </c:set>

    <c:set var="roleDesc">
        <c:choose>
            <c:when test="${not empty sidebarUser.roles and not empty sidebarUser.roles[0]}">
                ${sidebarUser.roles[0].description}
            </c:when>
            <c:otherwise>User</c:otherwise>
        </c:choose>
    </c:set>
</c:if>

<aside class="sidebar">
    <div class="brand">
        <div class="brand-mark">WH</div>
        <div>Warehouse OS</div>
    </div>
    <nav class="nav">
        <div class="nav-section">Tổng quan</div>


        <c:if test="${not empty perms and perms.contains('dashboard.view')}">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                Dashboard
            </a>
        </c:if>

        <c:if test="${not empty perms and (perms.contains('inventory.view') or perms.contains('stock_card.view'))}">
            <div class="nav-parent" onclick="this.classList.toggle('open');this.nextElementSibling.classList.toggle('open')">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
                Kho
                <span class="arrow"></span>
            </div>
            <div class="nav-children">
                <c:if test="${not empty perms and perms.contains('inventory.view')}">
                    <a href="${pageContext.request.contextPath}/inventory">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
                        Tồn kho
                    </a>
                </c:if>
                <c:if test="${not empty perms and perms.contains('stock_card.view')}">
                    <a href="${pageContext.request.contextPath}/stock-card">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 21V9M15 21V9"/></svg>
                        Thẻ kho
                    </a>
                </c:if>
            </div>
        </c:if>

        <c:if test="${not empty perms and (perms.contains('proposals.approve') or perms.contains('proposals.create') or perms.contains('purchase_orders.view'))}">
            <div class="nav-parent" onclick="this.classList.toggle('open');this.nextElementSibling.classList.toggle('open')">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 2h6a2 2 0 0 1 2 2v2H7V4a2 2 0 0 1 2-2z"/><rect x="5" y="6" width="14" height="16" rx="2"/><path d="M9 12h6M9 16h4"/></svg>
                Đề xuất phiếu
                <span id="proposalBadge" style="display:none; background:#ef4444; color:#fff; font-size:10px; font-weight:700; padding:1px 6px; border-radius:9px; margin-left:6px;">0</span>
                <span class="arrow"></span>
            </div>
            <div class="nav-children">
                <c:if test="${perms.contains('proposals.approve') or perms.contains('proposals.create')}">
                    <a href="${pageContext.request.contextPath}/proposal">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                        Đề xuất nhập kho
                    </a>
                </c:if>
                <c:if test="${perms.contains('purchase_orders.view')}">
                    <a href="${pageContext.request.contextPath}/purchase-order">
                        <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-8 2a2 2 0 1 1-4 0 2 2 0 0 1 4 0z"/></svg>
                        Phiếu mua
                    </a>
                </c:if>
            </div>
        </c:if>

        <c:if test="${not empty perms and perms.contains('receipts.view')}">
            <div class="nav-parent" onclick="this.classList.toggle('open');this.nextElementSibling.classList.toggle('open')">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M3 12h18M3 18h12"/></svg>
                Phiếu
                <span class="arrow"></span>
            </div>
            <div class="nav-children">
                <a href="${pageContext.request.contextPath}/import-receipt">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 5v14M5 12h14"/></svg>
                    Phiếu nhập
                </a>
                <a href="${pageContext.request.contextPath}/export-receipt">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 19V5M5 12l7 7 7-7"/></svg>
                    Phiếu xuất
                </a>
            </div>
        </c:if>
    

    <c:if test="${not empty perms and perms.contains('orders.view')}">
        <a href="${pageContext.request.contextPath}/order">

            <svg class="icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            Đơn hàng
        </a>
    </c:if>

    <c:if test="${not empty perms and perms.contains('liquidations.view')}">
        <a href="${pageContext.request.contextPath}/liquidations">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>

            Thanh lý
        </a>
    </c:if>

    <c:if test="${not empty perms and perms.contains('transfers.view')}">
        <a href="${pageContext.request.contextPath}/transfers" class="${activePage == 'transfer-list' or activePage == 'transfer-detail' or activePage == 'transfer-create' or activePage == 'transfer-edit' ? 'active' : ''}">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>
            Luân chuyển kho
        </a>
    </c:if>


    <div class="nav-section">Quản trị</div>


    <c:if test="${not empty perms and perms.contains('categories.view')}">
        <div class="nav-parent" onclick="this.classList.toggle('open');this.nextElementSibling.classList.toggle('open')">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="3"/>
            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
            </svg>
            Khai báo danh mục
            <span class="arrow"></span>
        </div>
        <div class="nav-children">
            <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20v%e1%ba%adt%20t%c6%b0">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/><line x1="7" y1="7" x2="7.01" y2="7"/></svg>
                Quản lý vật tư
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20phi%e1%ba%bfu%20xu%e1%ba%a5t%20nh%e1%ba%adp">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                Quản lý xuất nhập
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20phi%e1%ba%bfu%20mua%20b%c3%a1n">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                Quản lý mua bán
            </a>
            <a href="${pageContext.request.contextPath}/admin/categories?module=qu%e1%ba%a3n%20l%c3%bd%20thanh%20l%c3%bd">
                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="21 8 21 21 3 21 3 8"/><rect x="1" y="3" width="22" height="5"/><line x1="10" y1="12" x2="14" y2="12"/></svg>

                Quản lý thanh lý
            </a>
        </div>
    </c:if>

    <c:if test="${not empty perms and perms.contains('system_log.view')}">
        <a href="${pageContext.request.contextPath}/admin/system-log"
           class="${activePage == 'system-log' ? 'active' : ''}">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
            <polyline points="14 2 14 8 20 8"/>
            <line x1="8" y1="13" x2="16" y2="13"/>
            <line x1="8" y1="17" x2="16" y2="17"/>
            <polyline points="10 9 9 9 8 9"/>
            </svg>
            System Log
        </a>
    </c:if>


    <c:if test="${not empty perms and (perms.contains('users.view') or perms.contains('roles.view') or perms.contains('forgot_pw.process'))}">
        <div class="nav-parent" onclick="this.classList.toggle('open');this.nextElementSibling.classList.toggle('open')">
            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
            Quản lý chung
            <span class="arrow"></span>
        </div>
        <div class="nav-children">
            <c:if test="${not empty perms and perms.contains('users.view')}">
                <a href="${pageContext.request.contextPath}/admin/users">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
                    Người dùng
                </a>
            </c:if>

            <c:if test="${not empty perms and perms.contains('roles.view')}">
                <a href="${pageContext.request.contextPath}/admin/roles">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    Phân quyền
                </a>
            </c:if>

            <c:if test="${not empty perms and perms.contains('forgot_pw.process')}">
                <a href="${pageContext.request.contextPath}/admin/forgot-password">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"></path>
                    <path d="M21 3v5h-5"></path>
                    <path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"></path>
                    <path d="M3 21v-5h5"></path>
                    </svg>
                    Cấp mật khẩu
                </a>
            </c:if>
        </div>
    </c:if>

    <c:if test="${not empty perms and perms.contains('warehouses.view')}">
        <a href="${pageContext.request.contextPath}/warehouse?action=list">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/></svg>
            Kho hàng
        </a>
    </c:if>

    <a href="${pageContext.request.contextPath}/warehouse/generators">
        <svg class="icon" viewBox="0 0 24 24"><path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/></svg>
        Máy phát điện
    </a>

    <div class="nav-section">Tài khoản</div>


    <c:if test="${not empty perms and perms.contains('profile.view')}">
        <a href="${pageContext.request.contextPath}/profile" class="${activePage == 'profile' ? 'active' : ''}">
            <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Hồ sơ của tôi
        </a>
    </c:if>

    <c:if test="${not empty perms and perms.contains('password.change')}">
        <a href="${pageContext.request.contextPath}/changepass" class="${activePage == 'changepass' ? 'active' : ''}">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Đổi mật khẩu
        </a>
    </c:if>

    <a href="${pageContext.request.contextPath}/authen?action=logout">
        <svg class="icon" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        Đăng xuất
    </a>
</nav>
<div class="sidebar-footer">
    <div class="user-meta">
        <div class="name"><c:out value="${fullName}"/></div>
        <div class="role"><c:out value="${roleDesc}"/></div>
    </div>
</aside>
<script>
    (function () {
        var badge = document.getElementById('proposalBadge');
        if (!badge) { return; }
        var ctx = (window.APP_CTX || '${pageContext.request.contextPath}');
        fetch(ctx + '/proposal?action=countPending', { credentials: 'same-origin' })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data && data.canApprove && data.count > 0) {
                    badge.textContent = data.count > 99 ? '99+' : data.count;
                    badge.style.display = 'inline-block';
                }
            })
            .catch(function () {});
    })();
</script>
