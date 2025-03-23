package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.UserDAO;
import model.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role"); // Lấy role từ input ẩn

        // Xác thực người dùng
        String authenticatedRole = UserDAO.authenticateUser(username, password);

        if (authenticatedRole == null) {
            // Sai tài khoản hoặc mật khẩu
            request.setAttribute("errorMessage", "Invalid username or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if (!authenticatedRole.equalsIgnoreCase(role)) {
            // Sai vai trò
            request.setAttribute("errorMessage", "Access denied. Incorrect role!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Lấy thông tin người dùng từ cơ sở dữ liệu
            User user = UserDAO.getUserByUsername(username);

            if (user != null) {
                // Đăng nhập thành công, lưu thông tin vào session
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getUsername());
                session.setAttribute("role", user.getRole());
                session.setAttribute("userID", user.getUserID()); // Lưu userID vào session

                // Chuyển hướng đến dashboard tương ứng
                switch (authenticatedRole.toLowerCase()) {
                    case "admin":
                        response.sendRedirect("admin_dashboard.jsp");
                        break;
                    case "manager":
                        response.sendRedirect("manager_dashboard.jsp");
                        break;
                    case "employee":
                        response.sendRedirect("employee_dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect("login.jsp");
                }
            } else {
                // Nếu không tìm thấy người dùng
                request.setAttribute("errorMessage", "User not found!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}