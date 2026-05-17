<%-- 
    Document   : role-error
    Created on : May 17, 2026, 9:12:15 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <h1>403 — Không có quyền truy cập</h1>
    <p>Bạn không có quyền "${requiredPerm}" để truy cập trang này.</p>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Về Dashboard</a>
</html>
