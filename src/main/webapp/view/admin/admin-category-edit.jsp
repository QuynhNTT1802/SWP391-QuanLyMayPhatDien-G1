<%--
    Document   : admin-category-edit
    Created on : May 24, 2026, 8:48:37 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${empty category ? 'Thêm danh mục' : 'Sửa danh mục'} — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>${empty category ? 'Thêm danh mục' : 'Sửa danh mục'}</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}">${moduleLabel}</a> / ${empty category ? 'Thêm mới' : 'Chỉnh sửa'}</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
            </div>
        </header>

        <main>
            <c:if test="${not empty errors}">
                <c:forEach var="err" items="${errors}">
                    <div class="alert alert-error">
                        <c:out value="${err}"/>
                    </div>
                </c:forEach>
            </c:if>

            <a class="back-link" href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}<c:if test="${not empty param.type}">&type=${param.type}</c:if>">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            

            <div class="form-layout">
                <form class="form-card" id="categoryForm" method="post" action="${pageContext.request.contextPath}/admin/category/save">
                    <c:if test="${category.id > 0}">
                    <input type="hidden" name="id" value="${category.id}">
                    </c:if>
                    <input type="hidden" name="module" value="${currentModule}">
                    <input type="hidden" name="redirectType" value="${not empty category ? category.type : param.type}">

                    <div class="form-section">
                        <div class="form-section-head">
                            <div class="form-section-num">01 — THÔNG TIN DANH MỤC</div>
                            <h3 class="form-section-title">Thông tin cơ bản</h3>
                        </div>
                        <div class="form-grid">
                            <div class="field">
                                <label class="field-label">Tên danh mục <span class="req">*</span></label>
                                <input class="input" name="name" id="fieldName" placeholder="VD: Honda" value="<c:out value="${category.name}"/>" required maxlength="100" />
                                <div class="field-error">Vui lòng nhập tên danh mục (tối đa 100 ký tự)</div>
                            </div>
                            <div class="field">
                                <label class="field-label">Loại danh mục <span class="req">*</span></label>
                                <select class="select" name="type" id="fieldType" required onchange="toggleExtensionSections()">
                                    <option value="">-- Chọn loại --</option>
                                    <c:forEach var="t" items="${types}">
                                        <option value="${t}" ${category.type == t ? 'selected' : ''}>${typeLabels[t] != null ? typeLabels[t] : t}</option>
                                    </c:forEach>
                                </select>
                                <div class="field-error">Vui lòng chọn loại danh mục</div>
                            </div>
                            <div class="field">
                                <label class="field-label">Trạng thái</label>
                                <select class="select" name="status">
                                    <option value="active" ${category.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${category.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="field span-2">
                                <label class="field-label">Mô tả <span class="opt">(tối đa 500 ký tự)</span></label>
                                <textarea class="input" name="description" id="fieldDesc" rows="3" maxlength="500" placeholder="Mô tả ngắn về danh mục"><c:out value="${category.description}"/></textarea>
                                <div class="field-error">Mô tả không được vượt quá 500 ký tự</div>
                            </div>
                        </div>
                    </div>

                    <c:set var="extType" value="${not empty category ? category.type : param.type}"/>

                    <div class="ext-section ${extType == 'brand' ? 'visible' : ''}" id="ext-brand">
                        <c:if test="${extType == 'brand'}">
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — THÔNG TIN HÃNG</div>
                                <h3 class="form-section-title">Chi tiết thương hiệu</h3>
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Quốc gia</label>
                                    <input class="input" name="country" placeholder="VD: Nhật Bản" value="<c:out value="${extension.country}"/>" />
                                </div>
                                <div class="field">
                                    <label class="field-label">Website</label>
                                    <input class="input" name="website" placeholder="VD: honda.com.vn" value="<c:out value="${extension.website}"/>" />
                                </div>
                                <div class="field">
                                    <label class="field-label">Năm thành lập</label>
                                    <input class="input mono" name="foundedYear" type="number" placeholder="VD: 1948" value="<c:out value="${extension.foundedYear}"/>" />
                                </div>
                                <div class="field">
                                    <label class="field-label">Bảo hành (tháng)</label>
                                    <input class="input mono" name="warrantyPeriod" type="number" placeholder="VD: 12" value="<c:out value="${extension.warrantyPeriod}"/>" />
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <div class="ext-section ${extType == 'fuel_type' ? 'visible' : ''}" id="ext-fuel">
                        <c:if test="${extType == 'fuel_type'}">
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — THÔNG TIN NHIÊN LIỆU</div>
                                <h3 class="form-section-title">Chi tiết nhiên liệu</h3>
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Đơn vị</label>
                                    <input class="input" name="unit" placeholder="VD: lít" value="<c:out value="${extension.unit}"/>" />
                                </div>
                                <div class="field">
                                    <label class="field-label">Giá tham khảo (VND)</label>
                                    <input class="input mono" name="typicalPrice" type="number" step="1" min="0" placeholder="VD: 25000" value="<c:out value="${extension.typicalPrice}"/>" />
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <div class="ext-section ${extType == 'origin' ? 'visible' : ''}" id="ext-origin">
                        <c:if test="${extType == 'origin'}">
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — THÔNG TIN XUẤT XỨ</div>
                                <h3 class="form-section-title">Chi tiết xuất xứ</h3>
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Mã quốc gia</label>
                                    <input class="input mono" name="country_code" placeholder="VD: JP" maxlength="5" value="<c:out value="${extension.countryCode}"/>" />
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <div class="ext-section ${extType == 'customer_type' ? 'visible' : ''}" id="ext-customer">
                        <c:if test="${extType == 'customer_type'}">
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — THÔNG TIN LOẠI KHÁCH</div>
                                <h3 class="form-section-title">Chi tiết loại khách hàng</h3>
                            </div>
                            <div class="form-grid">
                                <div class="field">
                                    <label class="field-label">Loại thuế</label>
                                    <select class="select" name="taxType">
                                        <option value="">-- Chọn --</option>
                                        <option value="VAT 10%" ${extension.taxType == 'VAT 10%' ? 'selected' : ''}>VAT 10%</option>
                                        <option value="VAT 8%"  ${extension.taxType == 'VAT 8%' ? 'selected' : ''}>VAT 8%</option>
                                        <option value="VAT 5%"  ${extension.taxType == 'VAT 5%' ? 'selected' : ''}>VAT 5%</option>
                                        <option value="VAT 0%"  ${extension.taxType == 'VAT 0%' ? 'selected' : ''}>VAT 0%</option>
                                        <option value="Không chịu thuế" ${extension.taxType == 'Không chịu thuế' ? 'selected' : ''}>Không chịu thuế</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        </c:if>
                    </div>

                    <div class="ext-section ${extType == 'receipt_reason' or extType == 'receipt_status' or extType == 'order_status' or extType == 'generator_type' or extType == 'phase' or extType == 'condition' ? 'visible' : ''}" id="ext-simple">
                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — THÔNG TIN BỔ SUNG</div>
                                <h3 class="form-section-title">
                                    <c:choose>
                                        <c:when test="${extType == 'generator_type'}">Loại máy phát</c:when>
                                        <c:when test="${extType == 'phase'}">Pha điện</c:when>
                                        <c:when test="${extType == 'condition'}">Tình trạng</c:when>
                                        <c:when test="${extType == 'receipt_reason'}">Lý do xuất/nhập</c:when>
                                        <c:when test="${extType == 'receipt_status'}">Trạng thái phiếu</c:when>
                                        <c:when test="${extType == 'order_status'}">Trạng thái đơn hàng</c:when>
                                        <c:otherwise>Thông tin bổ sung</c:otherwise>
                                    </c:choose>
                                </h3>
                            </div>
                            <p style="color:var(--muted);font-size:13px;font-weight:500;">Danh mục này chỉ yêu cầu thông tin cơ bản. Không có trường mở rộng bổ sung.</p>
                        </div>
                    </div>

                    <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                        <a class="btn" href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}<c:if test="${not empty param.type}">&type=${param.type}</c:if>">Huỷ</a>
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Lưu danh mục
                        </button>
                    </div>
                </form>

                <c:set var="catInitials">
                    <c:choose>
                        <c:when test="${empty category}">?</c:when>
                        <c:otherwise><c:out value="${fn:toUpperCase(fn:substring(category.name, 0, 1))}"/></c:otherwise>
                    </c:choose>
                </c:set>
                <div class="summary-card">
                    <div class="summary-head">
                        <c:choose>
                            <c:when test="${empty category}">
                                <div class="summary-avatar"><c:out value="${catInitials}"/></div>
                            </c:when>
                            <c:otherwise>
                                <div class="summary-avatar has-value"><c:out value="${catInitials}"/></div>
                            </c:otherwise>
                        </c:choose>
                        <div>
                            <c:choose>
                                <c:when test="${empty category}">
                                    <div class="summary-name empty">Danh mục mới</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="summary-name"><c:out value="${category.name}"/></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="summary-rows">
                        <div class="summary-row">
                            <span class="summary-label">Module</span>
                            <span class="summary-value"><c:out value="${moduleLabel}"/></span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Loại</span>
                            <c:choose>
                                <c:when test="${empty extType}">
                                    <span class="summary-value empty">Chưa chọn</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="summary-value"><c:out value="${typeLabels[extType] != null ? typeLabels[extType] : extType}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Trạng thái</span>
                            <c:choose>
                                <c:when test="${category.status == 'inactive'}">
                                    <span class="summary-value">Không hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="summary-value">Hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function toggleExtensionSections() {
    var type = document.getElementById('fieldType').value;
    var sections = document.querySelectorAll('.ext-section');
    sections.forEach(function(s) { s.classList.remove('visible'); });
    var map = {
        'brand': 'ext-brand',
        'fuel_type': 'ext-fuel',
        'origin': 'ext-origin',
        'customer_type': 'ext-customer',
        'generator_type': 'ext-simple',
        'phase': 'ext-simple',
        'condition': 'ext-simple',
        'receipt_reason': 'ext-simple',
        'receipt_status': 'ext-simple',
        'order_status': 'ext-simple'
    };
    var target = map[type];
    if (target) {
        var el = document.getElementById(target);
        if (el) el.classList.add('visible');
    }
    updateSummary();
}

function validateForm() {
    var valid = true;
    var name = document.getElementById('fieldName');
    var typeF = document.getElementById('fieldType');
    var desc = document.getElementById('fieldDesc');

    [name, typeF, desc].forEach(function(f) {
        if (f) { var p = f.closest('.field'); if (p) p.classList.remove('invalid'); }
    });

    if (!name.value.trim() || name.value.trim().length > 100) {
        document.getElementById('fieldName').closest('.field').classList.add('invalid');
        valid = false;
    }
    if (!typeF.value) {
        document.getElementById('fieldType').closest('.field').classList.add('invalid');
        valid = false;
    }
    if (desc.value.length > 500) {
        document.getElementById('fieldDesc').closest('.field').classList.add('invalid');
        valid = false;
    }
    return valid;
}

function updateSummary() {
    var type = document.getElementById('fieldType').value;
    var typeOpt = document.getElementById('fieldType').selectedOptions[0];
    var summaryValue = document.querySelector('.summary-row:nth-child(2) .summary-value');
    if (summaryValue) {
        summaryValue.textContent = typeOpt && typeOpt.textContent !== '-- Chọn loại --' ? typeOpt.textContent : 'Chưa chọn';
        if (!type) summaryValue.classList.add('empty'); else summaryValue.classList.remove('empty');
    }
}

document.getElementById('fieldType').addEventListener('change', toggleExtensionSections);

document.getElementById('categoryForm').addEventListener('submit', function(e) {
    if (!validateForm()) {
        e.preventDefault();
        return false;
    }
});

</script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
