/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller;

import com.quanlymayphatdien.g1.dal.AdminDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.dal.PasswordResetRequestDAO;
import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

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
        if (action == null) {
            action = "";
        }
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
        PasswordResetRequestDAO reqDao = new PasswordResetRequestDAO();
        int result = reqDao.insert(req);
        if (result > 0) {
            request.setAttribute("message", "Bạn đã gửi thành công");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại sau");
        }
        return "/view/authen/forgotpass.jsp";
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

            if (user == null || !user.getPassword().equals(password)) {
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

            return "view/admin/admin-user.jsp";

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            return "view/authen/login.jsp";
        }

    }

}
