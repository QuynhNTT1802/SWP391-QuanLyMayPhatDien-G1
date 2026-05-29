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

            <%-- Extract categories by type for easy access --%>
            <c:set var="catBrand" value=""/>
            <c:set var="catType" value=""/>
            <c:set var="catOrigin" value=""/>
            <c:set var="catCondition" value=""/>
            <c:set var="catFuel" value=""/>
            <c:set var="catPhase" value=""/>
            <c:set var="catPowerRange" value=""/>
            <c:forEach var="cat" items="${generator.categories}">
                <c:if test="${cat.type == 'brand'}"><c:set var="catBrand" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'generator_type'}"><c:set var="catType" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'origin'}"><c:set var="catOrigin" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'condition'}"><c:set var="catCondition" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'fuel_type'}"><c:set var="catFuel" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'phase'}"><c:set var="catPhase" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'power_range'}"><c:set var="catPowerRange" value="${cat.name}"/></c:if>
            </c:forEach>

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
                                <c:if test="${not empty catType}">
                                    <span class="verified"><c:out value="${catType}"/></span>
                                </c:if>
                            </h2>
                            <div class="hero-meta">
                                <span><c:out value="${catBrand}"/></span>
                                <span class="sep">·</span>
                                <span class="id">#<c:out value="${generator.id}"/></span>
                                <span class="sep">·</span>
                                <span>Tạo ngày <c:out value="${createdDate}"/></span>
                            </div>
                            <div class="hero-pills">
                                <span class="pill role-admin"><span class="pdot"></span><c:out value="${generator.powerRating}"/> kVA</span>
                                <c:if test="${not empty catFuel}"><span class="pill role-admin"><span class="pdot"></span><c:out value="${catFuel}"/></span></c:if>
                                    <c:choose>
                                        <c:when test="${generator.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                                    <c:when test="${generator.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="layout">
                        <div class="toc">
                            <a class="toc-item active" data-toc="basic"><span class="toc-num">01</span><span>Thông tin cơ bản</span></a>
                            <a class="toc-item" data-toc="technical"><span class="toc-num">02</span><span>Thông tin kỹ thuật</span></a>
                            <a class="toc-item" data-toc="logs"><span class="toc-num">03</span><span>Nhật ký hoạt động</span></a>
                            <div class="toc-meta">
                                <strong>#<c:out value="${generator.id}"/></strong><br>
                                Tạo: <c:out value="${createdDate}"/><br>
                                Cập nhật: <c:out value="${updatedDate}"/>
                            </div>
                        </div>

                        <div class="content">
                            <section class="section" id="basic">
                                <div class="section-head">
                                    <div>
                                        <div class="section-num">01 — THÔNG TIN CƠ BẢN</div>
                                        <h3 class="section-title">Danh mục &amp; thông tin chung</h3>
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
                                        <div class="info-value"><c:out value="${catBrand}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Loại máy</div>
                                        <div class="info-value"><c:out value="${catType}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Xuất xứ</div>
                                        <div class="info-value"><c:out value="${catOrigin}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Tình trạng</div>
                                        <div class="info-value"><c:out value="${catCondition}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Đơn giá</div>
                                        <div class="info-value mono"><fmt:formatNumber value="${generator.unitPrice}" pattern="#,###"/> VNĐ</div>
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

                            <section class="section" id="technical">
                                <div class="section-head">
                                    <div>
                                        <div class="section-num">02 — THÔNG TIN KỸ THUẬT</div>
                                        <h3 class="section-title">Thông số vận hành</h3>
                                    </div>
                                </div>
                                <div class="info-grid">
                                    <div class="info-field">
                                        <div class="info-label">Công suất</div>
                                        <div class="info-value mono"><c:out value="${generator.powerRating}"/> kVA</div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Tần số</div>
                                        <div class="info-value mono"><c:out value="${generator.frequency}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Pha</div>
                                        <div class="info-value"><c:out value="${catPhase}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Nhiên liệu</div>
                                        <div class="info-value"><c:out value="${catFuel}"/></div>
                                    </div>
                                    <div class="info-field">
                                        <div class="info-label">Trọng lượng</div>
                                        <div class="info-value mono">
                                            <c:choose>
                                                <c:when test="${not empty generator.weight}"><fmt:formatNumber value="${generator.weight}" pattern="#,###.#"/> kg</c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </section>
                            
                                        <section class="section" id="logs">
                                            <div class="section-head">
                                                <div>
                                                    <div class="section-num">03 — NHẬT KÝ HOẠT ĐỘNG</div>
                                                    <h3 class="section-title">Lịch sử thao tác</h3>
                                                </div>
                                            </div>
                                            <div class="info-grid">
                                                <c:choose>
                                                    <c:when test="${empty activityLogs}">
                                                        <p>Chưa có hoạt động nào.</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <table class="users">
                                                            <thead>
                                                                <tr>
                                                                    <th>Thời gian</th>
                                                                    <th>Người thực hiện</th>
                                                                    <th>Hành động</th>
                                                                    <th>Chi tiết</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="log" items="${activityLogs}">
                                                                    <tr>
                                                                        <td><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                                        <td><c:out value="${log.username}"/></td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when test="${log.action == 'CREATE'}"><span class="pill status-active">Tạo mới</span></c:when>
                                                                                <c:when test="${log.action == 'UPDATE'}"><span class="pill role-admin">Cập nhật</span></c:when>
                                                                                <c:when test="${log.action == 'ACTIVATE'}"><span class="pill status-active">Kích hoạt</span></c:when>
                                                                                <c:when test="${log.action == 'DEACTIVATE'}"><span class="pill status-active" style="color:var(--danger)">Khóa</span></c:when>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td><c:out value="${log.details}"/></td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </c:otherwise>
                                                </c:choose>
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