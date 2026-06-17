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
            .proposal-code { font-weight: 600; font-size: 13px; font-family: 'JetBrains Mono', monospace; }
            .proposal-date { font-size: 12px; color: var(--muted); }
            .proposal-body { display: none; }
            .proposal-body.open { display: block; }
            .detail-table { width: 100%; border-collapse: collapse; }
            .detail-table th { text-align: left; font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface); padding: 8px 12px; border-bottom: 1px solid var(--border); }
            .detail-table td { padding: 8px 12px; border-bottom: 1px solid var(--border); font-size: 13px; }
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
                            <strong>Đã có phiếu mua <c:out value="${existingPo.poCode}"/> (trạng thái <c:out value="${existingPo.status}"/>) cho tháng + kho này.</strong>
                            Không thể tạo phiếu mua mới. Vui lòng hủy phiếu cũ trước.
                        </div>
                    </c:if>

                    <c:if test="${quarterBlocked}">
                        <div class="alert alert-error" style="background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; padding: 14px 18px; border-radius: 6px; margin-bottom: 16px; display: flex; align-items: center; gap: 10px;">
                            <svg viewBox="0 0 24 24" style="width:20px;height:20px;flex-shrink:0;stroke:currentColor;fill:none;stroke-width:2;"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <div>
                                <strong>Tháng ${blockedPeriod}</strong> tại kho này đã bị CEO từ chối PO.
                                Không thể tạo PO mới cho tháng này.
                            </div>
                        </div>
                    </c:if>

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
                                                    <span class="proposal-date">
                                                        <c:choose>
                                                            <c:when test="${p.proposalDate == null}">—</c:when>
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
                                                                <th style="width:70px;">Tồn kho</th>
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
                                                                    <td>—</td>
                                                                    <td><input type="number" name="finalQuantity" value="${d.quantity}" min="0" class="qty-input" data-proposed="${d.quantity}"/></td>
                                                                    <td><input type="text" name="unitPrice" class="qty-input" placeholder="VNĐ"
                                                                           value="${d.unitPrice != null ? d.unitPrice : ''}"/></td>
                                                                    <td><input type="text" name="detailNote" class="note-input" placeholder="Ghi chú..."
                                                                           value="<c:out value='${d.note}'/>"/></td>
                                                                    <input type="hidden" name="generatorId" value="${d.generatorId}"/>
                                                                    <input type="hidden" name="proposalId" value="${p.proposalId}"/>
                                                                </tr>
                                                            </c:forEach>
                                                            <c:if test="${empty p.details}">
                                                                <tr><td colspan="8" style="text-align:center;color:var(--muted);padding:16px;">Phiếu này chưa có dòng máy nào.</td></tr>
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

                    <form method="post" action="${pageContext.request.contextPath}/purchase-order?action=submitReviewCreate">
                        <input type="hidden" name="period" value="${selectedPeriod}"/>
                        <input type="hidden" name="warehouseId" value="${selectedWarehouseId}"/>

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
                                                    <td><span class="agg-price mono" data-gen="${agg.generatorId}">—</span></td>
                                                    <td class="mono text-right"><span class="agg-row-total mono" data-gen="${agg.generatorId}">0</span></td>
                                                    <td><span class="agg-note" data-gen="${agg.generatorId}" style="color:var(--muted);">—</span></td>
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
            function toggleCreator(el) {
                el.classList.toggle('open');
                var body = el.nextElementSibling;
                if (body) body.classList.toggle('open');
            }
            function toggleProposal(el) {
                el.classList.toggle('open');
                var body = el.nextElementSibling;
                if (body) body.classList.toggle('open');
            }
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    } else {
                        alert(window.SESSION_DATA.message);
                    }
                }

                const detailRows = document.querySelectorAll('tr[data-gen]');
                const grandTotalEl = document.getElementById('grandTotal');
                const grandQtyEl = document.getElementById('grandQty');

                function parsePrice(str) {
                    if (!str) return 0;
                    const cleaned = String(str).replace(/[^\d.]/g, '');
                    const n = parseFloat(cleaned);
                    return isNaN(n) ? 0 : n;
                }

                function fmtMoney(n) {
                    if (!isFinite(n)) n = 0;
                    return n.toLocaleString('vi-VN');
                }

                function recalc() {
                    const perGen = {};
                    let totalQty = 0;
                    let totalMoney = 0;
                    detailRows.forEach(function (row) {
                        const gen = row.getAttribute('data-gen');
                        if (!gen) return;
                        const qtyInp = row.querySelector('input[name="finalQuantity"]');
                        const priceInp = row.querySelector('input[name="unitPrice"]');
                        const noteInp = row.querySelector('input[name="detailNote"]');
                        const v = parseInt(qtyInp ? qtyInp.value : '', 10);
                        const safeQty = isNaN(v) || v < 0 ? 0 : v;
                        const price = parsePrice(priceInp ? priceInp.value : '');
                        const note = (noteInp && noteInp.value || '').trim();
                        if (!perGen[gen]) perGen[gen] = {qty: 0, money: 0, price: price, note: ''};
                        perGen[gen].qty += safeQty;
                        perGen[gen].money += safeQty * price;
                        if (price > 0) perGen[gen].price = price;
                        if (note) perGen[gen].note = note;
                        totalQty += safeQty;
                        totalMoney += safeQty * price;
                    });
                    document.querySelectorAll('.agg-qty').forEach(function (el) {
                        const g = el.getAttribute('data-gen');
                        if (perGen[g]) el.textContent = perGen[g].qty;
                    });
                    document.querySelectorAll('.agg-price').forEach(function (el) {
                        const g = el.getAttribute('data-gen');
                        if (perGen[g] && perGen[g].price > 0) {
                            el.textContent = fmtMoney(perGen[g].price);
                        } else {
                            el.textContent = '—';
                        }
                    });
                    document.querySelectorAll('.agg-row-total').forEach(function (el) {
                        const g = el.getAttribute('data-gen');
                        if (perGen[g]) el.textContent = fmtMoney(perGen[g].money);
                    });
                    document.querySelectorAll('.agg-note').forEach(function (el) {
                        const g = el.getAttribute('data-gen');
                        const n = perGen[g] ? perGen[g].note : '';
                        el.textContent = n ? n : '—';
                        el.style.color = n ? '' : 'var(--muted)';
                    });
                    if (grandQtyEl) grandQtyEl.textContent = totalQty;
                    if (grandTotalEl) grandTotalEl.textContent = fmtMoney(totalMoney);
                }

                detailRows.forEach(function (row) {
                    ['finalQuantity', 'unitPrice', 'detailNote'].forEach(function (n) {
                        const inp = row.querySelector('input[name="' + n + '"]');
                        if (inp) inp.addEventListener('input', recalc);
                    });
                });
                recalc();

                const reviewForm = document.querySelector('form[action*="submitReviewCreate"]');
                if (reviewForm) {
                    reviewForm.addEventListener('submit', function (e) {
                        let hasError = false;
                        let firstErrorRow = null;
                        detailRows.forEach(function (row) {
                            const qtyInp = row.querySelector('input[name="finalQuantity"]');
                            const noteInp = row.querySelector('input[name="detailNote"]');
                            if (!qtyInp) return;
                            const v = parseInt(qtyInp.value, 10) || 0;
                            const proposed = parseInt(qtyInp.getAttribute('data-proposed'), 10) || 0;
                            const needWarn = v <= 0 || (proposed > 0 && v < proposed);
                            if (needWarn && (!noteInp.value || noteInp.value.trim() === '')) {
                                hasError = true;
                                if (!firstErrorRow) firstErrorRow = row;
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
