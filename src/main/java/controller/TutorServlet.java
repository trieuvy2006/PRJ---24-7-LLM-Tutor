package controller;

import service.GeminiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "TutorServlet", urlPatterns = {"/tutor"})
public class TutorServlet extends HttpServlet {
    private final GeminiService geminiService = new GeminiService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/tutor-chat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String question = request.getParameter("question");
        String answer = geminiService.askTutor(question);

        request.setAttribute("question", question);
        request.setAttribute("answer", answer);
        request.getRequestDispatcher("/tutor-chat.jsp").forward(request, response);
    }
}
