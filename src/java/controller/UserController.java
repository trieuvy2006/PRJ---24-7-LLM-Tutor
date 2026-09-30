package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import service.UserService;

/**
 * Controller Servlet quản lý thông tin tài khoản người dùng theo mô hình MVC,
 * sử dụng UserService để kiểm tra phân quyền và tính hợp lệ của dữ liệu.
 */
@WebServlet(name = "UserController", urlPatterns = { "/users", "/profile" })
public class UserController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String path = request.getServletPath();

        if ("/profile".equals(path)) {
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            try {
                User profile = userService.getUserById(currentUser, currentUser.getUser_id());
                request.setAttribute("user", profile);
                request.getRequestDispatcher("update.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("user.jsp").forward(request, response);
            }
            return;
        }

        // /users: Xem danh sách
        try {
            if (currentUser == null) {
                // Nếu chưa đăng nhập qua session, chuyển hướng tới danh sách mặc định hoặc
                // login
                response.sendRedirect(request.getContextPath() + "/user");
                return;
            }
            List<User> list = userService.getAllUsers(currentUser);
            request.setAttribute("data", list);
            request.getRequestDispatcher("user.jsp").forward(request, response);
        } catch (SecurityException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("user.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("user.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            String fullName = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String classIdRaw = request.getParameter("class_id");

            Integer classId = null;
            if (classIdRaw != null && !classIdRaw.trim().isEmpty()) {
                try {
                    classId = Integer.parseInt(classIdRaw.trim());
                } catch (NumberFormatException ignored) {
                }
            }

            try {
                userService.updateStudentProfile(currentUser, fullName, email, phone, classId);
                // Cập nhật lại session
                session.setAttribute("currentUser", currentUser);
                response.sendRedirect(request.getContextPath() + "/user?message=profile_updated");
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("update.jsp").forward(request, response);
            }
        }
    }
}
