package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.User;
import utils.EmailUtil;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email.trim());

        if (user == null || !user.isStatus()) {
            request.setAttribute("error", "Email không tồn tại trên hệ thống hoặc tài khoản đã bị khóa.");
            request.getRequestDispatcher("/forgot-password.jsp").forward(request, response);
            return;
        }

        // Tạo mã OTP 6 số ngẫu nhiên
        String otp = String.valueOf((int) (Math.random() * 900000) + 100000);
        long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000); // 5 phút hiệu lực

        // Lưu vào Session để xác thực sau
        HttpSession session = request.getSession(true);
        session.setAttribute("resetEmail", email.trim());
        session.setAttribute("resetOTP", otp);
        session.setAttribute("resetExpiry", expiryTime);

        // Gửi OTP
        EmailUtil.sendResetCode(email.trim(), otp);

        // Redirect sang trang nhập OTP và mật khẩu mới
        response.sendRedirect(request.getContextPath() + "/reset-password?email=" + java.net.URLEncoder.encode(email.trim(), "UTF-8") + "&success=" + java.net.URLEncoder.encode("Mã xác thực đã được gửi! Vui lòng kiểm tra email của bạn (hoặc file email_sent.txt ở thư mục dự án).", "UTF-8"));
    }
}
