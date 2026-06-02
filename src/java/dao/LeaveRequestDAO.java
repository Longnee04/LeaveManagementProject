package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import models.LeaveRequest;
import utils.LeaveStatus;

public class LeaveRequestDAO extends DBContext {

    private static final String SELECT_COLUMNS = """
            lr.RequestID, lr.UserID, lr.LeaveTypeID, lr.StartDate, lr.EndDate,
            lr.Reason, lr.Status, lr.ManagerComment, lr.CreatedAt, lr.UpdatedAt,
            u.FullName AS EmployeeName, u.Email AS EmployeeEmail,
            u.DepartmentID, d.DepartmentName,
            lt.LeaveTypeName
            """;

    private static final String FROM_JOIN = """
            FROM LeaveRequests lr
            INNER JOIN Users u ON lr.UserID = u.UserID
            INNER JOIN LeaveTypes lt ON lr.LeaveTypeID = lt.LeaveTypeID
            LEFT JOIN Departments d ON u.DepartmentID = d.DepartmentID
            """;

    public int insert(LeaveRequest request) {
        String sql = """
            INSERT INTO LeaveRequests (UserID, LeaveTypeID, StartDate, EndDate, Reason, Status)
            VALUES (?, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, request.getUserID());
            st.setInt(2, request.getLeaveTypeID());
            st.setDate(3, request.getStartDate());
            st.setDate(4, request.getEndDate());
            st.setString(5, request.getReason());
            st.setString(6, request.getStatus());
            int affected = st.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return -1;
    }

    public boolean updateDraft(LeaveRequest request) {
        String sql = """
            UPDATE LeaveRequests
            SET LeaveTypeID = ?, StartDate = ?, EndDate = ?, Reason = ?, Status = ?, UpdatedAt = GETDATE()
            WHERE RequestID = ? AND UserID = ? AND Status = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, request.getLeaveTypeID());
            st.setDate(2, request.getStartDate());
            st.setDate(3, request.getEndDate());
            st.setString(4, request.getReason());
            st.setString(5, request.getStatus());
            st.setInt(6, request.getRequestID());
            st.setInt(7, request.getUserID());
            st.setString(8, LeaveStatus.DRAFT);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean submitDraft(int requestId, int userId) {
        String sql = """
            UPDATE LeaveRequests
            SET Status = ?, UpdatedAt = GETDATE()
            WHERE RequestID = ? AND UserID = ? AND Status = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, LeaveStatus.PENDING);
            st.setInt(2, requestId);
            st.setInt(3, userId);
            st.setString(4, LeaveStatus.DRAFT);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean deleteDraft(int requestId, int userId) {
        String sql = "DELETE FROM LeaveRequests WHERE RequestID = ? AND UserID = ? AND Status = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, requestId);
            st.setInt(2, userId);
            st.setString(3, LeaveStatus.DRAFT);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean review(int requestId, String newStatus, String managerComment) {
        String sql = """
            UPDATE LeaveRequests
            SET Status = ?, ManagerComment = ?, UpdatedAt = GETDATE()
            WHERE RequestID = ? AND Status = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newStatus);
            st.setString(2, managerComment);
            st.setInt(3, requestId);
            st.setString(4, LeaveStatus.PENDING);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public LeaveRequest findById(int requestId) {
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN + " WHERE lr.RequestID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, requestId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public LeaveRequest findByIdAndUser(int requestId, int userId) {
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN
                + " WHERE lr.RequestID = ? AND lr.UserID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, requestId);
            st.setInt(2, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public List<LeaveRequest> findByUserId(int userId) {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN
                + " WHERE lr.UserID = ? ORDER BY lr.CreatedAt DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<LeaveRequest> findPendingForReview() {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN
                + " WHERE lr.Status = ? ORDER BY lr.CreatedAt ASC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, LeaveStatus.PENDING);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<LeaveRequest> findReviewedByManager() {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN
                + " WHERE lr.Status IN (?, ?) ORDER BY lr.UpdatedAt DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, LeaveStatus.APPROVED);
            st.setString(2, LeaveStatus.REJECTED);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    private LeaveRequest mapRow(ResultSet rs) throws SQLException {
        LeaveRequest req = new LeaveRequest();
        req.setRequestID(rs.getInt("RequestID"));
        req.setUserID(rs.getInt("UserID"));
        req.setLeaveTypeID(rs.getInt("LeaveTypeID"));
        req.setStartDate(rs.getDate("StartDate"));
        req.setEndDate(rs.getDate("EndDate"));
        req.setReason(rs.getString("Reason"));
        req.setStatus(rs.getString("Status"));
        req.setManagerComment(rs.getString("ManagerComment"));
        req.setCreatedAt(rs.getTimestamp("CreatedAt"));
        req.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        req.setEmployeeName(rs.getString("EmployeeName"));
        req.setEmployeeEmail(rs.getString("EmployeeEmail"));
        req.setLeaveTypeName(rs.getString("LeaveTypeName"));
        int deptId = rs.getInt("DepartmentID");
        if (!rs.wasNull()) {
            req.setDepartmentID(deptId);
            req.setDepartmentName(rs.getString("DepartmentName"));
        }
        return req;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM LeaveRequests";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM LeaveRequests WHERE Status = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public int countTodayLeaves() {
        String sql = "SELECT COUNT(*) FROM LeaveRequests WHERE CAST(GETDATE() AS DATE) BETWEEN StartDate AND EndDate AND Status = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "Approved");
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return 0;
    }

    public List<LeaveRequest> findAll() {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT " + SELECT_COLUMNS + " " + FROM_JOIN + " ORDER BY lr.CreatedAt DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}

