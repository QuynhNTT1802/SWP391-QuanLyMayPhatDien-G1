<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __poFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("poFmt", __poFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu mua — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <style>
            .po-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
            .po-table th, .po-table td { padding: 10px; border-bottom: 1px solid var(--border); text-align: left; font-size: 13px; }
            .po-table th { background: var(--surface-2); font-weight: 600; color: var(--muted); text-transform: uppercase; font-size: 11px; }
            .po-table tfoot td { padding: 12px 10px; border-top: 2px solid var(--border); font-size: 14px; background: var(--surface-2); }
            .mono { font-family: 'JetBrains Mono', monospace; }
            .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px 24px; margin: 16px 0; }
            .info-grid .row { padding: 6px 0; }
            .info-grid .lbl { color: var(--muted); font-size: 12px; text-transform: uppercase; }
            .info-grid .val { font-size: 14px; font-weight: 500; }
            .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
            .status-draft { background: #e2e3e5; color: #383d41; }
            .status-pending_ceo { background: #fff3cd; color: #856404; }
            .status-approved { background: #d4edda; color: #155724; }
            .status-rejected { background: #f8d7da; color: #721c24; }
            .status-cancelled { background: #e2e3e5; color: #383d41; }
            .po-code { font-family: 'JetBrains Mono', monospace; font-size: 14px; color: var(--accent); }
            .action-bar { display: flex; gap: 10px; margin: 16px 0; flex-wrap: wrap; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / ${po.poCode}</span>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">
                                <span class="po-code">${po.poCode}</span>
                                <c:choose>
                                    <c:when test="${po.status == 'DRAFT'}"><span class="status-pill status-draft">Nháp</span></c:when>
                                    <c:when test="${po.status == 'PENDING_CEO'}"><span class="status-pill status-pending_ceo">Chờ CEO duyệt</span></c:when>
                                    <c:when test="${po.status == 'APPROVED'}"><span class="status-pill status-approved">Đã duyệt</span></c:when>
                                    <c:when test="${po.status == 'REJECTED'}"><span class="status-pill status-rejected">Từ chối</span></c:when>
                                    <c:when test="${po.status == 'CANCELLED'}"><span class="status-pill status-cancelled">Đã hủy</span></c:when>
                                </c:choose>
                            </h2>
                        </div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.message}"/>', type: 'success'};
                            <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.toastMessage}">
                            window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <div class="card" style="padding: 20px;">
                        <div class="info-grid">
                            <div class="row"><div class="lbl">Tháng</div><div class="val">${po.period} (${po.periodStart} → ${po.periodEnd})</div></div>
                            <div class="row"><div class="lbl">Kho</div><div class="val">${po.warehouseName}</div></div>
                            <div class="row"><div class="lbl">Người tạo</div><div class="val">${po.createdByName} lúc ${po.createdAt.format(poFmt)}</div></div>
                            <div class="row"><div class="lbl">Số proposal gom</div><div class="val">${po.totalProposals}</div></div>
                            <c:if test="${po.status == 'APPROVED'}">
                                <div class="row"><div class="lbl">CEO duyệt lúc</div><div class="val">${po.approvedAt.format(poFmt)}</div></div>
                            </c:if>
                            <c:if test="${po.status == 'REJECTED'}">
                                <div class="row"><div class="lbl">CEO từ chối lúc</div><div class="val">${po.rejectedAt.format(poFmt)}</div></div>
                                <div class="row" style="grid-column: span 2;"><div class="lbl">Lý do từ chối</div><div class="val" style="color: var(--danger);">${po.rejectReason}</div></div>
                            </c:if>
                            <c:if test="${not empty po.note}">
                                <div class="row" style="grid-column: span 2;"><div class="lbl">Ghi chú PO</div><div class="val">${po.note}</div></div>
                            </c:if>
                        </div>
                    </div>

                    <h3 style="margin-top: 20px;">Chi tiết các dòng máy (${fn:length(po.details)} dòng)</h3>
                    <table class="po-table">
                        <thead>
                            <tr>
                                <th>Mã máy</th>
                                <th>Tên máy</th>
                                <th>Thương hiệu</th>
                                <th>SL đề xuất</th>
                                <th>Tồn kho</th>
                                <th>SL mua cuối</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="d" items="${po.details}">
                                <tr>
                                    <td>${d.generatorCode}</td>
                                    <td>${d.generatorName}</td>
                                    <td>${d.brandName}</td>
                                    <td>${d.proposedQuantity}</td>
                                    <td>${d.currentStock}</td>
                                    <td><strong>${d.finalQuantity}</strong></td>
                                    <td class="mono"><c:choose><c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice}" type="number" groupingUsed="true" minFractionDigits="0"/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose></td>
                                    <td class="mono"><c:choose><c:when test="${d.unitPrice != null}"><fmt:formatNumber value="${d.unitPrice * d.finalQuantity}" type="number" groupingUsed="true" minFractionDigits="0"/> ₫</c:when><c:otherwise>—</c:otherwise></c:choose></td>
                                    <td>${d.note}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" style="text-align:right;font-weight:700;">Tổng cộng:</td>
                                <td class="mono" style="font-weight:700;font-size:15px;"><fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true" minFractionDigits="0"/> ₫</td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>

                    <c:if test="${not empty sourceProposals}">
                        <h3 style="margin-top: 24px;">Đề xuất gốc từ sale staff (${fn:length(sourceProposals)} phiếu)</h3>
                        <table class="po-table">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Người tạo</th>
                                    <th>Kho</th>
                                    <th>Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="sp" items="${sourceProposals}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/proposal?action=detail&id=${sp.proposalId}">${sp.proposalCode}</a></td>
                                        <td>${sp.createdByName}</td>
                                        <td>${sp.warehouseName}</td>
                                        <td>${sp.status}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>

                    <div class="action-bar">
                        <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn">← Quay lại</a>

                        <c:set var="perms" value="${sessionScope.userPermissions}"/>
                        <c:set var="canApprovePo" value="${perms.contains('purchase_orders.approve')}"/>
                        <c:set var="canCreatePo" value="${perms.contains('purchase_orders.create')}"/>
                        <c:set var="isOwnerPo" value="${sessionScope.loggedUser.id == po.createdBy}"/>

                        <c:if test="${po.status == 'DRAFT' && canCreatePo}">
                            <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=sendToCeo" style="display:inline;">
                                <input type="hidden" name="id" value="${po.poId}"/>
                                <button type="submit" class="btn btn-primary">Gửi CEO duyệt</button>
                            </form>
                            <c:if test="${isOwnerPo}">
                                <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=cancel" style="display:inline;" onsubmit="return confirm('Hủy phiếu mua này?');">
                                    <input type="hidden" name="id" value="${po.poId}"/>
                                    <button type="submit" class="btn btn-danger">Hủy</button>
                                </form>
                            </c:if>
                        </c:if>

                        <c:if test="${po.status == 'PENDING_CEO' && canApprovePo}">
                            <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=approve" style="display:inline;" onsubmit="return confirm('Duyệt phiếu mua này?');">
                                <input type="hidden" name="id" value="${po.poId}"/>
                                <button type="submit" class="btn btn-primary">Duyệt</button>
                            </form>
                            <a href="${pageContext.request.contextPath}/purchase-order?action=reject&id=${po.poId}" class="btn btn-danger">Từ chối</a>
                        </c:if>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
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
