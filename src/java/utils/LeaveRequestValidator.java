package utils;

import dao.EmployeeLeaveBalanceDAO;
import java.sql.Date;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import models.EmployeeLeaveBalance;
import models.LeaveType;
import models.User;

public final class LeaveRequestValidator {

    public static String validate(int leaveTypeId, String startDateStr, String endDateStr,
            String reason, LeaveType leaveType, User user, String minUnitChosen) {
        if (leaveTypeId <= 0) {
            return "Vui lòng chọn loại nghỉ phép.";
        }
        if (leaveType == null) {
            return "Loại nghỉ phép không hợp lệ.";
        }
        if (startDateStr == null || startDateStr.isBlank()) {
            return "Vui lòng chọn ngày bắt đầu.";
        }
        if (endDateStr == null || endDateStr.isBlank()) {
            return "Vui lòng chọn ngày kết thúc.";
        }

        LocalDate start;
        LocalDate end;
        try {
            start = LocalDate.parse(startDateStr);
            end = LocalDate.parse(endDateStr);
        } catch (Exception e) {
            return "Ngày không hợp lệ.";
        }

        if (end.isBefore(start)) {
            return "Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.";
        }

        // 1. Kiểm tra giới hạn thử việc đối với nhân viên mới (dưới 30 ngày)
        if (leaveType.isNewEmployeeRestricted() && user != null && user.getCreatedAt() != null) {
            LocalDate created = user.getCreatedAt().toLocalDateTime().toLocalDate();
            long daysOfSeniority = ChronoUnit.DAYS.between(created, LocalDate.now());
            if (daysOfSeniority < 30) {
                return "Loại nghỉ phép này (" + leaveType.getLeaveTypeName() + ") chỉ áp dụng cho nhân sự chính thức đã làm việc trên 30 ngày.";
            }
        }

        // 2. Tính thời lượng nghỉ (Duration)
        double duration = 0;
        if (start.equals(end) && !"Full".equalsIgnoreCase(minUnitChosen)) {
            // Xin nghỉ nửa ngày (Morning hoặc Afternoon)
            duration = 0.5;
        } else {
            if (leaveType.isIsWorkingDaysOnly()) {
                // Tính số ngày làm việc (bỏ qua Thứ Bảy, Chủ Nhật)
                LocalDate curr = start;
                while (!curr.isAfter(end)) {
                    DayOfWeek dow = curr.getDayOfWeek();
                    if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY) {
                        duration += 1.0;
                    }
                    curr = curr.plusDays(1);
                }
            } else {
                // Tính số ngày lịch
                duration = ChronoUnit.DAYS.between(start, end) + 1.0;
            }
        }

        if (duration <= 0) {
            return "Thời lượng nghỉ phép không hợp lệ (không chứa ngày làm việc).";
        }

        // 3. Kiểm tra số dư nghỉ phép
        if (user != null) {
            try (EmployeeLeaveBalanceDAO balanceDAO = new EmployeeLeaveBalanceDAO()) {
                EmployeeLeaveBalance balance = balanceDAO.findByUserAndLeaveType(user.getUserID(), leaveTypeId);
                if (balance != null) {
                    if (balance.getRemainingDays() < duration) {
                        return "Số dư ngày nghỉ của bạn không đủ. Còn lại: " + balance.getRemainingDays() + " ngày. Yêu cầu: " + duration + " ngày.";
                    }
                } else {
                    // Nếu chưa có bảng số dư (ví dụ: lỗi đồng bộ), coi như không đủ số dư nếu loại nghỉ có giới hạn
                    if (leaveType.getMaxDays() < duration) {
                        return "Không tìm thấy số dư nghỉ phép của bạn.";
                    }
                }
            }
        }

        if (reason != null && reason.length() > 500) {
            return "Lý do nghỉ không được vượt quá 500 ký tự.";
        }

        return null;
    }

    // Tính thời lượng nghỉ mà không validate (dùng khi lưu đơn)
    public static double calculateDuration(String startDateStr, String endDateStr, LeaveType leaveType, String minUnitChosen) {
        try {
            LocalDate start = LocalDate.parse(startDateStr);
            LocalDate end = LocalDate.parse(endDateStr);
            if (start.equals(end) && !"Full".equalsIgnoreCase(minUnitChosen)) {
                return 0.5;
            }
            if (leaveType.isIsWorkingDaysOnly()) {
                double duration = 0;
                LocalDate curr = start;
                while (!curr.isAfter(end)) {
                    DayOfWeek dow = curr.getDayOfWeek();
                    if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY) {
                        duration += 1.0;
                    }
                    curr = curr.plusDays(1);
                }
                return duration;
            } else {
                return ChronoUnit.DAYS.between(start, end) + 1.0;
            }
        } catch (Exception e) {
            return 1.0;
        }
    }

    public static Date toSqlDate(String dateStr) {
        return Date.valueOf(LocalDate.parse(dateStr));
    }

    private LeaveRequestValidator() {
    }
}
