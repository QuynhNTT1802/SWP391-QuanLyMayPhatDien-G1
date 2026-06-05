<%--
    Document   : admin-category
    Created on : May 24, 2026, 8:48:05 AM
    Author     : LENOVO
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
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
                                <c:when test="${param.msg == 'deleted'}">Khóa danh mục thành công!</c:when>
                                <c:when test="${param.msg == 'import-success'}">Nhập Excel thành công! Đã thêm <strong>${param.importedCount}</strong> danh mục.</c:when>
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
                                <span class="type-count">${kpiTotal} mục</span>
                                <span class="spacer"></span>
                            </div>
                            <div class="kpi-grid">
                                <div class="kpi-card kpi-total">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h7"/></svg></div>
                                    <div class="kpi-title">Tổng ${typeLabel}</div>
                                    <div class="kpi-value">${kpiTotal}</div>
                                </div>
                                <div class="kpi-card kpi-active">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                                    <div class="kpi-title">Đang hoạt động</div>
                                    <div class="kpi-value">${kpiActive}</div>
                                </div>
                                <div class="kpi-card kpi-inactive">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg></div>
                                    <div class="kpi-title">Đã khóa</div>
                                    <div class="kpi-value">${kpiInactive}</div>
                                </div>
                            </div>

                            <div class="tab-bar">
                                <a href="?module=${currentModule}&amp;type=${currentType}" class="tab ${empty currentTab or currentTab != 'history' ? 'active' : ''}">
                                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                    Thông tin chung
                                </a>
                                <a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                                    <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                    Lịch sử
                                </a>
                                    
                                    
                            </div>
                            <c:choose>
                                <c:when test="${currentTab == 'history'}">
                                    <div class="table-card history-card">
                                        <form method="get" action="${pageContext.request.contextPath}/admin/categories" class="history-filter-bar">
                                            <input type="hidden" name="module" value="${currentModule}"/>
                                            <input type="hidden" name="type"   value="${currentType}"/>
                                            <input type="hidden" name="tab"    value="history"/>
                                            <input type="hidden" name="page"   value="1"/>

                                            <div class="search-input hf-search">
                                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                                <input name="logSearch" value="${logSearch}" placeholder="Tìm đối tượng, người dùng..." autocomplete="off"/>
                                            </div>
                                            <select name="logAction" class="filter-select">
                                                <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                                <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Thêm mới</option>
                                                <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                                <option value="DELETE" ${logAction == 'DELETE' ? 'selected' : ''}>Khóa</option>
                                            </select>
                                            <div class="date-range">
                                                <label class="date-label">Từ</label>
                                                <input type="date" name="dateFrom" value="${dateFrom}" class="date-input"/>
                                                <label class="date-label">đến</label>
                                                <input type="date" name="dateTo"   value="${dateTo}"   class="date-input"/>
                                            </div>
                                            <button type="submit" class="btn btn-primary">
                                                <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                                Áp dụng
                                            </button>
                                            <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                <a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history" class="btn">
                                                    <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                                    Xóa lọc
                                                </a>
                                            </c:if>
                                        </form>

                                        <div class="result-summary">
                                            Tìm thấy <strong>${totalLogs}</strong> bản ghi
                                            <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                &nbsp;—&nbsp;<span class="filter-active-badge">Bộ lọc đang hoạt động</span>
                                            </c:if>
                                        </div>

                                        <table>
                                            <thead><tr>
                                                    <th style="width:140px;">Thời gian</th>
                                                    <th style="width:160px;">Người dùng</th>
                                                    <th style="width:120px;">Hành động</th>
                                                    <th>Đối tượng</th>
                                                    <th>Chi tiết</th>
                                                </tr></thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty logList}">
                                                        <tr><td colspan="5">
                                                                <div class="empty-state">
                                                                    <div class="icon-wrap">
                                                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                                    </div>
                                                                    <strong>Không có bản ghi nào</strong>
                                                                    <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                                                        <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history">xóa lọc</a></span>
                                                                    </c:if>
                                                                </div>
                                                            </td></tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="log" items="${logList}">
                                                            <tr>
                                                                <td><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                                <td>
                                                                    <div style="font-weight:600;color:var(--fg);">${log.username}</div>
                                                                </td>
                                                                <td>
                                                                    <span class="action-badge action-<c:choose><c:when test="${log.action == 'CREATE'}">create</c:when><c:when test="${log.action == 'UPDATE'}">update</c:when><c:when test="${log.action == 'DELETE'}">delete</c:when><c:when test="${log.action == 'IMPORT'}">import</c:when><c:when test="${log.action == 'EXPORT'}">export</c:when><c:otherwise>default</c:otherwise></c:choose>"><c:choose><c:when test="${log.action == 'CREATE'}">Thêm mới</c:when><c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when><c:when test="${log.action == 'DELETE'}">Khóa</c:when><c:when test="${log.action == 'IMPORT'}">Nhập Excel</c:when><c:when test="${log.action == 'EXPORT'}">Xuất Excel</c:when><c:otherwise>${log.action}</c:otherwise></c:choose></span>
                                                                        </td>
                                                                                                        <td style="font-weight:600;color:var(--fg);">${log.entityName}</td>
                                                                <td style="max-width:340px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                                    Admin đã <c:choose><c:when test="${log.action == 'CREATE'}">thêm mới</c:when><c:when test="${log.action == 'UPDATE'}">cập nhật</c:when><c:when test="${log.action == 'DELETE'}">khóa</c:when><c:otherwise>${fn:toLowerCase(log.action)}</c:otherwise></c:choose> danh mục <strong>${log.entityName}</strong>.
                                                                        </td>
                                                                    </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>

                                        <c:if test="${logTotalPages > 1}">
                                            <div class="pagination">
                                                <div class="info">Hiển thị <strong>${(logPage-1)*20 + 1}</strong>–<strong>${logPage*20 > totalLogs ? totalLogs : logPage*20}</strong> / <strong>${totalLogs}</strong> bản ghi</div>
                                                <div class="controls">
                                                    <c:if test="${logPage > 1}">
                                                        <a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                                    </c:if>
                                                    <c:forEach begin="1" end="${logTotalPages}" var="p">
                                                        <c:choose>
                                                            <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                            <c:otherwise><a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                    <c:if test="${logPage < logTotalPages}">
                                                        <a href="?module=${currentModule}&amp;type=${currentType}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="toolbar">
                                        <form method="get" action="${pageContext.request.contextPath}/admin/categories" style="display:contents;">
                                            <input type="hidden" name="module" value="${currentModule}"/>
                                            <input type="hidden" name="type" value="${currentType}"/>
                                            <input type="hidden" name="page" value="1"/>
                                            <div class="search-input">
                                                <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                                <input name="search" value="<c:out value="${param.search}"/>" placeholder="Tìm ${typeLabel}..." autocomplete="off"/>
                                            </div>
                                            <%-- Dropdown filter trạng thái --%>
                                            <select name="status" class="filter-select" onchange="this.form.submit()">
                                                <option value="all" ${empty currentStatus or currentStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                                                <option value="active"   ${currentStatus == 'active'   ? 'selected' : ''}>Hoạt động</option>
                                                <option value="inactive" ${currentStatus == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                            </select>
                                            <c:if test="${not empty param.search or (not empty currentStatus and currentStatus != 'all')}">
                                                <button type="button" class="btn" onclick="location.href = '${pageContext.request.contextPath}/admin/categories?module=${currentModule}&amp;type=${currentType}'">
                                                    <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                                    Xóa lọc
                                                </button>
                                            </c:if>
                                        </form>
                                        <%-- Nút Xuất / Nhập Excel --%>
                                        <a href="${pageContext.request.contextPath}/admin/category/export?module=${currentModule}&type=${currentType}&search=${param.search}&status=${currentStatus}"
                                           class="btn btn-success">
                                            Xuất Excel
                                        </a>
                                        <button type="button" class="btn btn-primary"
                                                onclick="document.getElementById('importModal').style.display='flex'">
                                            Nhập Excel
                                        </button>
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
                                                                        <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/admin/category/edit?id=${cat.id}&module=${currentModule}'" title="Chỉnh sửa">
                                                                            <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                                        </button>
                                                                        <c:choose>
                                                                            <c:when test="${cat.status == 'active'}">
                                                                                <button class="icon-mini danger" onclick="confirmDelete(${cat.id}, '<c:out value="${cat.name}"/>')" title="Khóa">
                                                                                    <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                                                                </button>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <button class="icon-mini" disabled style="opacity:0.3;cursor:not-allowed;" title="Đã khóa">
                                                                                    <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                                                                </button>
                                                                            </c:otherwise>
                                                                        </c:choose>
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
                                                        <a href="?page=${currentPage - 1}&amp;module=${currentModule}&amp;type=${currentType}<c:if test="${not empty param.search}">&amp;search=<c:out value="${param.search}"/></c:if><c:if test="${not empty currentStatus and currentStatus != 'all'}">&amp;status=${currentStatus}</c:if>" class="page-btn">‹</a>
                                                    </c:if>
                                                    <c:forEach begin="1" end="${totalPages}" var="p">
                                                        <c:choose>
                                                            <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                                            <c:otherwise><a href="?page=${p}&amp;module=${currentModule}&amp;type=${currentType}<c:if test="${not empty param.search}">&amp;search=<c:out value="${param.search}"/></c:if><c:if test="${not empty currentStatus and currentStatus != 'all'}">&amp;status=${currentStatus}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                    <c:if test="${currentPage < totalPages}">
                                                        <a href="?page=${currentPage + 1}&amp;module=${currentModule}&amp;type=${currentType}<c:if test="${not empty param.search}">&amp;search=<c:out value="${param.search}"/></c:if><c:if test="${not empty currentStatus and currentStatus != 'all'}">&amp;status=${currentStatus}</c:if>" class="page-btn">›</a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>

                        <c:otherwise>

                            <div class="page-head">
                                <div class="left">
                                    <div class="eyebrow">Quản trị · Danh mục</div>
                                    <h2 class="page-title">${moduleLabel}</h2>
                                    <div class="page-sub">Quản lý tổng quát cấu trúc và dữ liệu của module</div>
                                </div>
                            </div>

                            <div class="kpi-grid">
                                <div class="kpi-card kpi-total">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M4 6h16M4 12h16M4 18h7"/></svg></div>
                                    <div class="kpi-title">Tổng danh mục</div>
                                    <div class="kpi-value">${kpiTotal}</div>
                                </div>
                                <div class="kpi-card kpi-active">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg></div>
                                    <div class="kpi-title">Đang hoạt động</div>
                                    <div class="kpi-value">${kpiActive}</div>
                                </div>
                                <div class="kpi-card kpi-inactive">
                                    <div class="kpi-icon"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg></div>
                                    <div class="kpi-title">Đã khóa</div>
                                    <div class="kpi-value">${kpiInactive}</div>
                                </div>
                            </div>

                      
                            <h3 style="font-size:15px; font-weight:700; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                                <svg style="width:16px;height:16px;stroke:var(--accent);fill:none;" viewBox="0 0 24 24"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                                Phân loại theo nhóm
                            </h3>
                            <div class="table-card" style="margin-bottom: 32px;">
                                <table>
                                    <thead><tr>
                                            <th style="width:60px;text-align:center;font-family:var(--font-mono);">ID</th>
                                            <th>Loại danh mục</th>
                                            <th style="width:80px;text-align:right;">Số mục</th>
                                        </tr></thead>
                                    <tbody>
                                        <c:forEach var="t" items="${types}">
                                            <tr onclick="location.href = '?module=${currentModule}&type=${t}'" style="cursor:pointer;">
                                                <td style="text-align:center;">
                                                    <span style="font-family:var(--font-mono);font-size:0.82rem;color:var(--muted);font-weight:600;">#${typeMinIds[t] != null ? typeMinIds[t] : '—'}</span>
                                                </td>
                                                <td>
                                                    <div style="display:flex;align-items:center;gap:10px;">
                                                        <span class="sdot" style="<c:choose><c:when test="${t == 'brand'}">background:var(--brand-color);box-shadow:0 0 0 3px var(--brand-soft)</c:when><c:when test="${t == 'fuel_type'}">background:var(--fuel-color);box-shadow:0 0 0 3px var(--fuel-soft)</c:when><c:when test="${t == 'phase'}">background:var(--phase-color);box-shadow:0 0 0 3px var(--phase-soft)</c:when><c:when test="${t == 'generator_type'}">background:var(--gen-color);box-shadow:0 0 0 3px var(--gen-soft)</c:when><c:when test="${t == 'condition'}">background:var(--condition-color);box-shadow:0 0 0 3px var(--condition-soft)</c:when><c:when test="${t == 'origin'}">background:var(--origin-color);box-shadow:0 0 0 3px var(--origin-soft)</c:when><c:when test="${t == 'customer_type'}">background:var(--customer-color);box-shadow:0 0 0 3px var(--customer-soft)</c:when><c:when test="${t == 'receipt_type' or t == 'receipt_reason' or t == 'receipt_status'}">background:var(--receipt-color);box-shadow:0 0 0 3px var(--receipt-soft)</c:when><c:when test="${t == 'order_status'}">background:var(--order-color);box-shadow:0 0 0 3px var(--order-soft)</c:when><c:otherwise>background:var(--muted);box-shadow:0 0 0 3px var(--surface-2)</c:otherwise></c:choose>"></span>
                                                        <span style="font-weight:600;color:var(--fg);">${typeLabels[t] != null ? typeLabels[t] : t}</span>
                                                    </div>
                                                </td>
                                                <td style="text-align:right;">
                                                    <span style="font-family:var(--font-mono);font-weight:600;color:var(--muted);">${typeCounts[t] != null ? typeCounts[t] : 0}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <%-- Bảng Danh sách chi tiết --%>
                            <h3 style="font-size:15px; font-weight:700; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                                <svg style="width:16px;height:16px;stroke:var(--accent);fill:none;" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                                Tất cả danh mục
                            </h3>
                            <div class="table-card">
                                <table>
                                    <thead><tr>
                                            <th style="width:60px;text-align:center;">ID</th>
                                            <th>Tên danh mục</th>
                                            <th>Loại danh mục</th>
                                            <th>Mô tả</th>
                                            <th style="width:140px;">Trạng thái</th>
                                            <th class="actions-col">Hành động</th>
                                        </tr></thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty categoryList}">
                                                <tr><td colspan="6">
                                                        <div class="empty-state">
                                                            <div class="icon-wrap"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg></div>
                                                            <strong>Chưa có danh mục nào</strong>
                                                        </div>
                                                    </td></tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="cat" items="${categoryList}">
                                                    <tr>
                                                        <td style="text-align:center;font-family:var(--font-mono);font-size:0.85rem;color:var(--muted);font-weight:600;">#${cat.id}</td>
                                                        <td><div style="font-weight:600;color:var(--fg);"><c:out value="${cat.name}"/></div></td>
                                                        <td>
                                                            <span class="pill"><span class="pdot"></span>${typeLabels[cat.type] != null ? typeLabels[cat.type] : cat.type}</span>
                                                        </td>
                                                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;"><c:out value="${cat.description}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${cat.status == 'active'}"><span class="status active"><span class="sdot"></span>Hoạt động</span></c:when>
                                                                <c:otherwise><span class="status inactive"><span class="sdot"></span>Không hoạt động</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="actions-col">
                                                            <div class="row-actions">
                                                                <button class="icon-mini" onclick="location.href = '${pageContext.request.contextPath}/admin/category/edit?id=${cat.id}&module=${currentModule}'" title="Chỉnh sửa">
                                                                    <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                                </button>
                                                                <c:choose>
                                                                    <c:when test="${cat.status == 'active'}">
                                                                        <button class="icon-mini danger" onclick="confirmDelete(${cat.id}, '<c:out value="${cat.name}"/>')" title="Khóa">
                                                                            <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button class="icon-mini" disabled style="opacity:0.3;cursor:not-allowed;" title="Đã khóa">
                                                                            <svg viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                                                        </button>
                                                                    </c:otherwise>
                                                                </c:choose>
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
                                                <a href="?page=${currentPage - 1}&amp;module=${currentModule}" class="page-btn">‹</a>
                                            </c:if>
                                            <c:forEach begin="1" end="${totalPages}" var="p">
                                                <c:choose>
                                                    <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                                    <c:otherwise><a href="?page=${p}&amp;module=${currentModule}" class="page-btn">${p}</a></c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <c:if test="${currentPage < totalPages}">
                                                <a href="?page=${currentPage + 1}&amp;module=${currentModule}" class="page-btn">›</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>


        <div id="importModal"
             style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
                    background:rgba(0,0,0,0.45); justify-content:center; align-items:center;
                    z-index:9999;">
            <div style="background:var(--surface); border-radius:12px; padding:32px;
                        min-width:420px; box-shadow:0 20px 60px rgba(0,0,0,0.3);">
                <h3 style="margin:0 0 8px; font-size:1.1rem; color:var(--fg);">Nhập từ file Excel</h3>
                <p style="color:var(--muted); font-size:0.88rem; margin:0 0 20px;">
                    Chỉ hỗ trợ file <strong>.xlsx</strong>.
                    Hệ thống sẽ kiểm tra dữ liệu trước khi nhập.
                </p>
                <form action="${pageContext.request.contextPath}/admin/category/import-preview"
                      method="post" enctype="multipart/form-data">
                    <input type="hidden" name="type"   value="${currentType}"/>
                    <input type="hidden" name="module" value="${currentModule}"/>
                    <label style="display:block; font-size:0.88rem; font-weight:600;
                                  color:var(--fg); margin-bottom:8px;">Chọn file .xlsx</label>
                    <input type="file" name="excelFile" accept=".xlsx" required
                           style="display:block; width:100%; margin-bottom:20px; font-size:0.9rem;"/>
                    <div style="display:flex; gap:10px; justify-content:flex-end;">
                        <button type="button" class="btn"
                                onclick="document.getElementById('importModal').style.display='none'">
                            Hủy
                        </button>
                        <button type="submit" class="btn btn-primary">Xem trước</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-host" id="deleteModal">
            <div class="modal">
                <h3>Xác nhận khóa</h3>
                <p id="deleteMsg">Bạn có chắc muốn khoá danh mục này? Danh mục sẽ bị chuyển sang trạng thái không hoạt động.</p>
                <div class="actions">
                    <button class="btn" onclick="closeDeleteModal()">Huỷ</button>
                    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/category/delete" style="display:inline;">
                        <input type="hidden" name="id" id="deleteId"/>
                        <input type="hidden" name="module" value="${currentModule}"/>
                        <input type="hidden" name="type" value="${currentType}"/>
                        <button type="submit" class="btn btn-danger">Khóa</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function confirmDelete(id, name) {
                document.getElementById('deleteId').value = id;
                document.getElementById('deleteMsg').textContent = 'Bạn có chắc muốn khóa danh mục "' + name + '"?';
                document.getElementById('deleteModal').classList.add('open');
            }
            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.remove('open');
            }
            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this)
                    closeDeleteModal();
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
