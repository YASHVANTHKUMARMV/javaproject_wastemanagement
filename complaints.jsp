<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.ComplaintsDAO" %>
<%@ page import="com.wastemanagement.dao.UserDAO" %>
<%@ page import="com.wastemanagement.model.Complaint" %>
<%@ page import="com.wastemanagement.model.User" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaints - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_ADMIN.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        ComplaintsDAO complaintsDAO = new ComplaintsDAO();
        UserDAO userDAO = new UserDAO();
        List<Complaint> allComplaints = complaintsDAO.getAllComplaints();
        List<Complaint> pendingComplaints = complaintsDAO.getComplaintsByStatus("PENDING");
        int pendingCount = pendingComplaints.size();
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
        <section class="content-section">
            <h1>Waste Segregation Complaints</h1>
            <p class="subtitle">Monitor low-segregation alerts and citizen issues</p>

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

            <div class="stats-summary">
                <div class="stat-item">
                    <strong>Pending Complaints</strong>
                    <span class="stat-value alert-danger" style="padding: 10px; border-radius: 5px; color: white;"><%= pendingCount %></span>
                </div>
                <div class="stat-item">
                    <strong>Total Complaints</strong>
                    <span class="stat-value"><%= allComplaints.size() %></span>
                </div>
            </div>

            <h2>All Complaints</h2>
            <%
                if (allComplaints.isEmpty()) {
            %>
                <div class="alert alert-info">No complaints recorded yet. Well done!</div>
            <%
                } else {
            %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Citizen</th>
                            <th>Worker</th>
                            <th>Type</th>
                            <th>Segregation %</th>
                            <th>Status</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Complaint complaint : allComplaints) {
                            User citizen = userDAO.getUserById(complaint.getCitizenId());
                            User worker = userDAO.getUserById(complaint.getWorkerId());
                            String citizenName = (citizen != null) ? citizen.getName() : "N/A";
                            String workerName = (worker != null) ? worker.getName() : "N/A";
                    %>
                        <tr>
                            <td><%= complaint.getCreatedAt() %></td>
                            <td><%= citizenName %></td>
                            <td><%= workerName %></td>
                            <td><%= complaint.getComplaintType() %></td>
                            <td><%= String.format("%.1f", complaint.getSegregationScore()) %>%</td>
                            <td>
                                <span class="status-badge status-<%= complaint.getStatus().toLowerCase() %>">
                                    <%= complaint.getStatus() %>
                                </span>
                            </td>
                            <td><%= complaint.getDescription() %></td>
                            <td>
                                <%
                                    if ("PENDING".equals(complaint.getStatus())) {
                                %>
                                    <form action="resolveComplaint" method="POST" style="display: inline;">
                                        <input type="hidden" name="complaintId" value="<%= complaint.getId() %>">
                                        <input type="hidden" name="status" value="RESOLVED">
                                        <textarea name="adminNotes" placeholder="Admin notes..." rows="2" cols="20" required></textarea>
                                        <button type="submit" class="btn btn-small btn-success">Resolve</button>
                                    </form>
                                <%
                                    } else {
                                %>
                                    <span class="text-muted">
                                        <%= complaint.getAdminNotes() != null ? complaint.getAdminNotes() : "-" %>
                                    </span>
                                <%
                                    }
                                %>
                            </td>
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
                <a href="adminDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
