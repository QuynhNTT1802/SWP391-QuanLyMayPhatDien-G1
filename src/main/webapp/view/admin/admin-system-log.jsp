<%--
    admin-system-log.jsp — Trang xem System Log (lỗi kỹ thuật hệ thống)
    URL: /admin/system-log
    Chỉ admin mới có quyền truy cập (kiểm soát bởi SecurityFilter)
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="vi" data-theme="light">
    <head>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>System Log — Warehouse OS</title>
        <meta name="description" content="Theo dõi lỗi và cảnh báo kỹ thuật của hệ thống Warehouse OS"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/variables.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-category.css"/>
        <style>
            .level-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 2px 10px;
                border-radius: 999px;
                font-size: 10.5px;
                font-weight: 700;
                letter-spacing: 0.04em;
                text-transform: uppercase;
            }
            .level-badge::before {
                content: '';
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background: currentColor;
                opacity: 0.7;
            }
            .level-badge.level-INFO    {
                background: var(--info-soft);
                color: var(--info);
            }
            .level-badge.level-WARNING {
                background: var(--warn-soft);
                color: var(--warn);
            }
            .level-badge.level-ERROR   {
                background: var(--danger-soft);
                color: var(--danger);
            }

            /* ===== Stack trace details block ===== */
            .stack-details summary {
                cursor: pointer;
                color: var(--muted);
                font-size: 11.5px;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 4px;
                margin-top: 5px;
                user-select: none;
            }
            .stack-details summary:hover {
                color: var(--fg);
            }
            .stack-details summary::marker {
                display: none;
            }
            .stack-details pre {
                font-family: var(--font-mono);
                font-size: 11px;
                line-height: 1.5;
                background: var(--surface-2);
                border: 1px solid var(--border);
                border-radius: var(--radius-sm);
                padding: 10px 12px;
                margin-top: 6px;
                overflow-x: auto;
                max-height: 220px;
                white-space: pre-wrap;
                word-break: break-all;
                color: var(--fg-soft);
            }

            /* ===== Source cell ===== */
            .source-cell {
                font-family: var(--font-mono);
                font-size: 11.5px;
                color: var(--muted);
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

            /* ===== Message cell ===== */
            .message-cell {
                max-width: 400px;
            }
            .message-text {
                font-size: 13px;
                font-weight: 500;
                color: var(--fg);
                line-height: 1.4;
            }

            /* ===== Header stats ===== */
            .stat-chips {
                display: flex;
                gap: 8px;
                margin-left: auto;
                flex-wrap: wrap;
            }
            .stat-chip {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 3px 10px;
                border-radius: 999px;
                border: 1px solid;
                font-size: 11.5px;
                font-weight: 700;
            }
            .stat-chip .dot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
            }
            .stat-chip.sc-error   {
                color: var(--danger);
                border-color: color-mix(in srgb, var(--danger)  30%, transparent);
                background: var(--danger-soft);
            }
            .stat-chip.sc-warning {
                color: var(--warn);
                border-color: color-mix(in srgb, var(--warn)    30%, transparent);
                background: var(--warn-soft);
            }
            .stat-chip.sc-info    {
                color: var(--info);
                border-color: color-mix(in srgb, var(--info)    30%, transparent);
                background: var(--info-soft);
            }

            /* ===== Filter row ===== */
            .syslog-filter {
                display: flex;
                align-items: center;
                gap: 10px;
                flex-wrap: wrap;
                padding: 14px 16px;
                background: var(--surface-2);
                border-bottom: 1px solid var(--border);
            }
            .syslog-filter .search-input {
                min-width: 220px;
                max-width: 320px;
                flex: 1;
            }
        </style>
    </head>
    <body>
        <div class="app">
            <jsp:include page="../common/admin/aside.jsp"/>

            <div>
                <!-- ===== Top bar ===== -->
                <header class="topbar">
                    <h1>System Log</h1>
                    <span class="crumb">/ Lỗi hệ thống</span>
                    <div class="top-actions">
                        <!-- Theme toggle -->
                        <button id="themeToggleBtn" class="icon-btn theme-toggle" title="Chuyển giao diện"
                                onclick="document.documentElement.dataset.theme = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark'; localStorage.setItem('theme', document.documentElement.dataset.theme)">
                            <svg class="icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="5"/><path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42"/></svg>
                            <svg class="icon-moon" viewBox="0 0 24 24"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></svg>
                        </button>
                    </div>
                </header>

                <main>

                    <div class="page-head">
                        <div class="left">
                            <div class="eyebrow">Hệ thống</div>
                            <h2 class="page-title">System Log</h2>
                            <p class="page-sub">Theo dõi lỗi kỹ thuật, cảnh báo và thông tin hoạt động của hệ thống</p>
                        </div>
                        
                    </div>

                    <form id="syslogFilterForm" method="get"
                          action="${pageContext.request.contextPath}/admin/system-log"
                          class="syslog-filter">

                        <%-- Dropdown mức độ --%>
                        <select id="levelFilter" name="level" class="filter-select"
                                onchange="document.getElementById('syslogFilterForm').submit()">
                            <option value="" ${empty level ? 'selected' : ''}>Tất cả mức độ</option>
                            <option value="ERROR"   ${level == 'ERROR'   ? 'selected' : ''}>ERROR</option>
                            <option value="WARNING" ${level == 'WARNING' ? 'selected' : ''}>WARNING</option>
                            <option value="INFO"    ${level == 'INFO'    ? 'selected' : ''}>INFO</option>
                        </select>

                        <%-- Dropdown module --%>
                        <select id="moduleFilter" name="module" class="filter-select"
                                onchange="document.getElementById('syslogFilterForm').submit()">
                            <option value="" ${empty module ? 'selected' : ''}>Tất cả module</option>
                            <option value="quản lý danh mục"   ${module == 'quản lý danh mục'   ? 'selected' : ''}>Quản lý danh mục</option>
                            <option value="quản lý người dùng" ${module == 'quản lý người dùng' ? 'selected' : ''}>Quản lý người dùng</option>
                            <option value="quản lý phân quyền" ${module == 'quản lý phân quyền' ? 'selected' : ''}>Quản lý phân quyền</option>
                            <option value="quản lý mật khẩu"   ${module == 'quản lý mật khẩu'   ? 'selected' : ''}>Quản lý mật khẩu</option>
                            <option value="hệ thống"            ${module == 'hệ thống'            ? 'selected' : ''}>Hệ thống</option>
                        </select>

                        <%-- Tìm kiếm nội dung --%>
                        <div class="search-input">
                            <svg viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                            <input id="syslogSearch" name="search" value="${search}"
                                   placeholder="Tìm nội dung, nguồn lỗi..."/>
                        </div>

                        <%-- Khoảng ngày --%>
                        <div class="date-range">
                            <span class="date-label">Từ</span>
                            <input id="dateFrom" type="date" name="dateFrom" value="${dateFrom}" class="date-input"/>
                            <span class="date-label">đến</span>
                            <input id="dateTo"   type="date" name="dateTo"   value="${dateTo}"   class="date-input"/>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            <svg class="icon" viewBox="0 0 24 24"><path d="M22 3H2l8 9.46V19l4 2v-8.54L22 3z"/></svg>
                            Lọc
                        </button>

                        <c:if test="${not empty level or not empty module or not empty search or not empty dateFrom or not empty dateTo}">
                            <a href="${pageContext.request.contextPath}/admin/system-log" class="btn">Xóa lọc</a>
                            <span class="filter-active-badge">Đang lọc</span>
                        </c:if>
                    </form>


                    <div class="table-card history-card">
                        <c:if test="${totalLogs > 0}">
                            <div class="result-summary">
                                Tổng <strong>${totalLogs}</strong> bản ghi
                                <c:if test="${not empty level}"> — mức <strong>${level}</strong></c:if>
                                <c:if test="${not empty module}"> — module <strong>${module}</strong></c:if>
                                <c:if test="${not empty search}"> — tìm "<strong>${search}</strong>"</c:if>
                            </div>
                        </c:if>

                        <table>
                            <thead>
                                <tr>
                                    <th style="width:140px">Thời gian</th>
                                    <th style="width:90px">Mức độ</th>
                                    <th style="width:160px">Module</th>
                                    <th style="width:175px">Nguồn</th>
                                    <th>Nội dung</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty logList}">
                                        <tr>
                                            <td colspan="5">
                                                <div class="empty-state">
                                                    <div class="icon-wrap">
                                                        <svg viewBox="0 0 24 24"><path d="M9 12h6M9 16h6M17 21H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7l5 5v11a2 2 0 0 1-2 2z"/></svg>
                                                    </div>
                                                    <strong>Không có log nào</strong>
                                                    <c:choose>
                                                        <c:when test="${not empty level or not empty module or not empty search or not empty dateFrom or not empty dateTo}">
                                                            Không tìm thấy kết quả phù hợp với bộ lọc hiện tại
                                                        </c:when>
                                                        <c:otherwise>
                                                            Hệ thống chưa ghi nhận lỗi nào
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="log" items="${logList}">
                                            <tr>
                                                <%-- Thời gian --%>
                                                <td style="font-family:var(--font-mono);font-size:12px;color:var(--muted);white-space:nowrap">
                                                    <fmt:formatDate value="${log.createdAtAsDate}" pattern="dd/MM/yyyy"/>
                                                    <br/>
                                                    <span style="font-size:11px">
                                                        <fmt:formatDate value="${log.createdAtAsDate}" pattern="HH:mm:ss"/>
                                                    </span>
                                                </td>

                                                <%-- Mức độ --%>
                                                <td>
                                                    <span class="level-badge level-${log.level}">${log.level}</span>
                                                </td>

                                                <%-- Module --%>
                                                <td>
                                                    <a href="?module=${log.module}" title="Lọc theo module này"
                                                       style="font-size:12px;color:var(--primary);text-decoration:none;font-weight:500">
                                                        ${fn:escapeXml(log.module)}
                                                    </a>
                                                </td>

                                                <%-- Nguồn --%>
                                                <td>
                                                    <div class="source-cell" title="${log.source}">${log.source}</div>
                                                </td>

                                                <%-- Nội dung + Stack trace --%>
                                                <td class="message-cell">
                                                    <div class="message-text">${fn:escapeXml(log.message)}</div>
                                                    <c:if test="${not empty log.stackTrace}">
                                                        <details class="stack-details">
                                                            <summary>Xem stack trace</summary>
                                                            <pre>${fn:escapeXml(fn:substring(log.stackTrace, 0, 2000))}<c:if test="${fn:length(log.stackTrace) > 2000}">
... (đã rút gọn)</c:if></pre>
                                                        </details>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>

                        <%-- Phân trang --%>
                        <c:if test="${logTotalPages > 1}">
                            <div class="pagination">
                                <div class="info">
                                    Trang <strong>${logPage}</strong> / <strong>${logTotalPages}</strong>
                                    &nbsp;·&nbsp; Tổng <strong>${totalLogs}</strong> bản ghi
                                </div>
                                <div class="controls">
                                    <%-- Nút trang trước --%>
                                    <c:choose>
                                        <c:when test="${logPage > 1}">
                                            <a class="page-btn"
                                               href="?page=${logPage-1}&level=${level}&module=${module}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">‹</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="page-btn" disabled>‹</button>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Số trang --%>
                                    <c:forEach begin="1" end="${logTotalPages}" var="p">
                                        <c:if test="${p >= logPage - 2 and p <= logPage + 2}">
                                            <a class="page-btn ${p == logPage ? 'active' : ''}"
                                               href="?page=${p}&level=${level}&module=${module}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">${p}</a>
                                        </c:if>
                                    </c:forEach>

                                    <%-- Nút trang sau --%>
                                    <c:choose>
                                        <c:when test="${logPage < logTotalPages}">
                                            <a class="page-btn"
                                               href="?page=${logPage+1}&level=${level}&module=${module}&search=${search}&dateFrom=${dateFrom}&dateTo=${dateTo}">›</a>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="page-btn" disabled>›</button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </main>
            </div>
        </div>

        <script>
            // Khôi phục theme đã lưu
            (function () {
                var t = localStorage.getItem('theme');
                if (t)
                    document.documentElement.dataset.theme = t;
            })();
        </script>
    </body>
</html>
