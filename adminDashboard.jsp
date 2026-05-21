<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.UserDAO" %>
<%@ page import="com.wastemanagement.dao.CollectionDAO" %>
<%@ page import="com.wastemanagement.dao.RedemptionDAO" %>
<%@ page import="com.wastemanagement.dao.ComplaintsDAO" %>
<%@ page import="com.wastemanagement.model.Redemption" %>
<%@ page import="com.wastemanagement.model.User" %>
<%@ page import="com.wastemanagement.model.CollectionSession" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_ADMIN.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        CollectionDAO collectionDAO = new CollectionDAO();
        RedemptionDAO redemptionDAO = new RedemptionDAO();
        ComplaintsDAO complaintsDAO = new ComplaintsDAO();

        int citizenCount = userDAO.countUsersByRole(Constants.ROLE_CITIZEN);
        int workerCount = userDAO.countUsersByRole(Constants.ROLE_WORKER);
        int sessionCount = collectionDAO.getTotalSessions();
        int redeemedPoints = redemptionDAO.getTotalPointsRedeemed();
        int pendingComplaints = complaintsDAO.getTotalComplaints();

        List<Redemption> redemptions = redemptionDAO.getAllRedemptions();
        int pendingRedemptionsCount = 0;
        for (Redemption r : redemptions) {
            if (Constants.REDEMPTION_PENDING.equals(r.getStatus())) {
                pendingRedemptionsCount++;
            }
        }

        double[] wasteStats = collectionDAO.getAggregateWasteStats();
        double organicTotal = wasteStats[0];
        double dryTotal = wasteStats[1];
        double rejectTotal = wasteStats[2];

        List<Object[]> dailyTrend = collectionDAO.getDailyCollectionTrend();

        List<User> citizensList = userDAO.getUsersByRole(Constants.ROLE_CITIZEN);
        List<User> workersList = userDAO.getUsersByRole(Constants.ROLE_WORKER);
        List<CollectionSession> recentSessionsList = collectionDAO.getRecentSessions(10);
    %>

    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <a href="adminDashboard.jsp">Dashboard</a>
                <a href="complaints.jsp">Complaints</a>
                <a href="adminRedemptions.jsp">Redemptions</a>
                <a href="profile.jsp">Profile</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="dashboard">
            <h1>Admin Dashboard</h1>
            <p class="subtitle">Monitor citizens, workers, collections, complaints, and rewards</p>

            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <h3>👥 Total Citizens</h3>
                    <p class="stat-value"><%= citizenCount %></p>
                </div>
                <div class="dashboard-card">
                    <h3>🧑‍🔧 Total Workers</h3>
                    <p class="stat-value"><%= workerCount %></p>
                </div>
                <div class="dashboard-card">
                    <h3>📦 Total Sessions</h3>
                    <p class="stat-value"><%= sessionCount %></p>
                </div>
                <div class="dashboard-card">
                    <h3>💸 Points Redeemed</h3>
                    <p class="stat-value"><%= redeemedPoints %></p>
                </div>
                <div class="dashboard-card alert-warning">
                    <h3>⚠️ Pending Complaints</h3>
                    <p class="stat-value"><%= pendingComplaints %></p>
                    <p><a href="complaints.jsp" class="btn btn-small btn-primary">View Complaints</a></p>
                </div>
                <div class="dashboard-card alert-warning">
                    <h3>🎁 Pending Redemptions</h3>
                    <p class="stat-value"><%= pendingRedemptionsCount %></p>
                    <p><a href="adminRedemptions.jsp" class="btn btn-small btn-primary">View Redemptions</a></p>
                </div>
            </div>

            <section class="dashboard-charts">
                <h2>Waste Performance Charts</h2>
                <div class="charts-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 2rem; margin-top: 1.5rem; margin-bottom: 3rem;">
                    <div class="chart-card" style="background: white; padding: 1.5rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center;">
                        <h3 style="margin-bottom: 1rem; color: #333;">Waste Segregation (kg)</h3>
                        <div style="max-width: 250px; margin: 0 auto;">
                            <canvas id="wasteDistributionChart"></canvas>
                        </div>
                    </div>
                    <div class="chart-card" style="background: white; padding: 1.5rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center;">
                        <h3 style="margin-bottom: 1rem; color: #333;">Daily Collection Trend (kg)</h3>
                        <div style="margin: 0 auto;">
                            <canvas id="wasteTrendChart"></canvas>
                        </div>
                    </div>
                    <div class="chart-card" style="background: white; padding: 1.5rem; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center;">
                        <h3 style="margin-bottom: 1rem; color: #333;">Ward Segregation Accuracy (%)</h3>
                        <div style="margin: 0 auto;">
                            <canvas id="wardAccuracyChart"></canvas>
                        </div>
                    </div>
                </div>
            </section>

            <section class="ward-analytics" style="margin-top: 3rem; margin-bottom: 3rem;">
                <h2>Ward-Wise Performance Overview</h2>
                <div class="content-section" style="background: white; padding: 2rem; border-radius: 12px; margin-top: 1.5rem;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ward</th>
                                <th>Total Pickups</th>
                                <th>Wet Waste (kg)</th>
                                <th>Dry Waste (kg)</th>
                                <th>Reject Waste (kg)</th>
                                <th>Total Waste (kg)</th>
                                <th>Average Segregation Accuracy</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            List<Object[]> wardStats = collectionDAO.getWardWiseStats();
                            if (wardStats.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--text-light);">No ward statistics recorded yet.</td>
                            </tr>
                        <%
                            } else {
                                for (Object[] row : wardStats) {
                                    String wardName = (String) row[0];
                                    int totalPickups = (Integer) row[1];
                                    double organic = (Double) row[2];
                                    double dry = (Double) row[3];
                                    double reject = (Double) row[4];
                                    double totalCollected = (Double) row[5];
                                    double avgScore = (Double) row[6];
                        %>
                            <tr>
                                <td><strong><%= wardName %></strong></td>
                                <td><%= totalPickups %></td>
                                <td><%= String.format("%.2f", organic) %></td>
                                <td><%= String.format("%.2f", dry) %></td>
                                <td><%= String.format("%.2f", reject) %></td>
                                <td><%= String.format("%.2f", totalCollected) %></td>
                                <td>
                                    <span class="status-badge <%= avgScore >= 70.0 ? "status-approved" : "status-rejected" %>">
                                        <%= String.format("%.1f", avgScore) %>%
                                    </span>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="citizens-directory" style="margin-top: 3rem; margin-bottom: 3rem;">
                <h2>Registered Citizens Directory</h2>
                <div class="content-section" style="background: white; padding: 2rem; border-radius: 12px; margin-top: 1.5rem; overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Ward</th>
                                <th>Address</th>
                                <th>QR Code ID</th>
                                <th>Points Balance</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (citizensList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--text-light);">No citizens registered in the system yet.</td>
                            </tr>
                        <%
                            } else {
                                for (User citizen : citizensList) {
                        %>
                            <tr>
                                <td><%= citizen.getId() %></td>
                                <td><strong><%= citizen.getName() %></strong></td>
                                <td><%= citizen.getEmail() %></td>
                                <td><%= citizen.getWard() != null ? citizen.getWard() : "N/A" %></td>
                                <td><%= citizen.getAddress() != null ? citizen.getAddress() : "N/A" %></td>
                                <td><code><%= citizen.getQrCode() != null ? citizen.getQrCode() : "N/A" %></code></td>
                                <td>
                                    <span class="status-badge status-approved" style="background: #e0f2fe; color: #0369a1;">
                                        <%= citizen.getPoints() %> pts
                                    </span>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="workers-directory" style="margin-top: 3rem; margin-bottom: 3rem;">
                <h2>Registered Sanitation Workers Directory</h2>
                <div class="content-section" style="background: white; padding: 2rem; border-radius: 12px; margin-top: 1.5rem; overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Ward Assigned</th>
                                <th>Address</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (workersList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="5" style="text-align: center; color: var(--text-light);">No sanitation workers registered in the system yet.</td>
                            </tr>
                        <%
                            } else {
                                for (User worker : workersList) {
                        %>
                            <tr>
                                <td><%= worker.getId() %></td>
                                <td><strong><%= worker.getName() %></strong></td>
                                <td><%= worker.getEmail() %></td>
                                <td><%= worker.getWard() != null ? worker.getWard() : "N/A" %></td>
                                <td><%= worker.getAddress() != null ? worker.getAddress() : "N/A" %></td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="recent-collections" style="margin-top: 3rem; margin-bottom: 3rem;">
                <h2>Recent Collection Activities &amp; Segregation Status</h2>
                <div class="content-section" style="background: white; padding: 2rem; border-radius: 12px; margin-top: 1.5rem; overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Session ID</th>
                                <th>Date</th>
                                <th>Citizen</th>
                                <th>Worker</th>
                                <th>Wet (kg)</th>
                                <th>Dry (kg)</th>
                                <th>Reject (kg)</th>
                                <th>Total (kg)</th>
                                <th>Segregation Score</th>
                                <th>Points Given</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (recentSessionsList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="11" style="text-align: center; color: var(--text-light);">No collection sessions recorded yet.</td>
                            </tr>
                        <%
                            } else {
                                for (CollectionSession sess : recentSessionsList) {
                                    User citizen = userDAO.getUserById(sess.getCitizenId());
                                    User worker = userDAO.getUserById(sess.getWorkerId());
                                    String citizenName = citizen != null ? citizen.getName() : "Citizen #" + sess.getCitizenId();
                                    String workerName = worker != null ? worker.getName() : "Worker #" + sess.getWorkerId();
                                    double score = sess.getSegregationScore();
                        %>
                            <tr>
                                <td><%= sess.getId() %></td>
                                <td style="white-space: nowrap;"><%= sess.getSessionDate() %></td>
                                <td><strong><%= citizenName %></strong></td>
                                <td><%= workerName %></td>
                                <td><%= String.format("%.2f", sess.getTotalOrganic()) %></td>
                                <td><%= String.format("%.2f", sess.getTotalDry()) %></td>
                                <td><%= String.format("%.2f", sess.getTotalReject()) %></td>
                                <td><strong><%= String.format("%.2f", sess.getTotalCollected()) %></strong></td>
                                <td>
                                    <span class="status-badge <%= score >= 70.0 ? "status-approved" : (score >= 40.0 ? "status-pending" : "status-rejected") %>">
                                        <%= String.format("%.1f", score) %>%
                                    </span>
                                </td>
                                <td>
                                    <span style="font-weight: 600; color: #16a34a;">+<%= sess.getPointsAwarded() %></span>
                                </td>
                                <td><span class="text-muted"><%= sess.getNotes() != null ? sess.getNotes() : "-" %></span></td>
                            </tr>
                        <%
                                }
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="quick-actions">
                <h2>Quick Actions</h2>
                <div class="button-group">
                    <a href="complaints.jsp" class="btn btn-primary">View Low Segregation Alerts</a>
                    <a href="adminRedemptions.jsp" class="btn btn-secondary">Manage Rewards Redemptions</a>
                    <a href="profile.jsp" class="btn btn-secondary">View My Profile</a>
                </div>
            </section>

            <section class="quick-stats">
                <h2>System Summary</h2>
                <p>
                    The system has <strong><%= citizenCount %></strong> registered citizens and <strong><%= workerCount %></strong> sanitation workers.
                    A total of <strong><%= sessionCount %></strong> waste collection sessions have been recorded.
                    <strong><%= redeemedPoints %></strong> reward points have been redeemed by citizens.
                    There are <strong><%= pendingComplaints %></strong> pending complaints and <strong><%= pendingRedemptionsCount %></strong> pending redemption requests requiring admin review.
                </p>
            </section>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>

    <script>
        var organicTotal = <%= organicTotal %>;
        var dryTotal = <%= dryTotal %>;
        var rejectTotal = <%= rejectTotal %>;

        var dailyLabels = [];
        var dailyData = [];
        <%
            for (int i = dailyTrend.size() - 1; i >= 0; i--) {
                Object[] row = dailyTrend.get(i);
        %>
                dailyLabels.push('<%= row[0] %>');
                dailyData.push(<%= row[1] %>);
        <%
            }
        %>

        var wardLabels = [];
        var wardAccuracy = [];
        <%
            for (Object[] row : wardStats) {
        %>
                wardLabels.push('<%= row[0] %>');
                wardAccuracy.push(<%= row[6] %>);
        <%
            }
        %>

        document.addEventListener("DOMContentLoaded", function() {
            // Doughnut Chart
            var ctxPie = document.getElementById('wasteDistributionChart').getContext('2d');
            var pieChart = new Chart(ctxPie, {
                type: 'doughnut',
                data: {
                    labels: ['Organic', 'Dry', 'Reject'],
                    datasets: [{
                        data: [organicTotal, dryTotal, rejectTotal],
                        backgroundColor: ['#2ecc71', '#3498db', '#e74c3c'],
                        hoverBackgroundColor: ['#27ae60', '#2980b9', '#c0392b'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        }
                    }
                }
            });

            // Line Chart
            var ctxLine = document.getElementById('wasteTrendChart').getContext('2d');
            var lineChart = new Chart(ctxLine, {
                type: 'line',
                data: {
                    labels: dailyLabels,
                    datasets: [{
                        label: 'Total Collected (kg)',
                        data: dailyData,
                        borderColor: '#9b59b6',
                        backgroundColor: 'rgba(155, 89, 182, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.3
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Weight (kg)'
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

            // Bar Chart for Ward Accuracy
            var ctxBar = document.getElementById('wardAccuracyChart').getContext('2d');
            var barChart = new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: wardLabels,
                    datasets: [{
                        label: 'Average Accuracy (%)',
                        data: wardAccuracy,
                        backgroundColor: 'rgba(13, 148, 136, 0.7)',
                        borderColor: 'rgba(15, 118, 110, 1)',
                        borderWidth: 1.5
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
                                text: 'Accuracy (%)'
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
