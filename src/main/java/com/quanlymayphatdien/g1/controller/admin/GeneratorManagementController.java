package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.GeneratorDAO;
import com.quanlymayphatdien.g1.entity.Generator;
import jakarta.servlet.RequestDispatcher;
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
            case "list":
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

        GeneratorDAO dao = new GeneratorDAO();
        List<Generator> generators = dao.findGeneratorsByFilters(search, status, page, pageSize);
        int total = dao.getTotalFiltered(search, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("generators", generators);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalGenerators", total);
        request.setAttribute("searchFilter", search);
        request.setAttribute("statusFilter", status);
        request.setAttribute("activeCount", dao.countByStatus("active"));
        request.setAttribute("lockedCount", dao.countByStatus("locked"));

        request.getRequestDispatcher("/view/warehouse/generator.jsp").forward(request, response);
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
                request.setAttribute("createdDate", g.getCreatedAt() != null ? g.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", g.getUpdatedAt() != null ? g.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "—");
                request.getRequestDispatcher("/view/warehouse/generator-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list");
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/warehouse/generator-create.jsp").forward(request, response);
    }

    private void createGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String model = request.getParameter("model");
            String brand = request.getParameter("brand");
            String powerStr = request.getParameter("powerRating");
            String priceStr = request.getParameter("unitPrice");
            String stockStr = request.getParameter("stockQuantity");
            String desc = request.getParameter("description");
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "active";
            }
            BigDecimal power = new BigDecimal(powerStr);
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);

            Map<String, String> errors = validateGeneratorForm(model, brand, powerStr, priceStr, stockStr, null);
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=create");
                return;
            }

            Generator g = new Generator();
            g.setModel(model);
            g.setBrand(brand);
            g.setPowerRating(power);
            g.setUnitPrice(price);
            g.setStockQuantity(stock);
            g.setDescription(desc);
            g.setStatus(status);
            g.setCreatedAt(LocalDateTime.now());
            g.setCreatedBy(1);

            GeneratorDAO dao = new GeneratorDAO();
            int newId = dao.insert(g);
            if (newId > 0) {
                request.getSession().setAttribute("message", "Thêm máy phát điện thành công!");
            } else {
                request.getSession().setAttribute("message", "Thêm máy phát điện thất bại!");
            }
        } catch (Exception e) {
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
                request.getRequestDispatcher("/view/warehouse/generator-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list");
    }

    private void updateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String model = request.getParameter("model");
            String brand = request.getParameter("brand");
            String powerStr = request.getParameter("powerRating");
            String priceStr = request.getParameter("unitPrice");
            String stockStr = request.getParameter("stockQuantity");
            String desc = request.getParameter("description");
            String status = request.getParameter("status");
            
            Map<String, String> errors = validateGeneratorForm(model, brand, powerStr, priceStr, stockStr, id);
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());
                response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=update&id=" + id);
                return;
            }
            GeneratorDAO dao = new GeneratorDAO();
            Generator g = dao.findById(id);
            if (g != null) {
                g.setModel(model);
                g.setBrand(brand);
                g.setPowerRating(new BigDecimal(powerStr));
                g.setUnitPrice(new BigDecimal(priceStr));
                g.setStockQuantity(Integer.parseInt(stockStr));
                g.setDescription(desc);
                g.setStatus(status);
                g.setUpdatedAt(LocalDateTime.now());
                g.setUpdatedBy(1);

                boolean ok = dao.update(g);
                if (ok) {
                    request.getSession().setAttribute("message", "Cập nhật thành công!");
                } else {
                    request.getSession().setAttribute("message", "Cập nhật thất bại!");
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list");
    }

    private void activateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) currentPage = "1";

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            boolean ok = dao.activate(id);
            if (ok) {
                request.getSession().setAttribute("message", "Kích hoạt thành công!");
            } else {
                request.getSession().setAttribute("message", "Kích hoạt thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list&page=" + currentPage);
    }

    private void deactivateGenerator(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) currentPage = "1";

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            GeneratorDAO dao = new GeneratorDAO();
            boolean ok = dao.deactivate(id);
            request.getSession().setAttribute("message", ok ? "Khóa thành công!" : "Khóa thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list&page=" + currentPage);
    }
    
    private Map<String, String> validateGeneratorForm(String model, String brand,
            String powerRatingStr, String unitPriceStr, String stockQuantityStr, Integer id) {
        Map<String, String> errors = new HashMap<>();

        if (model == null || model.trim().isEmpty()) {
            errors.put("model", "Mẫu máy không được để trống");
        } else if (model.trim().length() > 20) {
            errors.put("model", "Mẫu máy không được vượt quá 20 ký tự");
        } else {
            GeneratorDAO dao = new GeneratorDAO();
            if (dao.isModelExists(model, id)) {           // ← THÊM
                errors.put("model", "Mẫu máy này đã tồn tại");   // ← THÊM
            }
        }

        if (brand == null || brand.trim().isEmpty()) {
            errors.put("brand", "Thương hiệu không được để trống");
        } else if (brand.trim().length() > 20) {
            errors.put("brand", "Thương hiệu không được vượt quá 20 ký tự");
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

        if (stockQuantityStr == null || stockQuantityStr.trim().isEmpty()) {
            errors.put("stockQuantity", "Số lượng tồn kho không được để trống");
        } else {
            try {
                int sq = Integer.parseInt(stockQuantityStr.trim());
                if (sq < 0) {
                    errors.put("stockQuantity", "Số lượng tồn kho không được âm");
                }
            } catch (NumberFormatException e) {
                errors.put("stockQuantity", "Số lượng tồn kho phải là số nguyên");
            }
        }

        return errors;
    }
}