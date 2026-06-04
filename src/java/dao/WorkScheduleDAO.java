package dao;

import models.WorkSchedule;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class WorkScheduleDAO extends DBContext {

    // Thêm lịch làm việc mới
    public int insert(WorkSchedule schedule) {
        String sql = """
            INSERT INTO WorkSchedules (UserID, WorkDate, Shift, Status, Note)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, schedule.getUserID());
            st.setDate(2, schedule.getWorkDate());
            st.setString(3, schedule.getShift());
            st.setString(4, schedule.getStatus());
            st.setString(5, schedule.getNote());
            int affected = st.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    // Cập nhật lịch làm việc (chỉ cho phép nếu trạng thái là Pending)
    public boolean update(WorkSchedule schedule) {
        String sql = """
            UPDATE WorkSchedules
            SET WorkDate = ?, Shift = ?, Note = ?, CreatedAt = GETDATE()
            WHERE ScheduleID = ? AND UserID = ? AND Status = 'Pending'
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, schedule.getWorkDate());
            st.setString(2, schedule.getShift());
            st.setString(3, schedule.getNote());
            st.setInt(4, schedule.getScheduleID());
            st.setInt(5, schedule.getUserID());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.update: " + e.getMessage());
        }
        return false;
    }

    // Xóa lịch làm việc (chỉ cho phép nếu trạng thái là Pending)
    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM WorkSchedules WHERE ScheduleID = ? AND UserID = ? AND Status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.delete: " + e.getMessage());
        }
        return false;
    }

    // Tìm lịch theo ID
    public WorkSchedule findById(int id) {
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.ScheduleID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findById: " + e.getMessage());
        }
        return null;
    }

    // Tìm lịch theo nhân viên (sắp xếp ngày giảm dần)
    public List<WorkSchedule> findByUserId(int userId) {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.UserID = ?
            ORDER BY ws.WorkDate DESC, ws.CreatedAt DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findByUserId: " + e.getMessage());
        }
        return list;
    }

    // Tìm các đơn đăng ký lịch đang chờ duyệt (Pending)
    public List<WorkSchedule> findPendingForReview() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.Status = 'Pending'
            ORDER BY ws.WorkDate ASC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findPendingForReview: " + e.getMessage());
        }
        return list;
    }

    // Tìm tất cả lịch đã được duyệt (Approved)
    public List<WorkSchedule> findApproved() {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.Status = 'Approved'
            ORDER BY ws.WorkDate DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findApproved: " + e.getMessage());
        }
        return list;
    }

    // Duyệt lịch làm việc
    public boolean approve(int scheduleId) {
        String sql = "UPDATE WorkSchedules SET Status = 'Approved' WHERE ScheduleID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.approve: " + e.getMessage());
        }
        return false;
    }

    // Từ chối lịch làm việc kèm lý do
    public boolean reject(int scheduleId, String note) {
        String sql = "UPDATE WorkSchedules SET Status = 'Rejected', Note = ? WHERE ScheduleID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, note);
            st.setInt(2, scheduleId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.reject: " + e.getMessage());
        }
        return false;
    }

    // Duyệt tất cả lịch đang chờ trong tuần của bộ phận
    public boolean approveAllPending(int deptId, java.sql.Date start, java.sql.Date end) {
        String sql;
        if (deptId > 0) {
            sql = """
                UPDATE WorkSchedules
                SET Status = 'Approved'
                WHERE Status = 'Pending'
                  AND WorkDate BETWEEN ? AND ?
                  AND UserID IN (SELECT UserID FROM Users WHERE DepartmentID = ?)
                """;
        } else {
            sql = """
                UPDATE WorkSchedules
                SET Status = 'Approved'
                WHERE Status = 'Pending'
                  AND WorkDate BETWEEN ? AND ?
                """;
        }
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            if (deptId > 0) {
                st.setDate(1, start);
                st.setDate(2, end);
                st.setInt(3, deptId);
            } else {
                st.setDate(1, start);
                st.setDate(2, end);
            }
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.approveAllPending: " + e.getMessage());
        }
        return false;
    }

    // Kiểm tra ca làm trùng lặp trong cùng ngày của nhân viên
    public boolean isDuplicate(int userId, Date workDate, String shift) {
        String sql = "SELECT ScheduleID FROM WorkSchedules WHERE UserID = ? AND WorkDate = ? AND Shift = ? AND Status != 'Rejected'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setDate(2, workDate);
            st.setString(3, shift);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.isDuplicate: " + e.getMessage());
        }
        return false;
    }

    // Lấy danh sách lịch trong khoảng ngày
    public List<WorkSchedule> findByWeek(Date startDate, Date endDate) {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.WorkDate BETWEEN ? AND ? AND ws.Status = 'Approved'
            ORDER BY ws.WorkDate ASC, ws.Shift ASC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, startDate);
            st.setDate(2, endDate);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findByWeek: " + e.getMessage());
        }
        return list;
    }

    // Đếm số ca chờ duyệt
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM WorkSchedules WHERE Status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.countPending: " + e.getMessage());
        }
        return 0;
    }

    // Xóa các ca đang chờ duyệt của nhân viên trong khoảng ngày (để đăng ký đè lịch mới)
    public boolean deletePendingByDateRange(int userId, Date start, Date end) {
        String sql = "DELETE FROM WorkSchedules WHERE UserID = ? AND WorkDate BETWEEN ? AND ? AND Status = 'Pending'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setDate(2, start);
            st.setDate(3, end);
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.deletePendingByDateRange: " + e.getMessage());
        }
        return false;
    }

    // Lấy tất cả lịch (bao gồm các ca Approved, Pending, Rejected) của 1 nhân viên trong tuần
    public List<WorkSchedule> findByWeekAndUser(int userId, Date start, Date end) {
        List<WorkSchedule> list = new ArrayList<>();
        String sql = """
            SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
            FROM WorkSchedules ws
            INNER JOIN Users u ON ws.UserID = u.UserID
            WHERE ws.UserID = ? AND ws.WorkDate BETWEEN ? AND ?
            ORDER BY ws.WorkDate ASC, ws.Shift ASC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setDate(2, start);
            st.setDate(3, end);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findByWeekAndUser: " + e.getMessage());
        }
        return list;
    }

    // Lấy toàn bộ ca đăng ký của phòng ban (hoặc tất cả nhân viên) trong khoảng ngày
    public List<WorkSchedule> findByWeekAndDepartment(int deptId, Date start, Date end) {
        List<WorkSchedule> list = new ArrayList<>();
        String sql;
        if (deptId > 0) {
            sql = """
                SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
                FROM WorkSchedules ws
                INNER JOIN Users u ON ws.UserID = u.UserID
                WHERE u.DepartmentID = ? AND u.Status = 1 AND ws.WorkDate BETWEEN ? AND ?
                ORDER BY u.FullName ASC, ws.WorkDate ASC, ws.Shift ASC
                """;
        } else {
            sql = """
                SELECT ws.ScheduleID, ws.UserID, ws.WorkDate, ws.Shift, ws.Status, ws.Note, ws.CreatedAt, u.FullName AS EmployeeName
                FROM WorkSchedules ws
                INNER JOIN Users u ON ws.UserID = u.UserID
                WHERE u.Status = 1 AND ws.WorkDate BETWEEN ? AND ?
                ORDER BY u.FullName ASC, ws.WorkDate ASC, ws.Shift ASC
                """;
        }
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            if (deptId > 0) {
                st.setInt(1, deptId);
                st.setDate(2, start);
                st.setDate(3, end);
            } else {
                st.setDate(1, start);
                st.setDate(2, end);
            }
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in WorkScheduleDAO.findByWeekAndDepartment: " + e.getMessage());
        }
        return list;
    }

    private WorkSchedule mapRow(ResultSet rs) throws SQLException {
        WorkSchedule ws = new WorkSchedule();
        ws.setScheduleID(rs.getInt("ScheduleID"));
        ws.setUserID(rs.getInt("UserID"));
        ws.setEmployeeName(rs.getString("EmployeeName"));
        ws.setWorkDate(rs.getDate("WorkDate"));
        ws.setShift(rs.getString("Shift"));
        ws.setStatus(rs.getString("Status"));
        ws.setNote(rs.getString("Note"));
        ws.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return ws;
    }
}

