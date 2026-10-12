package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;
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
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Mặc định là /login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
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

            // Xử lý Remember Me (Cookie)
            String remember = request.getParameter("remember");
            Cookie cUser = new Cookie("cuser", username);
            Cookie cPass = new Cookie("cpass", password);
            if (remember != null) {
                cUser.setMaxAge(60 * 60 * 24 * 7); // 7 days
                cPass.setMaxAge(60 * 60 * 24 * 7);
            } else {
                cUser.setMaxAge(0);
                cPass.setMaxAge(0);
            }
            response.addCookie(cUser);
            response.addCookie(cPass);

            // Phân luồng điều hướng theo vai trò thực tế:
            // - Quản trị viên (Admin) -> Quản trị người dùng /user
            // - Giảng viên (Instructor) -> Danh sách lớp học phụ trách /classes
            // - Sinh viên (Student) -> Giao diện AI Tutor Chatbot 24/7 /chat
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/user");
            } else if (user.isInstructor()) {
                response.sendRedirect(request.getContextPath() + "/classes");
            } else {
                response.sendRedirect(request.getContextPath() + "/chat");
            }
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            if (errorMsg == null || errorMsg.trim().isEmpty()) {
                errorMsg = "Tên đăng nhập hoặc mật khẩu không chính xác. Vui lòng thử lại!";
            }
            request.setAttribute("error", errorMsg);
            request.setAttribute("username", username);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
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

            // Tài khoản đăng ký mới là Sinh viên -> chuyển hướng về giao diện Chatbot AI /chat
            response.sendRedirect(request.getContextPath() + "/chat");
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            if (errorMsg == null || errorMsg.trim().isEmpty()) {
                errorMsg = "Đăng ký không thành công. Vui lòng kiểm tra lại thông tin!";
            }
            request.setAttribute("error", errorMsg);
            request.setAttribute("username", username);
            request.setAttribute("full_name", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("student_code", studentCode);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
