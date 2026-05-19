package com.wastemanagement.dao;

import com.wastemanagement.model.WasteRecord;
import com.wastemanagement.util.DBConnection;
import java.sql.*;
import java.util.*;

/**
 * Data Access Object for Waste Record operations
 * Handles all waste collection related database queries
 */
public class WasteDAO {
    
    /**
     * Add a new waste collection record
     */
    public boolean addWasteRecord(WasteRecord record) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "INSERT INTO waste_collection(user_id, waste_type, quantity, unit, location, date, notes) VALUES(?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            
            ps.setInt(1, record.getUserId());
            ps.setString(2, record.getWasteType());
            ps.setDouble(3, record.getQuantity());
            ps.setString(4, record.getUnit());
            ps.setString(5, record.getLocation());
            ps.setString(6, record.getDate());
            ps.setString(7, record.getNotes());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error adding waste record: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, ps);
        }
    }
    
    /**
     * Get all waste records for a user
     */
    public List<WasteRecord> getRecordsByUserId(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<WasteRecord> records = new ArrayList<>();
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT id, user_id, waste_type, quantity, unit, location, date, notes FROM waste_collection WHERE user_id = ? ORDER BY date DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                WasteRecord record = new WasteRecord();
                record.setId(rs.getInt("id"));
                record.setUserId(rs.getInt("user_id"));
                record.setWasteType(rs.getString("waste_type"));
                record.setQuantity(rs.getDouble("quantity"));
                record.setUnit(rs.getString("unit"));
                record.setLocation(rs.getString("location"));
                record.setDate(rs.getString("date"));
                record.setNotes(rs.getString("notes"));
                records.add(record);
            }
            
            return records;
            
        } catch (SQLException e) {
            System.out.println("Error getting waste records: " + e.getMessage());
            return records;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Get total waste collected by user (by type)
     */
    public Map<String, Double> getTotalWasteByType(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Map<String, Double> totals = new HashMap<>();
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT waste_type, SUM(quantity) as total FROM waste_collection WHERE user_id = ? GROUP BY waste_type";
            ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                String type = rs.getString("waste_type");
                double total = rs.getDouble("total");
                totals.put(type, total);
            }
            
            return totals;
            
        } catch (SQLException e) {
            System.out.println("Error getting waste totals: " + e.getMessage());
            return totals;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Get total waste collected by user
     */
    public double getTotalWaste(int userId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "SELECT SUM(quantity) as total FROM waste_collection WHERE user_id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, userId);
            
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
            
            return 0.0;
            
        } catch (SQLException e) {
            System.out.println("Error getting total waste: " + e.getMessage());
            return 0.0;
        } finally {
            closeResources(con, ps, rs);
        }
    }
    
    /**
     * Delete a waste record
     */
    public boolean deleteRecord(int recordId) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            String query = "DELETE FROM waste_collection WHERE id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, recordId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error deleting record: " + e.getMessage());
            return false;
        } finally {
            closeResources(con, ps);
        }
    }
    
    // Helper methods
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
