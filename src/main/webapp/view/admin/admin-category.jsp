<%--
    Document   : admin-category
    Created on : May 24, 2026, 8:48:05 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${moduleLabel} — Warehouse OS</title>
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
            <h1>
                <c:choose>
                    <c:when test="${not empty currentType}">${typeLabel}</c:when>
                    <c:otherwise>${moduleLabel}</c:otherwise>
                </c:choose>
            </h1>
            
            
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}">Quản trị</a> / ${moduleLabel}<c:if test="${not empty currentType}"> / ${typeLabel}</c:if></span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/category/edit?module=${currentModule}<c:if test="${not empty currentType}">&type=${currentType}</c:if>">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                    Thêm danh mục
                </a>
            </div>
        </header>

        <main>
            <c:if test="${not empty param.msg}">
                <div class="alert alert-success">
                    <c:choose>
                        <c:when test="${param.msg == 'success'}">Lưu danh mục thành công!</c:when>
                        <c:when test="${param.msg == 'deleted'}">Xoá danh mục thành công!</c:when>
                        <c:otherwise>${param.msg}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty currentType}">
                    <a class="back-link" href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}">
                        <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại tổng quan ${moduleLabel}
                    </a>

                    <div class="type-header">
                        <span class="type-badge"><span class="tdot"></span>${typeLabel}</span>
                        <span class="type-count">${totalItems} mục</span>
                        <span class="spacer"></span>
                    </div>

                    <div class="toolbar">
                        <form method="get" action="${pageContext.request.contextPath}/admin/categories" style="display:contents;">
                            <input type="hidden" name="module" value="${currentModule}"/>
                            <input type="hidden" name="type" value="${currentType}"/>
                            <input type="hidden" name="page" value="1"/>
                            <div class="search-input">
                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                <input name="search" value="<c:out value="${param.search}"/>" placeholder="Tìm ${typeLabel}..." autocomplete="off"/>
                            </div>
                            <c:if test="${not empty param.search}">
                                <button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/admin/categories?module=${currentModule}&type=${currentType}'">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                    Xoá lọc
                                </button>
                            </c:if>
                        </form>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead><tr>
                                <th>Tên</th>
                                <c:choose>
                                    <c:when test="${currentType == 'brand'}">
                                        <th>Quốc gia</th><th>Website</th><th>Năm TL</th><th>Bảo hành</th>
                                    </c:when>
                                    <c:when test="${currentType == 'fuel_type'}">
                                        <th>Đơn vị</th><th>Giá tham khảo</th>
                                    </c:when>
                                    <c:when test="${currentType == 'origin'}">
                                        <th>Mã quốc gia</th>
                                    </c:when>
                                    <c:when test="${currentType == 'customer_type'}">
                                        <th>Loại thuế</th>
                                    </c:when>
                                    <c:otherwise>
                                        <th>Mô tả</th>
                                    </c:otherwise>
                                </c:choose>
                                <th>Trạng thái</th>
                                <th class="actions-col">Hành động</th>
                            </tr></thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty categoryList}">
                                    <tr><td colspan="9">
                                        <div class="empty-state">
                                            <div class="icon-wrap">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                                                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>
                                                </svg>
                                            </div>
                                            <strong>Không tìm thấy</strong>
                                            <c:if test="${not empty param.search}">Không có kết quả cho "<c:out value="${param.search}"/>"</c:if>
                                        </div>
                                    </td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="cat" items="${categoryList}">
                                        <tr>
                                            <td><div style="font-weight:600;color:var(--fg);"><c:out value="${cat.name}"/></div></td>
                                            <c:choose>
                                                <c:when test="${currentType == 'brand'}">
                                                    <c:set var="ext" value="${extensions[cat.id]}"/>
                                                    <td><c:out value="${ext.country}"/></td>
                                                    <td style="max-width:150px;overflow:hidden;text-overflow:ellipsis;"><c:out value="${ext.website}"/></td>
                                                    <td><c:out value="${ext.foundedYear}"/></td>
                                                    <td><c:out value="${ext.warrantyPeriod}"/> th</td>
                                                </c:when>
                                                <c:when test="${currentType == 'fuel_type'}">
                                                    <c:set var="ext" value="${extensions[cat.id]}"/>
                                                    <td><c:out value="${ext.unit}"/></td>
                                                    <td><fmt:formatNumber value="${ext.typicalPrice}" pattern="#,###"/> ₫</td>
                                                </c:when>
                                                <c:when test="${currentType == 'origin'}">
                                                    <c:set var="ext" value="${extensions[cat.id]}"/>
                                                    <td><c:out value="${ext.countryCode}"/></td>
                                                </c:when>
                                                <c:when test="${currentType == 'customer_type'}">
                                                    <c:set var="ext" value="${extensions[cat.id]}"/>
                                                    <td><c:out value="${ext.taxType}"/></td>
                                                </c:when>
                                                <c:otherwise>
                                                    <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;"><c:out value="${cat.description}"/></td>
                                                </c:otherwise>
                                            </c:choose>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cat.status == 'active'}"><span class="status active"><span class="sdot"></span>Hoạt động</span></c:when>
                                                    <c:otherwise><span class="status inactive"><span class="sdot"></span>Không hoạt động</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions-col">
                                                <div class="row-actions">
                                                    <button class="icon-mini" onclick="location.href='${pageContext.request.contextPath}/admin/category/edit?id=${cat.id}&module=${currentModule}'" title="Chỉnh sửa">
                                                        <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                    </button>
                                                    <button class="icon-mini danger" onclick="confirmDelete(${cat.id}, '<c:out value="${cat.name}"/>')" title="Xoá">
                                                        <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                        <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&module=${currentModule}&type=${currentType}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?page=${p}&module=${currentModule}&type=${currentType}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&module=${currentModule}&type=${currentType}<c:if test="${not empty param.search}">&search=<c:out value="${param.search}"/></c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                        </c:if>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Quản trị · Danh mục</div>
                            <h2 class="page-title">${moduleLabel}</h2>
                            <div class="page-sub">${totalItems} danh mục · ${types.size()} loại</div>
                        </div>
                    </div>

                    <div class="table-card">
                        <table>
                            <thead><tr>
                                <th>Loại danh mục</th>
                                <th style="width:80px;text-align:right;">Số mục</th>
                                <th style="width:40px;"></th>
                            </tr></thead>
                            <tbody>
                                <c:forEach var="t" items="${types}">
                                    <tr onclick="location.href='?module=${currentModule}&type=${t}'" style="cursor:pointer;">
                                        <td>
                                            <div style="display:flex;align-items:center;gap:10px;">
                                                <span class="sdot" style="<c:choose><c:when test="${t == 'brand'}">background:var(--brand-color);box-shadow:0 0 0 3px var(--brand-soft)</c:when><c:when test="${t == 'fuel_type'}">background:var(--fuel-color);box-shadow:0 0 0 3px var(--fuel-soft)</c:when><c:when test="${t == 'phase'}">background:var(--phase-color);box-shadow:0 0 0 3px var(--phase-soft)</c:when><c:when test="${t == 'generator_type'}">background:var(--gen-color);box-shadow:0 0 0 3px var(--gen-soft)</c:when><c:when test="${t == 'condition'}">background:var(--condition-color);box-shadow:0 0 0 3px var(--condition-soft)</c:when><c:when test="${t == 'origin'}">background:var(--origin-color);box-shadow:0 0 0 3px var(--origin-soft)</c:when><c:when test="${t == 'customer_type'}">background:var(--customer-color);box-shadow:0 0 0 3px var(--customer-soft)</c:when><c:when test="${t == 'receipt_type' or t == 'receipt_reason' or t == 'receipt_status'}">background:var(--receipt-color);box-shadow:0 0 0 3px var(--receipt-soft)</c:when><c:when test="${t == 'order_status'}">background:var(--order-color);box-shadow:0 0 0 3px var(--order-soft)</c:when><c:otherwise>background:var(--muted);box-shadow:0 0 0 3px var(--surface-2)</c:otherwise></c:choose>"></span>
                                                <span style="font-weight:600;color:var(--fg);">${typeLabels[t] != null ? typeLabels[t] : t}</span>
                                            </div>
                                        </td>
                                        <td style="text-align:right;">
                                            <span style="font-family:var(--font-mono);font-weight:600;color:var(--muted);">${typeCounts[t] != null ? typeCounts[t] : 0}</span>
                                        </td>
                                        <td style="text-align:right;">
                                            <svg style="width:14px;height:14px;stroke:var(--muted);fill:none;stroke-width:2;" viewBox="0 0 24 24"><path d="m9 18 6-6-6-6"/></svg>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<div class="modal-host" id="deleteModal">
    <div class="modal">
        <h3>Xác nhận xoá</h3>
        <p id="deleteMsg">Bạn có chắc muốn khoá danh mục này? Danh mục sẽ bị chuyển sang trạng thái không hoạt động.</p>
        <div class="actions">
            <button class="btn" onclick="closeDeleteModal()">Huỷ</button>
            <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/category/delete" style="display:inline;">
                <input type="hidden" name="id" id="deleteId"/>
                <input type="hidden" name="module" value="${currentModule}"/>
                <input type="hidden" name="type" value="${currentType}"/>
                <button type="submit" class="btn btn-danger">Xoá</button>
            </form>
        </div>
    </div>
</div>

<script>
function confirmDelete(id, name) {
    document.getElementById('deleteId').value = id;
    document.getElementById('deleteMsg').textContent = 'Bạn có chắc muốn xoá danh mục "' + name + '"?';
    document.getElementById('deleteModal').classList.add('open');
}
function closeDeleteModal() {
    document.getElementById('deleteModal').classList.remove('open');
}
document.getElementById('deleteModal').addEventListener('click', function(e) {
    if (e.target === this) closeDeleteModal();
});
</script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
