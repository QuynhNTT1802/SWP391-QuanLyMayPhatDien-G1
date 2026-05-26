<%-- 
    Document   : receipt-list
    Created on : May 27, 2026
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu nhập/xuất — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Phiếu nhập/xuất</h1>
            <span class="crumb">/ Phiếu nhập/xuất</span>
            <div class="top-actions">
                <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                    <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                </button>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/receipt?action=create">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                    Tạo phiếu mới
                </a>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho</div>
                    <h2 class="page-title">Quản lý phiếu nhập/xuất</h2>
                    <div class="page-sub">${totalItems} phiếu</div>
                </div>
            </div>

            <c:if test="${not empty param.msg}">
                <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                    <c:choose>
                        <c:when test="${param.msg == 'created'}">Đã tạo phiếu thành công.</c:when>
                        <c:when test="${param.msg == 'approved'}">Đã duyệt phiếu thành công.</c:when>
                        <c:when test="${param.msg == 'rejected'}">Đã từ chối phiếu.</c:when>
                        <c:otherwise>${param.msg}</c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 30%,transparent);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <form method="get" action="${pageContext.request.contextPath}/receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <input type="hidden" name="action" value="list" />
                <input type="hidden" name="page" value="1" />

                <select class="filter-select" name="type" onchange="this.form.submit()">
                    <option value="">Loại: Tất cả</option>
                    <option value="IMPORT" <c:if test="${typeFilter == 'IMPORT'}">selected</c:if>>Nhập kho</option>
                    <option value="EXPORT" <c:if test="${typeFilter == 'EXPORT'}">selected</c:if>>Xuất kho</option>
                </select>

                <select class="filter-select" name="status" onchange="this.form.submit()">
                    <option value="">Trạng thái: Tất cả</option>
                    <option value="PENDING_RECONCILIATION" <c:if test="${statusFilter == 'PENDING_RECONCILIATION'}">selected</c:if>>Chờ duyệt</option>
                    <option value="COMPLETED" <c:if test="${statusFilter == 'COMPLETED'}">selected</c:if>>Hoàn thành</option>
                    <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã từ chối</option>
                </select>

                <select class="filter-select" name="warehouse" onchange="this.form.submit()">
                    <option value="">Kho: Tất cả</option>
                    <c:forEach var="wh" items="${warehouses}">
                        <option value="${wh.warehouseId}" <c:if test="${whFilter == wh.warehouseId.toString()}">selected</c:if>>${wh.name}</option>
                    </c:forEach>
                </select>

                <div class="spacer"></div>
                <c:if test="${not empty typeFilter or not empty statusFilter or not empty whFilter}">
                    <a href="${pageContext.request.contextPath}/receipt" class="btn">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                        Xoá lọc
                    </a>
                </c:if>
            </form>

            <div class="table-card" style="margin-top:16px;">
                <table class="users">
                    <thead>
                        <tr>
                            <th>Mã phiếu</th>
                            <th>Loại</th>
                            <th>Kho</th>
                            <th>Người tạo</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="col-actions">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty receiptList}">
                                <tr><td colspan="7">
                                    <div class="empty-state"><strong>Không tìm thấy phiếu nào</strong></div>
                                </td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${receiptList}">
                                    <tr>
                                        <td><strong>${r.receiptCode}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.receiptType == 'IMPORT'}"><span class="pill"><span class="pdot"></span>Nhập kho</span></c:when>
                                                <c:otherwise><span class="pill"><span class="pdot"></span>Xuất kho</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${r.warehouseName}</td>
                                        <td>${r.createdByName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'PENDING_RECONCILIATION'}"><span class="status active" style="--dot:var(--warn);"><span class="sdot"></span>Chờ duyệt</span></c:when>
                                                <c:when test="${r.status == 'COMPLETED'}"><span class="status active"><span class="sdot"></span>Hoàn thành</span></c:when>
                                                <c:when test="${r.status == 'CANCELLED'}"><span class="status locked"><span class="sdot"></span>Đã từ chối</span></c:when>
                                                <c:otherwise>${r.status}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${r.createdAt}</td>
                                        <td class="col-actions">
                                            <div class="row-actions">
                                                <a href="${pageContext.request.contextPath}/receipt?action=detail&id=${r.receiptId}" class="icon-mini" title="Xem chi tiết">
                                                    <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="pagination">
                    <div class="info">Hiển thị <strong>${fromIndex}</strong>–<strong>${toIndex}</strong> / <strong>${totalItems}</strong> kết quả</div>
                    <c:if test="${totalPages > 1}">
                    <div class="controls">
                        <c:if test="${currentPage > 1}">
                            <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty typeFilter}">&type=${typeFilter}</c:if><c:if test="${not empty statusFilter}">&status=${statusFilter}</c:if><c:if test="${not empty whFilter}">&warehouse=${whFilter}</c:if>" class="page-btn">‹</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <c:choose>
                                <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty typeFilter}">&type=${typeFilter}</c:if><c:if test="${not empty statusFilter}">&status=${statusFilter}</c:if><c:if test="${not empty whFilter}">&warehouse=${whFilter}</c:if>" class="page-btn">${p}</a></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty typeFilter}">&type=${typeFilter}</c:if><c:if test="${not empty statusFilter}">&status=${statusFilter}</c:if><c:if test="${not empty whFilter}">&warehouse=${whFilter}</c:if>" class="page-btn">›</a>
                        </c:if>
                    </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
</body>
</html>
