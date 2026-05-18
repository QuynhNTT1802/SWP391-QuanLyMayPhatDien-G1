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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
        request.setAttribute("roleList", roleList);

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
                if (r.getRoleId() == roleId) { curRole = r; break; }
            }
            List<Permission> rolePermissions = perDAO.getPermissionByRoleId(roleId);
            
            request.setAttribute("role", curRole);
            request.setAttribute("rolePermissions", rolePermissions);
        }
        request.getRequestDispatcher("/view/admin/admin-role-edit.jsp").forward(request, response);
    }

    //TASK 14 & 16: SAVE EVERYTHING
    private void saveRoleFull(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String desc = request.getParameter("description");
        String status = request.getParameter("status");

        Role role = new Role();
        role.setRoleName(name);
        role.setDescription(desc);
        role.setStatus(status != null ? status : "active");

        int roleId;
        if (idParam == null || idParam.isEmpty()) {
            roleId = roleDAO.insert(role);
        } else {

            roleId = Integer.parseInt(idParam);
            role.setRoleId(roleId);
            roleDAO.update(role);
        }


        String[] perIdsString = request.getParameterValues("perIds");
        List<Integer> perIds = new ArrayList<>();
        if (perIdsString != null) {
            for (String pId : perIdsString) { perIds.add(Integer.parseInt(pId)); }
        }
        roleDAO.updatePermissionRole(roleId, perIds);

        response.sendRedirect(request.getContextPath() + "/admin/roles?msg=success");
    }
}