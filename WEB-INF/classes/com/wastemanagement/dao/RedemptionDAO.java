package com.wastemanagement.dao;

import com.wastemanagement.model.Redemption;
import com.wastemanagement.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for citizen redemption requests.
 */
public class RedemptionDAO {

    public boolean createRedemption(Redemption redemption) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error creating redemption: unable to establish database connection");
                return false;
            }
            String query = "INSERT INTO redemptions(citizen_id, points_requested, reward_type, status) VALUES(?, ?, ?, ?)";
            ps = con.prepareStatement(query);
            ps.setInt(1, redemption.getCitizenId());
            ps.setInt(2, redemption.getPointsRequested());
            ps.setString(3, redemption.getRewardType());
            ps.setString(4, redemption.getStatus());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error creating redemption: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }

    public List<Redemption> getRedemptionsByCitizen(int citizenId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Redemption> redemptions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading redemptions: unable to establish database connection");
                return redemptions;
            }
            String query = "SELECT id, citizen_id, points_requested, reward_type, status, created_at, updated_at FROM redemptions WHERE citizen_id = ? ORDER BY id DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, citizenId);
            rs = ps.executeQuery();

            while (rs.next()) {
                Redemption redemption = new Redemption();
                redemption.setId(rs.getInt("id"));
                redemption.setCitizenId(rs.getInt("citizen_id"));
                redemption.setPointsRequested(rs.getInt("points_requested"));
                redemption.setRewardType(rs.getString("reward_type"));
                redemption.setStatus(rs.getString("status"));
                redemption.setCreatedAt(rs.getString("created_at"));
                redemption.setUpdatedAt(rs.getString("updated_at"));
                redemptions.add(redemption);
            }
            return redemptions;
        } catch (SQLException e) {
            System.err.println("Error reading redemptions: " + e.getMessage());
            e.printStackTrace();
            return redemptions;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<Redemption> getAllRedemptions() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Redemption> redemptions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading all redemptions: unable to establish database connection");
                return redemptions;
            }
            String query = "SELECT id, citizen_id, points_requested, reward_type, status, created_at, updated_at FROM redemptions ORDER BY id DESC";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Redemption redemption = new Redemption();
                redemption.setId(rs.getInt("id"));
                redemption.setCitizenId(rs.getInt("citizen_id"));
                redemption.setPointsRequested(rs.getInt("points_requested"));
                redemption.setRewardType(rs.getString("reward_type"));
                redemption.setStatus(rs.getString("status"));
                redemption.setCreatedAt(rs.getString("created_at"));
                redemption.setUpdatedAt(rs.getString("updated_at"));
                redemptions.add(redemption);
            }
            return redemptions;
        } catch (SQLException e) {
            System.err.println("Error reading all redemptions: " + e.getMessage());
            e.printStackTrace();
            return redemptions;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public Redemption getRedemptionById(int id) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading redemption by ID: unable to establish database connection");
                return null;
            }
            String query = "SELECT id, citizen_id, points_requested, reward_type, status, created_at, updated_at FROM redemptions WHERE id = ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                Redemption redemption = new Redemption();
                redemption.setId(rs.getInt("id"));
                redemption.setCitizenId(rs.getInt("citizen_id"));
                redemption.setPointsRequested(rs.getInt("points_requested"));
                redemption.setRewardType(rs.getString("reward_type"));
                redemption.setStatus(rs.getString("status"));
                redemption.setCreatedAt(rs.getString("created_at"));
                redemption.setUpdatedAt(rs.getString("updated_at"));
                return redemption;
            }
            return null;
        } catch (SQLException e) {
            System.err.println("Error reading redemption by ID: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public boolean updateRedemptionStatus(int redemptionId, String status) {
        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error updating redemption: unable to establish database connection");
                return false;
            }
            String query = "UPDATE redemptions SET status = ?, updated_at = NOW() WHERE id = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, status);
            ps.setInt(2, redemptionId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating redemption: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            closeResources(con, ps);
        }
    }

    public int getTotalPointsRedeemed() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error calculating redeemed points: unable to establish database connection");
                return 0;
            }
            String query = "SELECT IFNULL(SUM(points_requested), 0) AS total FROM redemptions WHERE status = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, com.wastemanagement.util.Constants.REDEMPTION_APPROVED);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error calculating redeemed points: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(con, ps, rs);
        }
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
