package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.utils.GlobalUtils;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
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
        if (action == null || action.isEmpty()) {
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
                    ex.printStackTrace();
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
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                request.setAttribute("createdDate", user.getCreatedAt() != null ? user.getCreatedAt().format(dtf) : "—");
                request.setAttribute("updatedDate", user.getUpdatedAt() != null ? user.getUpdatedAt().format(dtf) : "—");

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
                ActivityLogDAO logDAO = new ActivityLogDAO();
                List<ActivityLog> historyLogs = logDAO.findByEntityTypeAndId2("user", userId, histSearch, historyAction, histDateFrom, histDateTo, histPage, histPageSize);
                int histTotalLogs = logDAO.countByEntityTypeAndId2("user", userId, histSearch, historyAction, histDateFrom, histDateTo);
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
                }
                request.getSession().setAttribute("message", "Thêm người dùng thành công!");
                logActivity(request, "user", newUserId, name, "CREATE",
                        "Tạo người dùng: " + username);
            } else {
                request.getSession().setAttribute("message", "Thêm người dùng thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
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
            RoleDAO roleDAO = new RoleDAO();
            PermissionDAO perDAO = new PermissionDAO();
            User user = userDAO.findById(userId);

            if (user != null) {
                Map<String, String> errors = validateForm(null, password, email, phone, userId);
                if (!errors.isEmpty()) {
                    request.getSession().setAttribute("errors", errors);
                    request.getSession().setAttribute("formData", request.getParameterMap());

                    response.sendRedirect(request.getContextPath() + "/admin/users?action=update&id=" + userId);
                    return;
                }

                String beforeName = user.getName();
                String beforeEmail = user.getEmail();
                String beforePhone = user.getPhone();
                String beforeAddress = user.getAddress();
                String beforeStatus = user.getStatus();
                List<Role> beforeRoles = roleDAO.getRolesByUserId(userId);
                List<String[]> beforeOverrides = perDAO.getUserOverrides(userId);

                List<String> fieldChanges = new ArrayList<>();
                if (!equalsStr(beforeName, name)) {
                    fieldChanges.add("name: \"" + safe(beforeName) + "\" → \"" + safe(name) + "\"");
                }
                if (!equalsStr(beforeEmail, email)) {
                    fieldChanges.add("email: \"" + safe(beforeEmail) + "\" → \"" + safe(email) + "\"");
                }
                if (!equalsStr(beforePhone, phone)) {
                    fieldChanges.add("phone: \"" + safe(beforePhone) + "\" → \"" + safe(phone) + "\"");
                }
                if (!equalsStr(beforeAddress, address)) {
                    fieldChanges.add("address: \"" + safe(beforeAddress) + "\" → \"" + safe(address) + "\"");
                }
                if (!equalsStr(beforeStatus, status)) {
                    fieldChanges.add("status: \"" + safe(beforeStatus) + "\" → \"" + safe(status) + "\"");
                }

                user.setName(name);
                user.setEmail(email);
                user.setPhone(phone);
                user.setAddress(address);
                user.setStatus(status);
                user.setUpdatedAt(LocalDateTime.now());
                user.setUpdatedBy(1);

                boolean isUpdated = userDAO.update(user);

                if (isUpdated) {
                    String[] roleIds = request.getParameterValues("roleIds");
                    List<Integer> roleIdList = new ArrayList<>();
                    if (roleIds != null) {
                        for (String r : roleIds) {
                            roleIdList.add(Integer.parseInt(r));
                        }
                    }
                    userDAO.updateUserRoles(userId, roleIdList);

                    List<Role> afterRoles = roleDAO.getRolesByUserId(userId);
                    String roleDiff = diffRoles(beforeRoles, afterRoles);
                    if (!roleDiff.isEmpty()) {
                        fieldChanges.add("roles: " + roleDiff);
                    }

                    String overrideSubmitted = request.getParameter("perOverride_submitted");
                    if ("1".equals(overrideSubmitted)) {
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
                    List<String[]> afterOverrides = perDAO.getUserOverrides(userId);
                    String overrideDiff = diffOverrides(beforeOverrides, afterOverrides);
                    if (!overrideDiff.isEmpty()) {
                        fieldChanges.add("permissions: " + overrideDiff);
                    }

                    if (password != null && !password.isEmpty()) {
                        fieldChanges.add("password: đã đặt lại");
                    }

                    request.getServletContext().setAttribute("perm_refresh_" + userId, true);

                    request.getSession().setAttribute("message", "Cập nhật thành công");
                    String details;
                    if (fieldChanges.isEmpty()) {
                        details = "Cập nhật người dùng #" + userId + " (" + safe(name) + "): không có thay đổi";
                    } else {
                        details = "Cập nhật người dùng #" + userId + " (" + safe(name) + "): "
                                + String.join("; ", fieldChanges);
                    }
                    logActivity(request, "user", userId, name, "UPDATE", details);
                } else {
                    request.getSession().setAttribute("message", "Cập nhật thất bại");
                }
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy tài khoản!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("Error", e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?action=update&id=" + userId);
    }

    private static boolean equalsStr(String a, String b) {
        if (a == null) {
            return b == null;
        }
        return a.equals(b);
    }

    private static String safe(String s) {
        return s == null ? "" : s;
    }

    private static String diffRoles(List<Role> before, List<Role> after) {
        Set<String> beforeSet = new java.util.TreeSet<>();
        Set<String> afterSet = new java.util.TreeSet<>();
        for (Role r : before) {
            beforeSet.add(r.getRoleName());
        }
        for (Role r : after) {
            afterSet.add(r.getRoleName());
        }
        java.util.Set<String> added = new java.util.LinkedHashSet<>(afterSet);
        added.removeAll(beforeSet);
        java.util.Set<String> removed = new java.util.LinkedHashSet<>(beforeSet);
        removed.removeAll(afterSet);
        List<String> parts = new ArrayList<>();
        if (!added.isEmpty()) {
            parts.add("+" + String.join(",", added));
        }
        if (!removed.isEmpty()) {
            parts.add("-" + String.join(",", removed));
        }
        return String.join(" ", parts);
    }

    private static String diffOverrides(List<String[]> before, List<String[]> after) {
        Map<String, String> beforeMap = new java.util.LinkedHashMap<>();
        for (String[] o : before) {
            beforeMap.put(o[0], o[1]);
        }
        Map<String, String> afterMap = new java.util.LinkedHashMap<>();
        for (String[] o : after) {
            afterMap.put(o[0], o[1]);
        }
        List<String> parts = new ArrayList<>();
        for (Map.Entry<String, String> e : afterMap.entrySet()) {
            String prev = beforeMap.get(e.getKey());
            if (prev == null) {
                parts.add("+" + e.getKey() + "=" + e.getValue());
            } else if (!prev.equals(e.getValue())) {
                parts.add(e.getKey() + ": " + prev + "→" + e.getValue());
            }
        }
        for (Map.Entry<String, String> e : beforeMap.entrySet()) {
            if (!afterMap.containsKey(e.getKey())) {
                parts.add("-" + e.getKey() + "=" + e.getValue());
            }
        }
        return String.join("; ", parts);
    }

    private Map<String, String> validateForm(String username, String password,
            String email, String phone, Integer userId) {
        Map<String, String> errors = new HashMap<>();
        UserDAO userDAO = new UserDAO();

        if (username != null && !username.isEmpty()) {
            if (username.length() < 3 || username.length() > 50) {
                errors.put("username", "Tên đăng nhập phải có độ dài từ 3 đến 50 ký tự");
            } else if (!username.matches(GlobalUtils.REGEX_USERNAME)) {
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
            } else if (!password.matches(GlobalUtils.REGEX_PASSWORD)) {
                errors.put("password", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số");
            }
        } else if (userId == null) {
            errors.put("password", "Mật khẩu không được để trống");
        }

        if (email != null && !email.isEmpty()) {
            if (!email.matches(GlobalUtils.REGEX_EMAIL)) {
                errors.put("email", "Định dạng email không hợp lệ");
            } else if (userDAO.isEmailExists(email, userId)) {
                errors.put("email", "Email đã được sử dụng");
            }
        } else {
            errors.put("email", "Email không được để trống");
        }

        if (phone != null && !phone.isEmpty()) {
            if (!phone.matches(GlobalUtils.REGEX_PHONE)) {
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
                    request.getSession().setAttribute("message", "Không thể khóa Quản trị viên");
                } else {
                    boolean check = userDAO.deactivateAccount(userId);
                    if (check) {
                        request.getSession().setAttribute("message", "Khóa người dùng thành công");
                        logActivity(request, "user", userId, user.getName(), "DEACTIVATE",
                                "Khóa người dùng: " + user.getUsername());
                    } else {
                        request.getSession().setAttribute("message", "Khóa người dùng thất bại");
                    }
                }
            } else {
                request.getSession().setAttribute("message", "Không tìm thấy người dùng");
            }
        } else {
            request.getSession().setAttribute("message", "Không tìm thấy ID");
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
                request.getSession().setAttribute("message", "Kích hoạt người dùng thành công");
                User user = userDAO.findById(userId);
                if (user != null) {
                    logActivity(request, "user", userId, user.getName(), "ACTIVATE",
                            "Kích hoạt người dùng: " + user.getUsername());
                }
            } else {
                request.getSession().setAttribute("message", "Kích hoạt người dùng thất bại");
            }
        } else {
            request.getSession().setAttribute("message", "Không tìm thấy ID");
        }
        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&page=" + currentPage);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        int totalUsers = userDAO.getTotalFilteredUsers(roleFilter, statusFilter, searchFilter);
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

        request.getRequestDispatcher("/view/admin/admin-user.jsp").forward(request, response);
    }

    private void prepareUserDisplayData(List<User> users, HttpServletRequest request) {
        List<String> userInitials = new ArrayList<>();
        List<String> userAvatarClass = new ArrayList<>();
        String[] avatarColors = {"green", "blue", "orange", "purple", "pink", "teal", "grey"};

        for (int i = 0; i < users.size(); i++) {
            User u = users.get(i);

            String name = u.getName() != null ? u.getName().trim() : "";
            String initials = "";

            if (!name.isEmpty()) {
                String[] parts = name.split(" ");
                if (parts.length == 1) {
                    initials = parts[0].substring(0, 1);
                } else {
                    initials = parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1);
                }
            } else {
                initials = "?";
            }

            userInitials.add(initials.toUpperCase());
            userAvatarClass.add(avatarColors[i % avatarColors.length]);
        }

        request.setAttribute("userInitials", userInitials);
        request.setAttribute("userAvatarClass", userAvatarClass);
    }

    private void logActivity(HttpServletRequest request, String entityType,
            int entityId, String entityName, String action, String details) {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            return;
        }
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