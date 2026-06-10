package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.InventoryDAO;
import com.quanlymayphatdien.g1.dal.WarehouseDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.entity.Warehouse;
import com.quanlymayphatdien.g1.utils.SystemLogger;
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
    private final ActivityLogDAO logDAO = new ActivityLogDAO();
    private static final String ENTITY_TYPE = "warehouse";

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

        String tab = request.getParameter("tab");
        boolean isHistory = "history".equals(tab);
        request.setAttribute("currentTab", isHistory ? "history" : "info");

        if (isHistory) {
            String logSearch = request.getParameter("logSearch");
            String logAction = request.getParameter("logAction");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");

            int page = 1;
            int pageSize = 20;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException ignored) {
                    page = 1;
                }
            }

            List<ActivityLog> logs = logDAO.findByEntityTypeAndId2(ENTITY_TYPE, id, logSearch, logAction,
                    dateFrom, dateTo, page, pageSize);
            int totalLogs = logDAO.countByEntityTypeAndId2(ENTITY_TYPE, id, logSearch, logAction,
                    dateFrom, dateTo);

            int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
            if (page > totalPages) page = totalPages;

            request.setAttribute("logList", logs);
            request.setAttribute("logPage", page);
            request.setAttribute("logTotalPages", totalPages);
            request.setAttribute("totalLogs", totalLogs);
            request.setAttribute("logSearch", logSearch != null ? logSearch : "");
            request.setAttribute("logAction", logAction != null ? logAction : "");
            request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
            request.setAttribute("dateTo", dateTo != null ? dateTo : "");
        }

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

        Warehouse oldW = warehouseDAO.findById(id);
        if (oldW == null) {
            response.sendRedirect(request.getContextPath() + "/warehouse");
            return;
        }

        Warehouse w = new Warehouse();
        w.setWarehouseId(id);
        w.setName(name);
        w.setAddress(address);
        w.setDescription(description);
        w.setStatus(oldW.getStatus());
        w.setUpdatedAt(LocalDateTime.now());

        boolean updated = warehouseDAO.update(w);
        if (updated) {
            logUpdate(request, id, w, oldW);
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
        String oldStatus = w.getStatus();
        boolean ok = warehouseDAO.lock(id);
        if (ok) {
            logLock(request, id, w.getName(), oldStatus);
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
        String oldStatus = w.getStatus();
        boolean ok = warehouseDAO.unlock(id);
        if (ok) {
            logUnlock(request, id, w.getName(), oldStatus);
            session.setAttribute("toastMessage", "Đã mở khóa kho. Các máy trong kho đã hiển thị lại trong tồn kho.");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Mở khóa kho thất bại!");
            session.setAttribute("toastType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/warehouse");
    }

    private String statusLabel(String status) {
        if ("active".equals(status)) {
            return "Hoạt động";
        }
        if ("locked".equals(status)) {
            return "Bị khóa";
        }
        if ("deactive".equals(status) || "inactive".equals(status)) {
            return "Ngưng hoạt động";
        }
        return status != null ? status : "";
    }

    private String normalizeLogString(String s) {
        return (s == null || s.trim().isEmpty()) ? "(trống)" : s.trim();
    }

    private void logUpdate(HttpServletRequest request, int entityId, Warehouse newW, Warehouse oldW) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }

            String username = user.getName() != null ? user.getName() : user.getUsername();

            String oldName = oldW.getName();
            String newName = newW.getName();
            String oldAddress = oldW.getAddress() != null ? oldW.getAddress() : "";
            String newAddress = newW.getAddress() != null ? newW.getAddress() : "";
            String oldDesc = oldW.getDescription() != null ? oldW.getDescription() : "";
            String newDesc = newW.getDescription() != null ? newW.getDescription() : "";

            boolean nameChanged = !newName.equals(oldName);
            boolean addressChanged = !newAddress.equals(oldAddress);
            boolean descChanged = !newDesc.equals(oldDesc);

            if (!nameChanged && !addressChanged && !descChanged) {
                return;
            }

            StringBuilder desc = new StringBuilder();
            desc.append(username).append(" đã cập nhật kho '").append(oldName).append("'");

            java.util.List<String> changes = new java.util.ArrayList<>();
            if (nameChanged) {
                changes.add("Tên: " + normalizeLogString(oldName) + " -> " + normalizeLogString(newName));
            }
            if (addressChanged) {
                changes.add("Địa chỉ: " + normalizeLogString(oldAddress) + " -> " + normalizeLogString(newAddress));
            }
            if (descChanged) {
                changes.add("Mô tả: " + normalizeLogString(oldDesc) + " -> " + normalizeLogString(newDesc));
            }

            if (!changes.isEmpty()) {
                desc.append(" — ").append(String.join(", ", changes));
            }

            insertLog(user, entityId, newName, "UPDATE", desc.toString());
        } catch (Exception e) {
            SystemLogger.error("quản lý kho", "WarehouseController.logUpdate", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void logLock(HttpServletRequest request, int entityId, String name, String oldStatus) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }
            String username = user.getName() != null ? user.getName() : user.getUsername();
            String description = username + " đã khóa kho '" + name + "' — Trạng thái: " + statusLabel(oldStatus) + " -> " + statusLabel("locked");
            insertLog(user, entityId, name, "LOCK", description);
        } catch (Exception e) {
            SystemLogger.error("quản lý kho", "WarehouseController.logLock", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void logUnlock(HttpServletRequest request, int entityId, String name, String oldStatus) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }
            String username = user.getName() != null ? user.getName() : user.getUsername();
            String description = username + " đã mở khóa kho '" + name + "' — Trạng thái: " + statusLabel(oldStatus) + " -> " + statusLabel("active");
            insertLog(user, entityId, name, "UNLOCK", description);
        } catch (Exception e) {
            SystemLogger.error("quản lý kho", "WarehouseController.logUnlock", e.getMessage(), e);
            e.printStackTrace();
        }
    }

    private void insertLog(User user, int entityId, String entityName, String action, String description) {
        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType(ENTITY_TYPE);
        log.setAction(action);
        log.setEntityId(entityId);
        log.setEntityName(entityName);
        log.setDetails(description);
        logDAO.insert(log);
    }
}
