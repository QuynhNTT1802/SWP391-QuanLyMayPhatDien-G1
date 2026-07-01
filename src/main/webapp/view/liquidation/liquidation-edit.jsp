<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Trang này đã được gộp vào detail — chuyển hướng
    String ctx = request.getContextPath();
    String id = request.getParameter("id");
    if (id != null && !id.trim().isEmpty()) {
        String wh = request.getParameter("warehouseId");
        String url = ctx + "/liquidations?action=detail&id=" + id.trim();
        if (wh != null && !wh.trim().isEmpty()) {
            url += "&warehouseId=" + wh.trim();
        }
        response.sendRedirect(url);
    } else {
        response.sendRedirect(ctx + "/liquidations");
    }
%>
