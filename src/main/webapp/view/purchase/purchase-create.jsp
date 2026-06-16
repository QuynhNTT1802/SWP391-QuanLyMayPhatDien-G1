<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
            .agg-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
            .agg-table th, .agg-table td { padding: 10px; border-bottom: 1px solid var(--border); text-align: left; font-size: 13px; }
            .agg-table th { background: var(--surface-2); font-weight: 600; color: var(--muted); text-transform: uppercase; font-size: 11px; }
            .qty-input { width: 80px; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; }
            .note-input { width: 100%; padding: 6px 8px; border: 1px solid var(--border); border-radius: 4px; }
            .filter-row { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin-bottom: 16px; padding: 12px; background: var(--surface-2); border-radius: 6px; }
            .filter-row select { padding: 7px 10px; border: 1px solid var(--border); border-radius: 4px; background: white; }
            .form-actions { display: flex; gap: 10px; margin-top: 20px; justify-content: flex-end; }
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
                            <h2 class="page-title">Gom đề xuất theo quý + kho</h2>
                            <div class="page-sub">Chọn quý và kho để xem các đề xuất PENDING cần mua.</div>
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
                                <strong>Quý ${blockedPeriod}</strong> tại kho này đã bị CEO từ chối PO.
                                Không thể tạo PO mới cho quý này.
                            </div>
                        </div>
                    </c:if>

                    <form method="get" action="${pageContext.request.contextPath}/purchase-order" id="filterForm">
                        <input type="hidden" name="action" value="create"/>
                        <div class="filter-row">
                            <label><strong>Quý:</strong>
                                <select name="period" onchange="document.getElementById('filterForm').submit()">
                                    <c:forEach var="p" items="${periods}">
                                        <option value="${p}" <c:if test="${p == selectedPeriod}">selected</c:if>>${p}</option>
                                    </c:forEach>
                                </select>
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
                            <c:when test="${empty aggregations}">
                                <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                    Quý <strong>${selectedPeriod}</strong> chưa có đề xuất PENDING nào trong kho này.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${quarterBlocked}">
                                    <div class="card" style="padding: 24px; text-align: center; color: var(--muted);">
                                        Vui lòng chọn quý hoặc kho khác.
                                    </div>
                                </c:if>
                                <c:if test="${!quarterBlocked}">
                                <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=create">
                                    <input type="hidden" name="period" value="${selectedPeriod}"/>
                                    <input type="hidden" name="warehouseId" value="${selectedWarehouseId}"/>

                                    <div class="card" style="padding: 16px;">
                                        <p style="margin: 0 0 8px 0; color: var(--muted); font-size: 13px;">
                                            Hệ thống đã gộp các đề xuất theo máy. Tick chọn và chỉnh <strong>SL mua cuối</strong> nếu cần.
                                        </p>

                                        <table class="agg-table">
                                            <thead>
                                                <tr>
                                                    <th style="width:40px;">Chọn</th>
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
                                                <c:forEach var="agg" items="${aggregations}">
                                                    <tr>
                                                        <td><input type="checkbox" name="selectedGen" value="${agg.generatorId}" checked/></td>
                                                        <td><input type="hidden" name="generatorId" value="${agg.generatorId}"/>${agg.generatorCode}</td>
                                                        <td>${agg.generatorName}</td>
                                                        <td>${agg.brandName}</td>
                                                        <td>${agg.totalProposed}</td>
                                                        <td>${agg.currentStock}</td>
                                                        <td><input type="number" name="finalQuantity" value="${agg.totalProposed}" min="0" class="qty-input"/></td>
                                                        <td><input type="text" name="detailNote" class="note-input" placeholder="Ghi chú..."/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>

                                        <div style="margin-top: 16px;">
                                            <label><strong>Ghi chú PO:</strong></label>
                                            <textarea name="note" rows="2" style="width:100%; padding:8px; border:1px solid var(--border); border-radius:4px; box-sizing:border-box;"></textarea>
                                        </div>

                                        <div class="form-actions">
                                            <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn">Hủy</a>
                                            <button type="submit" name="submitType" value="draft" class="btn">Lưu nháp</button>
                                            <button type="submit" name="submitType" value="send" class="btn btn-primary">Gửi CEO duyệt</button>
                                        </div>
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
        </script>
    </body>
</html>
