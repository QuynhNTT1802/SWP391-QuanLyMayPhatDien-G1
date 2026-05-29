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
                    <c:if test="${not empty sessionScope.message}">
                        <div style="background:var(--accent);color:var(--bg);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                            <c:out value="${sessionScope.message}"/>
                        </div>
                        <c:remove var="message" scope="session"/>
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
                                    <h3 class="form-section-title">Mẫu máy &amp; thông số</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Mẫu máy <span class="req">*</span></label>
                                        <input class="input" name="model" value="<c:out value="${generator.model}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Công suất (kVA) <span class="req">*</span></label>
                                        <input class="input mono" name="powerRating" type="number" step="0.01" min="0" value="<c:out value="${generator.powerRating}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Đơn giá (VND) <span class="req">*</span></label>
                                        <input class="input mono" name="unitPrice" type="number" step="1" min="0" value="<c:out value="${generator.unitPrice}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Số lượng tồn kho <span class="req">*</span></label>
                                        <input class="input mono" name="stockQuantity" type="number" min="0" value="<c:out value="${generator.stockQuantity}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tần số (Hz)</label>
                                        <input class="input mono" name="frequency" placeholder="VD: 50Hz" value="<c:out value="${generator.frequency}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Cân nặng (kg)</label>
                                        <input class="input mono" name="weight" type="number" step="0.1" min="0" value="<c:out value="${generator.weight}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Mô tả</label>
                                        <textarea class="input" name="description" rows="3" placeholder="Mô tả chi tiết về máy phát điện..."><c:out value="${generator.description}"/></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — PHÂN LOẠI</div>
                                    <h3 class="form-section-title">Danh mục máy</h3>
                                </div>
                                <div class="form-grid">
                                    <c:set var="types" value="brand,phase,fuel_type,generator_type,power_range,condition,origin"/>
                                    <c:set var="labels" value="Thương hiệu,Pha,Nhiên liệu,Loại máy,Dải công suất,Tình trạng,Xuất xứ"/>
                                    <c:forEach var="i" begin="1" end="7">
                                        <div class="field">
                                            <label class="field-label"><c:forTokens items="${labels}" delims="," varStatus="ls"><c:if test="${ls.index == i}">${ls.current}</c:if></c:forTokens></label>
                                            <select class="select" name="categoryIds">
                                                <option value="">-- Chọn --</option>
                                                <c:forEach var="cat" items="${allCategories}">
                                                    <c:forTokens items="${types}" delims="," varStatus="ts">
                                                        <c:if test="${ts.index == i && cat.type == ts.current}">
                                                            <c:set var="isSelected" value="false"/>
                                                            <c:forEach var="gcat" items="${generator.categories}">
                                                                <c:if test="${gcat.id == cat.id}">
                                                                    <c:set var="isSelected" value="true"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            <option value="${cat.id}" ${isSelected ? 'selected' : ''}>${cat.name}</option>
                                                        </c:if>
                                                    </c:forTokens>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:forEach>
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

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
