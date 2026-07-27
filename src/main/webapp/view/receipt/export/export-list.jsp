<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phiếu xuất kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Phiếu xuất kho</h1>
                    <span class="crumb">/ Kho / Phiếu xuất</span>
                    <div class="top-actions">
                        <jsp:include page="../../common/admin/bell.jsp"/>
                        <a class="btn" href="${pageContext.request.contextPath}/export-receipt?action=selectOrder">
                            Tạo từ đơn hàng
                        </a>
                        <a class="btn" href="${pageContext.request.contextPath}/export-receipt?action=selectLiquidation">
                            Tạo từ đơn thanh lý
                        </a>
                        <a class="btn" href="${pageContext.request.contextPath}/export-receipt?action=selectTransfer">
                            Tạo từ phiếu luân chuyển
                        </a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/export-receipt?action=create">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                            Tạo phiếu xuất
                        </a>
                    </div>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho · Phiếu xuất</div>
                            <h2 class="page-title">Danh sách phiếu xuất kho</h2>
                        </div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.toastMessage}">
                        window.SESSION_DATA = { message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>' };
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                        <c:if test="${not empty requestScope.toastMessage}">
                        window.SESSION_DATA = window.SESSION_DATA || {};
                        window.SESSION_DATA.message = '<c:out value="${requestScope.toastMessage}"/>';
                        window.SESSION_DATA.type = '<c:out value="${requestScope.toastType}"/>';
                        </c:if>
                    </script>

                    <form method="get" action="${pageContext.request.contextPath}/export-receipt" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;flex:1;">
                        <input type="hidden" name="action" value="list" />
                        <input type="hidden" name="page" value="1" />
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                            <input name="search" value="<c:out value='${search}'/>" placeholder="Tìm theo mã phiếu, đơn, khách hàng, người tạo" autocomplete="off" />
                        </div>

                        <select class="filter-select" name="relatedType" onchange="this.form.submit()">
                            <option value="">Đơn liên quan: Tất cả</option>
                            <option value="ORDER" <c:if test="${relatedType == 'ORDER'}">selected</c:if>>Đơn hàng</option>
                            <option value="LIQUIDATION" <c:if test="${relatedType == 'LIQUIDATION'}">selected</c:if>>Thanh lý</option>
                        </select>

                        <select class="filter-select" name="status" onchange="this.form.submit()">
                            <option value="">Trạng thái: Tất cả</option>
                            <option value="PENDING" <c:if test="${statusFilter == 'PENDING'}">selected</c:if>>Chờ duyệt</option>
                            <option value="COMPLETED" <c:if test="${statusFilter == 'COMPLETED'}">selected</c:if>>Hoàn thành</option>
                            <option value="CANCELLED" <c:if test="${statusFilter == 'CANCELLED'}">selected</c:if>>Đã từ chối</option>
                        </select>


                        <div class="spacer"></div>
                        <button type="button" class="btn" id="clearFilters" onclick="location.href = '${pageContext.request.contextPath}/export-receipt?action=list'">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                            Xóa lọc
                        </button>
                    </form>

                    <div class="table-card" style="margin-top:16px;">
                        <table class="users" id="receiptsTable">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Kho</th>
                                    <th class="col-order">Đơn liên quan</th>
                                    <th class="col-reason">Lý do</th>
                                    <th class="col-creator">Người tạo</th>
                                    <th class="col-status">Trạng thái</th>
                                    <th class="col-date">Ngày tạo</th>
                                </tr>
                            </thead>
                            <tbody id="receiptsBody">
                                <c:choose>
                                    <c:when test="${empty receiptList}">
                                        <tr><td colspan="7"><div class="empty-state" style="padding:20px;">Không có phiếu nào.</div></td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="r" items="${receiptList}">
                                            <tr data-id="${r.receiptId}">
                                                <td><a class="code-link" href="${pageContext.request.contextPath}/export-receipt?action=detail&id=${r.receiptId}"><c:out value="${r.receiptCode}"/></a></td>
                                                <td>${r.warehouseName}</td>
                                                <td class="col-order">
                                                    <c:choose>
                                                    <c:when test="${not empty r.orderCode}">
                                                             <a href="javascript:void(0);" class="code-link code-link--purple" onclick="showRelatedModal(this)" data-doc-type="order" data-doc-code="<c:out value='${r.orderCode}'/>" data-doc-customer="<c:out value='${r.customerName}'/>" data-doc-id="${r.orderId}"><c:out value="${r.orderCode}"/></a>
                                                         </c:when>
                                                         <c:when test="${not empty r.liquidationCode}">
                                                              <a href="javascript:void(0);" class="code-link" onclick="showRelatedModal(this)" data-doc-type="liquidation" data-doc-code="<c:out value='${r.liquidationCode}'/>" data-doc-customer="<c:out value='${r.customerName}'/>" data-doc-id="${r.liquidationId}"><c:out value="${r.liquidationCode}"/></a>
                                                          </c:when>
                                                          <c:when test="${not empty r.transferCode}">
                                                              <a href="${pageContext.request.contextPath}/transfers?action=detail&id=${r.linkedTransferId}" class="code-link"><c:out value="${r.transferCode}"/></a>
                                                          </c:when>
                                                         <c:otherwise><span class="muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-reason">
                                                    <c:choose>
                                                        <c:when test="${not empty r.reasonName}">
                                                            <c:set var="reasonColor" value="status-neutral"/>
                                                            <c:set var="rc" value="${fn:toLowerCase(fn:replace(r.reasonName, ' ', ''))}"/>
                                                            <c:choose>
                                                                <c:when test="${fn:contains(rc, 'xuất') || fn:contains(rc, 'xuat')}"><c:set var="reasonColor" value="status-purple"/></c:when>
                                                                <c:when test="${fn:contains(rc, 'chuyển') || fn:contains(rc, 'chuyen') || fn:contains(rc, 'điều') || fn:contains(rc, 'dieu')}"><c:set var="reasonColor" value="status-teal"/></c:when>
                                                                <c:when test="${fn:contains(rc, 'bảo') || fn:contains(rc, 'bao')}"><c:set var="reasonColor" value="status-pink"/></c:when>
                                                                <c:when test="${fn:contains(rc, 'hư') || fn:contains(rc, 'hu') || fn:contains(rc, 'hết') || fn:contains(rc, 'het') || fn:contains(rc, 'hỏng') || fn:contains(rc, 'hong') || fn:contains(rc, 'cũ') || fn:contains(rc, 'cu')}"><c:set var="reasonColor" value="status-orange"/></c:when>
                                                            </c:choose>
                                                            <span class="status-pill ${reasonColor}"><span class="pdot"></span>${r.reasonName}</span>
                                                        </c:when>
                                                        <c:otherwise><span class="muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-creator"><c:out value="${r.createdByName}"/></td>
                                                <td class="col-status">
                                                    <c:choose>
                                                        <c:when test="${r.status == 'PENDING'}"><span class="status-pill status-pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                                        <c:when test="${r.status == 'COMPLETED'}"><span class="status-pill status-completed"><span class="pdot"></span>Hoàn thành</span></c:when>
                                                        <c:when test="${r.status == 'CANCELLED'}"><span class="status-pill status-cancelled"><span class="pdot"></span>Đã từ chối</span></c:when>
                                                        <c:otherwise><span class="status-pill"><span class="pdot"></span><c:out value="${r.status}"/></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="col-date">${r.createdAt}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <c:set var="filterParams" value="" />
                        <c:if test="${not empty statusFilter}">
                            <c:set var="filterParams" value="${filterParams}&status=${statusFilter}" />
                        </c:if>
                        <c:if test="${not empty whFilter}">
                            <c:set var="filterParams" value="${filterParams}&warehouse=${whFilter}" />
                        </c:if>
                        <c:if test="${not empty search}">
                            <c:set var="filterParams" value="${filterParams}&search=${search}" />
                        </c:if>
                        <c:if test="${not empty relatedType}">
                            <c:set var="filterParams" value="${filterParams}&relatedType=${relatedType}" />
                        </c:if>
                        <div class="pagination">
                            <div class="info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
                            <div class="controls">
                                <c:if test="${currentPage > 1}">
                                    <a href="?action=list&page=${currentPage - 1}${filterParams}" class="page-btn">‹</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <c:choose>
                                        <c:when test="${p == currentPage}"><span class="page-btn active">${p}</span></c:when>
                                        <c:otherwise><a href="?action=list&page=${p}${filterParams}" class="page-btn">${p}</a></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?action=list&page=${currentPage + 1}${filterParams}" class="page-btn">›</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <style>
            .code-link.code-link--purple { color:#7c3aed; text-decoration:none; cursor:pointer; font-weight:600; font-family:'JetBrains Mono',monospace; font-size:13px; }
            .code-link.code-link--purple:hover { text-decoration:underline; color:#6d28d9; }
            .status-purple { background:#ede9fe; color:#6d28d9; }
            .status-orange { background:#fff3e0; color:#b15c00; }
            .status-teal   { background:#e0f2f1; color:#00695c; }
            .status-pink   { background:#fce4ec; color:#a13d63; }
            .doc-modal-backdrop { position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:1000; display:none; align-items:center; justify-content:center; padding:20px; }
            .doc-modal-backdrop.open { display:flex; }
            .doc-modal { background:var(--surface); border-radius:8px; width:100%; max-width:480px; box-shadow:0 10px 40px rgba(0,0,0,.25); overflow:hidden; animation:modalPop .18s ease-out; }
            @keyframes modalPop { from{transform:scale(.96);opacity:0} to{transform:scale(1);opacity:1} }
            .doc-modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 18px; border-bottom:1px solid var(--border); }
            .doc-modal-header h3 { margin:0; font-size:16px; font-weight:700; }
            .doc-modal-close { background:transparent; border:none; font-size:22px; line-height:1; cursor:pointer; color:var(--muted); padding:0 4px; }
            .doc-modal-close:hover { color:var(--fg); }
            .doc-modal-body { padding:16px 18px; }
            .doc-info-row { display:flex; gap:10px; padding:8px 0; border-bottom:1px dashed var(--border); font-size:13.5px; }
            .doc-info-row:last-child { border-bottom:none; }
            .doc-info-row .lbl { flex:0 0 110px; color:var(--muted); font-weight:500; }
            .doc-info-row .val { flex:1; color:var(--fg); word-break:break-word; }
            .doc-modal-footer { padding:12px 18px; border-top:1px solid var(--border); display:flex; justify-content:flex-end; gap:8px; background:var(--surface-2); }
        </style>

        <div class="doc-modal-backdrop" id="relatedDocModal" onclick="if (event.target === this) closeRelatedModal();">
            <div class="doc-modal" role="dialog" aria-modal="true" aria-labelledby="relatedDocTitle">
                <div class="doc-modal-header">
                    <h3 id="relatedDocTitle">Thông tin</h3>
                    <button type="button" class="doc-modal-close" onclick="closeRelatedModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="doc-modal-body">
                    <div class="doc-info-row">
                        <div class="lbl" id="rdm-code-label">Mã</div>
                        <div class="val" id="rdm-code">—</div>
                    </div>
                    <div class="doc-info-row">
                        <div class="lbl">Khách hàng</div>
                        <div class="val" id="rdm-customer">—</div>
                    </div>
                </div>
                <div class="doc-modal-footer">
                    <button type="button" class="btn" onclick="closeRelatedModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="rdm-detail-link">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/export-scanner-actions.js"></script>
        <script>
            function showRelatedModal(el) {
                event.stopPropagation();
                var type = el.getAttribute('data-doc-type') || 'order';
                var code = el.getAttribute('data-doc-code') || '—';
                var cust = el.getAttribute('data-doc-customer') || '—';
                var id = el.getAttribute('data-doc-id') || '';

                if (type === 'order') {
                    document.getElementById('relatedDocTitle').textContent = 'Thông tin đơn hàng';
                    document.getElementById('rdm-code-label').textContent = 'Mã đơn';
                    document.getElementById('rdm-detail-link').href = window.APP_CTX + '/order?action=detail&id=' + id;
                } else {
                    document.getElementById('relatedDocTitle').textContent = 'Thông tin thanh lý';
                    document.getElementById('rdm-code-label').textContent = 'Mã thanh lý';
                    document.getElementById('rdm-detail-link').href = window.APP_CTX + '/liquidations?action=detail&id=' + id;
                }
                document.getElementById('rdm-code').textContent = code;
                document.getElementById('rdm-customer').textContent = cust;
                document.getElementById('relatedDocModal').classList.add('open');
            }
            function closeRelatedModal() {
                document.getElementById('relatedDocModal').classList.remove('open');
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeRelatedModal();
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    } else if (typeof toast === 'function') {
                        toast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'default');
                    }
                    window.SESSION_DATA = null;
                }
            });
        </script>
    </body>
</html>
