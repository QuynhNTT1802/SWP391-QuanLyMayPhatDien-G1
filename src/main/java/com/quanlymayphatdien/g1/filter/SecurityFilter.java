package com.quanlymayphatdien.g1.filter;

import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.Set;

@WebFilter("/admin/*")
public class SecurityFilter implements Filter {

    private static final Map<String, String> perMap = Map.ofEntries(
        Map.entry("/admin/dashboard",      "dashboard.view"),
        Map.entry("/admin/users",          "users.view"),
        Map.entry("/admin/roles",          "roles.view"),
        Map.entry("/admin/role/edit",      "roles.update"),
        Map.entry("/admin/role/save",      "roles.update"),
        Map.entry("/admin/forgot-password","forgot_pw.process"),
        Map.entry("/admin/categories",     "categories.view")
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loggedUser") == null) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        if (!"active".equalsIgnoreCase(user.getStatus())) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }

        int userId = user.getId();

        Object refreshFlag = req.getServletContext().getAttribute("perm_refresh_" + userId);
        if (refreshFlag != null) {
            PermissionDAO perDAO = new PermissionDAO();
            try {
                Set<String> freshPerms = perDAO.getEffectPermissions(userId);
                session.setAttribute("userPermissions", freshPerms);
                req.getServletContext().removeAttribute("perm_refresh_" + userId);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        String servletPath = req.getServletPath();
        String requiredPer = perMap.get(servletPath);

        if ("/admin/users".equals(servletPath)) {
            String action = req.getParameter("action");
            if ("update".equals(action)) {
                requiredPer = "users.update";
            } else if ("create".equals(action)) {
                requiredPer = "users.create";
            } else if ("deactivate".equals(action) || "activate".equals(action)) {
                requiredPer = "users.deactivate";
            } else if ("edit".equals(action)) {
                requiredPer = "users.update";
            }
        }

        if ("/admin/roles".equals(servletPath)) {
            String action = req.getParameter("action");
            if ("update".equals(action) || "create".equals(action) || "edit".equals(action)) {
                requiredPer = "roles.update";
            } else if ("edit_permissions".equals(action)) {
                requiredPer = "roles.edit_permissions";
            }
        }
        
        if("/admin/categories".equals(servletPath)){
            String action = req.getParameter("action");
            if("create".equals(action)) {
                requiredPer = "categories.create";
            } else if ("update".equals(action)) {
                requiredPer = "categories.update";
            } else if("delete".equals(action)){
                requiredPer = "categories.delete";
            }
        }

        if (requiredPer != null) {
            Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
            if (permissions == null || !permissions.contains(requiredPer)) {
                req.setAttribute("requiredPerm", requiredPer);
                request.getRequestDispatcher("/view/error/403.jsp").forward(req, res);
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
