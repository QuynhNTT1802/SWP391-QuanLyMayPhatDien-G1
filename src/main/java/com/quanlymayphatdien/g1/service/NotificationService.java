package com.quanlymayphatdien.g1.service;

import com.quanlymayphatdien.g1.dal.NotificationDAO;
import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.Notification;
import com.quanlymayphatdien.g1.entity.User;

import java.util.List;

public class NotificationService {

    private static final NotificationDAO dao = new NotificationDAO();
    private static final UserDAO userDAO = new UserDAO();

    private NotificationService() {
    }

    public static boolean send(int userId, String title, String message, String link,
                               String entityType, Integer entityId) {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setTitle(title);
        n.setMessage(message);
        n.setLink(link);
        n.setEntityType(entityType);
        n.setEntityId(entityId);
        n.setRead(false);
        return dao.insert(n);
    }

    public static int sendToRole(String roleName, String title, String message, String link,
                                 String entityType, Integer entityId) {
        List<User> users = userDAO.findUsersWithRoles(roleName, null, null, 1, 1000);
        int sent = 0;
        for (User u : users) {
            if (send(u.getId(), title, message, link, entityType, entityId)) {
                sent++;
            }
        }
        return sent;
    }
}
