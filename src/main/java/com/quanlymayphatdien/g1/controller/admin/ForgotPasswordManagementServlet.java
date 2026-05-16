/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.quanlymayphatdien.g1.controller.admin;

import com.quanlymayphatdien.g1.dal.PasswordResetRequestDAO;
import com.quanlymayphatdien.g1.entity.PasswordResetRequest;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author FPTShop
 */
@WebServlet(name="ForgotPasswordManagementServlet", urlPatterns={"/admin/forgot-password"})
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
    }

}
