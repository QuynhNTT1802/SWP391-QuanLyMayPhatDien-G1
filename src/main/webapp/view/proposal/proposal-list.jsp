<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __propFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .table-card {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }
            .order-code {
                font-family: 'JetBrains Mono', monospace;
                font-size: 13px;
                color: var(--muted);
            }
            .col-code {
                white-space: nowrap;
                width: 160px;
            }
            .col-creator {
                white-space: nowrap;
                width: 160px;
            }
            .col-date {
                white-space: nowrap;
                width: 150px;
                color: var(--muted);
                font-size: 13px;
            }
            .col-warehouse {
                white-space: nowrap;
            }
            .col-status {
                white-space: nowrap;
                width: 150px;
            }
            .col-actions {
                white-space: nowrap;
                width: 110px;
                text-align: right;
            }
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }
            .status-pill .pdot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: currentColor;
                opacity: 0.55;
            }
            .status-draft     {
                background: #e2e3e5;
                color: #383d41;
            }
            .status-pending   {
                background: #fff3cd;
                color: #856404;
            }
            .status-approved  {
                background: #d4edda;
                color: #155724;
            }
            .status-rejected  {
                background: #f8d7da;
                color: #721c24;
            }
            .status-converted {
                background: #cce5ff;
                color: #004085;
            }
            .status-cancelled {
                background: #d6d8db;
                color: #1d2129;
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Kinh doanh</a> / Đề xuất nhập kho</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/proposal?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu đề xuất
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Đề xuất nhập kho</div>
                            <h2 class="page-title">Quản lý phiếu đề xuất nhập kho</h2>
                            <div class="page-sub">${totalProposals} phiếu đề xuất</div>
                        </div>
                    </div>

                    <div class="stats-row">
                        <div class="stat"><div class="lbl">Nháp</div><div class="val">${draftCount}</div></div>
                        <div class="stat"><div class="lbl">Chờ duyệt</div><div class="val">${pendingCount}</div></div>
                        <div class="stat"><div class="lbl">Đã duyệt</div><div class="val">${approvedCount}</div></div>
                        <div class="stat"><div class="lbl">Từ chối</div><div class="val">${rejectedCount}</div></div>
                        <div class="stat"><div class="lbl">Đã chuyển phiếu nhập</div><div class="val">${convertedCount}</div></div>
                        <div class="stat"><div class="lbl">Đã hủy</div><div class="val">${cancelledCount}</div></div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.toastMessage}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/proposal" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value="${search}"/>" placeholder="Tìm theo mã phiếu hoặc ghi chú" autocomplete="off" />
                        </div>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="DRAFT" <c:if test="${statusFilter == 'DRAFT'}">selected</c:if>>Nháp</option>
                            <option value="PENDING" <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="APPROVED" <c:if test="${statusFilter == 'APPROVED'}">selected</c:if>>Đã duyệt</option>
                            <option value="REJECTED" <c:if test="${statusFilter == 'REJECTED'}">selected</c:if>>Từ chối</option>
                            <option value="CONVERTED" <c:if test="${statusFilter == 'CONVERTED'}">selected</c:if>>Đã chuyển phiếu nhập</option>
                            <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã hủy</option>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/proposal?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <table class="users" id="proposalsTable">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th class="col-warehouse">Kho</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody id="proposalsBody">
                                <c:choose>
                                    <c:when test="${empty proposals}">
                                        <tr><td colspan="6" style="text-align:center; padding:20px; color:var(--muted);">Chưa có phiếu đề xuất nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="p" items="${proposals}" varStatus="loop">
                                            <tr data-id="${p.proposalId}">
                                                <td>
                                                    <div class="order-code"><c:out value="${p.proposalCode}"/></div>
                                                </td>
                                                <td class="col-creator"><c:out value="${p.createdByName}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.proposalDate == null}">—</c:when>
                                                        <c:otherwise>${p.proposalDate.format(propFmt)}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-warehouse"><c:out value="${p.warehouseName}"/></td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'DRAFT'}"><span class="status-pill status-draft"><span class="pdot"></span>Nháp</span></c:when>
                                                        <c:when test="${p.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${p.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                                        <c:when test="${p.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                                        <c:when test="${p.status == 'CONVERTED'}"><span class="status-pill status-converted"><span class="pdot"></span>Đã chuyển phiếu nhập</span></c:when>
                                                        <c:when test="${p.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${p.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-actions">
                                                    <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${p.proposalId}">
                                                        Chi tiết
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination" style="display:flex;gap:6px;align-items:center;justify-content:flex-end;margin-top:16px;flex-wrap:wrap;">
                            <c:if test="${currentPage > 1}">
                                <a class="btn" href="<c:out value='${pageContext.request.contextPath}/proposal?action=list&page=${currentPage - 1}&status=${statusFilter}&search=${search}'/>">‹ Trước</a>
                            </c:if>
                            <span style="color:var(--muted);font-size:13px;">Trang ${currentPage} / ${totalPages} (${fromIndex}–${toIndex} / ${totalProposals})</span>
                            <c:if test="${currentPage < totalPages}">
                                <a class="btn" href="<c:out value='${pageContext.request.contextPath}/proposal?action=list&page=${currentPage + 1}&status=${statusFilter}&search=${search}'/>">Sau ›</a>
                            </c:if>
                        </div>
                    </c:if>
                </main>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    } else {
                        alert(window.SESSION_DATA.message);
                    }
                }
            });
        </script>
    </body>
</html>
