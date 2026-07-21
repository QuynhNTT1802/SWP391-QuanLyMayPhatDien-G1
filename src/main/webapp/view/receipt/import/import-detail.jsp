<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết phiếu nhập - Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/purchase-detail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết phiếu nhập</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / <span><c:out value="${receipt.receiptCode}"/></span></span>
                    <div class="top-actions">
                        <jsp:include page="../../common/admin/bell.jsp"/>
                        <button class="icon-btn theme-toggle" id="themeToggle"><svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg><svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg></button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty error}">
                        <div class="alert alert-error">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${error}"/></span>
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${receipt.status == 'PENDING'}">
                            <c:set var="statusLabel" value="Chờ duyệt"/>
                        </c:when>
                        <c:when test="${receipt.status == 'COMPLETED'}">
                            <c:set var="statusLabel" value="Hoàn thành"/>
                        </c:when>
                        <c:when test="${receipt.status == 'CANCELLED'}">
                            <c:set var="statusLabel" value="Đã từ chối"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="statusLabel" value="${receipt.status}"/>
                        </c:otherwise>
                    </c:choose>

                    <div class="header-bar">
                        <div class="left">
                            <a class="back-link" href="${pageContext.request.contextPath}/import-receipt">
                                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                Quay lại danh sách
                            </a>
                            <span class="code-tag">
                                <span class="ct-label">Phiếu nhập -</span>
                                <span><c:out value="${receipt.receiptCode}"/></span>
                            </span>
                            <h2 class="page-main-title">
                                #<c:out value="${receipt.receiptCode}"/>
                                <span class="status-pill ${receipt.status == 'PENDING' ? 'status-pending' : receipt.status == 'COMPLETED' ? 'status-completed' : receipt.status == 'CANCELLED' ? 'status-cancelled' : 'status-draft'}">
                                    <span class="pdot"></span>${statusLabel}
                                </span>
                            </h2>
                        </div>
                        <div class="right">
                            <c:if test="${receipt.status == 'PENDING' and isManager}">
                                <button type="button" class="btn btn-primary" onclick="openModal('approveModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                                    Duyệt phiếu
                                </button>
                                <button type="button" class="btn btn-danger" onclick="openModal('rejectModal')">
                                    <svg class="icon" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                    Từ chối
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
                                    <label>Loại phiếu</label>
                                    <input class="info-input" type="text" disabled value="Nhập kho">
                                </div>
                                <div class="info-field">
                                    <label>Mã phiếu</label>
                                    <input class="info-input mono" type="text" disabled value="<c:out value='${receipt.receiptCode}'/>">
                                </div>
                                <div class="info-field">
                                    <label>Kho nhập</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${receipt.warehouseName}'/>">
                                </div>
                                <c:if test="${not empty receipt.purchaseOrderCode}">
                                    <div class="info-field">
                                        <label>Phiếu mua nguồn</label>
                                        <input class="info-input mono" type="text" disabled value="<c:out value='${receipt.purchaseOrderCode}'/>">
                                    </div>
                                </c:if>
                                <div class="info-field">
                                    <label>Người tạo</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${receipt.createdByName}'/>">
                                </div>
                            </div>
                            <div class="form-grid cols-5" style="margin-top: 14px;">
                                <div class="info-field">
                                    <label>Ngày tạo</label>
                                    <input class="info-input mono" type="text" disabled value="${receipt.createdAt}">
                                </div>
                                <div class="info-field">
                                    <label>Người duyệt</label>
                                    <input class="info-input" type="text" disabled value="${not empty receipt.approvedByName ? receipt.approvedByName : '—'}">
                                </div>
                                <div class="info-field">
                                    <label>Ngày duyệt</label>
                                    <input class="info-input mono" type="text" disabled value="${not empty receipt.approvedAt ? receipt.approvedAt : '—'}">
                                </div>
                                <c:if test="${not empty receipt.reasonName}">
                                    <div class="info-field">
                                        <label>Lý do</label>
                                        <input class="info-input" type="text" disabled value="${receipt.reasonName}${not empty receipt.reasonNote ? ' · ' : ''}${not empty receipt.reasonNote ? receipt.reasonNote : ''}">
                                    </div>
                                </c:if>
                                <div class="info-field">
                                    <label>Trạng thái</label>
                                    <input class="info-input" type="text" disabled value="<c:out value='${statusLabel}'/>">
                                </div>
                            </div>
                            <c:if test="${not empty receipt.purchaseOrderCode}">
                                <div style="margin-top: 14px;">
                                    <a class="code-link" href="${pageContext.request.contextPath}/purchase-order?action=detail&id=${receipt.purchaseOrderId}">Xem phiếu mua <c:out value="${receipt.purchaseOrderCode}"/> →</a>
                                </div>
                            </c:if>
                            <c:if test="${not empty receipt.note}">
                                <div style="margin-top: 18px;">
                                    <div class="info-label" style="font-size:11px;color:var(--muted);font-weight:700;text-transform:uppercase;letter-spacing:0.04em;margin-bottom:6px;">Ghi chú</div>
                                    <div class="note-soft"><c:out value="${receipt.note}"/></div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="section" style="margin-top: 18px;">
                        <div class="tabs" style="margin-bottom: 16px;">
                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}" class="tab ${empty currentTab or currentTab == 'info' ? 'active' : ''}">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                                Thông tin các máy
                            </a>
                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="tab ${currentTab == 'history' ? 'active' : ''}">
                                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                Lịch sử cập nhật
                                <c:if test="${not empty totalLogs and totalLogs > 0}"><span class="tab-badge">${totalLogs}</span></c:if>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${currentTab == 'history'}">
                                <div class="table-card history-card">
                                    <form method="get" action="${pageContext.request.contextPath}/import-receipt" class="history-filter-bar">
                                        <input type="hidden" name="action" value="detail"/>
                                        <input type="hidden" name="id" value="${receipt.receiptId}"/>
                                        <input type="hidden" name="tab" value="history"/>
                                        <input type="hidden" name="page" value="1"/>

                                        <div class="search-input hf-search">
                                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                            <input name="logSearch" value="${logSearch}" placeholder="Tìm người dùng, chi tiết..." autocomplete="off"/>
                                        </div>
                                        <select name="logAction" class="filter-select">
                                            <option value="" ${empty logAction ? 'selected' : ''}>Tất cả hành động</option>
                                            <option value="CREATE" ${logAction == 'CREATE' ? 'selected' : ''}>Tạo phiếu</option>
                                            <option value="UPDATE" ${logAction == 'UPDATE' ? 'selected' : ''}>Cập nhật</option>
                                            <option value="APPROVE" ${logAction == 'APPROVE' ? 'selected' : ''}>Duyệt</option>
                                            <option value="REJECT" ${logAction == 'REJECT' ? 'selected' : ''}>Từ chối</option>
                                            <option value="REVISION" ${logAction == 'REVISION' ? 'selected' : ''}>Yêu cầu sửa</option>
                                        </select>
                                        <div class="date-range">
                                            <label class="date-label">Từ</label>
                                            <input type="date" name="dateFrom" value="${dateFrom}" class="date-input"/>
                                            <label class="date-label">đến</label>
                                            <input type="date" name="dateTo"   value="${dateTo}"   class="date-input"/>
                                        </div>
                                        <button type="submit" class="btn btn-primary">
                                            <svg class="icon" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m21 21-4.3-4.3"/></svg>
                                        Áp dụng
                                        </button>
                                        <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history" class="btn">
                                                <svg class="icon" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>
                                            Xóa lọc
                                            </a>
                                        </c:if>
                                    </form>

                                    <div class="result-summary">
                                    Tìm thấy <strong>${totalLogs}</strong> bản ghi
                                        <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                        &nbsp;·&nbsp;<span class="filter-active-badge">Bộ lọc đang hoạt động</span>
                                        </c:if>
                                    </div>

                                    <table>
                                        <thead><tr>
                                            <th style="width:150px;">Thời gian</th>
                                            <th style="width:180px;">Người thực hiện</th>
                                            <th style="width:160px;">Hành động</th>
                                            <th>Chi tiết thay đổi</th>
                                        </tr></thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${empty logList}">
                                                <tr><td colspan="4">
                                                    <div class="empty-state">
                                                        <div class="icon-wrap">
                                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                        </div>
                                            <strong>Không có bản ghi nào</strong>
                                                        <c:if test="${not empty logSearch or not empty logAction or not empty dateFrom or not empty dateTo}">
                                            <span style="color:var(--muted);font-size:0.88rem;">Thử điều chỉnh bộ lọc hoặc <a href="${pageContext.request.contextPath}/import-receipt?action=detail&id=${receipt.receiptId}&amp;tab=history">xóa lọc</a></span>
                                                        </c:if>
                                                    </div>
                                                </td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="log" items="${logList}">
                                                    <tr>
                                                        <td style="font-family:var(--font-mono);"><fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                        <td>
                                                            <div style="font-weight:600;color:var(--fg);"><c:out value="${log.username}"/></div>
                                                        </td>
                                                        <td>
                                                            <span class="action-badge action-<c:choose>
                                                                <c:when test="${log.action == 'CREATE'}">create</c:when>
                                                                <c:when test="${log.action == 'UPDATE'}">update</c:when>
                                                                <c:when test="${log.action == 'APPROVE'}">approve</c:when>
                                                                <c:when test="${log.action == 'REJECT'}">reject</c:when>
                                                                <c:when test="${log.action == 'REVISION'}">revision</c:when>
                                                                <c:otherwise>default</c:otherwise>
                                                            </c:choose>">
                                                            <c:choose>
    <c:when test="${log.action == 'CREATE'}">Tạo phiếu</c:when>
    <c:when test="${log.action == 'UPDATE'}">Cập nhật</c:when>
    <c:when test="${log.action == 'APPROVE'}">Duyệt</c:when>
    <c:when test="${log.action == 'REJECT'}">Từ chối</c:when>
    <c:when test="${log.action == 'REVISION'}">Yêu cầu sửa</c:when>
                                                                <c:otherwise>${log.action}</c:otherwise>
                                                            </c:choose></span>
                                                        </td>
                                                        <td style="max-width:380px;color:var(--muted);font-size:0.9rem;line-height:1.5;">
                                                            <c:out value="${log.details}"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>

                                    <c:if test="${logTotalPages > 1}">
                                    <div class="pagination">
                                        <div class="info">Hiển thị <strong>${(logPage-1)*20 + 1}</strong>–<strong>${logPage*20 > totalLogs ? totalLogs : logPage*20}</strong> / <strong>${totalLogs}</strong> bản ghi</div>
                                        <div class="controls">
                                            <c:if test="${logPage > 1}">
                                                <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage - 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&lsaquo;</a>
                                            </c:if>
                                            <c:forEach begin="1" end="${logTotalPages}" var="p">
                                                <c:choose>
                                                    <c:when test="${p == logPage}"><span class="page-btn active">${p}</span></c:when>
                                                    <c:otherwise><a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${p}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">${p}</a></c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                            <c:if test="${logPage < logTotalPages}">
                                                <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;tab=history&amp;page=${logPage + 1}<c:if test="${not empty logSearch}">&amp;logSearch=<c:out value="${logSearch}"/></c:if><c:if test="${not empty logAction}">&amp;logAction=${logAction}</c:if><c:if test="${not empty dateFrom}">&amp;dateFrom=${dateFrom}</c:if><c:if test="${not empty dateTo}">&amp;dateTo=${dateTo}</c:if>" class="page-btn">&rsaquo;</a>
                                            </c:if>
                                        </div>
                                    </div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="section-head" style="margin-top: 0;">
                                    <h3>Danh sách máy phát điện (<strong>${totalDetails}</strong> dòng)</h3>
                                </div>
                                <table class="product-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                        <th>Mã máy phát</th>
                                        <th>Máy phát</th>
                                        <th>Hãng</th>
                                            <th>Serial</th>
                                        <th>Tình trạng</th>
                                        <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty pagedDetails}">
<tr><td colspan="7" class="text-center" style="padding: 24px; color: var(--muted);">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${pagedDetails}" varStatus="st">
                                                    <tr>
                                                        <td class="mono">${(detailPage - 1) * 10 + st.index + 1}</td>
                                                        <td><a href="javascript:void(0);" class="code-link gen-link" style="font-family:var(--font-mono);"
                                                               onclick="showGeneratorModal(this)"
                                                               data-gen-id="${d.generatorId}"
                                                               data-gen-model="<c:out value='${d.generatorModel}'/>"
                                                               data-gen-power="<c:out value='${d.generatorPower}'/>"
                                                               data-gen-freq="<c:out value='${d.generatorFreq}'/>"
                                                               data-gen-weight="<c:out value='${d.generatorWeight}'/>"
                                                               data-gen-status="<c:out value='${d.generatorStatus}'/>"><c:out value="${d.generatorModel}"/></a></td>
                                                        <td><strong><c:out value="${not empty d.generatorName ? d.generatorName : d.generatorModel}"/></strong></td>
                                                        <td><span style="color: var(--muted);"><c:out value="${d.generatorBrand}"/></span></td>
                                                        <td style="font-family:var(--font-mono);"><c:out value="${d.serialNumber}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${d.condition == 'GOOD'}"><span class="cond-badge cond-good">Tốt</span></c:when>
    <c:when test="${d.condition == 'POOR'}"><span class="cond-badge cond-poor">Kém</span></c:when>
                                                                <c:when test="${d.condition == 'DAMAGED'}"><span class="cond-badge cond-damaged">Hỏng</span></c:when>
     <c:otherwise><span class="cond-badge cond-none">Chưa kiểm kê</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td><c:out value="${d.note}"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>

                                <c:if test="${detailTotalPages > 1}">
                                <div class="pagination" style="margin-top: 16px;">
                                    <div class="info">Hiển thị <strong>${(detailPage-1)*10 + 1}</strong>–<strong>${detailPage*10 > totalDetails ? totalDetails : detailPage*10}</strong> / <strong>${totalDetails}</strong> bản ghi</div>
                                    <div class="controls">
                                        <c:if test="${detailPage > 1}">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;detailPage=${detailPage - 1}" class="page-btn">&lsaquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${detailTotalPages}" var="p">
                                            <c:choose>
                                                <c:when test="${p == detailPage}"><span class="page-btn active">${p}</span></c:when>
                                                <c:otherwise><a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;detailPage=${p}" class="page-btn">${p}</a></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${detailPage < detailTotalPages}">
                                            <a href="${pageContext.request.contextPath}/import-receipt?action=detail&amp;id=${receipt.receiptId}&amp;detailPage=${detailPage + 1}" class="page-btn">&rsaquo;</a>
                                        </c:if>
                                    </div>
                                </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>
            </div>
        </div>

        <c:if test="${receipt.status == 'PENDING' and isManager}">
            <div class="modal-host" id="approveModal">
                <div class="modal-card">
                    <h3>Duyệt phiếu nhập</h3>
                    <div class="modal-sub">Phiếu nhập sẽ chuyển sang trạng thái "Hoàn thành" và cập nhật tồn kho.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/import-receipt?action=approve">
                        <input type="hidden" name="id" value="${receipt.receiptId}"/>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('approveModal')">Đóng</button>
                            <button type="submit" class="btn btn-primary">Xác nhận duyệt</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal-host" id="rejectModal">
                <div class="modal-card">
                    <h3>Từ chối phiếu nhập</h3>
                    <div class="modal-sub">Phiếu nhập sẽ bị từ chối. Hành động này không thể hoàn tác.</div>
                    <form method="POST" action="${pageContext.request.contextPath}/import-receipt?action=reject">
                        <input type="hidden" name="id" value="${receipt.receiptId}"/>
                        <label for="rejectReason">Mô tả chi tiết lý do từ chối <span style="color:var(--danger)">*</span></label>
                        <textarea id="rejectReason" name="reason" required placeholder="Ví dụ: Sai số lượng, sai serial, không khớp phiếu mua..." style="margin-top:8px;"></textarea>
                        <div class="modal-actions">
                            <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                            <button type="submit" class="btn btn-danger">Xác nhận từ chối</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <style>
            .gen-modal-backdrop { position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:1000; display:none; align-items:center; justify-content:center; padding:20px; }
            .gen-modal-backdrop.open { display:flex; }
            .gen-modal { background:var(--surface); border-radius:8px; width:100%; max-width:480px; box-shadow:0 10px 40px rgba(0,0,0,.25); overflow:hidden; animation:modalPop .18s ease-out; }
            @keyframes modalPop { from{transform:scale(.96);opacity:0} to{transform:scale(1);opacity:1} }
            .gen-modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 18px; border-bottom:1px solid var(--border); }
            .gen-modal-header h3 { margin:0; font-size:16px; font-weight:700; }
            .gen-modal-close { background:transparent; border:none; font-size:22px; line-height:1; cursor:pointer; color:var(--muted); padding:0 4px; }
            .gen-modal-close:hover { color:var(--fg); }
            .gen-modal-body { padding:16px 18px; }
            .gen-info-row { display:flex; gap:10px; padding:8px 0; border-bottom:1px dashed var(--border); font-size:13.5px; }
            .gen-info-row:last-child { border-bottom:none; }
            .gen-info-row .lbl { flex:0 0 110px; color:var(--muted); font-weight:500; }
            .gen-info-row .val { flex:1; color:var(--fg); word-break:break-word; }
            .gen-modal-footer { padding:12px 18px; border-top:1px solid var(--border); display:flex; justify-content:flex-end; gap:8px; background:var(--surface-2); }
            .gen-link { color:var(--accent); text-decoration:none; cursor:pointer; font-weight:600; }
            .gen-link:hover { text-decoration:underline; color:var(--accent-hover); }
        </style>

        <div class="gen-modal-backdrop" id="generatorModal" onclick="if (event.target === this) closeGeneratorModal();">
            <div class="gen-modal" role="dialog" aria-modal="true" aria-labelledby="generatorModalTitle">
                <div class="gen-modal-header">
                    <h3 id="generatorModalTitle">Thông tin máy phát</h3>
                    <button type="button" class="gen-modal-close" onclick="closeGeneratorModal()" aria-label="Đóng">&times;</button>
                </div>
                <div class="gen-modal-body">
                    <div class="gen-info-row">
                        <div class="lbl">Mã máy phát</div>
                        <div class="val" id="gm-id">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Model</div>
                        <div class="val" id="gm-model">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Công suất</div>
                        <div class="val" id="gm-power">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Tần số</div>
                        <div class="val" id="gm-freq">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Trọng lượng</div>
                        <div class="val" id="gm-weight">—</div>
                    </div>
                    <div class="gen-info-row">
                        <div class="lbl">Trạng thái</div>
                        <div class="val" id="gm-status">—</div>
                    </div>
                </div>
                <div class="gen-modal-footer">
                    <button type="button" class="btn" onclick="closeGeneratorModal()">Đóng</button>
                    <a href="#" class="btn btn-primary" id="gm-detail-link">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                        Xem chi tiết
                    </a>
                </div>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
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
        <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
        <script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/purchase-detail-modal.js"></script>
        <script>
            function showGeneratorModal(el) {
                event.stopPropagation();
                var id = el.getAttribute('data-gen-id') || '';
                var model = el.getAttribute('data-gen-model') || '—';
                var power = el.getAttribute('data-gen-power') || '—';
                var freq = el.getAttribute('data-gen-freq') || '—';
                var weight = el.getAttribute('data-gen-weight') || '—';
                var status = el.getAttribute('data-gen-status') || '—';

                document.getElementById('gm-id').textContent = id || '—';
                document.getElementById('gm-model').textContent = model;
                document.getElementById('gm-power').textContent = power ? power + ' kVA' : '—';
                document.getElementById('gm-freq').textContent = freq ? freq + ' Hz' : '—';
                document.getElementById('gm-weight').textContent = weight ? weight + ' kg' : '—';
                var statusText = status === 'active' ? 'Đang hoạt động' : (status === 'locked' ? 'Bị khóa' : status || '—');
                document.getElementById('gm-status').textContent = statusText;
                document.getElementById('gm-detail-link').href = window.APP_CTX + '/warehouse/generators?action=view&id=' + id;

                document.getElementById('generatorModal').classList.add('open');
            }
            function closeGeneratorModal() {
                document.getElementById('generatorModal').classList.remove('open');
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') {
                    closeGeneratorModal();
                }
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                if (window.SESSION_DATA && window.SESSION_DATA.message) {
                    if (typeof showToast === 'function') {
                        showToast(window.SESSION_DATA.message, window.SESSION_DATA.type || 'info');
                    }
                }
            });
        </script>
    </body>
</html>
