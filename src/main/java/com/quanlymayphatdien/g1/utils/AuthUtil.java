package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.Set;

public final class AuthUtil {

    private AuthUtil() {
    }

    @SuppressWarnings("unchecked")
    public static Set<String> permissions(HttpSession session) {
        if (session == null) return null;
        return (Set<String>) session.getAttribute("userPermissions");
    }

    public static boolean has(HttpSession session, String perm) {
        Set<String> p = permissions(session);
        return p != null && p.contains(perm);
    }

    public static boolean hasAny(HttpSession session, String... perms) {
        Set<String> p = permissions(session);
        if (p == null) return false;
        for (String perm : perms) {
            if (p.contains(perm)) return true;
        }
        return false;
    }

    public static User loggedUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute("loggedUser");
    }

    public static boolean isLoggedIn(HttpSession session) {
        return loggedUser(session) != null;
    }

    public static boolean has(HttpServletRequest req, String perm) {
        return has(req.getSession(false), perm);
    }
}
