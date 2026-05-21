<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.CollectionDAO" %>
<%@ page import="com.wastemanagement.model.CollectionSession" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Waste History - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (!Constants.ROLE_CITIZEN.equals(role)) {
            response.sendRedirect("citizenDashboard.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute(Constants.SESSION_ID);
        CollectionDAO collectionDAO = new CollectionDAO();
        List<CollectionSession> sessions = collectionDAO.getSessionsByCitizen(userId);
        
        double totalWaste = 0;
        for (CollectionSession session : sessions) {
            totalWaste += session.getTotalCollected();
        }
    %>
    
    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <a href="citizenDashboard.jsp">Dashboard</a>
                <a href="history.jsp">Waste History</a>
                <a href="rewards.jsp">Rewards</a>
                <a href="redemption.jsp">Redeem</a>
                <a href="profile.jsp">Profile</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="content-section">
            <h1>Waste Collection History</h1>
            <p class="subtitle">Your recorded waste collection sessions</p>
            
            <div class="stats-summary">
                <div class="stat-item">
                    <strong>Total Waste Collected:</strong>
                    <span class="stat-value"><%= String.format("%.2f", totalWaste) %> kg</span>
                </div>
                <div class="stat-item">
                    <strong>Total Sessions:</strong>
                    <span class="stat-value"><%= sessions.size() %></span>
                </div>
            </div>
            
            <%
                if (sessions != null && sessions.size() > 0) {
            %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Organic (kg)</th>
                            <th>Dry (kg)</th>
                            <th>Reject (kg)</th>
                            <th>Total (kg)</th>
                            <th>Score (%)</th>
                            <th>Points</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (CollectionSession session : sessions) {
                        %>
                            <tr>
                                <td><%= session.getSessionDate() %></td>
                                <td><%= String.format("%.2f", session.getTotalOrganic()) %></td>
                                <td><%= String.format("%.2f", session.getTotalDry()) %></td>
                                <td><%= String.format("%.2f", session.getTotalReject()) %></td>
                                <td><%= String.format("%.2f", session.getTotalCollected()) %></td>
                                <td><%= String.format("%.1f", session.getSegregationScore()) %></td>
                                <td><%= session.getPointsAwarded() %></td>
                                <td><%= session.getNotes() != null && !session.getNotes().isEmpty() ? session.getNotes() : "-" %></td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                } else {
            %>
                <div class="alert alert-info">
                    No waste collection sessions recorded yet. Ask a sanitation worker to scan your QR code to submit a collection.
                </div>
            <%
                }
            %>
            
            <div class="button-group">
                <a href="citizenDashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
