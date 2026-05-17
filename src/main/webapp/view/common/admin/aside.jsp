<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.quanlymayphatdien.g1.entity.User"%>
<%@page import="java.util.Set"%>
<%
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";

    User sidebarUser = (User) request.getAttribute("sidebarUser");
    if (sidebarUser == null) {
        HttpSession sess = request.getSession(false);
        if (sess != null) {
            sidebarUser = (User) sess.getAttribute("loggedUser");
        }
    }

    Set<String> userPermissions = (Set<String>) request.getAttribute("sidebarPermissions");
    if (userPermissions == null) {
        HttpSession sess = request.getSession(false);
        if (sess != null) {
            userPermissions = (Set<String>) sess.getAttribute("userPermissions");
        }
    }

    boolean hasDashboard    = userPermissions != null && userPermissions.contains("dashboard.view");
    boolean hasInventory    = userPermissions != null && userPermissions.contains("inventory.view");
    boolean hasImportExport = userPermissions != null && userPermissions.contains("import_export.view");
    boolean hasOrders       = userPermissions != null && userPermissions.contains("orders.view");
    boolean hasUsers        = userPermissions != null && userPermissions.contains("users.view");
    boolean hasRoles        = userPermissions != null && userPermissions.contains("roles.view");
    boolean hasSuppliers    = userPermissions != null && userPermissions.contains("suppliers.view");
    boolean hasProfile      = userPermissions != null && userPermissions.contains("profile.view");
    boolean hasPassword     = userPermissions != null && userPermissions.contains("password.change");

    String fullName = sidebarUser != null && sidebarUser.getName() != null ? sidebarUser.getName() : "Nguoi dung";
    String initials = "";
    String[] nameParts = fullName.trim().split("\\s+");
    if (nameParts.length == 1) {
        initials = nameParts[0].length() >= 2 ? nameParts[0].substring(0, 2).toUpperCase() : nameParts[0].toUpperCase();
    } else {
        initials = (nameParts[0].charAt(0) + nameParts[nameParts.length - 1].charAt(0) + "").toUpperCase();
    }
%>
<aside class="sidebar">
    <div class="brand">
        <div class="brand-mark">WH</div>
        <div>Warehouse OS</div>
    </div>
    <nav class="nav">
        <div class="nav-section">Tong quan</div>
        <% if (hasDashboard) { %>
        <a href="<%=request.getContextPath()%>/admin/dashboard">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            Dashboard
        </a>
        <% } %>
        <% if (hasInventory) { %>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
            Ton kho
            <span class="count">12.4k</span>
        </a>
        <% } %>
        <% if (hasImportExport) { %>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M3 12h18M3 18h12"/></svg>
            Phieu nhap/xuat
            <span class="count">23</span>
        </a>
        <% } %>
        <% if (hasOrders) { %>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            Don hang
        </a>
        <% } %>

        <div class="nav-section">Quan tri</div>
        <% if (hasUsers) { %>
        <a href="<%=request.getContextPath()%>/admin/users">
            <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
            Nguoi dung
            <span class="count">142</span>
        </a>
        <% } %>
        <% if (hasRoles) { %>
        <a href="<%=request.getContextPath()%>/admin/roles">
            <svg class="icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            Phan quyen
        </a>
        <% } %>
        <% if (hasSuppliers) { %>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            Nha cung cap
        </a>
        <% } %>

        <div class="nav-section">Tai khoan</div>
        <% if (hasProfile) { %>
        <a href="<%=request.getContextPath()%>/profile" class="<%= "profile".equals(activePage) ? "active" : "" %>">
            <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Ho so cua toi
        </a>
        <% } %>
        <% if (hasPassword) { %>
        <a href="<%=request.getContextPath()%>/changepass" class="<%= "changepass".equals(activePage) ? "active" : "" %>">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Doi mat khau
        </a>
        <% } %>
        <a href="<%=request.getContextPath()%>/authen?action=logout">
            <svg class="icon" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            Dang xuat
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="user-meta">
            <div class="name"><%=fullName%></div>
            <div class="role"><%= sidebarUser != null && sidebarUser.getRoles() != null && !sidebarUser.getRoles().isEmpty() ? sidebarUser.getRoles().get(0).getRoleName() : "Nguoi dung" %></div>
        </div>
    </div>
</aside>
