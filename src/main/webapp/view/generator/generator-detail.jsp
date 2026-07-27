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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/generator.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory-check.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <c:set var="catBrand" value=""/>
            <c:set var="catType" value=""/>
            <c:set var="catOrigin" value=""/>

            <c:set var="catFuel" value=""/>
            <c:set var="catPhase" value=""/>
            <c:set var="catPowerRange" value=""/>
            <c:forEach var="cat" items="${generator.categories}">
                <c:if test="${cat.type == 'brand'}"><c:set var="catBrand" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'generator_type'}"><c:set var="catType" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'origin'}"><c:set var="catOrigin" value="${cat.name}"/></c:if>

                <c:if test="${cat.type == 'fuel_type'}"><c:set var="catFuel" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'phase'}"><c:set var="catPhase" value="${cat.name}"/></c:if>
                <c:if test="${cat.type == 'power_range'}"><c:set var="catPowerRange" value="${cat.name}"/></c:if>
            </c:forEach>

            <div>
                <header class="topbar">
                    <h1>Chi tiết máy phát điện</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/generators?action=list">Máy phát điện</a> / <span id="crumbId"><c:out value="${generator.model}"/></span></span>
                    <div class="top-actions">
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
                                <span class="power-rating"><span class="pdot"></span><c:out value="${generator.powerRating}"/> kVA</span>
                                <c:if test="${not empty catFuel}"><span class="fuel-type"><span class="pdot"></span><c:out value="${catFuel}"/></span></c:if>                              
                            </div>
                        </div>
                    </div>

                    <div class="section" id="basic">
                                <div class="section-head">
                                    <h3>Thông tin chung</h3>
                                </div>
                                <div class="section-body">
                                    <div class="form-grid cols-5">
                                        <div class="info-field">
                                            <label>Mẫu máy</label>
                                            <input class="info-input mono" type="text" disabled value="<c:out value='${generator.model}'/>">
                                        </div>
                                        <div class="info-field">
                                            <label>Thương hiệu</label>
                                            <input class="info-input" type="text" disabled value="<c:out value='${catBrand}'/>">
                                        </div>
                                        <div class="info-field">
                                            <label>Loại máy</label>
                                            <input class="info-input" type="text" disabled value="<c:out value='${catType}'/>">
                                        </div>
                                        <div class="info-field">
                                            <label>Xuất xứ</label>
                                            <input class="info-input" type="text" disabled value="<c:out value='${catOrigin}'/>">
                                        </div>
                                        <div class="info-field">
                                            <label>Trạng thái</label>
                                            <input class="info-input" type="text" disabled value="${generator.status == 'active' ? 'Đang hoạt động' : (generator.status == 'locked' ? 'Bị khóa' : '')}">
                                        </div>
                                    </div>
                                    <div class="form-grid cols-5 grid-mt-14">
                                        <div class="info-field">
                                            <label>Ngày tạo</label>
                                            <input class="info-input mono" type="text" disabled value="<c:out value='${createdDate}'/>">
                                        </div>
                                        <div class="info-field">
                                            <label>Cập nhật cuối</label>
                                            <input class="info-input mono" type="text" disabled value="<c:out value='${updatedDate}'/>">
                                        </div>
                                        <c:if test="${not empty generator.description}">
                                            <div class="info-field">
                                                <label>Mô tả</label>
                                                <input class="info-input" type="text" disabled value="<c:out value='${generator.description}'/>">
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                    <div class="section" id="technical">
                        <div class="section-head">
                            <h3>Thông số kỹ thuật</h3>
                        </div>
                        <div class="section-body">
                            <div class="form-grid cols-5">
                                <div class="info-field">
                                    <label>Công suất</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${generator.powerRating}'/> kVA">
                                </div>
                                <div class="info-field">
                                    <label>Tần số</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${generator.frequency}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Pha</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${catPhase}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Nhiên liệu</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${catFuel}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Trọng lượng</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${not empty generator.weight ? generator.weight : "—"}'/> kg">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section" id="logs">
                        <div class="section-head">
                            <h3>Nhật ký hoạt động</h3>
                        </div>
                        <c:choose>
                            <c:when test="${empty activityLogs}">
                                <div class="actlog-empty">Chưa có hoạt động nào.</div>
                            </c:when>
                            <c:otherwise>
                                <table class="actlog-table">
                                    <thead>
                                        <tr>
                                            <th class="col-user">Người thực hiện</th>
                                            <th>Hành động</th>
                                            <th class="col-time">Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${activityLogs}" varStatus="st">
                                            <tr>
                                                <td class="col-user"><c:out value="${log.username}"/></td>
                                                <td><c:out value="${log.details}"/></td>
                                                <td class="col-time"><c:out value="${logDates[st.index]}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
