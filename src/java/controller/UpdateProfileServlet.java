package controller;

import dao.UserDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = UserDAO.getUserByUsername(username);
        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("update_profile.jsp").forward(request, response);
        } else {
            response.sendRedirect("profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String department = request.getParameter("department");
        String gender = request.getParameter("gender");
        String dobString = request.getParameter("dob");

        // Chuyển đổi ngày sinh từ String sang Date
        Date dob = null;
        if (dobString != null && !dobString.isEmpty()) {
            try {
                dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobString);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        // Cập nhật thông tin người dùng
        User user = new User();
        user.setUsername(username);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setDepartment(department);
        user.setGender(gender);
        user.setDob(dob);

        boolean isUpdated = UserDAO.updateUser(user);

        if (isUpdated) {
            request.setAttribute("successMessage", "Profile updated successfully!");
            request.setAttribute("user", user);
        } else {
            request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }

        request.getRequestDispatcher("update_profile.jsp").forward(request, response);
    }
}