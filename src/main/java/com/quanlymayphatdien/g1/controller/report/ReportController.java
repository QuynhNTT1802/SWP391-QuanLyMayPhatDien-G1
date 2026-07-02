/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quanlymayphatdien.g1.controller.report;

import com.quanlymayphatdien.g1.dal.ReportDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.InventoryCheckReportItem;
import com.quanlymayphatdien.g1.entity.InventoryReportItem;
import com.quanlymayphatdien.g1.entity.PurchaseOrder;
import com.quanlymayphatdien.g1.entity.Receipt;
import com.quanlymayphatdien.g1.entity.SaleOrder;
import com.quanlymayphatdien.g1.utils.ReportExcelSupport;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.OutputStream;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author Aadmin
 */
@WebServlet(name="ReportController", urlPatterns={"/reports"})
public class ReportController extends HttpServlet {
    private final ReportDAO reportDAO = new ReportDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }

        Set<String> perms = (Set<String>) session.getAttribute("userPermissions");
        if (perms == null || !perms.contains("reports.view")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        if ("export".equals(action)) {
            if (perms == null || !perms.contains("reports.export")) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            handleExport(req, resp);
        } else {
            showReport(req, resp);
        }
    }
    
    private void showReport(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String type = req.getParameter("type");
        if (type == null || type.isEmpty()) {
            type = "inventory";
        }

        int month = LocalDate.now().getMonthValue();
        int year = LocalDate.now().getYear();
        try {
            month = Integer.parseInt(req.getParameter("month"));
        } catch (Exception e) {
        }
        try {
            year = Integer.parseInt(req.getParameter("year"));
        } catch (Exception e) {
        }

        Integer warehouseId = null;
        try {
            warehouseId = Integer.parseInt(req.getParameter("warehouseId"));
        } catch (Exception e) {
        }

        int page = 1, pageSize = 15;
        try {
            page = Integer.parseInt(req.getParameter("page"));
            if (page < 1) {
                page = 1;
            }
        } catch (Exception e) {
        }
        try {
            pageSize = Integer.parseInt(req.getParameter("pageSize"));
        } catch (Exception e) {
        }

        int totalItems = 0;
        int totalPages = 1;

        String view = "/view/report/report.jsp";
        req.setAttribute("reportType", type);
        req.setAttribute("month", month);
        req.setAttribute("year", year);
        req.setAttribute("selWarehouseId", warehouseId);
        req.setAttribute("warehouses", warehouseDAO.findAll());

        switch (type) {
            case "inventory": {
                totalItems = reportDAO.countInventoryReport(warehouseId, month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<InventoryReportItem> items = reportDAO.getInventoryReport(warehouseId, month, year, page, pageSize);
                req.setAttribute("inventoryItems", items);
                break;
            }
            case "import": {
                totalItems = reportDAO.countImportReport(warehouseId, month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<Receipt> items = reportDAO.getImportReport(warehouseId, month, year, page, pageSize);
                req.setAttribute("receiptItems", items);
                break;
            }
            case "export": {
                totalItems = reportDAO.countExportReport(warehouseId, month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<Receipt> items = reportDAO.getExportReport(warehouseId, month, year, page, pageSize);
                req.setAttribute("receiptItems", items);
                break;
            }
            case "inventory-check": {
                totalItems = reportDAO.countInventoryCheckReport(warehouseId, month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<InventoryCheckReportItem> items = reportDAO.getInventoryCheckReport(warehouseId, month, year, page, pageSize);
                req.setAttribute("checkItems", items);
                break;
            }
            case "purchase": {
                totalItems = reportDAO.countPurchaseReport(warehouseId, month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<PurchaseOrder> items = reportDAO.getPurchaseReport(warehouseId, month, year, page, pageSize);
                req.setAttribute("poItems", items);
                break;
            }
            case "sales": {
                totalItems = reportDAO.countSalesReport(month, year);
                totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }
                List<SaleOrder> items = reportDAO.getSalesReport(month, year, page, pageSize);
                req.setAttribute("saleItems", items);
                break;
            }
        }

        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);

        req.getRequestDispatcher(view).forward(req, resp);
    }
    
    private void handleExport(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String type = req.getParameter("type");
        int month = LocalDate.now().getMonthValue();
        int year = LocalDate.now().getYear();
        try {
            month = Integer.parseInt(req.getParameter("month"));
        } catch (Exception e) {
        }
        try {
            year = Integer.parseInt(req.getParameter("year"));
        } catch (Exception e) {
        }

        Integer warehouseId = null;
        try {
            warehouseId = Integer.parseInt(req.getParameter("warehouseId"));
        } catch (Exception e) {
        }

        String warehouseName = "";
        if (warehouseId != null) {
            var wh = warehouseDAO.findById(warehouseId);
            if (wh != null) {
                warehouseName = wh.getName();
            }
        }

        XSSFWorkbook workbook = null;
        String filename = "BaoCao.xlsx";

        switch (type) {
            case "inventory": {
                var data = reportDAO.getAllInventoryReport(warehouseId, month, year);
                workbook = ReportExcelSupport.exportInventory(data, month, year, warehouseName);
                filename = "BaoCaoTonKho_T" + month + "_" + year + ".xlsx";
                break;
            }
            case "import": {
                var data = reportDAO.getImportExcelData(warehouseId, month, year);
                workbook = ReportExcelSupport.exportImport(data, month, year, warehouseName);
                filename = "BaoCaoNhap_T" + month + "_" + year + ".xlsx";
                break;
            }
            case "export": {
                var data = reportDAO.getExportExcelData(warehouseId, month, year);
                workbook = ReportExcelSupport.exportExport(data, month, year, warehouseName);
                filename = "BaoCaoXuat_T" + month + "_" + year + ".xlsx";
                break;
            }
            case "inventory-check": {
                var data = reportDAO.getAllInventoryCheckReport(warehouseId, month, year);
                workbook = ReportExcelSupport.exportInventoryCheck(data, month, year, warehouseName);
                filename = "BaoCaoKiemKe_T" + month + "_" + year + ".xlsx";
                break;
            }
            case "purchase": {
                var data = reportDAO.getPurchaseExcelData(warehouseId, month, year);
                workbook = ReportExcelSupport.exportPurchase(data, month, year, warehouseName);
                filename = "BaoCaoMua_T" + month + "_" + year + ".xlsx";
                break;
            }
            case "sales": {
                var data = reportDAO.getSalesExcelData(month, year);
                workbook = ReportExcelSupport.exportSales(data, month, year);
                filename = "BaoCaoBan_T" + month + "_" + year + ".xlsx";
                break;
            }
        }

        if (workbook == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=" + filename);
        try (OutputStream out = resp.getOutputStream()) {
            workbook.write(out);
        }
        workbook.close();
    }
}
