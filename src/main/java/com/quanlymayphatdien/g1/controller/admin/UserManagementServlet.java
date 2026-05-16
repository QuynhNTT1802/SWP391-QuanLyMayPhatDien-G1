package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.AdminDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Aadmin
 */
@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users"})
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                showCreateForm(request, response);
                break;
            case "update":
                showUpdateForm(request, response); // Sửa từ showUpdateForm thành showEditForm cho khớp bên dưới
                break;
            case "deactivate":
                deactivateUser(request, response);
                break;
            case "activate":
                activateUser(request, response);
                break;
            case "list":
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            case "list":
            default:
                listUsers(request, response);
                break;
        }
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/create-user.jsp");
        dispatcher.forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String status = request.getParameter("status");
            if (status == null || status.isEmpty()) {
                status = "active";
            }
            Map<String, String> errors = validateForm(username, password, email, phone, null);
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                request.getSession().setAttribute("formData", request.getParameterMap());

                response.sendRedirect(request.getContextPath() + "/admin/users?action=create");
                return;
            }

            User newUser = new User() {
            };
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPassword(password);
            newUser.setName(name);
            newUser.setPhone(phone);
            newUser.setAddress(address);
            newUser.setStatus(status);
            newUser.setCreatedAt(LocalDateTime.now());
            newUser.setUpdatedAt(LocalDateTime.now());
            newUser.setCreatedBy(1);
            UserDAO userDAO = new UserDAO();
            boolean isSuccess = userDAO.insert(newUser) > 0;
            if (isSuccess) {
                request.getSession().setAttribute("message", "User added successfully!");
            } else {
                request.getSession().setAttribute("message", "Failed to add user!");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("message", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findById(userId);
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/admin/update-user.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }

        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            String password = request.getParameter("password");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String status = request.getParameter("status");

            UserDAO userDAO = new UserDAO();
            User user = userDAO.findById(userId);

            if (user != null) {
                Map<String, String> errors = validateForm(null, password, email, phone, userId);
                if (!errors.isEmpty()) {
                    request.getSession().setAttribute("errors", errors);
                    request.getSession().setAttribute("formData", request.getParameterMap());

                    response.sendRedirect(request.getContextPath() + "/admin/users?action=update&id=" + userId);
                    return;
                }

                user.setPassword(password);
                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                user.setStatus(status);
                user.setUpdatedAt(LocalDateTime.now());
                user.setUpdatedBy(1);

                boolean isUpdated = userDAO.update(user);
                if (isUpdated) {
                    request.getSession().setAttribute("message", "Update successfully");
                } else {
                    request.getSession().setAttribute("message", "Fail to update");
                }
            } else {
                request.getSession().setAttribute("message", "Account not found!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("Error", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&page=" + currentPage);
    }

    private Map<String, String> validateForm(String username, String password, String email, String phone, Integer userId) {
        Map<String, String> errors = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        if (username != null && !username.isEmpty()) {
            if (username.length() < 3 || username.length() > 50) {
                errors.put("username", "Tên đăng nhập phải có độ dài từ 3 đến 50 ký tự");
            } else if (!username.matches("^[a-zA-Z0-9_]+$")) {
                errors.put("username", "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới");
            } else if (userDAO.isUsernameExists(username)) {
                errors.put("username", "Tên đăng nhập đã tồn tại");
            }
        } else if (userId == null) {
            errors.put("username", "Tên đăng nhập không được để trống");
        }

        if (password != null && !password.isEmpty()) {
            if (password.length() < 6) {
                errors.put("password", "Mật khẩu phải có ít nhất 6 ký tự");
            } else if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$")) {
                errors.put("password", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số");
            }
        } else if (userId == null) {
            errors.put("password", "Mật khẩu không được để trống");
        }

        if (email != null && !email.isEmpty()) {
            String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
            if (!email.matches(emailRegex)) {
                errors.put("email", "Định dạng email không hợp lệ");
            } else if (userDAO.isEmailExists(email, userId)) {
                errors.put("email", "Email đã được sử dụng");
            }
        } else {
            errors.put("email", "Email không được để trống");
        }

        if (phone != null && !phone.isEmpty()) {
            if (!phone.matches("^0[0-9]{9,10}$")) {
                errors.put("phone", "Số điện thoại phải bắt đầu bằng số 0 và có 10 hoặc 11 chữ số");
            } else if (userDAO.isPhoneExists(phone, userId)) {
                errors.put("phone", "Số điện thoại này đã được sử dụng");
            }
        } else {
            errors.put("phone", "Số điện thoại không được để trống");
        }

        return errors;
    }

    private void deactivateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }

        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            RoleDAO roleDAO = new RoleDAO();
            User user = userDAO.findById(userId);
            if (user != null) {
                List<Role> userRoles = roleDAO.getRolesByUserId(userId);
                boolean isAdmin = false;
                if (userRoles != null) {
                    for (Role role : userRoles) {
                        if (role.getRoleName().equals("admin")) {
                            isAdmin = true;
                            break;
                        }
                    }
                }

                if (isAdmin) {
                    request.getSession().setAttribute("message", "Cannot deactivate admin");
                } else {
                    boolean check = userDAO.deactivateAccount(userId);
                    if (check) {
                        request.getSession().setAttribute("message", "Deactivate successfully");
                    } else {
                        request.getSession().setAttribute("message", "Fail to deactivate");
                    }
                }
            } else {
                request.getSession().setAttribute("message", "User not found");
            }
        } else {
            request.getSession().setAttribute("message", "UserID not found");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&page=" + currentPage);
    }

    private void activateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String currentPage = request.getParameter("page");
        if (currentPage == null || currentPage.isEmpty()) {
            currentPage = "1";
        }

        String userIdStr = request.getParameter("id");
        if (userIdStr != null || !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            boolean check = userDAO.activateAccount(userId);
            if (check) {
                request.getSession().setAttribute("message", "Activate user  successfully");
            } else {
                request.getSession().setAttribute("message", "Fail to activate user");
            }
        } else {
            request.getSession().setAttribute("message", "UserID not found");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&page=" + currentPage);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchFilter = request.getParameter("search");
        String statusFilter = request.getParameter("status");
        String roleFilter = request.getParameter("role");

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
                page = 1;
            }
        }

        UserDAO userDAO = new UserDAO();
        // TODO: temporarily disable role filter for testing
        List<User> users = userDAO.findUsersWithFilters(null, statusFilter, searchFilter, page, pageSize);
        int totalUsers = userDAO.getTotalFilteredUsers(null, statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("searchFilter", searchFilter);

        request.setAttribute("activeCount", userDAO.countUsersByStatus("active"));
        request.setAttribute("inactiveCount", userDAO.countUsersByStatus("inactive"));
        request.setAttribute("pendingCount", userDAO.countUsersByStatus("pending"));
        request.setAttribute("lockedCount", userDAO.countUsersByStatus("locked"));
        request.setAttribute("now", LocalDateTime.now());

        request.getRequestDispatcher("/view/admin/admin-user.jsp").forward(request, response);
    }
    

    
    
}
