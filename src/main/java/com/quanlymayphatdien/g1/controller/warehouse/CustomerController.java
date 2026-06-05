package com.quanlymayphatdien.g1.controller.warehouse;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.CategoryDAO;
import com.quanlymayphatdien.g1.dal.CustomerDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Category;
import com.quanlymayphatdien.g1.entity.Customer;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name="CustomerController", urlPatterns={"/warehouse/customers"})
public class CustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) action = "list";

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
                activateCustomer(request, response);
                break;
            case "deactivate":
                deactivateCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
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
        if (action == null) action = "list";

        switch (action) {
            case "create":
                createCustomer(request, response);
                break;
            case "update":
                updateCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
                break;
        }
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String typeIdStr = request.getParameter("customerTypeId");
        Integer customerTypeId = (typeIdStr != null && !typeIdStr.isEmpty())
                ? Integer.valueOf(typeIdStr) : null;

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

        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.findByFilters(search, status, customerTypeId, page, pageSize);
        int total = dao.getTotalFiltered(search, status, customerTypeId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("customers", customers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCustomers", total);
        request.setAttribute("searchFilter", search);
        request.setAttribute("statusFilter", status);
        request.setAttribute("activeCount", dao.countByStatus("active"));
        request.setAttribute("lockedCount", dao.countByStatus("locked"));
        request.setAttribute("customerTypeFilter", typeIdStr);

        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("customerTypeList", catDAO.findByType("customer_type"));

        request.getRequestDispatcher("/view/customer/customer-list.jsp").forward(request, response);
    }

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            CustomerDAO dao = new CustomerDAO();
            Customer c = dao.findById(id);
            if (c != null) {
                request.setAttribute("customer", c);
                DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                request.setAttribute("createdDate", c.getCreatedAt() != null
                        ? c.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", c.getUpdatedAt() != null
                        ? c.getUpdatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) : "—");

                CategoryDAO catDAO = new CategoryDAO();
                List<Category> types = catDAO.findByType("customer_type");
                String typeName = "—";
                for (Category t : types) {
                    if (t.getId() == c.getCustomerTypeId()) {
                        typeName = t.getName();
                        break;
                    }
                }
                request.setAttribute("customerTypeName", typeName);

                ActivityLogDAO logDAO = new ActivityLogDAO();
                List<ActivityLog> logs = logDAO.findByEntityTypeAndId("customer", id, 1, 20);
                DateTimeFormatter logFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                List<String> logDates = new ArrayList<>();
                for (ActivityLog log : logs) {
                    logDates.add(log.getCreatedAt() != null ? log.getCreatedAt().format(logFmt) : "—");
                }
                request.setAttribute("activityLogs", logs);
                request.setAttribute("logDates", logDates);

                request.getRequestDispatcher("/view/customer/customer-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list");
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO catDAO = new CategoryDAO();
        request.setAttribute("customerTypeList", catDAO.findByType("customer_type"));
        request.getRequestDispatcher("/view/customer/customer-create.jsp").forward(request, response);
    }

    private void createCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String companyName = request.getParameter("companyName");
            String typeIdStr = request.getParameter("customerTypeId");
            String status = request.getParameter("status");
            String note = request.getParameter("note");
            if (status == null || status.isEmpty()) status = "active";

            Map<String, String> errors = validateCustomerForm(name, phone, email, null);
            if (!errors.isEmpty()) {
                saveFormFields(request, name, phone, email, address, companyName,
                        typeIdStr, note);
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=create");
                return;
            }

            Customer c = new Customer();
            c.setName(name.trim());
            c.setPhone(phone.trim());
            c.setEmail(email != null ? email.trim() : null);
            c.setAddress(address);
            c.setCompanyName(companyName);
            if (typeIdStr != null && !typeIdStr.isEmpty()) {
                c.setCustomerTypeId(Integer.parseInt(typeIdStr));
            }
            c.setStatus(status);
            c.setCreatedAt(LocalDateTime.now());
            User user = (User) request.getSession().getAttribute("loggedUser");
            c.setCreatedBy(user != null ? user.getId() : null);

            CustomerDAO dao = new CustomerDAO();
            int newId = dao.insert(c);
            if (newId > 0) {
                request.getSession().setAttribute("message", "Thêm khách hàng thành công!");
                logActivity(request, "customer", newId, name.trim(), "CREATE",
                        "Tạo khách hàng: " + name.trim() + " - " + phone.trim());
            } else {
                request.getSession().setAttribute("message", "Thêm khách hàng thất bại!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list");
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            CustomerDAO dao = new CustomerDAO();
            Customer c = dao.findById(id);
            if (c != null) {
                request.setAttribute("customer", c);
                CategoryDAO catDAO = new CategoryDAO();
                request.setAttribute("customerTypeList", catDAO.findByType("customer_type"));
                request.getRequestDispatcher("/view/customer/customer-edit.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list");
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String companyName = request.getParameter("companyName");
            String typeIdStr = request.getParameter("customerTypeId");
            String status = request.getParameter("status");

            Map<String, String> errors = validateCustomerForm(name, phone, email, id);
            if (!errors.isEmpty()) {
                saveFormFields(request, name, phone, email, address, companyName, typeIdStr, request.getParameter("note"));
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=update&id=" + id);
                return;
            }

            CustomerDAO dao = new CustomerDAO();
            Customer c = dao.findById(id);
            if (c != null) {
                c.setName(name.trim());
                c.setPhone(phone.trim());
                c.setEmail(email != null ? email.trim() : null);
                c.setAddress(address);
                c.setCompanyName(companyName);
                if (typeIdStr != null && !typeIdStr.isEmpty()) {
                    c.setCustomerTypeId(Integer.parseInt(typeIdStr));
                }
                c.setStatus(status);
                c.setUpdatedAt(LocalDateTime.now());
                User user = (User) request.getSession().getAttribute("loggedUser");
                c.setUpdatedBy(user != null ? user.getId() : null);

                boolean ok = dao.update(c);
                if (ok) {
                    request.getSession().setAttribute("message", "Cập nhật thành công!");
                    logActivity(request, "customer", id, name.trim(), "UPDATE",
                            "Cập nhật thông tin khách hàng: " + name.trim());
                } else {
                    request.getSession().setAttribute("message", "Cập nhật thất bại!");
                }
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy khách hàng!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list");
    }

    private void activateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) currentPage = "1";
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            CustomerDAO dao = new CustomerDAO();
            boolean ok = dao.activate(id);
            if (ok) {
                request.getSession().setAttribute("message", "Kích hoạt thành công!");
                Customer c = dao.findById(id);
                if (c != null) {
                    logActivity(request, "customer", id, c.getName(), "ACTIVATE",
                            "Kích hoạt khách hàng: " + c.getName());
                }
            } else {
                request.getSession().setAttribute("message", "Kích hoạt thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list&page=" + currentPage);
    }

    private void deactivateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) currentPage = "1";
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            CustomerDAO dao = new CustomerDAO();
            boolean ok = dao.deactivate(id);
            if (ok) {
                request.getSession().setAttribute("message", "Khóa thành công!");
                Customer c = dao.findById(id);
                if (c != null) {
                    logActivity(request, "customer", id, c.getName(), "DEACTIVATE",
                            "Khóa khách hàng: " + c.getName());
                }
            } else {
                request.getSession().setAttribute("message", "Khóa thất bại!");
            }
        }
        response.sendRedirect(request.getContextPath() + "/warehouse/customers?action=list&page=" + currentPage);
    }

    private Map<String, String> validateCustomerForm(String name, String phone,
            String email, Integer excludeId) {
        Map<String, String> errors = new HashMap<>();

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Tên khách hàng không được để trống");
        } else if (name.trim().length() > 255) {
            errors.put("name", "Tên khách hàng không được vượt quá 255 ký tự");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phone", "Số điện thoại không được để trống");
        } else {
            CustomerDAO dao = new CustomerDAO();
            if (dao.isPhoneExists(phone.trim(), excludeId)) {
                errors.put("phone", "Số điện thoại này đã tồn tại");
            }
        }

        if (email != null && !email.trim().isEmpty()) {
            if (!email.trim().matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                errors.put("email", "Email không đúng định dạng");
            }
        }

        return errors;
    }

    private void saveFormFields(HttpServletRequest request, String name, String phone,
            String email, String address, String companyName, String customerTypeId, String note) {
        request.getSession().setAttribute("fieldName", name);
        request.getSession().setAttribute("fieldPhone", phone);
        request.getSession().setAttribute("fieldEmail", email);
        request.getSession().setAttribute("fieldAddress", address);
        request.getSession().setAttribute("fieldCompanyName", companyName);
        request.getSession().setAttribute("fieldCustomerTypeId", customerTypeId);
        request.getSession().setAttribute("fieldNote", note);
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
}