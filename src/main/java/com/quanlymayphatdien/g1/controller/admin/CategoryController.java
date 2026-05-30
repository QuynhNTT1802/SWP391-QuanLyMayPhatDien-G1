/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CategoryExtensionDAO;
import com.quanlymayphatdien.g1.entity.*;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "CategoryController",
        urlPatterns = {"/admin/categories",
            "/admin/category/edit",
            "/admin/category/save",
            "/admin/category/delete"})
public class CategoryController extends HttpServlet {

    private final CategoryDAO cateDAO = new CategoryDAO();
    private final ActivityLogDAO logDAO= new ActivityLogDAO();

    private static final Map<String, String> TYPE_LABELS = new LinkedHashMap<>();

    static {
        TYPE_LABELS.put("brand", "Thương hiệu");
        TYPE_LABELS.put("fuel_type", "Nhiên liệu");
        TYPE_LABELS.put("phase", "Pha");
        TYPE_LABELS.put("generator_type", "Loại máy");
        TYPE_LABELS.put("condition", "Tình trạng");
        TYPE_LABELS.put("origin", "Xuất xứ");
        TYPE_LABELS.put("receipt_reason", "Lý do xuất nhập");
        TYPE_LABELS.put("receipt_status", "Trạng thái phiếu");
        TYPE_LABELS.put("customer_type", "Loại khách hàng");
        TYPE_LABELS.put("order_status", "Trạng thái đơn");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        try {
            if ("/admin/categories".equals(action)) {
                viewCategoryList(request, response);
            } else if ("/admin/category/edit".equals(action)) {
                viewCategoryEdit(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        try {
            if ("/admin/category/save".equals(action)) {
                saveCategory(request, response);
            } else if ("/admin/category/delete".equals(action)) {
                deleteCategory(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void viewCategoryList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String typeFilter = request.getParameter("type");
        String module = request.getParameter("module");
        if (module == null || module.trim().isEmpty()) {
            module = "quản lý vật tư";
        }
        
        String tab = request.getParameter("tab");
        if("history".equals(tab)){
            showHistory(request, response, module);
            return;
        }

        List<Category> list;
        if (typeFilter != null && !typeFilter.trim().isEmpty() && search != null && !search.trim().isEmpty()) {
            list = cateDAO.searchByTypeAndModule(typeFilter, module, search.trim());
        } else if (search != null && !search.trim().isEmpty()) {
            list = cateDAO.searchByName(search.trim());
            List<Category> filtered = new ArrayList<>();
            for (Category c : list) {
                if (module.equals(c.getModule())) {
                    filtered.add(c);
                }
            }
            list = filtered;
        } else {
            list = cateDAO.findByModule(module);
        }

        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            List<Category> filtered = new ArrayList<>();
            for (Category c : list) {
                if (typeFilter.equals(c.getType())) {
                    filtered.add(c);
                }
            }
            list = filtered;
        }

        // --- Filter theo trạng thái (active / inactive / tất cả) ---
        String statusFilter = request.getParameter("status");
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equals(statusFilter)) {
            List<Category> filtered = new ArrayList<>();
            for (Category c : list) {
                if (statusFilter.equals(c.getStatus())) {
                    filtered.add(c);
                }
            }
            list = filtered;
        }

        int totalItems = list.size();

        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            int page = 1, pageSize = 12;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
            if (page > totalPages) page = totalPages;
            int from = (page - 1) * pageSize;
            int to = Math.min(from + pageSize, totalItems);

            request.setAttribute("categoryList", list.subList(from, to));
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("fromIndex", from + 1);
            request.setAttribute("toIndex", to);
            request.setAttribute("currentType", typeFilter);
            request.setAttribute("typeLabel", TYPE_LABELS.getOrDefault(typeFilter, typeFilter));
            // Giữ state statusFilter cho JSP
            request.setAttribute("currentStatus", statusFilter != null ? statusFilter : "");

            List<Integer> catIds = new ArrayList<>();
            for (Category c : list) catIds.add(c.getId());
            request.setAttribute("extensions", new CategoryExtensionDAO().loadExtensionsByType(typeFilter, catIds));
        } else {
            request.setAttribute("categoryList", list);
            Map<String, Integer> typeCounts = new LinkedHashMap<>();
            for (Category c : list) typeCounts.merge(c.getType(), 1, Integer::sum);
            request.setAttribute("typeCounts", typeCounts);
        }
        
        List<String> types = cateDAO.getTypesByModule(module);
        request.setAttribute("types", types);
        request.setAttribute("typeLabels", TYPE_LABELS);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("currentModule", module);
        request.setAttribute("moduleLabel", getModuleLabel(module));
        request.getRequestDispatcher("/view/admin/admin-category.jsp").forward(request, response);
    }

    private void viewCategoryEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idVar = request.getParameter("id");
        if (idVar != null && !idVar.isEmpty()) {
            try {
                int id = Integer.parseInt(idVar);
                Category found = cateDAO.findById(id);
                if (found != null) {
                    request.setAttribute("category", found);
                    CategoryExtensionDAO extDAO = new CategoryExtensionDAO();
                    request.setAttribute("extension", extDAO.findExtension(found.getType(), id));
                    // không log VIEW_DETAIL vào lịch sử
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String module = request.getParameter("module");
        if (module == null || module.trim().isEmpty()) {
            module = "quản lý vật tư";
        }

        request.setAttribute("types", cateDAO.getTypesByModule(module));
        request.setAttribute("typeLabels", TYPE_LABELS);
        request.setAttribute("currentModule", module);
        request.setAttribute("moduleLabel", getModuleLabel(module));
        
        request.getRequestDispatcher("/view/admin/admin-category-edit.jsp").forward(request, response);
    }

    private void saveCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idVar = request.getParameter("id");
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        String desc = request.getParameter("description");
        String status = request.getParameter("status");
        String module = request.getParameter("module");

        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên danh mục không được để trống");
        } else {
            name = name.trim();
            if (name.length() > 100) {
                errors.add("Tên danh mục không được vượt quá 100 ký tự");
            }
        }

        if (type == null || type.trim().isEmpty()) {
            errors.add("Loại danh mục không được để trống");
        }

        if (desc != null && desc.length() > 500) {
            errors.add("Mô tả không được vượt quá 500 ký tự");
        }

        if (status == null) {
            status = "active";
        } else if (!"active".equals(status) && !"inactive".equals(status)) {
            errors.add("Trạng thái không hợp lệ");
        }

        if (!errors.isEmpty()) {
            Category c = new Category();
            c.setName(name);
            c.setType(type);
            c.setDescription(desc);
            c.setStatus(status);
            c.setModule(module);
            if (idVar != null && !idVar.isEmpty()) c.setId(Integer.parseInt(idVar));
            request.setAttribute("category", c);
            request.setAttribute("errors", errors);
            List<String> types;
            if (module != null && !module.trim().isEmpty()) {
                types = cateDAO.getTypesByModule(module);
            } else {
                types = cateDAO.getDistrictTypes();
            }
            request.setAttribute("types", types);
            request.setAttribute("typeLabels", TYPE_LABELS);
            request.setAttribute("currentModule", module);
            request.setAttribute("moduleLabel", getModuleLabel(module));
            request.getRequestDispatcher("/view/admin/admin-category-edit.jsp").forward(request, response);
            return;
        }

        int existingId = 0;
        if (idVar != null && !idVar.isEmpty() && !"0".equals(idVar)) {
            existingId = Integer.parseInt(idVar);
        }
        if (cateDAO.existsByNameAndTypeAndModule(name, type, module, existingId)) {
            errors.add("Danh mục \"" + name + "\" đã tồn tại trong cùng loại và module");
            Category c = new Category();
            c.setName(name);
            c.setType(type);
            c.setDescription(desc);
            c.setStatus(status);
            c.setModule(module);
            if (existingId > 0) c.setId(existingId);
            request.setAttribute("category", c);
            request.setAttribute("errors", errors);
            List<String> types;
            if (module != null && !module.trim().isEmpty()) {
                types = cateDAO.getTypesByModule(module);
            } else {
                types = cateDAO.getDistrictTypes();
            }
            request.setAttribute("types", types);
            request.setAttribute("typeLabels", TYPE_LABELS);
            request.setAttribute("currentModule", module);
            request.setAttribute("moduleLabel", getModuleLabel(module));
            request.getRequestDispatcher("/view/admin/admin-category-edit.jsp").forward(request, response);
            return;
        }

        Category category = new Category();
        category.setName(name);
        category.setType(type);
        category.setDescription(desc);
        category.setStatus(status);
        category.setModule(module);

        int categoryId;
        boolean isUpdate = idVar != null && !idVar.isEmpty() && !"0".equals(idVar);
        if (isUpdate) {
            categoryId = Integer.parseInt(idVar);
            // Đọc giá trị cũ TRƯỚC khi lưu để so sánh trước → sau
            Category oldCategory = cateDAO.findById(categoryId);
            category.setId(categoryId);
            cateDAO.update(category);
            logUpdate(request, categoryId, name, type, status, oldCategory, module);
        } else {
            categoryId = cateDAO.insert(category);
            logCreate(request, categoryId, name, type, status, module);
        }

        if (categoryId > 0) {
            saveExtensionData(request, categoryId, type);
        }

        String redirectModule = (module != null && !module.trim().isEmpty()) ? module : "quản lý vật tư";
        String redirectType = request.getParameter("redirectType");
        String redirectUrl = request.getContextPath() + "/admin/categories?module=" + URLEncoder.encode(redirectModule, StandardCharsets.UTF_8) + "&msg=success";
        if (redirectType != null && !redirectType.trim().isEmpty()) {
            redirectUrl += "&type=" + URLEncoder.encode(redirectType, StandardCharsets.UTF_8);
        }
        response.sendRedirect(redirectUrl);
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idVar = request.getParameter("id");
        String module = request.getParameter("module");
        String typeFilter = request.getParameter("type");

        if (idVar != null && !idVar.isEmpty()) {
            try {
                int id = Integer.parseInt(idVar);
                Category c = cateDAO.findById(id);
                if (c != null) {
                    cateDAO.delete(c);
                    logDelete(request, id, c.getName(), c.getType(), c.getStatus(), c.getModule());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        String redirectModule = (module != null && !module.trim().isEmpty()) ? module : "quản lý vật tư";
        String redirectUrl = request.getContextPath() + "/admin/categories?module=" + URLEncoder.encode(redirectModule, StandardCharsets.UTF_8) + "&msg=deleted";
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            redirectUrl += "&type=" + URLEncoder.encode(typeFilter, StandardCharsets.UTF_8);
        }
        response.sendRedirect(redirectUrl);
    }

    private void saveExtensionData(HttpServletRequest request, int categoryId, String type) {
        CategoryExtensionDAO extDAO = new CategoryExtensionDAO();
        switch (type) {
            case "brand": {
                CategoryBrand b = new CategoryBrand();
                b.setCategoryId(categoryId);
                b.setCountry(request.getParameter("country"));
                b.setWebsite(request.getParameter("website"));
                String fy = request.getParameter("foundedYear");
                if (fy != null && !fy.trim().isEmpty()) b.setFoundedYear(Integer.parseInt(fy));
                String wp = request.getParameter("warrantyPeriod");
                if (wp != null && !wp.trim().isEmpty()) b.setWarrantyPeriod(Integer.parseInt(wp));
                extDAO.saveBrand(b);
                break;
            }
            case "fuel_type": {
                CategoryFuelType ft = new CategoryFuelType();
                ft.setCategoryId(categoryId);
                ft.setUnit(request.getParameter("unit"));
                String tp = request.getParameter("typicalPrice");
                if (tp != null && !tp.trim().isEmpty()) ft.setTypicalPrice(new java.math.BigDecimal(tp));
                extDAO.saveFuelType(ft);
                break;
            }
            case "origin": {
                CategoryOrigin o = new CategoryOrigin();
                o.setCategoryId(categoryId);
                o.setCountryCode(request.getParameter("country_code"));
                extDAO.saveOrigin(o);
                break;
            }
            case "customer_type": {
                CategoryCustomerType ct = new CategoryCustomerType();
                ct.setCategoryId(categoryId);
                ct.setTaxType(request.getParameter("taxType"));
                extDAO.saveCustomerType(ct);
                break;
            }
            default: {
                String tableName = getExtensionTableName(type);
                if (tableName != null) extDAO.insertEmptyExtension(tableName, categoryId);
                break;
            }
        }
    }

    private String getExtensionTableName(String type) {
        if (type == null) return null;
        switch (type) {
            case "generator_type": return "category_generator_type";
            case "phase":          return "category_phase";
            case "condition":      return "category_condition";
            case "receipt_reason": return "category_receipt_reason";
            case "receipt_status": return "category_receipt_status";
            case "order_status":   return "category_order_status";
            default:               return null;
        }
    }

    private String getModuleLabel(String module) {
        if (module == null) return "Danh mục";
        switch (module) {
            case "quản lý vật tư":            return "Danh mục vật tư";
            case "quản lý phiếu xuất nhập":    return "Danh mục phiếu xuất nhập";
            case "quản lý phiếu mua bán":      return "Danh mục phiếu mua bán";
            case "quản lý kiểm kê":            return "Danh mục kiểm kê";
            default:                           return "Danh mục";
        }
    }
    
    // --------------- Hệ thống ghi log ---------------

    /** Nhãn hiển thị tiếng Việt cho trạng thái */
    private String statusLabel(String status) {
        if ("active".equals(status))   return "Hoạt động";
        if ("inactive".equals(status)) return "Không hoạt động";
        return status != null ? status : "";
    }

    /**
     * Log thêm mới danh mục.
     * Định dạng: Thêm mới: 'Honda' (Thương hiệu) — Trạng thái: Hoạt động
     */
    private void logCreate(HttpServletRequest request, Integer entityId,
                           String name, String type, String status, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) return;

            String typeLabel   = TYPE_LABELS.getOrDefault(type, type);
            String statusLabel = statusLabel(status);

            String description = "Thêm mới: '" + name + "' (" + typeLabel + ") — Trạng thái: " + statusLabel;

            insertLog(user, entityId, name, "CREATE", description);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Log cập nhật danh mục: chỉ mô tả các trường thực sự thay đổi (tên và trạng thái).
     * Định dạng ví dụ:
     *   - Chỉ đổi tên: Nguyễn Văn A đã cập nhật 'Honda' thành 'Honda Generator' (Thương hiệu)
     *   - Chỉ đổi trạng thái: Nguyễn Văn A đã cập nhật 'Honda' (Thương hiệu) — Trạng thái: Hoạt động thành Không hoạt động
     *   - Cả hai: Nguyễn Văn A đã cập nhật 'Honda' thành 'Honda Generator' (Thương hiệu) — Trạng thái: Hoạt động thành Không hoạt động
     */
    private void logUpdate(HttpServletRequest request, Integer entityId,
                           String newName, String type, String newStatus,
                           Category oldCategory, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) return;

            String username  = user.getName() != null ? user.getName() : user.getUsername();
            String typeLabel = TYPE_LABELS.getOrDefault(type, type);

            String oldName   = oldCategory != null ? oldCategory.getName()   : newName;
            String oldStatus = oldCategory != null ? oldCategory.getStatus() : newStatus;

            boolean nameChanged   = !newName.equals(oldName);
            boolean statusChanged = !newStatus.equals(oldStatus);

            // Nếu không có gì thay đổi, không cần ghi log
            if (!nameChanged && !statusChanged) return;

            StringBuilder desc = new StringBuilder();
            desc.append(username).append(" đã cập nhật '");

            if (nameChanged) {
                desc.append(oldName).append("' thành '").append(newName).append("' (").append(typeLabel).append(")");
            } else {
                desc.append(newName).append("' (").append(typeLabel).append(")");
            }

            if (statusChanged) {
                desc.append(" — Trạng thái: ")
                    .append(statusLabel(oldStatus))
                    .append(" thành ")
                    .append(statusLabel(newStatus));
            }

            insertLog(user, entityId, newName, "UPDATE", desc.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Log xóa danh mục.
     * Định dạng: Xóa: 'Honda' (Thương hiệu) — Trạng thái trước: Hoạt động
     */
    private void logDelete(HttpServletRequest request, Integer entityId,
                           String name, String type, String status, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) return;

            String typeLabel   = TYPE_LABELS.getOrDefault(type, type);
            String statusLabel = statusLabel(status);

            // Nhúng module vào details để fallback khi category đã xóa khỏi DB
            String description = "Xóa: '" + name + "' (" + typeLabel + ") — Trạng thái trước: " + statusLabel
                               + " | module:" + (module != null ? module : "");

            insertLog(user, entityId, name, "DELETE", description);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Hàm nội bộ để insert ActivityLog vào DB */
    private void insertLog(User user, Integer entityId, String entityName,
                           String action, String description) {
        ActivityLog log = new ActivityLog();
        log.setUserId(user.getId());
        log.setEntityType("categories");
        log.setAction(action);
        log.setEntityId(entityId);
        log.setEntityName(entityName);
        log.setDetails(description);
        logDAO.insert(log);
    }

    private void showHistory(HttpServletRequest request, HttpServletResponse response, String module) 
        throws ServletException, IOException {

        // --- Đọc các tham số filter ---
        String logSearch  = request.getParameter("logSearch");   // từ khóa: tên đối tượng / người dùng
        String logAction  = request.getParameter("logAction");   // hành động: CREATE, UPDATE, DELETE...
        String dateFrom   = request.getParameter("dateFrom");    // ngày bắt đầu yyyy-MM-dd
        String dateTo     = request.getParameter("dateTo");      // ngày kết thúc yyyy-MM-dd

        // --- Đọc trang hiện tại ---
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int pageSize = 20;

        // --- Gọi DAO có filter thay vì findByEntityType ---
        List<ActivityLog> logs = logDAO.findByModuleFilter(
                module, logSearch, logAction, dateFrom, dateTo, page, pageSize);
        int totalLogs = logDAO.countByModuleFilter(
                module, logSearch, logAction, dateFrom, dateTo);

        int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        // --- Set attributes cho JSP ---
        request.setAttribute("logList",        logs);
        request.setAttribute("logPage",        page);
        request.setAttribute("logTotalPages",  totalPages);
        request.setAttribute("totalLogs",      totalLogs);
        request.setAttribute("currentTab",     "history");
        request.setAttribute("currentModule",  module);
        request.setAttribute("moduleLabel",    getModuleLabel(module));

        // Trả state filter về JSP để giữ giá trị form + link phân trang
        request.setAttribute("logSearch",  logSearch  != null ? logSearch  : "");
        request.setAttribute("logAction",  logAction  != null ? logAction  : "");
        request.setAttribute("dateFrom",   dateFrom   != null ? dateFrom   : "");
        request.setAttribute("dateTo",     dateTo     != null ? dateTo     : "");

        request.getRequestDispatcher("/view/admin/admin-category.jsp").forward(request, response);
    }
}
