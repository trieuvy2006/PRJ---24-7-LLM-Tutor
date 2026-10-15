package controller;

import dao.AssignmentDAO;
import dao.SubmissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;
import model.Assignment;
import model.Submission;
import model.User;

/**
 * Controller Servlet xử lý việc NỘP BÀI TẬP của Sinh viên.
 *
 * URL patterns:
 *   GET  /submit?assignment_id=X  → Xem form nộp bài cho bài tập X
 *   POST /submit                  → Xử lý upload file ZIP và lưu Submission
 *   GET  /submit?action=history   → Xem lịch sử nộp bài của bản thân
 */
@WebServlet(name = "SubmissionServlet", urlPatterns = {"/submit"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB threshold before writing to disk
    maxFileSize       = 50 * 1024 * 1024,  // Tối đa 50 MB mỗi file
    maxRequestSize    = 55 * 1024 * 1024   // Tối đa 55 MB mỗi request
)
public class SubmissionServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    // Thư mục lưu file nộp trên server (có thể config lại qua init-param)
    private static final String UPLOAD_DIR = "/uploads";

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

        if ("history".equals(action)) {
            // Xem lịch sử bài nộp của bản thân (Sinh viên)
            handleHistory(request, response, currentUser);
        } else {
            // Hiển thị form nộp bài cho một bài tập cụ thể
            handleShowSubmitForm(request, response, currentUser);
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

        // Chỉ sinh viên được nộp bài
        if (!currentUser.isStudent()) {
            response.sendRedirect(request.getContextPath() + "/assignments?error=forbidden");
            return;
        }

        handleDoSubmit(request, response, currentUser);
    }

    // ─────────────────────────── HANDLERS ───────────────────────────

    /**
     * Hiển thị form nộp bài cho một assignment_id cụ thể.
     */
    private void handleShowSubmitForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String idStr = request.getParameter("assignment_id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        try {
            int assignmentId = Integer.parseInt(idStr);
            Assignment assignment = assignmentDAO.getById(assignmentId);

            if (assignment == null) {
                response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
                return;
            }

            // Lấy bài nộp gần nhất của sinh viên này cho bài tập này (nếu có)
            Submission latestSubmission = null;
            if (currentUser.isStudent()) {
                latestSubmission = submissionDAO.getLatestByStudentAndAssignment(
                        assignmentId, currentUser.getUser_id());
            }

            request.setAttribute("assignment", assignment);
            request.setAttribute("latestSubmission", latestSubmission);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
        }
    }

    /**
     * Hiển thị lịch sử tất cả bài nộp của sinh viên.
     */
    private void handleHistory(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        List<Submission> history = submissionDAO.getByStudentId(currentUser.getUser_id());
        request.setAttribute("submissions", history);
        request.getRequestDispatcher("/WEB-INF/views/assignments/history.jsp").forward(request, response);
    }

    /**
     * Xử lý upload file và lưu bài nộp vào DB.
     */
    private void handleDoSubmit(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {

        String assignmentIdStr = request.getParameter("assignment_id");
        int assignmentId;
        try {
            assignmentId = Integer.parseInt(assignmentIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/assignments");
            return;
        }

        Assignment assignment = assignmentDAO.getById(assignmentId);
        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/assignments?error=not_found");
            return;
        }

        // Kiểm tra hạn nộp
        if (assignment.isOverdue()) {
            request.setAttribute("error", "Đã quá hạn nộp bài. Bài tập này đã đóng lúc "
                    + assignment.getDeadline() + ".");
            request.setAttribute("assignment", assignment);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);
            return;
        }

        // Lấy file từ request
        Part filePart = request.getPart("submission_file");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file ZIP để nộp bài.");
            request.setAttribute("assignment", assignment);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);
            return;
        }

        String fileName = getSubmittedFileName(filePart);
        if (fileName == null || !fileName.toLowerCase().endsWith(".zip")) {
            request.setAttribute("error", "Chỉ chấp nhận file định dạng ZIP (.zip).");
            request.setAttribute("assignment", assignment);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);
            return;
        }

        // Đếm số lần nộp trước đó để tính attempt_number
        int prevAttempts = submissionDAO.countAttempts(assignmentId, currentUser.getUser_id());
        int attemptNumber = prevAttempts + 1;

        // Đảm bảo sinh viên đã được ghi danh môn học này
        assignmentDAO.ensureStudentEnrolledCourse(currentUser.getUser_id(), assignment.getCourse_id());

        // Xác định đường dẫn lưu file
        String safeStudentCode = currentUser.getStudent_code() != null
                ? currentUser.getStudent_code() : "U" + currentUser.getUser_id();
        String savedFileName = assignment.getCourse_code() + "_"
                + assignment.getAssignment_id() + "_"
                + safeStudentCode + "_v" + attemptNumber + ".zip";
        String relativePath = UPLOAD_DIR + "/" + savedFileName;

        // Xác định thư mục upload an toàn
        String basePath = getServletContext().getRealPath("");
        if (basePath == null || basePath.trim().isEmpty()) {
            basePath = System.getProperty("user.dir");
        }
        File uploadFolder = new File(basePath, "uploads");
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }
        File destFile = new File(uploadFolder, savedFileName);

        // Lưu file vật lý vào server và đồng thời tính mã SHA-256 trong 1 lần đọc stream
        String sha256;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            try (InputStream in = filePart.getInputStream();
                 java.io.OutputStream out = new java.io.FileOutputStream(destFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    digest.update(buffer, 0, bytesRead);
                    out.write(buffer, 0, bytesRead);
                }
            }
            byte[] hashBytes = digest.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            sha256 = sb.toString();
        } catch (NoSuchAlgorithmException | IOException e) {
            request.setAttribute("error", "Lỗi lưu file bài làm: " + e.getMessage());
            request.setAttribute("assignment", assignment);
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);
            return;
        }

        // Lưu Submission vào database
        Submission sub = new Submission(assignmentId, currentUser.getUser_id(),
                sha256, relativePath, attemptNumber, Submission.STATUS_PENDING);
        String err = submissionDAO.insert(sub);

        if (err == null) {
            response.sendRedirect(request.getContextPath() + "/submit?action=history&message=submitted");
        } else {
            request.setAttribute("error", "Nộp bài thất bại: " + err);
            request.setAttribute("assignment", assignment);
            request.setAttribute("latestSubmission",
                    submissionDAO.getLatestByStudentAndAssignment(assignmentId, currentUser.getUser_id()));
            request.getRequestDispatcher("/WEB-INF/views/assignments/submit.jsp").forward(request, response);
        }
    }

    // ─────────────────────────── UTILITIES ───────────────────────────

    /**
     * Lấy tên file gốc từ Part, lọc bỏ đường dẫn Windows/Unix.
     */
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf("=") + 1).trim()
                        .replace("\"", "");
                // Lọc đường dẫn đầy đủ (IE gửi full path)
                int lastSlash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return lastSlash >= 0 ? name.substring(lastSlash + 1) : name;
            }
        }
        return null;
    }

    /**
     * Tính mã SHA-256 của nội dung InputStream và trả về chuỗi HEX 64 ký tự.
     */
    private String computeSHA256(InputStream is) throws IOException, NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] buffer = new byte[8192];
        int bytesRead;
        while ((bytesRead = is.read(buffer)) != -1) {
            digest.update(buffer, 0, bytesRead);
        }
        byte[] hashBytes = digest.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
