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

@WebServlet(name = "EmployeeLeaveListServlet", urlPatterns = {"/employee/leave-requests"})
public class EmployeeLeaveListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        LeaveRequestDAO dao = new LeaveRequestDAO();
        request.setAttribute("requests", dao.findByUserId(user.getUserID()));
        request.getRequestDispatcher("/employee/leave/list.jsp").forward(request, response);
    }
}
