<%-- 
    Document   : generator-create
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
        <title>Thêm máy phát điện — Warehouse OS</title>
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
                        <h1>Thêm máy phát điện</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/warehouse/generators?action=list">Máy phát điện</a> / Thêm mới</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.message}">
                        <div style="background:var(--accent);color:var(--bg);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                            <c:out value="${sessionScope.message}"/>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>
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
                        <div class="eyebrow">Quản lý kho · Máy phát điện mới</div>
                        <h2 class="page-title">Thêm máy phát điện</h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/warehouse/generators?action=create">

                            <%-- ============ SECTION 01: THÔNG TIN CƠ BẢN ============ --%>
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN CƠ BẢN</div>
                                    <h3 class="form-section-title">Mẫu máy &amp; danh mục</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Mẫu máy <span class="req">*</span></label>
                                        <input class="input" name="model" placeholder="VD: GX-5000" value="<c:out value="${sessionScope.fieldModel}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Thương hiệu <span class="req">*</span></label>
                                        <select class="select" name="brandId">
                                            <option value="">-- Chọn thương hiệu --</option>
                                            <c:forEach var="c" items="${brands}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldBrandId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Loại máy</label>
                                        <select class="select" name="genTypeId">
                                            <option value="">-- Chọn loại máy --</option>
                                            <c:forEach var="c" items="${genTypes}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldGenTypeId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Xuất xứ</label>
                                        <select class="select" name="originId">
                                            <option value="">-- Chọn xuất xứ --</option>
                                            <c:forEach var="c" items="${origins}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldOriginId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tình trạng</label>
                                        <select class="select" name="conditionId">
                                            <option value="">-- Chọn tình trạng --</option>
                                            <c:forEach var="c" items="${conditions}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldConditionId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Đơn giá (VNĐ) <span class="req">*</span></label>
                                        <input class="input mono" name="unitPrice" type="number" step="1" min="0" placeholder="VD: 15000000" value="<c:out value="${sessionScope.fieldPrice}"/>" required />
                                    </div>
                                    <div class="field full-width">
                                        <label class="field-label">Mô tả</label>
                                        <textarea class="input" name="description" rows="3" placeholder="Mô tả chi tiết về máy phát điện..."><c:out value="${sessionScope.fieldDesc}"/></textarea>
                                    </div>
                                </div>
                            </div>

                            <%-- ============ SECTION 02: THÔNG TIN KỸ THUẬT ============ --%>
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — THÔNG TIN KỸ THUẬT</div>
                                    <h3 class="form-section-title">Thông số vận hành</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                                        <input class="input mono" name="powerRating" type="number" step="0.01" min="0" placeholder="VD: 5.0" value="<c:out value="${sessionScope.fieldPower}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tần số</label>
                                        <input class="input mono" name="frequency" placeholder="VD: 50Hz" value="<c:out value="${sessionScope.fieldFrequency}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Trọng lượng (kg)</label>
                                        <input class="input mono" name="weight" type="number" step="0.01" min="0" placeholder="VD: 85.5" value="<c:out value="${sessionScope.fieldWeight}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Nhiên liệu</label>
                                        <select class="select" name="fuelTypeId">
                                            <option value="">-- Chọn nhiên liệu --</option>
                                            <c:forEach var="c" items="${fuelTypes}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldFuelTypeId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Pha</label>
                                        <select class="select" name="phaseId">
                                            <option value="">-- Chọn pha --</option>
                                            <c:forEach var="c" items="${phases}">
                                                <option value="${c.id}" <c:if test="${sessionScope.fieldPhaseId == c.id}">selected</c:if>>${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                </div>
                            </div>

                            <%-- ============ SECTION 03: TRẠNG THÁI ============ --%>
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">03 — TRẠNG THÁI</div>
                                    <h3 class="form-section-title">Kích hoạt máy</h3>
                                </div>
                                <div class="form-grid single">
                                    <div class="field">
                                        <label class="field-label">Trạng thái</label>
                                        <select class="select" name="status">
                                            <option value="active">Hoạt động</option>
                                            <option value="locked">Bị khóa</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                <a class="btn" href="${pageContext.request.contextPath}/warehouse/generators?action=list">Hủy</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                    Tạo máy phát điện
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <c:remove var="fieldModel" scope="session"/>
        <c:remove var="fieldBrandId" scope="session"/>
        <c:remove var="fieldGenTypeId" scope="session"/>
        <c:remove var="fieldOriginId" scope="session"/>
        <c:remove var="fieldConditionId" scope="session"/>
        <c:remove var="fieldPrice" scope="session"/>
        <c:remove var="fieldDesc" scope="session"/>
        <c:remove var="fieldPower" scope="session"/>
        <c:remove var="fieldFrequency" scope="session"/>
        <c:remove var="fieldWeight" scope="session"/>
        <c:remove var="fieldFuelTypeId" scope="session"/>
        <c:remove var="fieldPhaseId" scope="session"/>
        <c:remove var="fieldPowerRangeId" scope="session"/>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js" charset="UTF-8"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js" charset="UTF-8"></script>
    </body>
</html>