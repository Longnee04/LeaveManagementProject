package model;

import java.sql.Timestamp;
import java.util.Objects;

public class LeaveRequest {
	private Integer requestId;
	private String requestCode;
	private Integer employeeId;
	private Integer warehouseId;
	private Integer leaveTypeId;
	private java.sql.Date startDate;
	private java.sql.Date endDate;
	private String reason;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private String status; // draft, pending, approve, reject
	private Integer approvedBy;
	private Timestamp approvedAt;
	private String managerNotes;

	public LeaveRequest() {}

	public Integer getRequestId() { return requestId; }
	public void setRequestId(Integer requestId) { this.requestId = requestId; }

	public String getRequestCode() { return requestCode; }
	public void setRequestCode(String requestCode) { this.requestCode = requestCode; }

	public Integer getEmployeeId() { return employeeId; }
	public void setEmployeeId(Integer employeeId) { this.employeeId = employeeId; }

	public Integer getWarehouseId() { return warehouseId; }
	public void setWarehouseId(Integer warehouseId) { this.warehouseId = warehouseId; }

	public Integer getLeaveTypeId() { return leaveTypeId; }
	public void setLeaveTypeId(Integer leaveTypeId) { this.leaveTypeId = leaveTypeId; }

	public java.sql.Date getStartDate() { return startDate; }
	public void setStartDate(java.sql.Date startDate) { this.startDate = startDate; }

	public java.sql.Date getEndDate() { return endDate; }
	public void setEndDate(java.sql.Date endDate) { this.endDate = endDate; }

	public String getReason() { return reason; }
	public void setReason(String reason) { this.reason = reason; }

	public Timestamp getCreatedAt() { return createdAt; }
	public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

	public Timestamp getUpdatedAt() { return updatedAt; }
	public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

	public String getStatus() { return status; }
	public void setStatus(String status) { this.status = status; }

	public Integer getApprovedBy() { return approvedBy; }
	public void setApprovedBy(Integer approvedBy) { this.approvedBy = approvedBy; }

	public Timestamp getApprovedAt() { return approvedAt; }
	public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

	public String getManagerNotes() { return managerNotes; }
	public void setManagerNotes(String managerNotes) { this.managerNotes = managerNotes; }

	@Override
	public String toString() {
		return "LeaveRequest{" +
				"requestId=" + requestId +
				", requestCode='" + requestCode + '\'' +
				", employeeId=" + employeeId +
				", warehouseId=" + warehouseId +
				", leaveTypeId=" + leaveTypeId +
				", startDate=" + startDate +
				", endDate=" + endDate +
				", status='" + status + '\'' +
				"}";
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		LeaveRequest that = (LeaveRequest) o;
		return Objects.equals(requestId, that.requestId);
	}

	@Override
	public int hashCode() {
		return Objects.hash(requestId);
	}
} 