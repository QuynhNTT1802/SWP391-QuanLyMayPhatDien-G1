<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết thẻ kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <style>
            .summary-card { display: flex; gap: 16px; margin: 16px 0; flex-wrap: wrap; }
            .summary-item { flex: 1; min-width: 180px; background: var(--surface-1); border: 1px solid var(--border); border-radius: var(--radius); padding: 16px; }
            .summary-label { font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.04em; margin-bottom: 6px; }
            .summary-value { font-size: 24px; font-weight: 800; }
            .qty-import { color: #155724; font-weight: 700; }
            .qty-export { color: #721c24; font-weight: 700; }

            /* Serial cell - compact */
            .serial-cell { font-size: 11px; font-family: 'JetBrains Mono', monospace; }
            .serial-tag { display: inline-block; padding: 2px 6px; background: var(--surface-2); border: 1px solid var(--border); border-radius: 3px; margin: 1px; color: var(--fg); }
            .serial-more { display: inline-block; padding: 2px 8px; background: var(--accent-soft); color: var(--accent); border: 1px solid color-mix(in srgb, var(--accent) 25%, transparent); border-radius: 10px; margin: 1px; font-weight: 600; cursor: pointer; font-size: 10.5px; }
            .serial-more:hover { background: color-mix(in srgb, var(--accent) 25%, var(--accent-soft)); }

            /* Modal */
            .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 200; padding: 20px; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 0; width: 100%; max-width: 560px; max-height: 80vh; display: flex; flex-direction: column; }
            .modal-head { padding: 18px 22px 14px; border-bottom: 1px solid var(--border); }
            .modal-head h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; display: flex; align-items: center; gap: 8px; }
            .modal-head .meta { font-size: 12px; color: var(--muted); }
            .modal-body { padding: 18px 22px; overflow-y: auto; flex: 1; }
            .modal-foot { padding: 12px 22px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; gap: 8px; }
            .modal-foot .count { font-size: 12px; color: var(--muted); }
            .modal-actions { display: flex; gap: 8px; }
            .serial-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 6px; }
            .serial-item { display: flex; align-items: center; gap: 6px; padding: 8px 10px; background: var(--surface-1); border: 1px solid var(--border); border-radius: var(--radius-sm); font-family: 'JetBrains Mono', monospace; font-size: 12px; color: var(--fg); word-break: break-all; }
            .serial-item .idx { color: var(--muted); font-size: 10px; min-width: 20px; }
            .serial-empty { padding: 30px; text-align: center; color: var(--muted); font-size: 13px; }
            .modal-search { width: 100%; padding: 8px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; margin-bottom: 12px; box-sizing: border-box; font-family: var(--font-ui); }
            .modal-search:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px color-mix(in srgb, var(--accent) 15%, transparent); }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>
            <div>
                <header class="topbar">
                    <h1>Thẻ kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/stock-card">Thẻ kho</a> / Chi tiết</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>
                <main>
                    <a href="${pageContext.request.contextPath}/stock-card" class="btn btn-back" title="Quay lại">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại
                    </a>

                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kho · Sản phẩm</div>
                            <h2 class="page-title">
                                <c:choose>
                                    <c:when test="${not empty stockCards}">
                                        ${stockCards.get(0).warehouseName} — ${stockCards.get(0).generatorModel}
                                    </c:when>
                                    <c:otherwise>Không tìm thấy dữ liệu</c:otherwise>
                                </c:choose>
                            </h2>
                            <div class="page-sub">Lịch sử nhập/xuất/điều chỉnh</div>
                        </div>
                    </div>

                    <div class="summary-card">
                        <div class="summary-item">
                            <div class="summary-label">Tổng nhập</div>
                            <div class="summary-value qty-import">+${totalImport}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tổng xuất</div>
                            <div class="summary-value qty-export">-${totalExport}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tồn kho hiện tại</div>
                            <div class="summary-value" style="color:var(--accent);">${currentStock}</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-label">Tổng giao dịch</div>
                            <div class="summary-value" style="color:var(--fg);">${not empty stockCards ? stockCards.size() : 0}</div>
                        </div>
                    </div>

                    <div class="table-card">
                        <table class="users">
                            <thead>
                                <tr>
                                    <th style="width:140px;">Thời gian</th>
                                    <th style="width:100px;">Loại</th>
                                    <th style="width:90px;">+/- SL</th>
                                    <th style="width:80px;">Tồn sau</th>
                                    <th>Mã phiếu</th>
                                    <th style="width:200px;">Serial</th>
                                    <th>Ghi chú</th>
                                    <th>Người tạo</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty stockCards}">
                                        <tr><td colspan="8">
                                            <div class="empty-state"><strong>Sản phẩm này chưa có giao dịch nào trong kho này</strong></div>
                                        </td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="sc" items="${stockCards}">
                                            <tr>
                                                <td style="font-size:12px;"><fmt:formatDate value="${sc.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}"><span class="status active" style="--dot:var(--accent);"><span class="sdot"></span>Nhập</span></c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}"><span class="status locked" style="--dot:var(--danger);"><span class="sdot"></span>Xuất</span></c:when>
                                                        <c:otherwise><span class="status active" style="--dot:var(--warn);background:var(--warn-soft);color:var(--warn);"><span class="sdot"></span>Điều chỉnh</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${sc.transactionType == 'IMPORT'}"><span class="qty-import">+${sc.quantityChange}</span></c:when>
                                                        <c:when test="${sc.transactionType == 'EXPORT'}"><span class="qty-export">-${sc.quantityChange}</span></c:when>
                                                        <c:otherwise><c:out value="${sc.quantityChange >= 0 ? '+' : ''}${sc.quantityChange}"/></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong>${sc.quantityAfter}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty sc.receiptCode}">
                                                            <a href="${pageContext.request.contextPath}${sc.transactionType == 'IMPORT' ? '/import-receipt' : '/export-receipt'}?action=detail&id=${sc.receiptId}" style="font-family:monospace;font-size:12px;">${sc.receiptCode}</a>
                                                        </c:when>
                                                        <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="serial-cell">
                                                    <c:choose>
                                                        <c:when test="${empty sc.serialList}">
                                                            <span style="color:var(--muted);">—</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="serialsArr" value="${fn:split(sc.serialList, ', ')}" />
                                                            <c:set var="serialCount" value="${fn:length(serialsArr)}" />
                                                            <span class="serial-tag"><c:out value="${serialsArr[0]}"/></span>
                                                            <c:if test="${serialCount > 1}">
                                                                <button type="button" class="serial-more" onclick="openSerialModal(${sc.stockCardId})" title="Xem tất cả serial">+${serialCount - 1}</button>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-size:12px;color:var(--muted);">${sc.referenceNote}</td>
                                                <td>${sc.createdByName}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <!-- Modal hiển thị danh sách serial -->
        <div class="modal-host" id="serialModal">
            <div class="modal-card">
                <div class="modal-head">
                    <h3>
                        <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 7h16M4 12h16M4 17h10"/></svg>
                        Danh sách serial
                    </h3>
                    <div class="meta" id="serialMeta">—</div>
                </div>
                <div class="modal-body">
                    <input type="text" class="modal-search" id="serialSearch" placeholder="Tìm serial..." autocomplete="off" />
                    <div class="serial-grid" id="serialGrid"></div>
                </div>
                <div class="modal-foot">
                    <div class="count" id="serialCount">—</div>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="closeSerialModal()">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script>
            var serialsMap = {};
            <c:forEach var="sc" items="${stockCards}">
                serialsMap[${sc.stockCardId}] = '<c:out value="${sc.serialList}"/>'.split(', ');
            </c:forEach>

            function escapeHtml(s) {
                return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
            }

            function renderSerialList(filter) {
                var grid = document.getElementById('serialGrid');
                var q = (filter || '').toLowerCase();
                var list = (window._currentSerials || []).filter(function (s) {
                    return !q || s.toLowerCase().indexOf(q) >= 0;
                });
                if (list.length === 0) {
                    grid.innerHTML = '<div class="serial-empty" style="grid-column:1/-1;">Không có serial nào' + (q ? ' khớp với "' + escapeHtml(q) + '"' : '') + '.</div>';
                } else {
                    var html = '';
                    for (var i = 0; i < list.length; i++) {
                        html += '<div class="serial-item"><span class="idx">' + (i + 1) + '.</span><span>' + escapeHtml(list[i]) + '</span></div>';
                    }
                    grid.innerHTML = html;
                }
                document.getElementById('serialCount').textContent =
                        'Hiển thị ' + list.length + ' / ' + (window._currentSerials ? window._currentSerials.length : 0) + ' serial';
            }

            function openSerialModal(stockCardId) {
                var serials = serialsMap[stockCardId] || [];
                serials = serials.filter(function (s) { return s && s.length > 0; });
                window._currentSerials = serials;
                var meta = 'Stock card #' + stockCardId + ' · ' + serials.length + ' serial';
                document.getElementById('serialMeta').textContent = meta;
                document.getElementById('serialSearch').value = '';
                renderSerialList('');
                document.getElementById('serialModal').classList.add('show');
                setTimeout(function () { document.getElementById('serialSearch').focus(); }, 50);
            }

            function closeSerialModal() {
                document.getElementById('serialModal').classList.remove('show');
            }

            (function () {
                var modal = document.getElementById('serialModal');
                if (!modal) return;
                modal.addEventListener('click', function (e) {
                    if (e.target === modal) closeSerialModal();
                });
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && modal.classList.contains('show')) closeSerialModal();
                });
                var search = document.getElementById('serialSearch');
                if (search) {
                    search.addEventListener('input', function () {
                        renderSerialList(this.value);
                    });
                }
            })();
        </script>
    </body>
</html>
