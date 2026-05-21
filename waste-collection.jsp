<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Waste - Smart Waste Monitoring System</title>
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
            response.sendRedirect("dashboard.jsp");
            return;
        }
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
        <section class="content-section">
            <h1>Log Waste Collection</h1>
            <p class="subtitle">Record your waste segregation and collection</p>
            
            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <%
                }
                if (success != null) {
            %>
                <div class="alert alert-success"><%= success %></div>
            <%
                }
            %>
            
            <form action="waste" method="POST" class="form-grid">
                <div class="form-group">
                    <label for="wasteType">Waste Type:</label>
                    <select id="wasteType" name="wasteType" required>
                        <option value="">-- Select Waste Type --</option>
                        <option value="Plastic">Plastic</option>
                        <option value="Paper">Paper</option>
                        <option value="Glass">Glass</option>
                        <option value="Metal">Metal</option>
                        <option value="Organic">Organic</option>
                        <option value="E-Waste">E-Waste</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="quantity">Quantity (kg):</label>
                    <input type="number" id="quantity" name="quantity" step="0.1" min="0" required>
                </div>
                
                <div class="form-group">
                    <label for="location">Location:</label>
                    <input type="text" id="location" name="location" placeholder="e.g., Building A, Floor 2" required>
                </div>
                
                <div class="form-group">
                    <label for="notes">Notes (optional):</label>
                    <textarea id="notes" name="notes" rows="3" placeholder="Additional details about the waste..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Log Waste</button>
                <a href="dashboard.jsp" class="btn btn-secondary btn-block">Back to Dashboard</a>
            </form>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
