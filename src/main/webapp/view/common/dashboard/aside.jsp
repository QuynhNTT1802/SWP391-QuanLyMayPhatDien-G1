<%-- 
    Document   : aside
    Created on : May 15, 2026, 9:31:04 AM
    Author     : Aadmin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<aside class="sidebar">
    <div class="brand">
        <div class="brand-mark">WH</div>
        <div>Warehouse OS</div>
    </div>
    <nav class="nav">
        <div class="nav-section">Tổng quan</div>
        <a href="index.html">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            Dashboard
        </a>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M3 7l9-4 9 4-9 4z"/><path d="M3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></svg>
            Tồn kho
            <span class="count">12.4k</span>
        </a>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M3 12h18M3 18h12"/></svg>
            Phiếu nhập/xuất
            <span class="count">23</span>
        </a>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
            Đơn hàng
        </a>

        <div class="nav-section">Quản trị</div>
        <a href="admin-users.html">
            <svg class="icon" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M20 8v6M23 11h-6"/></svg>
            Người dùng
            <span class="count">142</span>
        </a>
        <a href="rbac-roles.html">
            <svg class="icon" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
            Phân quyền
        </a>
        <a href="#">
            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
            Nhà cung cấp
        </a>

        <div class="nav-section">Tài khoản</div>
        <a href="profile.html">
            <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Hồ sơ của tôi
        </a>
        <a href="change-password.html">
            <svg class="icon" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Yêu cầu đổi mật khẩu
        </a>

    </nav>
    <div class="sidebar-footer">
        <div class="avatar">TQ</div>
        <div class="user-meta">
            <div class="name">Thúy Quỳnh</div>
            <div class="role">Super Admin</div>
        </div>
    </div>
</aside>