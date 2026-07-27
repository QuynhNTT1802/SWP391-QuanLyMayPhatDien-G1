<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Từ chối - Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/proposal-reject.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
                <div>
                    <header class="topbar">
                        <h1>Từ chối</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}"><c:out value="${proposal.proposalCode}"/></a> / Từ chối</span>
<div class="top-actions">
                        <jsp:include page="../common/admin/bell.jsp"/>
                    </div>
                </header>
                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Quay lại chi tiết</a>
                    <div class="page-head">
                        <div class="eyebrow">Đề xuất nhập kho · Từ chối</div>
                        <h1 class="title">
                            <span>Từ chối phiếu đề xuất</span>
                            <span class="pill pending"><span class="pdot"></span>Chờ duyệt</span>
                        </h1>
                        <div class="lede">Phiếu <c:out value="${proposal.proposalCode}"/> - vui lòng xem lại chi tiết và nhập lý do từ chối.</div>
                    </div>
                    <div class="section">
                        <div class="section-head"><h3>Thông tin phiếu</h3><span class="sub">Chỉ đọc</span></div>
                        <div class="section-body">
                            <div class="info-grid">
                                <div class="info-field">
                                    <div class="info-label">Mã phiếu</div>
                                    <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Người tạo</div>
                                    <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Ngày tạo</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${proposal.proposalDate == null}"><span class="empty">—</span></c:when>
                                            <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Kho nhập</div>
                                    <div class="info-value"><c:out value="${proposal.warehouseName}"/></div>
                                </div>
                                <div class="info-field" style="grid-column:1/-1">
                                    <div class="info-label">Ghi chú của nhân viên</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${empty proposal.note}"><span class="empty">—</span></c:when>
                                            <c:otherwise><c:out value="${proposal.note}"/></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="section">
                        <div class="section-head"><h3>Chi tiết máy phát đề xuất</h3><span class="sub"><c:out value="${fn:length(proposal.details)}"/> dòng</span></div>
                        <div class="section-body" style="padding:0">
                            <table class="detail-table">
                                <thead>
                                    <tr>
                                        <th class="col-num">#</th>
                                        <th>Mã máy</th>
                                        <th>Tên máy</th>
                                        <th class="col-brand">Thương hiệu</th>
                                        <th class="col-qty">Số lượng</th>
                                        <th class="col-qty">Tồn kho HT</th>
                                        <th>Ghi chú dòng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty proposal.details}">
                                            <tr><td colspan="7" class="text-center" style="padding:18px;color:var(--muted)">Không có dòng chi tiết nào.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                <tr>
                                                    <td class="col-num">${st.count}</td>
                                                    <td class="mono"><c:out value="${d.generatorCode}"/></td>
                                                    <td><c:out value="${d.generatorName}"/></td>
                                                    <td><c:out value="${d.brandName}"/></td>
                                                    <td class="col-qty mono"><c:out value="${d.quantity}"/></td>
                                                    <td class="col-qty mono"><c:out value="${d.currentStock}"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty d.note}"><span class="empty">—</span></c:when>
                                                            <c:otherwise><c:out value="${d.note}"/></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <form class="section" method="post" action="${pageContext.request.contextPath}/proposal?action=reject" onsubmit="return validateRejectForm();">
                        <div class="section-head"><h3>Lý do từ chối</h3><span class="sub">Bắt buộc</span></div>
                        <div class="section-body">
                            <div class="alert alert-warn">
                                <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                <span><strong>Hành động này không thể hoàn tác.</strong> Phiếu sẽ chuyển sang trạng thái "Từ chối" và nhân viên tạo sẽ nhận được thông báo.</span>
                            </div>
                            <input type="hidden" name="id" value="${proposal.proposalId}" />
                            <div class="field">
                                <label class="field-label" for="rejectReason">Lý do từ chối <span class="req">*</span></label>
                                <textarea class="input" id="rejectReason" name="rejectReason" rows="5" required placeholder="VD: Số lượng đề xuất vượt quá nhu cầu thực tế tại kho HCM tháng này..."></textarea>
                            </div>
                            <div class="form-actions">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Quay lại</a>
                                <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                            </div>
                        </div>
                    </form>
                </main>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/js/proposal-reject.js"></script>
    </body>
</html>
