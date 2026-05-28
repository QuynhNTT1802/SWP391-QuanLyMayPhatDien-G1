package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.entity.Permission;
import com.quanlymayphatdien.g1.entity.Role;
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
            e.printStackTrace();
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
            e.printStackTrace();
        }
    }

    //TASK 12: VIEW ROLE LIST
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

    //TASK 13: VIEW ROLE EDIT
    private void viewRolePermission(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id");
        String permSearch = request.getParameter("permSearch");

        List<Permission> allPermissions = perDAO.findAll();

        // Ví dụ: "users" -> [Xem, Tạo, Sửa, Xoá]
        Map<String, List<Permission>> groupedPerms = new LinkedHashMap<>();
        for (Permission p : allPermissions) {
            if (permSearch != null && !permSearch.trim().isEmpty()) {
                if (!p.getResource().toLowerCase().contains(permSearch.trim().toLowerCase())) {
                    continue;
                }
            }
            groupedPerms.computeIfAbsent(p.getResource(), k -> new ArrayList<>()).add(p);
        }
        request.setAttribute("groupedPerms", groupedPerms);

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
        }
        request.getRequestDispatcher("/view/admin/admin-role-edit.jsp").forward(request, response);
    }

    //TASK 14 & 16: SAVE EVERYTHING
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
            Map<String, List<Permission>> groupedPerms = new LinkedHashMap<>();
            for (Permission p : allPermissions) {
                if (permSearch != null && !permSearch.trim().isEmpty()) {
                    if (!p.getResource().toLowerCase().contains(permSearch.trim().toLowerCase())) {
                        continue;
                    }
                }
                groupedPerms.computeIfAbsent(p.getResource(), k -> new ArrayList<>()).add(p);
            }
            request.setAttribute("groupedPerms", groupedPerms);

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
        } else {
            if (permissions == null || !permissions.contains("roles.update")) {
                request.getRequestDispatcher("/view/error/403.jsp").forward(request, response);
                return;
            }
            roleId = excludeId;
            role.setRoleId(roleId);
            roleDAO.update(role);
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
        roleDAO.updatePermissionRole(roleId, new ArrayList<>(expanded));

        response.sendRedirect(request.getContextPath() + "/admin/roles?msg=success");
    }
}