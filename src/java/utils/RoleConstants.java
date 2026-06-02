package utils;

public final class RoleConstants {
    public static final String ADMIN = "Admin";
    public static final String MANAGER = "Manager";
    public static final String EMPLOYEE = "Employee";

    private RoleConstants() {
    }

    public static String homePath(String roleName) {
        if (roleName == null) {
            return "/login";
        }
        return switch (roleName) {
            case ADMIN -> "/admin/home.jsp";
            case MANAGER -> "/manager/home.jsp";
            case EMPLOYEE -> "/employee/home.jsp";
            default -> "/login";
        };
    }

    public static boolean canAccess(String roleName, String path) {
        if (roleName == null || path == null) {
            return false;
        }
        if (path.startsWith("/admin/")) {
            return ADMIN.equals(roleName);
        }
        if (path.startsWith("/manager/")) {
            return MANAGER.equals(roleName);
        }
        if (path.startsWith("/employee/")) {
            return EMPLOYEE.equals(roleName);
        }
        return false;
    }
}
