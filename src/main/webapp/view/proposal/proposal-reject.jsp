<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    java.time.format.DateTimeFormatter __propFmt =
        java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Từ chối đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
        <style>
            .table-card { overflow-x: auto; -webkit-overflow-scrolling: touch; }
            .order-code { font-family: 'JetBrains Mono', monospace; font-size: 13px; color: var(--muted); }
            .col-num { width: 36px; text-align: center; color: var(--muted); font-weight: 600; }
            .col-qty { width: 100px; text-align: center; }
            .col-brand { width: 140px; }
            .col-del { width: 40px; text-align: center; }
            .detail-table { width: 100%; border-collapse: collapse; margin-top: 8px; }
            .detail-table th { text-align: left; padding: 8px 10px; font-size: 12px; font-weight: 600; color: var(--muted); border-bottom: 1px solid var(--border); text-transform: uppercase; letter-spacing: 0.5px; }
            .detail-table td { padding: 8px 6px; vertical-align: top; font-size: 13px; }
            .reject-card { max-width: 720px; margin: 0 auto; }
            .alert-warn { padding: 12px 16px; border-radius: 8px; background: #fff3cd; color: #856404; border: 1px solid #ffe69c; display: flex; gap: 10px; align-items: flex-start; margin: 16px 0; }
            .alert-warn svg { flex-shrink: 0; margin-top: 2px; }
            .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px 24px; padding: 16px; background: var(--surface-2); border-radius: 8px; margin: 12px 0; }
            .info-item .lbl { font-size: 11px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; margin-bottom: 4px; }
            .info-item .val { font-size: 13.5px; color: var(--fg); }
            .status-pill { display: inline-flex; align-items: center; gap: 6px; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; background: #fff3cd; color: #856404; }
            .status-pill .pdot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; opacity: 0.55; }
            .form-section { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 18px 20px; margin-bottom: 18px; }
            .form-section-head { display: flex; align-items: baseline; gap: 10px; margin-bottom: 14px; }
            .form-section-num { font-size: 11px; font-weight: 700; color: var(--accent); letter-spacing: 0.08em; }
            .form-section-title { font-size: 16px; font-weight: 700; margin: 0; }
            textarea.input { min-height: 110px; resize: vertical; font-family: inherit; }
            .btn-danger { background: #dc3545; color: #fff; border: 1px solid #dc3545; }
            .btn-danger:hover { background: #c82333; border-color: #bd2130; }
            .back-link { display: inline-flex; align-items: center; gap: 6px; color: var(--muted); text-decoration: none; font-size: 13px; margin-bottom: 12px; }
            .back-link:hover { color: var(--accent); }
            .footer-actions { display: flex; gap: 10px; justify-content: flex-end; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Từ chối đề xuất</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <a href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}"><c:out value="${proposal.proposalCode}"/></a> / Từ chối</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <a class="back-link" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                        Quay lại chi tiết
                    </a>

                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Kinh doanh · Từ chối đề xuất</div>
                            <h2 class="page-title">Từ chối phiếu đề xuất nhập kho</h2>
                            <div class="page-sub">
                                Phiếu <c:out value="${proposal.proposalCode}"/> ·
                                <span class="status-pill" style="margin-left:6px;"><span class="pdot"></span>Chờ duyệt</span>
                            </div>
                        </div>
                    </div>

                    <div class="reject-card">

                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">01 — THÔNG TIN PHIẾU</div>
                                <h3 class="form-section-title">Chi tiết đề xuất</h3>
                            </div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="lbl">Mã phiếu</div>
                                    <div class="val order-code"><c:out value="${proposal.proposalCode}"/></div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Người tạo</div>
                                    <div class="val"><c:out value="${proposal.createdByName}"/></div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Ngày tạo</div>
                                    <div class="val">
                                        <c:choose>
                                            <c:when test="${proposal.proposalDate == null}">—</c:when>
                                            <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="lbl">Kho nhập</div>
                                    <div class="val"><c:out value="${proposal.warehouseName}"/></div>
                                </div>
                                <div class="info-item" style="grid-column: span 2;">
                                    <div class="lbl">Ghi chú của nhân viên</div>
                                    <div class="val">
                                        <c:choose>
                                            <c:when test="${empty proposal.note}"><span style="color:var(--muted);">—</span></c:when>
                                            <c:otherwise><c:out value="${proposal.note}"/></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-section">
                            <div class="form-section-head">
                                <div class="form-section-num">02 — DANH SÁCH MÁY ĐỀ XUẤT</div>
                                <h3 class="form-section-title">Chi tiết máy phát điện</h3>
                            </div>
                            <div class="table-card">
                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th class="col-num">#</th>
                                            <th>Mã máy</th>
                                            <th>Tên máy</th>
                                            <th class="col-brand">Thương hiệu</th>
                                            <th class="col-qty">Số lượng</th>
                                            <th class="col-qty">Tồn kho HT</th>
                                            <th>Ghi chú dòng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty proposal.details}">
                                                <tr><td colspan="7" style="text-align:center;padding:18px;color:var(--muted);">Không có dòng chi tiết nào.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                                    <tr>
                                                        <td class="col-num">${st.count}</td>
                                                        <td class="order-code"><c:out value="${d.generatorCode}"/></td>
                                                        <td><c:out value="${d.generatorName}"/></td>
                                                        <td class="col-brand"><c:out value="${d.brandName}"/></td>
                                                        <td class="col-qty"><c:out value="${d.quantity}"/></td>
                                                        <td class="col-qty"><c:out value="${d.currentStock}"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty d.note}"><span style="color:var(--muted);">—</span></c:when>
                                                                <c:otherwise><c:out value="${d.note}"/></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <form class="form-section" method="post" action="${pageContext.request.contextPath}/proposal?action=reject" onsubmit="return validateRejectForm();">
                            <div class="form-section-head">
                                <div class="form-section-num">03 — LÝ DO TỪ CHỐI</div>
                                <h3 class="form-section-title">Vui lòng nhập lý do</h3>
                            </div>

                            <div class="alert-warn">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                                <div>
                                    <strong>Hành động này không thể hoàn tác.</strong> Phiếu sẽ chuyển sang trạng thái "Từ chối" và nhân viên tạo phiếu sẽ nhận được thông báo.
                                </div>
                            </div>

                            <input type="hidden" name="id" value="${proposal.proposalId}" />

                            <div class="field" style="margin-top:12px;">
                                <label class="field-label" for="rejectReason">Lý do từ chối <span style="color:#dc3545;">*</span></label>
                                <textarea class="input" id="rejectReason" name="rejectReason" rows="5" required
                                          placeholder="VD: Số lượng đề xuất vượt quá nhu cầu thực tế tại kho HCM trong tháng này..."></textarea>
                            </div>

                            <div class="footer-actions" style="margin-top:18px;">
                                <a class="btn" href="${pageContext.request.contextPath}/proposal?action=detail&id=${proposal.proposalId}">Quay lại</a>
                                <button type="submit" class="btn btn-danger">
                                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                                    Xác nhận từ chối
                                </button>
                            </div>
                        </form>

                    </div>
                </main>
            </div>
        </div>

        <script>
            function validateRejectForm() {
                var reason = document.getElementById('rejectReason').value.trim();
                if (reason.length < 5) {
                    alert('Vui lòng nhập lý do từ chối (tối thiểu 5 ký tự).');
                    document.getElementById('rejectReason').focus();
                    return false;
                }
                return confirm('Bạn có chắc chắn muốn từ chối phiếu đề xuất "' + (document.querySelector('.order-code')?.textContent || '') + '"?\n\nLý do: ' + reason);
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
