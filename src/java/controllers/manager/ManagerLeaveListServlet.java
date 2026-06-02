package controllers.manager;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ManagerLeaveListServlet", urlPatterns = {"/manager/leave-requests"})
public class ManagerLeaveListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LeaveRequestDAO dao = new LeaveRequestDAO();
        request.setAttribute("pendingRequests", dao.findPendingForReview());
        request.setAttribute("reviewedRequests", dao.findReviewedByManager());
        request.getRequestDispatcher("/manager/leave/list.jsp").forward(request, response);
    }
}
