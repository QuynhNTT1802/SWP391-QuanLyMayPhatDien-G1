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
public class ForgotPasswordManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
        String requestIdStr = request.getParameter("requestId");
        String newPassword = request.getParameter("newPassword");
        String note = request.getParameter("note");
        HttpSession session = request.getSession();
//        Admin admin = (Admin) session.getAttribute("admin");

        if (requestIdStr == null || newPassword == null || newPassword.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập mật khẩu mới");
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
        User user = userDAO.findById(req.getUserId());
        if (user != null) {
            user.setPassword(newPassword);
            user.setUpdatedAt(LocalDateTime.now());
            userDAO.update(user);
        }
        req.setStatus("approved");
//        req.setProcessedBy(admin.getId());
        req.setProcessedBy(3);
        req.setNewPassword(newPassword);
        req.setNote(note);
        req.setProcessedAt(LocalDateTime.now());
        requestDAO.update(req);
        session.setAttribute("message", "Đã cấp lại mật khẩu cho " + req.getUsername() + " thành công");
        response.sendRedirect(request.getContextPath() + "/admin/forgot-password");
    }

}
