package com.quanlymayphatdien.g1.controller.warehouse;

import com.google.gson.Gson;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.utils.InventoryReportExcelSupport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "InventoryReportController", urlPatterns = {"/inventory/report"})
public class InventoryReportController extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();
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
        if (perms == null || !perms.contains("inventory.view")) {
            request.setAttribute("requiredPerm", "inventory.view");
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

        Map<String, Object> summary = inventoryDAO.getInventoryReportSummary(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byWarehouse = inventoryDAO.getInventoryByWarehouse(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byStatus = inventoryDAO.getInventoryByStatus(fromDate, toDate, warehouseId);
        List<Map<String, Object>> monthlyTrend = inventoryDAO.getInventoryMonthlyTrend(fromDate, toDate, warehouseId);
        String monthlyTrendJson = new Gson().toJson(monthlyTrend);

        if ("export".equals(request.getParameter("action"))) {
            List<Map<String, Object>> rows = inventoryDAO.getInventoryDetailList(
                    fromDate, toDate, warehouseId, Integer.MAX_VALUE, 0);
            String warehouseName = resolveWarehouseName(warehouseId);
            XSSFWorkbook workbook = InventoryReportExcelSupport.exportReport(
                    fromDate, toDate, warehouseName, rows);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition",
                    "attachment; filename=BaoCaoTonKho_" + fromDate + "_" + toDate + ".xlsx");
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
            workbook.close();
            return;
        }

        int page = 1, pageSize = 25;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr.trim());
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        if (page < 1) {
            page = 1;
        }
        int offset = (page - 1) * pageSize;

        int totalItems = inventoryDAO.countInventoryDetailList(fromDate, toDate, warehouseId);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        List<Map<String, Object>> rows = inventoryDAO.getInventoryDetailList(
                fromDate, toDate, warehouseId, pageSize, offset);

        int fromIndex = totalItems > 0 ? (page - 1) * pageSize + 1 : 0;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("summary", summary);
        request.setAttribute("byWarehouse", byWarehouse);
        request.setAttribute("byStatus", byStatus);
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
        request.setAttribute("activePage", "inventory-report");
        request.getRequestDispatcher("/view/inventory/report/inventory-report.jsp").forward(request, response);
    }

    private String resolveWarehouseName(Integer warehouseId) {
        if (warehouseId == null) {
            return null;
        }
        for (Warehouse w : warehouseDAO.findAll()) {
            if (w.getWarehouseId() == warehouseId) {
                return w.getName();
            }
        }
        return null;
    }

    private LocalDate parseDate(String s, LocalDate fallback) {
        if (s == null || s.trim().isEmpty()) {
            return fallback;
        }
        try {
            return LocalDate.parse(s.trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private Integer parseInt(String s) {
        if (s == null || s.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}