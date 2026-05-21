<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redeem Points - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_CITIZEN.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
        int points = (Integer) session.getAttribute(Constants.SESSION_POINTS);
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
        <section class="content-section">
            <h1>Redeem Your Points</h1>
            <p class="subtitle">Submit a simple redemption request for rewards</p>

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
                    <strong>Available Points</strong>
                    <span class="stat-value"><%= points %></span>
                </div>
            </div>

            <form action="redeem" method="POST" class="form-grid" id="redeemForm">
                <div class="form-group">
                    <label for="rewardType">Reward Type:</label>
                    <select id="rewardType" name="rewardType" onchange="toggleUpi()" required>
                        <option value="">-- Select Reward Type --</option>
                        <option value="UPI Voucher">UPI Voucher</option>
                        <option value="Public Transport Credit">Public Transport Credit</option>
                    </select>
                </div>

                <div id="upiGroup" class="form-group" style="display: none;">
                    <label for="upiId">UPI ID (e.g. mobile@ybl, name@oksbi):</label>
                    <input type="text" id="upiId" name="upiId" placeholder="Enter your UPI ID">
                </div>

                <div class="form-group">
                    <label for="pointsRequested">Points to Redeem:</label>
                    <input type="number" id="pointsRequested" name="pointsRequested" min="1" max="<%= points %>" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Submit Redemption</button>
            </form>

            <!-- UPI Payment Simulation Modal -->
            <div id="upiModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(8px); z-index: 9999; align-items: center; justify-content: center;">
                <div style="background: #ffffff; color: #1f2937; border-radius: 24px; padding: 25px; max-width: 400px; width: 90%; text-align: center; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); border: 1px solid #e5e7eb;">
                    <!-- GPay Style Header -->
                    <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 20px; border-bottom: 1px solid #f3f4f6; padding-bottom: 12px; text-align: left;">
                        <span style="font-size: 1.4rem; background: #4f46e5; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold;">W</span>
                        <div>
                            <div style="font-weight: 700; font-size: 0.95rem; color: #111827;">Waste Management Portal</div>
                            <div style="font-size: 0.75rem; color: #6b7280;">UPI Reward Distribution</div>
                        </div>
                    </div>

                    <!-- Amount -->
                    <div style="margin: 25px 0;">
                        <div style="font-size: 0.8rem; color: #6b7280; text-transform: uppercase; letter-spacing: 1px; font-weight: 600;">Redemption Cash-out</div>
                        <div id="upiAmount" style="font-size: 3rem; font-weight: 800; color: #111827; margin: 5px 0;">Rs. 0.00</div>
                        <div id="upiReceiver" style="font-size: 0.85rem; color: #4b5563; font-weight: 500;">To: <span style="font-family: monospace; font-weight: 600;">-</span></div>
                    </div>

                    <!-- Loader -->
                    <div id="upiProcessing" style="display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 120px;">
                        <div class="spinner" style="border: 4px solid #f3f4f6; border-top: 4px solid #4f46e5; border-radius: 50%; width: 45px; height: 45px; animation: spin 1s infinite linear; margin-bottom: 15px;"></div>
                        <div id="upiStatus" style="font-weight: 600; color: #374151; font-size: 0.9rem;">Connecting to UPI Gateway...</div>
                    </div>

                    <!-- Success Animation -->
                    <div id="upiSuccess" style="display: none; flex-direction: column; align-items: center; justify-content: center; min-height: 120px;">
                        <div style="background: #10b981; width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; box-shadow: 0 4px 10px rgba(16,185,129,0.3);">
                            <span style="font-size: 2.2rem; color: white; font-weight: bold;">✓</span>
                        </div>
                        <div style="font-weight: 700; font-size: 1.15rem; color: #065f46; margin-bottom: 5px;">Transaction Successful</div>
                        <div style="font-size: 0.8rem; color: #047857;">Points converted and transferred!</div>
                    </div>
                </div>
            </div>

            <!-- CSS Spinner Animation -->
            <style>
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
                .spinner {
                    animation: spin 1s infinite linear;
                }
            </style>

            <script>
                function toggleUpi() {
                    var rewardType = document.getElementById("rewardType").value;
                    var upiGroup = document.getElementById("upiGroup");
                    var upiId = document.getElementById("upiId");
                    
                    if (rewardType === "UPI Voucher" || rewardType === "Public Transport Credit") {
                        upiGroup.style.display = "block";
                        upiId.required = true;
                    } else {
                        upiGroup.style.display = "none";
                        upiId.required = false;
                    }
                }

                document.getElementById("redeemForm").addEventListener("submit", function(e) {
                    e.preventDefault();
                    var form = this;

                    var points = parseInt(document.getElementById("pointsRequested").value) || 0;
                    var upiIdVal = document.getElementById("upiId").value;
                    var rewardTypeSelect = document.getElementById("rewardType");
                    var rewardTypeVal = rewardTypeSelect.value;

                    // Show GPay modal
                    var modal = document.getElementById("upiModal");
                    modal.style.display = "flex";
                    
                    // Set details
                    document.getElementById("upiAmount").innerText = "Rs. " + points + ".00";
                    document.getElementById("upiReceiver").querySelector("span").innerText = upiIdVal;

                    // Processing elements
                    var status = document.getElementById("upiStatus");
                    var upiProcessing = document.getElementById("upiProcessing");
                    var upiSuccess = document.getElementById("upiSuccess");

                    upiProcessing.style.display = "flex";
                    upiSuccess.style.display = "none";

                    setTimeout(function() {
                        status.innerText = "Verifying UPI ID Virtual Payment Address...";
                    }, 800);

                    setTimeout(function() {
                        status.innerText = "Processing transfer from Municipal Rewards fund...";
                    }, 1800);

                    setTimeout(function() {
                        upiProcessing.style.display = "none";
                        upiSuccess.style.display = "flex";
                        
                        // Dynamically append UPI ID to rewardType selection value
                        var newOpt = document.createElement("option");
                        newOpt.value = rewardTypeVal + " (UPI: " + upiIdVal + ")";
                        newOpt.selected = true;
                        rewardTypeSelect.appendChild(newOpt);

                        setTimeout(function() {
                            form.submit();
                        }, 1200);
                    }, 2800);
                });
            </script>

            <div class="button-group">
                <a href="rewards.jsp" class="btn btn-secondary">View Rewards History</a>
                <a href="citizenDashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </section>
    </div>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
