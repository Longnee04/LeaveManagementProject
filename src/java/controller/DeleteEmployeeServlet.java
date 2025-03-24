package controller;

import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/deleteEmployee")
public class DeleteEmployeeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"Manager".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userID = Integer.parseInt(request.getParameter("userID"));

        boolean isDeleted = UserDAO.deleteUser(userID);

        if (isDeleted) {
            session.setAttribute("successMessage", "Employee deleted successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to delete employee.");
        }

        response.sendRedirect("employee_list.jsp");
    }
}