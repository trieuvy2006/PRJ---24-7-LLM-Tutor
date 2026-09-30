package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import service.AuthService;

/**
 * Controller Servlet xử lý Đăng nhập, Đăng ký và Đăng xuất.
 */
@WebServlet(name = "AuthController", urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/login?message=logged_out");
            return;
        }

        if ("/register".equals(path)) {
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Mặc định là /login
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/register".equals(path)) {
            handleRegister(request, response);
        } else {
            handleLogin(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = authService.login(username, password);
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("role", user.getRole_name());

            // Chuyển hướng tới trang quản lý người dùng sau khi đăng nhập thành công
            response.sendRedirect(request.getContextPath() + "/user");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String studentCode = request.getParameter("student_code");
        String classIdRaw = request.getParameter("class_id");

        Integer classId = null;
        if (classIdRaw != null && !classIdRaw.trim().isEmpty()) {
            try {
                classId = Integer.parseInt(classIdRaw.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        try {
            User newUser = authService.register(username, password, fullName, email, phone, studentCode, classId);
            HttpSession session = request.getSession(true);
            session.setAttribute("currentUser", newUser);
            session.setAttribute("role", newUser.getRole_name());

            response.sendRedirect(request.getContextPath() + "/user");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("full_name", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("student_code", studentCode);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
