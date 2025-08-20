/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.authentication;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SendMailOK;

@WebServlet(name = "ForgotServlet", urlPatterns = {"/forgotpass"})
public class ForgotServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Khởi tạo DAO
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email không được để trống.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        boolean exists = userDAO.emailExists(email);
        if (!exists) {
            request.setAttribute("error", "Email chưa được đăng ký trong hệ thống.");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        try {
            // 1. Tạo mật khẩu mới ngẫu nhiên
            String newPassword = generateRandomPassword(8);

            // 2. Cập nhật mật khẩu mới cho user (nếu có mã hóa thì nhớ mã hóa)
            userDAO.updatePasswordByEmail(email, newPassword);

            // 3. Gửi mail mật khẩu mới cho user
            String subject = "Your New Password";
            String body = "<p>Your new password is: <b>" + newPassword + "</b></p>"
                    + "<p>Please log in and change your password immediately.</p>";

            SendMailOK.send("smtp.gmail.com", email, "thinhndhe170101@fpt.edu.vn", "vbzn nros scoe bykb", subject, body);

            request.setAttribute("success", "Mật khẩu mới đã được gửi đến email của bạn.");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi gửi email. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }

// Hàm tạo password ngẫu nhiên (ký tự chữ và số)
    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

}
