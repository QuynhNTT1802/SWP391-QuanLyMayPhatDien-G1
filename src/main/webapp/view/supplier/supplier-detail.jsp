<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết nhà cung cấp — Warehouse OS</title>
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
            <h1>Chi tiết nhà cung cấp</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">Nhà cung cấp</a> / <span id="crumbId"><c:out value="${supplier.name}"/></span></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                <a class="btn" href="${pageContext.request.contextPath}/warehouse/suppliers?action=update&id=${supplier.id}">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                    Chỉnh sửa
                </a>
                <c:choose>
                    <c:when test="${supplier.status == 'active'}">
                        <a class="btn btn-danger" href="${pageContext.request.contextPath}/warehouse/suppliers?action=deactivate&id=${supplier.id}">
                            Khóa
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a class="btn" href="${pageContext.request.contextPath}/warehouse/suppliers?action=activate&id=${supplier.id}">
                            Kích hoạt
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </header>

        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/warehouse/suppliers?action=list">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <div class="hero">
                <div class="hero-avatar purple"><c:out value="${supplier.name.substring(0,2)}"/></div>
                <div class="hero-body">
                    <h2 class="hero-name">
                        <c:out value="${supplier.name}"/>
                        <c:if test="${not empty supplierTypeName}">
                            <span class="verified"><c:out value="${supplierTypeName}"/></span>
                        </c:if>
                    </h2>
                    <div class="hero-meta">
                        <span class="mono"><c:out value="${supplier.phone}"/></span>
                        <span class="sep">·</span>
                        <span class="id">#<c:out value="${supplier.id}"/></span>
                        <span class="sep">·</span>
                        <span>Tạo ngày <c:out value="${createdDate}"/></span>
                    </div>
                    <div class="hero-pills">
                        <c:choose>
                            <c:when test="${supplier.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                            <c:when test="${supplier.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="layout">
                <div class="toc">
                    <a class="toc-item active" data-toc="basic"><span class="toc-num">01</span><span>Thông tin cơ bản</span></a>
                    <a class="toc-item" data-toc="logs"><span class="toc-num">02</span><span>Nhật ký hoạt động</span></a>
                    <div class="toc-meta">
                        <strong>#<c:out value="${supplier.id}"/></strong><br>
                        Tạo: <c:out value="${createdDate}"/><br>
                        Cập nhật: <c:out value="${updatedDate}"/>
                    </div>
                </div>

                <div class="content">
                    <section class="section" id="basic">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN CƠ BẢN</div>
                                <h3 class="section-title">Thông tin liên hệ & phân loại</h3>
                            </div>
                            <div class="section-update">Cập nhật <c:out value="${updatedDate}"/></div>
                        </div>
                        <div class="info-grid">
                            <div class="info-field">
                                <div class="info-label">Tên nhà cung cấp</div>
                                <div class="info-value"><c:out value="${supplier.name}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Số điện thoại</div>
                                <div class="info-value mono"><c:out value="${supplier.phone}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Email</div>
                                <div class="info-value"><c:out value="${not empty supplier.email ? supplier.email : '—'}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Địa chỉ</div>
                                <div class="info-value"><c:out value="${not empty supplier.address ? supplier.address : '—'}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Loại nhà cung cấp</div>
                                <div class="info-value"><c:out value="${supplierTypeName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Tên công ty</div>
                                <div class="info-value"><c:out value="${not empty supplier.companyName ? supplier.companyName : '—'}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${supplier.status == 'active'}"><span class="pill status-active"><span class="pdot"></span>Đang hoạt động</span></c:when>
                                        <c:when test="${supplier.status == 'locked'}"><span class="pill status-active" style="color:var(--danger)"><span class="pdot"></span>Bị khóa</span></c:when>
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
                        </div>
                    </section>

                    <section class="section" id="logs">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — NHẬT KÝ HOẠT ĐỘNG</div>
                                <h3 class="section-title">Lịch sử thao tác</h3>
                            </div>
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