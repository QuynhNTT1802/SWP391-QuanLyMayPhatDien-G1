<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thêm nhà cung cấp — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/supplier.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Thêm nhà cung cấp</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">Nhà cung cấp</a> / Thêm mới</span>
            <div class="top-actions">
                </div>
        </header>

        <main>
            <c:if test="${not empty sessionScope.message}">
                <div class="alert-success">
                    <c:out value="${sessionScope.message}"/>
                </div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errors}">
                <c:forEach var="err" items="${sessionScope.errors}">
                    <div class="alert-danger">
                        <c:out value="${err.value}"/>
                    </div>
                </c:forEach>
                <c:remove var="errors" scope="session"/>
            </c:if>

            <a class="back-link" href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="page-head">
                <div class="eyebrow">Quản lý nhà cung cấp · Nhà cung cấp mới</div>
                <h2 class="page-title">Thêm nhà cung cấp</h2>
            </div>

            <div class="form-layout">
                <form class="form-card" method="post" action="${pageContext.request.contextPath}/warehouse/suppliers?action=create">
                    <input type="hidden" name="returnUrl" value="<c:out value="${returnUrl}"/>" />
                    <input type="hidden" name="rowGid" value="<c:out value="${rowGid}"/>" />

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                            <h3 class="form-section-title">Thông tin liên hệ & phân loại</h3>
                        </div>
                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Tên nhà cung cấp <span class="req">*</span></label>
                                <c:set var="_nameValue" value="${empty sessionScope.fieldName ? prefillName : sessionScope.fieldName}" />
                                <input class="input" name="name" placeholder="VD: Công ty TNHH ABC" value="<c:out value="${_nameValue}"/>" required />
                            </div>
                            <div class="field">
                                <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                <input class="input mono" name="phone" placeholder="VD: 0912345678" value="<c:out value="${sessionScope.fieldPhone}"/>" required />
                            </div>
                            <div class="field">
                                <label class="field-label">Email</label>
                                <input class="input" name="email" type="email" placeholder="email@example.com" value="<c:out value="${sessionScope.fieldEmail}"/>" />
                            </div>
                            <div class="field">
                                <label class="field-label">Loại nhà cung cấp</label>
                                <select class="select" name="supplierTypeId">
                                    <option value="">-- Chọn loại NCC --</option>
                                    <c:forEach var="t" items="${supplierTypeList}">
                                        <option value="${t.id}" <c:if test="${sessionScope.fieldSupplierTypeId == t.id}">selected</c:if>>${t.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="field">
                                <label class="field-label">Tên công ty</label>
                                <input class="input" name="companyName" placeholder="VD: Công ty TNHH ABC" value="<c:out value="${sessionScope.fieldCompanyName}"/>" />
                            </div>
                            <div class="field full-width">
                                <label class="field-label">Địa chỉ</label>
                                <textarea class="input" name="address" rows="3" placeholder="VD: Số 1, Đường ABC, Quận 1, TP.HCM"><c:out value="${sessionScope.fieldAddress}"/></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">02 — TRẠNG THÁI</div>
                            <h3 class="form-section-title">Thông tin bổ sung</h3>
                        </div>
                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Trạng thái</label>
                                <select class="select" name="status">
                                    <option value="active">Hoạt động</option>
                                    <option value="locked">Bị khóa</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-section form-actions-end">
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">Hủy</a>
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Thêm nhà cung cấp
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
<c:remove var="fieldSupplierTypeId" scope="session"/>
<c:remove var="fieldNote" scope="session"/>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
