package controllers.employee;

import dao.EmployeeLeaveBalanceDAO;
import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.EmployeeLeaveBalance;
import models.LeaveRequest;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "EmployeeLeaveListServlet", urlPatterns = {"/employee/leave-requests"})
public class EmployeeLeaveListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        
        List<LeaveRequest> requests;
        List<EmployeeLeaveBalance> balances;
        try (LeaveRequestDAO dao = new LeaveRequestDAO();
             EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
            requests = dao.findByUserId(user.getUserID());
            balances = balanceDAO.findByUserId(user.getUserID());
        }
        
        request.setAttribute("requests", requests);
        request.setAttribute("balances", balances);
        request.getRequestDispatcher("/employee/leave/list.jsp").forward(request, response);
    }
}
