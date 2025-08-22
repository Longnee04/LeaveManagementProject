package controller.leavetype;

import dao.DBConnect;
import dao.LeaveTypeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.LeaveType;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/admin/leave-types")
public class LeaveTypeServlet extends HttpServlet {
    
    private LeaveTypeDAO leaveTypeDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        try {
            DBConnect dbConnect = new DBConnect();
            Connection connection = dbConnect.connection;
            if (connection == null) {
                throw new ServletException("Database connection is null");
            }
            leaveTypeDAO = new LeaveTypeDAO(connection);
        } catch (Exception e) {
            throw new ServletException("Failed to initialize LeaveTypeDAO", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listLeaveTypes(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteLeaveType(request, response);
                    break;
                default:
                    listLeaveTypes(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                addLeaveType(request, response);
            } else if ("update".equals(action)) {
                updateLeaveType(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/leave-types");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
    
    private void listLeaveTypes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<LeaveType> leaveTypes = leaveTypeDAO.getAllLeaveTypes();
        request.setAttribute("leaveTypes", leaveTypes);
        request.getRequestDispatcher("/admin/leave-type-list.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/leave-type-add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=notfound");
            return;
        }
        int leaveTypeId = Integer.parseInt(idParam);
        LeaveType leaveType = leaveTypeDAO.getLeaveTypeById(leaveTypeId);
        
        if (leaveType != null) {
            request.setAttribute("leaveType", leaveType);
            request.getRequestDispatcher("/admin/leave-type-edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=notfound");
        }
    }
    
    private void addLeaveType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String leaveTypeName = request.getParameter("leaveTypeName");
        String description = request.getParameter("description");
        boolean isActive = request.getParameter("isActive") != null;
        
        if (leaveTypeName == null || leaveTypeName.trim().isEmpty()) {
            request.setAttribute("error", "Leave type name is required!");
            request.getRequestDispatcher("/admin/leave-type-add.jsp").forward(request, response);
            return;
        }
        
        if (leaveTypeDAO.isLeaveTypeNameExists(leaveTypeName)) {
            request.setAttribute("error", "Leave type name already exists!");
            request.getRequestDispatcher("/admin/leave-type-add.jsp").forward(request, response);
            return;
        }
        
        LeaveType leaveType = new LeaveType(leaveTypeName, description, isActive);
        
        if (leaveTypeDAO.createLeaveType(leaveType)) {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=added");
        } else {
            request.setAttribute("error", "Failed to add leave type!");
            request.getRequestDispatcher("/admin/leave-type-add.jsp").forward(request, response);
        }
    }
    
    private void updateLeaveType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int leaveTypeId = Integer.parseInt(request.getParameter("leaveTypeId"));
        String leaveTypeName = request.getParameter("leaveTypeName");
        String description = request.getParameter("description");
        boolean isActive = request.getParameter("isActive") != null;
        
        LeaveType existingLeaveType = leaveTypeDAO.getLeaveTypeById(leaveTypeId);
        if (existingLeaveType == null) {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=notfound");
            return;
        }
        
        if (leaveTypeName == null || leaveTypeName.trim().isEmpty()) {
            request.setAttribute("error", "Leave type name is required!");
            request.setAttribute("leaveType", existingLeaveType);
            request.getRequestDispatcher("/admin/leave-type-edit.jsp").forward(request, response);
            return;
        }
        
        if (!existingLeaveType.getLeaveTypeName().equals(leaveTypeName) && 
            leaveTypeDAO.isLeaveTypeNameExists(leaveTypeName)) {
            request.setAttribute("error", "Leave type name already exists!");
            request.setAttribute("leaveType", existingLeaveType);
            request.getRequestDispatcher("/admin/leave-type-edit.jsp").forward(request, response);
            return;
        }
        
        LeaveType leaveType = new LeaveType(leaveTypeId, leaveTypeName, description, isActive);
        
        if (leaveTypeDAO.updateLeaveType(leaveType)) {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=updated");
        } else {
            request.setAttribute("error", "Failed to update leave type!");
            request.setAttribute("leaveType", leaveType);
            request.getRequestDispatcher("/admin/leave-type-edit.jsp").forward(request, response);
        }
    }
    
    private void deleteLeaveType(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int leaveTypeId = Integer.parseInt(request.getParameter("id"));
        
        if (leaveTypeDAO.deleteLeaveType(leaveTypeId)) {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/leave-types?error=deletefailed");
        }
    }
}