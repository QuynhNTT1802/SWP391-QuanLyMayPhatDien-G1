package com.quanlymayphatdien.g1.controller.warehouse.inventory;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Endpoint tra cuu serial phuc vu cho quet barcode o cac trang:
 *  - Tao phieu nhap / xuat kho
 *  - Kiem ke kho
 *
 * GET /inventory-lookup?action=scan&serial=XXX&warehouseId=YYY
 *  Tra ve JSON:
 *   {
 *     "found": true|false,
 *     "serialNumber": "...",
 *     "generatorId": int,
 *     "generatorModel": "...",
 *     "generatorBrand": "...",
 *     "currentWarehouseId": int,
 *     "currentWarehouseName": "...",
 *     "status": "IN_STOCK|SOLD|IN_TRANSIT|LIQUIDATED|...",
 *     "blocked": bool,
 *     "inTargetWarehouse": bool|null
 *   }
 */
@WebServlet(name = "InventoryLookupController", urlPatterns = {"/inventory-lookup"})
public class InventoryLookupController extends HttpServlet {

    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "scan";
        }

        try {
            switch (action) {
                case "scan":
                    handleScan(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quan ly kho", "InventoryLookupController.doGet", e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"found\":false,\"message\":\"Loi he thong\"}");
        }
    }

    private boolean isLoggedIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"found\":false,\"message\":\"Chua dang nhap\"}");
            return false;
        }
        return true;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isLoggedIn(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "scan";
        }

        try {
            switch (action) {
                case "scan":
                    handleScan(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quan ly kho", "InventoryLookupController.doPost", e.getMessage(), e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"found\":false,\"message\":\"Loi he thong\"}");
        }
    }

    private void handleScan(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String serial = request.getParameter("serial");
        if (serial != null) serial = serial.trim();
        Integer warehouseId = null;
        String whParam = request.getParameter("warehouseId");
        if (whParam != null && !whParam.isEmpty()) {
            try {
                warehouseId = Integer.parseInt(whParam);
            } catch (NumberFormatException ignored) {
            }
        }

        response.setContentType("application/json;charset=UTF-8");
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("serialNumber", serial);

        if (serial == null || serial.isEmpty()) {
            body.put("found", false);
            body.put("message", "Serial trong");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        Inventory inv = inventoryDAO.findBySerialNumber(serial);
        if (inv == null) {
            body.put("found", false);
            body.put("message", "Serial chua ton tai trong he thong");
            new Gson().toJson(body, response.getWriter());
            return;
        }

        body.put("found", true);
        body.put("inventoryId", inv.getInventoryId());
        body.put("generatorId", inv.getGeneratorId());
        body.put("generatorModel", inv.getGeneratorModel());
        body.put("generatorBrand", inv.getGeneratorBrand());
        body.put("currentWarehouseId", inv.getWarehouseId());
        body.put("currentWarehouseName", inv.getWarehouseName());
        body.put("status", inv.getStatus());

        boolean blocked = inventoryDAO.isSerialBlocked(serial);
        body.put("blocked", blocked);

        if (warehouseId != null) {
            boolean inStockAtWh = inventoryDAO.isInStockAtWarehouse(serial, warehouseId);
            body.put("inTargetWarehouse", inStockAtWh);
        }

        new Gson().toJson(body, response.getWriter());
    }
}
