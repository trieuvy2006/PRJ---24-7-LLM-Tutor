package controller;

import dao.TutorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.TutorMessage;
import model.User;
import service.AiTutorService;

/**
 * Controller Servlet quản lý Giao diện AI Tutor Chatbot 24/7 và xử lý hội thoại AI thời gian thực.
 */
@WebServlet(name = "ChatServlet", urlPatterns = {"/chat"})
public class ChatServlet extends HttpServlet {

    private final AiTutorService aiTutorService = new AiTutorService();
    private final TutorDAO tutorDAO = new TutorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=access_denied");
            return;
        }

        int sessionId = requestedSessionId(request, currentUser.getUser_id());
        if (sessionId <= 0) sessionId = tutorDAO.getOrCreateActiveSession(currentUser.getUser_id(), null, null, null);
        List<TutorMessage> messages = tutorDAO.getMessagesBySession(sessionId);

        request.setAttribute("chatSessionId", sessionId);
        request.setAttribute("chatMessages", messages);
        request.setAttribute("chatSessions", tutorDAO.getRecentSessions(currentUser.getUser_id()));

        // Chuyển tới giao diện Chatbox
        request.getRequestDispatcher("/chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        PrintWriter out = response.getWriter();

        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"status\":\"error\",\"message\":\"Phiên đăng nhập đã hết hạn.\"}");
            return;
        }

        String action = request.getParameter("action");
        if ("newSession".equals(action)) {
            int newSessionId = tutorDAO.createNewSession(currentUser.getUser_id(), null, null, null);
            if (newSessionId <= 0) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\":\"error\",\"message\":\"Không thể tạo cuộc trò chuyện mới.\"}");
            } else {
                out.print("{\"status\":\"success\",\"sessionId\":" + newSessionId + "}");
            }
            return;
        }

        if ("deleteSession".equals(action)) {
            try {
                int delSessionId = Integer.parseInt(request.getParameter("sessionId"));
                boolean deleted = tutorDAO.deleteSession(delSessionId, currentUser.getUser_id());
                if (deleted) {
                    out.print("{\"status\":\"success\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"status\":\"error\",\"message\":\"Không thể xóa cuộc trò chuyện này.\"}");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\":\"error\",\"message\":\"Tham số sessionId không hợp lệ.\"}");
            }
            return;
        }

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\",\"message\":\"Tin nhắn không được để trống.\"}");
            return;
        }
        if (userMessage.length() > 30_000) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\",\"message\":\"Tin nhắn vượt quá 30000 ký tự.\"}");
            return;
        }

        int sessionId = requestedSessionId(request, currentUser.getUser_id());
        if (sessionId <= 0) sessionId = tutorDAO.getOrCreateActiveSession(currentUser.getUser_id(), null, null, null);

        // 1. Lưu tin nhắn của sinh viên vào Database
        tutorDAO.saveMessage(sessionId, "STUDENT", userMessage.trim());

        // 2. Chuyển qua AI Tutor Service phân tích lỗi sư phạm & cập nhật Lộ trình học tập
        List<TutorMessage> conversation = tutorDAO.getMessagesBySession(sessionId);
        AiTutorService.AiResponse aiRes = aiTutorService.processStudentInquiry(currentUser.getUser_id(), userMessage.trim(), conversation);

        // 3. Lưu câu trả lời của AI Tutor vào Database
        tutorDAO.saveMessage(sessionId, "LLM_TUTOR", aiRes.getAnswerHtml());

        // 4. Trả về JSON cho giao diện người dùng
        String jsonAnswer = escapeJson(aiRes.getAnswerHtml());
        String jsonTopic = aiRes.getDetectedTopic() != null ? escapeJson(aiRes.getDetectedTopic()) : "";
        String jsonAction = aiRes.getRecommendedAction() != null ? escapeJson(aiRes.getRecommendedAction()) : "";

        out.print("{"
                + "\"status\":\"success\","
                + "\"sessionId\":" + sessionId + ","
                + "\"answerHtml\":\"" + jsonAnswer + "\","
                + "\"detectedTopic\":\"" + jsonTopic + "\","
                + "\"recommendedAction\":\"" + jsonAction + "\","
                + "\"pathCreated\":" + aiRes.isPathCreated()
                + "}");
    }

    private int requestedSessionId(HttpServletRequest request, int studentId) {
        try {
            int sessionId = Integer.parseInt(request.getParameter("sessionId"));
            return sessionId > 0 && tutorDAO.belongsToStudent(sessionId, studentId) ? sessionId : -1;
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
