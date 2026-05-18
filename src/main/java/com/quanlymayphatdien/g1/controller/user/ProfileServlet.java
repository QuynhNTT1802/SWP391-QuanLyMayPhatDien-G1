package com.quanlymayphatdien.g1.controller.user;
import static com.quanlymayphatdien.g1.config.GlobalConfig.REGEX_PHONE;
import com.quanlymayphatdien.g1.dal.RoleDAO;
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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

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
            RoleDAO roleDAO = new RoleDAO();
            latestUser.setRoles(roleDAO.getRolesByUserId(latestUser.getId()));
            request.setAttribute("user", latestUser);
            session.setAttribute("loggedUser", latestUser);
        } else {
            request.setAttribute("user", user);
        }

        request.getRequestDispatcher("/view/user/profile.jsp").forward(request, response);
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
        String name = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống.");
            doGet(request, response);
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Số điện thoại không được để trống.");
            doGet(request, response);
            return;
        }

        if (!phone.trim().matches(REGEX_PHONE)) {
            request.setAttribute("error", "SĐT không hợp lệ (10-11 số, bắt đầu là 0).");
            doGet(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findById(currentUser.getId());

        if (user != null) {
            user.setName(name.trim());
            user.setPhone(phone.trim());
            user.setAddress(address != null ? address.trim() : "");
            user.setUpdatedAt(LocalDateTime.now());
            user.setUpdatedBy(currentUser.getId());

            boolean updated = userDAO.update(user);

            if (updated) {
                session.setAttribute("loggedUser", user);
                request.setAttribute("success", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ.");
            }
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/user/profile.jsp").forward(request, response);
    }
}
