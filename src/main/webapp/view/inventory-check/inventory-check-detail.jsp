<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết kiểm kê — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/inventory-check.css">
</head>
<body>
    <div class="app">
        <jsp:include page="../common/admin/aside.jsp"></jsp:include>

        <div>
            <header class="topbar">
                <h1>Chi tiết kiểm kê</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/inventory-check">Kiểm kê</a> / <span><c:out value="${check.checkCode}"/></span></span>
                <div class="top-actions">
                    <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    </button>
                </div>
            </header>

            <main>
                <a class="back-link" href="${pageContext.request.contextPath}/inventory-check">
                    <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    Quay lại danh sách
                </a>

                <c:if test="${not empty sessionScope.toastMessage}">
                    <div style="background:var(--accent);color:var(--bg);padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                        <c:out value="${sessionScope.toastMessage}"/>
                    </div>
                    <c:remove var="toastMessage" scope="session"/>
                </c:if>
                <c:if test="${not empty error}">
                    <div style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 30%,transparent);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                        <c:out value="${error}"/>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <div class="hero">
                    <div class="hero-body">
                        <h2 class="hero-name">
                            <c:out value="${check.checkCode}"/>
                            <c:choose>
                                <c:when test="${check.status == 'doing'}"><span class="status-doing"><span class="sdot"></span>Đang kiểm kê</span></c:when>
                                <c:when test="${check.status == 'completed'}"><span class="status-completed"><span class="sdot"></span>Đã hoàn thành</span></c:when>
                            </c:choose>
                        </h2>
                        <div class="hero-meta">
                            <span>Phiếu kiểm kê</span>
                            <span class="sep">·</span>
                            <span class="id">#${check.id}</span>
                            <span class="sep">·</span>
                            <span>Ngày tạo: ${check.createdAt}</span>
                        </div>
                        <div class="hero-pills">
                            <span class="pill warehouse"><span class="pdot"></span><a href="${pageContext.request.contextPath}/warehouse?action=view&id=${check.warehouseId}"><c:out value="${check.warehouseName}"/></a></span>
                            <span class="pill status-active"><span class="pdot"></span>Người thực hiện: <c:out value="${check.createdByName}"/></span>
                        </div>
                    </div>
                </div>

                <c:if test="${check.status == 'doing'}">
                    <div class="action-bar-top">
                        <a href="${pageContext.request.contextPath}/inventory-check?action=edit&id=${check.id}" class="btn btn-warn">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                            Nhập số lượng
                        </a>
                        <button type="button" class="btn btn-success" onclick="openModal('completeModal')">
                            <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                            Hoàn thành kiểm kê
                        </button>
                    </div>
                </c:if>

                <c:if test="${check.status == 'completed'}">
                    <div class="action-bar-top">
                        <button type="button" class="btn btn-primary" onclick="openModal('exportModal')">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                            Trích xuất báo cáo
                        </button>
                    </div>
                </c:if>

                <div class="section" style="padding: 18px 22px;">
                    <div class="tabs">
                        <button type="button" class="tab active" data-tab="info">Thông tin chung</button>
                        <button type="button" class="tab" data-tab="products">Chi tiết kiểm kê</button>
                        <c:if test="${not empty logs}">
                            <button type="button" class="tab" data-tab="history">Lịch sử</button>
                        </c:if>
                    </div>

                    <div class="tab-panel active" id="tab-info">
                        <div class="info-grid">
                            <div class="info-field">
                                <div class="info-label">Mã phiếu</div>
                                <div class="info-value"><c:out value="${check.checkCode}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Kho kiểm kê</div>
                                <div class="info-value"><c:out value="${check.warehouseName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Người thực hiện</div>
                                <div class="info-value"><c:out value="${check.createdByName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Trạng thái</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${check.status == 'doing'}"><span class="status-doing"><span class="sdot"></span>Đang kiểm kê</span></c:when>
                                        <c:when test="${check.status == 'completed'}"><span class="status-completed"><span class="sdot"></span>Đã hoàn thành</span></c:when>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Thời gian bắt đầu</div>
                                <div class="info-value mono">${check.startedAt}</div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Thời gian kết thúc</div>
                                <div class="info-value mono">
                                    <c:choose>
                                        <c:when test="${not empty check.completedAt}">${check.completedAt}</c:when>
                                        <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Tổng mặt hàng</div>
                                <div class="info-value">${details.size()} máy</div>
                            </div>
                        </div>
                        <c:if test="${not empty check.notes}">
                            <div style="margin-top: 18px;">
                                <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú</div>
                                <div style="font-size:13px;color:var(--fg-soft);white-space:pre-wrap;line-height:1.55;padding:14px;background:var(--surface-2);border-radius:var(--radius-sm);"><c:out value="${check.notes}"/></div>
                            </div>
                        </c:if>
                    </div>

                    <div class="tab-panel" id="tab-products">
                    <c:if test="${empty details}">
                        <div style="padding:24px;text-align:center;color:var(--muted);font-size:14px;">Chưa có dữ liệu kiểm kê.</div>
                    </c:if>
                    <c:if test="${not empty details}">
                        <c:set var="totalSys" value="0"/>
                        <c:set var="totalActual" value="0"/>
                        <c:set var="totalGood" value="0"/>
                        <c:set var="totalPoor" value="0"/>
                        <c:set var="totalDamaged" value="0"/>
                        <c:forEach var="d" items="${details}">
                            <c:set var="totalSys" value="${totalSys + d.systemQuantity}"/>
                            <c:set var="totalActual" value="${totalActual + (not empty d.actualQuantity ? d.actualQuantity : 0)}"/>
                            <c:forEach var="s" items="${serialsByDetail[d.id]}">
                                <c:if test="${s.status == 'GOOD'}"><c:set var="totalGood" value="${totalGood + 1}"/></c:if>
                                <c:if test="${s.status == 'POOR'}"><c:set var="totalPoor" value="${totalPoor + 1}"/></c:if>
                                <c:if test="${s.status == 'DAMAGED'}"><c:set var="totalDamaged" value="${totalDamaged + 1}"/></c:if>
                            </c:forEach>
                        </c:forEach>

                        <div class="summary-row">
                            <div class="summary-card">
                                <div class="summary-lbl">Tổng sổ sách</div>
                                <div class="summary-val">${totalSys}</div>
                            </div>
                            <div class="summary-card">
                                <div class="summary-lbl">SL thực tế</div>
                                <div class="summary-val">${totalActual}</div>
                            </div>
                            <div class="summary-card sum-good">
                                <div class="summary-lbl">Tốt</div>
                                <div class="summary-val">${totalGood}</div>
                            </div>
                            <div class="summary-card sum-poor">
                                <div class="summary-lbl">Kém</div>
                                <div class="summary-val">${totalPoor}</div>
                            </div>
                            <div class="summary-card sum-damaged">
                                <div class="summary-lbl">Hỏng</div>
                                <div class="summary-val">${totalDamaged}</div>
                            </div>
                        </div>

                        <table class="detail-table">
                            <thead>
                                <tr>
                                    <th style="width:40px;">#</th>
                                    <th>Mã máy</th>
                                    <th>Thương hiệu</th>
                                    <th>SL sổ sách</th>
                                    <th>SL thực tế</th>
                                    <th>Chênh lệch</th>
                                    <th>Ghi chú</th>
                                    <th style="width:50px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${details}" varStatus="st">
                                    <c:set var="diff" value="${d.systemQuantity - (not empty d.actualQuantity ? d.actualQuantity : 0)}"/>
                                        <tr class="detail-row" data-detail-id="${d.id}">
                                            <td>${st.index + 1}</td>
                                            <td>
                                                <strong>
                                                    <a href="${pageContext.request.contextPath}/stock-card?warehouseId=${check.warehouseId}&generatorId=${d.generatorId}" target="_blank">
                                                        <c:out value="${d.generatorModel}"/>
                                                    </a>
                                                </strong>
                                            </td>
                                            <td><c:out value="${not empty d.generatorBrand ? d.generatorBrand : '—'}"/></td>
                                            <td class="qty-sys">${d.systemQuantity}</td>
                                            <td class="qty-actual">
                                                <c:choose>
                                                    <c:when test="${not empty d.actualQuantity}">${d.actualQuantity}</c:when>
                                                    <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="col-diff">
                                                <c:if test="${not empty d.actualQuantity}">
                                                    <c:choose>
                                                        <c:when test="${diff == 0}"><span class="diff-zero">0</span></c:when>
                                                        <c:when test="${diff > 0}"><span class="diff-neg">-${diff}</span></c:when>
                                                        <c:otherwise><span class="diff-pos">+${-diff}</span></c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${empty d.actualQuantity}"><span style="color:var(--muted);">—</span></c:if>
                                            </td>
                                            <td><c:out value="${not empty d.notes ? d.notes : '—'}"/></td>
                                            <td>
                                                <button type="button" class="icon-btn toggle-serials"
                                                        data-detail-id="${d.id}"
                                                        title="Xem serials">
                                                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;"><polyline points="6 9 12 15 18 9"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr class="serial-row" data-detail-id="${d.id}">
                                            <td colspan="8" style="padding: 0;">
                                                <div class="serial-container">
                                                    <c:choose>
                                                        <c:when test="${empty serialsByDetail[d.id]}">
                                                            <div class="serial-empty">Không có serial nào.</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <table class="serial-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th style="width:30px;">#</th>
                                                                        <th>Serial</th>
                                                                        <th>Trạng thái</th>
                                                                        <th>Ghi chú</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="s" items="${serialsByDetail[d.id]}" varStatus="sSt">
                                                                        <tr>
                                                                            <td class="col-num">${sSt.index + 1}</td>
                                                                            <td><span class="mono"><c:out value="${s.serialNumber}"/></span></td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when test="${s.status == 'GOOD'}"><span class="status-good">Tốt</span></c:when>
                                                                                    <c:when test="${s.status == 'POOR'}"><span class="status-poor">Kém</span></c:when>
                                                                                    <c:when test="${s.status == 'DAMAGED'}"><span class="status-damaged">Hỏng</span></c:when>
                                                                                    <c:otherwise><span style="color:var(--muted);">—</span></c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td><c:out value="${not empty s.notes ? s.notes : '—'}"/></td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>

                    <c:if test="${not empty logs}">
                        <div class="tab-panel" id="tab-history">
                            <div class="history-list">
                                <c:forEach var="log" items="${logs}">
                                    <div class="history-item">
                                        <div class="history-icon ${log.action == 'CREATE' ? 'create' : log.action == 'UPDATE' ? 'update' : log.action == 'COMPLETE' ? 'complete' : 'create'}">
                                            <c:choose>
                                                <c:when test="${log.action == 'CREATE'}">
                                                    <svg viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></svg>
                                                </c:when>
                                                <c:when test="${log.action == 'UPDATE'}">
                                                    <svg viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                                </c:when>
                                                <c:when test="${log.action == 'COMPLETE'}">
                                                    <svg viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                                </c:when>
                                                <c:otherwise>
                                                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/></svg>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="history-body">
                                            <div class="history-title">
                                                <c:choose>
                                                    <c:when test="${log.action == 'CREATE'}">Tạo phiếu kiểm kê</c:when>
                                                    <c:when test="${log.action == 'UPDATE'}">Cập nhật số lượng</c:when>
                                                    <c:when test="${log.action == 'COMPLETE'}">Hoàn thành kiểm kê</c:when>
                                                    <c:otherwise><c:out value="${log.action}"/></c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty log.username}"> bởi <c:out value="${log.username}"/></c:if>
                                            </div>
                                            <div class="history-meta">${log.createdAt}</div>
                                            <c:if test="${not empty log.details}">
                                                <div style="font-size:12px;color:var(--fg-soft);margin-top:2px;"><c:out value="${log.details}"/></div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </div>

    <div class="modal-host" id="completeModal">
        <div class="modal-card">
            <h3>Hoàn thành kiểm kê</h3>
            <div class="modal-sub">Xác nhận kết thúc phiếu kiểm kê? Hành động này không thể hoàn tác.</div>
            <form method="POST" action="${pageContext.request.contextPath}/inventory-check?action=complete">
                <input type="hidden" name="id" value="${check.id}" />
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="closeModal('completeModal')">Huỷ</button>
                    <button type="submit" class="btn btn-success">Xác nhận hoàn thành</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-host" id="exportModal">
        <div class="modal-card">
            <h3>Trích xuất báo cáo</h3>
            <div class="modal-sub">Chọn khoảng thời gian để xuất báo cáo stock card cho từng máy trong phiếu kiểm kê.</div>
            <c:forEach var="d" items="${details}" varStatus="st">
                <form method="GET" action="${pageContext.request.contextPath}/inventory-check?action=exportReport"
                      class="export-form" style="margin-bottom: ${st.last ? '0' : '12px'}; padding: 12px; background: var(--surface-2); border-radius: var(--radius-sm);">
                    <input type="hidden" name="action" value="exportReport" />
                    <input type="hidden" name="checkId" value="${check.id}" />
                    <input type="hidden" name="detailId" value="${d.id}" />
                    <input type="hidden" name="warehouseId" value="${check.warehouseId}" />
                    <input type="hidden" name="warehouseName" value="<c:out value="${check.warehouseName}"/>" />
                    <div style="font-weight:600;font-size:13px;margin-bottom:8px;"><c:out value="${d.generatorModel}"/></div>
                    <div style="display:flex;gap:8px;align-items:center;">
                        <input type="date" name="fromDate" class="edit-input" style="flex:1;" required max="${today}" />
                        <span>→</span>
                        <input type="date" name="toDate" class="edit-input" style="flex:1;" required max="${today}" />
                        <button type="submit" class="btn btn-primary" style="white-space:nowrap;">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                            Xuất Excel
                        </button>
                    </div>
                </form>
            </c:forEach>
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('exportModal')">Đóng</button>
            </div>
        </div>
    </div>

    <c:if test="${not empty param.openComplete}">
        <script>document.addEventListener('DOMContentLoaded',function(){openModal('completeModal');});</script>
    </c:if>

    <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/inventory-check.js"></script>
</body>
</html>
