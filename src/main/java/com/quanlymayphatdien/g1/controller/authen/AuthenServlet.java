/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.authen;

import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.PasswordResetRequestDAO;
import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
import com.quanlymayphatdien.g1.entity.Role;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.BCryptUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Set;

/**
 *
 * @author Phuong Linh
 */
@WebServlet(name = "AuthenServlet", urlPatterns = {"/authen"})
public class AuthenServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        String url = "";
        switch (action) {
            case "login":
                url = "view/authen/login.jsp";
                break;
            case "forgotpass":
                url = "view/authen/forgotpass.jsp";
                break;
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/authen?action=login");
                return;
            default:
                throw new AssertionError();
        }
        request.getRequestDispatcher(url).forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String url = "";
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "forgotpass":
                url = forgotpassDoPost(request, response);
                break;
            default:
                throw new AssertionError();
        }
        if (url != null && !url.isEmpty()) {
            if (url.startsWith("redirect:")) {

                String redirectUrl = url.substring("redirect:".length());
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {

                request.getRequestDispatcher(url).forward(request, response);
            }
        }
    }

    private String forgotpassDoPost(HttpServletRequest request, HttpServletResponse response) {
        String username = request.getParameter("username");
        UserDAO userDAO = new UserDAO();
        PasswordResetRequestDAO prDAO = new PasswordResetRequestDAO();
        User user = userDAO.findByUsername(username);
        if (user == null) {
            request.setAttribute("error", "Không có tài khoản trong hệ thống");
            return "/view/authen/forgotpass.jsp";
        }
        if(prDAO.hasPendingRequest(user.getId())){
            request.setAttribute("error", "Bạn đã gửi yêu cầu, hãy chờ đợi để được cấp mật khẩu");
            return "/view/authen/forgotpass.jsp";
        }
        PasswordResetRequest req = new PasswordResetRequest();
        req.setUserId(user.getId());
        req.setUsername(user.getUsername());
        req.setCreatedAt(java.time.LocalDateTime.now());
        PasswordResetRequestDAO reqDao = new PasswordResetRequestDAO();
        int result = reqDao.insert(req);
        if (result > 0) {
            request.setAttribute("message", "Bạn đã gửi thành công");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại sau");
        }
        return "/view/authen/forgotpass.jsp";
    }

    private boolean passwordMatches(String plain, String stored) {
        if (stored == null) {
            return false;
        }
        if (stored.startsWith("$2a$") || stored.startsWith("$2b$")) {
            return BCryptUtils.verify(plain, stored);
        }
        return stored.equals(plain);
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập thông tin đầy đủ");
            return "view/authen/login.jsp";
        }
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByUsername(username);

            if (user == null || !passwordMatches(password, user.getPassword())) {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                return "view/authen/login.jsp";
            }

            if (!"active".equals(user.getStatus())) {
                request.setAttribute("error", "Tài khoản đã bị khóa!");
                return "view/authen/login.jsp";
            }

            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", user);
            session.setAttribute("username", user.getUsername());

            RoleDAO roleDAO = new RoleDAO();
            List<Role> roles = roleDAO.getRolesByUserId(user.getId());
            user.setRoles(roles);

            PermissionDAO perDAO = new PermissionDAO();
            Set<String> perms = perDAO.getEffectPermissions(user.getId());
            session.setAttribute("userPermissions", perms);

            return "redirect:/admin/dashboard";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            return "view/authen/login.jsp";
        }

    }

}