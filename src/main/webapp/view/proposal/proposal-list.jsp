<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .status-pill {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
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

                    <c:if test="${not empty message}">
                        <div class="alert alert-${messageType == 'danger' ? 'danger' : (messageType == 'success' ? 'success' : 'info')}" style="padding:10px 14px;margin:12px 0;border-radius:6px;background:${messageType == 'danger' ? '#f8d7da' : (messageType == 'success' ? '#d4edda' : '#d1ecf1')};color:${messageType == 'danger' ? '#721c24' : (messageType == 'success' ? '#155724' : '#0c5460')};">
                            ${message}
                        </div>
                    </c:if>

                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Kho</th>
                                    <th>Trạng thái</th>
                                    <th class="col-actions">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty proposals}">
                                        <tr><td colspan="6" style="text-align:center;padding:24px;color:var(--muted);">
                                                Chưa có phiếu đề xuất nào.
                                            </td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="p" items="${proposals}">
                                            <tr>
                                                <td>
                                                    <div class="order-code"><c:out value="${p.proposalCode}"/></div>
                                                </td>
                                                <td><c:out value="${p.createdByName}"/></td>
                                                <td>
                                                    <fmt:formatDate value="${p.proposalDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td><c:out value="${p.warehouseName}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.status == 'DRAFT'}">
                                                            <span class="status-pill status-draft">Nháp</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'PENDING'}">
                                                            <span class="status-pill status-pending">Chờ duyệt</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'APPROVED'}">
                                                            <span class="status-pill status-approved">Đã duyệt</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'REJECTED'}">
                                                            <span class="status-pill status-rejected">Từ chối</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'CONVERTED'}">
                                                            <span class="status-pill status-converted">Đã chuyển phiếu nhập</span>
                                                        </c:when>
                                                        <c:when test="${p.status == 'CANCELLED'}">
                                                            <span class="status-pill status-cancelled">Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill"><c:out value="${p.status}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
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
                </main>
            </div>
        </div>
    </body>
</html>