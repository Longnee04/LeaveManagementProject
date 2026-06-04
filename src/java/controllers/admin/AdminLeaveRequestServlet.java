package controllers.admin;

import dao.LeaveRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.LeaveRequest;

@WebServlet(name = "AdminLeaveRequestServlet", urlPatterns = {"/admin/leave-requests", "/admin/leave-requests/view"})
public class AdminLeaveRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        
        try (LeaveRequestDAO dao = new LeaveRequestDAO()) {
            if (path.startsWith("/admin/leave-requests/view")) {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    LeaveRequest lr = dao.findById(id);
                    if (lr != null) {
                        request.setAttribute("requestDetails", lr);
                        request.getRequestDispatcher("/admin/leave-requests/view.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/leave-requests?error=" + encode("Không tìm thấy đơn nghỉ phép."));
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/admin/leave-requests?error=" + encode("ID không hợp lệ."));
                }
                return;
            }

            // Mặc định: Hiển thị danh sách tất cả đơn nghỉ phép
            List<LeaveRequest> requests = dao.findAll();
            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/admin/leave-requests/list.jsp").forward(request, response);
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
