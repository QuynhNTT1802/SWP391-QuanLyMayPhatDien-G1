<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Chỉnh sửa đơn hàng — Warehouse OS</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-user.css">
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"></jsp:include>

                <div>
                    <header class="topbar">
                        <h1>Chỉnh sửa đơn hàng</h1>
                        <span class="crumb">/ <a href="${pageContext.request.contextPath}/order?action=list">Đơn hàng</a> / Chỉnh sửa</span>
                    <div class="top-actions">
                        <button class="icon-btn theme-toggle" id="themeToggle" title="Đổi theme">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" stroke="currentColor" fill="none" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                </header>

                <main>
                    <c:if test="${not empty sessionScope.message}">
                        <div style="background:var(--accent);color:var(--bg);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                            <c:out value="${sessionScope.message}"/>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div style="background:var(--danger-soft);color:var(--danger);border:1px solid color-mix(in srgb,var(--danger) 30%,transparent);border-radius:var(--radius);padding:10px 16px;margin-bottom:12px;font-size:13px;font-weight:600;">
                            <c:out value="${error}"/>
                        </div>
                    </c:if>

                    <a class="back-link" href="${pageContext.request.contextPath}/order?action=list">
                        <svg viewBox="0 0 24 24"><path d="M19 
                                                       19l-7-7 7-7"/></svg>
                        Quay lại danh sách
                    </a>

                    <div class="page-head">
                        <div class="eyebrow">Kinh doanh · Đơn hàng #${order.orderId}</div>
                        <h2 class="page-title">Chỉnh sửa thông tin đơn hàng</h2>
                    </div>

                    <div class="form-layout">
                        <form class="form-card" method="post" action="${pageContext.request.contextPath}/order?action=update">
                            <input type="hidden" name="orderId" value="${order.orderId}" />

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">01 — THÔNG TIN KHÁCH HÀNG</div>
                                    <h3 class="form-section-title">Người nhận hàng</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field">
                                        <label class="field-label">Tên khách hàng <span class="req">*</span></label>
                                        <input class="input" name="customerName" value="<c:out value="${order.customerName}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Số điện thoại <span class="req">*</span></label>
                                        <input class="input mono" name="customerPhone" value="<c:out value="${order.customerPhone}"/>" required />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Email</label>
                                        <input class="input mono" name="customerEmail" type="email" value="<c:out value="${order.customerEmail}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Địa chỉ giao hàng</label>
                                        <input class="input" name="customerAddress" value="<c:out value="${order.customerAddress}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Mã số thuế</label>
                                        <input class="input mono" name="customerTaxCode" value="<c:out value="${order.customerTaxCode}"/>" />
                                    </div>
                                    <div class="field">
                                        <label class="field-label">Tên công ty</label>
                                        <input class="input" name="customerCompany" value="<c:out value="${order.customerCompany}"/>" />
                                    </div>
                                </div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">02 — GHI CHÚ ĐƠN HÀNG</div>
                                    <h3 class="form-section-title">Thông tin bổ sung</h3>
                                </div>
                                <div class="form-grid">
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú của khách hàng</label>
                                        <textarea class="input" name="customerNote" rows="3"><c:out value="${order.customerNote}"/></textarea>
                                    </div>
                                    <div class="field" style="grid-column: span 2;">
                                        <label class="field-label">Ghi chú nội bộ</label>
                                        <textarea class="input" name="internalNote" rows="2"><c:out value="${order.note}"/></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="form-section">
                                <div class="form-section-head">
                                    <div class="form-section-num">03 — CHỌN LẠI MÁY PHÁT ĐIỆN</div>
                                    <h3 class="form-section-title">Cập nhật sản phẩm</h3>
                                </div>

                                <div id="generator-list">
                                    <c:forEach var="gen" items="${generators}">
                                        <!-- Kiểm tra xem máy này đã có trong đơn chưa -->
                                        <c:set var="isChecked" value="false" />
                                        <c:set var="currentQty" value="1" />

                                        <c:forEach var="detail" items="${existingDetails}">
                                            <c:if test="${detail.generatorId == gen.id}">
                                                <c:set var="isChecked" value="true" />
                                                <c:set var="currentQty" value="${detail.quantity}" />
                                            </c:if>
                                        </c:forEach>
                                        <div class="generator-item" style="border:1px solid var(--border);border-radius:var(--radius);padding:16px;margin-bottom:12px;">
                                            <label style="display:flex;align-items:center;gap:12px;cursor:pointer;">
                                                <!-- Checkbox: Nếu isChecked=true thì thêm thuộc tính checked -->
                                                <input type="checkbox" name="generatorIds" value="${gen.id}" 
                                                       <c:if test="${isChecked}">checked</c:if> 
                                                           style="width:18px;height:18px;accent-color:var(--accent);" />
                                                       <div style="flex:1;">
                                                           <div style="font-weight:600;font-size:15px;"><c:out value="${gen.model}"/></div>
                                                       <div style="font-size:13px;color:var(--muted);margin-top:2px;">
                                                           <fmt:formatNumber value="${gen.unitPrice}" type="currency" currencySymbol="₫"/>
                                                       </div>
                                                </div>
                                            </label>

                                            <!-- Input số lượng: Nếu đã chọn thì hiện số lượng cũ, chưa chọn thì hiện 1 -->
                                            <div style="margin-top:12px;display:flex;gap:12px;align-items:center;">
                                                <label class="field-label" style="margin:0;">Số lượng:</label>
                                                <input type="number" name="quantity_${gen.id}" min="1" value="${currentQty}" class="input" style="width:100px;" />
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="form-section" style="display:flex;gap:8px;justify-content:flex-end;">
                                <a class="btn" href="${pageContext.request.contextPath}/order?action=list">Huỷ</a>
                                <button type="submit" class="btn btn-primary">
                                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 20h9M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                                    Cập nhật đơn hàng
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <div class="toast-host" id="toastHost"></div>
        <script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>
    </body>
</html>
