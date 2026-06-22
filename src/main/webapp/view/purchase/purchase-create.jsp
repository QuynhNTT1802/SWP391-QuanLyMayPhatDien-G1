<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tạo phiếu mua — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            .filter-row { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-bottom: 16px; padding: 12px; background: var(--surface-2); border-radius: 6px; }
            .filter-row select { padding: 7px 10px; border: 1px solid var(--border); border-radius: 4px; background: white; }
            .creator-section { border: 1px solid var(--border); border-radius: 8px; overflow: hidden; margin-bottom: 14px; }
            .creator-header { display: flex; align-items: center; gap: 10px; padding: 12px 16px; background: var(--surface-2); cursor: pointer; user-select: none; }
            .creator-header:hover { background: var(--surface); }
            .creator-header .toggle-icon { transition: transform .2s; font-size: 12px; color: var(--muted); }
            .creator-header.open .toggle-icon { transform: rotate(90deg); }
            .creator-name { font-weight: 700; font-size: 14px; }
            .creator-count { font-size: 12px; color: var(--muted); margin-left: auto; }
            .creator-body { display: none; }
            .creator-body.open { display: block; }
            .proposal-card { border-top: 1px solid var(--border); }
            .proposal-card:first-child { border-top: 0; }
            .proposal-head { display: flex; align-items: center; gap: 10px; padding: 10px 16px 10px 32px; cursor: pointer; user-select: none; }
            .proposal-head:hover { background: var(--surface); }
            .proposal-head .toggle-icon { transition: transform .2s; font-size: 11px; color: var(--muted); }
            .proposal-head.open .toggle-icon { transform: rotate(90deg); }
            .proposal-code { font-weight: 600; font-size: 13px; font-family: var(--font-mono); }
            .proposal-date { font-size: 12px; color: var(--muted); }
            .proposal-body { display: none; }
            .proposal-body.open { display: block; }
            .detail-table { width: 100%; border-collapse: collapse; }
            .detail-table th { text-align: left; font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface); padding: 8px 12px; border-bottom: 1px solid var(--border); }
            .detail-table td { padding: 8px 12px; border-bottom: 1px solid var(--border); font-size: 13px; }
            .qty-input { width: 80px; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; font-size: 13px; }
            .price-input { width: 100px; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; font-size: 13px; }
            .note-input { width: 100%; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; font-size: 13px; box-sizing: border-box; }
            .form-actions { display: flex; gap: 10px; margin-top: 20px; justify-content: flex-end; }
            .mono { font-family: var(--font-mono); }
            .text-right { text-align: right; }
            .empty-msg { padding: 32px; text-align: center; color: var(--muted); font-size: 14px; }
            .check-proposal { width: 16px; height: 16px; cursor: pointer; }
            .stock-badge { font-size: 12px; color: var(--muted); }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Tạo phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / Tạo mới</span>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Gom đề xuất theo tháng + kho</h2>
                            <div class="page-sub">Chọn tháng và kho, mỗi người đề xuất là một nhóm riêng.</div>
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

                    <c:if test="${quarterBlocked}">
                        <div class="alert alert-error" style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 14px 18px; border-radius: 6px; margin-bottom: 16px; display: flex; align-items: center; gap: 10px;">
                            <svg viewBox="0 0 24 24" style="width:20px;height:20px;flex-shrink:0;stroke:currentColor;fill:none;stroke-width:2;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div>
                                <strong>Tháng ${blockedPeriod}</strong> tại kho này đã bị CEO từ chối PO.
                                Không thể tạo PO mới cho tháng này.
                            </div>
                        </div>
                    </c:if>

                    <form method="get" action="${pageContext.request.contextPath}/purchase-order" id="filterForm">
                        <input type="hidden" name="action" value="create"/>
                        <div class="filter-row">
                            <label><strong>Tháng:</strong>
                                <c:set var="selPeriodVal">
                                    <c:choose>
                                        <c:when test="${fn:length(selectedPeriod) eq 6}">${fn:substring(selectedPeriod,0,4)}-${fn:substring(selectedPeriod,4)}</c:when>
                                        <c:otherwise>${selectedPeriod}</c:otherwise>
                                    </c:choose>
                                </c:set>
                                <input type="month" name="period" value="${selPeriodVal}"
                                       onchange="document.getElementById('filterForm').submit()">
                            </label>
                            <label><strong>Kho:</strong>
                                <select name="warehouseId" onchange="document.getElementById('filterForm').submit()">
                                    <option value="">-- Chọn kho --</option>
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.warehouseId}" <c:if test="${w.warehouseId == selectedWarehouseId}">selected</c:if>>${w.name}</option>
                                    </c:forEach>
                                </select>
                            </label>
                        </div>
                    </form>

                    <c:if test="${selectedWarehouseId > 0}">
                        <c:choose>
                            <c:when test="${empty creatorGroups}">
                                <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                    Tháng <strong>${selectedPeriod}</strong> chưa có đề xuất APPROVED nào trong kho này.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${quarterBlocked}">
                                    <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                        Vui lòng chọn tháng hoặc kho khác.
                                    </div>
                                </c:if>
                                <c:if test="${!quarterBlocked}">
                                <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=create">
                                    <input type="hidden" name="period" value="${selectedPeriod}"/>
                                    <input type="hidden" name="warehouseId" value="${selectedWarehouseId}"/>

                                    <c:forEach var="group" items="${creatorGroups}">
                                        <div class="creator-section">
                                            <div class="creator-header open" onclick="toggleCreator(this)">
                                                <span class="toggle-icon">▶</span>
                                                <span class="creator-name"><c:out value="${group.creatorName}"/></span>
                                                <span class="creator-count">${fn:length(group.proposals)} phiếu</span>
                                            </div>
                                            <div class="creator-body open">
                                        <c:forEach var="p" items="${group.proposals}">
                                        <div class="proposal-card">
                                            <div class="proposal-head open" onclick="toggleProposal(this)">
                                                <span class="toggle-icon">▶</span>
                                                <span class="proposal-code"><c:out value="${p.proposalCode}"/></span>
                                                <span class="proposal-date">${p.proposalDate}</span>
                                            </div>
                                            <div class="proposal-body open">
                                                <table class="detail-table">
                                                    <thead>
                                                        <tr>
                                                            <th style="width:40px;">#</th>
                                                            <th>Máy phát</th>
                                                            <th>Hãng</th>
                                                            <th style="width:90px;">SL đề xuất</th>
                                                            <th style="width:70px;">Tồn kho</th>
                                                            <th style="width:100px;">SL mua cuối</th>
                                                            <th style="width:120px;">Đơn giá</th>
                                                            <th>Ghi chú</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="d" items="${p.details}" varStatus="st">
                                                            <tr>
                                                                <td class="mono">${st.index + 1}</td>
                                                                <td><strong><c:out value="${d.generatorName}"/></strong>
                                                                    <div style="font-size:11px;color:var(--muted);"><c:out value="${d.generatorCode}"/></div></td>
                                                                <td><c:out value="${d.brandName}"/></td>
                                                                <td><span class="mono">${d.quantity}</span></td>
                                                                <td><span class="stock-badge">—</span></td>
                                                                <td><input type="number" name="finalQuantity" value="${d.quantity}" min="0" class="qty-input"/></td>
                                                                <td><input type="text" name="unitPrice" class="price-input" placeholder="VNĐ"
                                                                       value="${d.unitPrice != null ? d.unitPrice : ''}"/></td>
                                                                <td><input type="text" name="detailNote" class="note-input" placeholder="Ghi chú..."
                                                                       value="<c:out value='${d.note}'/>"/></td>
                                                                <input type="hidden" name="generatorId" value="${d.generatorId}"/>
                                                                <input type="hidden" name="proposalId" value="${p.proposalId}"/>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                        </c:forEach>
                                            </div></div>
                                    </c:forEach>

                                    <div style="margin-top: 16px;">
                                        <label><strong>Ghi chú PO:</strong></label>
                                        <textarea name="note" rows="2" style="width:100%; padding:8px; border:1px solid var(--border); border-radius:4px; box-sizing:border-box;"></textarea>
                                    </div>

                                    <div class="form-actions">
                                        <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn">Hủy</a>
                                        <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                                        <button type="submit" name="submitType" value="send" class="btn btn-primary">Gửi CEO duyệt</button>
                                    </div>
                                </form>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

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

            function toggleCreator(el) {
                el.classList.toggle('open');
                el.nextElementSibling.classList.toggle('open');
            }

            function toggleProposal(el) {
                el.classList.toggle('open');
                el.nextElementSibling.classList.toggle('open');
            }
        </script>
    </body>
</html>