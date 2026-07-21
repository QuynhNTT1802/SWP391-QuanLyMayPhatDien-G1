<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
        <title>Xem xét tạo phiếu mua &mdash; Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-review-create.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
<header class="topbar">
                <h1>Xem xét tạo phiếu mua</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / Tạo mới</span>
                <jsp:include page="../common/admin/bell.jsp"/>
            </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Xem xét phiếu mua từ <c:out value="${proposals.size()}"/> đề xuất</h2>
                            <div class="page-sub">Kiểm tra số lượng mua cuối cùng trước khi tạo phiếu mua.</div>
                        </div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.message}"/>', type: 'info'};
                            <c:remove var="message" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.toastMessage}">
                            window.SESSION_DATA = {message: '<c:out value="${sessionScope.toastMessage}"/>', type: '<c:out value="${sessionScope.toastType}"/>'};
                            <c:remove var="toastMessage" scope="session"/>
                            <c:remove var="toastType" scope="session"/>
                        </c:if>
                    </script>

                    <div class="po-info">
                        <div>
                            <span class="lbl">Tháng</span>
                            <span class="val"><c:out value="${selectedPeriod}"/></span>
                        </div>
                        <div>
                            <span class="lbl">Kho</span>
                            <span class="val">
                                <c:forEach var="w" items="${warehouses}">
                                    <c:if test="${w.warehouseId == selectedWarehouseId}"><c:out value="${w.name}"/></c:if>
                                </c:forEach>
                            </span>
                        </div>
                        <div>
                            <span class="lbl">Số đề xuất</span>
                            <span class="val">${proposals.size()}</span>
                        </div>
                    </div>

                    <div class="section-title">Danh sách đề xuất đã chọn</div>
                    <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=submitReviewCreate">
                        <input type="hidden" name="period" value="${selectedPeriod}"/>
                        <input type="hidden" name="warehouseId" value="${selectedWarehouseId}"/>
                    <c:choose>
                        <c:when test="${empty creatorGroups}">
                            <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                Chưa có đề xuất nào.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="group" items="${creatorGroups}">
                                <div class="creator-section">
                                    <div class="creator-header open" onclick="toggleCreator(this)">
                                        <span>
                                            <span class="toggle-icon">▶</span>
                                            <span class="creator-name"><c:out value="${group.creatorName}"/></span>
                                        </span>
                                        <span class="creator-count">${fn:length(group.proposals)} phiếu</span>
                                    </div>
                                    <div class="creator-body open">
                                        <c:forEach var="p" items="${group.proposals}">
                                            <div class="proposal-card">
                                                <div class="proposal-head open" onclick="toggleProposal(this)">
                                                    <span>
                                                        <span class="toggle-icon">▶</span>
                                                        <span class="proposal-code"><c:out value="${p.proposalCode}"/></span>
                                                    </span>
                                                    <span class="proposal-date">
                                                        <c:choose>
                                                            <c:when test="${p.proposalDate == null}">&mdash;</c:when>
                                                            <c:otherwise>${p.proposalDate.format(propFmt)}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                                <div class="proposal-body open">
                                                    <table class="detail-table">
                                                        <thead>
                                                            <tr>
                                                                <th style="width:40px;">#</th>
                                                                <th>Máy phát</th>
                                                                <th>Hãng</th>
                                                                <th style="width:90px;">SL đề xuất</th>
                                                                <th style="width:100px;">SL mua cuối</th>
                                                                <th style="width:120px;">Đơn giá</th>
                                                                <th>Ghi chú</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="d" items="${p.details}" varStatus="st">
                                                                <tr data-gen="${d.generatorId}">
                                                                    <td class="mono">${st.index + 1}</td>
                                                                    <td><strong><c:out value="${d.generatorName}"/></strong>
                                                                        <div style="font-size:11px;color:var(--muted);"><c:out value="${d.generatorCode}"/></div></td>
                                                                    <td><c:out value="${d.brandName}"/></td>
                                                                    <td><span class="mono">${d.quantity}</span></td>
                                                                    <td><input type="number" name="finalQuantity" value="${d.quantity}" min="0" class="qty-input" data-proposed="${d.quantity}" readonly tabindex="-1" title="SL mua cuối = SL đề xuất gốc"/></td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${not empty d.unitPrice}">
                                                                                <span class="mono"><fmt:formatNumber value="${d.unitPrice}" pattern="#,##0"/> ₫</span>
                                                                                <input type="hidden" name="unitPrice" value="${d.unitPrice}"/>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="number" name="unitPrice" class="qty-input price-input" min="0" step="1000" placeholder="Nhập đơn giá" style="border-color:#dc3545;"/>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td><input type="text" name="detailNote" class="note-input" placeholder="Ghi chú..."
                                                                           value="<c:out value='${d.note}'/>"/></td>
                                                                    <input type="hidden" name="generatorId" value="${d.generatorId}"/>
                                                                    <input type="hidden" name="proposalDetailId" value="${d.proposalDetailId}"/>
                                                                    <input type="hidden" name="proposalId" value="${p.proposalId}"/>
                                                                </tr>
                                                            </c:forEach>
                                                            <c:if test="${empty p.details}">
                                                                <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:16px;">Phiếu này chưa có dòng máy nào.</td></tr>
                                                            </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                        <div class="section-title">Bảng tổng hợp theo máy</div>
                        <div class="card" style="padding: 16px;">
                            <c:choose>
                                <c:when test="${empty aggregations}">
                                    <div style="padding: 16px; text-align: center; color: var(--muted);">
                                        Không có dòng máy nào trong các đề xuất đã chọn.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p style="margin: 0 0 8px 0; color: var(--muted); font-size: 13px;">
                                        Hệ thống đã gộp các đề xuất theo máy. Chỉnh <strong>SL mua cuối</strong> nếu cần.
                                    </p>

                                    <table class="agg-table">
                                        <thead>
                                            <tr>
                                                <th>Mã máy</th>
                                                <th>Tên máy</th>
                                                <th>Thương hiệu</th>
                                                <th style="width:100px;">SL đề xuất</th>
                                                <th style="width:80px;">Tồn kho</th>
                                                <th style="width:100px;">SL mua cuối</th>
                                                <th style="width:120px;">Đơn giá</th>
                                                <th style="width:120px;">Thành tiền</th>
                                                <th>Ghi chú</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="agg" items="${aggregations}">
                                                <tr>
                                                    <td><c:out value="${agg.generatorCode}"/></td>
                                                    <td><c:out value="${agg.generatorName}"/></td>
                                                    <td><c:out value="${agg.brandName}"/></td>
                                                    <td>${agg.totalProposed}</td>
                                                    <td>${agg.currentStock}</td>
                                                    <td><span class="agg-qty mono" data-gen="${agg.generatorId}">${agg.totalProposed}</span></td>
                                                    <td><span class="agg-price mono" data-gen="${agg.generatorId}">&mdash;</span></td>
                                                    <td class="mono text-right"><span class="agg-row-total mono" data-gen="${agg.generatorId}">0</span></td>
                                                    <td><span class="agg-note" data-gen="${agg.generatorId}" style="color:var(--muted);">&mdash;</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="5" style="text-align: right;"><strong>Tổng SL mua:</strong> <span id="grandQty">0</span></td>
                                                <td colspan="2" style="text-align: right;"><strong>Tổng tiền:</strong></td>
                                                <td class="mono text-right"><strong><span id="grandTotal">0</span> ₫</strong></td>
                                                <td></td>
                                            </tr>
                                        </tfoot>
                                    </table>

                                    <div style="margin-top: 16px;">
                                        <label><strong>Ghi chú PO:</strong></label>
                                        <textarea name="note" rows="2" style="width:100%; padding:8px; border:1px solid var(--border); border-radius:4px; box-sizing:border-box;"></textarea>
                                    </div>

                                    <div class="form-actions">
                                        <a href="${pageContext.request.contextPath}/proposal?action=list" class="btn">Hủy</a>
                                        <button type="submit" class="btn btn-primary">Gửi duyệt</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </form>

                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>

        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-review-create-modal.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-review-create-recalc.js"></script>
    </body>
</html>