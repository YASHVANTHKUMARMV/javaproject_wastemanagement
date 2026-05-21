<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.RedemptionDAO" %>
<%@ page import="com.wastemanagement.model.Redemption" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rewards - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_CITIZEN.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        int citizenId = (Integer) session.getAttribute(Constants.SESSION_ID);
        int points = (Integer) session.getAttribute(Constants.SESSION_POINTS);
        RedemptionDAO redemptionDAO = new RedemptionDAO();
        List<Redemption> redemptions = redemptionDAO.getRedemptionsByCitizen(citizenId);
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
            <h1>Your Rewards</h1>
            <p class="subtitle">Current point balance and redemption history</p>

            <div class="stats-summary">
                <div class="stat-item">
                    <strong>Available Points</strong>
                    <span class="stat-value"><%= points %></span>
                </div>
                <div class="stat-item">
                    <strong>Redeem Now</strong>
                    <span class="stat-value"><a href="redemption.jsp">Request Redemption</a></span>
                </div>
            </div>

            <h2>Redemption History</h2>
            <%
                if (redemptions.isEmpty()) {
            %>
                <div class="alert alert-info">No redemptions have been requested yet.</div>
            <%
                } else {
            %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Reward Type</th>
                            <th>Points</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Redemption redemption : redemptions) {
                        %>
                            <tr>
                                <td><%= redemption.getCreatedAt() %></td>
                                <td><%= redemption.getRewardType() %></td>
                                <td><%= redemption.getPointsRequested() %></td>
                                <td><%= redemption.getStatus() %></td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <%
                }
            %>

            <div class="button-group">
                <a href="citizenDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
                <a href="redemption.jsp" class="btn btn-primary">Redeem Points</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
