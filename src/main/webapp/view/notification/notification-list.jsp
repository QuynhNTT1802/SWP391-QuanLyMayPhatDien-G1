<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thông báo — Warehouse OS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-user.css">
    <style>
        .notif-page { padding: 16px 24px; }
        .notif-toolbar { display: flex; align-items: center; gap: 12px; margin-bottom: 12px; }
        .notif-tabs { display: inline-flex; gap: 4px; padding: 4px; background: var(--surface-2, #f1f5f9); border-radius: 8px; }
        .notif-tab { padding: 6px 14px; border-radius: 6px; font-size: 13px; color: var(--muted); text-decoration: none; }
        .notif-tab.active { background: var(--surface, #fff); color: var(--fg); font-weight: 600; box-shadow: 0 1px 2px rgba(0,0,0,.06); }
        .notif-count { color: var(--muted); font-size: 13px; }
        .notif-mark { margin-left: auto; }
        .notif-list { background: var(--surface, #fff); border: 1px solid var(--border); border-radius: 8px; overflow: hidden; }
        .notif-row { display: flex; gap: 12px; padding: 14px 16px; border-bottom: 1px solid var(--border); cursor: pointer; align-items: flex-start; }
        .notif-row:last-child { border-bottom: none; }
        .notif-row:hover { background: var(--surface-2, rgba(0,0,0,.03)); }
        .notif-row.unread { background: color-mix(in srgb, var(--primary, #2563eb) 5%, transparent); }
        .notif-row .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--primary, #2563eb); margin-top: 7px; flex-shrink: 0; }
        .notif-row.read .dot { visibility: hidden; }
        .notif-row .body { flex: 1; min-width: 0; }
        .notif-row .ttl { font-weight: 600; font-size: 14px; color: var(--fg); }
        .notif-row .msg { color: var(--muted); font-size: 13px; margin-top: 4px; line-height: 1.4; }
        .notif-row .meta { display: flex; gap: 10px; font-size: 12px; color: var(--muted); margin-top: 6px; align-items: center; }
        .notif-tag { padding: 2px 8px; border-radius: 4px; background: var(--surface-2, #f1f5f9); font-size: 11px; font-weight: 500; }
        .notif-empty { padding: 60px 20px; text-align: center; color: var(--muted); }
        .notif-pager { display: flex; justify-content: center; gap: 4px; margin-top: 16px; }
        .notif-pager a, .notif-pager span { padding: 6px 12px; border: 1px solid var(--border); border-radius: 6px; text-decoration: none; color: var(--fg); font-size: 13px; }
        .notif-pager .current { background: var(--primary, #2563eb); color: #fff; border-color: var(--primary, #2563eb); }
        .notif-pager .disabled { color: var(--muted); pointer-events: none; opacity: .5; }
    </style>
</head>
<body>
<c:set var="loggedUser" value="${sessionScope.loggedUser}"/>
<c:if test="${empty loggedUser}">
    <c:redirect url="/login"/>
</c:if>
<div class="app">
    <jsp:include page="../common/admin/aside.jsp"/>
    <div>
        <header class="topbar">
            <h1>Thông báo</h1>
            <span class="crumb">/ Thông báo</span>
            <div class="top-actions">
                <jsp:include page="../common/admin/bell.jsp"/>
            </div>
        </header>
        <main>
            <div class="notif-page">
                <div class="notif-toolbar">
                    <div class="notif-tabs">
                        <a class="notif-tab ${filter eq 'all' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/notifications?filter=all">Tất cả</a>
                        <a class="notif-tab ${filter eq 'unread' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/notifications?filter=unread">Chưa đọc (${unreadCount})</a>
                    </div>
                    <span class="notif-count">${total} thông báo</span>
                    <c:if test="${unreadCount > 0}">
                        <button type="button" class="btn notif-mark" id="markAllBtn">Đánh dấu tất cả đã đọc</button>
                    </c:if>
                </div>

                <div class="notif-list">
                    <c:choose>
                        <c:when test="${empty notifications}">
                            <div class="notif-empty">Không có thông báo nào.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="n" items="${notifications}">
                                <div class="notif-row ${n.read ? 'read' : 'unread'}"
                                     data-id="${n.id}"
                                     data-link="${n.link}">
                                    <span class="dot"></span>
                                    <div class="body">
                                        <div class="ttl">
                                            <c:out value="${n.title}"/>
                                        </div>
                                        <div class="msg"><c:out value="${n.message}"/></div>
                                        <div class="meta">
                                            <c:if test="${not empty n.entityType}">
                                                <span class="notif-tag">
                                                    <c:choose>
                                                        <c:when test="${n.entityType eq 'liquidation'}">Thanh lý</c:when>
                                                        <c:when test="${n.entityType eq 'order'}">Đơn hàng</c:when>
                                                        <c:when test="${n.entityType eq 'import_receipt'}">Nhập kho</c:when>
                                                        <c:when test="${n.entityType eq 'export_receipt'}">Xuất kho</c:when>
                                                        <c:when test="${n.entityType eq 'transfer'}">Luân chuyển</c:when>
                                                        <c:otherwise>${n.entityType}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </c:if>
                                            <span>
                                                <fmt:formatDate value="${n.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <c:if test="${totalPages > 1}">
                    <div class="notif-pager">
                        <c:choose>
                            <c:when test="${page > 1}">
                                <a href="${pageContext.request.contextPath}/notifications?filter=${filter}&page=${page - 1}">‹ Trước</a>
                            </c:when>
                            <c:otherwise><span class="disabled">‹ Trước</span></c:otherwise>
                        </c:choose>
                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <c:choose>
                                <c:when test="${p == page}">
                                    <span class="current">${p}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/notifications?filter=${filter}&page=${p}">${p}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${page < totalPages}">
                                <a href="${pageContext.request.contextPath}/notifications?filter=${filter}&page=${page + 1}">Sau ›</a>
                            </c:when>
                            <c:otherwise><span class="disabled">Sau ›</span></c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>
<script>
(function () {
    var endpoint = '${pageContext.request.contextPath}/notifications';
    document.querySelectorAll('.notif-row').forEach(function (row) {
        row.addEventListener('click', function () {
            var id = row.dataset.id;
            var link = row.dataset.link;
            fetch(endpoint + '?action=markRead&id=' + encodeURIComponent(id), {
                method: 'POST',
                credentials: 'same-origin'
            }).finally(function () {
                if (link) window.location.href = link;
            });
        });
    });

    var markAllBtn = document.getElementById('markAllBtn');
    if (markAllBtn) {
        markAllBtn.addEventListener('click', function () {
            fetch(endpoint + '?action=markAllRead', {
                method: 'POST',
                credentials: 'same-origin'
            }).finally(function () {
                window.location.reload();
            });
        });
    }
})();
</script>
</body>
</html>
