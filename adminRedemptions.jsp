<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>
<%@ page import="com.wastemanagement.dao.RedemptionDAO" %>
<%@ page import="com.wastemanagement.dao.UserDAO" %>
<%@ page import="com.wastemanagement.model.Redemption" %>
<%@ page import="com.wastemanagement.model.User" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Redemptions - Smart Waste Monitoring System</title>
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

        RedemptionDAO redemptionDAO = new RedemptionDAO();
        UserDAO userDAO = new UserDAO();
        List<Redemption> redemptions = redemptionDAO.getAllRedemptions();
        
        int pendingCount = 0;
        for (Redemption r : redemptions) {
            if (Constants.REDEMPTION_PENDING.equals(r.getStatus())) {
                pendingCount++;
            }
        }
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
            <h1>Reward Redemptions</h1>
            <p class="subtitle">Review and approve citizen reward redemption requests (UPI Vouchers, Public Transport Credits)</p>

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
                    <strong>Pending Requests</strong>
                    <span class="stat-value <%= pendingCount > 0 ? "alert-warning" : "" %>" style="padding: 5px 15px; border-radius: 5px;"><%= pendingCount %></span>
                </div>
                <div class="stat-item">
                    <strong>Total Requests</strong>
                    <span class="stat-value"><%= redemptions.size() %></span>
                </div>
            </div>

            <h2>All Redemption Requests</h2>
            <%
                if (redemptions.isEmpty()) {
            %>
                <div class="alert alert-info">No redemption requests recorded yet.</div>
            <%
                } else {
            %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Citizen Name</th>
                            <th>Points Requested</th>
                            <th>Reward Type</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Redemption redemption : redemptions) {
                            User citizen = userDAO.getUserById(redemption.getCitizenId());
                            String citizenName = citizen != null ? citizen.getName() : "Unknown (ID: " + redemption.getCitizenId() + ")";
                            String statusClass = "";
                            if (Constants.REDEMPTION_PENDING.equals(redemption.getStatus())) {
                                statusClass = "status-pending";
                            } else if (Constants.REDEMPTION_APPROVED.equals(redemption.getStatus())) {
                                statusClass = "status-approved";
                            } else {
                                statusClass = "status-rejected";
                            }
                    %>
                        <tr>
                            <td><%= redemption.getCreatedAt() %></td>
                            <td><%= citizenName %></td>
                            <td><strong><%= redemption.getPointsRequested() %></strong> pts</td>
                            <td><%= redemption.getRewardType() %></td>
                            <td><span class="status-badge <%= statusClass %>"><%= redemption.getStatus() %></span></td>
                            <td>
                                <%
                                    if (Constants.REDEMPTION_PENDING.equals(redemption.getStatus())) {
                                %>
                                    <div style="display: flex; gap: 0.5rem;">
                                        <form action="adminRedemptions" method="POST" style="margin: 0;">
                                            <input type="hidden" name="redemptionId" value="<%= redemption.getId() %>">
                                            <input type="hidden" name="action" value="approve">
                                            <button type="submit" class="btn btn-small btn-success">Approve</button>
                                        </form>
                                        <form action="adminRedemptions" method="POST" style="margin: 0;">
                                            <input type="hidden" name="redemptionId" value="<%= redemption.getId() %>">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn btn-small btn-danger">Reject</button>
                                        </form>
                                    </div>
                                <%
                                    } else {
                                %>
                                    <span class="text-muted">Processed</span>
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
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
