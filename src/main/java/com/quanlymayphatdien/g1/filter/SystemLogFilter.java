package com.quanlymayphatdien.g1.filter;

import com.quanlymayphatdien.g1.utils.SystemLogger;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;



@WebFilter("/*")
public class SystemLogFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } catch (Throwable e) {
            // Xác ??nh URI request ?? bi?t l?i x?y ra ? ?âu
            String source = "Unknown";
            if (request instanceof HttpServletRequest) {
                String uri = ((HttpServletRequest) request).getRequestURI();
                String method = ((HttpServletRequest) request).getMethod();
                source = method + " " + uri;
            }

            String message = e.getMessage() != null ? e.getMessage() : e.getClass().getName();
            SystemLogger.error("h? th?ng", source, message, e);

            // Re-throw ?? server ti?p t?c x? lý (hi?n th? trang l?i 500)
            if (e instanceof IOException) throw (IOException) e;
            if (e instanceof ServletException) throw (ServletException) e;
            if (e instanceof RuntimeException) throw (RuntimeException) e;
            if (e instanceof Error) throw (Error) e;
            throw new ServletException(e);
        }
    }
}