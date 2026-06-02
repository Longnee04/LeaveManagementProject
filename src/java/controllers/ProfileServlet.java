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
import utils.SessionKeys;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/edit", "/profile/change-password"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());

        if ("/profile/edit".equals(path)) {
            request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
        } else if ("/profile/change-password".equals(path)) {
            request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
        } else {
            // Xem profile
            request.getRequestDispatcher("/profile/view.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        UserDAO userDAO = new UserDAO();

        if ("/profile/edit".equals(path)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            if (fullName == null || fullName.isBlank() || email == null || email.isBlank()) {
                request.setAttribute("error", "Họ tên và Email không được để trống.");
                request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
                return;
            }

            // Kiểm tra trùng email (nếu email thay đổi)
            if (!email.trim().equalsIgnoreCase(user.getEmail())) {
                User checkEmail = userDAO.findByEmail(email.trim());
                if (checkEmail != null) {
                    request.setAttribute("error", "Email này đã được sử dụng bởi một tài khoản khác.");
                    request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
                    return;
                }
            }

            boolean success = userDAO.updateProfile(user.getUserID(), fullName.trim(), email.trim(), phone != null ? phone.trim() : null);
            if (success) {
                // Cập nhật lại thông tin user trong session
                User updatedUser = userDAO.findById(user.getUserID());
                session.setAttribute(SessionKeys.USER, updatedUser);
                response.sendRedirect(request.getContextPath() + "/profile?success=" + encode("Cập nhật thông tin thành công."));
            } else {
                request.setAttribute("error", "Lỗi xảy ra trong quá trình cập nhật. Vui lòng thử lại.");
                request.getRequestDispatcher("/profile/edit.jsp").forward(request, response);
            }

        } else if ("/profile/change-password".equals(path)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || oldPassword.isBlank() || newPassword == null || newPassword.isBlank() || confirmPassword == null || confirmPassword.isBlank()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ các trường mật khẩu.");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp.");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }

            if (newPassword.length() < 6) {
                request.setAttribute("error", "Mật khẩu mới phải chứa ít nhất 6 ký tự.");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
                return;
            }

            boolean success = userDAO.changePassword(user.getUserID(), oldPassword, newPassword);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/profile?success=" + encode("Đổi mật khẩu thành công."));
            } else {
                request.setAttribute("error", "Mật khẩu cũ không chính xác.");
                request.getRequestDispatcher("/profile/change-password.jsp").forward(request, response);
            }
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
