package dao;

import db.DBConnection;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // 1. Xác thực người dùng
    public static String authenticateUser(String username, String password) {
        String role = null;
        String query = "SELECT Role FROM Users WHERE Username = ? AND Password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
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
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public static boolean updateUser(User user) {
        boolean isUpdated = false;
        String sql = "UPDATE Users SET fullName = ?, email = ?, phone = ?, address = ?, department = ?, gender = ?, dob = ? WHERE username = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());
            ps.setString(5, user.getDepartment());
            ps.setString(6, user.getGender());
            if (user.getDob() != null) {
                ps.setDate(7, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(7, java.sql.Types.DATE);
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
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, currentPassword);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu tìm thấy bản ghi
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(String username, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE username = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, username);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu cập nhật thành công
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean addUser(User user) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Role, Department, Phone, Gender, DOB, Address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getDepartment());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getGender());
            if (user.getDob() != null) {
                ps.setDate(9, new java.sql.Date(user.getDob().getTime()));
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }
            ps.setString(10, user.getAddress());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

        
    public static boolean deleteUser(int userID) {
        String sql = "DELETE FROM Users WHERE UserID = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
