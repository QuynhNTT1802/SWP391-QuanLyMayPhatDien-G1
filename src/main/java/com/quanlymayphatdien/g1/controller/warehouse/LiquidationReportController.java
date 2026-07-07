package com.quanlymayphatdien.g1.controller.warehouse;

import com.google.gson.Gson;
import com.quanlymayphatdien.g1.dal.LiquidationDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.utils.LiquidationReportExcelSupport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "LiquidationReportController", urlPatterns = {"/liquidations/report"})
public class LiquidationReportController extends HttpServlet {

    private final LiquidationDAO liquidationDAO = new LiquidationDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canView = perms != null && perms.contains("liquidations.approve_ceo");
        if (!canView) {
            request.setAttribute("requiredPerm", "liquidations.approve_ceo");
            request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
            return;
        }

        LocalDate today = LocalDate.now();
        LocalDate defaultFrom = today.withDayOfYear(1);
        LocalDate fromDate = parseDate(request.getParameter("fromDate"), defaultFrom);
        LocalDate toDate = parseDate(request.getParameter("toDate"), today);

        if (fromDate.isAfter(today) || toDate.isAfter(today) || fromDate.isAfter(toDate)) {
            request.setAttribute("dateError", "Khoảng thời gian không hợp lệ");
            fromDate = defaultFrom;
            toDate = today;
        }

        Integer warehouseId = parseInt(request.getParameter("warehouseId"));

        // Data for KPI cards + analytics tables
        Map<String, Object> summary = liquidationDAO.getReportSummary(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byReason = liquidationDAO.getReportByReason(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byWarehouse = liquidationDAO.getReportByWarehouse(fromDate, toDate, warehouseId);
        List<Map<String, Object>> monthlyTrend = liquidationDAO.getReportMonthlyTrend(fromDate, toDate, warehouseId);
        String monthlyTrendJson = new Gson().toJson(monthlyTrend);

        if ("export".equals(request.getParameter("action"))) {
            List<Map<String, Object>> rows = liquidationDAO.getReportDetailList(fromDate, toDate, warehouseId);
            String warehouseName = resolveWarehouseName(warehouseId);
            XSSFWorkbook workbook = LiquidationReportExcelSupport.exportReport(
                    fromDate, toDate, warehouseName, rows);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition",
                    "attachment; filename=BaoCaoThanhLy_" + fromDate + "_" + toDate + ".xlsx");
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
            workbook.close();
            return;
        }

        int page = 1, pageSize = 25;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr.trim()); } catch (NumberFormatException e) { page = 1; }
        }
        if (page < 1) page = 1;
        int offset = (page - 1) * pageSize;

        int totalItems = liquidationDAO.countReportDetailList(fromDate, toDate, warehouseId);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Map<String, Object>> rows = liquidationDAO.getReportDetailList(fromDate, toDate, warehouseId, pageSize, offset);

        int fromIndex = totalItems > 0 ? (page - 1) * pageSize + 1 : 0;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("summary", summary);
        request.setAttribute("byReason", byReason);
        request.setAttribute("byWarehouse", byWarehouse);
        request.setAttribute("monthlyTrend", monthlyTrend);
        request.setAttribute("monthlyTrendJson", monthlyTrendJson);
        request.setAttribute("rows", rows);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("fromDate", fromDate.toString());
        request.setAttribute("toDate", toDate.toString());
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("activePage", "liquidation-report");
        request.getRequestDispatcher("/view/liquidation/liquidation-report.jsp").forward(request, response);
    }

    private String resolveWarehouseName(Integer warehouseId) {
        if (warehouseId == null) return null;
        for (Warehouse w : warehouseDAO.findAll()) {
            if (w.getWarehouseId() == warehouseId) return w.getName();
        }
        return null;
    }

    private LocalDate parseDate(String s, LocalDate fallback) {
        if (s == null || s.trim().isEmpty()) return fallback;
        try {
            return LocalDate.parse(s.trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private Integer parseInt(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
