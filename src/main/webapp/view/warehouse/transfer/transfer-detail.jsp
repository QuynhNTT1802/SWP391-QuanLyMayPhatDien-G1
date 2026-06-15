<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết phiếu luân chuyển — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
    <style>
        a.btn, a.back-link { text-decoration: none; }
        .product-table { width: 100%; border-collapse: collapse; margin-top: 12px; }
        .product-table th, .product-table td { padding: 12px 16px; text-align: left; border-bottom: 1px solid var(--border); }
        .product-table th { font-size: 12px; color: var(--muted); text-transform: uppercase; font-weight: 600; background: var(--surface-2); letter-spacing: 0.04em; }
        .product-table td { font-size: 13px; }
        .product-table tbody tr:hover { background: var(--surface-2); }

        .btn-warn { background: var(--warn); color: white; border-color: var(--warn); }
        .btn-success { background: var(--accent); color: white; border-color: var(--accent); }
        .btn-danger { background: var(--danger); color: white; border-color: var(--danger); }
        .btn-outline-warn { background: transparent; color: var(--warn); border-color: var(--warn); }
        .btn-outline-warn:hover { background: var(--warn-soft); }
        .btn-outline-danger { background: transparent; color: var(--danger); border-color: var(--danger); }
        .btn-outline-danger:hover { background: var(--danger-soft); }

        .tabs { display: flex; gap: 2px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
        .tab { padding: 10px 18px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 13px; font-weight: 600; font-family: var(--font-ui); border-bottom: 2px solid transparent; margin-bottom: -1px; }
        .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
        .modal-host.show { display: flex; }
        .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
        .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
        .modal-card textarea { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; margin-bottom: 15px; margin-top: 10px; resize: vertical; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển ${transfer.transferCode}</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/transfers">Luân chuyển</a> / <span>${transfer.transferCode}</span></span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/transfers">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>

            <c:if test="${empty transfer}">
                <div class="section" style="padding: 18px 22px;">
                    <p style="color: var(--muted); font-size: 14px;">${error != null ? error : 'Không tìm thấy phiếu'}</p>
                </div>
            </c:if>
            <c:if test="${not empty transfer}">
            <c:set var="t" value="${transfer}"/>
            <c:set var="status" value="${t.status}"/>
            <c:set var="isMgrRound1" value="${status == 'PENDING_MANAGER' && empty t.ceoReviewedAt}"/>
            <c:set var="isMgrRound2" value="${status == 'PENDING_MANAGER' && not empty t.ceoReviewedAt}"/>

            <c:if test="${status == 'REJECTED'}">
                <c:if test="${not empty t.managerNote}">
                    <div style="display: flex; gap: 10px; align-items: flex-start; background: var(--danger-soft); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); margin-bottom: 20px; color: var(--danger);">
                        <div>
                            <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Phản hồi từ Quản lý kho</div>
                            <div style="font-size: 13px;">${t.managerNote}</div>
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty t.ceoNote}">
                    <div style="display: flex; gap: 10px; align-items: flex-start; background: var(--danger-soft); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); padding: 14px 16px; border-radius: var(--radius); margin-bottom: 20px; color: var(--danger);">
                        <div>
                            <div style="font-weight: 700; font-size: 14px; margin-bottom: 4px;">Phản hồi từ CEO</div>
                            <div style="font-size: 13px;">${t.ceoNote}</div>
                        </div>
                    </div>
                </c:if>
            </c:if>

            <div class="tabs">
                <button type="button" class="tab active" data-tab="info">Thông tin chi tiết</button>
                <button type="button" class="tab" data-tab="history">Lịch sử xử lý (${totalHistory != null ? totalHistory : 0})</button>
            </div>

            <c:if test="${isOwner && status == 'DRAFT'}">
                <div style="display: flex; gap: 12px; align-items: center; justify-content: space-between; flex-wrap: wrap; background: var(--info-soft); border: 1px solid color-mix(in srgb, var(--info) 25%, transparent); padding: 14px 18px; border-radius: var(--radius); margin-bottom: 18px; color: var(--info);">
                    <div>
                        <div style="font-weight: 700; font-size: 14px; margin-bottom: 2px;">Phiếu đang ở trạng thái Nháp</div>
                        <div style="font-size: 13px; opacity: 0.9;">Bạn có thể chỉnh sửa nội dung hoặc gửi cho Manager duyệt.</div>
                    </div>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                        <a class="btn" href="${pageContext.request.contextPath}/transfers?action=edit_view&id=${t.transferId}">
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                            Sửa phiếu
                        </a>
                        <form method="post" action="${pageContext.request.contextPath}/transfers?action=submit" style="display:inline;">
                            <input type="hidden" name="id" value="${t.transferId}"/>
                            <button type="submit" class="btn btn-primary">
                                <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                                Gửi duyệt (Manager)
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>

            <div id="tab-info" class="tab-panel active">
                <div class="section" style="padding: 18px 22px; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Thông tin chung</h3>
                    <div class="info-grid">
                        <div class="info-field">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${status == 'DRAFT'}"><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>Nháp</span></c:when>
                                    <c:when test="${status == 'PENDING_MANAGER' && isMgrRound1}"><span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ Manager duyệt lần 1</span></c:when>
                                    <c:when test="${status == 'PENDING_MANAGER' && isMgrRound2}"><span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ Manager xác nhận cuối</span></c:when>
                                    <c:when test="${status == 'PENDING_CEO'}"><span class="pill" style="color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft);"><span class="pdot" style="background: var(--purple);"></span>Chờ CEO duyệt</span></c:when>
                                    <c:when test="${status == 'COMPLETED'}"><span class="pill" style="color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft);"><span class="pdot" style="background: var(--accent);"></span>Hoàn tất</span></c:when>
                                    <c:when test="${status == 'REJECTED'}"><span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Bị từ chối</span></c:when>
                                    <c:when test="${status == 'CANCELLED'}"><span class="pill" style="color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft);"><span class="pdot" style="background: var(--warn);"></span>Đã hủy</span></c:when>
                                    <c:otherwise><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>${status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Mã phiếu</div>
                            <div class="info-value mono">${t.transferCode}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Kho nguồn</div>
                            <div class="info-value">${t.sourceWarehouseName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Kho đích</div>
                            <div class="info-value">${t.destWarehouseName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Người tạo</div>
                            <div class="info-value">${t.createdByName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Ngày tạo</div>
                            <div class="info-value mono">
                                 <c:if test="${not empty t.createdAt}"><fmt:formatDate value="${t.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></c:if>
                            </div>
                        </div>
                        <c:if test="${not empty t.executedAt}">
                        <div class="info-field">
                            <div class="info-label">Ngày hoàn tất</div>
                            <div class="info-value mono"><fmt:formatDate value="${t.executedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                        </c:if>
                    </div>
                    <c:if test="${not empty t.note}">
                    <div style="margin-top: 16px;">
                        <div class="info-label">Ghi chú phiếu</div>
                        <div style="padding: 10px 14px; background: var(--surface-2); border: 1px solid var(--border); border-radius: var(--radius-sm); margin-top: 6px; font-size: 13px;">${t.note}</div>
                    </div>
                    </c:if>
                </div>

                <div class="section" style="padding: 18px 22px; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Lịch sử duyệt</h3>
                    <c:choose>
                        <c:when test="${empty t.managerReviewedAt && empty t.ceoReviewedAt && empty t.finalReviewedAt}">
                            <p style="color: var(--muted); font-size: 13px; margin: 0;">Phiếu chưa trải qua bước duyệt nào.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="info-grid">
                                <c:if test="${not empty t.managerReviewedAt}">
                                <div class="info-field">
                                    <div class="info-label">Manager duyệt lần 1</div>
                                    <div class="info-value">
                                        ${t.managerReviewedByName}
                                        <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.managerReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </div>
                                </c:if>
                                <c:if test="${not empty t.ceoReviewedAt}">
                                <div class="info-field">
                                    <div class="info-label">CEO duyệt</div>
                                    <div class="info-value">
                                        ${t.ceoReviewedByName}
                                        <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.ceoReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </div>
                                </c:if>
                                <c:if test="${not empty t.finalReviewedAt}">
                                <div class="info-field">
                                    <div class="info-label">Manager xác nhận cuối</div>
                                    <div class="info-value">
                                        ${t.finalReviewedByName}
                                        <span class="mono" style="color: var(--muted); font-size: 12px;">lúc <fmt:formatDate value="${t.finalReviewedAtAsDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                                    </div>
                                </div>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="section" style="padding: 18px 22px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Danh sách máy phát điện (${empty t.details ? 0 : t.details.size()} dòng)</h3>
                    <table class="product-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Dòng máy</th>
                                <th>Số lượng</th>
                                <th>Số Serial</th>
                                <th>Ghi chú</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty t.details}">
                                    <tr><td colspan="5" style="text-align: center; color: var(--muted); padding: 24px;">Chưa có chi tiết</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="d" items="${t.details}" varStatus="st">
                                    <tr>
                                        <td>${st.count}</td>
                                        <td><strong>${d.generatorModel}</strong></td>
                                        <td class="mono">${d.quantity}</td>
                                        <td class="mono">${d.serialNumber != null ? d.serialNumber : '—'}</td>
                                        <td>${d.note != null ? d.note : '—'}</td>
                                    </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${status == 'DRAFT' || status == 'PENDING_MANAGER' || status == 'PENDING_CEO'}">
                <div class="section" style="padding: 18px 22px; margin-top: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 12px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Xử lý phiếu luân chuyển</h3>
                    <p style="margin-bottom: 16px; color: var(--muted); font-size: 13px;">Hãy kiểm tra kỹ thông tin kho nguồn/đích và danh sách máy ở phía trên trước khi ra quyết định.</p>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                        <c:if test="${isOwner && status == 'DRAFT'}">
                            <a class="btn" href="${pageContext.request.contextPath}/transfers?action=edit_view&id=${t.transferId}">Sửa phiếu</a>
                            <form method="post" action="${pageContext.request.contextPath}/transfers?action=submit" style="display:inline;">
                                <input type="hidden" name="id" value="${t.transferId}"/>
                                <button type="submit" class="btn btn-primary">Gửi duyệt (Manager)</button>
                            </form>
                        </c:if>

                        <c:if test="${isOwner && (status == 'DRAFT' || isMgrRound1)}">
                            <form method="post" action="${pageContext.request.contextPath}/transfers?action=cancel" style="display:inline;" onsubmit="return confirm('Hủy phiếu này?');">
                                <input type="hidden" name="id" value="${t.transferId}"/>
                                <button type="submit" class="btn btn-outline-warn">Hủy phiếu</button>
                            </form>
                        </c:if>

                        <c:if test="${isMgrRound1}">
                            <form method="post" action="${pageContext.request.contextPath}/transfers?action=approve_manager" style="display:inline;">
                                <input type="hidden" name="id" value="${t.transferId}"/>
                                <button type="submit" class="btn btn-primary" onclick="return confirm('Duyệt phiếu và chuyển CEO?');">Duyệt → CEO</button>
                            </form>
                            <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('reject_manager', 'Từ chối phiếu (Manager)', 'managerNote')">Từ chối</button>
                        </c:if>

                        <c:if test="${isMgrRound2}">
                            <form method="post" action="${pageContext.request.contextPath}/transfers?action=final_approve" style="display:inline;">
                                <input type="hidden" name="id" value="${t.transferId}"/>
                                <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận cuối và THỰC HIỆN chuyển kho?');">Xác nhận cuối &amp; Chuyển kho</button>
                            </form>
                            <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('final_reject', 'Từ chối xác nhận cuối', 'managerNote')">Từ chối (Hủy phiếu)</button>
                        </c:if>

                        <c:if test="${status == 'PENDING_CEO'}">
                            <form method="post" action="${pageContext.request.contextPath}/transfers?action=approve_ceo" style="display:inline;">
                                <input type="hidden" name="id" value="${t.transferId}"/>
                                <button type="submit" class="btn btn-primary" onclick="return confirm('Duyệt phiếu và trả về Manager xác nhận cuối?');">Duyệt → Manager</button>
                            </form>
                            <button type="button" class="btn btn-outline-danger" onclick="openRejectModal('reject_ceo', 'Từ chối phiếu (CEO)', 'ceoNote')">Từ chối</button>
                        </c:if>
                    </div>
                </div>
                </c:if>
            </div>

            <div id="tab-history" class="tab-panel">
                <div class="section" style="padding: 18px 22px;">
                    <c:if test="${empty transferHistory}">
                        <p style="color: var(--muted); font-size: 13px; text-align: center; padding: 20px 0;">Chưa có lịch sử hoạt động.</p>
                    </c:if>
                    <c:if test="${not empty transferHistory}">
                        <div style="display: flex; flex-direction: column; gap: 16px; margin-top: 8px;">
                            <c:forEach var="log" items="${transferHistory}">
                                <div style="display: flex; gap: 12px;">
                                    <div style="display: flex; flex-direction: column; align-items: center; width: 24px; flex-shrink: 0;">
                                        <div style="width: 10px; height: 10px; border-radius: 50%; background: var(--accent); margin-top: 4px;"></div>
                                        <div style="flex: 1; width: 2px; background: var(--border); margin-top: 4px;"></div>
                                    </div>
                                    <div style="padding-bottom: 16px;">
                                        <div style="font-size: 13px; color: var(--muted); margin-bottom: 2px;">
                                            <fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm" /> - <strong>${log.action}</strong>
                                            (bởi <b>${log.username}</b> - #${log.userId})
                                        </div>
                                        <div style="font-size: 14px; color: var(--fg); line-height: 1.5;">${log.details}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </div>
            </c:if>
        </main>
    </div>
</div>

<div class="modal-host" id="rejectModal">
    <div class="modal-card">
        <h3 id="rejectModalTitle">Từ chối</h3>
        <form method="POST" action="${pageContext.request.contextPath}/transfers" id="rejectForm">
            <input type="hidden" name="id" value="${transfer.transferId}" />
            <input type="hidden" name="action" id="rejectFormAction" value="" />
            <textarea name="REPLACE_NOTE" id="rejectFormNote" required maxlength="500" rows="4" placeholder="Nhập lý do từ chối..."></textarea>
            <div class="modal-actions">
                <button type="button" class="btn" onclick="closeModal('rejectModal')">Huỷ</button>
                <button type="submit" class="btn btn-danger" id="rejectFormSubmit">Xác nhận từ chối</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function switchTab(tabId) {
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.tab').forEach(function(t) { t.classList.remove('active'); });
        var panel = document.getElementById('tab-' + tabId);
        if (panel) panel.classList.add('active');
        document.querySelectorAll('.tab').forEach(function(t) {
            if (t.getAttribute('data-tab') === tabId) t.classList.add('active');
        });
    }

    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }

    function openRejectModal(action, title, noteFieldName) {
        document.getElementById('rejectModalTitle').innerText = title;
        document.getElementById('rejectFormAction').value = action;
        var ta = document.getElementById('rejectFormNote');
        ta.value = '';
        ta.setAttribute('name', noteFieldName);
        openModal('rejectModal');
    }

    document.querySelectorAll('.tab').forEach(function (btn) {
        btn.addEventListener('click', function () {
            var tabId = this.getAttribute('data-tab');
            if (tabId) switchTab(tabId);
        });
    });

    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
</script>
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
<div class="toast-host" id="toastHost"></div>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
</body>
</html>
