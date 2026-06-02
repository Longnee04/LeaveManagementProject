package dao;

import models.Attendance;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO extends DBContext {

    // Thực hiện Check-In
    public boolean checkIn(int userId) {
        if (hasCheckedInToday(userId)) {
            return false; // Đã check-in rồi, không check-in nữa
        }
        String sql = """
            INSERT INTO Attendance (UserID, CheckIn, AttendanceDate)
            VALUES (?, GETDATE(), CAST(GETDATE() AS DATE))
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.checkIn: " + e.getMessage());
        }
        return false;
    }

    // Thực hiện Check-Out và tự động tính giờ làm việc
    public boolean checkOut(int userId) {
        String sql = """
            UPDATE Attendance
            SET CheckOut = GETDATE(),
                WorkHours = ROUND(CAST(DATEDIFF(SECOND, CheckIn, GETDATE()) AS FLOAT) / 3600.0, 2)
            WHERE UserID = ? AND AttendanceDate = CAST(GETDATE() AS DATE) AND CheckOut IS NULL
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.checkOut: " + e.getMessage());
        }
        return false;
    }

    // Tìm record điểm danh ngày hôm nay của nhân viên
    public Attendance findTodayByUser(int userId) {
        String sql = """
            SELECT a.AttendanceID, a.UserID, a.CheckIn, a.CheckOut, a.WorkHours, a.AttendanceDate, u.FullName AS EmployeeName
            FROM Attendance a
            INNER JOIN Users u ON a.UserID = u.UserID
            WHERE a.UserID = ? AND a.AttendanceDate = CAST(GETDATE() AS DATE)
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.findTodayByUser: " + e.getMessage());
        }
        return null;
    }

    // Kiểm tra xem hôm nay nhân viên đã check-in chưa
    public boolean hasCheckedInToday(int userId) {
        String sql = "SELECT AttendanceID FROM Attendance WHERE UserID = ? AND AttendanceDate = CAST(GETDATE() AS DATE)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.hasCheckedInToday: " + e.getMessage());
        }
        return false;
    }

    // Lấy lịch sử điểm danh của một nhân viên
    public List<Attendance> findByUserId(int userId) {
        List<Attendance> list = new ArrayList<>();
        String sql = """
            SELECT a.AttendanceID, a.UserID, a.CheckIn, a.CheckOut, a.WorkHours, a.AttendanceDate, u.FullName AS EmployeeName
            FROM Attendance a
            INNER JOIN Users u ON a.UserID = u.UserID
            WHERE a.UserID = ?
            ORDER BY a.AttendanceDate DESC, a.CheckIn DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.findByUserId: " + e.getMessage());
        }
        return list;
    }

    // Điểm danh của nhân viên trong khoảng ngày
    public List<Attendance> findByDateRange(int userId, Date startDate, Date endDate) {
        List<Attendance> list = new ArrayList<>();
        String sql = """
            SELECT a.AttendanceID, a.UserID, a.CheckIn, a.CheckOut, a.WorkHours, a.AttendanceDate, u.FullName AS EmployeeName
            FROM Attendance a
            INNER JOIN Users u ON a.UserID = u.UserID
            WHERE a.UserID = ? AND a.AttendanceDate BETWEEN ? AND ?
            ORDER BY a.AttendanceDate DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setDate(2, startDate);
            st.setDate(3, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AttendanceDAO.findByDateRange: " + e.getMessage());
        }
        return list;
    }

    private Attendance mapRow(ResultSet rs) throws SQLException {
        Attendance att = new Attendance();
        att.setAttendanceID(rs.getInt("AttendanceID"));
        att.setUserID(rs.getInt("UserID"));
        att.setEmployeeName(rs.getString("EmployeeName"));
        att.setCheckIn(rs.getTimestamp("CheckIn"));
        att.setCheckOut(rs.getTimestamp("CheckOut"));
        double wh = rs.getDouble("WorkHours");
        if (!rs.wasNull()) {
            att.setWorkHours(wh);
        }
        att.setAttendanceDate(rs.getDate("AttendanceDate"));
        return att;
    }
}
