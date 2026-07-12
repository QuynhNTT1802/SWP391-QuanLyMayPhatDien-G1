package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.Permission;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.SystemLogger;
import com.quanlymayphatdien.g1.utils.LogModule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "RoleController", urlPatterns = {
    "/admin/roles",
    "/admin/role/edit",
    "/admin/role/save"
})
public class RoleController extends HttpServlet {

    private final RoleDAO roleDAO = new RoleDAO();
    private final PermissionDAO perDAO = new PermissionDAO();
    private final ActivityLogDAO logDAO = new ActivityLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        String action = request.getServletPath();
        try {
            if ("/admin/roles".equals(action)) {
                viewRoleList(request, response);
            } else if ("/admin/role/edit".equals(action)) {
                viewRolePermission(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.ROLE, "RoleController",
                "Lỗi xử lý GET " + action + ": " + e.getMessage(), e);
            throw new ServletException(e);
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
        try {
            if ("/admin/role/save".equals(request.getServletPath())) {
                saveRoleFull(request, response);
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.ROLE, "RoleController",
                "Lỗi xử lý POST /admin/role/save: " + e.getMessage(), e);
            throw new ServletException(e);
        }
    }


    private void viewRoleList(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String search = request.getParameter("search");
        List<Role> roleList;
        if (search != null && !search.trim().isEmpty()) {
            roleList = roleDAO.searchByName(search.trim());
        } else {
            roleList = roleDAO.findAll();
        }

        int page = 1;
        int pageSize = 12;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalItems = roleList.size();
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<Role> pageList = roleList.subList(fromIndex, toIndex);

        request.setAttribute("roleList", pageList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("fromIndex", fromIndex + 1);
        request.setAttribute("toIndex", toIndex);

        request.getRequestDispatcher("/view/admin/admin-role.jsp").forward(request, response);
    }


    private void viewRolePermission(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id");
        String permSearch = request.getParameter("permSearch");

        List<Permission> allPermissions = perDAO.findAll();


        Map<String, Map<String, List<Permission>>> groupedByModule = buildGroupedByModule(allPermissions, permSearch);
        request.setAttribute("groupedByModule", groupedByModule);
        request.setAttribute("taskLabels", TASK_LABELS);
        request.setAttribute("totalPermCount", allPermissions.size());
        request.setAttribute("totalModuleCount", groupedByModule.size());

        if (idParam != null && !idParam.isEmpty()) {
            int roleId = Integer.parseInt(idParam);
            Role curRole = null;
            for (Role r : roleDAO.findAll()) {
                if (r.getRoleId() == roleId) {
                    curRole = r;
                    break;
                }
            }
            List<Permission> rolePermissions = perDAO.getPermissionByRoleId(roleId);

            request.setAttribute("role", curRole);
            request.setAttribute("rolePermissions", rolePermissions);

            // Tải lịch sử thay đổi của role này
            int histPage = 1;
            String histPageStr = request.getParameter("histPage");
            if (histPageStr != null && !histPageStr.isEmpty()) {
                try { histPage = Math.max(1, Integer.parseInt(histPageStr)); }
                catch (NumberFormatException ignored) {}
            }
            int histPageSize = 10;
            
            String histSearch = request.getParameter("histSearch");
            String histAction = request.getParameter("histAction");
            String histDateFrom = request.getParameter("histDateFrom");
            String histDateTo = request.getParameter("histDateTo");

            List<ActivityLog> roleHistory = logDAO.getLogsByRoleId(roleId, histSearch, histAction, histDateFrom, histDateTo, histPage, histPageSize);
            int histTotal = logDAO.countLogsByRoleId(roleId, histSearch, histAction, histDateFrom, histDateTo);
            int histTotalPages = Math.max(1, (int) Math.ceil((double) histTotal / histPageSize));
            if (histPage > histTotalPages) histPage = histTotalPages;

            request.setAttribute("roleHistory", roleHistory);
            request.setAttribute("histPage", histPage);
            request.setAttribute("histTotalPages", histTotalPages);
            request.setAttribute("histTotal", histTotal);
            
            request.setAttribute("histSearch", histSearch);
            request.setAttribute("histAction", histAction);
            request.setAttribute("histDateFrom", histDateFrom);
            request.setAttribute("histDateTo", histDateTo);

            String activeTab = request.getParameter("activeTab");
            request.setAttribute("activeTab", "history".equals(activeTab) ? "history" : "info");
        }
        request.getRequestDispatcher("/view/admin/admin-role-edit.jsp").forward(request, response);
    }


    private void saveRoleFull(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        @SuppressWarnings("unchecked")
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String desc = request.getParameter("description");
        String status = request.getParameter("status");

        List<String> errors = new ArrayList<>();

        if (name == null || name.trim().isEmpty()) {
            errors.add("Tên vai trò không được để trống");
        } else {
            name = name.trim();
            if (name.length() > 100) {
                errors.add("Tên vai trò không được vượt quá 100 ký tự");
            }
        }

        int excludeId = 0;
        boolean isEdit = idParam != null && !idParam.isEmpty();
        if (isEdit) {
            try {
                excludeId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                errors.add("ID vai trò không hợp lệ");
            }
        }

        Role existingRole = null;
        if (excludeId > 0) {
            for (Role r : roleDAO.findAll()) {
                if (r.getRoleId() == excludeId) {
                    existingRole = r;
                    break;
                }
            }
        }

        if (existingRole != null && "admin".equalsIgnoreCase(existingRole.getRoleName())) {
            if (name != null && !name.equalsIgnoreCase("admin")) {
                errors.add("Không thể đổi tên vai trò Quản trị viên");
            }
            if ("inactive".equals(status)) {
                errors.add("Không thể khóa vai trò Quản trị viên");
            }
        }

        if (name != null && !name.trim().isEmpty() && errors.isEmpty()) {
            if (roleDAO.isRoleNameExists(name, excludeId)) {
                errors.add("Tên vai trò đã tồn tại");
            }
        }

        if (status == null) {
            status = "active";
        } else if (!"active".equals(status) && !"inactive".equals(status)) {
            errors.add("Trạng thái không hợp lệ");
        }

        if (desc != null && desc.length() > 500) {
            errors.add("Mô tả không được vượt quá 500 ký tự");
        }

        String[] perIdsString = request.getParameterValues("perIds");
        List<Integer> perIds = new ArrayList<>();
        if (perIdsString != null) {
            for (String pId : perIdsString) {
                try {
                    perIds.add(Integer.parseInt(pId));
                } catch (NumberFormatException e) {
                    errors.add("Danh sách quyền chứa giá trị không hợp lệ");
                    break;
                }
            }
        }

        if (!errors.isEmpty()) {
            Role formRole = new Role();
            formRole.setRoleName(name);
            formRole.setDescription(desc);
            formRole.setStatus(status);
            if (excludeId > 0) {
                formRole.setRoleId(excludeId);
            }
            request.setAttribute("role", formRole);
            request.setAttribute("errors", errors);

            List<Permission> allPermissions = perDAO.findAll();
            String permSearch = request.getParameter("permSearch");
            Map<String, Map<String, List<Permission>>> groupedByModule = buildGroupedByModule(allPermissions, permSearch);
            request.setAttribute("groupedByModule", groupedByModule);
            request.setAttribute("taskLabels", TASK_LABELS);
            request.setAttribute("totalPermCount", allPermissions.size());
            request.setAttribute("totalModuleCount", groupedByModule.size());

            if (excludeId > 0) {
                List<Permission> rolePerms = perDAO.getPermissionByRoleId(excludeId);
                request.setAttribute("rolePermissions", rolePerms);
            }

            request.getRequestDispatcher("/view/admin/admin-role-edit.jsp").forward(request, response);
            return;
        }

        Role role = new Role();
        role.setRoleName(name);
        role.setDescription(desc);
        role.setStatus(status);

        int roleId;
        if (!isEdit) {
            if (permissions == null || !permissions.contains("roles.create")) {
                request.getRequestDispatcher("/view/error/role-error.jsp").forward(request, response);
                return;
            }
            roleId = roleDAO.insert(role);
            // --- LOG: Tạo role mới ---
            String createDetails = "Tạo vai trò mới — Mô tả: "
                + (desc != null && !desc.trim().isEmpty() ? desc.trim() : "(trống)");
            logRoleAction(request, roleId, name, "CREATE_ROLE", createDetails);
        } else {
            if (permissions == null || !permissions.contains("roles.update")) {
                request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                return;
            }
            roleId = excludeId;
            role.setRoleId(roleId);
            roleDAO.update(role);
            // --- LOG: Cập nhật thông tin role ---
            String oldName   = existingRole != null ? existingRole.getRoleName() : name;
            String oldStatus = existingRole != null ? existingRole.getStatus()   : status;
            String oldDesc   = existingRole != null && existingRole.getDescription() != null
                               ? existingRole.getDescription() : "";
            String updateAction = ("active".equals(oldStatus) && "inactive".equals(status))
                                  ? "DEACTIVATE_ROLE" : "UPDATE_ROLE";
            List<String> changes = new ArrayList<>();
            if (!name.equals(oldName))
                changes.add("Tên: '" + oldName + "' -> '" + name + "'");
            if (!status.equals(oldStatus))
                changes.add("Trạng thái: " + oldStatus + " -> " + status);
            String newDescTrim = desc != null ? desc.trim() : "";
            if (!newDescTrim.equals(oldDesc.trim()))
                changes.add("Mô tả đã thay đổi");
            String updateDetails = "Cập nhật vai trò '" + name + "'"
                + (changes.isEmpty() ? "" : " — " + String.join(", ", changes));
            logRoleAction(request, roleId, name, updateAction, updateDetails);
        }

        List<Permission> allPerms = perDAO.findAll();
        Map<Integer, Permission> permById = new HashMap<>();
        Map<String, Integer> resourceViewPermId = new HashMap<>();
        for (Permission p : allPerms) {
            permById.put(p.getPermissionId(), p);
            if ("view".equals(p.getAction())) {
                resourceViewPermId.put(p.getResource(), p.getPermissionId());
            }
        }

        Set<Integer> expanded = new HashSet<>(perIds);
        for (int pid : perIds) {
            Permission perm = permById.get(pid);
            if (perm != null && !"view".equals(perm.getAction())) {
                Integer viewPid = resourceViewPermId.get(perm.getResource());
                if (viewPid != null) {
                    expanded.add(viewPid);
                }
            }
        }

        try {
            List<Permission> oldPermList = perDAO.getPermissionByRoleId(roleId);
            Set<String> oldPermSet = new HashSet<>();
            for (Permission perm : oldPermList) {
                oldPermSet.add(perm.getResource() + "." + perm.getAction());
            }
            Set<String> newPermSet = new HashSet<>();
            for (int pid : expanded) {
                Permission perm = permById.get(pid);
                if (perm != null) newPermSet.add(perm.getResource() + "." + perm.getAction());
            }
            Set<String> added = new HashSet<>(newPermSet);
            added.removeAll(oldPermSet);
            Set<String> removed = new HashSet<>(oldPermSet);
            removed.removeAll(newPermSet);
            if (!added.isEmpty() || !removed.isEmpty()) {
                StringBuilder permDetails = new StringBuilder();
                if (!added.isEmpty())   permDetails.append("Thêm: ").append(String.join(", ", added));
                if (!removed.isEmpty()) {
                    if (permDetails.length() > 0) permDetails.append(" | ");
                    permDetails.append("Xóa: ").append(String.join(", ", removed));
                }
                logRoleAction(request, roleId, name, "UPDATE_PERMISSIONS", permDetails.toString());
            }
        } catch (Exception e) {
            SystemLogger.error(LogModule.ROLE, "RoleController.log quyền", e.getMessage(), e);
        }
        roleDAO.updatePermissionRole(roleId, new ArrayList<>(expanded));


        UserDAO userDAO = new UserDAO();
        List<Integer> affectedUsers = userDAO.getUserIdsByRoleId(roleId);
        for (Integer uid : affectedUsers) {
            request.getServletContext().setAttribute("perm_refresh_" + uid, true);
        }

        response.sendRedirect(request.getContextPath() + "/admin/roles?msg=success");
    }

    /**
     * Ghi log thay đổi vai trò và phân quyền vào activity_log.
     */
    private void logRoleAction(HttpServletRequest request, int roleId,
                                String roleName, String action, String details) {
        try {
            User user = (User) request.getSession().getAttribute("loggedUser");
            if (user == null) return;

            ActivityLog log = new ActivityLog();
            log.setUserId(user.getId());
            log.setEntityType("roles");
            log.setAction(action);
            log.setEntityId(roleId);
            log.setEntityName(roleName);
            log.setDetails(details);
            logDAO.insert(log);
        } catch (Exception e) {
            SystemLogger.error(LogModule.ROLE,
                    "RoleController.logRoleAction", e.getMessage(), e);
        }
    }
    private static final Map<String, String> MODULE_LABELS = Map.of(
            "admin", "Quản trị hệ thống",
            "warehouse", "Kho & Phiếu",
            "sales", "Bán hàng",
            "system", "Hệ thống & Danh mục",
            "report", "Báo cáo",
            "account", "Tài khoản cá nhân"
    );

    private static final Map<String, String> TASK_LABELS = Map.ofEntries(
            Map.entry("READ", "Xem"),
            Map.entry("CREATE", "Tạo"),
            Map.entry("UPDATE", "Sửa"),
            Map.entry("DELETE", "Vô hiệu"),
            Map.entry("APPROVE", "Duyệt"),
            Map.entry("REJECT", "Từ chối"),
            Map.entry("CANCEL", "Hủy"),
            Map.entry("EXPORT", "Xuất"),
            Map.entry("CONVERT", "Chuyển"),
            Map.entry("ADJUST", "Điều chỉnh")
    );

    private Map<String, Map<String, List<Permission>>> buildGroupedByModule(
            List<Permission> allPermissions, String permSearch) {
        String needle = permSearch == null ? "" : permSearch.trim().toLowerCase();
        Map<String, Map<String, List<Permission>>> result = new LinkedHashMap<>();
        for (Permission p : allPermissions) {
            if (!needle.isEmpty()) {
                String hay = (p.getResource() + " " + (p.getFeatureName() == null ? "" : p.getFeatureName())
                        + " " + (p.getDescription() == null ? "" : p.getDescription())).toLowerCase();
                if (!hay.contains(needle)) continue;
            }
            String moduleKey = p.getModule() == null ? "other" : p.getModule();
            String moduleLabel = MODULE_LABELS.getOrDefault(moduleKey, moduleKey);
            String featureLabel = p.getFeatureName();
            if (featureLabel == null || featureLabel.trim().isEmpty()) {
                featureLabel = p.getResource();
            }
            result.computeIfAbsent(moduleLabel, k -> new LinkedHashMap<>())
                  .computeIfAbsent(featureLabel, k -> new ArrayList<>())
                  .add(p);
        }
        return result;
    }
}
