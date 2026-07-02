/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CategoryExtensionDAO;
import com.quanlymayphatdien.g1.entity.*;
import com.quanlymayphatdien.g1.utils.CategoryExcelSupport;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "CategoryController",
        urlPatterns = {"/admin/categories",
            "/admin/category/edit",
            "/admin/category/save",
            "/admin/category/delete",
            "/admin/category/export",
            "/admin/category/template",
            "/admin/category/import-preview",
            "/admin/category/import-confirm"})

@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class CategoryController extends HttpServlet {

    private final CategoryDAO cateDAO = new CategoryDAO();
    private final ActivityLogDAO logDAO = new ActivityLogDAO();

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
        TYPE_LABELS.put("liquidation_reason", "Lý do thanh lý");
        TYPE_LABELS.put("manager_reject_reason", "Lý do quản lý từ chối");
        TYPE_LABELS.put("manager_request_edit_reason", "Lý do quản lý yêu cầu sửa");
        TYPE_LABELS.put("ceo_reject_reason", "Lý do CEO từ chối");
        TYPE_LABELS.put("ceo_request_edit_reason", "Lý do CEO yêu cầu sửa");
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
            } else if ("/admin/category/export".equals(action)) {
                exportCategoryExcel(request, response);
            } else if ("/admin/category/template".equals(action)) {
                downloadCategoryTemplate(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.CATEGORY, "CategoryController",
                    "Lỗi xử lý GET " + action + ": " + e.getMessage(), e);
            throw new ServletException(e);
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
            } else if ("/admin/category/import-preview".equals(action)) {
                importCategoryPreview(request, response);
            } else if ("/admin/category/import-confirm".equals(action)) {
                importCategoryConfirm(request, response);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.CATEGORY, "CategoryController",
                    "Lỗi xử lý POST " + action + ": " + e.getMessage(), e);
            throw new ServletException(e);
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


        int kpiTotal = list.size();
        int kpiActive = 0;
        int kpiInactive = 0;
        for (Category c : list) {
            if ("active".equals(c.getStatus())) {
                kpiActive++;
            } else {
                kpiInactive++;
            }
        }
        request.setAttribute("kpiTotal", kpiTotal);
        request.setAttribute("kpiActive", kpiActive);
        request.setAttribute("kpiInactive", kpiInactive);


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
            request.setAttribute("currentType", typeFilter);
            request.setAttribute("typeLabel", TYPE_LABELS.getOrDefault(typeFilter, typeFilter));
            request.setAttribute("currentStatus", statusFilter != null ? statusFilter : "");
            request.setAttribute("currentTab", tab);

            if ("history".equals(tab)) {
                String logSearch = request.getParameter("logSearch");
                String logAction = request.getParameter("logAction");
                String dateFrom = request.getParameter("dateFrom");
                String dateTo = request.getParameter("dateTo");

                int page = 1, pageSize = 20;
                String pageStr = request.getParameter("page");
                if (pageStr != null && !pageStr.isEmpty()) {
                    try {
                        page = Math.max(1, Integer.parseInt(pageStr));
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }

                List<ActivityLog> logs = logDAO.findByTypeAndModuleFilter(module, typeFilter, logSearch, logAction, dateFrom, dateTo, page, pageSize);
                int totalLogs = logDAO.countByTypeAndModuleFilter(module, typeFilter, logSearch, logAction, dateFrom, dateTo);

                int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
                if (page > totalPages) {
                    page = totalPages;
                }

                request.setAttribute("logList", logs);
                request.setAttribute("logPage", page);
                request.setAttribute("logTotalPages", totalPages);
                request.setAttribute("totalLogs", totalLogs);
                request.setAttribute("logSearch", logSearch != null ? logSearch : "");
                request.setAttribute("logAction", logAction != null ? logAction : "");
                request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
                request.setAttribute("dateTo", dateTo != null ? dateTo : "");
            } else {
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
                if (page > totalPages) {
                    page = totalPages;
                }
                int from = (page - 1) * pageSize;
                int to = Math.min(from + pageSize, totalItems);

                request.setAttribute("categoryList", list.subList(from, to));
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalItems", totalItems);
                request.setAttribute("fromIndex", from + 1);
                request.setAttribute("toIndex", to);

                List<Integer> catIds = new ArrayList<>();
                for (Category c : list) {
                    catIds.add(c.getId());
                }
                request.setAttribute("extensions", new CategoryExtensionDAO().loadExtensionsByType(typeFilter, catIds));
            }
        } else {
            
            // Danh sách toàn bộ các danh mục 
            Map<String, Integer> typeCounts = new LinkedHashMap<>();
            for (Category c : list) {
                typeCounts.merge(c.getType(), 1, Integer::sum);
            }
            request.setAttribute("typeCounts", typeCounts);
            request.setAttribute("typeMinIds", cateDAO.getMinIdByType(module));


            int page = 1, pageSize = 10;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
            if (page > totalPages) {
                page = totalPages;
            }
            int from = (page - 1) * pageSize;
            int to = Math.min(from + pageSize, totalItems);

            request.setAttribute("categoryList", list.subList(from, to));
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("fromIndex", totalItems > 0 ? from + 1 : 0);
            request.setAttribute("toIndex", to);

            request.setAttribute("currentStatus", statusFilter != null ? statusFilter : "");
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
                    Object ext = extDAO.findExtension(found.getType(), id);
                    if ("brand".equals(found.getType())) {
                        request.setAttribute("brandExt", ext);
                    } else if ("fuel_type".equals(found.getType())) {
                        request.setAttribute("fuelExt", ext);
                    } else if ("origin".equals(found.getType())) {
                        request.setAttribute("originExt", ext);
                    } else if ("customer_type".equals(found.getType())) {
                        request.setAttribute("customerExt", ext);
                    }

                    String histSearch = request.getParameter("histSearch");
                    String historyAction = request.getParameter("historyAction");
                    String histDateFrom = request.getParameter("histDateFrom");
                    String histDateTo = request.getParameter("histDateTo");

                    int histPage = 1;
                    String histPageStr = request.getParameter("histPage");
                    if (histPageStr != null && !histPageStr.isEmpty()) {
                        try {
                            histPage = Math.max(1, Integer.parseInt(histPageStr));
                        } catch (NumberFormatException ignored) {
                            histPage = 1;
                        }
                    }
                    int histPageSize = 10;
                    List<ActivityLog> historyLogs = logDAO.findByEntityId(id, histSearch, historyAction, histDateFrom, histDateTo, histPage, histPageSize);
                    int histTotalLogs = logDAO.countByEntityId(id, histSearch, historyAction, histDateFrom, histDateTo);
                    int histTotalPages = Math.max(1, (int) Math.ceil((double) histTotalLogs / histPageSize));
                    if (histPage > histTotalPages) {
                        histPage = histTotalPages;
                    }

                    request.setAttribute("historyLogs", historyLogs);
                    request.setAttribute("histPage", histPage);
                    request.setAttribute("histTotalPages", histTotalPages);
                    request.setAttribute("histTotalLogs", histTotalLogs);
                    request.setAttribute("histSearch", histSearch != null ? histSearch : "");
                    request.setAttribute("historyAction", historyAction != null ? historyAction : "");
                    request.setAttribute("histDateFrom", histDateFrom != null ? histDateFrom : "");
                    request.setAttribute("histDateTo", histDateTo != null ? histDateTo : "");


                    String activeTab = request.getParameter("activeTab");
                    request.setAttribute("activeTab", "history".equals(activeTab) ? "history" : "info");
                }
            } catch (Exception e) {
                SystemLogger.error(LogModule.CATEGORY, "CategoryController.viewCategoryEdit", e.getMessage(), e);
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
            if (idVar != null && !idVar.isEmpty()) {
                c.setId(Integer.parseInt(idVar));
            }
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
            if (existingId > 0) {
                c.setId(existingId);
            }
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

            Category oldCategory = cateDAO.findById(categoryId);
            category.setId(categoryId);
            cateDAO.update(category);
            logUpdate(request, categoryId, category, oldCategory, module);
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
                SystemLogger.error(LogModule.CATEGORY, "CategoryController.deleteCategory", e.getMessage(), e);
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
                if (fy != null && !fy.trim().isEmpty()) {
                    b.setFoundedYear(Integer.parseInt(fy));
                }
                String wp = request.getParameter("warrantyPeriod");
                if (wp != null && !wp.trim().isEmpty()) {
                    b.setWarrantyPeriod(Integer.parseInt(wp));
                }
                extDAO.saveBrand(b);
                break;
            }
            case "fuel_type": {
                CategoryFuelType ft = new CategoryFuelType();
                ft.setCategoryId(categoryId);
                ft.setUnit(request.getParameter("unit"));
                String tp = request.getParameter("typicalPrice");
                if (tp != null && !tp.trim().isEmpty()) {
                    ft.setTypicalPrice(new java.math.BigDecimal(tp));
                }
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
                if (tableName != null) {
                    extDAO.insertEmptyExtension(tableName, categoryId);
                }
                break;
            }
        }
    }

    private String getExtensionTableName(String type) {
        if (type == null) {
            return null;
        }
        switch (type) {
            case "generator_type":
                return "category_generator_type";
            case "phase":
                return "category_phase";
            case "condition":
                return "category_condition";
            case "receipt_reason":
                return "category_receipt_reason";
            case "receipt_status":
                return "category_receipt_status";
            case "order_status":
                return "category_order_status";
            default:
                return null;
        }
    }

    private String getModuleLabel(String module) {
        if (module == null) {
            return "Danh mục";
        }
        switch (module) {
            case "quản lý vật tư":
                return "Danh mục vật tư";
            case "quản lý phiếu xuất nhập":
                return "Danh mục phiếu xuất nhập";
            case "quản lý phiếu mua bán":
                return "Danh mục phiếu mua bán";
            case "quản lý kiểm kê":
                return "Danh mục kiểm kê";
            case "quản lý thanh lý":
                return "Danh mục thanh lý";
            default:
                return "Danh mục";
        }
    }

    private String statusLabel(String status) {
        if ("active".equals(status)) {
            return "Hoạt động";
        }
        if ("inactive".equals(status)) {
            return "Không hoạt động";
        }
        return status != null ? status : "";
    }

    private void logCreate(HttpServletRequest request, Integer entityId,
            String name, String type, String status, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }

            String typeLabel = TYPE_LABELS.getOrDefault(type, type);
            String statusLabel = statusLabel(status);

            String description = "Thêm mới: '" + name + "' (" + typeLabel + ") — Trạng thái: " + statusLabel
                    + " | module:" + (module != null ? module : "");

            insertLog(user, entityId, name, "CREATE", description);
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "CategoryController.logCreate", e.getMessage(), e);
        }
    }

    private String normalizeLogString(String s) {
        return (s == null || s.trim().isEmpty()) ? "(trống)" : s.trim();
    }

    private String normalizeLogNumber(Number n) {
        return n == null ? "(trống)" : n.toString();
    }

    private void logUpdate(HttpServletRequest request, Integer entityId,
            Category newCategory, Category oldCategory, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }

            String username = user.getName() != null ? user.getName() : user.getUsername();
            String typeLabel = TYPE_LABELS.getOrDefault(newCategory.getType(), newCategory.getType());

            String oldName = oldCategory != null ? oldCategory.getName() : newCategory.getName();
            String oldStatus = oldCategory != null ? oldCategory.getStatus() : newCategory.getStatus();
            String oldDesc = oldCategory != null && oldCategory.getDescription() != null ? oldCategory.getDescription() : "";
            String newDesc = newCategory.getDescription() != null ? newCategory.getDescription() : "";

            boolean nameChanged = !newCategory.getName().equals(oldName);
            boolean statusChanged = !newCategory.getStatus().equals(oldStatus);
            boolean descChanged = !newDesc.equals(oldDesc);

            StringBuilder desc = new StringBuilder();
            desc.append(username).append(" đã cập nhật ");

            if (nameChanged) {
                desc.append("tên ").append(oldName).append(" -> ").append(newCategory.getName());
            } else {
                desc.append("'").append(newCategory.getName()).append("'");
            }

            desc.append(" (").append(typeLabel).append(")");

            List<String> changes = new ArrayList<>();
            if (statusChanged) {
                changes.add("Trạng thái: " + statusLabel(oldStatus) + " -> " + statusLabel(newCategory.getStatus()));
            }
            if (descChanged) {
                changes.add("Mô tả: " + normalizeLogString(oldDesc) + " -> " + normalizeLogString(newDesc));
            }

            // So sánh các trường mở rộng (Extension)
            CategoryExtensionDAO extDAO = new CategoryExtensionDAO();
            Object oldExt = extDAO.findExtension(newCategory.getType(), entityId);

            switch (newCategory.getType()) {
                case "brand":
                    CategoryBrand oldB = (CategoryBrand) oldExt;
                    String newCountry = normalizeLogString(request.getParameter("country"));
                    String oldCountry = normalizeLogString(oldB != null ? oldB.getCountry() : null);
                    if (!newCountry.equals(oldCountry)) {
                        changes.add("Quốc gia: " + oldCountry + " -> " + newCountry);
                    }

                    String newWebsite = normalizeLogString(request.getParameter("website"));
                    String oldWebsite = normalizeLogString(oldB != null ? oldB.getWebsite() : null);
                    if (!newWebsite.equals(oldWebsite)) {
                        changes.add("Website: " + oldWebsite + " -> " + newWebsite);
                    }

                    String newFYStr = request.getParameter("foundedYear");
                    String newFY = normalizeLogString(newFYStr);
                    String oldFY = normalizeLogNumber(oldB != null ? oldB.getFoundedYear() : null);
                    if (!newFY.equals(oldFY)) {
                        changes.add("Năm TL: " + oldFY + " -> " + newFY);
                    }

                    String newWPStr = request.getParameter("warrantyPeriod");
                    String newWP = normalizeLogString(newWPStr);
                    String oldWP = normalizeLogNumber(oldB != null ? oldB.getWarrantyPeriod() : null);
                    if (!newWP.equals(oldWP)) {
                        changes.add("Bảo hành: " + oldWP + " -> " + newWP);
                    }
                    break;
                case "fuel_type":
                    CategoryFuelType oldF = (CategoryFuelType) oldExt;
                    String newUnit = normalizeLogString(request.getParameter("unit"));
                    String oldUnit = normalizeLogString(oldF != null ? oldF.getUnit() : null);
                    if (!newUnit.equals(oldUnit)) {
                        changes.add("Đơn vị: " + oldUnit + " -> " + newUnit);
                    }

                    String newPriceStr = request.getParameter("typicalPrice");
                    String newPrice = normalizeLogString(newPriceStr);
                    String oldPrice = normalizeLogNumber(oldF != null ? oldF.getTypicalPrice() : null);
                    if (!newPrice.equals(oldPrice)) {
                        try {
                            java.math.BigDecimal np = newPrice.equals("(trống)") ? null : new java.math.BigDecimal(newPriceStr.trim());
                            java.math.BigDecimal op = oldF != null ? oldF.getTypicalPrice() : null;
                            if (np != null && op != null && np.compareTo(op) == 0) {

                            } else {
                                changes.add("Giá tham khảo: " + oldPrice + " -> " + newPrice);
                            }
                        } catch (Exception e) {
                            changes.add("Giá tham khảo: " + oldPrice + " -> " + newPrice);
                        }
                    }
                    break;
                case "origin":
                    CategoryOrigin oldO = (CategoryOrigin) oldExt;
                    String newCode = normalizeLogString(request.getParameter("country_code"));
                    String oldCode = normalizeLogString(oldO != null ? oldO.getCountryCode() : null);
                    if (!newCode.equals(oldCode)) {
                        changes.add("Mã quốc gia: " + oldCode + " -> " + newCode);
                    }
                    break;
                case "customer_type":
                    CategoryCustomerType oldC = (CategoryCustomerType) oldExt;
                    String newTax = normalizeLogString(request.getParameter("taxType"));
                    String oldTax = normalizeLogString(oldC != null ? oldC.getTaxType() : null);
                    if (!newTax.equals(oldTax)) {
                        changes.add("Loại thuế: " + oldTax + " -> " + newTax);
                    }
                    break;
            }

            if (!changes.isEmpty()) {
                desc.append(" — ").append(String.join(", ", changes));
            } else if (!nameChanged) {
                return; // Không có bất kỳ thay đổi nào cả (cả cơ bản lẫn mở rộng), bỏ qua log
            }

            desc.append(" | module:").append(module != null ? module : "");

            insertLog(user, entityId, newCategory.getName(), "UPDATE", desc.toString());
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "CategoryController.logUpdate", e.getMessage(), e);
        }
    }



    private void logDelete(HttpServletRequest request, Integer entityId,
            String name, String type, String status, String module) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) {
                return;
            }

            String typeLabel = TYPE_LABELS.getOrDefault(type, type);
            String statusLabel = statusLabel(status);

            String description = "Khóa: '" + name + "' (" + typeLabel + ") — Trạng thái trước: " + statusLabel
                    + " | module:" + (module != null ? module : "");

            insertLog(user, entityId, name, "DELETE", description);
        } catch (Exception e) {
            SystemLogger.error(LogModule.SYSTEM, "CategoryController.logDelete", e.getMessage(), e);
        }
    }

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


        String logSearch = request.getParameter("logSearch");
        String logAction = request.getParameter("logAction");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");


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

        List<ActivityLog> logs = logDAO.findByModuleFilter(
                module, logSearch, logAction, dateFrom, dateTo, page, pageSize);
        int totalLogs = logDAO.countByModuleFilter(
                module, logSearch, logAction, dateFrom, dateTo);

        int totalPages = Math.max(1, (int) Math.ceil((double) totalLogs / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        request.setAttribute("logList", logs);
        request.setAttribute("logPage", page);
        request.setAttribute("logTotalPages", totalPages);
        request.setAttribute("totalLogs", totalLogs);
        request.setAttribute("currentTab", "history");
        request.setAttribute("currentModule", module);
        request.setAttribute("moduleLabel", getModuleLabel(module));

        request.setAttribute("logSearch", logSearch != null ? logSearch : "");
        request.setAttribute("logAction", logAction != null ? logAction : "");
        request.setAttribute("dateFrom", dateFrom != null ? dateFrom : "");
        request.setAttribute("dateTo", dateTo != null ? dateTo : "");

        request.getRequestDispatcher("/view/admin/admin-category.jsp").forward(request, response);
    }

    private void exportCategoryExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String module = request.getParameter("module");
        if (module == null || module.isEmpty()) {
            module = "quản lý vật tư";
        }

        String typeFilter = request.getParameter("type");
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        List<Category> list;
        if (typeFilter != null && !typeFilter.trim().isEmpty()
                && search != null && !search.trim().isEmpty()) {
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


        if (statusFilter != null && !statusFilter.trim().isEmpty()
                && !"all".equals(statusFilter)) {
            List<Category> filtered = new ArrayList<>();
            for (Category c : list) {
                if (statusFilter.equals(c.getStatus())) {
                    filtered.add(c);
                }
            }
            list = filtered;
        }

        List<Integer> catIds = new ArrayList<>();
        for (Category c : list) {
            catIds.add(c.getId());
        }

        Map<Integer, Object> extensions = null;
        if (typeFilter != null && !typeFilter.trim().isEmpty() && !catIds.isEmpty()) {
            extensions = new CategoryExtensionDAO().loadExtensionsByType(typeFilter, catIds);
        }

        XSSFWorkbook workbook = CategoryExcelSupport.exportToWorkbook(list, extensions, typeFilter);

        String today = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
        String fileName = "danh-muc-"
                + (typeFilter != null && !typeFilter.isEmpty() ? typeFilter : "all")
                + "-" + today + ".xlsx";


        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");


        workbook.write(response.getOutputStream());
        workbook.close();


        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user != null) {
            String desc = "Xuất Excel: " + list.size() + " bản ghi"
                    + " | type:" + (typeFilter != null ? typeFilter : "all")
                    + " | module:" + module;
            insertLog(user, null, "Excel Export", "EXPORT", desc);
        }
    }

    private void importCategoryPreview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String module = request.getParameter("module");

        Part filePart = request.getPart("excelFile");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect(request.getContextPath()
                    + "/admin/categories?module=" + module + "&type=" + type + "&msg=no-file");
            return;
        }

        InputStream is = filePart.getInputStream();
        List<Map<String, String>> rows = CategoryExcelSupport.parseFromExcel(is, type);

        List<Map<String, String>> validRows = new ArrayList<>();
        List<Map<String, String>> invalidRows = new ArrayList<>();
        for (Map<String, String> row : rows) {
            String name = row.get("Tên danh mục");
            List<String> errors = new ArrayList<>();

            if (name == null || name.trim().isEmpty()) {
                errors.add("Tên danh mục không được trống");
            } else if (cateDAO.existsByNameAndTypeAndModule(name.trim(), type, module, 0)) {
                // Kiểm tra trùng với dữ liệu đang có trong DB
                errors.add("Đã tồn tại danh mục \"" + name.trim() + "\" trong hệ thống");
            }

            if (errors.isEmpty()) {
                validRows.add(row);
            } else {
                row.put("_errors", String.join("; ", errors));
                invalidRows.add(row);
            }
        }

        request.setAttribute("validRows", validRows);
        request.setAttribute("invalidRows", invalidRows);
        request.setAttribute("currentType", type);
        request.setAttribute("currentModule", module);
        request.getRequestDispatcher("/view/admin/admin-category-import-preview.jsp")
                .forward(request, response);
    }

    private void importCategoryConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String module = request.getParameter("module");
        if (module == null || module.trim().isEmpty()) {
            module = "quản lý vật tư";
        }

        String[] names = request.getParameterValues("name");
        String[] descs = request.getParameterValues("description");
        String[] statuses = request.getParameterValues("status");
        // brand
        String[] countries = request.getParameterValues("country");
        String[] websites = request.getParameterValues("website");
        String[] foundedYears = request.getParameterValues("foundedYear");
        String[] warrantyPeriods = request.getParameterValues("warrantyPeriod");
        // fuel_type
        String[] units = request.getParameterValues("unit");
        String[] typicalPrices = request.getParameterValues("typicalPrice");
        // origin
        String[] countryCodes = request.getParameterValues("countryCode");
        // customer_type
        String[] taxTypes = request.getParameterValues("taxType");

        int importedCount = 0;
        CategoryExtensionDAO extDAO = new CategoryExtensionDAO();

        if (names != null) {
            for (int i = 0; i < names.length; i++) {

                if (names[i] == null || names[i].trim().isEmpty()) {
                    continue;
                }

                // Kiểm tra trùng lần cuối trước khi insert (tránh race condition)
                if (cateDAO.existsByNameAndTypeAndModule(names[i].trim(), type, module, 0)) {
                    continue; // bỏ qua nếu đã tồn tại
                }

                Category c = new Category();
                c.setName(names[i].trim());
                c.setType(type);
                c.setDescription(descs != null && i < descs.length ? descs[i] : "");
                c.setStatus(statuses != null && i < statuses.length ? statuses[i] : "active");
                c.setModule(module);

                int newId = cateDAO.insert(c);
                if (newId <= 0) {
                    continue;
                }

                switch (type != null ? type : "") {

                    case "brand": {
                        CategoryBrand b = new CategoryBrand();
                        b.setCategoryId(newId);
                        b.setCountry(safeGet(countries, i));
                        b.setWebsite(safeGet(websites, i));

                        String fy = safeGet(foundedYears, i);
                        if (!fy.isEmpty()) {
                            try {
                                b.setFoundedYear(Integer.parseInt(fy));
                            } catch (NumberFormatException ignored) {
                            }
                        }
                        String wp = safeGet(warrantyPeriods, i);
                        if (!wp.isEmpty()) {
                            try {
                                b.setWarrantyPeriod(Integer.parseInt(wp));
                            } catch (NumberFormatException ignored) {
                            }
                        }
                        extDAO.saveBrand(b);
                        break;
                    }

                    case "fuel_type": {
                        CategoryFuelType ft = new CategoryFuelType();
                        ft.setCategoryId(newId);
                        ft.setUnit(safeGet(units, i));
                        String price = safeGet(typicalPrices, i);
                        if (!price.isEmpty()) {
                            try {
                                ft.setTypicalPrice(new java.math.BigDecimal(price));
                            } catch (NumberFormatException ignored) {
                            }
                        }
                        extDAO.saveFuelType(ft);
                        break;
                    }

                    case "origin": {
                        CategoryOrigin o = new CategoryOrigin();
                        o.setCategoryId(newId);
                        o.setCountryCode(safeGet(countryCodes, i));
                        extDAO.saveOrigin(o);
                        break;
                    }

                    case "customer_type": {
                        CategoryCustomerType ct = new CategoryCustomerType();
                        ct.setCategoryId(newId);
                        ct.setTaxType(safeGet(taxTypes, i));
                        extDAO.saveCustomerType(ct);
                        break;
                    }

                    default: {
                        // phase, condition, generator_type, receipt_reason...
                        String tableName = getExtensionTableName(type);
                        if (tableName != null) {
                            extDAO.insertEmptyExtension(tableName, newId);
                        }
                        break;
                    }
                }


                User user = (User) request.getSession().getAttribute("loggedUser");
                if (user != null) {
                    insertLog(user, newId, names[i].trim(), "IMPORT",
                            "Tạo từ nhập Excel | type:" + type + " | module:" + module);
                }
                importedCount++;
            }
        }

        User user = (User) request.getSession().getAttribute("loggedUser");
        if (user != null) {
            insertLog(user, 0, "Excel Import", "IMPORT",
                    "Nhập Excel: thêm " + importedCount + " danh mục " + type + " | module:" + module);
        }

        response.sendRedirect(request.getContextPath()
                + "/admin/categories?module=" + java.net.URLEncoder.encode(module, "UTF-8")
                + "&type=" + type
                + "&msg=import-success"
                + "&importedCount=" + importedCount);
    }

    private String safeGet(String[] arr, int index) {
        if (arr == null || index >= arr.length || arr[index] == null) {
            return "";
        }
        return arr[index].trim();
    }

    private void downloadCategoryTemplate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("type");
        if (type == null || type.trim().isEmpty()) {
            type = "default";
        }

        XSSFWorkbook workbook = CategoryExcelSupport.createTemplateWorkbook(type);
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String filename = "BieuMau_Nhap_" + type + ".xlsx";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

        try (java.io.OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        } finally {
            workbook.close();
        }
    }

}
