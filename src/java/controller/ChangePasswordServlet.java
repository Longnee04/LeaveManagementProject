package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra mật khẩu mới và xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match!");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu hiện tại
        boolean isCurrentPasswordValid = UserDAO.validatePassword(username, currentPassword);
        if (!isCurrentPasswordValid) {
            request.setAttribute("errorMessage", "Current password is incorrect!");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Cập nhật mật khẩu mới
        boolean isPasswordChanged = UserDAO.updatePassword(username, newPassword);
        if (isPasswordChanged) {
            request.setAttribute("successMessage", "Password changed successfully!");
        } else {
            request.setAttribute("errorMessage", "Failed to change password. Please try again.");
        }

        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng đến trang hoặc xử lý logic tương ứng
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}
