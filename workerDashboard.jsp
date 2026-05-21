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
    <title>Worker Dashboard - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_WORKER.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        int workerId = (Integer) session.getAttribute(Constants.SESSION_ID);
        CollectionDAO collectionDAO = new CollectionDAO();
        List<CollectionSession> sessions = collectionDAO.getSessionsByWorker(workerId);
    %>

    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <a href="workerDashboard.jsp">Dashboard</a>
                <a href="collectionForm.jsp">Record Collection</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="dashboard">
            <h1>Worker Dashboard</h1>
            <p class="subtitle">Enter citizen QR codes and record segregated waste collections</p>

            <%
                double totalAccuracy = 0;
                double avgAccuracy = 0;
                if (sessions != null && !sessions.isEmpty()) {
                    for (CollectionSession s : sessions) {
                        totalAccuracy += s.getSegregationScore();
                    }
                    avgAccuracy = totalAccuracy / sessions.size();
                }
            %>
            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <h3>📌 Your Name</h3>
                    <p><%= userSession %></p>
                </div>
                <div class="dashboard-card">
                    <h3>📝 Sessions Recorded</h3>
                    <p><%= sessions.size() %> collections</p>
                </div>
                <div class="dashboard-card">
                    <h3>♻️ Average Sorting Accuracy</h3>
                    <p class="stat-value" style="font-size: 1.8rem; font-weight: 700; color: var(--success);"><%= String.format("%.1f", avgAccuracy) %>%</p>
                </div>
                <div class="dashboard-card">
                    <h3>▶️ Next Step</h3>
                    <p><a href="collectionForm.jsp" class="btn btn-primary">Record a collection</a></p>
                </div>
            </div>

            <section class="recent-activity">
                <h2>Recent Sessions</h2>
                <%
                    if (sessions.isEmpty()) {
                %>
                    <div class="alert alert-info">No collection sessions recorded yet.</div>
                <%
                    } else {
                %>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Citizen QR</th>
                                <th>Total Collected</th>
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
                                <td><%= sessionRecord.getQrCode() %></td>
                                <td><%= String.format("%.2f", sessionRecord.getTotalCollected()) %></td>
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
</body>
</html>
