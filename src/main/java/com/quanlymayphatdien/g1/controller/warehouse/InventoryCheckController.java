package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.InventoryCheckDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.InventoryCheck;
import com.quanlymayphatdien.g1.entity.InventoryCheckDetail;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "InventoryCheckController", urlPatterns = {"/inventory-check"})
public class InventoryCheckController extends HttpServlet {

    private final InventoryCheckDAO checkDAO = new InventoryCheckDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        try {
            switch (action) {
                case "list":
                    viewList(request, response);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "detail":
                    viewDetail(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "InventoryCheckController.doGet", e.getMessage(), e);
            e.printStackTrace();
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
        try {
            switch (action) {
                case "save":
                    saveCheck(request, response);
                    break;
                case "update":
                    updateCheck(request, response);
                    break;
                case "complete":
                    completeCheck(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error("Quản lý kho", "InventoryCheckController.doPost", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void viewList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String whParam = request.getParameter("warehouseId");
        Integer warehouseId = (whParam != null && !whParam.isEmpty()) ? Integer.parseInt(whParam) : null;
        String status = request.getParameter("status");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalItems = checkDAO.countWithFilters(search, warehouseId, status);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<InventoryCheck> list = checkDAO.findWithFilters(search, warehouseId, status, page, pageSize);
        int fromIndex = totalItems == 0 ? 0 : (page - 1) * pageSize + 1;
        int toIndex = Math.min(page * pageSize, totalItems);

        request.setAttribute("checkList", list);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("search", search);
        request.setAttribute("selectedWarehouse", warehouseId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex);
        request.setAttribute("toIndex", toIndex);
        request.setAttribute("totalChecks", checkDAO.countTotal());
        request.setAttribute("doingCount", checkDAO.countByStatus("doing"));
        request.setAttribute("completedCount", checkDAO.countByStatus("completed"));

        request.getRequestDispatcher("/view/inventory-check/inventory-check-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String whParam = request.getParameter("warehouseId");
        Integer warehouseId = (whParam != null && !whParam.isEmpty()) ? Integer.parseInt(whParam) : null;

        request.setAttribute("warehouses", warehouseDAO.findAll());
        if (warehouseId != null) {
            request.setAttribute("selectedWarehouse", warehouseId);
            request.setAttribute("inventoryList", inventoryDAO.findByWarehouseId(warehouseId));
        }

        request.getRequestDispatcher("/view/inventory-check/inventory-check-create.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        int id = Integer.parseInt(idStr);
        InventoryCheck check = checkDAO.findById(id);
        if (check == null) {
            request.setAttribute("error", "Không tìm thấy phiếu kiểm kê");
            request.getRequestDispatcher("/view/inventory-check/inventory-check-detail.jsp").forward(request, response);
            return;
        }
        List<InventoryCheckDetail> details = checkDAO.findDetailsByCheckId(id);

        request.setAttribute("check", check);
        request.setAttribute("details", details);
        request.getRequestDispatcher("/view/inventory-check/inventory-check-detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        int id = Integer.parseInt(idStr);
        InventoryCheck check = checkDAO.findById(id);
        if (check == null) {
            response.sendRedirect(request.getContextPath() + "/inventory-check");
            return;
        }
        if (!"doing".equals(check.getStatus())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        List<InventoryCheckDetail> details = checkDAO.findDetailsByCheckId(id);

        request.setAttribute("check", check);
        request.setAttribute("details", details);
        request.setAttribute("warehouses", warehouseDAO.findAll());
        request.setAttribute("inventoryList", inventoryDAO.findByWarehouseId(check.getWarehouseId()));

        request.getRequestDispatcher("/view/inventory-check/inventory-check-edit.jsp").forward(request, response);
    }

    private void saveCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        String whParam = request.getParameter("warehouseId");
        String notes = request.getParameter("notes");
        String[] genIds = request.getParameterValues("generatorId");

        List<String> errors = new ArrayList<>();

        int warehouseId = 0;
        try {
            warehouseId = Integer.parseInt(whParam);
            if (warehouseId <= 0) errors.add("Vui lòng chọn kho");
        } catch (NumberFormatException e) {
            errors.add("Kho không hợp lệ");
        }

        List<InventoryCheckDetail> details = new ArrayList<>();
        if (genIds != null) {
            for (String gidStr : genIds) {
                int genId = Integer.parseInt(gidStr);
                com.quanlymayphatdien.g1.entity.Inventory inv = inventoryDAO.findByWarehouseAndGenerator(warehouseId, genId);
                int sysQty = (inv != null) ? inv.getQuantity() : 0;
                InventoryCheckDetail d = new InventoryCheckDetail();
                d.setGeneratorId(genId);
                d.setSystemQuantity(sysQty);
                d.setNotes(null);
                details.add(d);
            }
        }

        if (details.isEmpty()) {
            errors.add("Phải chọn ít nhất 1 máy để kiểm kê");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("toastType", "danger");
            request.setAttribute("toastMessage", "Tạo phiếu thất bại: " + String.join(", ", errors));
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.setAttribute("selectedWarehouse", warehouseId);
            request.setAttribute("inventoryList", inventoryDAO.findByWarehouseId(warehouseId));
            request.getRequestDispatcher("/view/inventory-check/inventory-check-create.jsp").forward(request, response);
            return;
        }

        InventoryCheck check = new InventoryCheck();
        check.setCheckCode(checkDAO.generateCheckCode());
        check.setWarehouseId(warehouseId);
        check.setNotes(notes);
        check.setCreatedBy(loggedUser.getId());

        int checkId = checkDAO.insert(check);
        if (checkId <= 0) {
            request.setAttribute("toastMessage", "Không thể tạo phiếu kiểm kê");
            request.setAttribute("toastType", "danger");
            request.setAttribute("warehouses", warehouseDAO.findAll());
            request.getRequestDispatcher("/view/inventory-check/inventory-check-create.jsp").forward(request, response);
            return;
        }

        checkDAO.insertDetailsBatch(checkId, details);

        session.setAttribute("toastMessage", "Tạo phiếu kiểm kê thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }

    private void updateCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("loggedUser");

        int checkId = Integer.parseInt(request.getParameter("checkId"));
        InventoryCheck existing = checkDAO.findById(checkId);
        if (existing == null || !"doing".equals(existing.getStatus())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String[] detailIds = request.getParameterValues("detailId");
        String[] actualQtys = request.getParameterValues("actualQuantity");
        String[] damagedQtys = request.getParameterValues("damagedQuantity");
        String[] detailNotes = request.getParameterValues("detailNote");

        List<InventoryCheckDetail> details = new ArrayList<>();
        if (detailIds != null) {
            for (int i = 0; i < detailIds.length; i++) {
                InventoryCheckDetail d = new InventoryCheckDetail();
                d.setId(Integer.parseInt(detailIds[i]));
                if (actualQtys != null && i < actualQtys.length && actualQtys[i] != null && !actualQtys[i].trim().isEmpty()) {
                    d.setActualQuantity(Integer.parseInt(actualQtys[i]));
                }
                if (damagedQtys != null && i < damagedQtys.length && damagedQtys[i] != null && !damagedQtys[i].trim().isEmpty()) {
                    d.setDamagedQuantity(Integer.parseInt(damagedQtys[i]));
                }
                if (detailNotes != null && i < detailNotes.length) {
                    d.setNotes(detailNotes[i]);
                }
                details.add(d);
            }
        }

        String notes = request.getParameter("notes");
        if (notes != null) {
            existing.setNotes(notes);
            checkDAO.update(existing);
        }

        checkDAO.updateDetailsBatch(checkId, details);

        session.setAttribute("toastMessage", "Cập nhật phiếu kiểm kê thành công");
        session.setAttribute("toastType", "success");
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }

    private void completeCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int checkId = Integer.parseInt(request.getParameter("id"));
        boolean ok = checkDAO.complete(checkId);
        if (ok) {
            session.setAttribute("toastMessage", "Hoàn thành kiểm kê");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Không thể hoàn thành phiếu kiểm kê");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/inventory-check?action=detail&id=" + checkId);
    }
}