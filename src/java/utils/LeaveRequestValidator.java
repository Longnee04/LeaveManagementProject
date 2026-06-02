package utils;

import java.sql.Date;
import java.time.LocalDate;
import models.LeaveType;

public final class LeaveRequestValidator {

    public static String validate(int leaveTypeId, String startDateStr, String endDateStr,
            String reason, LeaveType leaveType) {
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

        int totalDays = (int) (end.toEpochDay() - start.toEpochDay()) + 1;
        if (totalDays > leaveType.getMaxDays()) {
            return "Số ngày nghỉ (" + totalDays + ") vượt quá giới hạn loại này (" + leaveType.getMaxDays() + " ngày).";
        }

        if (reason != null && reason.length() > 500) {
            return "Lý do nghỉ không được vượt quá 500 ký tự.";
        }

        return null;
    }

    public static Date toSqlDate(String dateStr) {
        return Date.valueOf(LocalDate.parse(dateStr));
    }

    private LeaveRequestValidator() {
    }
}
