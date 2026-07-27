/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse.inventory;

import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.GeneratorSummary;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Warehouse;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

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
        String search = request.getParameter("search");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                page = 1;
            }
        }

        int totalItems = warehouseDAO.countWithSearch(search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Warehouse> paginatedWarehouses = warehouseDAO.findWithSearch(search, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);
        request.setAttribute("warehouses", paginatedWarehouses);
        request.setAttribute("search", search);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);

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
                ignored.printStackTrace();
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
        request.setAttribute("selectedWarehouse", selectedWarehouse);

        // Neu co generator param => che do serial detail
        if (genParam != null && !genParam.isEmpty()) {
            handleSerialDetail(request, response, selectedWarehouse, genParam);
        } else {
            handleModelGroup(request, response, selectedWarehouse);
        }
    }

    private void handleModelGroup(HttpServletRequest request, HttpServletResponse response,
            Integer selectedWarehouse) throws ServletException, IOException {
        String search = request.getParameter("search");
        String brand = request.getParameter("brand");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                e.printStackTrace();
                page = 1;
            }
        }

        int totalItems = inventoryDAO.countGeneratorSummary(selectedWarehouse, search, brand);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<GeneratorSummary> summaries = inventoryDAO.findGeneratorSummary(selectedWarehouse, search, brand, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("generatorSummaries", summaries);
        request.setAttribute("search", search);
        request.setAttribute("brand", brand);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("viewMode", "group");
        request.getRequestDispatcher("/view/inventory/inventory-list.jsp").forward(request, response);
    }

    private void handleSerialDetail(HttpServletRequest request, HttpServletResponse response,
            Integer selectedWarehouse, String genParam) throws ServletException, IOException {
        Integer selectedGenerator = null;
        try {
            selectedGenerator = Integer.parseInt(genParam);
        } catch (NumberFormatException ignored) {
        }

        String status = request.getParameter("status");
        if (status == null) {
            status = "IN_STOCK";
        }
        String search = request.getParameter("search");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                e.printStackTrace();
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

        request.setAttribute("selectedGenerator", selectedGenerator);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("serialList", serialList);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("viewMode", "detail");

        GeneratorDAO gdao = new GeneratorDAO();
        List<Generator> gens = gdao.findAllActive();
        request.setAttribute("gens", gens);

        request.getRequestDispatcher("/view/inventory/inventory-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
