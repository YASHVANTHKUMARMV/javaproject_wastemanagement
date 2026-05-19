package com.wastemanagement.dao;

import com.wastemanagement.model.User;
import com.wastemanagement.util.DBConnection;
import java.sql.*;

/**
 * Data Access Object for User operations
 * Handles all user-related database queries
 */
public class UserDAO {
    
    /**
     * Register a new user with email and password
     */
    public boolean registerUser(User user) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error registering user: unable to establish database connection");
                return false;
            }
            String query = "INSERT INTO users(name, email, password, created_at) VALUES(?, ?, ?, NOW())";
            ps = con.prepareStatement(query);
            
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // In production, hash this!
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }
    
    /**
     * Authenticate user by email and password
     */
    public User authenticateUser(String email, String password) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error authenticating user: unable to establish database connection");
                return null;
            }
            String query = "SELECT id, name, email FROM users WHERE email = ? AND password = ?";
            ps = con.prepareStatement(query);
            
            ps.setString(1, email);
            ps.setString(2, password);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                return user;
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Check if email already exists
     */
    public boolean emailExists(String email) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error checking email: unable to establish database connection");
                return false;
            }
            String query = "SELECT id FROM users WHERE email = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, email);
            
            rs = ps.executeQuery();
            return rs.next();
            
        } catch (SQLException e) {
            System.err.println("Error checking email: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Get user by ID
     */
    public User getUserById(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error getting user: unable to establish database connection");
                return null;
            }
            String query = "SELECT id, name, email, created_at FROM users WHERE id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setCreatedAt(rs.getString("created_at"));
                return user;
            }
            
            return null;
            
        } catch (SQLException e) {
            System.err.println("Error getting user: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Update user profile
     */
    public boolean updateUser(User user) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error updating user: unable to establish database connection");
                return false;
            }
            String query = "UPDATE users SET name = ? WHERE id = ?";
            ps = con.prepareStatement(query);
            
            ps.setString(1, user.getName());
            ps.setInt(2, user.getId());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }
    
    // Helper method to close resources
    private void closeResources(Connection con, PreparedStatement ps) {
        try {
            if (ps != null) ps.close();
            DBConnection.closeConnection(con);
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
    
    private void closeResources(Connection con, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            DBConnection.closeConnection(con);
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
}
