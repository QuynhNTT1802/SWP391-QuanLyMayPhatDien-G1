package com.quanlymayphatdien.g1.listener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;

@WebListener
public class WebContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 1. Terminate MySQL AbandonedConnectionCleanupThread cleanly
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Throwable e) {
            System.err.println("WebContextListener: Failed to shutdown AbandonedConnectionCleanupThread - " + e.getMessage());
        }

        // 2. Deregister JDBC drivers registered by web application classloader
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            ClassLoader driverClassLoader = driver.getClass().getClassLoader();
            ClassLoader webAppClassLoader = Thread.currentThread().getContextClassLoader();

            if (driverClassLoader == webAppClassLoader || driverClassLoader == WebContextListener.class.getClassLoader()) {
                try {
                    DriverManager.deregisterDriver(driver);
                } catch (SQLException e) {
                    System.err.println("WebContextListener: Failed to deregister driver " + driver + " - " + e.getMessage());
                }
            }
        }
    }
}
