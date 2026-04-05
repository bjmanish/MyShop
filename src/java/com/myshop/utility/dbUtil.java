package com.myshop.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class dbUtil {

    private static final ResourceBundle rb = ResourceBundle.getBundle("application");

    private static final String URL = rb.getString("db.connectionString");
    private static final String USER = rb.getString("db.username");
    private static final String PASS = rb.getString("db.password");
    private static final String DRIVER = rb.getString("db.driverName");

    static {
        try {
            Class.forName(DRIVER); // optional but safe
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // ✅ Always return NEW connection (best practice)
    public static Connection provideConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    // ✅ Close Connection
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Close ResultSet
    public static void closeConnection(ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Close PreparedStatement
    public static void closeConnection(PreparedStatement ps) {
        try {
            if (ps != null && !ps.isClosed()) {
                ps.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}