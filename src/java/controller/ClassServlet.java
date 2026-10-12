package controller;

import dao.ClassDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.ClassRoom;
import model.User;

/**
 * Controller Servlet quản lý Giao diện Danh sách Lớp học dành cho Giảng viên.
 */
@WebServlet(name = "ClassServlet", urlPatterns = {"/classes"})
public class ClassServlet extends HttpServlet {

    private final ClassDAO classDAO = new ClassDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        // Học sinh không xem trang này -> chuyển hướng về giao diện AI Tutor Chatbot
        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/chat");
            return;
        }

        List<ClassRoom> classes = classDAO.getAllClassesWithCount();
        request.setAttribute("classes", classes);
        request.getRequestDispatcher("/classes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
