package com.quanlymayphatdien.g1.utils;

import com.quanlymayphatdien.g1.dal.SystemLogDAO;
import com.quanlymayphatdien.g1.entity.SystemLog;
import java.io.PrintWriter;
import java.io.StringWriter;


public class SystemLogger {

    private static final SystemLogDAO dao = new SystemLogDAO();


    public static void info(String source, String message) {
        insert("INFO", source, message, null);
    }

    public static void warn(String source, String message) {
        insert("WARNING", source, message, null);
    }


    public static void error(String source, String message, Throwable ex) {
        String stackTrace = null;
        if (ex != null) {
            StringWriter sw = new StringWriter();
            ex.printStackTrace(new PrintWriter(sw));
            stackTrace = sw.toString();
        }
        insert("ERROR", source, message, stackTrace);
    }


    public static void error(String source, String message) {
        insert("ERROR", source, message, null);
    }

    private static void insert(String level, String source, String message, String stackTrace) {
        try {
            dao.insert(new SystemLog(level, source, message, stackTrace));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
