package controller;

import dao.LearningPathDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.PersonalizedLearningPath;
import model.User;

/**
 * Controller Servlet quản lý Lộ trình học tập cá nhân hóa (Personalized Learning Path).
 * Dành cho Sinh viên tự theo dõi điểm yếu và Giảng viên giám sát chất lượng học tập.
 */
@WebServlet(name = "LearningPathServlet", urlPatterns = {"/learning-path"})
public class LearningPathServlet extends HttpServlet {

    private final LearningPathDAO learningPathDAO = new LearningPathDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        int roleId = currentUser.getRole_id();

        if (roleId == 3) {
            // Role Sinh viên: Xem lộ trình cá nhân của chính mình
            List<PersonalizedLearningPath> paths = learningPathDAO.getPathsByStudent(currentUser.getUser_id());
            
            int total = paths.size();
            int completed = 0;
            int inProgress = 0;
            for (PersonalizedLearningPath p : paths) {
                if ("COMPLETED".equalsIgnoreCase(p.getStatus())) {
                    completed++;
                } else {
                    inProgress++;
                }
            }
            int percent = total > 0 ? (completed * 100 / total) : 100;

            request.setAttribute("paths", paths);
            request.setAttribute("totalItems", total);
            request.setAttribute("completedItems", completed);
            request.setAttribute("inProgressItems", inProgress);
            request.setAttribute("progressPercent", percent);

        } else {
            // Role Giảng viên / Admin: Xem danh sách tổng hợp điểm yếu của sinh viên
            List<PersonalizedLearningPath> allPaths = learningPathDAO.getAllPaths();
            request.setAttribute("allPaths", allPaths);
        }

        request.getRequestDispatcher("/WEB-INF/views/learning_path.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int pathId = Integer.parseInt(request.getParameter("path_id"));
                String newStatus = request.getParameter("status"); // 'COMPLETED' or 'IN_PROGRESS'
                learningPathDAO.updateStatus(pathId, currentUser.getUser_id(), newStatus);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/learning-path");
    }
}
