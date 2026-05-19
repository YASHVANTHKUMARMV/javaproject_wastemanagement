<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
    %>
    
    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <%
                    if (userSession != null) {
                %>
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="waste-collection.jsp">Log Waste</a>
                    <a href="history.jsp">History</a>
                    <a href="profile.jsp">Profile</a>
                    <a href="logout">Logout</a>
                <%
                    } else {
                %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                <%
                    }
                %>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="hero">
            <h1>Smart Waste Monitoring System</h1>
            <p>Track, manage, and reduce waste efficiently</p>
            
            <%
                if (userSession == null) {
            %>
                <div class="button-group">
                    <a href="login.jsp" class="btn btn-primary">Login</a>
                    <a href="register.jsp" class="btn btn-secondary">Register</a>
                </div>
            <%
                } else {
            %>
                <div class="button-group">
                    <a href="dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
                    <a href="waste-collection.jsp" class="btn btn-secondary">Log Waste</a>
                </div>
            <%
                }
            %>
        </section>

        <section class="features">
            <h2>Features</h2>
            <div class="feature-grid">
                <div class="feature-card">
                    <h3>📊 Track Waste</h3>
                    <p>Monitor waste collection by type and quantity</p>
                </div>
                <div class="feature-card">
                    <h3>📈 Analytics</h3>
                    <p>View waste statistics and trends</p>
                </div>
                <div class="feature-card">
                    <h3>🔒 Secure</h3>
                    <p>Your data is protected with secure authentication</p>
                </div>
                <div class="feature-card">
                    <h3>📱 Easy to Use</h3>
                    <p>Simple and intuitive interface for everyone</p>
                </div>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
