package com.wastemanagement.dao;

import com.wastemanagement.model.CollectionSession;
import com.wastemanagement.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for worker collection sessions.
 */
public class CollectionDAO {

    public boolean addSession(CollectionSession session) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error adding collection session: unable to establish database connection");
                return false;
            }
            String query = "INSERT INTO collection_sessions(worker_id, citizen_id, qr_code, total_organic, total_dry, total_reject, total_collected, segregation_score, points_awarded, notes, session_date) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, session.getWorkerId());
            ps.setInt(2, session.getCitizenId());
            ps.setString(3, session.getQrCode());
            ps.setDouble(4, session.getTotalOrganic());
            ps.setDouble(5, session.getTotalDry());
            ps.setDouble(6, session.getTotalReject());
            ps.setDouble(7, session.getTotalCollected());
            ps.setDouble(8, session.getSegregationScore());
            ps.setInt(9, session.getPointsAwarded());
            ps.setString(10, session.getNotes());
            ps.setString(11, session.getSessionDate());

            int result = ps.executeUpdate();
            if (result > 0) {
                generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    session.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error adding collection session: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
            } catch (SQLException e) {
                System.out.println("Error closing generated keys: " + e.getMessage());
            }
            closeResources(con, ps);
        }
    }

    public List<CollectionSession> getSessionsByCitizen(int citizenId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CollectionSession> sessions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading sessions by citizen: unable to establish database connection");
                return sessions;
            }
            String query = "SELECT id, worker_id, citizen_id, qr_code, total_organic, total_dry, total_reject, total_collected, segregation_score, points_awarded, notes, session_date, created_at FROM collection_sessions WHERE citizen_id = ? ORDER BY created_at DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, citizenId);
            rs = ps.executeQuery();

            while (rs.next()) {
                CollectionSession session = new CollectionSession();
                session.setId(rs.getInt("id"));
                session.setWorkerId(rs.getInt("worker_id"));
                session.setCitizenId(rs.getInt("citizen_id"));
                session.setQrCode(rs.getString("qr_code"));
                session.setTotalOrganic(rs.getDouble("total_organic"));
                session.setTotalDry(rs.getDouble("total_dry"));
                session.setTotalReject(rs.getDouble("total_reject"));
                session.setTotalCollected(rs.getDouble("total_collected"));
                session.setSegregationScore(rs.getDouble("segregation_score"));
                session.setPointsAwarded(rs.getInt("points_awarded"));
                session.setNotes(rs.getString("notes"));
                session.setSessionDate(rs.getString("session_date"));
                session.setCreatedAt(rs.getString("created_at"));
                sessions.add(session);
            }
            return sessions;
        } catch (SQLException e) {
            System.err.println("Error reading sessions by citizen: " + e.getMessage());
            e.printStackTrace();
            return sessions;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<CollectionSession> getSessionsByWorker(int workerId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CollectionSession> sessions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading sessions by worker: unable to establish database connection");
                return sessions;
            }
            String query = "SELECT id, worker_id, citizen_id, qr_code, total_organic, total_dry, total_reject, total_collected, segregation_score, points_awarded, notes, session_date, created_at FROM collection_sessions WHERE worker_id = ? ORDER BY created_at DESC";
            ps = con.prepareStatement(query);
            ps.setInt(1, workerId);
            rs = ps.executeQuery();

            while (rs.next()) {
                CollectionSession session = new CollectionSession();
                session.setId(rs.getInt("id"));
                session.setWorkerId(rs.getInt("worker_id"));
                session.setCitizenId(rs.getInt("citizen_id"));
                session.setQrCode(rs.getString("qr_code"));
                session.setTotalOrganic(rs.getDouble("total_organic"));
                session.setTotalDry(rs.getDouble("total_dry"));
                session.setTotalReject(rs.getDouble("total_reject"));
                session.setTotalCollected(rs.getDouble("total_collected"));
                session.setSegregationScore(rs.getDouble("segregation_score"));
                session.setPointsAwarded(rs.getInt("points_awarded"));
                session.setNotes(rs.getString("notes"));
                session.setSessionDate(rs.getString("session_date"));
                session.setCreatedAt(rs.getString("created_at"));
                sessions.add(session);
            }
            return sessions;
        } catch (SQLException e) {
            System.err.println("Error reading sessions by worker: " + e.getMessage());
            e.printStackTrace();
            return sessions;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public int getTotalSessions() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error counting sessions: unable to establish database connection");
                return 0;
            }
            String query = "SELECT COUNT(*) AS total FROM collection_sessions";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        } catch (SQLException e) {
            System.err.println("Error counting sessions: " + e.getMessage());
            e.printStackTrace();
            return 0;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public double[] getAggregateWasteStats() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        double[] stats = new double[3]; // [organic, dry, reject]

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading aggregate waste stats: unable to establish database connection");
                return stats;
            }
            String query = "SELECT IFNULL(SUM(total_organic), 0) AS organic, IFNULL(SUM(total_dry), 0) AS dry, IFNULL(SUM(total_reject), 0) AS reject FROM collection_sessions";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            if (rs.next()) {
                stats[0] = rs.getDouble("organic");
                stats[1] = rs.getDouble("dry");
                stats[2] = rs.getDouble("reject");
            }
            return stats;
        } catch (SQLException e) {
            System.err.println("Error reading aggregate waste stats: " + e.getMessage());
            e.printStackTrace();
            return stats;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<Object[]> getDailyCollectionTrend() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Object[]> trend = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading daily collection trend: unable to establish database connection");
                return trend;
            }
            String query = "SELECT session_date, SUM(total_collected) AS daily_total FROM collection_sessions GROUP BY session_date ORDER BY session_date DESC LIMIT 7";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                trend.add(new Object[]{ rs.getString("session_date"), rs.getDouble("daily_total") });
            }
            return trend;
        } catch (SQLException e) {
            System.err.println("Error reading daily collection trend: " + e.getMessage());
            e.printStackTrace();
            return trend;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<Object[]> getWardWiseStats() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Object[]> statsList = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading ward wise stats: unable to establish database connection");
                return statsList;
            }
            String query = "SELECT " +
                           "    IFNULL(u.ward, 'Unknown') AS ward, " +
                           "    COUNT(cs.id) AS total_sessions, " +
                           "    SUM(cs.total_organic) AS total_organic, " +
                           "    SUM(cs.total_dry) AS total_dry, " +
                           "    SUM(cs.total_reject) AS total_reject, " +
                           "    SUM(cs.total_collected) AS total_collected, " +
                           "    AVG(cs.segregation_score) AS avg_segregation_score " +
                           "FROM collection_sessions cs " +
                           "JOIN users u ON cs.citizen_id = u.id " +
                           "GROUP BY u.ward";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                statsList.add(new Object[]{
                    rs.getString("ward"),
                    rs.getInt("total_sessions"),
                    rs.getDouble("total_organic"),
                    rs.getDouble("total_dry"),
                    rs.getDouble("total_reject"),
                    rs.getDouble("total_collected"),
                    rs.getDouble("avg_segregation_score")
                });
            }
            return statsList;
        } catch (SQLException e) {
            System.err.println("Error reading ward wise stats: " + e.getMessage());
            e.printStackTrace();
            return statsList;
        } finally {
            closeResources(con, ps, rs);
        }
    }

    public List<CollectionSession> getRecentSessions(int limit) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CollectionSession> sessions = new ArrayList<>();

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                System.err.println("Error reading recent sessions: unable to establish database connection");
                return sessions;
            }
            String query = "SELECT id, worker_id, citizen_id, qr_code, total_organic, total_dry, total_reject, total_collected, segregation_score, points_awarded, notes, session_date, created_at FROM collection_sessions ORDER BY created_at DESC LIMIT ?";
            ps = con.prepareStatement(query);
            ps.setInt(1, limit);
            rs = ps.executeQuery();

            while (rs.next()) {
                CollectionSession session = new CollectionSession();
                session.setId(rs.getInt("id"));
                session.setWorkerId(rs.getInt("worker_id"));
                session.setCitizenId(rs.getInt("citizen_id"));
                session.setQrCode(rs.getString("qr_code"));
                session.setTotalOrganic(rs.getDouble("total_organic"));
                session.setTotalDry(rs.getDouble("total_dry"));
                session.setTotalReject(rs.getDouble("total_reject"));
                session.setTotalCollected(rs.getDouble("total_collected"));
                session.setSegregationScore(rs.getDouble("segregation_score"));
                session.setPointsAwarded(rs.getInt("points_awarded"));
                session.setNotes(rs.getString("notes"));
                session.setSessionDate(rs.getString("session_date"));
                session.setCreatedAt(rs.getString("created_at"));
                sessions.add(session);
            }
            return sessions;
        } catch (SQLException e) {
            System.err.println("Error reading recent sessions: " + e.getMessage());
            e.printStackTrace();
            return sessions;
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
