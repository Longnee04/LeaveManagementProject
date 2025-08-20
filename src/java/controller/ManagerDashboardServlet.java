/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;
import utils.AuthorizationService;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager/manager-dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }

        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra quyền truy cập của người dùng
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Chuyển tiếp yêu cầu đến JSP
        request.getRequestDispatcher("/manager/ManagerDashboard.jsp").forward(request, response);
    }

    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1: return "Admin";
            case 2: return "Warehouse Manager";
            case 3: return "Sales Staff";
            case 4: return "Warehouse Staff";
            case 5: return "Purchase Staff";
            default: return "Unknown";
        }
    }
}
