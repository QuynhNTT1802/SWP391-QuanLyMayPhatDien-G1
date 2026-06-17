package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.dal.SystemLogDAO;
import com.quanlymayphatdien.g1.entity.SystemLog;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Helper ghi log hệ thống. Module nên dùng hằng số từ {@link LogModule}
 * để dữ liệu nhất quán cho UI filter.
 */
public class SystemLogger {

    private static final SystemLogDAO dao = new SystemLogDAO();

    public static void info(String module, String source, String message) {
        insert("INFO", module, source, message, null);
    }

    public static void warn(String module, String source, String message) {
        insert("WARNING", module, source, message, null);
    }

    public static void error(String module, String source, String message, Throwable ex) {
        String stackTrace = null;
        if (ex != null) {
            StringWriter sw = new StringWriter();
            ex.printStackTrace(new PrintWriter(sw));
            stackTrace = sw.toString();
        }
        insert("ERROR", module, source, message, stackTrace);
    }

    public static void error(String module, String source, String message) {
        insert("ERROR", module, source, message, null);
    }

    private static void insert(String level, String module, String source, String message, String stackTrace) {
        try {
            dao.insert(new SystemLog(level, normalizeModule(module), source, message, stackTrace));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Trim + default về {@link LogModule#SYSTEM} nếu null/blank.
     * Không ép case để giữ nguyên tiếng Việt có dấu.
     */
    private static String normalizeModule(String module) {
        if (module == null) return LogModule.SYSTEM;
        String trimmed = module.trim();
        return trimmed.isEmpty() ? LogModule.SYSTEM : trimmed;
    }
}
