package dao;

import models.Agenda;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class AgendaDAO extends DBContext {

    // Thêm agenda mới
    public int insert(Agenda agenda) {
        String sql = """
            INSERT INTO Agenda (Title, Description, StartTime, EndTime, CreatedBy)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, agenda.getTitle());
            st.setString(2, agenda.getDescription());
            st.setTimestamp(3, agenda.getStartTime());
            st.setTimestamp(4, agenda.getEndTime());
            st.setInt(5, agenda.getCreatedBy());
            int affected = st.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = st.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.insert: " + e.getMessage());
        }
        return -1;
    }

    // Cập nhật thông tin agenda
    public boolean update(Agenda agenda) {
        String sql = """
            UPDATE Agenda
            SET Title = ?, Description = ?, StartTime = ?, EndTime = ?
            WHERE AgendaID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, agenda.getTitle());
            st.setString(2, agenda.getDescription());
            st.setTimestamp(3, agenda.getStartTime());
            st.setTimestamp(4, agenda.getEndTime());
            st.setInt(5, agenda.getAgendaID());
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.update: " + e.getMessage());
        }
        return false;
    }

    // Xóa agenda
    public boolean delete(int id) {
        String sql = "DELETE FROM Agenda WHERE AgendaID = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.delete: " + e.getMessage());
        }
        return false;
    }

    // Tìm agenda theo ID
    public Agenda findById(int id) {
        String sql = """
            SELECT a.AgendaID, a.Title, a.Description, a.StartTime, a.EndTime, a.CreatedBy, a.CreatedAt, u.FullName AS CreatorName
            FROM Agenda a
            INNER JOIN Users u ON a.CreatedBy = u.UserID
            WHERE a.AgendaID = ?
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.findById: " + e.getMessage());
        }
        return null;
    }

    // Lấy tất cả agenda (Sắp xếp theo thời gian bắt đầu)
    public List<Agenda> findAll() {
        List<Agenda> list = new ArrayList<>();
        String sql = """
            SELECT a.AgendaID, a.Title, a.Description, a.StartTime, a.EndTime, a.CreatedBy, a.CreatedAt, u.FullName AS CreatorName
            FROM Agenda a
            INNER JOIN Users u ON a.CreatedBy = u.UserID
            ORDER BY a.StartTime DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.findAll: " + e.getMessage());
        }
        return list;
    }

    // Lấy agenda trong một khoảng thời gian
    public List<Agenda> findByWeek(Date start, Date end) {
        List<Agenda> list = new ArrayList<>();
        String sql = """
            SELECT a.AgendaID, a.Title, a.Description, a.StartTime, a.EndTime, a.CreatedBy, a.CreatedAt, u.FullName AS CreatorName
            FROM Agenda a
            INNER JOIN Users u ON a.CreatedBy = u.UserID
            WHERE CAST(a.StartTime AS DATE) BETWEEN ? AND ?
            ORDER BY a.StartTime ASC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setDate(1, start);
            st.setDate(2, end);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.findByWeek: " + e.getMessage());
        }
        return list;
    }

    // Tìm các agenda được tạo bởi một nhân viên cụ thể
    public List<Agenda> findByCreator(int userId) {
        List<Agenda> list = new ArrayList<>();
        String sql = """
            SELECT a.AgendaID, a.Title, a.Description, a.StartTime, a.EndTime, a.CreatedBy, a.CreatedAt, u.FullName AS CreatorName
            FROM Agenda a
            INNER JOIN Users u ON a.CreatedBy = u.UserID
            WHERE a.CreatedBy = ?
            ORDER BY a.StartTime DESC
            """;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in AgendaDAO.findByCreator: " + e.getMessage());
        }
        return list;
    }

    private Agenda mapRow(ResultSet rs) throws SQLException {
        Agenda agenda = new Agenda();
        agenda.setAgendaID(rs.getInt("AgendaID"));
        agenda.setTitle(rs.getString("Title"));
        agenda.setDescription(rs.getString("Description"));
        agenda.setStartTime(rs.getTimestamp("StartTime"));
        agenda.setEndTime(rs.getTimestamp("EndTime"));
        agenda.setCreatedBy(rs.getInt("CreatedBy"));
        agenda.setCreatorName(rs.getString("CreatorName"));
        agenda.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return agenda;
    }
}
