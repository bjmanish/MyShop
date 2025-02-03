package com.myshop.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ResourceBundle;

public class dbUtil {
    private static Connection conn;

    public dbUtil() {
    }
    
    public static Connection provideConnection(){
        try {
            if(conn == null  || conn.isClosed()){
                ResourceBundle rb = ResourceBundle.getBundle("application");
                String connString = rb.getString("db.connectionString");
                String driverName = rb.getString("db.driverName");
                String userName = rb.getString("db.username");
                String password = rb.getString("db.password");
                try{
                        Class.forName(driverName);
                }catch(ClassNotFoundException cnf){
                        cnf.printStackTrace();
                }
                conn = DriverManager.getConnection(connString, userName, password);
            }
        } catch (SQLException ex) {
                ex.printStackTrace();
        }
        return conn;
    }
    
    public static void closeConnection(Connection conn) {
        /*
	try { 
            if (con != null && !con.isClosed()) {
               con.close(); 
            } 
        } catch (SQLException e) { 
             e.printStackTrace(); 
        }
	*/
    }
    
    
    public static void closeConnection(ResultSet rs) {
	try {
            if (rs != null && !rs.isClosed()) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
		}
            }
	} catch (SQLException e) {
	    e.printStackTrace();
	}
    }

    public static void closeConnection(PreparedStatement ps) {
	try{
            if (ps != null && !ps.isClosed()) {
		try {
                    ps.close();
		} catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
}
