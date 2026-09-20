package controller;

import dao.DemoMessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DatabaseDemoServlet", urlPatterns = {"/database-demo"})
public class DatabaseDemoServlet extends HttpServlet {

    private final DemoMessageDAO messageDAO = new DemoMessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        showPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String content = request.getParameter("content");
        try {
            if (content != null && !content.trim().isEmpty()) {
                messageDAO.add(content.trim());
            }
            response.sendRedirect(request.getContextPath() + "/database-demo");
        } catch (ClassNotFoundException | java.sql.SQLException exception) {
            request.setAttribute("error", exception.getMessage());
            showPage(request, response);
        }
    }

    private void showPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("messages", messageDAO.getAll());
            request.setAttribute("connected", Boolean.TRUE);
        } catch (ClassNotFoundException | java.sql.SQLException exception) {
            request.setAttribute("connected", Boolean.FALSE);
            request.setAttribute("error", exception.getMessage());
        }
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
