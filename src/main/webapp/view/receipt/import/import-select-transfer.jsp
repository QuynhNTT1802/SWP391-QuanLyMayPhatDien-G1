<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Phiếu luân chuyển — Warehouse OS</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/receipt.css">
</head>
<body>
<div class="app">
    <jsp:include page="../../common/admin/aside.jsp"></jsp:include>

    <div>
        <header class="topbar">
            <h1>Phiếu luân chuyển</h1>
            <span class="crumb">/ <a href="${pageContext.request.contextPath}/import-receipt">Phiếu nhập</a> / Chọn phiếu luân chuyển</span>
            <div class="top-actions">
                <jsp:include page="../../common/admin/bell.jsp"/>
                <a class="btn" href="${pageContext.request.contextPath}/import-receipt">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                    Quay lại
                </a>
            </div>
        </header>

        <main>
            <div class="page-head">
                <div class="left">
                    <div class="eyebrow">Kho · Phiếu nhập</div>
                    <h2 class="page-title">Chọn phiếu luân chuyển đã xuất kho</h2>
                    <div class="page-sub">${totalItems} phiếu</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty transfers}">
                    <div style="text-align:center;padding:40px;color:var(--muted);">
                        Không có phiếu luân chuyển nào đã xuất kho.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-card">
                        <table class="users" style="width:100%;table-layout:fixed;">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Kho nguồn</th>
                                    <th>Kho đích</th>
                                    <th>Người tạo</th>
                                    <th>Phiếu xuất</th>
                                    <th>Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${transfers}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/transfers?action=detail&id=${t.transferId}" style="font-family:monospace;text-decoration:none;"><strong style="font-family:monospace;">${t.transferCode}</strong></a></td>
                                        <td>${t.sourceWarehouseName}</td>
                                        <td>${t.destWarehouseName}</td>
                                        <td>${t.createdByName}</td>
                                        <td><span style="font-family:monospace;">${t.exportReceiptCode}</span></td>
                                        <td>
                                            <button type="button" class="btn" style="font-size:12px;padding:4px 10px;" onclick="viewTransferDetail(${t.transferId}, '${t.transferCode}', '${pageContext.request.contextPath}/import-receipt?action=create&exportReceiptId=${t.exportReceiptId}')" title="Xem chi tiết">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="14" height="14"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                Xem chi tiết
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<div class="toast-host" id="toastHost"></div>

<div class="modal-overlay" id="detailModal" style="display:none;">
    <div class="modal-box" style="max-width:700px;">
        <div class="modal-header">
            <h3 id="modalTitle">Chi tiết phiếu luân chuyển</h3>
            <button type="button" class="modal-close" onclick="closeDetailModal()">&times;</button>
        </div>
        <div class="modal-body">
            <div class="table-card" style="border:none;padding:0;">
                <table class="users" id="detailTable">
                    <thead>
                        <tr>
                            <th>Mẫu máy</th>
                            <th>Số seri</th>
                            <th>Số lượng</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody id="detailBody">
                    </tbody>
                </table>
            </div>
            <div class="empty-state" id="detailEmpty" style="display:none;">Không có chi tiết.</div>
        </div>
        <div class="modal-footer">
            <a id="createBtn" href="#" class="btn btn-primary" style="font-size:13px;padding:6px 16px;">Tạo phiếu nhập</a>
            <button type="button" class="btn" onclick="closeDetailModal()">Đóng</button>
        </div>
    </div>
</div>

<script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
<style>
.modal-overlay { position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center; }
.modal-box { background:var(--card-bg,#fff);border-radius:12px;width:90%;max-height:80vh;display:flex;flex-direction:column;box-shadow:0 20px 60px rgba(0,0,0,0.3); }
.modal-header { display:flex;align-items:center;justify-content:space-between;padding:16px 20px;border-bottom:1px solid var(--border,#e5e7eb); }
.modal-header h3 { margin:0;font-size:16px;font-weight:600; }
.modal-close { background:none;border:none;font-size:24px;cursor:pointer;color:var(--muted,#999);padding:0;line-height:1; }
.modal-body { padding:20px;overflow-y:auto;flex:1; }
.modal-footer { display:flex;justify-content:flex-end;gap:8px;padding:12px 20px;border-top:1px solid var(--border,#e5e7eb); }
</style>
<script>
function viewTransferDetail(id, code, createUrl) {
    document.getElementById('modalTitle').textContent = 'Chi tiết phiếu luân chuyển ' + code;
    document.getElementById('createBtn').href = createUrl;
    var tbody = document.getElementById('detailBody');
    tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:var(--muted)">Đang tải...</td></tr>';
    document.getElementById('detailEmpty').style.display = 'none';
    document.getElementById('detailModal').style.display = 'flex';
    fetch(window.APP_CTX + '/import-receipt?action=getTransferDetail&id=' + id)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            tbody.innerHTML = '';
            if (!data || data.length === 0) {
                document.getElementById('detailEmpty').style.display = 'block';
                return;
            }
            data.forEach(function(item) {
                var tr = document.createElement('tr');
                tr.innerHTML = '<td>' + (item.generatorModel || '') + '</td>'
                    + '<td>' + (item.serialNumber || '') + '</td>'
                    + '<td>' + item.quantity + '</td>'
                    + '<td>' + (item.note || '') + '</td>';
                tbody.appendChild(tr);
            });
        })
        .catch(function() {
            tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;padding:20px;color:red;">Lỗi tải dữ liệu.</td></tr>';
        });
}
function closeDetailModal() {
    document.getElementById('detailModal').style.display = 'none';
}
</script>
</body>
</html>
