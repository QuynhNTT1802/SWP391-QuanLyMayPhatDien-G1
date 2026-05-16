//package com.quanlymayphatdien.g1.controller.admin;
//
//import com.quanlymayphatdien.g1.dal.AdminDAO;
//import com.quanlymayphatdien.g1.dal.UserDAO;
//import com.quanlymayphatdien.g1.entity.User;
//import jakarta.servlet.RequestDispatcher;
//import java.io.IOException;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.time.LocalDateTime;
//import java.util.HashMap;
//import java.util.Map;
//
///**
// * @author Aadmin
// */
//@WebServlet(name = "UserManagementServlet", urlPatterns = {"/admin/users"})
//public class UserManagementServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "list";
//        }
//String url = null;
//        switch (action) {
//            case "create":
//                showCreateForm(request, response);
//                break;
//            case "update":
//                showUpdateForm(request, response); // Sửa từ showUpdateForm thành showEditForm cho khớp bên dưới
//                break;
//            case "deactivate":
//                deactivateUser(request, response);
//                break;
//            case "activate":
//                activateUser(request, response);
//                break;
//            case "list":
//            default:
//                listUsers(request, response);
//                break;
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//        if (action == null) {
//            action = "list";
//        }
//        switch (action) {
//            case "create":
//                createUser(request, response);
//                break;
//            case "update":
//                updateUser(request, response);
//                break;
//            case "list":
//            default:
//                listUsers(request, response);
//                break;
//        }
//    }
//
//    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        RequestDispatcher dispatcher = request.getRequestDispatcher("/view/admin/create-user.jsp");
//        dispatcher.forward(request, response);
//    }
//<<<<<<< HEAD
//
//    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }
//
//    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }
//
//    private void deactivateUser(HttpServletRequest request, HttpServletResponse response) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }
//
//    private void activateUser(HttpServletRequest request, HttpServletResponse response) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }
//
//    private void listUsers(HttpServletRequest request, HttpServletResponse response) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }
//    
//    
//=======
//>>>>>>> 9a3c4df8006c29d2f059f486a81724776fa3cf81
//
//    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String userIdStr = request.getParameter("id");
//        if (userIdStr != null && !userIdStr.isEmpty()) {
//            int userId = Integer.parseInt(userIdStr);
//            UserDAO userDAO = new UserDAO(); 
//            User user = userDAO.findById(userId); 
//            if (user != null) {
//                request.setAttribute("user", user);
//                request.getRequestDispatcher("/view/admin/update-user.jsp").forward(request, response);
//                return;
//            }
//        }
//        response.sendRedirect(request.getContextPath() + "/admin/users?action=list");
//    }
//
//    private void updateUser(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String currentPage = request.getParameter("page");
//        if (currentPage == null || currentPage.isEmpty()) {
//            currentPage = "1";
//        }
//        
//        try {
//            int userId = Integer.parseInt(request.getParameter("id"));
//            String password = request.getParameter("password");
//            String name = request.getParameter("name");
//            String email = request.getParameter("email");
//            String phone = request.getParameter("phone");
//            String address = request.getParameter("address");
//            String status = request.getParameter("status");
//
//            UserDAO userDAO = new UserDAO(); 
//            User user = userDAO.findById(userId);
//
//            if (user != null) {
//                Map<String, String> errors = validateForm(null, password, email, phone, userId);
//                if (!errors.isEmpty()) {
//                    request.getSession().setAttribute("errors", errors);
//                    request.getSession().setAttribute("formData", request.getParameterMap());
//                    
//                    response.sendRedirect(request.getContextPath() + "/admin/users?action=update&id=" + userId);
//                    return;
//                }
//
//                user.setPassword(password);
//                user.setName(name);
//                user.setEmail(email);
//                user.setPhone(phone);
//                user.setAddress(address);
//                user.setStatus(status);
//                user.setUpdatedAt(LocalDateTime.now());
//                user.setUpdatedBy(1); 
//
//                boolean isUpdated = userDAO.update(user);
//                if (isUpdated) {
//                    request.getSession().setAttribute("message", "Update successfully");
//                } else {
//                    request.getSession().setAttribute("message", "Fail to update");
//                }
//            } else {
//                request.getSession().setAttribute("message", "Account not found!");
//            }
//        } catch (Exception e) {
//            request.getSession().setAttribute("Error", e.getMessage());
//        }
//
//        response.sendRedirect(request.getContextPath() + "/admin/users?action=list&page=" + currentPage);
//    }
//
//    private Map<String, String> validateForm(String username, String password, String email, String phone, Integer userId) {
//        Map<String, String> errors = new HashMap<>();
//        UserDAO userDAO = new UserDAO();
//
//        if (username != null && !username.isEmpty()) {
//            if (username.length() < 3 || username.length() > 50) {
//                errors.put("username", "Tên đăng nhập phải có độ dài từ 3 đến 50 ký tự");
//            } else if (!username.matches("^[a-zA-Z0-9_]+$")) {
//                errors.put("username", "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới");
//            } else if (userDAO.isUsernameExists(username)) {
//                errors.put("username", "Tên đăng nhập đã tồn tại");
//            }
//        } else if (userId == null) {
//            errors.put("username", "Tên đăng nhập không được để trống");
//        }
//
//        if (password != null && !password.isEmpty()) {
//            if (password.length() < 6) {
//                errors.put("password", "Mật khẩu phải có ít nhất 6 ký tự");
//            } else if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).+$")) {
//                errors.put("password", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường và 1 chữ số");
//            }
//        } else if (userId == null) {
//            errors.put("password", "Mật khẩu không được để trống");
//        }
//
//        if (email != null && !email.isEmpty()) {
//            String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
//            if (!email.matches(emailRegex)) {
//                errors.put("email", "Định dạng email không hợp lệ");
//            } else if (userDAO.isEmailExists(email, userId)) {
//                errors.put("email", "Email đã được sử dụng");
//            }
//        } else {
//            errors.put("email", "Email không được để trống");
//        }
//
//        if (phone != null && !phone.isEmpty()) {
//            if (!phone.matches("^0[0-9]{9,10}$")) {
//                errors.put("phone", "Số điện thoại phải bắt đầu bằng số 0 và có 10 hoặc 11 chữ số");
//            } else if (userDAO.isPhoneExists(phone, userId)) {
//                errors.put("phone", "Số điện thoại này đã được sử dụng");
//            }
//        } else {
//            errors.put("phone", "Số điện thoại không được để trống");
//        }
//
//        return errors;
//    }
//
//    private void deactivateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        String currentPage = request.getParameter("page");
//        if (currentPage == null || currentPage.isEmpty()) {
//            currentPage = "1";
//        }
//        
//        String userIdStr = request.getParameter("id");
//        
//        
//        
//    }
//    
//    private void activateUser(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        String currentPage = request.getParameter("page");
//        if (currentPage == null || currentPage.isEmpty()) {
//            currentPage = "1";
//        }
//        
//        String userIdStr = request.getParameter("id");
//        if (userIdStr != null || !userIdStr.isEmpty()) {
//            int userId = Integer.parseInt(userIdStr);
//            UserDAO userDAO = new UserDAO();
//            
//        }
//    }
//    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
//    private void createUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {}
//}