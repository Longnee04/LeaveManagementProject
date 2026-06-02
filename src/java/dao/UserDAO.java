package dao;

import models.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DBContext {
    
    public User login(String email, String password) {
        String sql = """
            SELECT u.UserID, u.FullName, u.Email, u.Phone, u.Password,
                   u.RoleID, u.DepartmentID, u.Status, r.RoleName
            FROM Users u
            INNER JOIN Roles r ON u.RoleID = r.RoleID
            WHERE u.Email = ? AND u.Password = ? AND u.Status = 1
            """;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
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
                user.setStatus(rs.getBoolean("Status"));
                return user;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }
}
