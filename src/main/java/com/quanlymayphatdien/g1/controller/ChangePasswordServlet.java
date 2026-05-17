package com.quanlymayphatdien.g1.controller.user;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.User;
import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changepass"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        UserDAO userDAO = new UserDAO();
        User latestUser = userDAO.findById(user.getId());

        if (latestUser != null) {
            request.setAttribute("user", latestUser);
        } else {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/view/user/changepass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        }

        User currentUser = (User) session.getAttribute("loggedUser");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu hiện tại.");
            doGet(request, response);
            return;
        }

        if (newPassword == null || newPassword.trim().length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            doGet(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            doGet(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findById(currentUser.getId());

        if (user == null || !user.getPassword().equals(currentPassword)) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            doGet(request, response);
            return;
        }

        user.setPassword(newPassword);
        user.setUpdatedAt(LocalDateTime.now());
        user.setUpdatedBy(currentUser.getId());

        boolean updated = userDAO.update(user);

        if (updated) {
            session.setAttribute("loggedUser", user);
            request.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu.");
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/user/changepass.jsp").forward(request, response);
    }
}