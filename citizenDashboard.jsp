<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.UserDAO" %>
<%@ page import="com.wastemanagement.dao.CollectionDAO" %>
<%@ page import="com.wastemanagement.dao.RedemptionDAO" %>
<%@ page import="com.wastemanagement.model.User" %>
<%@ page import="com.wastemanagement.model.CollectionSession" %>
<%@ page import="com.wastemanagement.model.Redemption" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citizen Dashboard - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_CITIZEN.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute(Constants.SESSION_ID);
        UserDAO userDAO = new UserDAO();
        CollectionDAO collectionDAO = new CollectionDAO();
        RedemptionDAO redemptionDAO = new RedemptionDAO();

        User user = userDAO.getUserById(userId);
        List<CollectionSession> sessions = collectionDAO.getSessionsByCitizen(userId);
        List<Redemption> redemptions = redemptionDAO.getRedemptionsByCitizen(userId);
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
        <section class="dashboard">
            <h1>Welcome, <%= user.getName() %>!</h1>
            <p class="subtitle">Citizen dashboard for your waste segregation history and rewards</p>

            <%
                double avgScore = 0;
                if (!sessions.isEmpty()) {
                    double totalScore = 0;
                    for (CollectionSession s : sessions) {
                        totalScore += s.getSegregationScore();
                    }
                    avgScore = totalScore / sessions.size();
                }
            %>

            <div class="dashboard-grid">
                <div class="dashboard-card" style="min-height: 250px;">
                    <h3>🆔 Your Citizen QR</h3>
                    <div style="margin: 10px 0;">
                        <img src="https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=<%= user.getQrCode() %>" alt="QR Code" style="border: 4px solid white; box-shadow: 0 4px 8px rgba(0,0,0,0.1); border-radius: 8px;" />
                    </div>
                    <p class="stat-value" style="font-size: 1.2rem; color: var(--primary);"><%= user.getQrCode() %></p>
                </div>
                <div class="dashboard-card">
                    <h3>⭐ Points Balance</h3>
                    <p class="stat-value"><%= user.getPoints() %></p>
                    <p><a href="redemption.jsp" class="btn btn-small btn-primary">Redeem Points</a></p>
                </div>
                <div class="dashboard-card">
                    <h3>♻️ Segregation Accuracy</h3>
                    <p class="stat-value"><%= String.format("%.1f", avgScore) %>%</p>
                    <p>Municipal Standard: 70.0%</p>
                </div>
                <div class="dashboard-card">
                    <h3>📆 Sessions Logged</h3>
                    <p class="stat-value"><%= sessions.size() %></p>
                </div>
                <div class="dashboard-card">
                    <h3>🎁 Redeem Status</h3>
                    <p class="stat-value" style="font-size: 1.5rem; margin-top: 10px;">
                        <%= redemptions.isEmpty() ? "None" : redemptions.get(0).getStatus() %>
                    </p>
                    <p><a href="rewards.jsp" class="btn btn-small btn-secondary">History</a></p>
                </div>
            </div>

            <% if (!sessions.isEmpty()) { %>
            <section class="dashboard-charts">
                <h2>Your Segregation Performance Trend</h2>
                <div class="chart-card" style="background: white; padding: 1.5rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center; margin-top: 1.5rem; margin-bottom: 3rem;">
                    <canvas id="citizenPerformanceChart" style="max-height: 280px;"></canvas>
                </div>
            </section>
            <% } %>

            <section class="recent-activity">
                <h2>Recent Waste Sessions</h2>
                <%
                    if (sessions.isEmpty()) {
                %>
                    <div class="alert alert-info">
                        No collection sessions recorded yet. Ask a worker to scan your QR code to submit a collection.
                    </div>
                <%
                    } else {
                %>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Organic (kg)</th>
                                <th>Dry (kg)</th>
                                <th>Reject (kg)</th>
                                <th>Score (%)</th>
                                <th>Points</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            for (CollectionSession sessionRecord : sessions) {
                        %>
                            <tr>
                                <td><%= sessionRecord.getSessionDate() %></td>
                                <td><%= String.format("%.2f", sessionRecord.getTotalOrganic()) %></td>
                                <td><%= String.format("%.2f", sessionRecord.getTotalDry()) %></td>
                                <td><%= String.format("%.2f", sessionRecord.getTotalReject()) %></td>
                                <td><%= String.format("%.1f", sessionRecord.getSegregationScore()) %></td>
                                <td><%= sessionRecord.getPointsAwarded() %></td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                <%
                    }
                %>
            </section>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>

    <% if (!sessions.isEmpty()) { %>
    <script>
        var performanceLabels = [];
        var performanceScores = [];
        <%
            for (int i = sessions.size() - 1; i >= 0; i--) {
                CollectionSession sessionRecord = sessions.get(i);
        %>
                performanceLabels.push('<%= sessionRecord.getSessionDate() %>');
                performanceScores.push(<%= sessionRecord.getSegregationScore() %>);
        <%
            }
        %>

        document.addEventListener("DOMContentLoaded", function() {
            var ctx = document.getElementById('citizenPerformanceChart').getContext('2d');
            var performanceChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: performanceLabels,
                    datasets: [{
                        label: 'Segregation Score (%)',
                        data: performanceScores,
                        borderColor: '#2ecc71',
                        backgroundColor: 'rgba(46, 204, 113, 0.1)',
                        borderWidth: 3,
                        pointBackgroundColor: '#27ae60',
                        pointRadius: 5,
                        fill: true,
                        tension: 0.2
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            min: 0,
                            max: 100,
                            title: {
                                display: true,
                                text: 'Score (%)'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Date'
                            }
                        }
                    }
                }
            });
        });
    </script>
    <% } %>
</body>
</html>
