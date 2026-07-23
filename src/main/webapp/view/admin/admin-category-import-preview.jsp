<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Xem trước nhập Excel — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
    <style>
        .preview-wrap   { max-width: 1100px; margin: 32px auto; padding: 0 24px; }
        .section-title  { font-size: 1rem; font-weight: 700; margin: 24px 0 10px; display: flex; align-items: center; gap: 8px; color: var(--fg); }
        .badge-count    { font-size: 0.78rem; font-weight: 600; padding: 2px 10px; border-radius: 99px; }
        .badge-valid    { background: #d1fae5; color: #065f46; }
        .badge-invalid  { background: #fee2e2; color: #991b1b; }
        .error-text     { font-size: 0.82rem; color: #dc2626; }
        .info-box       { background: var(--surface-2); border-radius: 10px; padding: 16px 20px; margin-bottom: 20px; font-size: 0.9rem; color: var(--muted); line-height: 1.7; }
        .btn-row        { display: flex; gap: 12px; margin-top: 24px; }
        table           { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
        thead tr        { background: var(--surface-2); }
        th, td          { padding: 10px 14px; text-align: left; border-bottom: 1px solid var(--border); }
        th              { font-weight: 600; color: var(--muted); font-size: 0.8rem; text-transform: uppercase; }
        tr:last-child td{ border-bottom: none; }
        .cb-col         { width: 40px; text-align: center; }
        input[type=checkbox] { width: 16px; height: 16px; cursor: pointer; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"/>
    <div>
        <header class="topbar">
            <h1>Xem trước nhập Excel</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}">Quản trị</a> / Nhập Excel</span>
        </header>

        <main>
            <div class="preview-wrap">

  
                <div class="info-box">
                    Loại danh mục: <strong>${currentType}</strong> &nbsp;|&nbsp;
                    Module: <strong>${currentModule}</strong> &nbsp;|&nbsp;
                    Hợp lệ: <strong>${fn:length(validRows)}</strong> dòng &nbsp;|&nbsp;
                    Lỗi: <strong>${fn:length(invalidRows)}</strong> dòng
                </div>

             
                <div class="section-title">
                    Dòng hợp lệ
                    <span class="badge-count badge-valid">${fn:length(validRows)}</span>
                </div>

                <c:choose>
                    <c:when test="${empty validRows}">
                        <div class="table-card" style="padding:24px; text-align:center; color:var(--muted);">
                            Không có dòng hợp lệ nào.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/admin/category/import-confirm">
                            <input type="hidden" name="type"   value="${currentType}"/>
                            <input type="hidden" name="module" value="${currentModule}"/>

                            <div class="table-card">
                                <table>
                                    <thead><tr>
                                        <th class="cb-col">
                                            <input type="checkbox" id="checkAll" checked
                                                   onclick="document.querySelectorAll('.row-cb').forEach(c => c.checked = this.checked)"/>
                                        </th>
                                        <th>Tên danh mục</th>
                                        <th>Mô tả</th>
                                        <th>Trạng thái</th>

                                        <%-- Cột extension theo type --%>
                                        <c:choose>
                                            <c:when test="${currentType == 'brand'}">
                                                <th>Quốc gia</th><th>Trang web</th><th>Năm TL</th><th>Bảo hành</th>
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
                                        </c:choose>
                                    </tr></thead>
                                    <tbody>
                                    <c:forEach var="row" items="${validRows}" varStatus="st">
                                        <tr>
                                            <td class="cb-col">
                                                <input type="checkbox" class="row-cb" checked
                                                       name="_selected" value="${st.index}"/>
                                            </td>
                             
                                            <input type="hidden" name="name"        value="${row['Tên danh mục']}"/>
                                            <input type="hidden" name="description" value="${row['Mô tả']}"/>
                                            <input type="hidden" name="status"      value="${empty row['Trạng thái'] ? 'active' : row['Trạng thái']}"/>

                                            <c:choose>
                                                <c:when test="${currentType == 'brand'}">
                                                    <input type="hidden" name="country"       value="${row['Quốc gia']}"/>
                                                    <input type="hidden" name="website"       value="${row['Website']}"/>
                                                    <input type="hidden" name="foundedYear"   value="${row['Năm thành lập']}"/>
                                                    <input type="hidden" name="warrantyPeriod" value="${row['Bảo hành (tháng)']}"/>
                                                </c:when>
                                                <c:when test="${currentType == 'fuel_type'}">
                                                    <input type="hidden" name="unit"         value="${row['Đơn vị']}"/>
                                                    <input type="hidden" name="typicalPrice" value="${row['Giá tham khảo']}"/>
                                                </c:when>
                                                <c:when test="${currentType == 'origin'}">
                                                    <input type="hidden" name="countryCode" value="${row['Mã quốc gia']}"/>
                                                </c:when>
                                                <c:when test="${currentType == 'customer_type'}">
                                                    <input type="hidden" name="taxType" value="${row['Loại thuế']}"/>
                                                </c:when>
                                            </c:choose>

                                           
                                            <td><strong>${row['Tên danh mục']}</strong></td>
                                            <td style="color:var(--muted)">${row['Mô tả']}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row['Trạng thái'] == 'inactive'}">
                                                        <span class="status inactive"><span class="sdot"></span>Không hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status active"><span class="sdot"></span>Hoạt động</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:choose>
                                                <c:when test="${currentType == 'brand'}">
                                                    <td>${row['Quốc gia']}</td>
                                                    <td>${row['Website']}</td>
                                                    <td>${row['Năm thành lập']}</td>
                                                    <td>${row['Bảo hành (tháng)']}</td>
                                                </c:when>
                                                <c:when test="${currentType == 'fuel_type'}">
                                                    <td>${row['Đơn vị']}</td>
                                                    <td>${row['Giá tham khảo']}</td>
                                                </c:when>
                                                <c:when test="${currentType == 'origin'}">
                                                    <td>${row['Mã quốc gia']}</td>
                                                </c:when>
                                                <c:when test="${currentType == 'customer_type'}">
                                                    <td>${row['Loại thuế']}</td>
                                                </c:when>
                                            </c:choose>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="btn-row">
                                <a href="${pageContext.request.contextPath}/admin/categories?module=${currentModule}&type=${currentType}"
                                   class="btn">Hủy</a>
                                <button type="submit" class="btn btn-primary">
                                    Xác nhận nhập ${fn:length(validRows)} dòng
                                </button>
                            </div>
                        </form>
                    </c:otherwise>
                </c:choose>

                
                <c:if test="${not empty invalidRows}">
                    <div class="section-title" style="margin-top:32px;">
                        Dòng bị lỗi (sẽ không được nhập)
                        <span class="badge-count badge-invalid">${fn:length(invalidRows)}</span>
                    </div>
                    <div class="table-card">
                        <table>
                            <thead><tr>
                                <th>Tên danh mục</th>
                                <th>Lý do lỗi</th>
                            </tr></thead>
                            <tbody>
                            <c:forEach var="row" items="${invalidRows}">
                                <tr>
                                    <td>${row['Tên danh mục']}</td>
                                    <td class="error-text">${row['_errors']}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

            </div>
        </main>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
