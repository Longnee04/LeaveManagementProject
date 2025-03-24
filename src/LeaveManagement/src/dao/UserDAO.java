package dao;

import db.DBConnection;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public static String authenticateUser(String username, String password) {
        String role = null;
        String query = "SELECT Role FROM Users WHERE Username = ? AND Password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    role = rs.getString("Role");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }
    
    public static User getUserByUsername(String username) {
        User user = null;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM Users WHERE Username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUserID(rs.getInt("UserID"));
                user.setUsername(rs.getString("Username"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setRole(rs.getString("Role"));
                user.setDepartment(rs.getString("Department"));
                user.setPhone(rs.getString("Phone"));
                user.setGender(rs.getString("Gender"));
                user.setDob(rs.getDate("DOB"));
                user.setAddress(rs.getString("Address"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public static boolean updateUser(User user) {
        boolean isUpdated = false;
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Address = ?, Department = ?, Gender = ?, DOB = ? WHERE Username = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getDepartment());
            ps.setString(6, user.getGender());
            if (user.getDob() != null) {
                ps.setDate(7, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }
            ps.setString(8, user.getUsername());

            int rowsAffected = ps.executeUpdate();
            isUpdated = rowsAffected > 0;

            System.out.println("Update User: " + (isUpdated ? "Success" : "Failed"));

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return isUpdated;
    }

    public static boolean validatePassword(String username, String currentPassword) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, currentPassword);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE Username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, username);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}