package controllers.manager;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.LeaveRequest;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "ManagerLeaveListServlet", urlPatterns = {"/manager/leave-requests"})
public class ManagerLeaveListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        int deptId = user.getDepartmentID();

        List<LeaveRequest> pending;
        List<LeaveRequest> reviewed;
        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            pending = dao.findPendingForReview(deptId);
            reviewed = dao.findReviewedByManager(deptId);
        }

        request.setAttribute("pendingRequests", pending);
        request.setAttribute("reviewedRequests", reviewed);
        request.getRequestDispatcher("/manager/leave/list.jsp").forward(request, response);
    }
}
