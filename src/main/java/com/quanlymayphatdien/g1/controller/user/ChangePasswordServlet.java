package com.quanlymayphatdien.g1.controller.user;
import static com.quanlymayphatdien.g1.utils.GlobalUtils.REGEX_PASSWORD;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.User;
import com.quanlymayphatdien.g1.utils.BCryptUtils;
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

        if (!newPassword.matches(REGEX_PASSWORD)) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 1 chữ hoa, 1 chữ thường và 1 số.");
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

        if (user == null) {
            request.setAttribute("error", "Không tìm thấy người dùng.");
            doGet(request, response);
            return;
        }

        boolean passwordCorrect = false;
        if (user.getPassword().startsWith("$2a$") || user.getPassword().startsWith("$2b$")) {
            passwordCorrect = BCryptUtils.verify(currentPassword, user.getPassword());
        } else {
            passwordCorrect = user.getPassword().equals(currentPassword);
        }

        if (!passwordCorrect) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            doGet(request, response);
            return;
        }

        if (BCryptUtils.hash(newPassword).equals(user.getPassword())
                || (!user.getPassword().startsWith("$2a$") && !user.getPassword().startsWith("$2b$") && newPassword.equals(user.getPassword()))) {
            request.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu hiện tại.");
            doGet(request, response);
            return;
        }

        String newHashedPassword = BCryptUtils.hash(newPassword);
        boolean updated = userDAO.updatePassword(user.getId(), newHashedPassword);

        if (updated) {
            ActivityLog log = new ActivityLog();
            log.setUserId(currentUser.getId());
            log.setUsername(currentUser.getUsername());
            log.setEntityType("user");
            log.setEntityId(user.getId());
            log.setEntityName(user.getName());
            log.setAction("CHANGE_PASSWORD");
            log.setDetails("Đổi mật khẩu thành công");
            log.setCreatedAt(LocalDateTime.now());
            new ActivityLogDAO().insertLog(log);

            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/authen?action=login");
            return;
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu.");
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/user/changepass.jsp").forward(request, response);
    }
}