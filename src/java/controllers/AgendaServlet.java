package controllers;

import dao.AgendaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import models.Agenda;
import models.User;
import utils.SessionKeys;

@WebServlet(name = "AgendaServlet", urlPatterns = {"/agenda", "/agenda/add", "/agenda/edit", "/agenda/delete"})
public class AgendaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        AgendaDAO dao = new AgendaDAO();

        if ("/agenda/add".equals(path)) {
            request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
            return;
        }

        if ("/agenda/edit".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Agenda agenda = dao.findById(id);
                if (agenda != null) {
                    // Chỉ người tạo hoặc Admin mới có quyền sửa agenda này
                    if (agenda.getCreatedBy() == user.getUserID() || "Admin".equals(user.getRoleName())) {
                        request.setAttribute("agenda", agenda);
                        request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Bạn không có quyền chỉnh sửa cuộc họp/sự kiện này."));
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Không tìm thấy cuộc họp/sự kiện."));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("ID không hợp lệ."));
            }
            return;
        }

        if ("/agenda/delete".equals(path)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Agenda agenda = dao.findById(id);
                if (agenda != null) {
                    // Chỉ người tạo hoặc Admin mới có quyền xóa
                    if (agenda.getCreatedBy() == user.getUserID() || "Admin".equals(user.getRoleName())) {
                        if (dao.delete(id)) {
                            response.sendRedirect(request.getContextPath() + "/agenda?success=" + encode("Đã xóa cuộc họp/sự kiện thành công."));
                        } else {
                            response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Lỗi xảy ra trong quá trình xóa."));
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Bạn không có quyền xóa cuộc họp/sự kiện này."));
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Không tìm thấy cuộc họp/sự kiện."));
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("ID không hợp lệ."));
            }
            return;
        }

        // Mặc định: Hiển thị danh sách Agenda
        request.setAttribute("agendas", dao.findAll());
        request.getRequestDispatcher("/agenda/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute(SessionKeys.USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        AgendaDAO dao = new AgendaDAO();

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");

        if (title == null || title.isBlank() || startTimeStr == null || startTimeStr.isBlank() || endTimeStr == null || endTimeStr.isBlank()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc.");
            request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
            return;
        }

        Timestamp startTime;
        Timestamp endTime;
        try {
            // Định dạng datetime-local gửi lên: yyyy-MM-dd'T'HH:mm
            startTime = Timestamp.valueOf(startTimeStr.replace("T", " ") + ":00");
            endTime = Timestamp.valueOf(endTimeStr.replace("T", " ") + ":00");
            
            if (endTime.before(startTime)) {
                request.setAttribute("error", "Thời gian kết thúc phải sau thời gian bắt đầu.");
                if ("/agenda/edit".equals(path)) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("agenda", dao.findById(id));
                }
                request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
                return;
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng thời gian không hợp lệ.");
            request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
            return;
        }

        if ("/agenda/add".equals(path)) {
            Agenda agenda = new Agenda();
            agenda.setTitle(title.trim());
            agenda.setDescription(description != null ? description.trim() : null);
            agenda.setStartTime(startTime);
            agenda.setEndTime(endTime);
            agenda.setCreatedBy(user.getUserID());

            if (dao.insert(agenda) > 0) {
                response.sendRedirect(request.getContextPath() + "/agenda?success=" + encode("Đã thêm cuộc họp/sự kiện mới thành công."));
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu cuộc họp/sự kiện.");
                request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
            }
        } else if ("/agenda/edit".equals(path)) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Yêu cầu không hợp lệ."));
                return;
            }

            int id = Integer.parseInt(idStr);
            Agenda current = dao.findById(id);
            if (current == null) {
                response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Không tìm thấy cuộc họp/sự kiện."));
                return;
            }

            // Bảo mật: check quyền sở hữu hoặc Admin
            if (current.getCreatedBy() != user.getUserID() && !"Admin".equals(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/agenda?error=" + encode("Bạn không có quyền thực hiện hành động này."));
                return;
            }

            Agenda agenda = new Agenda();
            agenda.setAgendaID(id);
            agenda.setTitle(title.trim());
            agenda.setDescription(description != null ? description.trim() : null);
            agenda.setStartTime(startTime);
            agenda.setEndTime(endTime);

            if (dao.update(agenda)) {
                response.sendRedirect(request.getContextPath() + "/agenda?success=" + encode("Đã cập nhật cuộc họp/sự kiện thành công."));
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật cuộc họp/sự kiện.");
                request.setAttribute("agenda", current);
                request.getRequestDispatcher("/agenda/form.jsp").forward(request, response);
            }
        }
    }

    private String encode(String msg) {
        return java.net.URLEncoder.encode(msg, java.nio.charset.StandardCharsets.UTF_8);
    }
}
