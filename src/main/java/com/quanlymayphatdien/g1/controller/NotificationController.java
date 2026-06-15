package com.quanlymayphatdien.g1.controller;

import com.google.gson.Gson;
import com.quanlymayphatdien.g1.dal.NotificationDAO;
import com.quanlymayphatdien.g1.entity.Notification;
import com.quanlymayphatdien.g1.entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "NotificationController", urlPatterns = {"/notifications"})
public class NotificationController extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
    private static final int PAGE_SIZE = 20;
    private static final int DROPDOWN_LIMIT = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "dropdown":
                handleDropdown(user, response);
                break;
            case "list":
            default:
                handleList(request, response, user);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            writeJson(response, Map.of("ok", false, "error", "unauthorized"));
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "markRead":
                handleMarkRead(request, response, user);
                break;
            case "markAllRead":
                handleMarkAllRead(response, user);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                writeJson(response, Map.of("ok", false, "error", "unknown_action"));
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String filter = request.getParameter("filter");
        if (filter == null) filter = "all";

        int page = parseInt(request.getParameter("page"), 1);
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<Notification> all = notificationDAO.findByUserId(user.getId());
        List<Notification> filtered;
        if ("unread".equals(filter)) {
            filtered = new ArrayList<>();
            for (Notification n : all) if (!n.isRead()) filtered.add(n);
        } else {
            filtered = all;
        }

        int total = filtered.size();
        int totalPages = (int) Math.ceil(total / (double) PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        int from = Math.min(offset, total);
        int to = Math.min(offset + PAGE_SIZE, total);
        List<Notification> pageItems = filtered.subList(from, to);

        request.setAttribute("notifications", pageItems);
        request.setAttribute("filter", filter);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("unreadCount", notificationDAO.countUnread(user.getId()));

        request.getRequestDispatcher("/view/notification/notification-list.jsp")
                .forward(request, response);
    }

    private void handleDropdown(User user, HttpServletResponse response) throws IOException {
        List<Notification> items = notificationDAO.findByUserId(user.getId(), DROPDOWN_LIMIT, 0);
        int unread = notificationDAO.countUnread(user.getId());

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("unreadCount", unread);
        List<Map<String, Object>> arr = new ArrayList<>();
        for (Notification n : items) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", n.getId());
            m.put("title", n.getTitle());
            m.put("message", n.getMessage());
            m.put("link", n.getLink());
            m.put("entityType", n.getEntityType());
            m.put("isRead", n.isRead());
            m.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().format(ISO));
            arr.add(m);
        }
        out.put("items", arr);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(out, response.getWriter());
    }

    private void handleMarkRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int id = parseInt(request.getParameter("id"), 0);
        if (id <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeJson(response, Map.of("ok", false, "error", "invalid_id"));
            return;
        }

        Notification n = notificationDAO.findById(id);
        if (n == null || n.getUserId() != user.getId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            writeJson(response, Map.of("ok", false, "error", "forbidden"));
            return;
        }

        boolean ok = n.isRead() || notificationDAO.markAsRead(id);
        writeJson(response, Map.of("ok", ok));
    }

    private void handleMarkAllRead(HttpServletResponse response, User user) throws IOException {
        int count = notificationDAO.markAllAsRead(user.getId());
        writeJson(response, Map.of("ok", true, "count", count));
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession s = request.getSession(false);
        if (s == null) return null;
        Object u = s.getAttribute("loggedUser");
        return u instanceof User ? (User) u : null;
    }

    private int parseInt(String s, int dflt) {
        if (s == null || s.isEmpty()) return dflt;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return dflt; }
    }

    private void writeJson(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(data, response.getWriter());
    }
}
