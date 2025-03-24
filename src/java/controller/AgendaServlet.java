package controller;

import dao.AgendaDAO;
import model.Agenda;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@WebServlet("/agenda")
public class AgendaServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"Manager".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int managerID = (Integer) session.getAttribute("userID");

        // Get the current week
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_WEEK, calendar.getFirstDayOfWeek());
        Date startDate = calendar.getTime();
        calendar.add(Calendar.DAY_OF_WEEK, 6);
        Date endDate = calendar.getTime();

        // Parse the week parameter if provided
        String weekParam = request.getParameter("week");
        if (weekParam != null) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                startDate = sdf.parse(weekParam);
                calendar.setTime(startDate);
                calendar.add(Calendar.DAY_OF_WEEK, 6);
                endDate = calendar.getTime();
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        // Get the current page
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            page = Integer.parseInt(pageParam);
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<Agenda> agendaList = AgendaDAO.getAgendaByManager(managerID, startDate, endDate, offset, PAGE_SIZE);
        int totalCount = AgendaDAO.getAgendaCountByManager(managerID, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        request.setAttribute("agendaList", agendaList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.getRequestDispatcher("agenda.jsp").forward(request, response);
    }
}