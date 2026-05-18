/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.PasswordResetRequestDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.Admin;
import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
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
import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author FPTShop
 */
@WebServlet(name = "ForgotPasswordManagementServlet", urlPatterns = {"/admin/forgot-password"})
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        PasswordResetRequestDAO passwordResetRequestDAO = new PasswordResetRequestDAO();
        List<PasswordResetRequest> listRequests = passwordResetRequestDAO.findAll();
        List<PasswordResetRequest> pendingList = passwordResetRequestDAO.findByStatus("pending");
        request.setAttribute("listRequests", listRequests);
        request.setAttribute("totalRequests", listRequests.size());
        request.setAttribute("pendingList", pendingList);
        request.setAttribute("doneRequests", listRequests.size() - pendingList.size());
        request.getRequestDispatcher("/view/admin/admin-forgotpass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }
        
        String requestIdStr = request.getParameter("requestId");
        String note = request.getParameter("note");

        if (requestIdStr == null) {
            session.setAttribute("error", "Thiếu thông tin");
            response.sendRedirect(request.getContextPath() + "/admin/forgot-password");
            return;
        }
        
        int requestId = Integer.parseInt(requestIdStr);

        PasswordResetRequestDAO requestDAO = new PasswordResetRequestDAO();
        UserDAO userDAO = new UserDAO();
        PasswordResetRequest req = requestDAO.findById(requestId);
        if (req == null) {
            session.setAttribute("error", "Yêu cầu không tồn tại");
            response.sendRedirect(request.getContextPath() + "/admin/forgot-password");
            return;
        }
        try {
            String generatedPassword = BCryptUtils.generatePassword();
            String hashedPassword = BCryptUtils.hash(generatedPassword);
            User user = userDAO.findById(req.getUserId());
            if (user != null) {
                userDAO.updatePassword(user.getId(), hashedPassword);
            }

            req.setStatus("approved");
            req.setProcessedBy(3);
            req.setNote(note);
            req.setProcessedAt(LocalDateTime.now());
            boolean updated = requestDAO.update(req);
            if (updated) {
                session.setAttribute("message", "Đã cấp lại mật khẩu cho " + req.getUsername() + ": " + generatedPassword);
            } else {
                session.setAttribute("error", "Không thể cập nhật yêu cầu. Vui lòng thử lại.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống khi cấp mật khẩu: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/forgot-password");
    }

}
