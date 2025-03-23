package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username"); // Get username from session

        if (username == null) {
            // Nếu không có username trong session, hiển thị thông báo lỗi trên profile.jsp
            request.setAttribute("errorMessage", "You must log in to view your profile.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // Fetch user information from the database
        User user = UserDAO.getUserByUsername(username);
        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            // Nếu không tìm thấy user trong database, hiển thị thông báo lỗi trên profile.jsp
            request.setAttribute("errorMessage", "User data is not available. Please contact support.");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }

        // Debugging logs
        System.out.println("Username from session: " + username);
        if (user != null) {
            System.out.println("User found: " + user.getFullName());
        } else {
            System.out.println("User not found in database.");
        }
    }
}