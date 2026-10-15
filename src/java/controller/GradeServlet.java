package controller;

import dao.SubmissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;

/**
 * Controller Servlet xử lý chấm điểm bài nộp của sinh viên.
 *
 * URL patterns:
 *   POST /grade  → Giáo viên/Admin chấm điểm (AJAX JSON)
 */
@WebServlet(name = "GradeServlet", urlPatterns = {"/grade"})
@MultipartConfig
public class GradeServlet extends HttpServlet {

    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Chỉ Instructor và Admin mới được chấm điểm
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"success\":false,\"error\":\"Bạn chưa đăng nhập.\"}");
            return;
        }
        if (currentUser.isStudent()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            out.write("{\"success\":false,\"error\":\"Sinh viên không được phép chấm điểm.\"}");
            return;
        }

        // Lấy tham số
        String subIdStr   = request.getParameter("submission_id");
        String scoreStr   = request.getParameter("score");
        String feedback   = request.getParameter("feedback");

        int submissionId;
        double score;

        try {
            submissionId = Integer.parseInt(subIdStr);
        } catch (NumberFormatException e) {
            out.write("{\"success\":false,\"error\":\"submission_id không hợp lệ.\"}");
            return;
        }

        try {
            score = Double.parseDouble(scoreStr.replace(",", "."));
        } catch (NumberFormatException | NullPointerException e) {
            out.write("{\"success\":false,\"error\":\"Điểm số không hợp lệ. Vui lòng nhập số từ 0 đến 10.\"}");
            return;
        }

        // Validate phạm vi điểm
        if (score < 0 || score > 10) {
            out.write("{\"success\":false,\"error\":\"Điểm số phải nằm trong khoảng 0.0 – 10.0.\"}");
            return;
        }

        // Lưu điểm vào database
        String err = submissionDAO.upsertGrade(submissionId, score, feedback);

        if (err == null) {
            // Trả về JSON thành công kèm dữ liệu để update UI
            String feedbackJson = "";
            if (feedback != null && !feedback.trim().isEmpty()) {
                feedbackJson = feedback.trim()
                        .replace("\\", "\\\\")
                        .replace("\"", "\\\"")
                        .replace("\r", "\\r")
                        .replace("\n", "\\n")
                        .replace("\t", "\\t");
            }
            // BẮT BUỘC dùng Locale.US để dấu thập phân luôn là dấu chấm '.', tránh lỗi cú pháp JSON khi hệ thống ở locale vi_VN (dấu phẩy ',')
            out.write("{\"success\":true,"
                    + "\"score\":" + String.format(java.util.Locale.US, "%.1f", score) + ","
                    + "\"feedback\":\"" + feedbackJson + "\"}");
            out.flush();
        } else {
            out.write("{\"success\":false,\"error\":\"" + err.replace("\"", "'") + "\"}");
            out.flush();
        }
    }
}
