/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.quanlymayphatdien.g1.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
            default:
                throw new AssertionError();
        }
        request.getRequestDispatcher(url).forward(request, response);
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") != null
                ? request.getParameter("action")
                : "";
        String url = "";
        switch (action) {
            case "login":
                url = loginDoPost(request, response);
                break;
            case "forgot":
                url = forgotpassDoPost(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    private String loginDoPost(HttpServletRequest request, HttpServletResponse response) {
        return null;
    }

    private String forgotpassDoPost(HttpServletRequest request, HttpServletResponse response) {
        
    }
    
    

}
