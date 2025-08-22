package dao;

import model.LeaveRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDAO {
	private final Connection connection;

	public LeaveRequestDAO(Connection connection) {
		this.connection = connection;
	}

	private String formatCode(int seq) {
		String num = String.valueOf(seq);
		String padded = ("000000" + num);
		padded = padded.substring(padded.length() - 6);
		return "LR" + padded;
	}

	private int getNextSequenceForCode(Connection conn) throws SQLException {
		String sql = "SELECT ISNULL(MAX(CAST(SUBSTRING(request_code, 3, 6) AS INT)), 0) AS max_seq FROM Leave_Request WITH (UPDLOCK, HOLDLOCK)";
		try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
		}
		return 1;
	}

	public LeaveRequest create(LeaveRequest request, boolean submit) {
		String insertSql = "INSERT INTO Leave_Request (request_code, employee_id, warehouse_id, leave_type_id, start_date, end_date, reason, created_at, updated_at, status) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?); SELECT SCOPE_IDENTITY();";

		boolean originalAC = true;
		try {
			originalAC = connection.getAutoCommit();
			connection.setAutoCommit(false);
			connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

			int nextSeq = getNextSequenceForCode(connection);
			String code = formatCode(nextSeq);

			try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
				ps.setString(1, code);
				ps.setInt(2, request.getEmployeeId());
				ps.setInt(3, request.getWarehouseId());
				ps.setInt(4, request.getLeaveTypeId());
				ps.setDate(5, request.getStartDate());
				ps.setDate(6, request.getEndDate());
				ps.setNString(7, request.getReason());
				ps.setString(8, submit ? "pending" : "draft");

				boolean hasResult = ps.execute();
				Integer newId = null;
				if (hasResult) {
					try (ResultSet rs = ps.getResultSet()) {
						if (rs.next()) newId = rs.getInt(1);
					}
				}
				if (newId == null) {
					try (ResultSet rs = ps.getGeneratedKeys()) {
						if (rs != null && rs.next()) newId = rs.getInt(1);
					}
				}

				request.setRequestId(newId);
				request.setRequestCode(code);
				request.setStatus(submit ? "pending" : "draft");
			}

			connection.commit();
			return request;
		} catch (SQLException e) {
			e.printStackTrace();
			try { connection.rollback(); } catch (SQLException ignored) {}
			return null;
		} finally {
			try {
				connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
				connection.setAutoCommit(originalAC);
			} catch (SQLException ignored) {}
		}
	}

	public boolean updateDraft(LeaveRequest request) {
		String sql = "UPDATE Leave_Request SET warehouse_id = ?, leave_type_id = ?, start_date = ?, end_date = ?, reason = ?, updated_at = GETDATE() " +
				"WHERE request_id = ? AND employee_id = ? AND status = 'draft'";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setInt(1, request.getWarehouseId());
			ps.setInt(2, request.getLeaveTypeId());
			ps.setDate(3, request.getStartDate());
			ps.setDate(4, request.getEndDate());
			ps.setNString(5, request.getReason());
			ps.setInt(6, request.getRequestId());
			ps.setInt(7, request.getEmployeeId());
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteDraft(int requestId, int employeeId) {
		String sql = "DELETE FROM Leave_Request WHERE request_id = ? AND employee_id = ? AND status = 'draft'";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setInt(1, requestId);
			ps.setInt(2, employeeId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean submitDraft(int requestId, int employeeId) {
		String sql = "UPDATE Leave_Request SET status = 'pending', updated_at = GETDATE() WHERE request_id = ? AND employee_id = ? AND status = 'draft'";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setInt(1, requestId);
			ps.setInt(2, employeeId);
			return ps.executeUpdate() > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public LeaveRequest findByIdForEmployee(int requestId, int employeeId) {
		String sql = "SELECT request_id, request_code, employee_id, warehouse_id, leave_type_id, start_date, end_date, reason, created_at, updated_at, status, approved_by, approved_at, manager_notes " +
				"FROM Leave_Request WHERE request_id = ? AND employee_id = ?";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setInt(1, requestId);
			ps.setInt(2, employeeId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return map(rs);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<LeaveRequest> listByEmployee(int employeeId) {
		List<LeaveRequest> list = new ArrayList<>();
		String sql = "SELECT request_id, request_code, employee_id, warehouse_id, leave_type_id, start_date, end_date, reason, created_at, updated_at, status, approved_by, approved_at, manager_notes " +
				"FROM Leave_Request WHERE employee_id = ? ORDER BY created_at DESC, request_id DESC";
		try (PreparedStatement ps = connection.prepareStatement(sql)) {
			ps.setInt(1, employeeId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					list.add(map(rs));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}

	private LeaveRequest map(ResultSet rs) throws SQLException {
		LeaveRequest r = new LeaveRequest();
		r.setRequestId(rs.getInt("request_id"));
		r.setRequestCode(rs.getString("request_code"));
		r.setEmployeeId(rs.getInt("employee_id"));
		r.setWarehouseId(rs.getInt("warehouse_id"));
		r.setLeaveTypeId(rs.getInt("leave_type_id"));
		r.setStartDate(rs.getDate("start_date"));
		r.setEndDate(rs.getDate("end_date"));
		r.setReason(rs.getNString("reason"));
		r.setCreatedAt(rs.getTimestamp("created_at"));
		r.setUpdatedAt(rs.getTimestamp("updated_at"));
		r.setStatus(rs.getString("status"));
		Object apvBy = rs.getObject("approved_by");
		r.setApprovedBy(apvBy == null ? null : ((Number) apvBy).intValue());
		r.setApprovedAt(rs.getTimestamp("approved_at"));
		r.setManagerNotes(rs.getNString("manager_notes"));
		return r;
	}
} 