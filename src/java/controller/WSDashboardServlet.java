 package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthorizationService;

@WebServlet(name = "WSDashboardServlet", urlPatterns = {"/staff/warehouse-staff-dashboard"})
public class WSDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Gọi processRequest để load dữ liệu trước khi forward
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {

            // Lấy warehouseId từ session hoặc user
            Integer warehouseId = null;
            Object userObj = request.getSession().getAttribute("user");
            if (userObj != null) {
                try {
                    java.lang.reflect.Method getWarehouseIdMethod = userObj.getClass().getMethod("getWarehouseId");
                    Object wid = getWarehouseIdMethod.invoke(userObj);
                    if (wid instanceof Integer) {
                        warehouseId = (Integer) wid;
                    }
                } catch (Exception e) {
                    // Không lấy được warehouseId, để null
                }
            }
            if (warehouseId == null) {
                // Nếu không có warehouseId, có thể lấy mặc định hoặc báo lỗi
                warehouseId = 1; // Mặc định warehouseId = 1, bạn có thể thay đổi theo yêu cầu
            }
            
            request.getRequestDispatcher("/staff/WSDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi chi tiết ra console/server log
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/404.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Warehouse Staff Dashboard Controller";
    }
}
