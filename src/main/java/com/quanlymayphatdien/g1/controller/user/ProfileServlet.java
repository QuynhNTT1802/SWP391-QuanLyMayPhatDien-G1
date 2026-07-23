package com.quanlymayphatdien.g1.controller.user;
import static com.quanlymayphatdien.g1.utils.GlobalUtils.REGEX_PHONE;
import com.quanlymayphatdien.g1.dal.ActivityLogDAO;
import com.quanlymayphatdien.g1.dal.RoleDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.ActivityLog;
import com.quanlymayphatdien.g1.entity.User;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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
        if (userDAO.isPhoneExists(phone.trim(), currentUser.getId())) {
            request.setAttribute("error", "Số điện thoại đã được sử dụng bởi tài khoản khác.");
            doGet(request, response);
            return;
        }

        User user = userDAO.findById(currentUser.getId());

        if (user != null) {
            String beforeName = user.getName();
            String beforePhone = user.getPhone();
            String beforeAddress = user.getAddress();

            user.setName(name.trim());
            user.setPhone(phone.trim());
            user.setAddress(address != null ? address.trim() : "");
            user.setUpdatedAt(LocalDateTime.now());
            user.setUpdatedBy(currentUser.getId());

            boolean updated = userDAO.update(user);

            if (updated) {
                session.setAttribute("loggedUser", user);
                request.setAttribute("success", "Cập nhật hồ sơ thành công!");

                List<String> changes = new ArrayList<>();
                if (!equalsStr(beforeName, user.getName())) {
                    changes.add("Họ tên: \"" + safe(beforeName) + "\" → \"" + safe(user.getName()) + "\"");
                }
                if (!equalsStr(beforePhone, user.getPhone())) {
                    changes.add("Số điện thoại: \"" + safe(beforePhone) + "\" → \"" + safe(user.getPhone()) + "\"");
                }
                if (!equalsStr(beforeAddress, user.getAddress())) {
                    changes.add("Địa chỉ: \"" + safe(beforeAddress) + "\" → \"" + safe(user.getAddress()) + "\"");
                }
                String details = changes.isEmpty()
                        ? "Tự cập nhật hồ sơ: không có thay đổi"
                        : "Tự cập nhật hồ sơ: " + String.join("; ", changes);
                logProfileChange(currentUser, user, details);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật hồ sơ.");
            }
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/view/user/profile.jsp").forward(request, response);
    }

    private static boolean equalsStr(String a, String b) {
        if (a == null) {
            return b == null;
        }
        return a.equals(b);
    }

    private static String safe(String s) {
        return s == null ? "" : s;
    }

    private void logProfileChange(User actor, User target, String details) {
        ActivityLog log = new ActivityLog();
        log.setUserId(actor.getId());
        log.setUsername(actor.getUsername());
        log.setEntityType("user");
        log.setEntityId(target.getId());
        log.setEntityName(target.getName());
        log.setAction("UPDATE_PROFILE");
        log.setDetails(details);
        log.setCreatedAt(LocalDateTime.now());
        new ActivityLogDAO().insertLog(log);
    }
}