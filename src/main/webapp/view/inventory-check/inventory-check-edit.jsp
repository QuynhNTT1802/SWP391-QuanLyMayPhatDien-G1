<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Chỉnh sửa kiểm kê — Warehouse OS</title>
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
                <h1>Chỉnh sửa kiểm kê</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/inventory-check">Kiểm kê</a> / <a href="${pageContext.request.contextPath}/inventory-check?action=detail&id=${check.id}"><c:out value="${check.checkCode}"/></a> / Chỉnh sửa</span>
                <div class="top-actions">
                    <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi giao diện">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    </button>
                    <a class="btn" href="${pageContext.request.contextPath}/inventory-check?action=detail&id=${check.id}">Huỷ</a>
                </div>
            </header>

            <main>
                <div class="page-head">
                    <div class="left">
                        <div class="eyebrow">Kiểm kê</div>
                        <h2 class="page-title">Nhập số lượng kiểm kê</h2>
                        <div class="page-sub"><c:out value="${check.checkCode}"/></div>
                    </div>
                </div>

                <c:if test="${not empty requestScope.toastMessage}">
                    <div style="background:${requestScope.toastType == 'danger' ? 'var(--danger-soft)' : 'var(--accent)'};color:${requestScope.toastType == 'danger' ? 'var(--danger)' : 'var(--bg)'};border:${requestScope.toastType == 'danger' ? '1px solid color-mix(in srgb,var(--danger) 30%,transparent)' : 'none'};padding:10px 16px;border-radius:var(--radius);margin-bottom:12px;font-weight:600;font-size:13px;">
                        <c:out value="${requestScope.toastMessage}"/>
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/inventory-check?action=update" id="editForm">
                    <input type="hidden" name="checkId" value="${check.id}" />

                    <div class="section" style="padding: 18px 22px;">
                        <div class="form-grid">
                            <div class="form-field">
                                <label>Mã phiếu</label>
                                <input type="text" value="<c:out value="${check.checkCode}"/>" disabled />
                            </div>
                            <div class="form-field">
                                <label>Kho kiểm kê</label>
                                <input type="text" value="<c:out value="${check.warehouseName}"/>" disabled />
                            </div>
                            <div class="form-field">
                                <label>Người thực hiện</label>
                                <input type="text" value="<c:out value="${check.createdByName}"/>" disabled />
                            </div>
                            <div class="form-field">
                                <label>Thời gian bắt đầu</label>
                                <input type="text" value="${check.startedAt}" disabled />
                            </div>
                            <div class="form-field full">
                                <label>Ghi chú</label>
                                <textarea name="notes"><c:out value="${check.notes}"/></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="section" style="padding: 18px 22px; margin-top: 16px;">
                        <h3 style="margin: 0 0 12px; font-size: 15px; font-weight: 700;">Chi tiết kiểm kê</h3>

                        <c:choose>
                            <c:when test="${empty details}">
                                <div style="padding: 24px; text-align: center; color: var(--muted);">Không có dữ liệu.</div>
                            </c:when>
                            <c:otherwise>
                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 40px;">#</th>
                                            <th>Mã máy</th>
                                            <th>Thương hiệu</th>
                                            <th>Công suất</th>
                                            <th>SL sổ sách</th>
                                            <th>SL thực tế</th>
                                            <th>SL hư hỏng</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="d" items="${details}" varStatus="st">
                                            <tr>
                                                <td class="col-num">${st.index + 1}</td>
                                                <td><strong><c:out value="${d.generatorModel}"/></strong></td>
                                                <td><c:out value="${not empty d.generatorBrand ? d.generatorBrand : '—'}"/></td>
                                                <td><span class="mono"><c:out value="${d.powerRating}"/> kVA</span></td>
                                                <td class="qty-sys">${d.systemQuantity}</td>
                                                <td>
                                                    <input type="hidden" name="detailId" value="${d.id}" />
                                                    <input type="number" name="actualQuantity" class="edit-input"
                                                           value="<c:out value='${d.actualQuantity}'/>" min="0"
                                                           placeholder="—" />
                                                </td>
                                                <td>
                                                    <input type="number" name="damagedQuantity" class="edit-input"
                                                           value="${d.damagedQuantity}" min="0" />
                                                </td>
                                                <td>
                                                    <input type="text" name="detailNote" class="edit-input-note"
                                                           value="<c:out value='${d.notes}'/>" placeholder="Ghi chú..." />
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:20px;padding-bottom:40px;">
                        <a href="${pageContext.request.contextPath}/inventory-check?action=detail&id=${check.id}" class="btn">Huỷ</a>
                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                            Lưu thay đổi
                        </button>
                    </div>
                </form>
            </main>
        </div>
    </div>

    <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/inventory-check.js"></script>
</body>
</html>