package dao;

import models.Department;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO extends DBContext {

    // Lấy tất cả phòng ban
    public List<Department> findAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT DepartmentID, DepartmentName, Description FROM Departments ORDER BY DepartmentName";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Department d = new Department();
                d.setDepartmentID(rs.getInt("DepartmentID"));
                d.setDepartmentName(rs.getString("DepartmentName"));
                d.setDescription(rs.getString("Description"));
                list.add(d);
            }
        } catch (SQLException e) {
            System.out.println("Error in DepartmentDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    // Tìm phòng ban theo ID
    public Department findById(int id) {
        String sql = "SELECT DepartmentID, DepartmentName, Description FROM Departments WHERE DepartmentID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    Department d = new Department();
                    d.setDepartmentID(rs.getInt("DepartmentID"));
                    d.setDepartmentName(rs.getString("DepartmentName"));
                    d.setDescription(rs.getString("Description"));
                    return d;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in DepartmentDAO.findById: " + e.getMessage());
        }
        return null;
    }
}
