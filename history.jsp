<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.WasteDAO" %>
<%@ page import="com.wastemanagement.model.WasteRecord" %>
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
        if (userSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute(Constants.SESSION_ID);
        WasteDAO wasteDAO = new WasteDAO();
        List<WasteRecord> records = wasteDAO.getRecordsByUserId(userId);
        double totalWaste = wasteDAO.getTotalWaste(userId);
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
            <h1>Waste Collection History</h1>
            <p class="subtitle">Your recorded waste collections</p>
            
            <div class="stats-summary">
                <div class="stat-item">
                    <strong>Total Waste Collected:</strong>
                    <span class="stat-value"><%= String.format("%.2f", totalWaste) %> kg</span>
                </div>
                <div class="stat-item">
                    <strong>Total Records:</strong>
                    <span class="stat-value"><%= records.size() %></span>
                </div>
            </div>
            
            <%
                if (records != null && records.size() > 0) {
            %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Waste Type</th>
                            <th>Quantity (kg)</th>
                            <th>Location</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (WasteRecord record : records) {
                        %>
                            <tr>
                                <td><%= record.getDate() %></td>
                                <td><%= record.getWasteType() %></td>
                                <td><%= String.format("%.2f", record.getQuantity()) %></td>
                                <td><%= record.getLocation() %></td>
                                <td><%= record.getNotes() != null ? record.getNotes() : "-" %></td>
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
                    No waste records found. <a href="waste-collection.jsp">Log your first waste collection</a>
                </div>
            <%
                }
            %>
            
            <div class="button-group">
                <a href="waste-collection.jsp" class="btn btn-primary">Log Waste</a>
                <a href="dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
