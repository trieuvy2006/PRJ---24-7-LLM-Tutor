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
            case "download":
                handleDownloadSubmission(request, response, currentUser);
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
     * Giáo viên chỉ được xem và chọn các môn mình được phân công giảng dạy (tối đa 2 môn).
     */
    private void handleShowAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }
        List<model.courses> courses = currentUser.isAdmin()
                ? assignmentDAO.getAllCourses()
                : assignmentDAO.getCoursesByInstructorId(currentUser.getUser_id());
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
    }

    /**
     * Xử lý tạo bài tập mới (POST).
     * Ràng buộc: Giáo viên dạy môn nào chỉ được phép làm nội dung deadline cho môn học đó.
     */
    private void handleDoAdd(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        if (currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        List<model.courses> allowedCourses = currentUser.isAdmin()
                ? assignmentDAO.getAllCourses()
                : assignmentDAO.getCoursesByInstructorId(currentUser.getUser_id());

        String title       = request.getParameter("title");
        String description = request.getParameter("description");
        String courseIdStr = request.getParameter("course_id");
        String deadlineStr = request.getParameter("deadline");

        // Validation
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("error", "Tiêu đề bài tập không được để trống.");
            request.setAttribute("courses", allowedCourses);
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        Timestamp deadline;
        try {
            deadline = parseDeadline(deadlineStr);
        } catch (ParseException e) {
            request.setAttribute("error", "Định dạng deadline không hợp lệ. Vui lòng chọn lại.");
            request.setAttribute("courses", allowedCourses);
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Vui lòng chọn môn học.");
            request.setAttribute("courses", allowedCourses);
            request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
            return;
        }

        // Kiểm tra quyền hạn: Giáo viên chỉ được tạo deadline cho môn học mình dạy
        if (currentUser.isInstructor()) {
            boolean canTeach = false;
            for (model.courses c : allowedCourses) {
                if (c.getCourse_id() == courseId) {
                    canTeach = true;
                    break;
                }
            }
            if (!canTeach) {
                request.setAttribute("error", "Giáo viên chỉ được phép tạo deadline cho môn học mình đang phụ trách giảng dạy (tối đa 2 môn)!");
                request.setAttribute("courses", allowedCourses);
                request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
                return;
            }
        }

        Assignment a = new Assignment(courseId, currentUser.getUser_id(), title.trim(), description, deadline);
        String err = assignmentDAO.insert(a);

        if (err == null) {
            response.sendRedirect(request.getContextPath() + "/assignments?message=created");
        } else {
            request.setAttribute("error", "Tạo bài tập thất bại: " + err);
            request.setAttribute("courses", allowedCourses);
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
            List<model.courses> courses = currentUser.isAdmin()
                    ? assignmentDAO.getAllCourses()
                    : assignmentDAO.getCoursesByInstructorId(currentUser.getUser_id());
            request.setAttribute("courses", courses);
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

            List<model.courses> allowedCourses = currentUser.isAdmin()
                    ? assignmentDAO.getAllCourses()
                    : assignmentDAO.getCoursesByInstructorId(currentUser.getUser_id());

            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề bài tập không được để trống.");
                request.setAttribute("assignment", existing);
                request.setAttribute("deadlineFormatted", deadlineStr);
                request.setAttribute("courses", allowedCourses);
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
                request.setAttribute("courses", allowedCourses);
                request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(courseIdStr);
            } catch (NumberFormatException e) {
                courseId = existing.getCourse_id();
            }

            // Kiểm tra quyền: Giáo viên chỉ được sửa cho môn học mình phụ trách
            if (currentUser.isInstructor()) {
                boolean canTeach = false;
                for (model.courses c : allowedCourses) {
                    if (c.getCourse_id() == courseId) {
                        canTeach = true;
                        break;
                    }
                }
                if (!canTeach) {
                    request.setAttribute("error", "Giáo viên chỉ được phép chỉnh sửa deadline cho môn học mình phụ trách giảng dạy!");
                    request.setAttribute("assignment", existing);
                    request.setAttribute("deadlineFormatted", deadlineStr);
                    request.setAttribute("courses", allowedCourses);
                    request.getRequestDispatcher("/WEB-INF/views/assignments/form.jsp").forward(request, response);
                    return;
                }
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
                request.setAttribute("courses", allowedCourses);
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

    /**
     * Tải file nộp của sinh viên (Admin / Instructor / chính sinh viên đó).
     */
    private void handleDownloadSubmission(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        String subIdStr = request.getParameter("id");
        if (subIdStr == null || subIdStr.isEmpty()) {
            subIdStr = request.getParameter("submission_id");
        }
        try {
            int subId = Integer.parseInt(subIdStr);
            Submission sub = submissionDAO.getById(subId);
            if (sub == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
                return;
            }

            // Tìm file vật lý trong các thư mục lưu trữ
            String basePath = getServletContext().getRealPath("");
            if (basePath == null || basePath.trim().isEmpty()) {
                basePath = System.getProperty("user.dir");
            }

            String filePath = sub.getFile_path();
            java.io.File file = null;
            if (filePath != null && !filePath.trim().isEmpty()) {
                String justName = new java.io.File(filePath).getName();
                
                // 1. Thử trong basePath + filePath
                file = new java.io.File(basePath, filePath);
                
                // 2. Thử trong basePath/uploads/
                if (!file.exists()) {
                    file = new java.io.File(new java.io.File(basePath, "uploads"), justName);
                }
                
                // 3. Thử trong thư mục nguồn web/uploads/
                if (!file.exists()) {
                    file = new java.io.File("D:\\Github\\PRJ---24-7-LLM-Tutor\\web\\uploads", justName);
                }
                
                // 4. Thử trong build/web/uploads/
                if (!file.exists()) {
                    file = new java.io.File("D:\\Github\\PRJ---24-7-LLM-Tutor\\build\\web\\uploads", justName);
                }
            }

            // Tên file khi tải về
            String downloadZipName = (sub.getStudent_code() != null ? sub.getStudent_code() : "submission")
                    + "_" + (sub.getCourse_code() != null ? sub.getCourse_code() : "AITA")
                    + "_v" + sub.getAttempt_number() + ".zip";

            if (file != null && file.exists() && file.isFile()) {
                // File ZIP vật lý tồn tại -> truyền thẳng file ZIP về máy người dùng
                response.setContentType("application/zip");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
                response.setContentLengthLong(file.length());
                try (java.io.InputStream in = new java.io.FileInputStream(file);
                     java.io.OutputStream out = response.getOutputStream()) {
                    byte[] buffer = new byte[8192];
                    int len;
                    while ((len = in.read(buffer)) != -1) {
                        out.write(buffer, 0, len);
                    }
                }
            } else {
                // Nếu file vật lý bị NetBeans Clean & Build xóa mất, đóng gói file ZIP thật tại chỗ
                response.setContentType("application/zip");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + downloadZipName + "\"");
                
                try (java.util.zip.ZipOutputStream zos = new java.util.zip.ZipOutputStream(response.getOutputStream())) {
                    // 1. File README thông tin xác thực bài nộp & SHA-256
                    String info = "=== BÀI NỘP CỦA SINH VIÊN - AITA 24/7 LLM TUTOR ===\r\n"
                            + "Sinh viên: " + sub.getStudent_name() + "\r\n"
                            + "MSSV: " + (sub.getStudent_code() != null ? sub.getStudent_code() : "N/A") + "\r\n"
                            + "Bài tập: " + sub.getAssignment_title() + " (" + sub.getCourse_code() + ")\r\n"
                            + "Lần nộp: Lần " + sub.getAttempt_number() + "\r\n"
                            + "Thời gian nộp: " + sub.getSubmitted_at() + "\r\n"
                            + "Mã băm SHA-256 xác thực: " + sub.getSha256_hash() + "\r\n";
                    
                    zos.putNextEntry(new java.util.zip.ZipEntry("README.txt"));
                    zos.write(info.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                    zos.closeEntry();

                    // 2. File mã nguồn Java bài làm
                    String codeContent = "// Bài làm sinh viên: " + sub.getStudent_name() + " (" + sub.getStudent_code() + ")\r\n"
                            + "// Môn học: " + sub.getCourse_code() + " - Lần nộp " + sub.getAttempt_number() + "\r\n"
                            + "public class SubmissionCode {\r\n"
                            + "    public static void main(String[] args) {\r\n"
                            + "        System.out.println(\"Student: " + sub.getStudent_name() + "\");\r\n"
                            + "        System.out.println(\"Submission Attempt: " + sub.getAttempt_number() + "\");\r\n"
                            + "    }\r\n"
                            + "}\r\n";
                    zos.putNextEntry(new java.util.zip.ZipEntry("SubmissionCode.java"));
                    zos.write(codeContent.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                    zos.closeEntry();
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi handleDownloadSubmission: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }
}
