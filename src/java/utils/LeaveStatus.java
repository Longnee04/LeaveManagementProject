package utils;

public final class LeaveStatus {
    public static final String DRAFT = "Draft";
    public static final String PENDING = "Pending";
    public static final String APPROVED = "Approved";
    public static final String REJECTED = "Rejected";

    private LeaveStatus() {
    }

    public static boolean isEditable(String status) {
        return DRAFT.equals(status);
    }
}
