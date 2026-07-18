<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
    java.time.format.DateTimeFormatter __propFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Quản lý đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/proposal-list.css">
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
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M12 2.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                        <jsp:include page="../common/admin/bell.jsp"/>
                        <c:if test="${canCreateProposal}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/proposal?action=create">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                Tạo phiếu đề xuất
                            </a>
                        </c:if>
                        <c:if test="${canCreatePo}">
                            <button type="button" id="groupBtn" class="btn btn-primary" onclick="document.getElementById('reviewForm').submit();">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M3 3h7v7H3zM14 3h7v7h-7zM14 14h7v7h-7zM3 14h7v7H3z"/></svg>
                                Gom và Tổng hợp (<span id="tickedCount">0</span>)
                            </button>
                        </c:if>
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
                        <div class="stat"><div class="lbl">Chờ duyệt</div><div class="val">${pendingCount}</div></div>
                        <div class="stat"><div class="lbl">Đã duyệt bởi Sale Manager</div><div class="val">${approvedCount}</div></div>
                        <div class="stat"><div class="lbl">Từ chối bởi Sale Manager</div><div class="val">${rejectedCount}</div></div>
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

                        <input type="date" class="filter-select" name="dateFrom" value="${dateFrom}"
                               title="Từ ngày" onchange="this.form.submit()" />
                        <input type="date" class="filter-select" name="dateTo" value="${dateTo}"
                               title="Đến ngày" onchange="this.form.submit()" />

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="PENDING"   <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="PENDING_CEO" <c:if test="${statusFilter == 'PENDING_CEO'}">selected</c:if>>Chờ CEO duyệt</option>
                            <option value="APPROVED_SM" <c:if test="${statusFilter == 'APPROVED_SM'}">selected</c:if>>Đã duyệt bởi Sale Manager</option>
                            <option value="APPROVED_CEO" <c:if test="${statusFilter == 'APPROVED_CEO'}">selected</c:if>>Đã duyệt bởi CEO</option>
                            <option value="REJECTED_SM" <c:if test="${statusFilter == 'REJECTED_SM'}">selected</c:if>>Từ chối bởi Sale Manager</option>
                            <option value="REJECTED_CEO" <c:if test="${statusFilter == 'REJECTED_CEO'}">selected</c:if>>Từ chối bởi CEO</option>
                            <option value="NEEDS_REVISION" <c:if test="${statusFilter == 'NEEDS_REVISION'}">selected</c:if>>Cần chỉnh sửa</option>
                            <option value="DELETED" <c:if test="${statusFilter == 'DELETED'}">selected</c:if>>Đã xoá</option>
                        </select>

                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/proposal?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card">
                        <form id="reviewForm" method="post" action="${pageContext.request.contextPath}/purchase-order?action=reviewCreate">
                        <table class="users" id="proposalsTable">
                            <thead>
                                <tr>
                                    <c:if test="${canCreatePo}">
                                        <th class="col-check"><input type="checkbox" class="checkbox" id="selectAll" title="Chọn tất cả"/></th>
                                    </c:if>
                                <th>Mã phiếu</th>
                                <th>Người tạo</th>
                                <th>Ngày tạo</th>
                                <th>Tháng</th>
                                <th>Kho</th>
                                <th>Deadline</th>
                                <th>Phiếu mua</th>
                                <th class="col-status">Trạng thái</th>
                                                
                                </tr>
                            </thead>
                            <tbody id="proposalsBody">
                                <c:choose>
                                    <c:when test="${empty proposals}">
                                        <tr><td colspan="${canCreatePo ? 9 : 8}" style="text-align:center; padding:20px; color:var(--muted);">Chưa có phiếu đề xuất nào.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="p" items="${proposals}" varStatus="loop">
                                            <tr data-id="${p.proposalId}">
                                                <c:if test="${canCreatePo}">
                                                    <td class="col-check">
                                                        <c:set var="dl" value="${periodDeadlines[p.period]}" />
                                                        <c:set var="withinDeadline" value="${p.period != currentPeriod && dl != null && !dl.isBefore(currentDate)}"/>
                                                        <c:set var="canTick" value="${p.status == 'APPROVED' && empty p.poCode && withinDeadline}"/>
                                                        <input type="checkbox" class="checkbox row-check" name="proposalIds" value="${p.proposalId}" data-period="${p.period}" data-warehouse="${p.warehouseId}" <c:if test="${!canTick}">disabled</c:if>/>
                                                    </td>
                                                </c:if>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${p.proposalId}" class="code-link order-code"><c:out value="${p.proposalCode}"/></a>
                                                </td>
                                                <td><c:out value="${p.createdByName}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.proposalDate == null}">—</c:when>
                                                        <c:otherwise>${p.proposalDate.format(propFmt)}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong><c:out value="${p.period}"/></strong></td>
                                                <td><c:out value="${p.warehouseName}"/></td>
                                                <td>
                                                    <c:set var="deadlineDate" value="${periodDeadlines[p.period]}" />
                                                    <c:choose>
                                                        <c:when test="${deadlineDate == null}">
                                                            <span style="font-size:11px; color:var(--muted);">—</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="deadlineStr" value="${deadlineDate.toString()}" />
                                                            <c:choose>
                                                                <c:when test="${deadlineDate.isBefore(currentDate)}">
                                                                    <span style="font-family:'JetBrains Mono',monospace; font-size:12px; color:var(--danger); font-weight:600;" title="Đã quá deadline">${deadlineStr}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="font-family:'JetBrains Mono',monospace; font-size:12px; color:var(--muted);" title="Deadline gom/duyệt">${deadlineStr}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty p.poCode && canViewPo}">
                                                            <strong><a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${p.purchaseOrderId}" class="po-link" style="font-family: 'JetBrains Mono', monospace; font-size: 12.5px; font-weight: 600; color: var(--accent); text-decoration: none;" title="Xem chi tiết phiếu mua"><c:out value="${p.poCode}"/></a></strong>
                                                        </c:when>
                                                        <c:when test="${not empty p.poCode}">
                                                            <strong style="font-family: 'JetBrains Mono', monospace; font-size: 12.5px; color: var(--muted);" title="Bạn không có quyền xem phiếu mua"><c:out value="${p.poCode}"/></strong>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--muted); font-size: 12px;">—</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${p.status == 'PENDING_CEO'}"><span class="status-pill status-pending_ceo"><span class="pdot"></span>Chờ CEO duyệt</span></c:when>
                                                        <c:when test="${p.status == 'APPROVED' and not empty p.purchaseOrderId}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt bởi CEO</span></c:when>
                                                        <c:when test="${p.status == 'APPROVED'}"><span class="status-pill status-approved"><span class="pdot"></span>Đã duyệt bởi Sale Manager</span></c:when>
                                                        <c:when test="${p.status == 'REJECTED' and not empty p.purchaseOrderId}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối bởi CEO</span></c:when>
                                                        <c:when test="${p.status == 'REJECTED'}"><span class="status-pill status-rejected"><span class="pdot"></span>Từ chối bởi Sale Manager</span></c:when>
                                                        <c:when test="${p.status == 'NEEDS_REVISION'}"><span class="status-pill status-revision"><span class="pdot"></span>Cần chỉnh sửa</span></c:when>
                                                        <c:when test="${p.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã hủy</span></c:when>
                                                        <c:when test="${p.status == 'DELETED'}"><span class="status-pill status-deleted"><span class="pdot"></span>Đã xoá</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${p.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        </form>
                        <div class="pagination">
                            <div class="info">Hiển thị <strong>${(currentPage - 1) * 10 + 1}</strong>–<strong>${currentPage * 10 > totalProposals ? totalProposals : currentPage * 10}</strong> / <strong>${totalProposals}</strong> kết quả</div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}<c:if test="${not empty dateFrom}">&dateFrom=<c:out value="${dateFrom}"/></c:if><c:if test="${not empty dateTo}">&dateTo=<c:out value="${dateTo}"/></c:if><c:if test="${not empty statusFilter}">&status=<c:out value="${statusFilter}"/></c:if><c:if test="${not empty search}">&search=<c:out value="${search}"/></c:if>" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/proposal-list.js"></script>
    </body>
</html>
