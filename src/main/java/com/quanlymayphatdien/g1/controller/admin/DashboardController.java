package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.ReceiptDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@WebServlet(name="DashboardController", urlPatterns={"/admin/dashboard"})
public class DashboardController extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final ReceiptDAO receiptDAO = new ReceiptDAO();
    private final GeneratorDAO generatorDAO = new GeneratorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        long totalInStock = inventoryDAO.grandTotalInStock();
        int activeWarehouses = inventoryDAO.countActiveWarehouses();
        int totalGenerators = generatorDAO.countByStatus("active");
        LocalDate now = LocalDate.now();
        LocalDate firstOfMonth = now.withDayOfMonth(1);

        Map<String, Object> invSummary = inventoryDAO.getInventoryReportSummary(firstOfMonth, now, null);
        int inStockCount = invSummary != null ? ((Number) invSummary.getOrDefault("inStock", 0)).intValue() : 0;

        Map<String, Object> importSummary = receiptDAO.getReportSummary(firstOfMonth, now, null, "IMPORT");
        Map<String, Object> exportSummary = receiptDAO.getReportSummary(firstOfMonth, now, null, "EXPORT");
        int importCount = importSummary != null ? ((Number) importSummary.getOrDefault("totalReceipts", 0)).intValue() : 0;
        int exportCount = exportSummary != null ? ((Number) exportSummary.getOrDefault("totalReceipts", 0)).intValue() : 0;

        List<Map<String, Object>> recentReceipts = receiptDAO.getReportDetailList(
                firstOfMonth.minusMonths(1), now, null, null, 6, 0);

        request.setAttribute("totalInStock", totalInStock);
        request.setAttribute("activeWarehouses", activeWarehouses);
        request.setAttribute("totalGenerators", totalGenerators);
        request.setAttribute("inStockCount", inStockCount);
        request.setAttribute("importCount", importCount);
        request.setAttribute("exportCount", exportCount);
        request.setAttribute("recentReceipts", recentReceipts);

        request.getRequestDispatcher("../view/admin/admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
    }
}
