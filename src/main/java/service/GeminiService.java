package service;

public class GeminiService {
    public String askTutor(String question) {
        if (question == null || question.trim().isEmpty()) {
            return "Please enter a question.";
        }

        // TODO: Call Gemini API and return the AI tutor response.
        return "AI tutor response placeholder for: " + question;
    }
}
