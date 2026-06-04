package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.User;
import utils.RoleConstants;
import utils.SessionKeys;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute(SessionKeys.USER);
            if (user != null) {
                response.sendRedirect(request.getContextPath() + RoleConstants.homePath(user.getRoleName()));
                return;
            }
        }
        
        // Đọc cookie Remember Me để hiển thị sẵn email
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("rememberEmail".equals(c.getName())) {
                    request.setAttribute("rememberEmail", c.getValue());
                    request.setAttribute("rememberMeChecked", true);
                    break;
                }
            }
        }
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user;
        try (UserDAO userDAO = new UserDAO()) {
            user = userDAO.login(email.trim(), password);
        }

        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng, hoặc tài khoản đã bị khóa.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Lưu cookie Remember Me nếu checkbox được chọn
        Cookie cookie = new Cookie("rememberEmail", email.trim());
        if (rememberMe != null) {
            cookie.setMaxAge(30 * 24 * 60 * 60); // Lưu trong 30 ngày
        } else {
            cookie.setMaxAge(0); // Xóa cookie
        }
        response.addCookie(cookie);

        HttpSession session = request.getSession(true);
        session.setAttribute(SessionKeys.USER, user);
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
