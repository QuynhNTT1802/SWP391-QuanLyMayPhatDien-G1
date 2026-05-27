<%-- 
    Document   : generator-detail
    Created on : May 25, 2026, 4:59:55 PM
    Author     : LENOVO
--%>

<%-- 
    Document   : generator-detail
    Created on : May 23, 2026
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết máy phát điện — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Chi tiết máy phát điện</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/generators?action=list">Máy phát điện</a> / <span id="crumbId"><c:out value="${generator.model}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="${pageContext.request.contextPath}/warehouse/generators?action=update&id=${generator.id}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
                <c:choose>
                    <c:when test="${generator.status == 'active'}">
                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/warehouse/generators?action=deactivate&id=${generator.id}">
                            Khóa
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse/generators?action=activate&id=${generator.id}">
                            Kích hoạt
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse/generators?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar purple"><c:out value="${generator.model.substring(0,2)}"/></div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${generator.model}"/>
                        <c:if test="${generator.status == 'active'}">
                            <span class="verified"><svg viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg> Đang hoạt động</span>
                        </c:if>
                    </h2>
                    <div class="hero-meta">
                        <span>
                            <c:forEach var="cat" items="${generator.categories}" varStatus="loop">
                                ${cat.name}<c:if test="${!loop.last}"> · </c:if>
                            </c:forEach>
                        </span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${generator.id}"/></span>
                        <span class="sep">·</span>
                        <span>Tạo ngày <c:out value="${createdDate}"/></span>
                    </div>
                    <div class="hero-pills">
                        <span class="pill role-admin"><span class="pdot"></span><c:out value="${generator.powerRating}"/> kVA</span>
                        <c:choose>
                            <c:when test="${generator.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${generator.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                        </c:choose>
                    </div>
                </div>
                <div class="hero-actions">
                    <a class="btn" href="${pageContext.request.contextPath}/warehouse/generators?action=update&id=${generator.id}">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                        Chỉnh sửa
                    </a>
                </div>
            </div>

            <div class="layout">
                <div class="toc">
                    <a class="toc-item active" data-toc="info"><span class="toc-num">01</span><span>Thông tin máy</span></a>
                    <div class="toc-meta">
                        <strong>#<c:out value="${generator.id}"/></strong><br>
                        Tạo: <c:out value="${createdDate}"/><br>
                        Cập nhật: <c:out value="${updatedDate}"/>
                    </div>
                </div>

                <div class="content">
                    <section class="section" id="info">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN MÁY PHÁT ĐIỆN</div>
                                <h3 class="section-title">Thông số kỹ thuật &amp; thông tin</h3>
                            </div>
                            <div class="section-update">Cập nhật <c:out value="${updatedDate}"/></div>
                        </div>
                        <div class="info-grid">
                            <div class="info-field">
                                <div class="info-label">Mẫu máy</div>
                                <div class="info-value mono"><c:out value="${generator.model}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Thương hiệu</div>
                                <div class="info-value">
                                    <c:forEach var="cat" items="${generator.categories}" varStatus="loop">
                                        ${cat.name}<c:if test="${!loop.last}">, </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Công suất</div>
                                <div class="info-value mono"><c:out value="${generator.powerRating}"/> kVA</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Đơn giá</div>
                                <div class="info-value mono"><fmt:formatNumber value="${generator.unitPrice}" pattern="#,###"/> VND</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Số lượng tồn kho</div>
                                <div class="info-value mono"><c:out value="${generator.stockQuantity}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${generator.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                                        <c:when test="${generator.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Ngày tạo</div>
                                <div class="info-value mono"><c:out value="${createdDate}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Cập nhật cuối</div>
                                <div class="info-value mono"><c:out value="${updatedDate}"/></div>
                            </div>
                            <c:if test="${not empty generator.description}">
                            <div class="info-field full-width">
                                <div class="info-label">Mô tả</div>
                                <div class="info-value"><c:out value="${generator.description}"/></div>
                            </div>
                            </c:if>
                        </div>
                    </section>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>