package controllers.api;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import models.LeaveRequest;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "DashboardApiServlet", urlPatterns = {"/api/dashboard/summary"})
public class DashboardApiServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (DashboardDAO dao = new DashboardDAO();
             PrintWriter out = response.getWriter()) {
            
            int totalEmployees = dao.getTotalEmployees();
            int totalLeaveRequests = dao.getTotalLeaveRequests();
            int pendingLeaveCount = dao.getPendingLeaveCount();
            int todayLeaveCount = dao.getTodayLeaveCount();
            int pendingScheduleCount = dao.getPendingScheduleCount();
            List<LeaveRequest> recentLeaves = dao.getRecentLeaveRequests(5);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"totalEmployees\":").append(totalEmployees).append(",");
            json.append("\"totalLeaveRequests\":").append(totalLeaveRequests).append(",");
            json.append("\"pendingLeaveCount\":").append(pendingLeaveCount).append(",");
            json.append("\"todayLeaveCount\":").append(todayLeaveCount).append(",");
            json.append("\"pendingScheduleCount\":").append(pendingScheduleCount).append(",");
            json.append("\"recentLeaves\":[");
            
            for (int i = 0; i < recentLeaves.size(); i++) {
                LeaveRequest r = recentLeaves.get(i);
                json.append("{");
                json.append("\"requestID\":").append(r.getRequestID()).append(",");
                json.append("\"employeeName\":\"").append(escapeJson(r.getEmployeeName())).append("\",");
                json.append("\"employeeEmail\":\"").append(escapeJson(r.getEmployeeEmail())).append("\",");
                json.append("\"leaveTypeName\":\"").append(escapeJson(r.getLeaveTypeName())).append("\",");
                json.append("\"startDate\":\"").append(r.getStartDate().toString()).append("\",");
                json.append("\"endDate\":\"").append(r.getEndDate().toString()).append("\",");
                json.append("\"status\":\"").append(r.getStatus()).append("\",");
                json.append("\"createdAt\":\"").append(r.getCreatedAt() != null ? r.getCreatedAt().toString() : "").append("\"");
                json.append("}");
                if (i < recentLeaves.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            json.append("}");
            
            out.print(json.toString());
            out.flush();
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
