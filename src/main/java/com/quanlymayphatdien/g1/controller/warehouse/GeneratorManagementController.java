package com.quanlymayphatdien.g1.controller.warehouse;

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
import java.util.List;

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
        List<Generator> generators = dao.findByFilters(search, status, page, pageSize);
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
                request.setAttribute("createdDate", g.getCreatedAt() != null
                        ? g.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", g.getUpdatedAt() != null
                        ? g.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "—");
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
            request.getSession().setAttribute("message", "Loi: " + e.getMessage());
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
            request.getSession().setAttribute("message",
                    ok ? "Kích hoạt thành công!" : "Kích hoạt thất bại!");
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
            request.getSession().setAttribute("message",
                    ok ? "Khóa thành công!" : "Khóa thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/generators?action=list&page=" + currentPage);
    }
}