package controller;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.LeaveRequest;
import java.io.IOException;
import java.util.List;

@WebServlet("/PendingRequestsServlet")
public class PendingRequestsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String department = (String) session.getAttribute("department"); // Lấy department từ session

        if (department == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy danh sách các đơn chờ
        List<LeaveRequest> pendingRequests = LeaveRequestDAO.getPendingRequestsByDepartment(department);

        // Gửi danh sách đến JSP
        request.setAttribute("pendingRequests", pendingRequests);
        request.getRequestDispatcher("manager_pending_requests.jsp").forward(request, response);
    }
}