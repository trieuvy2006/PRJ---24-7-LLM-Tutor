package controller;

import dao.AssignmentDAO;
import dao.SubmissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.Assignment;
import model.Submission;
import model.User;

/**
 * Controller Servlet quản lý toàn bộ luồng Bài tập (Assignments).
 *
 * URL patterns:
 *   GET  /assignments              → Danh sách bài tập (phân vai trò)
 *   GET  /assignments?action=add   → Form tạo bài tập mới (Admin/Instructor)
 *   POST /assignments?action=add   → Xử lý tạo bài tập mới
 *   GET  /assignments?action=edit&id=X   → Form sửa bài tập (bao gồm đổi deadline)
 *   POST /assignments?action=edit        → Xử lý cập nhật bài tập
 *   GET  /assignments?action=delete&id=X → Xóa bài tập
 *   GET  /assignments?action=submissions&id=X → Xem danh sách bài nộp của 1 bài tập
 */
@WebServlet(name = "AssignmentServlet", urlPatterns = {"/assignments"})
public class AssignmentServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();
    private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm";

    // ─────────────────────────── GET ───────────────────────────

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                handleShowAddForm(request, response, currentUser);
                break;
            case "edit":
                handleShowEditForm(request, response, currentUser);
                break;
            case "delete":
                handleDelete(request, response, currentUser);
                break;
            case "submissions":
                handleViewSubmissions(request, response, currentUser);
                break;
            default:
                handleList(request, response, currentUser);
                break;
        }
    }

    // ─────────────────────────── POST ───────────────────────────

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
        if (action == null) action = "";

        switch (action) {
            case "add":
                handleDoAdd(request, response, currentUser);
                break;
            case "edit":
                handleDoEdit(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/assignments");
                break;
        }
    }

    // ─────────────────────────── HANDLERS ───────────────────────────

    /**
     * Hiển thị danh sách bài tập (phân quyền theo role).
     * - Admin:      toàn bộ bài tập
     * - Instructor: bài tập do mình tạo
     * - Student:    bài tập của các môn mình đăng ký
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        List<Assignment> assignments;
        if (currentUser.isAdmin()) {
            assignments = assignmentDAO.getAll();
        } else if (currentUser.isInstructor()) {
            assignments = assignmentDAO.getByInstructorId(currentUser.getUser_id());
        } else {
            // Sinh viên
            assignments = assignmentDAO.getByStudentId(currentUser.getUser_id());
        }

        request.setAttribute("assignments", assignments);
        request.getRequestDispatcher("/WEB-INF/views/assignments/list.jsp").forward(request, response);
    }

    /**
     * Hiển thị form TẠO bài tập mới (chỉ Admin và Instructor).
     */
    private void handleShowAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }
        request.setAttribute("courses", assignmentDAO.getAllCourses());
        request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
    }

    /**
     * Xử lý tạo bài tập mới (POST).
     */
    private void handleDoAdd(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        String courseIdStr = request.getParameter("course_id");
        String deadlineStr = request.getParameter("deadline");

        // Validation
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề bài tập không được để trống.");
            request.setAttribute("courses", assignmentDAO.getAllCourses());
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        Timestamp deadline;
        try {
            deadline = parseDeadline(deadlineStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng deadline không hợp lệ. Vui lòng chọn lại.");
            request.setAttribute("courses", assignmentDAO.getAllCourses());
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Vui lòng chọn môn học.");
            request.setAttribute("courses", assignmentDAO.getAllCourses());
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        Assignment a = new Assignment(courseId, currentUser.getUser_id(), title.trim(), description, deadline);
        String err = assignmentDAO.insert(a);

        if (err == null) {
            response.sendRedirect(request.getContextPath() + "/assignments?message=created");
        } else {
            request.setAttribute("error", "Tạo bài tập thất bại: " + err);
            request.setAttribute("courses", assignmentDAO.getAllCourses());
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
        }
    }

    /**
     * Hiển thị form SỬA bài tập (chỉ Admin và Instructor tạo bài đó).
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Assignment a = assignmentDAO.getById(id);

            if (a == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
                return;
            }
            // Instructor chỉ sửa bài tập của mình
            if (currentUser.isInstructor() && a.getCreated_by() != currentUser.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=forbidden");
                return;
            }

            request.setAttribute("assignment", a);
            if (a.getDeadline() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                request.setAttribute("deadlineFormatted", sdf.format(a.getDeadline()));
            }
            request.setAttribute("courses", assignmentDAO.getAllCourses());
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }

    /**
     * Xử lý cập nhật bài tập / deadline (POST).
     */
    private void handleDoEdit(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        String idStr       = request.getParameter("assignment_id");
        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        String courseIdStr = request.getParameter("course_id");
        String deadlineStr = request.getParameter("deadline");

        try {
            int id = Integer.parseInt(idStr);
            Assignment existing = assignmentDAO.getById(id);

            if (existing == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
                return;
            }
            if (currentUser.isInstructor() && existing.getCreated_by() != currentUser.getUser_id()) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=forbidden");
                return;
            }

            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề bài tập không được để trống.");
                request.setAttribute("assignment", existing);
                request.setAttribute("deadlineFormatted", deadlineStr);
                request.setAttribute("courses", assignmentDAO.getAllCourses());
                request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
                return;
            }

            Timestamp deadline;
            try {
                deadline = parseDeadline(deadlineStr);
            } catch (ParseException e) {
                request.setAttribute("error", "Định dạng deadline không hợp lệ. Vui lòng chọn lại.");
                request.setAttribute("assignment", existing);
                request.setAttribute("deadlineFormatted", deadlineStr);
                request.setAttribute("courses", assignmentDAO.getAllCourses());
                request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(courseIdStr);
            } catch (NumberFormatException e) {
                courseId = existing.getCourse_id();
            }

            Assignment updated = new Assignment(
                id,
                courseId,
                existing.getCreated_by(),
                title.trim(),
                description,
                deadline,
                existing.getCreated_at()
            );
            String err = assignmentDAO.update(updated);

            if (err == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?message=updated");
            } else {
                request.setAttribute("error", "Cập nhật thất bại: " + err);
                request.setAttribute("assignment", existing);
                request.setAttribute("deadlineFormatted", deadlineStr);
                request.setAttribute("courses", assignmentDAO.getAllCourses());
                request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }

    /**
     * Xóa bài tập (chỉ Admin; Instructor không được xóa).
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/assignments?error=forbidden");
            return;
        }

        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            String err = assignmentDAO.delete(id);
            if (err == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?message=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/assignments?error=" + java.net.URLEncoder.encode(err, "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }

    /**
     * Xem danh sách bài nộp của một bài tập cụ thể (Admin/Instructor).
     */
    private void handleViewSubmissions(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr);
            Assignment assignment = assignmentDAO.getById(id);
            if (assignment == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
                return;
            }

            List<Submission> submissions = submissionDAO.getByAssignmentId(id);
            request.setAttribute("assignment", assignment);
            request.setAttribute("submissions", submissions);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submissions.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }

    /**
     * Parse chuỗi datetime-local (HTML input type="datetime-local") thành Timestamp.
     */
    private Timestamp parseDeadline(String deadlineStr) throws ParseException {
        if (deadlineStr == null || deadlineStr.trim().isEmpty()) {
            throw new ParseException("Empty deadline", 0);
        }
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        java.util.Date d = sdf.parse(deadlineStr.trim());
        return new Timestamp(d.getTime());
    }
}
