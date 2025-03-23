/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package db;
/**
 *
 * @author nlong
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:sqlserver://NGUYENLONG:1433;databaseName=Assignment;encrypt=true;trustServerCertificate=true";
    private static final String USER = "longnd"; // Thay bằng username của SQL Server
    private static final String PASSWORD = "12345"; // Thay bằng mật khẩu SQL Server

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Tải driver (không bắt buộc với Java 8+ nhưng nên có để đảm bảo)
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Kết nối tới database
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Kết nối SQL Server thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy JDBC Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
        }
        return conn;
    }

    public static void main(String[] args) {
        getConnection(); // Kiểm tra kết nối
    }
}
