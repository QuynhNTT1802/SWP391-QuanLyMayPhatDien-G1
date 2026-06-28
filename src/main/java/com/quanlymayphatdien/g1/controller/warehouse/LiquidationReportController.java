package com.quanlymayphatdien.g1.controller.warehouse;

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

/**
 * Báo cáo thanh lý cho Quản lý kho + CEO. Chỉ tính đơn đã thanh lý
 * (APPROVED_BY_CEO). Hỗ trợ lọc theo khoảng ngày + kho và xuất Excel.
 */
@WebServlet(name = "LiquidationReportController", urlPatterns = {"/liquidations/report"})
public class LiquidationReportController extends HttpServlet {

    private final LiquidationDAO liquidationDAO = new LiquidationDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();

    private static final int TOP_MODEL_LIMIT = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        boolean canView = perms != null
                && (perms.contains("liquidations.approve_manager") || perms.contains("liquidations.approve_ceo"));
        if (!canView) {
            request.setAttribute("requiredPerm", "liquidations.approve_manager");
            request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
            return;
        }

        // Parse bộ lọc: mặc định từ đầu năm tới hôm nay.
        LocalDate today = LocalDate.now();
        LocalDate defaultFrom = today.withDayOfYear(1);
        LocalDate fromDate = parseDate(request.getParameter("fromDate"), defaultFrom);
        LocalDate toDate = parseDate(request.getParameter("toDate"), today);

        // Validate: không cho ngày tương lai, from <= to.
        if (fromDate.isAfter(today) || toDate.isAfter(today) || fromDate.isAfter(toDate)) {
            request.setAttribute("dateError", "Khoảng thời gian không hợp lệ");
            fromDate = defaultFrom;
            toDate = today;
        }

        Integer warehouseId = parseInt(request.getParameter("warehouseId"));

        Map<String, Object> summary = liquidationDAO.getReportSummary(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byReason = liquidationDAO.getReportByReason(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byWarehouse = liquidationDAO.getReportByWarehouse(fromDate, toDate, warehouseId);
        List<Map<String, Object>> byModel = liquidationDAO.getReportByModel(fromDate, toDate, warehouseId, TOP_MODEL_LIMIT);
        List<Map<String, Object>> monthly = liquidationDAO.getReportMonthlyTrend(fromDate, toDate, warehouseId);

        String warehouseName = resolveWarehouseName(warehouseId);

        if ("export".equals(request.getParameter("action"))) {
            exportExcel(response, fromDate, toDate, warehouseName,
                    summary, byReason, byWarehouse, byModel, monthly);
            return;
        }

        request.setAttribute("summary", summary);
        request.setAttribute("byReason", byReason);
        request.setAttribute("byWarehouse", byWarehouse);
        request.setAttribute("byModel", byModel);
        request.setAttribute("monthly", monthly);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("fromDate", fromDate.toString());
        request.setAttribute("toDate", toDate.toString());
        request.setAttribute("selectedWarehouseId", warehouseId);
        request.setAttribute("activePage", "liquidation-report");
        request.getRequestDispatcher("/view/liquidation/liquidation-report.jsp").forward(request, response);
    }

    private void exportExcel(HttpServletResponse response,
            LocalDate fromDate, LocalDate toDate, String warehouseName,
            Map<String, Object> summary,
            List<Map<String, Object>> byReason,
            List<Map<String, Object>> byWarehouse,
            List<Map<String, Object>> byModel,
            List<Map<String, Object>> monthly) throws IOException {
        XSSFWorkbook workbook = LiquidationReportExcelSupport.exportReport(
                fromDate, toDate, warehouseName, summary, byReason, byWarehouse, byModel, monthly);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition",
                "attachment; filename=BaoCaoThanhLy_" + fromDate + "_" + toDate + ".xlsx");
        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        }
        workbook.close();
    }

    private String resolveWarehouseName(Integer warehouseId) {
        if (warehouseId == null) {
            return null;
        }
        List<Warehouse> all = warehouseDAO.findAll();
        for (Warehouse w : all) {
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
