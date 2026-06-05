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
        } catch (Exception e) {
            // Xác định URI request để biết lỗi xảy ra ở đâu
            String source = "Unknown";
            if (request instanceof HttpServletRequest) {
                String uri = ((HttpServletRequest) request).getRequestURI();
                String method = ((HttpServletRequest) request).getMethod();
                source = method + " " + uri;
            }

            String message = e.getMessage() != null ? e.getMessage() : e.getClass().getName();
            SystemLogger.error("hệ thống", source, message, e);

            // Re-throw để server tiếp tục xử lý (hiển thị trang lỗi 500)
            throw e;
        }
    }
}
