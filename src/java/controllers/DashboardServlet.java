package controllers;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        DashboardDAO dao = new DashboardDAO();
        
        // Cung cấp các thuộc tính thống kê cho JSP Dashboard
        request.setAttribute("totalEmployees", dao.getTotalEmployees());
        request.setAttribute("totalLeaveRequests", dao.getTotalLeaveRequests());
        request.setAttribute("pendingLeaveCount", dao.getPendingLeaveCount());
        request.setAttribute("todayLeaveCount", dao.getTodayLeaveCount());
        request.setAttribute("pendingScheduleCount", dao.getPendingScheduleCount());
        request.setAttribute("recentLeaves", dao.getRecentLeaveRequests(5));
        
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
