package controller;
 
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
 
/**
 *
 * @author trieuvy
 */
@WebServlet(name = "AddServlet", urlPatterns = {"/add"})
public class AddServlet extends HttpServlet {
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role_id_raw = request.getParameter("role_id");
        String username = request.getParameter("username");
        String password_hash = request.getParameter("password_hash");
        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        UserDAO udb = new UserDAO();
 
        try {
            int role_id = Integer.parseInt(role_id_raw);
            User uNew = new User(role_id, username, password_hash, full_name, email, phone);
            String err = udb.insert(uNew);
            if (err == null) {
                response.sendRedirect("user");
            } else {
                request.setAttribute("error", "Insert failed: " + err);
                request.getRequestDispatcher("add.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Role_ID phải là số");
            request.getRequestDispatcher("add.jsp").forward(request, response);
        }
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
 
    @Override
    public String getServletInfo() {
        return "Short description";
    }
}