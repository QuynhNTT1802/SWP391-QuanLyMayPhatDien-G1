/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Inventory;
import com.quanlymayphatdien.g1.entity.Warehouse;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "InventoryController", urlPatterns = {"/inventory"})
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
        List<Warehouse> warehouses = warehouseDAO.findAll();
        request.setAttribute("warehouses", warehouses);
        String whParam = request.getParameter("warehouse");
        Integer selectedWarehouse = null;
        if (whParam != null && !whParam.isEmpty()) {
            selectedWarehouse = Integer.parseInt(whParam);
        }
        List<Inventory> allItems = new ArrayList<>();
        List<Warehouse> warehouseGroups = new ArrayList<>();
        if (selectedWarehouse != null) {
            allItems = inventoryDAO.findByWarehouseId(selectedWarehouse);
            for (Warehouse wh : warehouses) {
                if (wh.getWarehouseId() == selectedWarehouse) {
                    wh.setItemCount(allItems.size());
                    warehouseGroups.add(wh);
                    break;
                }
            }
        } else {
            for (Warehouse wh : warehouses) {
                List<Inventory> whItems = inventoryDAO.findByWarehouseId(wh.getWarehouseId());
                if (!whItems.isEmpty()) {
                    wh.setItemCount(whItems.size());
                    warehouseGroups.add(wh);
                    allItems.addAll(whItems);
                }
            }
        }
        request.setAttribute("selectedWarehouse", selectedWarehouse);
        request.setAttribute("warehouseGroups", warehouseGroups);
        request.setAttribute("inventoryList", allItems);
        request.setAttribute("totalItems", allItems.size());
        request.getRequestDispatcher("/view/inventory/inventory-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
