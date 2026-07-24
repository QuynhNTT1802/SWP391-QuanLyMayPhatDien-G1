<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="dash-hero">
  <div class="dash-hero-left">
    <div class="dash-avatar">
      <c:choose>
        <c:when test="${not empty sessionScope.loggedUser.name}">
          ${fn:substring(sessionScope.loggedUser.name, 0, 1)}
        </c:when>
        <c:otherwise>U</c:otherwise>
      </c:choose>
    </div>
    <div class="dash-welcome">
      <h2>
        Xin chào, ${not empty sessionScope.loggedUser.name ? sessionScope.loggedUser.name : 'Người dùng'}!
        <c:choose>
          <c:when test="${activeRole == 'ceo'}">
            <span class="role-badge ceo">CEO / Ban Giám Đốc</span>
          </c:when>
          <c:when test="${activeRole == 'admin'}">
            <span class="role-badge admin">System Administrator</span>
          </c:when>
          <c:when test="${activeRole == 'warehouse'}">
            <span class="role-badge warehouse">Quản Lý & Vận Hành Kho</span>
          </c:when>
          <c:when test="${activeRole == 'sales'}">
            <span class="role-badge sales">Kinh Doanh & Bán Hàng</span>
          </c:when>
          <c:otherwise>
            <span class="role-badge sales">Thành Viên</span>
          </c:otherwise>
        </c:choose>
      </h2>
      <p>
        <c:choose>
          <c:when test="${activeRole == 'ceo'}">Tổng quan điều hành toàn bộ hoạt động kinh doanh và phê duyệt chứng từ.</c:when>
          <c:when test="${activeRole == 'admin'}">Quản trị tài khoản hệ thống, cấu hình phân quyền và giám sát an toàn.</c:when>
          <c:when test="${activeRole == 'warehouse'}">Theo dõi tồn kho máy phát điện, biến động Nhập / Xuất kho và luân chuyển.</c:when>
          <c:when test="${activeRole == 'sales'}">Quản lý tiến độ đơn hàng, chỉ số kinh doanh và chăm sóc khách hàng.</c:when>
          <c:otherwise>Chào mừng bạn quay trở lại hệ thống Quản lý máy phát điện.</c:otherwise>
        </c:choose>
      </p>
    </div>
  </div>

  <c:if test="${not empty availableDashboardRoles and fn:length(availableDashboardRoles) > 1}">
  <div class="dash-hero-right">
    <div class="role-switcher" title="Chuyển đổi góc nhìn Dashboard">
      <c:forEach var="rKey" items="${availableDashboardRoles}">
        <c:url var="switchUrl" value="/admin/dashboard">
          <c:param name="viewRole" value="${rKey}" />
        </c:url>
        <a href="${switchUrl}" class="role-switch-btn ${activeRole == rKey ? 'active' : ''}">
          <c:choose>
            <c:when test="${rKey == 'ceo'}">CEO</c:when>
            <c:when test="${rKey == 'admin'}">Admin</c:when>
            <c:when test="${rKey == 'warehouse'}">Kho</c:when>
            <c:when test="${rKey == 'sales'}">Kinh doanh</c:when>
          </c:choose>
        </a>
      </c:forEach>
    </div>
  </div>
  </c:if>
</div>
