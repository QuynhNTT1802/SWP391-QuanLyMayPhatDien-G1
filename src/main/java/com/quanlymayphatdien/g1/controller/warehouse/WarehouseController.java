package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.Warehouse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "WarehouseController", urlPatterns = {"/warehouse"})
public class WarehouseController extends HttpServlet {

    private final WarehouseDAO warehouseDAO = new WarehouseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewDetail(request, response);
                break;
            case "update":
                showUpdateForm(request, response);
                break;
            case "lock":
                lockWarehouse(request, response);
                break;
            case "unlock":
                unlockWarehouse(request, response);
                break;
            default:
                listWarehouses(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "update";
        }

        switch (action) {
            case "update":
                updateWarehouse(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/warehouse");
                break;
        }
    }

    private void listWarehouses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }
        int totalItems = warehouseDAO.countWithSearch(search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Warehouse> list = warehouseDAO.findWithSearch(search, page, pageSize);
        request.setAttribute("warehouses", list);
        request.setAttribute("search", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", totalItems == 0 ? 0 : (page - 1) * pageSize + 1);
        request.setAttribute("toIndex", Math.min(page * pageSize, totalItems));
        request.getRequestDispatcher("/view/warehouse/warehouse-list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        int id = Integer.parseInt(idStr);
        Warehouse w = warehouseDAO.findById(id);
        if (w == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }

        InventoryDAO invDAO = new InventoryDAO();
        int itemCount = invDAO.countByWarehouseId(id);
        w.setItemCount(itemCount);

        request.setAttribute("warehouse", w);
        request.getRequestDispatcher("/view/warehouse/warehouse-detail.jsp").forward(request, response);
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        int id = Integer.parseInt(idStr);
        Warehouse w = warehouseDAO.findById(id);
        if (w == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        request.setAttribute("warehouse", w);
        request.getRequestDispatcher("/view/warehouse/warehouse-update.jsp").forward(request, response);
    }

    private void updateWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        int id = Integer.parseInt(idStr);

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        Warehouse w = warehouseDAO.findById(id);
        if (w == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }

        w.setName(name);
        w.setAddress(address);
        w.setDescription(description);
        w.setUpdatedAt(LocalDateTime.now());

        boolean updated = warehouseDAO.update(w);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/warehouse?action=view&id=" + id + "&msg=updated");
        } else {
            request.setAttribute("warehouse", w);
            request.setAttribute("error", "Cập nhật thất bại");
            request.getRequestDispatcher("/view/warehouse/warehouse-update.jsp").forward(request, response);
        }
    }

    private void lockWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        int id = Integer.parseInt(idStr);
        Warehouse w = warehouseDAO.findById(id);
        if (w == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        HttpSession session = request.getSession();
        boolean ok = warehouseDAO.lock(id);
        if (ok) {
            session.setAttribute("toastMessage", "Đã khóa kho. Các máy trong kho đã bị ẩn khỏi danh sách tồn kho.");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Khóa kho thất bại!");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/warehouse");
    }

    private void unlockWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        int id = Integer.parseInt(idStr);
        Warehouse w = warehouseDAO.findById(id);
        if (w == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }
        HttpSession session = request.getSession();
        boolean ok = warehouseDAO.unlock(id);
        if (ok) {
            session.setAttribute("toastMessage", "Đã mở khóa kho. Các máy trong kho đã hiển thị lại trong tồn kho.");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Mở khóa kho thất bại!");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/warehouse");
    }
}
