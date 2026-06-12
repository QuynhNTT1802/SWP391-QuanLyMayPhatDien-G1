<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    java.time.format.DateTimeFormatter __propFmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    request.setAttribute("propFmt", __propFmt);
%>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chi tiết đề xuất nhập kho — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:ital,wght@0,400;0,500;0,600;0,700;0,800;1,500;1,600&family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/user-detail.css">
        <style>
            h1, h2, h3, h4 { font-weight: 700; letter-spacing: -0.01em; }
            label, .label { font-weight: 600; }
            input, select, textarea, button { font-weight: 500; }
            .mono { font-family: var(--font-mono); font-variant-numeric: tabular-nums; }

            .app { display: grid; grid-template-columns: 240px 1fr; min-height: 100vh; }

            .btn { display: inline-flex; align-items: center; gap: 6px; border: 1px solid var(--border); background: var(--surface); color: var(--fg); padding: 7px 14px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 600; cursor: pointer; font-family: var(--font-ui); text-decoration: none; }
            .btn:hover { background: var(--surface-2); }
            .btn-primary { background: var(--fg); color: var(--bg); border-color: var(--fg); }
            .btn-primary:hover { background: var(--fg-soft); border-color: var(--fg-soft); }
            .btn-danger { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); }
            .btn-danger:hover { background: var(--danger-soft); }
            .btn-warn { color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); }
            .btn-warn:hover { background: var(--warn-soft); }

            main { padding: 24px 32px 120px; }

            .page-head { margin-bottom: 20px; }
            .eyebrow { display: inline-flex; align-items: center; gap: 6px; font-size: 11px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); margin-bottom: 8px; }
            .eyebrow::before { content: ''; width: 5px; height: 5px; border-radius: 50%; background: var(--accent); }
            .page-head h1.title { font-size: 26px; font-weight: 700; letter-spacing: -0.02em; margin: 0; display: flex; align-items: center; gap: 12px; flex-wrap: wrap; line-height: 1.2; }
            .page-head h1.title .ts-code { font-family: var(--font-mono); color: var(--fg-soft); font-weight: 700; }
            .page-head .lede { color: var(--muted); margin-top: 8px; font-size: 14px; display: flex; align-items: center; flex-wrap: wrap; gap: 4px; }
            .page-head .lede .sep { color: var(--muted-2); margin: 0 4px; }

            .pill { display: inline-flex; align-items: center; gap: 5px; font-size: 11.5px; font-weight: 600; padding: 2px 9px; border-radius: 999px; border: 1px solid; font-family: var(--font-ui); }
            .pill .pdot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
            .pill.draft     { color: var(--muted);   border-color: var(--border); background: var(--surface-2); }
            .pill.pending   { color: var(--warn);    border-color: color-mix(in srgb, var(--warn) 30%, transparent);    background: var(--warn-soft); }
            .pill.approved  { color: var(--accent);  border-color: color-mix(in srgb, var(--accent) 30%, transparent);  background: var(--accent-soft); }
            .pill.rejected  { color: var(--danger);  border-color: color-mix(in srgb, var(--danger) 30%, transparent);  background: var(--danger-soft); }
            .pill.cancelled { color: var(--muted);   border-color: var(--border); background: var(--surface-2); }

            .action-bar { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; }

            .note-soft { font-size: 13px; color: var(--fg-soft); line-height: 1.6; white-space: pre-wrap; }

            table.data-table { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 13px; }
            table.data-table thead th { text-align: left; font-size: 11px; color: var(--muted); text-transform: uppercase; font-weight: 700; background: var(--surface-2); padding: 11px 14px; border-bottom: 1px solid var(--border); letter-spacing: 0.04em; }
            table.data-table tbody td { padding: 11px 14px; border-bottom: 1px solid var(--border); vertical-align: middle; }
            table.data-table tbody tr:hover { background: var(--surface-2); }
            table.data-table tbody tr:last-child td { border-bottom: 0; }
            .text-right { text-align: right; }
            .text-center { text-align: center; }

            .empty-state { text-align: center; padding: 40px 12px; color: var(--muted); }

            .alert { padding: 12px 16px; border-radius: var(--radius-sm); margin-bottom: 16px; font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 10px; border: 1px solid; }
            .alert svg { width: 18px; height: 18px; stroke: currentColor; fill: none; stroke-width: 2; flex-shrink: 0; }
            .alert-warn { background: var(--warn-soft); color: var(--warn); border-color: color-mix(in srgb, var(--warn) 30%, transparent); }
            .alert-error { background: var(--danger-soft); color: var(--danger); border-color: color-mix(in srgb, var(--danger) 30%, transparent); }
            .alert-info { background: var(--info-soft); color: var(--info); border-color: color-mix(in srgb, var(--info) 30%, transparent); }

            .action-badge { display: inline-flex; align-items: center; gap: 5px; font-size: 11px; font-weight: 700; padding: 2px 9px; border-radius: 999px; border: 1px solid; text-transform: uppercase; letter-spacing: 0.02em; font-family: var(--font-ui); }
            .action-create   { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent);  background: var(--accent-soft); }
            .action-update   { color: var(--info);   border-color: color-mix(in srgb, var(--info) 32%, transparent);    background: var(--info-soft); }
            .action-approve  { color: var(--accent); border-color: color-mix(in srgb, var(--accent) 32%, transparent);  background: var(--accent-soft); }
            .action-reject   { color: var(--danger); border-color: color-mix(in srgb, var(--danger) 32%, transparent);  background: var(--danger-soft); }
            .action-cancel   { color: var(--muted);  border-color: var(--border); background: var(--surface-2); }

            .topbar { position: sticky; top: 0; z-index: 10; background: color-mix(in srgb, var(--bg) 85%, transparent); backdrop-filter: blur(8px); border-bottom: 1px solid var(--border); display: flex; align-items: center; gap: 16px; padding: 12px 24px; }
            .topbar h1 { font-size: 16px; font-weight: 700; margin: 0; letter-spacing: -0.01em; }
            .crumb { color: var(--muted); font-size: 13px; font-weight: 500; }
            .top-actions { margin-inline-start: auto; display: flex; align-items: center; gap: 8px; }
            .icon-btn { width: 32px; height: 32px; border: 1px solid var(--border); background: var(--surface); color: var(--fg-soft); border-radius: var(--radius-sm); display: grid; place-items: center; cursor: pointer; }
            .icon-btn:hover { background: var(--surface-2); color: var(--fg); }
            .icon-btn svg { width: 15px; height: 15px; stroke: currentColor; fill: none; stroke-width: 1.6; }

            .modal-host { position: fixed; inset: 0; background: rgba(0, 0, 0, 0.45); display: none; align-items: center; justify-content: center; z-index: 1000; }
            .modal-host.show { display: flex; }
            .modal-card { background: var(--surface); border-radius: var(--radius); padding: 22px 24px; width: 460px; max-width: 90vw; border: 1px solid var(--border); }
            .modal-card h3 { margin: 0 0 6px 0; font-size: 17px; }
            .modal-sub { font-size: 12.5px; color: var(--muted); margin-bottom: 14px; }
            .modal-card label { display: block; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em; color: var(--muted); margin-bottom: 6px; }
            .modal-card textarea { width: 100%; min-height: 80px; padding: 8px 10px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--surface); color: var(--fg); font-family: var(--font-ui); font-size: 13px; resize: vertical; box-sizing: border-box; }
            .modal-actions { display: flex; gap: 8px; justify-content: flex-end; margin-top: 14px; }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

            <div>
                <header class="topbar">
                    <h1>Chi tiết đề xuất nhập kho</h1>
                    <span class="crumb">/ <a href="${pageContext.request.contextPath}/proposal">Đề xuất nhập kho</a> / <span><c:out value="${proposal.proposalCode}"/></span></span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.6"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.toastMessage}">
                        <div class="alert ${sessionScope.toastType == 'success' ? 'alert-success' : 'alert-error'}">
                            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/></svg>
                            <span><c:out value="${sessionScope.toastMessage}"/></span>
                        </div>
                        <c:remove var="toastMessage" scope="session"/>
                        <c:remove var="toastType" scope="session"/>
                    </c:if>
                    <c:set var="isOwner" value="${sessionScope.loggedUser.id == proposal.createdBy}" />
                    <c:set var="perms" value="${sessionScope.userPermissions}" />
                    <c:set var="canApprove" value="${perms.contains('proposals.approve')}" />

                    <%-- Banner cảnh báo máy mới --%>
                    <c:if test="${proposal.hasNewGenerator() && proposal.status == 'APPROVED'}">
                        <div class="alert alert-warn">
                            <svg viewBox="0 0 24 24"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                            <span>Phiếu có chứa máy phát chưa có trong kho. Warehouse cần tự thêm category trước khi tạo phiếu nhập.</span>
                        </div>
                    </c:if>

                    <%-- Action bar --%>
                    <div class="action-bar">
                        <a class="btn" href="${pageContext.request.contextPath}/proposal">Quay lại danh sách</a>

                        <c:if test="${proposal.status == 'DRAFT' && isOwner}">
                            <a class="btn" href="${pageContext.request.contextPath}/proposal?action=edit&id=${proposal.proposalId}">Chỉnh sửa</a>
                            <form method="POST" action="${pageContext.request.contextPath}/proposal?action=update" style="display:inline;">
                                <input type="hidden" name="id" value="${proposal.proposalId}" />
                                <input type="hidden" name="submitType" value="submit" />
                                <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận gửi duyệt phiếu đề xuất này?')">Gửi duyệt</button>
                            </form>
                            <form method="POST" action="${pageContext.request.contextPath}/proposal?action=delete" style="display:inline;">
                                <input type="hidden" name="id" value="${proposal.proposalId}" />
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Xác nhận xoá phiếu đề xuất nháp này?')">Xoá</button>
                            </form>
                        </c:if>

                        <c:if test="${proposal.status == 'PENDING'}">
                            <c:if test="${canApprove}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=approve" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-primary" onclick="return confirm('Xác nhận duyệt phiếu đề xuất này?')">Duyệt phiếu</button>
                                </form>
                                <a class="btn btn-danger" href="${pageContext.request.contextPath}/proposal?action=reject&id=${proposal.proposalId}">Từ chối</a>
                            </c:if>
                            <c:if test="${perms.contains('proposals.cancel')}">
                                <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                    <input type="hidden" name="id" value="${proposal.proposalId}" />
                                    <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất này?')">Huỷ phiếu</button>
                                </form>
                            </c:if>
                        </c:if>

                        <c:if test="${proposal.status == 'APPROVED' && perms.contains('proposals.cancel')}">
                            <form method="POST" action="${pageContext.request.contextPath}/proposal?action=cancel" style="display:inline;">
                                <input type="hidden" name="id" value="${proposal.proposalId}" />
                                <button type="submit" class="btn btn-warn" onclick="return confirm('Xác nhận huỷ phiếu đề xuất đã duyệt?')">Huỷ phiếu</button>
                            </form>
                        </c:if>
                    </div>

                    <%-- Page head --%>
                    <div class="page-head">
                        <div class="eyebrow">Phiếu đề xuất nhập kho</div>
                        <h1 class="title">
                            <span>Chi tiết đề xuất</span>
                            <span class="ts-code">#${proposal.proposalId}</span>
                            <c:choose>
                                <c:when test="${proposal.status == 'DRAFT'}"><span class="pill draft"><span class="pdot"></span>Nháp</span></c:when>
                                <c:when test="${proposal.status == 'PENDING'}"><span class="pill pending"><span class="pdot"></span>Chờ duyệt</span></c:when>
                                <c:when test="${proposal.status == 'APPROVED'}"><span class="pill approved"><span class="pdot"></span>Đã duyệt</span></c:when>
                                <c:when test="${proposal.status == 'REJECTED'}"><span class="pill rejected"><span class="pdot"></span>Từ chối</span></c:when>
                                <c:when test="${proposal.status == 'CANCELLED'}"><span class="pill cancelled"><span class="pdot"></span>Đã huỷ</span></c:when>
                                <c:otherwise><span class="pill"><c:out value="${proposal.status}"/></span></c:otherwise>
                            </c:choose>
                        </h1>
                        <div class="lede">
                            <span>Ngày đề xuất:
                                <c:choose>
                                    <c:when test="${proposal.proposalDate == null}">—</c:when>
                                    <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                </c:choose>
                            </span>
                            <span class="sep">·</span>
                            <span>Kho: <c:out value="${proposal.warehouseName}"/></span>
                        </div>
                    </div>

                    <%-- Section 1: Thông tin chung --%>
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">01 — THÔNG TIN CHUNG</div>
                                <h3 class="section-title">Thông tin phiếu đề xuất</h3>
                            </div>
                            <span class="section-update">Read-only</span>
                        </div>
                        <div class="info-grid cols-4">
                            <div class="info-field">
                                <div class="info-label">Mã phiếu</div>
                                <div class="info-value mono"><c:out value="${proposal.proposalCode}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Kho nhập</div>
                                <div class="info-value"><c:out value="${proposal.warehouseName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Cán bộ đầu mối</div>
                                <div class="info-value"><c:out value="${proposal.createdByName}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Người duyệt</div>
                                <div class="info-value"><c:out value="${not empty proposal.approvedByName ? proposal.approvedByName : '—'}"/></div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Ngày đăng ký</div>
                                <div class="info-value mono">
                                    <c:choose>
                                        <c:when test="${proposal.proposalDate == null}"><span class="info-value empty">—</span></c:when>
                                        <c:otherwise>${proposal.proposalDate.format(propFmt)}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="info-field">
                                <div class="info-label">Ngày duyệt</div>
                                <div class="info-value mono">
                                    <c:choose>
                                        <c:when test="${proposal.approvedAt == null}"><span class="info-value empty">—</span></c:when>
                                        <c:otherwise>${proposal.approvedAt.format(propFmt)}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <c:if test="${proposal.status == 'REJECTED'}">
                            <div class="info-grid cols-2" style="margin-top: 16px;">
                                <div class="info-field">
                                    <div class="info-label">Người từ chối</div>
                                    <div class="info-value"><c:out value="${not empty proposal.rejectedByName ? proposal.rejectedByName : '—'}"/></div>
                                </div>
                                <div class="info-field">
                                    <div class="info-label">Ngày từ chối</div>
                                    <div class="info-value mono">
                                        <c:choose>
                                            <c:when test="${proposal.rejectedAt == null}"><span class="info-value empty">—</span></c:when>
                                            <c:otherwise>${proposal.rejectedAt.format(propFmt)}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-field" style="grid-column: span 2;">
                                    <div class="info-label">Lý do từ chối</div>
                                    <div class="info-value"><c:out value="${not empty proposal.rejectReason ? proposal.rejectReason : '—'}"/></div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty proposal.note}">
                            <div class="info-grid" style="margin-top: 16px;">
                                <div class="info-field">
                                    <div class="info-label">Ghi chú</div>
                                    <div class="note-soft"><c:out value="${proposal.note}"/></div>
                                </div>
                            </div>
                        </c:if>
                    </section>

                    <%-- Section 2: Chi tiết máy phát --%>
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">02 — CHI TIẾT MÁY PHÁT ĐỀ XUẤT</div>
                                <h3 class="section-title">Danh sách máy phát điện</h3>
                            </div>
                            <span class="section-update"><c:out value="${fn:length(proposal.details)}"/> dòng</span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width:50px;">#</th>
                                    <th>Máy phát / Hãng</th>
                                    <th style="width:100px;" class="text-right">Số lượng</th>
                                    <th style="width:130px;" class="text-right">Tồn kho hiện tại</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty proposal.details}">
                                        <tr><td colspan="5" class="text-center empty-state">Chưa có dòng hàng nào trong phiếu.</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="d" items="${proposal.details}" varStatus="st">
                                            <tr>
                                                <td class="mono">${st.index + 1}</td>
                                                <td>
                                                    <strong><c:out value="${d.generatorName}"/></strong>
                                                    <span style="color:var(--muted);"> · <c:out value="${d.brandName}"/></span>
                                                </td>
                                                <td class="mono text-right"><fmt:formatNumber value="${d.quantity}"/></td>
                                                <td class="mono text-right"><fmt:formatNumber value="${d.currentStock}"/></td>
                                                <td><c:out value="${d.note}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </section>

                    <%-- Section 3: Lịch sử cập nhật --%>
                    <section class="section">
                        <div class="section-head">
                            <div>
                                <div class="section-num">03 — LỊCH SỬ CẬP NHẬT</div>
                                <h3 class="section-title">Lịch sử thao tác</h3>
                            </div>
                            <span class="section-update">${totalHistory} bản ghi</span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width:160px;">Thời gian</th>
                                    <th style="width:200px;">Người thực hiện</th>
                                    <th style="width:150px;">Hành động</th>
                                    <th>Chi tiết thay đổi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty history}">
                                        <tr><td colspan="4" class="empty-state">Không có bản ghi nào</td></tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="h" items="${history}">
                                            <tr>
                                                <td class="mono">
                                                    <c:choose>
                                                        <c:when test="${h.createdAt == null}">—</c:when>
                                                        <c:otherwise>${h.createdAt.format(propFmt)}</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><c:out value="${h.username}"/></td>
                                                <td>
                                                    <span class="action-badge action-<c:choose>
                                                        <c:when test="${h.action == 'CREATE'}">create</c:when>
                                                        <c:when test="${h.action == 'UPDATE'}">update</c:when>
                                                        <c:when test="${h.action == 'APPROVE'}">approve</c:when>
                                                        <c:when test="${h.action == 'REJECT'}">reject</c:when>
                                                        <c:when test="${h.action == 'CANCEL'}">cancel</c:when>
                                                        <c:otherwise>cancel</c:otherwise>
                                                    </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${h.action == 'CREATE'}">Tạo phiếu</c:when>
                                                        <c:when test="${h.action == 'UPDATE'}">Cập nhật</c:when>
                                                        <c:when test="${h.action == 'APPROVE'}">Duyệt</c:when>
                                                        <c:when test="${h.action == 'REJECT'}">Từ chối</c:when>
                                                        <c:when test="${h.action == 'CANCEL'}">Huỷ</c:when>
                                                        <c:otherwise>${h.action}</c:otherwise>
                                                    </c:choose>
                                                    </span>
                                                </td>
                                                <td><c:out value="${h.details}"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                    </c:choose>
                            </tbody>
                        </table>
                    </section>
                </main>
            </div>
        </div>
    </body>
</html>
