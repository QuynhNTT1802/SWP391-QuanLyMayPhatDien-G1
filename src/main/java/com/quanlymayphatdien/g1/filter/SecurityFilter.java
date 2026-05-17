/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.quanlymayphatdien.g1.filter;

import com.quanlymayphatdien.g1.entity.Admin;
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


/**
 *
 * @author LENOVO
 */
@WebFilter("/admin/*")
public class SecurityFilter implements Filter {


    private static final Map<String, String> perMap = Map.ofEntries(
        Map.entry("/admin/users",   "users.Xem"),
        Map.entry("/admin/roles",   "roles.Xem"),
        Map.entry("/admin/role/edit","roles.Sua"),
        Map.entry("/admin/role/save","roles.Sua")
        // ... thêm các trang khác sau
    );

    
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest)request;
        HttpServletResponse res = (HttpServletResponse)response;
        
        HttpSession session = req.getSession(false);
        
        //check login
        if(session == null || session.getAttribute("admin") == null) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        
        //check user status
        if(!"active".equalsIgnoreCase(admin.getStatus())) {
            res.sendRedirect(req.getContextPath() + "/authen?action=login");
            return;
        }
        
        //check quyen
        String servletPath = req.getServletPath();
        String requiredPer = perMap.get(servletPath);
        
        if(requiredPer != null) {
            Set<String> permissions = admin.getEffectivePermissions();
            if(permissions == null || !permissions.contains(requiredPer)) {
                request.getRequestDispatcher("/view/error/role-error.jsp").forward(req, res);
                return;
            }
        }
        chain.doFilter(req, res);    
    }
}
