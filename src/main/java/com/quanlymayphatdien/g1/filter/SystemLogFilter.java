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

/**
 * Filter bắt mọi exception chưa được xử lý (uncaught) từ toàn bộ ứng dụng.
 * Khi phát hiện exception, ghi vào bảng system_log mức ERROR kèm stack trace,
 * sau đó re-throw để hệ thống tiếp tục xử lý lỗi bình thường (hiển thị trang lỗi).
 *
 * Vì là @WebFilter("/*"), filter này chạy SAU EncodingFilter và SecurityFilter.
 * Thứ tự thực thi phụ thuộc vào thứ tự khai báo trong web.xml hoặc thứ tự load.
 */
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
            SystemLogger.error(source, message, e);
            throw e;
        }
    }
}
