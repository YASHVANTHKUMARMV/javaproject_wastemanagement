<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.UserDAO" %>
<%@ page import="com.wastemanagement.model.User" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        if (userSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute(Constants.SESSION_ID);
        String email = (String) session.getAttribute(Constants.SESSION_EMAIL);
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userId);
    %>
    
    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <%
                    String role = (String) session.getAttribute(Constants.SESSION_ROLE);
                    if (Constants.ROLE_CITIZEN.equals(role)) {
                %>
                    <a href="citizenDashboard.jsp">Dashboard</a>
                    <a href="history.jsp">Waste History</a>
                    <a href="rewards.jsp">Rewards</a>
                    <a href="redemption.jsp">Redeem</a>
                    <a href="profile.jsp">Profile</a>
                    <a href="logout">Logout</a>
                <%
                    } else if (Constants.ROLE_WORKER.equals(role)) {
                %>
                    <a href="workerDashboard.jsp">Dashboard</a>
                    <a href="collectionForm.jsp">Record Collection</a>
                    <a href="profile.jsp">Profile</a>
                    <a href="logout">Logout</a>
                <%
                    } else if (Constants.ROLE_ADMIN.equals(role)) {
                %>
                    <a href="adminDashboard.jsp">Dashboard</a>
                    <a href="profile.jsp">Profile</a>
                    <a href="logout">Logout</a>
                <%
                    }
                %>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="content-section">
            <h1>User Profile</h1>
            <p class="subtitle">Your account information</p>
            
            <%
                if (user != null) {
            %>
                <div class="profile-card">
                    <div class="profile-field">
                        <label>Name:</label>
                        <p><%= user.getName() %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>Email:</label>
                        <p><%= user.getEmail() %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>Role:</label>
                        <p><%= user.getRole() %></p>
                    </div>
                    
                    <% if (com.wastemanagement.util.Constants.ROLE_CITIZEN.equals(user.getRole())) { %>
                    <div class="profile-field">
                        <label>Ward:</label>
                        <p><%= user.getWard() != null ? user.getWard() : "-" %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>Address:</label>
                        <p><%= user.getAddress() != null ? user.getAddress() : "-" %></p>
                    </div>
                    <% } %>
                    
                    <div class="profile-field">
                        <label>Citizen QR Code:</label>
                        <p><%= user.getQrCode() != null ? user.getQrCode() : "-" %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>Reward Points:</label>
                        <p><%= user.getPoints() %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>Member Since:</label>
                        <p><%= user.getCreatedAt() %></p>
                    </div>
                    
                    <div class="profile-field">
                        <label>User ID:</label>
                        <p><%= user.getId() %></p>
                    </div>
                </div>
            <%
                } else {
            %>
                <div class="alert alert-danger">
                    Unable to load profile information.
                </div>
            <%
                }
            %>
            
            <div class="button-group">
                <a href="dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
                <a href="logout" class="btn btn-danger">Logout</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
