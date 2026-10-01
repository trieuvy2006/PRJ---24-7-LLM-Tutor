package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter để kiểm tra quyền truy cập (Authentication)
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/user", "/add", "/update", "/delete"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        // Kiểm tra xem user đã đăng nhập chưa
        if (session != null && session.getAttribute("currentUser") != null) {
            // Đã đăng nhập, cho phép đi tiếp
            chain.doFilter(request, response);
        } else {
            // Chưa đăng nhập, chuyển hướng về trang login
            res.sendRedirect(req.getContextPath() + "/login?error=Please login first");
        }
    }

    @Override
    public void destroy() {
    }
}
