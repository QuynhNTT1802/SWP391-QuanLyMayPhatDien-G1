/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse.inventory;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 *
 * @author FPTShop
 *
 * Moi serial = 1 dong trong bang inventory.
 * Trang /inventory/list liet ke tung serial voi cac filter (warehouse, generator, status, search).
 * Trang /inventory (overview) hien thi KPI tong ton theo COUNT(inventory WHERE IN_STOCK).
 */
@WebServlet(name = "InventoryController", urlPatterns = {"/inventory", "/inventory/*"})
public class InventoryController extends HttpServlet {

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

        String pathInfo = request.getPathInfo();
        boolean isList = pathInfo != null && pathInfo.equals("/list");

        List<Warehouse> warehouses = warehouseDAO.findAll();
        request.setAttribute("warehouses", warehouses);

        Map<Integer, Integer> itemCountMap = inventoryDAO.countInStockByWarehouse();
        Map<String, Integer> itemsByWhGen = inventoryDAO.countItemsByWarehouseAndGenerator();
        int activeWh = inventoryDAO.countActiveWarehouses();
        int lockedWh = inventoryDAO.countLockedWarehouses();
        long grandQty = inventoryDAO.grandTotalInStock();
        request.setAttribute("warehouseItemCount", itemCountMap);
        request.setAttribute("warehouseItemsByWhGen", itemsByWhGen);
        request.setAttribute("kpiActiveWarehouses", activeWh);
        request.setAttribute("kpiLockedWarehouses", lockedWh);
        request.setAttribute("kpiTotalQty", grandQty);
        request.setAttribute("kpiTotalWarehouses", activeWh + lockedWh);

        if (isList) {
            handleListView(request, response);
        } else {
            handleOverview(request, response);
        }
    }

    private void handleOverview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String whParam = request.getParameter("warehouse");
        Integer selectedWarehouse = null;
        if (whParam != null && !whParam.isEmpty()) {
            try {
                selectedWarehouse = Integer.parseInt(whParam);
            } catch (NumberFormatException ignored) {
            }
        }
        if (selectedWarehouse != null) {
            Warehouse sel = warehouseDAO.findById(selectedWarehouse);
            if (sel != null && "locked".equals(sel.getStatus())) {
                request.setAttribute("lockedWarehouseName", sel.getName());
                selectedWarehouse = null;
            }
        }
        request.getRequestDispatcher("/view/inventory/inventory-overview.jsp").forward(request, response);
    }

    private void handleListView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String whParam = request.getParameter("warehouse");
        Integer selectedWarehouse = null;
        if (whParam != null && !whParam.isEmpty()) {
            try {
                selectedWarehouse = Integer.parseInt(whParam);
            } catch (NumberFormatException ignored) {
                SystemLogger.warn(LogModule.INVENTORY, "InventoryController.doGet", "Lỗi định dạng kho: " + ignored.getMessage());
            }
        }
        if (selectedWarehouse != null) {
            Warehouse sel = warehouseDAO.findById(selectedWarehouse);
            if (sel != null && "locked".equals(sel.getStatus())) {
                request.setAttribute("lockedWarehouseName", sel.getName());
                request.setAttribute("lockedWarehouseId", sel.getWarehouseId());
                selectedWarehouse = null;
            }
        }

        String genParam = request.getParameter("generator");
        Integer selectedGenerator = null;
        if (genParam != null && !genParam.isEmpty()) {
            try {
                selectedGenerator = Integer.parseInt(genParam);
            } catch (NumberFormatException ignored) {
            }
        }

        String status = request.getParameter("status");
        String search = request.getParameter("search");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                SystemLogger.warn(LogModule.INVENTORY, "InventoryController.doGet", "Lỗi định dạng trang: " + e.getMessage());
                page = 1;
            }
        }

        int totalItems = inventoryDAO.countByFilters(selectedWarehouse, selectedGenerator, status, search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Inventory> serialList = inventoryDAO.findByFilters(selectedWarehouse, selectedGenerator, status, search, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("selectedWarehouse", selectedWarehouse);
        request.setAttribute("selectedGenerator", selectedGenerator);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("serialList", serialList);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.getRequestDispatcher("/view/inventory/inventory-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
