package com.wastemanagement.util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Centralized database connection management.
 * Handles MySQL connectivity with proper resource management.
 */
public class DBConnection {
    
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/wastemanagement?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "Yash#2012";
    
    /**
     * Get a new database connection
     */
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.err.println("Database Connection Error: " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }
    
    /**
     * Close connection safely
     */
    public static void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (Exception e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
}
