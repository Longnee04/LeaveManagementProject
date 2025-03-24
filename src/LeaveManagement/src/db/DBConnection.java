package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/leavemanagement"; // Update with your database URL
    private static final String USER = "root"; // Update with your database username
    private static final String PASSWORD = "password"; // Update with your database password

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}