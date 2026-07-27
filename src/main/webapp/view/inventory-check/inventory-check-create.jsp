<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Tạo phiếu kiểm kê — Warehouse OS</title>
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
                <h1>Tạo phiếu kiểm kê</h1>
                <span class="crumb">/ <a href="${pageContext.request.contextPath}/inventory-check">Kiểm kê</a> / Tạo mới</span>
                <div class="top-actions">
                        <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                    </button>
                    <a class="btn" href="${pageContext.request.contextPath}/inventory-check">Huỷ</a>
                </div>
            </header>

            <main>
                <div class="page-head">
                    <div class="left">
                        <div class="eyebrow">Kiểm kê</div>
                        <h2 class="page-title">Tạo phiếu kiểm kê mới</h2>
                        <div class="page-sub">Kho kiểm kê được lấy tự động theo tài khoản của bạn</div>
                    </div>
                </div>

                <c:if test="${not empty requestScope.toastMessage}">
                    <div class="toast ${requestScope.toastType == 'danger' ? 'toast-danger' : 'toast-success'}">
                        <c:out value="${requestScope.toastMessage}"/>
                    </div>
                </c:if>

                <div class="section section-body mb-16">
                    <div class="form-field field-max-400">
                        <label>Kho kiểm kê</label>
                        <input type="text" class="edit-input" value="${currentWarehouseName}" disabled />
                    </div>
                </div>

                <c:if test="${selectedWarehouse > 0}">
                    <form method="POST" action="${pageContext.request.contextPath}/inventory-check?action=save" id="createForm">
                        <div class="section section-body">
                            <div class="form-field full">
                                <label>Ghi chú</label>
                                <textarea name="notes" placeholder="Nhập ghi chú cho phiếu kiểm kê (không bắt buộc)..."><c:out value="${param.notes}"/></textarea>
                            </div>
                        </div>

                        <div class="section section-body-mt">
                            <h3 class="section-title-sm">Danh sách máy trong kho</h3>

                            <c:choose>
                                <c:when test="${empty inventoryList}">
                                    <div class="empty-state">Kho này hiện không có máy nào.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="select-all-row">
                                        <input type="checkbox" id="selectAll" />
                                        <label for="selectAll" class="cursor-pointer">Chọn tất cả</label>
                                        <span class="count-label">(${inventoryList.size()} máy)</span>
                                    </div>

                                    <table class="detail-table table-mt">
                                        <thead>
                                            <tr>
                                                <th class="col-40">Chọn</th>
                                                <th class="col-40">STT</th>
                                                <th>Mẫu máy</th>                                                
                                                <th>SL trên hệ thống</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="inv" items="${inventoryList}" varStatus="st">
                                                <tr>
                                                    <td class="text-center">
                                                        <input type="checkbox" name="generatorId" value="${inv.generatorId}" class="gen-checkbox" />
                                                    </td>
                                                    <td class="col-num">${st.index + 1}</td>
                                                    <td><strong><c:out value="${inv.generatorModel}"/></strong></td>
                                                    <td class="qty-sys">${generatorCountMap[inv.generatorId]}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${not empty inventoryList}">
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/inventory-check" class="btn">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>
                                    Tạo phiếu kiểm kê
                                </button>
                            </div>
                        </c:if>
                    </form>
                </c:if>
            </main>
        </div>
    </div>

    <script>window.APP_CTX = '${pageContext.request.contextPath}';</script>
    <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/inventory-check.js"></script>
</body>
</html>
