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
        int userID = (int) session.getAttribute("userID"); // Lấy UserID từ session

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy dữ liệu từ form
        int leaveTypeID = Integer.parseInt(request.getParameter("leaveTypeID"));
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reason = request.getParameter("reason");

        // Xử lý file đính kèm
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

        // Tạo đối tượng LeaveRequest
        LeaveRequest leaveRequest = new LeaveRequest();
        leaveRequest.setUserID(userID);
        leaveRequest.setLeaveTypeID(leaveTypeID);
        leaveRequest.setStartDate(startDate);
        leaveRequest.setEndDate(endDate);
        leaveRequest.setReason(reason);
        leaveRequest.setAttachment(attachmentPath);

        // Lưu vào cơ sở dữ liệu
        boolean isCreated = LeaveRequestDAO.createLeaveRequest(leaveRequest);

        if (isCreated) {
            response.sendRedirect("employee_dashboard.jsp?success=Leave request created successfully!");
        } else {
            response.sendRedirect("create_leave_request.jsp?error=Failed to create leave request. Please try again.");
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng đến trang hoặc xử lý logic tương ứng
        request.getRequestDispatcher("create_leave_request.jsp").forward(request, response);
    }
}