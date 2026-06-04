package dao;

import models.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {
    
    // Đăng nhập hệ thống, lấy cả RoleName và DepartmentName
    public User login(String email, String password) {
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, u.CreatedAt, r.RoleName, d.DepartmentName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            WHERE u.Email = ? AND u.Password = ? AND u.Status = 1
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, utils.PasswordHash.sha256(password));
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in login: " + e.getMessage());
        }
        return null;
    }

    // Tìm tất cả nhân viên (không bị xóa mềm hoặc hiển thị tất cả tùy chọn)
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, u.CreatedAt, r.RoleName, d.DepartmentName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            ORDER BY u.UserID DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in findAll: " + e.getMessage());
        }
        return list;
    }

    // Tìm nhân viên theo ID
    public User findById(int id) {
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, u.CreatedAt, r.RoleName, d.DepartmentName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            WHERE u.UserID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in findById: " + e.getMessage());
        }
        return null;
    }

    // Tìm nhân viên theo Email
    public User findByEmail(String email) {
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, u.CreatedAt, r.RoleName, d.DepartmentName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            WHERE u.Email = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in findByEmail: " + e.getMessage());
        }
        return null;
    }

    // Thêm nhân viên mới
    public int insert(User user) {
        String sql = """
            INSERT INTO Users (FullName, Email, Phone, Password, RoleID, DepartmentID, Status)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone());
            st.setString(4, utils.PasswordHash.sha256(user.getPassword()));
            st.setInt(5, user.getRoleID());
            if (user.getDepartmentID() > 0) {
                st.setInt(6, user.getDepartmentID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setBoolean(7, user.isStatus());
            
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int userId = generatedKeys.getInt(1);
                        // Tự động khởi tạo số dư nghỉ phép của nhân viên mới
                        try (EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
                            balanceDAO.initBalancesForUser(userId);
                        }
                        return userId;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in insert: " + e.getMessage());
        }
        return -1;
    }

    // Cập nhật thông tin nhân viên (cho Admin)
    public boolean update(User user) {
        String sql = """
            UPDATE Users 
            SET FullName = ?, Email = ?, Phone = ?, RoleID = ?, DepartmentID = ?, Status = ?
            WHERE UserID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPhone());
            st.setInt(4, user.getRoleID());
            if (user.getDepartmentID() > 0) {
                st.setInt(5, user.getDepartmentID());
            } else {
                st.setNull(5, java.sql.Types.INTEGER);
            }
            st.setBoolean(6, user.isStatus());
            st.setInt(7, user.getUserID());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in update: " + e.getMessage());
        }
        return false;
    }

    // Xóa mềm nhân viên (Status = 0)
    public boolean delete(int id) {
        String sql = "UPDATE Users SET Status = 0 WHERE UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in delete: " + e.getMessage());
        }
        return false;
    }

    // Cập nhật Profile cá nhân (không đổi role/status/password)
    public boolean updateProfile(int userId, String fullName, String email, String phone) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ? WHERE UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, fullName);
            st.setString(2, email);
            st.setString(3, phone);
            st.setInt(4, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in updateProfile: " + e.getMessage());
        }
        return false;
    }

    // Đổi mật khẩu nhân viên
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        // Kiểm tra xem mật khẩu cũ có đúng không
        String checkSql = "SELECT UserID FROM Users WHERE UserID = ? AND Password = ?";
        try (PreparedStatement st = connection.prepareStatement(checkSql)) {
            st.setInt(1, userId);
            st.setString(2, utils.PasswordHash.sha256(oldPassword));
            try (ResultSet rs = st.executeQuery()) {
                if (!rs.next()) {
                    return false; // Mật khẩu cũ không khớp
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in changePassword check: " + e.getMessage());
            return false;
        }

        // Cập nhật mật khẩu mới
        String updateSql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(updateSql)) {
            st.setString(1, utils.PasswordHash.sha256(newPassword));
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in changePassword update: " + e.getMessage());
        }
        return false;
    }

    // Đặt lại mật khẩu mới qua email
    public boolean resetPassword(String email, String newPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE Email = ? AND Status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, utils.PasswordHash.sha256(newPassword));
            st.setString(2, email);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in resetPassword: " + e.getMessage());
        }
        return false;
    }

    // Tìm kiếm nhân viên theo tên
    public List<User> searchByName(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, u.CreatedAt, r.RoleName, d.DepartmentName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            WHERE u.FullName LIKE ?
            ORDER BY u.UserID DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in searchByName: " + e.getMessage());
        }
        return list;
    }

    // Đếm số lượng nhân viên hoạt động
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Users WHERE Status = 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in countAll: " + e.getMessage());
        }
        return 0;
    }

    // Hàm ánh xạ ResultSet thành đối tượng User
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserID(rs.getInt("UserID"));
        user.setFullName(rs.getString("FullName"));
        user.setEmail(rs.getString("Email"));
        user.setPhone(rs.getString("Phone"));
        user.setPassword(rs.getString("Password"));
        user.setRoleID(rs.getInt("RoleID"));
        user.setRoleName(rs.getString("RoleName"));
        int deptId = rs.getInt("DepartmentID");
        if (!rs.wasNull()) {
            user.setDepartmentID(deptId);
        }
        user.setDepartmentName(rs.getString("DepartmentName"));
        user.setStatus(rs.getBoolean("Status"));
        user.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return user;
    }
}
