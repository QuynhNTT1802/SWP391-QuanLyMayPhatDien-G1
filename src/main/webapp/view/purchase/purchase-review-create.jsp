<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
        <title>Review tạo phiếu mua — Warehouse OS</title>
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
            .po-info .val { font-weight: 600; }
            .section-title { font-size: 14px; font-weight: 600; margin: 20px 0 8px 0; color: var(--text); }
            .prop-table { width: 100%; border-collapse: collapse; }
            .prop-table th, .prop-table td { padding: 8px 10px; border-bottom: 1px solid var(--border); text-align: left; font-size: 13px; }
            .prop-table th { background: var(--surface-2); font-weight: 600; color: var(--muted); text-transform: uppercase; font-size: 11px; }
            .agg-table tfoot td { padding: 12px 10px; border-top: 2px solid var(--border); font-weight: 700; font-size: 14px; background: var(--surface-2); }
            .qty-warn { color: #dc3545; font-size: 11px; margin-top: 2px; display: none; }
            .qty-warn.show { display: block; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Review tạo phiếu mua</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/purchase-order">Phiếu mua</a> / Tạo mới</span>
                </header>

                <main>
                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Phiếu mua</div>
                            <h2 class="page-title">Review phiếu mua từ <c:out value="${proposals.size()}"/> đề xuất</h2>
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

                    <c:if test="${not empty existingPo}">
                        <div class="alert alert-warn">
                            <strong>Đã có phiếu mua <c:out value="${existingPo.poCode}"/> (trạng thái <c:out value="${existingPo.status}"/>) cho kỳ + kho này.</strong>
                            Không thể tạo phiếu mua mới. Vui lòng hủy phiếu cũ trước.
                        </div>
                    </c:if>

                    <c:if test="${quarterBlocked}">
                        <div class="alert alert-error" style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 14px 18px; border-radius: 6px; margin-bottom: 16px; display: flex; align-items: center; gap: 10px;">
                            <svg viewBox="0 0 24 24" style="width:20px;height:20px;flex-shrink:0;stroke:currentColor;fill:none;stroke-width:2;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div>
                                <strong>Quý ${blockedPeriod}</strong> tại kho này đã bị CEO từ chối PO.
                                Không thể tạo PO mới cho quý này.
                            </div>
                        </div>
                    </c:if>

                    <div class="po-info">
                        <div>
                            <span class="lbl">Kỳ</span>
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
                    <div class="card" style="padding: 0; overflow: hidden;">
                        <table class="prop-table">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Người tạo</th>
                                    <th>Ngày tạo</th>
                                    <th>Kho</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${proposals}">
                                    <tr>
                                        <td><strong style="font-family: 'JetBrains Mono', monospace;"><c:out value="${p.proposalCode}"/></strong></td>
                                        <td><c:out value="${p.createdByName}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.proposalDate == null}">—</c:when>
                                                <c:otherwise>${p.proposalDate.format(propFmt)}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${p.warehouseName}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=submitReviewCreate">
                        <input type="hidden" name="period" value="${selectedPeriod}"/>
                        <input type="hidden" name="warehouseId" value="${selectedWarehouseId}"/>
                        <c:forEach var="p" items="${proposals}">
                            <input type="hidden" name="proposalIds" value="${p.proposalId}"/>
                        </c:forEach>

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
                                                <th>Ghi chú</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="agg" items="${aggregations}">
                                                <tr>
                                                    <td><input type="hidden" name="generatorId" value="${agg.generatorId}"/><c:out value="${agg.generatorCode}"/></td>
                                                    <td><c:out value="${agg.generatorName}"/></td>
                                                    <td><c:out value="${agg.brandName}"/></td>
                                                    <td>${agg.totalProposed}</td>
                                                    <td>${agg.currentStock}</td>
                                                    <td>
                                                        <input type="number" name="finalQuantity" value="${agg.totalProposed}" min="0" class="qty-input" data-proposed="${agg.totalProposed}"/>
                                                        <div class="qty-warn">SL mua cuối = 0 hoặc nhỏ hơn SL đề xuất — cần nhập ghi chú</div>
                                                    </td>
                                                    <td><input type="text" name="detailNote" class="note-input" placeholder="Ghi chú..."/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="5" style="text-align: right;">Tổng SL mua:</td>
                                                <td><span id="grandTotal">0</span></td>
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
                                        <button type="submit" name="submitType" value="draft" class="btn" <c:if test="${not empty existingPo or quarterBlocked}">disabled</c:if>>Lưu nháp</button>
                                        <button type="submit" name="submitType" value="send" class="btn btn-primary" <c:if test="${not empty existingPo or quarterBlocked}">disabled</c:if>>Gửi CEO duyệt</button>
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
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    } else {
                        alert(window.SESSION_DATA.message);
                    }
                }

                const qtyInputs = document.querySelectorAll('input[name="finalQuantity"]');
                const grandTotalEl = document.getElementById('grandTotal');

                function recalc() {
                    let total = 0;
                    qtyInputs.forEach(function (inp) {
                        const v = parseInt(inp.value, 10);
                        if (!isNaN(v) && v > 0) {
                            total += v;
                        }
                        const proposed = parseInt(inp.getAttribute('data-proposed'), 10) || 0;
                        const row = inp.closest('tr');
                        const warn = row.querySelector('.qty-warn');
                        const noteInput = row.querySelector('input[name="detailNote"]');
                        const needWarn = v <= 0 || v < proposed;
                        if (warn) {
                            if (needWarn) {
                                warn.classList.add('show');
                            } else {
                                warn.classList.remove('show');
                            }
                        }
                        if (noteInput) {
                            if (needWarn) {
                                noteInput.style.borderColor = '#dc3545';
                            } else {
                                noteInput.style.borderColor = '';
                            }
                        }
                    });
                    grandTotalEl.textContent = total;
                }

                qtyInputs.forEach(function (inp) {
                    inp.addEventListener('input', recalc);
                });
                recalc();

                const reviewForm = document.querySelector('form[action*="submitReviewCreate"]');
                if (reviewForm) {
                    reviewForm.addEventListener('submit', function (e) {
                        let hasError = false;
                        let firstErrorRow = null;
                        qtyInputs.forEach(function (inp) {
                            const v = parseInt(inp.value, 10) || 0;
                            const proposed = parseInt(inp.getAttribute('data-proposed'), 10) || 0;
                            const row = inp.closest('tr');
                            const noteInput = row.querySelector('input[name="detailNote"]');
                            const needWarn = v <= 0 || v < proposed;
                            if (needWarn && (!noteInput.value || noteInput.value.trim() === '')) {
                                hasError = true;
                                if (!firstErrorRow) {
                                    firstErrorRow = row;
                                }
                            }
                        });
                        if (hasError) {
                            e.preventDefault();
                            alert('Có dòng máy có SL mua cuối = 0 hoặc nhỏ hơn SL đề xuất mà chưa nhập ghi chú.\nVui lòng bổ sung ghi chú cho các dòng này.');
                            if (firstErrorRow) {
                                firstErrorRow.scrollIntoView({behavior: 'smooth', block: 'center'});
                            }
                        }
                    });
                }
            });
        </script>
    </body>
</html>
