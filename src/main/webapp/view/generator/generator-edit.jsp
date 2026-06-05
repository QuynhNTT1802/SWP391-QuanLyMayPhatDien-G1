<%-- 
    Document   : generator-edit
    Created on : May 23, 2026
    Author     : Admin
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa máy phát điện — Warehouse OS</title>
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
                        <h1>Chỉnh sửa máy phát điện</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/generators?action=list">Máy phát điện</a> / <span><c:out value="${generator.model}"/></span></span>
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

                    <a class="back-link" href="${pageContext.request.contextPath}/warehouse/generators?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Quản trị · Chỉnh sửa</div>
                        <h2 class="page-title">Chỉnh sửa máy phát điện #<c:out value="${generator.id}"/></h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/warehouse/generators?action=update">
                            <input type="hidden" name="id" value="${generator.id}" />

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                                    <h3 class="form-section-title">Nhận diện &amp; phân loại máy</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Mẫu máy <span class="req">*</span></label>
                                        <c:set var="vModel" value="${not empty sessionScope.fieldModel ? sessionScope.fieldModel : generator.model}"/>
                                        <input class="input" name="model" value="<c:out value="${vModel}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Thương hiệu <span class="req">*</span></label>
                                        <select class="select" name="brandId">
                                            <option value="">-- Chọn thương hiệu --</option>
                                            <c:forEach var="c" items="${brands}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Loại máy</label>
                                        <select class="select" name="genTypeId">
                                            <option value="">-- Chọn loại máy --</option>
                                            <c:forEach var="c" items="${genTypes}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Xuất xứ</label>
                                        <select class="select" name="originId">
                                            <option value="">-- Chọn xuất xứ --</option>
                                            <c:forEach var="c" items="${origins}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tình trạng</label>
                                        <select class="select" name="conditionId">
                                            <option value="">-- Chọn tình trạng --</option>
                                            <c:forEach var="c" items="${conditions}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Đơn giá (VNĐ) <span class="req">*</span></label>
                                        <c:set var="vPrice" value="${not empty sessionScope.fieldPrice ? sessionScope.fieldPrice : generator.unitPrice}"/>
                                        <input class="input mono" name="unitPrice" type="number" step="1" min="0" value="<c:out value="${vPrice}"/>" required />
                                    </div>
                                    <div class="field full-width">
                                        <label class="field-label">Mô tả</label>
                                        <c:set var="vDesc" value="${not empty sessionScope.fieldDesc ? sessionScope.fieldDesc : generator.description}"/>
                                        <textarea class="input" name="description" rows="3" placeholder="Mô tả chi tiết về máy phát điện..."><c:out value="${vDesc}"/></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — THÔNG TIN KỸ THUẬT</div>
                                    <h3 class="form-section-title">Thông số vận hành</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                                        <c:set var="vPower" value="${not empty sessionScope.fieldPower ? sessionScope.fieldPower : generator.powerRating}"/>
                                        <input class="input mono" name="powerRating" type="number" step="0.01" min="0" value="<c:out value="${vPower}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tần số</label>
                                        <c:set var="vFreq" value="${not empty sessionScope.fieldFreq ? sessionScope.fieldFreq : generator.frequency}"/>
                                        <input class="input mono" name="frequency" placeholder="VD: 50Hz" value="<c:out value="${vFreq}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Trọng lượng (kg)</label>
                                        <c:set var="vWeight" value="${not empty sessionScope.fieldWeight ? sessionScope.fieldWeight : generator.weight}"/>
                                        <input class="input mono" name="weight" type="number" step="0.1" min="0" placeholder="VD: 85.5" value="<c:out value="${vWeight}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Nhiên liệu</label>
                                        <select class="select" name="fuelTypeId">
                                            <option value="">-- Chọn nhiên liệu --</option>
                                            <c:forEach var="c" items="${fuelTypes}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Pha</label>
                                        <select class="select" name="phaseId">
                                            <option value="">-- Chọn pha --</option>
                                            <c:forEach var="c" items="${phases}">
                                                <option value="${c.id}" <c:if test="${selectedCatIds.contains(c.id)}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">03 — TRẠNG THÁI</div>
                                    <h3 class="form-section-title">Kích hoạt máy</h3>
                                </div>
                                <div class="form-grid single">
                                    <div class="field">
                                        <label class="field-label">Trạng thái</label>
                                        <select class="select" name="status">
                                            <option value="active" <c:if test="${generator.status == 'active'}">selected</c:if>>Hoạt động</option>
                                            <option value="locked" <c:if test="${generator.status == 'locked'}">selected</c:if>>Bị khóa</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                    <a class="btn" href="${pageContext.request.contextPath}/warehouse/generators?action=view&id=${generator.id}">Hủy</a>
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

        <c:remove var="fieldModel" scope="session"/>
        <c:remove var="fieldPower" scope="session"/>
        <c:remove var="fieldPrice" scope="session"/>
        <c:remove var="fieldFreq" scope="session"/>
        <c:remove var="fieldWeight" scope="session"/>
        <c:remove var="fieldDesc" scope="session"/>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>