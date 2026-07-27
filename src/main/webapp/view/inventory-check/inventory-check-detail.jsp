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
                    </div>
            </header>

            <main>
                <div class="header-bar">
                    <div class="left">
                        <a class="back-link" href="${pageContext.request.contextPath}/inventory-check">
                            <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                            Quay lại danh sách
                        </a>
                            <br>
                        <span class="code-tag">
                            <span class="ct-label">Phiếu kiểm kê -</span>
                            <span><c:out value="${check.checkCode}"/></span>
                        </span>
                        <h2 class="page-main-title">
                            #<c:out value="${check.checkCode}"/>
                            <c:choose>
                                <c:when test="${check.status == 'doing'}"><span class="status-pill status-doing"><span class="pdot"></span>Đang kiểm kê</span></c:when>
                                <c:when test="${check.status == 'completed'}"><span class="status-pill status-completed"><span class="pdot"></span>Đã hoàn thành</span></c:when>
                            </c:choose>
                        </h2>
                    </div>
                    <div class="right">
                        <c:if test="${check.status == 'doing'}">
                            <a href="${pageContext.request.contextPath}/inventory-check?action=edit&id=${check.id}" class="btn btn-warn">
                                <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                Nhập số lượng
                            </a>
                            <button type="button" class="btn btn-success" onclick="openModal('completeModal')">
                                <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                Hoàn thành kiểm kê
                            </button>
                        </c:if>
                    </div>
                </div>

                <div class="section">
                    <div class="section-head">
                        <h3>Thông tin chung</h3>
                    </div>
                    <div class="section-body">
                        <div class="form-grid cols-5">
                            <div class="info-field">
                                <label>Mã phiếu kiểm kê</label>
                                <input class="info-input mono" type="text" disabled value="<c:out value='${check.checkCode}'/>">
                            </div>
                            <div class="info-field">
                                <label>Kho kiểm kê</label>
                                <input class="info-input" type="text" disabled value="<c:out value='${check.warehouseName}'/>">
                            </div>
                            <div class="info-field">
                                <label>Người thực hiện</label>
                                <input class="info-input" type="text" disabled value="<c:out value='${check.createdByName}'/>">
                            </div>
                            <div class="info-field">
                                <label>Trạng thái</label>
                                <input class="info-input" type="text" disabled value="${check.status == 'doing' ? 'Đang kiểm kê' : (check.status == 'completed' ? 'Đã hoàn thành' : '')}">
                            </div>
                            <div class="info-field">
                                <label>Tổng mặt hàng</label>
                                <input class="info-input mono" type="text" disabled value="${details.size()} máy">
                            </div>
                        </div>
                        <div class="form-grid cols-5 mt-14">
                            <div class="info-field">
                                <label>Thời gian bắt đầu</label>
                                <input class="info-input mono" type="text" disabled value="${check.startedAt}">
                            </div>
                            <div class="info-field">
                                <label>Thời gian kết thúc</label>
                                <input class="info-input mono" type="text" disabled value="${not empty check.completedAt ? check.completedAt : '—'}">
                            </div>
                            <div class="info-field">
                                <label>Mã ID</label>
                                <input class="info-input mono" type="text" disabled value="#${check.id}">
                            </div>
                            <div class="info-field">
                                <label>Ngày tạo</label>
                                <input class="info-input mono" type="text" disabled value="${check.createdAt}">
                            </div>
                        </div>
                        <c:if test="${not empty check.notes}">
                            <div class="note-section-wrap">
                                <div class="info-label">Ghi chú</div>
                                <div class="note-soft"><c:out value="${check.notes}"/></div>
                            </div>
                        </c:if>

                    </div>
                </div>
                                <c:if test="${check.status == 'completed'}">
                                    <div>
                                        <button type="button" class="btn btn-primary" onclick="openModal('exportModal')">
                                            <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                                            Trích xuất báo cáo
                                        </button>
                                    </div>
                                </c:if>
                            <br>
                <div class="section">
                    <div class="tabs">
                        <button type="button" class="tab active" data-tab="products">Chi tiết kiểm kê</button>
                        <c:if test="${not empty logs}">
                            <button type="button" class="tab" data-tab="history">Lịch sử</button>
                        </c:if>
                    </div>

                    <div class="tab-panel active" id="tab-products">
                    <c:if test="${empty details}">
                        <div>Chưa có dữ liệu kiểm kê.</div>
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
                                    <th class="col-40">#</th>
                                    <th>Mã máy</th>
                                    <th>Thương hiệu</th>
                                    <th>SL sổ sách</th>
                                    <th>SL thực tế</th>
                                    <th>Chênh lệch</th>
                                    <th>Ghi chú</th>
                                    <th class="col-50"></th>
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
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
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
                                                <c:if test="${empty d.actualQuantity}"><span class="text-muted">—</span></c:if>
                                            </td>
                                            <td><c:out value="${not empty d.notes ? d.notes : '—'}"/></td>
                                            <td>
                                                <button type="button" class="icon-btn toggle-serials"
                                                        data-detail-id="${d.id}"
                                                        title="Xem serials">
                                                    <svg viewBox="0 0 24 24" class="icon-collapse"><polyline points="6 9 12 15 18 9"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr class="serial-row" data-detail-id="${d.id}">
                                            <td colspan="8" class="no-padding">
                                                <div class="serial-container">
                                                    <c:choose>
                                                        <c:when test="${empty serialsByDetail[d.id]}">
                                                            <div class="serial-empty">Không có serial nào.</div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <table class="serial-table">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="col-30">#</th>
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
                                                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
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
                                                <div class="history-detail"><c:out value="${log.details}"/></div>
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
            <div class="modal-sub">Chọn khoảng thời gian để xuất báo cáo stock card cho tất cả máy trong phiếu kiểm kê.</div>
            <form method="GET" action="${pageContext.request.contextPath}/inventory-check?action=exportReport" class="export-form export-group">
                <input type="hidden" name="action" value="exportReport" />
                <input type="hidden" name="checkId" value="${check.id}" />
                <input type="hidden" name="warehouseId" value="${check.warehouseId}" />
                <input type="hidden" name="warehouseName" value="<c:out value="${check.warehouseName}"/>" />
                <div class="flex-date-row">
                    <input type="date" name="fromDate" class="edit-input flex-1" required max="${today}" />
                    <span>→</span>
                    <input type="date" name="toDate" class="edit-input flex-1" required max="${today}" />
                    <button type="submit" class="btn btn-primary nowrap">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M7 10l5 5 5-5M12 15V3"/></svg>
                        Xuất Excel
                    </button>
                </div>
            </form>
            <div class="modal-actions mt-12">
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