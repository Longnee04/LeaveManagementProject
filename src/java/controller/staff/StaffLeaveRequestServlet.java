package controller.staff;

import dao.DBConnect;
import dao.LeaveRequestDAO;
import dao.LeaveTypeDAO;
import dao.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.LeaveRequest;
import model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.List;

@WebServlet("/staff/leave-requests")
public class StaffLeaveRequestServlet extends HttpServlet {
    
    private LeaveRequestDAO leaveRequestDAO;
    private LeaveTypeDAO leaveTypeDAO;
    private WarehouseDAO warehouseDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            DBConnect db = new DBConnect();
            Connection connection = db.connection;
            leaveRequestDAO = new LeaveRequestDAO(connection);
            leaveTypeDAO = new LeaveTypeDAO(connection);
            warehouseDAO = new WarehouseDAO(connection);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listLeaveRequests(request, response, user.getUserId());
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response, user.getUserId());
                    break;
                case "detail":
                    showDetail(request, response, user.getUserId());
                    break;
                case "delete":
                    deleteLeaveRequest(request, response, user.getUserId());
                    break;
                default:
                    listLeaveRequests(request, response, user.getUserId());
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createLeaveRequest(request, response, user.getUserId());
            } else if ("update".equals(action)) {
                updateLeaveRequest(request, response, user.getUserId());
            } else if ("submit".equals(action)) {
                submitLeaveRequest(request, response, user.getUserId());
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }
    
    private void listLeaveRequests(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        List<LeaveRequest> leaveRequests = leaveRequestDAO.listByEmployee(employeeId);
        request.setAttribute("leaveRequests", leaveRequests);
        request.getRequestDispatcher("/staff/leave-request-list.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("leaveTypes", leaveTypeDAO.getAllLeaveTypes());
        request.setAttribute("warehouses", warehouseDAO.getAllWarehouses());
        request.getRequestDispatcher("/staff/leave-request-add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        int requestId = Integer.parseInt(request.getParameter("id"));
        LeaveRequest leaveRequest = leaveRequestDAO.findByIdForEmployee(requestId, employeeId);
        
        if (leaveRequest == null || !"draft".equals(leaveRequest.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?error=notfound");
            return;
        }
        
        request.setAttribute("leaveRequest", leaveRequest);
        request.setAttribute("leaveTypes", leaveTypeDAO.getAllLeaveTypes());
        request.setAttribute("warehouses", warehouseDAO.getAllWarehouses());
        request.getRequestDispatcher("/staff/leave-request-edit.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        int requestId = Integer.parseInt(request.getParameter("id"));
        LeaveRequest leaveRequest = leaveRequestDAO.findByIdForEmployee(requestId, employeeId);
        
        if (leaveRequest == null) {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?error=notfound");
            return;
        }
        
        request.setAttribute("leaveRequest", leaveRequest);
        request.getRequestDispatcher("/staff/leave-request-detail.jsp").forward(request, response);
    }
    
    private void createLeaveRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        try {
            LeaveRequest leaveRequest = new LeaveRequest();
            leaveRequest.setEmployeeId(employeeId);
            leaveRequest.setWarehouseId(Integer.parseInt(request.getParameter("warehouseId")));
            leaveRequest.setLeaveTypeId(Integer.parseInt(request.getParameter("leaveTypeId")));
            leaveRequest.setStartDate(Date.valueOf(request.getParameter("startDate")));
            leaveRequest.setEndDate(Date.valueOf(request.getParameter("endDate")));
            leaveRequest.setReason(request.getParameter("reason"));
            
            boolean isSubmit = request.getParameter("submit") != null;
            
            LeaveRequest created = leaveRequestDAO.create(leaveRequest, isSubmit);
            
            if (created != null) {
                String message = isSubmit ? "submitted" : "saved as draft";
                response.sendRedirect(request.getContextPath() + "/staff/leave-requests?success=" + message);
            } else {
                request.setAttribute("error", "Failed to create leave request");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input data");
            showAddForm(request, response);
        }
    }
    
    private void updateLeaveRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        try {
            LeaveRequest leaveRequest = new LeaveRequest();
            leaveRequest.setRequestId(Integer.parseInt(request.getParameter("requestId")));
            leaveRequest.setEmployeeId(employeeId);
            leaveRequest.setWarehouseId(Integer.parseInt(request.getParameter("warehouseId")));
            leaveRequest.setLeaveTypeId(Integer.parseInt(request.getParameter("leaveTypeId")));
            leaveRequest.setStartDate(Date.valueOf(request.getParameter("startDate")));
            leaveRequest.setEndDate(Date.valueOf(request.getParameter("endDate")));
            leaveRequest.setReason(request.getParameter("reason"));
            
            boolean updated = leaveRequestDAO.updateDraft(leaveRequest);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/staff/leave-requests?success=updated");
            } else {
                request.setAttribute("error", "Failed to update leave request");
                showEditForm(request, response, employeeId);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Invalid input data");
            showEditForm(request, response, employeeId);
        }
    }
    
    private void submitLeaveRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        int requestId = Integer.parseInt(request.getParameter("id"));
        boolean submitted = leaveRequestDAO.submitDraft(requestId, employeeId);
        
        if (submitted) {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?success=submitted");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?error=submitfailed");
        }
    }
    
    private void deleteLeaveRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        int requestId = Integer.parseInt(request.getParameter("id"));
        boolean deleted = leaveRequestDAO.deleteDraft(requestId, employeeId);
        
        if (deleted) {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/leave-requests?error=deletefailed");
        }
    }
}
