package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Generator;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "GeneratorManagementServlet", urlPatterns = {"/warehouse/generators"})
public class GeneratorManagementController extends HttpServlet {

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
            case "create":
                showCreateForm(request, response);
                break;
            case "update":
                showUpdateForm(request, response);
                break;
            case "activate":
                activateGenerator(request, response);
                break;
            case "deactivate":
                deactivateGenerator(request, response);
                break;
            default:
                listGenerators(request, response);
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
            action = "list";
        }
        switch (action) {
            case "create":
                createGenerator(request, response);
                break;
            case "update":
                updateGenerator(request, response);
                break;
            case "activate":
                activateGenerator(request, response);
                break;
            case "deactivate":
                deactivateGenerator(request, response);
                break;
            default:
                listGenerators(request, response);
                break;
        }
    }

    private void listGenerators(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String brandIdStr = request.getParameter("brandId");
        String genTypeIdStr = request.getParameter("genTypeId");
        Integer brandId = (brandIdStr != null && !brandIdStr.isEmpty())
                ? Integer.valueOf(brandIdStr) : null;
        Integer genTypeId = (genTypeIdStr != null && !genTypeIdStr.isEmpty())
                ? Integer.valueOf(genTypeIdStr) : null;

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                SystemLogger.warn(LogModule.GENERATOR, "GeneratorManagementController.listGenerators", "Lỗi định dạng trang: " + e.getMessage());
                page = 1;
            }
        }

        GeneratorDAO dao = new GeneratorDAO();
        List<Generator> generators = dao.findGeneratorsByFilters(search, status, brandId, genTypeId, page, pageSize);
        int total = dao.getTotalFiltered(search, status, brandId, genTypeId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("generators", generators);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalGenerators", total);
        request.setAttribute("searchFilter", search);
        request.setAttribute("statusFilter", status);
        request.setAttribute("activeCount", dao.countByStatus("active"));
        request.setAttribute("lockedCount", dao.countByStatus("locked"));
        request.setAttribute("brandFilter", brandIdStr);    
        request.setAttribute("genTypeFilter", genTypeIdStr);
        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("brandList", catDAO.findByType("brand"));
        request.setAttribute("genTypeList", catDAO.findByType("generator_type"));

        request.getRequestDispatcher("/view/generator/generator-list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            Generator g = dao.findById(id);
            if (g != null) {
                request.setAttribute("generator", g);
                DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                request.setAttribute("createdDate", g.getCreatedAt() != null
                        ? g.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", g.getUpdatedAt() != null
                        ? g.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "—");

                GeneratorDAO generatorDAO = new GeneratorDAO();   
                List<Category> cats = generatorDAO.getCategoriesByGeneratorId(id);
                request.setAttribute("genBrand", getCatName(cats, "brand"));
                request.setAttribute("genOrigin", getCatName(cats, "origin"));
                request.setAttribute("genCondition", getCatName(cats, "condition"));
                request.setAttribute("genType", getCatName(cats, "generator_type"));
                request.setAttribute("genFuelType", getCatName(cats, "fuel_type"));
                request.setAttribute("genPhase", getCatName(cats, "phase"));
                request.setAttribute("genPowerRange", getCatName(cats, "power_range"));

                ActivityLogDAO logDAO = new ActivityLogDAO();
                List<ActivityLog> logs = logDAO.getLogsByEntity("generator", id, 1, 20);
                DateTimeFormatter logFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                List<String> logDates = new ArrayList<>();
                for (ActivityLog log : logs) {
                    logDates.add(log.getCreatedAt() != null ? log.getCreatedAt().format(logFmt) : "—");
                }
                request.setAttribute("activityLogs", logs);
                request.setAttribute("logDates", logDates);
                request.getRequestDispatcher("/view/generator/generator-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/generator/generators?action=list");
    }

    private String getCatName(List<Category> cats, String type) {
        if (cats == null) {
            return "—";
        }
        for (Category c : cats) {
            if (type.equals(c.getType())) {
                return c.getName();
            }
        }
        return "—";
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("brands", catDAO.findByType("brand"));
        request.setAttribute("fuelTypes", catDAO.findByType("fuel_type"));
        request.setAttribute("powerRanges", catDAO.findByType("power_range"));
        request.setAttribute("genTypes", catDAO.findByType("generator_type"));
        request.setAttribute("phases", catDAO.findByType("phase"));
        request.setAttribute("conditions", catDAO.findByType("condition"));
        request.setAttribute("origins", catDAO.findByType("origin"));

        request.getRequestDispatcher("/view/generator/generator-create.jsp").forward(request, response);
    }

    private void createGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String model = request.getParameter("model");
            String powerStr = request.getParameter("powerRating");
            String priceStr = request.getParameter("unitPrice");
            String freq = request.getParameter("frequency");
            String weightStr = request.getParameter("weight");
            String desc = request.getParameter("description");
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "active";
            }

            String brandIdStr = request.getParameter("brandId");
            String genTypeIdStr = request.getParameter("genTypeId");
            String originIdStr = request.getParameter("originId");
            String conditionIdStr = request.getParameter("conditionId");
            String fuelTypeIdStr = request.getParameter("fuelTypeId");
            String phaseIdStr = request.getParameter("phaseId");
            String powerRangeIdStr = request.getParameter("powerRangeId");

            Map<String, String> errors = validateGeneratorForm(model, powerStr, priceStr,
                    freq, weightStr, null);
            if (!errors.isEmpty()) {
                saveFormFields(request, model, powerStr, priceStr, freq, weightStr, desc,
                        brandIdStr, genTypeIdStr, originIdStr, conditionIdStr,
                        fuelTypeIdStr, phaseIdStr, powerRangeIdStr);
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=create");
                return;
            }

            Generator g = new Generator();
            g.setModel(model.trim());
            g.setPowerRating(new BigDecimal(powerStr.trim()));

            g.setFrequency(freq != null ? freq.trim() : null);
            g.setWeight(weightStr != null && !weightStr.trim().isEmpty() ? new BigDecimal(weightStr.trim()) : null);
            g.setDescription(desc);
            g.setStatus(status);
            g.setCreatedAt(LocalDateTime.now());
            g.setCreatedBy(1);

            GeneratorDAO dao = new GeneratorDAO();
            int newId = dao.insert(g);
            if (newId > 0) {
                saveGeneratorCategories(request, dao, newId);
                request.getSession().setAttribute("message", "Thêm máy phát điện thành công!");

                String details = "Tạo máy phát điện: " + model.trim() + ", Công suất: " + powerStr + "kVA";
                logActivity(request, "generator", newId, model.trim(), "CREATE", details);
            } else {
                request.getSession().setAttribute("message", "Thêm máy phát điện thất bại!");
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.GENERATOR, "GeneratorManagementController.createGenerator", e.getMessage(), e);
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list");
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            Generator g = dao.findById(id);
            if (g != null) {
                request.setAttribute("generator", g);
                CategoryDAO catDAO = new CategoryDAO();
                request.setAttribute("brands", catDAO.findByType("brand"));
                request.setAttribute("fuelTypes", catDAO.findByType("fuel_type"));
                request.setAttribute("powerRanges", catDAO.findByType("power_range"));
                request.setAttribute("genTypes", catDAO.findByType("generator_type"));
                request.setAttribute("phases", catDAO.findByType("phase"));
                request.setAttribute("conditions", catDAO.findByType("condition"));
                request.setAttribute("origins", catDAO.findByType("origin"));
                List<Category> selectedCats = dao.getCategoriesByGeneratorId(id);
                List<Integer> selectedIds = selectedCats.stream()
                        .map(Category::getId).collect(Collectors.toList());
                request.setAttribute("selectedCatIds", selectedIds);

                request.getRequestDispatcher("/view/generator/generator-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/generator/generators?action=list");
    }

    private void updateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String model = request.getParameter("model");
            String powerStr = request.getParameter("powerRating");
            String priceStr = request.getParameter("unitPrice");
            String freq = request.getParameter("frequency");
            String weightStr = request.getParameter("weight");
            String desc = request.getParameter("description");
            String status = request.getParameter("status");

            String brandIdStr = request.getParameter("brandId");
            String genTypeIdStr = request.getParameter("genTypeId");
            String originIdStr = request.getParameter("originId");
            String conditionIdStr = request.getParameter("conditionId");
            String fuelTypeIdStr = request.getParameter("fuelTypeId");
            String phaseIdStr = request.getParameter("phaseId");
            String powerRangeIdStr = request.getParameter("powerRangeId");

            Map<String, String> errors = validateGeneratorForm(model, powerStr, priceStr,
                    freq, weightStr, id);
            if (!errors.isEmpty()) {
                saveFormFields(request, model, powerStr, priceStr, freq, weightStr, desc, brandIdStr, genTypeIdStr, originIdStr, conditionIdStr, fuelTypeIdStr, phaseIdStr, powerRangeIdStr);
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/warehouse/generators?action=update&id=" + id);
                return;
            }

            GeneratorDAO dao = new GeneratorDAO();
            Generator g = dao.findById(id);
            if (g != null) {
                g.setModel(model.trim());
                g.setPowerRating(new BigDecimal(powerStr.trim()));
                g.setFrequency(freq != null ? freq.trim() : null);
                g.setWeight(weightStr != null && !weightStr.trim().isEmpty()
                        ? new BigDecimal(weightStr.trim()) : null);
                g.setDescription(desc);
                g.setStatus(status);
                g.setUpdatedAt(LocalDateTime.now());
                g.setUpdatedBy(1);

                boolean ok = dao.update(g);
                if (ok) {
                    dao.deleteGeneratorCategories(id);
                    saveGeneratorCategories(request, dao, id);
                    request.getSession().setAttribute("message", "Cập nhật thành công!");

                    String details = "Cập nhật thông tin máy phát điện: " + model.trim();
                    logActivity(request, "generator", id, model.trim(), "UPDATE", details);
                } else {
                    request.getSession().setAttribute("message", "Cập nhật thất bại!");
                }
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy máy phát điện!");
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.GENERATOR, "GeneratorManagementController.updateGenerator", e.getMessage(), e);
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list");
    }

    private void saveGeneratorCategories(HttpServletRequest request, GeneratorDAO dao, int generatorId) {
        List<Integer> idList = new ArrayList<>();

        String[] inputs = {"brandId", "genTypeId", "originId", "conditionId", "fuelTypeId", "phaseId", "powerRangeId"};

        for (String i : inputs) {
            String value = request.getParameter(i);
            if (value != null && !value.trim().isEmpty()) {
                idList.add(Integer.valueOf(value.trim()));
            }
        }

        if (!idList.isEmpty()) {
            dao.saveGeneratorCategories(generatorId, idList);
        }
    }
    
    private void saveFormFields(HttpServletRequest request, String model,
            String powerStr, String priceStr, String freq, String weightStr,
            String desc, String brandIdStr, String genTypeIdStr,
            String originIdStr, String conditionIdStr, String fuelTypeIdStr,
            String phaseIdStr, String powerRangeIdStr) {
        request.getSession().setAttribute("fieldModel", model);
        request.getSession().setAttribute("fieldPower", powerStr);
        request.getSession().setAttribute("fieldPrice", priceStr);
        request.getSession().setAttribute("fieldFrequency", freq);
        request.getSession().setAttribute("fieldWeight", weightStr);
        request.getSession().setAttribute("fieldDesc", desc);
        request.getSession().setAttribute("fieldBrandId", brandIdStr);
        request.getSession().setAttribute("fieldGenTypeId", genTypeIdStr);
        request.getSession().setAttribute("fieldOriginId", originIdStr);
        request.getSession().setAttribute("fieldConditionId", conditionIdStr);
        request.getSession().setAttribute("fieldFuelTypeId", fuelTypeIdStr);
        request.getSession().setAttribute("fieldPhaseId", phaseIdStr);
        request.getSession().setAttribute("fieldPowerRangeId", powerRangeIdStr);
    }

    
    private void activateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            boolean ok = dao.activate(id);
            if (ok) {
                request.getSession().setAttribute("message","Kích hoạt thành công!");
                Generator gen = dao.findById(id);
                if (gen != null) {
                    logActivity(request, "generator", id, gen.getModel(), "ACTIVATE", "Kích hoạt máy phát điện: " + gen.getModel());
                }
            } else {
                request.getSession().setAttribute("message", "Kích hoạt thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/generator/generators?action=list&page=" + currentPage);
    }

    private void deactivateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            boolean ok = dao.deactivate(id);
            if (ok) {
                request.getSession().setAttribute("message","Khóa thành công!");
                Generator gen = dao.findById(id);
                if (gen != null) {
                    logActivity(request, "generator", id, gen.getModel(), "DEACTIVATE",
                            "Khóa máy phát điện: " + gen.getModel());
                }
            } else {
                request.getSession().setAttribute("message", "Khóa thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/generator/generators?action=list&page=" + currentPage);
    }

    private Map<String, String> validateGeneratorForm(String model,
            String powerRatingStr, String unitPriceStr,
            String frequency, String weightStr, Integer excludeId) {
        Map<String, String> errors = new HashMap<>();

        if (model == null || model.trim().isEmpty()) {
            errors.put("model", "Mẫu máy không được để trống");
        } else if (model.trim().length() > 100) {
            errors.put("model", "Mẫu máy không được vượt quá 100 ký tự");
        } else {
            GeneratorDAO dao = new GeneratorDAO();
            if (dao.isModelExists(model.trim(), excludeId)) {
                errors.put("model", "Mẫu máy này đã tồn tại");
            }
        }

        if (powerRatingStr == null || powerRatingStr.trim().isEmpty()) {
            errors.put("powerRating", "Công suất không được để trống");
        } else {
            try {
                BigDecimal pr = new BigDecimal(powerRatingStr.trim());
                if (pr.compareTo(BigDecimal.ZERO) <= 0) {
                    errors.put("powerRating", "Công suất phải lớn hơn 0");
                }
            } catch (NumberFormatException e) {
                errors.put("powerRating", "Công suất phải là số hợp lệ");
            }
        }

        if (unitPriceStr == null || unitPriceStr.trim().isEmpty()) {
            errors.put("unitPrice", "Đơn giá không được để trống");
        } else {
            try {
                BigDecimal up = new BigDecimal(unitPriceStr.trim());
                if (up.compareTo(BigDecimal.ZERO) <= 0) {
                    errors.put("unitPrice", "Đơn giá phải lớn hơn 0");
                }
            } catch (NumberFormatException e) {
                errors.put("unitPrice", "Đơn giá phải là số hợp lệ");
            }
        }

        if (frequency != null && !frequency.trim().isEmpty()) {
            if (!frequency.trim().matches("^[0-9]{2}Hz$")) {
                errors.put("frequency", "Tần số phải có định dạng XXHz (VD: 50Hz)");
            }
        }

        if (weightStr != null && !weightStr.trim().isEmpty()) {
            try {
                BigDecimal w = new BigDecimal(weightStr.trim());
                if (w.compareTo(BigDecimal.ZERO) <= 0) {
                    errors.put("weight", "Trọng lượng phải lớn hơn 0");
                }
            } catch (NumberFormatException e) {
                errors.put("weight", "Trọng lượng phải là số hợp lệ");
            }
        }

        return errors;
    }
    
    private void logActivity(HttpServletRequest request, String entityType,
            int entityId, String entityName, String action, String details) {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        ActivityLog log = new ActivityLog();
        log.setUserId(loggedUser.getId());
        log.setUsername(loggedUser.getUsername());
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setEntityName(entityName);
        log.setAction(action);
        log.setDetails(details);
        log.setCreatedAt(LocalDateTime.now());
        new ActivityLogDAO().insertLog(log);
    }

    /**
     * Tính lại số PO APPROVED có máy chưa có trong kho và lưu vào session.
     * Gọi sau khi sale staff tạo/cập nhật generator để badge trên sidebar
     * được cập nhật ngay.
     */
}