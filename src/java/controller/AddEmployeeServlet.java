package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/addEmployee")
public class AddEmployeeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        if (username == null || !"Manager".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String employeeUsername = request.getParameter("username");
        String employeePassword = request.getParameter("password");
        String employeeFullName = request.getParameter("fullName");
        String employeeEmail = request.getParameter("email");
        String employeeDepartment = request.getParameter("department");
        String employeePhone = request.getParameter("phone");
        String employeeGender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String employeeAddress = request.getParameter("address");

        Date dob = null;
        try {
            dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
        } catch (Exception e) {
            e.printStackTrace();
        }

        User employee = new User();
        employee.setUsername(employeeUsername);
        employee.setPassword(employeePassword);
        employee.setFullName(employeeFullName);
        employee.setEmail(employeeEmail);
        employee.setRole("Employee");
        employee.setDepartment(employeeDepartment);
        employee.setPhone(employeePhone);
        employee.setGender(employeeGender);
        employee.setDob(dob);
        employee.setAddress(employeeAddress);

        boolean isCreated = UserDAO.addUser(employee);

        if (isCreated) {
            session.setAttribute("successMessage", "Employee added successfully.");
        } else {
            session.setAttribute("errorMessage", "Failed to add employee.");
        }

        response.sendRedirect("add_employee.jsp");
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("add_employee.jsp").forward(request, response);
    }
}