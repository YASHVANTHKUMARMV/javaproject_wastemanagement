package com.wastemanagement.dao;

import com.wastemanagement.model.Complaint;
import com.wastemanagement.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for waste segregation complaints
 */
public class ComplaintsDAO {

    public boolean createComplaint(Complaint complaint) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error creating complaint: unable to establish database connection");
                return false;
            }
            String query = "INSERT INTO complaints(citizen_id, worker_id, session_id, complaint_type, segregation_score, description, status) VALUES(?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            
            ps.setInt(1, complaint.getCitizenId());
            ps.setInt(2, complaint.getWorkerId());
            ps.setInt(3, complaint.getSessionId());
            ps.setString(4, complaint.getComplaintType());
            ps.setDouble(5, complaint.getSegregationScore());
            ps.setString(6, complaint.getDescription());
            ps.setString(7, complaint.getStatus());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error creating complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }

    public List<Complaint> getAllComplaints() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> complaints = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading complaints: unable to establish database connection");
                return complaints;
            }
            String query = "SELECT id, citizen_id, worker_id, session_id, complaint_type, segregation_score, description, status, admin_notes, created_at, updated_at FROM complaints ORDER BY created_at DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Complaint complaint = mapComplaint(rs);
                complaints.add(complaint);
            }
            return complaints;
        } catch (SQLException e) {
            System.err.println("Error reading complaints: " + e.getMessage());
            e.printStackTrace();
            return complaints;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<Complaint> getComplaintsByStatus(String status) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Complaint> complaints = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading complaints by status: unable to establish database connection");
                return complaints;
            }
            String query = "SELECT id, citizen_id, worker_id, session_id, complaint_type, segregation_score, description, status, admin_notes, created_at, updated_at FROM complaints WHERE status = ? ORDER BY created_at DESC";
            ps = con.prepareStatement(query);
            ps.setString(1, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                Complaint complaint = mapComplaint(rs);
                complaints.add(complaint);
            }
            return complaints;
        } catch (SQLException e) {
            System.err.println("Error reading complaints by status: " + e.getMessage());
            e.printStackTrace();
            return complaints;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public int getTotalComplaints() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error counting complaints: unable to establish database connection");
                return 0;
            }
            String query = "SELECT COUNT(*) AS total FROM complaints WHERE status = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, "PENDING");
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error counting complaints: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public boolean updateComplaintStatus(int complaintId, String status, String adminNotes) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error updating complaint: unable to establish database connection");
                return false;
            }
            String query = "UPDATE complaints SET status = ?, admin_notes = ?, updated_at = NOW() WHERE id = ?";
            ps = con.prepareStatement(query);
            
            ps.setString(1, status);
            ps.setString(2, adminNotes);
            ps.setInt(3, complaintId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating complaint: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setId(rs.getInt("id"));
        complaint.setCitizenId(rs.getInt("citizen_id"));
        complaint.setWorkerId(rs.getInt("worker_id"));
        complaint.setSessionId(rs.getInt("session_id"));
        complaint.setComplaintType(rs.getString("complaint_type"));
        complaint.setSegregationScore(rs.getDouble("segregation_score"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setAdminNotes(rs.getString("admin_notes"));
        complaint.setCreatedAt(rs.getString("created_at"));
        complaint.setUpdatedAt(rs.getString("updated_at"));
        return complaint;
    }

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
