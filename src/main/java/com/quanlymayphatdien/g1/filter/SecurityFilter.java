package com.quanlymayphatdien.g1.filter;

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
import java.util.Map;
import java.util.Set;

@WebFilter("/admin/*")
public class SecurityFilter implements Filter {

    private static final Map<String, String> perMap = Map.ofEntries(
        Map.entry("/admin/dashboard",     "dashboard.view"),
        Map.entry("/admin/users",         "users.view"),
        Map.entry("/admin/roles",         "roles.view"),
        Map.entry("/admin/role/edit",     "roles.edit"),
        Map.entry("/admin/role/save",     "roles.edit"),
        Map.entry("/admin/forgot-password","forgot_pw.process")
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

        String servletPath = req.getServletPath();
        String requiredPer = perMap.get(servletPath);

        if (requiredPer != null) {
            Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
            if (permissions == null || !permissions.contains(requiredPer)) {
                req.setAttribute("requiredPerm", requiredPer);
                request.getRequestDispatcher("/view/error/role-error.jsp").forward(req, res);
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
