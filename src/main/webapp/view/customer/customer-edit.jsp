<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa khách hàng — Warehouse OS</title>
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
                        <h1>Chỉnh sửa khách hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/customers?action=list">Khách hàng</a> / <span><c:out value="${customer.name}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.errors}">
                        <c:forEach var="err" items="${sessionScope.errors}">
                            <div style="background:#ffeaea;color:#e74c3c;border:1px solid #e7b4b4;border-radius:6px;padding:10px 16px;margin-bottom:8px;font-size:13px;font-weight:600;">
                                <c:out value="${err.value}"/>
                            </div>
                        </c:forEach>
                        <c:remove var="errors" scope="session"/>
                    </c:if>

                    <a class="back-link" href="${pageContext.request.contextPath}/warehouse/customers?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Quản trị · Chỉnh sửa</div>
                        <h2 class="page-title">Chỉnh sửa khách hàng #<c:out value="${customer.id}"/></h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/warehouse/customers?action=update">
                            <input type="hidden" name="id" value="${customer.id}" />

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                                    <h3 class="form-section-title">Thông tin liên hệ & phân loại</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Tên khách hàng <span class="req">*</span></label>
                                        <c:set var="vName" value="${not empty sessionScope.fieldName ? sessionScope.fieldName : customer.name}"/>
                                        <input class="input" name="name" value="<c:out value="${vName}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                        <c:set var="vPhone" value="${not empty sessionScope.fieldPhone ? sessionScope.fieldPhone : customer.phone}"/>
                                        <input class="input mono" name="phone" value="<c:out value="${vPhone}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Email</label>
                                        <c:set var="vEmail" value="${not empty sessionScope.fieldEmail ? sessionScope.fieldEmail : customer.email}"/>
                                        <input class="input" name="email" type="email" value="<c:out value="${vEmail}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Loại khách hàng</label>
                                        <select class="select" name="customerTypeId">
                                            <option value="">-- Chọn loại KH --</option>
                                            <c:forEach var="t" items="${customerTypeList}">
                                                <option value="${t.id}" <c:if test="${customer.customerTypeId == t.id}">selected</c:if>>${t.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tên công ty</label>
                                        <c:set var="vCompany" value="${not empty sessionScope.fieldCompanyName ? sessionScope.fieldCompanyName : customer.companyName}"/>
                                        <input class="input" name="companyName" value="<c:out value="${vCompany}"/>" />
                                    </div>
                                    <div class="field full-width">
                                        <label class="field-label">Địa chỉ</label>
                                        <c:set var="vAddr" value="${not empty sessionScope.fieldAddress ? sessionScope.fieldAddress : customer.address}"/>
                                        <textarea class="input" name="address" rows="3"><c:out value="${vAddr}"/></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — GHI CHÚ & TRẠNG THÁI</div>
                                    <h3 class="form-section-title">Thông tin bổ sung</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field full-width">
                                        <label class="field-label">Ghi chú</label>
                                        <c:set var="vNote" value="${not empty sessionScope.fieldNote ? sessionScope.fieldNote : ''}"/>
                                        <textarea class="input" name="note" rows="3"><c:out value="${vNote}"/></textarea>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Trạng thái</label>
                                        <select class="select" name="status">
                                            <option value="active" <c:if test="${customer.status == 'active'}">selected</c:if>>Hoạt động</option>
                                            <option value="locked" <c:if test="${customer.status == 'locked'}">selected</c:if>>Bị khóa</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                    <a class="btn" href="${pageContext.request.contextPath}/warehouse/customers?action=view&id=${customer.id}">Hủy</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                    Cập nhật
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <c:remove var="fieldName" scope="session"/>
        <c:remove var="fieldPhone" scope="session"/>
        <c:remove var="fieldEmail" scope="session"/>
        <c:remove var="fieldAddress" scope="session"/>
        <c:remove var="fieldCompanyName" scope="session"/>
        <c:remove var="fieldCustomerTypeId" scope="session"/>
        <c:remove var="fieldNote" scope="session"/>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>