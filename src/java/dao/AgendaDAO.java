package dao;

import db.DBConnection;
import model.Agenda;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AgendaDAO {

    public static List<Agenda> getAgendaByManager(int managerID, Date startDate, Date endDate, int offset, int limit) {
        List<Agenda> agendaList = new ArrayList<>();
        String sql = "SELECT a.AgendaID, a.UserID, u.Username, a.WorkDate, a.Status " +
                     "FROM Agenda a " +
                     "JOIN Users u ON a.UserID = u.UserID " +
                     "JOIN Department d ON u.DepartmentID = d.DepartmentID " +
                     "WHERE d.ManagerID = ? AND a.WorkDate BETWEEN ? AND ? " +
                     "ORDER BY a.WorkDate ASC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerID);
            ps.setDate(2, new java.sql.Date(startDate.getTime()));
            ps.setDate(3, new java.sql.Date(endDate.getTime()));
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Agenda agenda = new Agenda();
                    agenda.setAgendaID(rs.getInt("AgendaID"));
                    agenda.setUserID(rs.getInt("UserID"));
                    agenda.setUsername(rs.getString("Username"));
                    agenda.setWorkDate(rs.getDate("WorkDate"));
                    agenda.setStatus(rs.getString("Status"));
                    agendaList.add(agenda);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return agendaList;
    }

    public static int getAgendaCountByManager(int managerID, Date startDate, Date endDate) {
        String sql = "SELECT COUNT(*) AS TotalCount " +
                     "FROM Agenda a " +
                     "JOIN Users u ON a.UserID = u.UserID " +
                     "JOIN Department d ON u.DepartmentID = d.DepartmentID " +
                     "WHERE d.ManagerID = ? AND a.WorkDate BETWEEN ? AND ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, managerID);
            ps.setDate(2, new java.sql.Date(startDate.getTime()));
            ps.setDate(3, new java.sql.Date(endDate.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("TotalCount");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }
}