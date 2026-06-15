<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.quanlymayphatdien.g1.dal.NotificationDAO" %>
<%@ page import="com.quanlymayphatdien.g1.entity.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    int __unread = 0;
    Object __u = session.getAttribute("loggedUser");
    if (__u instanceof User) {
        __unread = new NotificationDAO().countUnread(((User) __u).getId());
    }
    request.setAttribute("__bellUnread", __unread);
%>
<div class="bell-wrap">
    <button type="button" class="icon-btn bell-btn" id="notifBell" title="Thông báo"
            data-endpoint="${pageContext.request.contextPath}/notifications">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6">
            <path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/>
            <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
        </svg>
        <c:if test="${__bellUnread > 0}">
            <span class="bell-badge" id="notifBadge">
                <c:choose>
                    <c:when test="${__bellUnread > 99}">99+</c:when>
                    <c:otherwise>${__bellUnread}</c:otherwise>
                </c:choose>
            </span>
        </c:if>
    </button>

    <div class="bell-dropdown" id="notifDropdown" hidden>
        <div class="bell-head">
            <span>Thông báo</span>
            <button type="button" class="bell-mark-all" id="notifMarkAll">Đánh dấu tất cả đã đọc</button>
        </div>
        <div class="bell-list" id="notifList">
            <div class="bell-empty">Đang tải...</div>
        </div>
        <a class="bell-foot" href="${pageContext.request.contextPath}/notifications">Xem tất cả</a>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/notification-bell.js" defer></script>
