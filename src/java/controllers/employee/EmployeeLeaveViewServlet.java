package controllers.employee;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import models.LeaveRequest;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "EmployeeLeaveViewServlet", urlPatterns = {"/employee/leave-requests/view"})
public class EmployeeLeaveViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        int requestId = parseInt(request.getParameter("id"), 0);
        if (requestId <= 0) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests");
            return;
        }

        LeaveRequest leaveRequest;
        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            leaveRequest = dao.findByIdAndUser(requestId, user.getUserID());
        }
        
        if (leaveRequest == null) {
            response.sendRedirect(request.getContextPath() + "/employee/leave-requests");
            return;
        }

        request.setAttribute("leaveRequest", leaveRequest);
        request.getRequestDispatcher("/employee/leave/view.jsp").forward(request, response);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
