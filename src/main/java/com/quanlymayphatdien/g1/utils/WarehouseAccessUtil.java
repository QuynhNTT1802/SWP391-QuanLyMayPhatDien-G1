package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.dal.UserDAO;
import com.quanlymayphatdien.g1.entity.User;
import jakarta.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;

public class WarehouseAccessUtil {

    public static final int UNRESTRICTED = -1;
    public static final int NO_WAREHOUSE_ASSIGNED = 0;

    private WarehouseAccessUtil() {
    }

    public static int getScopedWarehouseId(HttpSession session) {
        if (session == null) {
            return UNRESTRICTED;
        }
        Object cached = session.getAttribute("scopedWarehouseId");
        if (cached instanceof Integer) {
            return (Integer) cached;
        }
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            return UNRESTRICTED;
        }
        int scoped = new UserDAO().getScopedWarehouseId(user.getId());
        session.setAttribute("scopedWarehouseId", scoped);
        return scoped;
    }

    public static boolean isWarehouseScoped(HttpSession session) {
        return getScopedWarehouseId(session) > 0;
    }

    public static boolean canAccessWarehouse(HttpSession session, int warehouseId) {
        int scoped = getScopedWarehouseId(session);
        if (scoped <= 0) {
            return true;
        }
        return scoped == warehouseId;
    }

    public static List<Integer> getAllowedWarehouseIds(HttpSession session) {
        int scoped = getScopedWarehouseId(session);
        if (scoped > 0) {
            return Collections.singletonList(scoped);
        }
        return null;
    }
}