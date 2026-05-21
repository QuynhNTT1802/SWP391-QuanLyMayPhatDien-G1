package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.config.GlobalConfig;
import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.Permission;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.BCryptUtils;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users"})
public class UserManagementController extends HttpServlet {

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
            case "update": {
                try {
                    showUpdateForm(request, response);
                } catch (SQLException ex) {
                    Logger.getLogger(UserManagementController.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
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
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
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

    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findById(userId);
            if (user != null) {
                RoleDAO roleDAO = new RoleDAO();
                user.setRoles(roleDAO.getRolesByUserId(userId));
                request.setAttribute("user", user);

                String name = user.getName() != null ? user.getName().trim() : "";
                String initials = "";

                if (!name.isEmpty()) {
                    String[] parts = name.split(" ");
                    if (parts.length == 1) {
                        initials = parts[0].substring(0, 1);
                    } else {
                        initials = parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
                    }
                }
                request.setAttribute("userInitials", initials.toUpperCase());

                java.time.format.DateTimeFormatter df = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                request.setAttribute("createdDate", user.getCreatedAt() != null ? user.getCreatedAt().format(df) : "—");
                request.setAttribute("updatedDate", user.getUpdatedAt() != null ? user.getUpdatedAt().format(dtf) : "—");

                request.getRequestDispatcher("/view/admin/admin-user-detail.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RoleDAO roleDAO = new RoleDAO();
        request.setAttribute("allRoles", roleDAO.findAll());
        request.getRequestDispatcher("/view/admin/admin-user-create.jsp").forward(request, response);
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
            newUser.setPassword(BCryptUtils.hash(password));
            newUser.setName(name);
            newUser.setPhone(phone);
            newUser.setAddress(address);
            newUser.setStatus(status);
            newUser.setCreatedAt(LocalDateTime.now());
            newUser.setUpdatedAt(LocalDateTime.now());
            newUser.setCreatedBy(1);

            UserDAO userDAO = new UserDAO();
            int newUserId = userDAO.insert(newUser);
            if (newUserId > 0) {
                String[] roleIdsParam = request.getParameterValues("roleIds");
                List<Integer> roleIdList = new ArrayList<>();
                if (roleIdsParam != null) {
                    for (String r : roleIdsParam) {
                        roleIdList.add(Integer.parseInt(r));
                    }
                }
                if (!roleIdList.isEmpty()) {
                    userDAO.updateUserRoles(newUserId, roleIdList);

                    RoleDAO roleDAO = new RoleDAO();
                    for (Role r : roleDAO.findAll()) {
                        if (roleIdList.contains(r.getRoleId()) && "admin".equals(r.getRoleName())) {
                            String sql = "INSERT INTO admin (admin_id) VALUES (?)";
                            try (java.sql.Connection c = userDAO.getConnection(); java.sql.PreparedStatement ps = c.prepareStatement(sql)) {
                                ps.setInt(1, newUserId);
                                ps.executeUpdate();
                            }
                            break;
                        }
                    }
                }
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
            throws ServletException, IOException, SQLException {
        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            int userId = Integer.parseInt(userIdStr);
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findById(userId);
            if (user != null) {
                RoleDAO roleDAO = new RoleDAO();
                user.setRoles(roleDAO.getRolesByUserId(userId));
                request.setAttribute("user", user);
                request.setAttribute("allRoles", roleDAO.findAll());

                PermissionDAO perDAO = new PermissionDAO();
                List<Permission> allPermissions = perDAO.findAll();
                List<String[]> userOverrides = perDAO.getUserOverrides(userId);

                Map<String, List<Permission>> groupedPerms = new LinkedHashMap<>();
                for (Permission p : allPermissions) {
                    groupedPerms.computeIfAbsent(p.getResource(), k -> new ArrayList<>()).add(p);
                }
                request.setAttribute("groupedPerms", groupedPerms);
                request.setAttribute("userOverrides", userOverrides);

                request.getRequestDispatcher("/view/admin/admin-user-edit.jsp").forward(request, response);
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
        int userId = 0;
        try {
            userId = Integer.parseInt(request.getParameter("id"));
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

                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                user.setStatus(status);
                user.setUpdatedAt(LocalDateTime.now());
                user.setUpdatedBy(1);

                boolean isUpdated = userDAO.update(user);

                //add role
                if (isUpdated) {
                    String[] roleIds = request.getParameterValues("roleIds");
                    List<Integer> roleIdList = new ArrayList<>();
                    if (roleIds != null) {
                        for (String r : roleIds) {
                            roleIdList.add(Integer.parseInt(r));
                        }
                    }
                    userDAO.updateUserRoles(userId, roleIdList);

                    String overrideSubmitted = request.getParameter("perOverride_submitted");
                    if ("1".equals(overrideSubmitted)) {
                        PermissionDAO perDAO = new PermissionDAO();
                        List<Permission> allPermissions = perDAO.findAll();
                        for (Permission perm : allPermissions) {
                            String overrideType = request.getParameter("perOverride_" + perm.getPermissionId());
                            if ("GRANT".equals(overrideType) || "DENY".equals(overrideType)) {
                                perDAO.setUserOverride(userId, perm.getPermissionId(), overrideType);
                            } else if ("default".equals(overrideType)) {
                                perDAO.removeUserOverride(userId, perm.getPermissionId());
                            }
                        }
                    }

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

        response.sendRedirect(request.getContextPath() + "/admin/users?action=update&id=" + userId);
    }

    private Map<String, String> validateForm(String username, String password,
            String email, String phone, Integer userId) {
        Map<String, String> errors = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        if (username != null && !username.isEmpty()) {
            if (username.length() < 3 || username.length() > 50) {
                errors.put("username", "Tên đăng nhập phải có độ dài từ 3 đến 50 ký tự");
            } else if (!username.matches(GlobalConfig.REGEX_USERNAME)) {
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
            } else if (!password.matches(GlobalConfig.REGEX_PASSWORD)) {
                errors.put("password", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số");
            }
        } else if (userId == null) {
            errors.put("password", "Mật khẩu không được để trống");
        }

        if (email != null && !email.isEmpty()) {
            if (!email.matches(GlobalConfig.REGEX_EMAIL)) {
                errors.put("email", "Định dạng email không hợp lệ");
            } else if (userDAO.isEmailExists(email, userId)) {
                errors.put("email", "Email đã được sử dụng");
            }
        } else {
            errors.put("email", "Email không được để trống");
        }

        if (phone != null && !phone.isEmpty()) {
            if (!phone.matches(GlobalConfig.REGEX_PHONE)) {
                errors.put("phone", "Số điện thoại phải bắt đầu bằng số 0 và có 10 chữ số");
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
        if (userIdStr != null && !userIdStr.isEmpty()) {
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
        List<User> users = userDAO.findUsersWithRoles(roleFilter, statusFilter, searchFilter, page, pageSize);
        prepareUserDisplayData(users, request);
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
        request.setAttribute("lockedCount", userDAO.countUsersByStatus("locked"));
        request.setAttribute("now", LocalDateTime.now());

        request.getRequestDispatcher("/view/admin/admin-user.jsp").forward(request, response);
    }

    private void prepareUserDisplayData(List<User> users, HttpServletRequest request) {
        List<String> userInitials = new ArrayList<>();
        List<String> userAvatarClass = new ArrayList<>();
        List<String> userCreatedDate = new ArrayList<>();
        List<String> userCreatedTime = new ArrayList<>();
        String[] avatarColors = {"green", "blue", "orange", "purple", "pink", "teal", "grey"};
        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");

        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);
            String name = u.getName() != null ? u.getName().trim() : "";
            int lastSpace = name.lastIndexOf(' ');
            String initials = name.isEmpty() ? "?"
                    : (name.substring(0, 1)
                            + (lastSpace >= 0 && lastSpace + 1 < name.length()
                            ? name.substring(lastSpace + 1, lastSpace + 2) : ""))
                            .toUpperCase();
            userInitials.add(initials);
            userAvatarClass.add(avatarColors[i % 7]);
            if (u.getCreatedAt() != null) {
                userCreatedDate.add(u.getCreatedAt().format(dateFmt));
                userCreatedTime.add(u.getCreatedAt().format(timeFmt));
            } else {
                userCreatedDate.add("—");
                userCreatedTime.add("");
            }
        }
        request.setAttribute("userInitials", userInitials);
        request.setAttribute("userAvatarClass", userAvatarClass);
        request.setAttribute("userCreatedDate", userCreatedDate);
        request.setAttribute("userCreatedTime", userCreatedTime);
        request.setAttribute("nowFormatted",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
    }

}
