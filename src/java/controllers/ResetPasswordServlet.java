package controllers;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        request.setAttribute("email", email);
        request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otpInput = request.getParameter("otp");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        request.setAttribute("email", email);

        if (email == null || email.isBlank() || otpInput == null || otpInput.isBlank()
                || password == null || password.isBlank() || confirmPassword == null || confirmPassword.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả thông tin.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng yêu cầu cấp lại mã xác thực.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        String sessionEmail = (String) session.getAttribute("resetEmail");
        String sessionOTP = (String) session.getAttribute("resetOTP");
        Long sessionExpiry = (Long) session.getAttribute("resetExpiry");

        if (sessionEmail == null || sessionOTP == null || sessionExpiry == null
                || !sessionEmail.equalsIgnoreCase(email.trim())) {
            request.setAttribute("error", "Thông tin yêu cầu đặt lại mật khẩu không hợp lệ.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > sessionExpiry) {
            request.setAttribute("error", "Mã xác thực đã hết hạn hiệu lực (5 phút). Vui lòng yêu cầu lại.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        if (!sessionOTP.equals(otpInput.trim())) {
            request.setAttribute("error", "Mã xác thực OTP không chính xác.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
            return;
        }

        // Thực hiện đặt lại mật khẩu trong cơ sở dữ liệu
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.resetPassword(email.trim(), password);

        if (success) {
            // Xóa thông tin reset trong session để bảo mật
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetOTP");
            session.removeAttribute("resetExpiry");

            response.sendRedirect(request.getContextPath() + "/login?success=" + java.net.URLEncoder.encode("Đặt lại mật khẩu thành công! Hãy đăng nhập với mật khẩu mới.", "UTF-8"));
        } else {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi cập nhật mật khẩu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/reset-password.jsp").forward(request, response);
        }
    }
}
