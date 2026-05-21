/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.authen;

import com.quanlymayphatdien.g1.dal.PermissionDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.PasswordResetRequestDAO;
import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.BCryptUtils;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
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
                HttpSession existingSession = request.getSession(false);
                if (existingSession != null && existingSession.getAttribute("loggedUser") != null) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    return;
                }
                if (tryAutoLogin(request, response)) {
                    return;
                }
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
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie c : cookies) {
                        if ("rememberUser".equals(c.getName())) {
                            c.setMaxAge(0);
                            c.setPath("/");
                            response.addCookie(c);
                        }
                    }
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
        User user = userDAO.findByUsername(username);
        if (user == null) {
            request.setAttribute("error", "Không có tài khoản trong hệ thống");
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

    private boolean tryAutoLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return false;

        String rememberToken = null;
        for (Cookie c : cookies) {
            if ("rememberUser".equals(c.getName())) {
                rememberToken = c.getValue();
                break;
            }
        }
        if (rememberToken == null || !rememberToken.contains(":")) return false;

        String username = rememberToken.split(":")[0];
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByUsername(username);
            if (user == null || !"active".equals(user.getStatus())) return false;

            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("username", user.getUsername());

            PermissionDAO perDAO = new PermissionDAO();
            Set<String> perms = perDAO.getEffectPermissions(user.getId());
            session.setAttribute("userPermissions", perms);

            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
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

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("username", user.getUsername());

            PermissionDAO perDAO = new PermissionDAO();
            Set<String> perms = perDAO.getEffectPermissions(user.getId());
            session.setAttribute("userPermissions", perms);

            if (remember != null) {
                String token = username + ":" + BCryptUtils.hash(username + System.currentTimeMillis());
                Cookie rememberCookie = new Cookie("rememberUser", token);
                rememberCookie.setMaxAge(7 * 24 * 60 * 60);
                rememberCookie.setPath("/");
                rememberCookie.setHttpOnly(true);
                response.addCookie(rememberCookie);
            }

            return "redirect:/admin/dashboard";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            return "view/authen/login.jsp";
        }

    }

}