<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa phiếu mua RETURNED — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            .agg-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
            .agg-table th, .agg-table td { padding: 10px; border-bottom: 1px solid var(--border); text-align: left; font-size: 13px; }
            .agg-table th { background: var(--surface-2); font-weight: 600; color: var(--muted); text-transform: uppercase; font-size: 11px; }
            .qty-input { width: 80px; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; }
            .note-input { width: 100%; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; }
            .form-actions { display: flex; gap: 10px; margin-top: 20px; justify-content: flex-end; }
            .alert { padding: 14px 16px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
            .alert-warn { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
            .alert-warn strong { display: block; margin-bottom: 4px; }
            .po-info { display: flex; gap: 24px; flex-wrap: wrap; padding: 12px 16px; background: var(--surface-2); border-radius: 6px; margin-bottom: 16px; font-size: 13px; }
            .po-info > div { display: flex; flex-direction: column; }
            .po-info .lbl { color: var(--muted); font-size: 11px; text-transform: uppercase; }
            .po-info .val { font-weight: 600; font-family: 'JetBrains Mono', monospace; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chỉnh sửa phiếu mua RETURNED</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / Chỉnh sửa</span>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Chỉnh sửa phiếu mua <c:out value="${po.poCode}"/></h2>
                            <div class="page-sub">CEO đã trả lại phiếu mua này. Chỉnh sửa và gửi lại để CEO duyệt.</div>
                        </div>
                    </div>

                    <script>
                        <c:if test="${not empty sessionScope.message}">
                        window.SESSION_DATA = {message: '<c:out value="${sessionScope.message}"/>', type: 'info'};
                            <c:remove var="message" scope="session"/>
                        </c:if>
                    </script>

                    <c:if test="${not empty po.rejectReason}">
                        <div class="alert alert-warn">
                            <strong>Lý do CEO trả lại:</strong>
                            <c:out value="${po.rejectReason}"/>
                        </div>
                    </c:if>

                    <div class="po-info">
                        <div><span class="lbl">Mã phiếu mua</span><span class="val"><c:out value="${po.poCode}"/></span></div>
                        <div><span class="lbl">Kỳ</span><span class="val"><c:out value="${po.period}"/></span></div>
                        <div>
                            <span class="lbl">Kho</span>
                            <span class="val">
                                <c:choose>
                                    <c:when test="${not empty warehouses}">
                                        <c:forEach var="w" items="${warehouses}">
                                            <c:if test="${w.warehouseId == po.warehouseId}"><c:out value="${w.name}"/></c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><c:out value="${po.warehouseName}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div><span class="lbl">Số đề xuất nguồn</span><span class="val">${po.totalProposals}</span></div>
                    </div>

                    <c:choose>
                        <c:when test="${empty po.details}">
                            <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                Phiếu mua chưa có dòng máy nào.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=submitEditReturned">
                                <input type="hidden" name="id" value="${po.poId}"/>
                                <c:forEach var="sp" items="${sourceProposals}">
                                    <input type="hidden" name="proposalIds" value="${sp.proposalId}"/>
                                </c:forEach>

                                <div class="card" style="padding: 16px;">
                                    <p style="margin: 0 0 8px 0; color: var(--muted); font-size: 13px;">
                                        Chỉnh sửa <strong>SL mua cuối</strong> và ghi chú nếu cần, sau đó gửi lại CEO.
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
                                                <th>Ghi chú</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="d" items="${po.details}">
                                                <tr>
                                                    <td><input type="hidden" name="generatorId" value="${d.generatorId}"/><c:out value="${d.generatorCode}"/></td>
                                                    <td><c:out value="${d.generatorName}"/></td>
                                                    <td><c:out value="${d.brandName}"/></td>
                                                    <td>${d.proposedQuantity}</td>
                                                    <td>${d.currentStock}</td>
                                                    <td><input type="number" name="finalQuantity" value="${d.finalQuantity}" min="0" class="qty-input"/></td>
                                                    <td><input type="text" name="detailNote" value="<c:out value='${d.note}'/>" class="note-input" placeholder="Ghi chú..."/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <div style="margin-top: 16px;">
                                        <label><strong>Ghi chú PO:</strong></label>
                                        <textarea name="note" rows="2" style="width:100%; padding:8px; border:1px solid var(--border); border-radius:4px; box-sizing:border-box;"><c:out value="${po.note}"/></textarea>
                                    </div>

                                    <div class="form-actions">
                                        <a href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${po.poId}" class="btn">Hủy</a>
                                        <button type="submit" class="btn btn-primary">Gửi lại CEO duyệt</button>
                                    </div>
                                </div>
                            </form>
                        </c:otherwise>
                    </c:choose>

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
