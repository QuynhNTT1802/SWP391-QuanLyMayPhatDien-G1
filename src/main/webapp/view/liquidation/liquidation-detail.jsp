<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chi tiết thanh lý — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
        .text-center { text-align: center; }
        .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-pending { background: #fef3c7; color: #d97706; }
        .status-revision { background: #fee2e2; color: #dc2626; }
        .status-completed { background: #d1fae5; color: #059669; }
        [data-theme="dark"] .status-pending { background: var(--warn-soft); color: var(--warn); }
        [data-theme="dark"] .status-revision { background: var(--danger-soft); color: var(--danger); }
        [data-theme="dark"] .status-completed { background: var(--accent-soft); color: var(--accent); }
        .hero-avatar { background: oklch(58% 0.16 250); }

        .action-bar-bottom { display: flex; gap: 8px; flex-wrap: wrap; padding: 14px 18px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); margin-top: 16px; position: sticky; bottom: 16px; z-index: 10; box-shadow: 0 -4px 16px rgba(0,0,0,0.08); }
        .btn-warn { background: var(--warn); color: white; border-color: var(--warn); }
        .btn-success { background: var(--accent); color: white; border-color: var(--accent); }
        .btn-danger { background: var(--danger); color: white; border-color: var(--danger); }

        .tabs { display: flex; gap: 2px; border-bottom: 1px solid var(--border); margin-bottom: 18px; }
        .tab { padding: 10px 18px; border: none; background: transparent; color: var(--muted); cursor: pointer; font-size: 13px; font-weight: 600; font-family: var(--font-ui); border-bottom: 2px solid transparent; margin-bottom: -1px; }
        .tab.active { color: var(--fg); border-bottom-color: var(--accent); }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }
        
        .modal-host { position: fixed; inset: 0; background: rgba(0,0,0,0.45); display: none; align-items: center; justify-content: center; z-index: 100; padding: 20px; }
        .modal-host.show { display: flex; }
        .modal-card { background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius); padding: 22px; width: 100%; max-width: 480px; }
        .modal-card h3 { margin: 0 0 4px; font-size: 16px; font-weight: 700; }
        .modal-card select { width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg); color: var(--fg); font-size: 13px; font-family: var(--font-ui); box-sizing: border-box; margin-bottom: 15px; margin-top: 10px; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }
    </style>
</head>
<body>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"></jsp:include>
    <div>
        <header class="topbar">
            <h1>Chi tiết đơn thanh lý</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/liquidations">Thanh lý</a> / <span>${liquidation.liquidationCode}</span></span>
        </header>
        <main>
            <a class="back-link" href="${pageContext.request.contextPath}/liquidations">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                Quay lại danh sách
            </a>



            <c:if test="${not empty liquidation.ceoFeedbackName}">
                <div style="background: var(--danger-soft); border: 1px solid color-mix(in srgb, var(--danger) 25%, transparent); padding: 12px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; color: var(--danger);">
                    Sếp từ chối/yêu cầu sửa: ${liquidation.ceoFeedbackName}
                </div>
            </c:if>
            <c:if test="${not empty liquidation.managerFeedbackName}">
                <div style="background: var(--warn-soft); border: 1px solid color-mix(in srgb, var(--warn) 25%, transparent); padding: 12px 14px; border-radius: var(--radius); margin-bottom: 14px; font-size: 13px; font-weight: 600; color: var(--warn);">
                    Quản lý yêu cầu sửa: ${liquidation.managerFeedbackName}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/liquidations" method="POST" id="mainForm">
                <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />



                <div class="section" style="padding: 18px 22px; margin-bottom: 20px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Thông tin chung</h3>
                    <div class="info-grid">
                        <div class="info-field">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${liquidation.status == 'PENDING_MANAGER'}"><span class="pill" style="color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); background: var(--info-soft);"><span class="pdot" style="background: var(--info);"></span>Chờ Quản lý duyệt</span></c:when>
                                    <c:when test="${liquidation.status == 'PENDING_CEO'}"><span class="pill" style="color: var(--purple); border-color: color-mix(in srgb, var(--purple) 30%, transparent); background: var(--purple-soft);"><span class="pdot" style="background: var(--purple);"></span>Chờ Sếp duyệt</span></c:when>
                                    <c:when test="${liquidation.status == 'APPROVED_BY_CEO'}"><span class="pill" style="color: var(--accent); border-color: color-mix(in srgb, var(--accent) 30%, transparent); background: var(--accent-soft);"><span class="pdot" style="background: var(--accent);"></span>Đã duyệt (Đã xuất)</span></c:when>
                                    <c:when test="${liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT'}"><span class="pill" style="color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); background: var(--warn-soft);"><span class="pdot" style="background: var(--warn);"></span>Bị yêu cầu sửa</span></c:when>
                                    <c:when test="${liquidation.status == 'REJECTED_BY_MANAGER' or liquidation.status == 'REJECTED_BY_CEO'}"><span class="pill" style="color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); background: var(--danger-soft);"><span class="pdot" style="background: var(--danger);"></span>Đã bị hủy</span></c:when>
                                    <c:otherwise><span class="pill" style="color: var(--muted); border-color: color-mix(in srgb, var(--muted) 30%, transparent); background: var(--surface-2);"><span class="pdot" style="background: var(--muted);"></span>${liquidation.status}</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Lý do thanh lý</div>
                            <div class="info-value">${liquidation.reasonName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Người tạo</div>
                            <div class="info-value">${liquidation.createdByName}</div>
                        </div>
                        <div class="info-field">
                            <div class="info-label">Ngày tạo</div>
                            <div class="info-value mono">${liquidation.createdAt}</div>
                        </div>
                    </div>
                </div>

                <div class="section" style="padding: 18px 22px;">
                    <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Danh sách máy phát điện</h3>
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th>Dòng máy</th>
                                    <th>Số Serial</th>
                                    <th>Giá gốc (VNĐ)</th>
                                    <th>Giá thanh lý (VNĐ)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${details}">
                                    <tr>
                                        <td><strong>${d.generatorModelName}</strong></td>
                                        <td class="mono">${d.serialNumber}</td>
                                        <td class="mono">${d.originalPrice}</td>
                                        <td>
                                            <input type="hidden" name="detailId" value="${d.liquidationDetailId}" />
                                            <c:choose>
                                                <c:when test="${liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT'}">
                                                    <input type="number" name="liquidationPrice" value="${d.liquidationPrice}" placeholder="Điền giá đề xuất..." required style="padding: 6px; width: 100%; border: 1px solid var(--border); border-radius: 4px;" />
                                                </c:when>
                                                <c:otherwise>
                                                    <strong class="mono">${d.liquidationPrice}</strong>
                                                    <input type="hidden" name="liquidationPrice" value="${d.liquidationPrice}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${(isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT')) or (isCeo and liquidation.status == 'PENDING_CEO') or (isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT')}">
                        <div class="section" style="padding: 18px 22px; margin-top: 20px;">
                            <h3 style="margin-top: 0; margin-bottom: 16px; font-size: 14px; font-weight: 700; color: var(--muted); text-transform: uppercase;">Xử lý đơn thanh lý</h3>
                            <p style="margin-bottom: 16px; color: var(--muted); font-size: 13px;">Hãy xem kỹ các chi tiết thiết bị và giá đề xuất ở phía trên trước khi ra quyết định.</p>
                            <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                <c:if test="${isStaff and liquidation.status == 'MANAGER_REQUEST_EDIT'}">
                                    <a href="${pageContext.request.contextPath}/liquidations?action=edit_view&id=${liquidation.liquidationId}" class="btn btn-primary">Sửa đơn (Cập nhật lại)</a>
                                </c:if>
                                <c:if test="${isManager and (liquidation.status == 'PENDING_MANAGER' or liquidation.status == 'CEO_REQUEST_EDIT' or liquidation.status == 'MANAGER_REQUEST_EDIT')}">
                                    <button type="submit" name="action" value="approve_manager" class="btn btn-primary">Lưu giá & Gửi sếp duyệt</button>
                                    <button type="button" class="btn btn-warn" onclick="openFeedbackModal('request_edit_manager', 'Quản lý yêu cầu sửa', 'managerFeedbackId', 'btn-warn', 'select_manager_edit')">Yêu cầu sửa</button>
                                    <button type="button" class="btn btn-danger" onclick="openFeedbackModal('reject_manager', 'Từ chối đơn thanh lý', 'managerFeedbackId', 'btn-danger', 'select_manager_reject')">Từ chối (Hủy đơn)</button>
                                </c:if>
                                <c:if test="${isCeo and liquidation.status == 'PENDING_CEO'}">
                                    <button type="submit" name="action" value="approve_ceo" class="btn btn-success" onclick="return confirm('Bạn có chắc chắn muốn duyệt và tạo Phiếu Xuất Kho cho đơn này?');">Duyệt & Xuất Kho</button>
                                    <button type="button" class="btn btn-warn" onclick="openFeedbackModal('request_edit_ceo', 'Sếp yêu cầu sửa', 'ceoFeedbackId', 'btn-warn', 'select_ceo_edit')">Yêu cầu sửa</button>
                                    <button type="button" class="btn btn-danger" onclick="openFeedbackModal('reject_ceo', 'Từ chối đơn thanh lý', 'ceoFeedbackId', 'btn-danger', 'select_ceo_reject')">Từ chối (Hủy đơn)</button>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

            </form>
        </main>
    </div>
</div>

<div class="modal-host" id="feedbackModal">
    <div class="modal-card">
        <h3 id="feedbackModalTitle">Phản hồi</h3>
        <form method="POST" action="${pageContext.request.contextPath}/liquidations">
            <input type="hidden" name="liquidationId" value="${liquidation.liquidationId}" />
            <input type="hidden" name="action" id="feedbackModalAction" value="" />
            
            <select id="select_manager_reject" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_manager_edit" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${managerEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_reject" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoRejectFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            <select id="select_ceo_edit" class="fb-select" style="display:none; width: 100%; padding: 8px; border: 1px solid var(--border); border-radius: 4px; margin-bottom: 16px; margin-top: 16px;">
                <option value="">-- Chọn lý do --</option>
                <c:forEach var="fb" items="${ceoEditFeedbacks}"><option value="${fb.id}">${fb.name}</option></c:forEach>
            </select>
            
            <div class="modal-actions" style="display: flex; justify-content: flex-end; gap: 8px;">
                <button type="button" class="btn" onclick="closeModal('feedbackModal')">Huỷ</button>
                <button type="submit" class="btn" id="feedbackModalSubmit">Xác nhận</button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<script>
    function openFeedbackModal(actionValue, title, paramName, btnClass, selectId) {
        document.getElementById('feedbackModalTitle').innerText = title;
        document.getElementById('feedbackModalAction').value = actionValue;
        document.getElementById('feedbackModalSubmit').className = 'btn ' + btnClass;
        
        document.querySelectorAll('.fb-select').forEach(function(el) {
            el.style.display = 'none';
            el.disabled = true;
            el.removeAttribute('name');
            el.removeAttribute('required');
        });
        
        var activeSelect = document.getElementById(selectId);
        activeSelect.style.display = 'block';
        activeSelect.disabled = false;
        activeSelect.name = paramName;
        activeSelect.required = true;
        
        openModal('feedbackModal');
    }
    function openModal(id) { document.getElementById(id).classList.add('show'); }
    function closeModal(id) { document.getElementById(id).classList.remove('show'); }
    document.querySelectorAll('.modal-host').forEach(function (m) {
        m.addEventListener('click', function (e) { if (e.target === m) m.classList.remove('show'); });
    });
</script>
</body>
</html>
