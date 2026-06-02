package utils;

public final class RoleConstants {
    public static final String ADMIN = "Admin";
    public static final String MANAGER = "Manager";
    public static final String EMPLOYEE = "Employee";

    private RoleConstants() {
    }

    // Tất cả các role sau khi đăng nhập đều chuyển về servlet /dashboard
    public static String homePath(String roleName) {
        if (roleName == null) {
            return "/login";
        }
        return "/dashboard";
    }

    // Kiểm tra quyền truy cập đường dẫn dựa trên vai trò
    public static boolean canAccess(String roleName, String path) {
        if (roleName == null || path == null) {
            return false;
        }
        
        // Loại bỏ query parameters nếu có khi kiểm tra path
        String cleanPath = path.split("\\?")[0];
        
        // Các tài nguyên chung mà bất kỳ user nào đã đăng nhập đều truy cập được
        if (cleanPath.equals("/dashboard") || cleanPath.startsWith("/dashboard/") ||
            cleanPath.equals("/profile") || cleanPath.startsWith("/profile/") ||
            cleanPath.equals("/agenda") || cleanPath.startsWith("/agenda/") ||
            cleanPath.equals("/attendance") || cleanPath.startsWith("/attendance/")) {
            return ADMIN.equals(roleName) || MANAGER.equals(roleName) || EMPLOYEE.equals(roleName);
        }
        
        // Các đường dẫn riêng theo vai trò
        if (cleanPath.startsWith("/admin/")) {
            return ADMIN.equals(roleName);
        }
        if (cleanPath.startsWith("/manager/")) {
            return MANAGER.equals(roleName);
        }
        if (cleanPath.startsWith("/employee/")) {
            return EMPLOYEE.equals(roleName);
        }
        
        return false;
    }
}
