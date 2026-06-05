package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.SystemLogDAO;
import com.quanlymayphatdien.g1.entity.SystemLog;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controller cho trang xem System Log tại /admin/system-log. Hỗ trợ filter theo
 * mức độ (INFO/WARNING/ERROR), khoảng thời gian, và nội dung.
 */
@WebServlet(name = "SystemLogController", urlPatterns = {"/admin/system-log"})
public class SystemLogController extends HttpServlet {

    private final SystemLogDAO logDAO = new SystemLogDAO();
    private static final int PAGE_SIZE = 25;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String level = request.getParameter("level");
        String module = request.getParameter("module");
        String search = request.getParameter("search");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        if (level != null && level.trim().isEmpty()) {
            level = null;
        }
        if (module != null && module.trim().isEmpty()) {
            module = null;
        }
        if (search != null && search.trim().isEmpty()) {
            search = null;
        }
        if (dateFrom != null && dateFrom.trim().isEmpty()) {
            dateFrom = null;
        }
        if (dateTo != null && dateTo.trim().isEmpty()) {
            dateTo = null;
        }

        // ---- Phân trang ----
        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.trim().isEmpty()) {
                page = Math.max(1, Integer.parseInt(p.trim()));
            }
        } catch (NumberFormatException ignored) {
            SystemLogger.warn("System Log", "SystemLogController.doGet", "Lỗi định dạng trang: " + ignored.getMessage());
        }

        List<SystemLog> logs = logDAO.findByFilter(level, module, search, dateFrom, dateTo, page, PAGE_SIZE);
        int total = logDAO.countByFilter(level, module, search, dateFrom, dateTo);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
        }

        request.setAttribute("logList", logs);
        request.setAttribute("totalLogs", total);
        request.setAttribute("logPage", page);
        request.setAttribute("logTotalPages", totalPages);
        request.setAttribute("level", level != null ? level : "");
        request.setAttribute("module", module != null ? module : "");
        request.setAttribute("search", search != null ? search : "");
        request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
        request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        request.setAttribute("activePage", "system-log");

        request.getRequestDispatcher("/view/admin/admin-system-log.jsp")
                .forward(request, response);
    }
}
