package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@WebServlet("/createLeaveRequest")
@MultipartConfig
public class CreateLeaveRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        int userID = (int) session.getAttribute("userID");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int leaveTypeID = Integer.parseInt(request.getParameter("leaveTypeID"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reason = request.getParameter("reason");

        String attachmentPath = null;
        if (request.getPart("attachment") != null && request.getPart("attachment").getSize() > 0) {
            String fileName = Paths.get(request.getPart("attachment").getSubmittedFileName()).getFileName().toString();
            String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdir();
            }
            attachmentPath = uploadDir + File.separator + fileName;
            request.getPart("attachment").write(attachmentPath);
        }

        LeaveRequest leaveRequest = new LeaveRequest();
        leaveRequest.setUserID(userID);
        leaveRequest.setLeaveTypeID(leaveTypeID);
        leaveRequest.setStartDate(startDate);
        leaveRequest.setEndDate(endDate);
        leaveRequest.setReason(reason);
        leaveRequest.setAttachment(attachmentPath);

        boolean isCreated = LeaveRequestDAO.createLeaveRequest(leaveRequest);

        if (isCreated) {
            request.setAttribute("successMessage", "Leave request created successfully.");
        } else {
            request.setAttribute("errorMessage", "Failed to create leave request.");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("create_leave_request.jsp").forward(request, response);
    }
}