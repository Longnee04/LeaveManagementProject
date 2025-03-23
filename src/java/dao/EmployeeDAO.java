package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import db.DBConnection;

public class EmployeeDAO {
    public static int getTotalEmployeesByManager(int managerID) {
        int totalEmployees = 0;
        String sql = "SELECT COUNT(*) AS Total FROM Employees WHERE ManagerID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalEmployees = rs.getInt("Total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return totalEmployees;
    }
}