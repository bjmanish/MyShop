package com.myshop.utility;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectURL {
    public static void main(String[] args) {

        // Create a variable for the connection string.
        String connectionUrl = "jdbc:sqlserver://localhost:1433;databaseName=MYSHOP;encrypt=true;trustServerCertificate=true";
//                "jdbc:sqlserver://MANISHKUMAR:1433;databaseName=MYSHOP;user=Admin;password=Admin@123";
String username = "MANISHKUMAR\\Admin";
String password = "Admin@123";

        try (Connection con = DriverManager.getConnection(connectionUrl, username, password); Statement stmt = con.createStatement();) {
            String SQL = "SELECT * FROM USERS";
            ResultSet rs = stmt.executeQuery(SQL);

            // Iterate through the data in the result set and display it.
            while (rs.next()) {
                System.out.println(rs.getString("name") + " " + rs.getString("mobile"));
            }
        }
        // Handle any errors that may have occurred.
        catch (SQLException e) {
            e.printStackTrace();
        }
    }
}