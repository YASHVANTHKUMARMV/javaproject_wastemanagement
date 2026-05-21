<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Smart Waste Monitoring System</title>
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
        if (Constants.ROLE_ADMIN.equals(role)) {
            response.sendRedirect("adminDashboard.jsp");
            return;
        } else if (Constants.ROLE_WORKER.equals(role)) {
            response.sendRedirect("workerDashboard.jsp");
            return;
        } else if (Constants.ROLE_CITIZEN.equals(role)) {
            response.sendRedirect("citizenDashboard.jsp");
            return;
        }
        String userName = (String) userSession;
    %>
    
    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <a href="dashboard.jsp">Dashboard</a>
                <a href="waste-collection.jsp">Log Waste</a>
                <a href="history.jsp">History</a>
                <a href="profile.jsp">Profile</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="dashboard">
            <h1>Welcome, <%= userName %>!</h1>
            <p class="subtitle">Your Smart Waste Monitoring Dashboard</p>
            
            <div class="dashboard-grid">
                <div class="dashboard-card">
                    <h3>📊 Log Waste</h3>
                    <p>Record your waste collection activities</p>
                    <a href="waste-collection.jsp" class="btn btn-primary">Log Now</a>
                </div>
                
                <div class="dashboard-card">
                    <h3>📈 View History</h3>
                    <p>Check your waste collection history and statistics</p>
                    <a href="history.jsp" class="btn btn-primary">View</a>
                </div>
                
                <div class="dashboard-card">
                    <h3>👤 Profile</h3>
                    <p>Manage your account settings</p>
                    <a href="profile.jsp" class="btn btn-primary">Edit</a>
                </div>
                
                <div class="dashboard-card">
                    <h3>ℹ️ System Status</h3>
                    <p>Check system health and information</p>
                    <a href="#" class="btn btn-primary">Status</a>
                </div>
            </div>
            
            <section class="quick-stats">
                <h2>Quick Stats</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <h4>Total Records</h4>
                        <p class="stat-value">--</p>
                    </div>
                    <div class="stat-card">
                        <h4>This Month</h4>
                        <p class="stat-value">--</p>
                    </div>
                    <div class="stat-card">
                        <h4>This Week</h4>
                        <p class="stat-value">--</p>
                    </div>
                </div>
            </section>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
