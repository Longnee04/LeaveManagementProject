package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/pendingRequests")
public class PendingRequestsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"Manager".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int managerID = (Integer) session.getAttribute("userID");
        List<LeaveRequest> pendingRequests = LeaveRequestDAO.getPendingRequestsByManager(managerID);

        request.setAttribute("pendingRequests", pendingRequests);
        request.getRequestDispatcher("pending_requests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"Manager".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int managerID = (Integer) session.getAttribute("userID");
        int requestID = Integer.parseInt(request.getParameter("requestID"));
        String action = request.getParameter("action");

        String status = "Rejected";
        if ("approve".equals(action)) {
            status = "Approved";
        }

        boolean isUpdated = LeaveRequestDAO.updateLeaveRequestStatus(requestID, status, managerID);

        if (isUpdated) {
            session.setAttribute("successMessage", "Leave request has been " + status.toLowerCase() + ".");
        } else {
            session.setAttribute("errorMessage", "Failed to update leave request status.");
        }

        response.sendRedirect("pendingRequests");
    }
}