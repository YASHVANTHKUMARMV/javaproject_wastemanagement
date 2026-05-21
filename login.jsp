<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.wastemanagement.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        @keyframes laserSweep {
            0% { top: 0%; opacity: 0; }
            10% { opacity: 1; }
            90% { opacity: 1; }
            100% { top: 100%; opacity: 0; }
        }
    </style>
</head>
<body class="auth-page">
    <div class="container auth-container">
        <div class="auth-box">
            <h2>Login</h2>
            
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
            
            <div class="login-tabs" style="display: flex; gap: 10px; margin-bottom: 20px;">
                <button type="button" id="tabStandard" class="btn btn-small btn-primary" style="flex: 1;" onclick="switchLoginMode('standard')">Standard Login</button>
                <button type="button" id="tabQr" class="btn btn-small btn-secondary" style="flex: 1;" onclick="switchLoginMode('qr')">Scan QR Image</button>
            </div>

            <div id="standardForm">
                <form action="login" method="POST">
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="role">Role:</label>
                        <select id="role" name="role" required>
                            <option value="CITIZEN" selected>Citizen</option>
                            <option value="WORKER">Sanitation Worker</option>
                            <option value="ADMIN">Municipal Officer (Admin)</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </form>
            </div>

            <div id="qrForm" style="display: none; text-align: center;">
                <div class="qr-scanner-box" style="border: 2px dashed var(--primary); padding: 20px; border-radius: 12px; margin-bottom: 15px; position: relative; overflow: hidden; background: rgba(255,255,255,0.5);">
                    <div class="scanner-viewfinder" style="height: 120px; display: flex; flex-direction: column; align-items: center; justify-content: center; position: relative;">
                        <span id="scanStatus" style="font-weight: 600; z-index: 2; color: var(--text-dark); background: rgba(255,255,255,0.8); padding: 5px 10px; border-radius: 4px;">Ready to Scan</span>
                        <div id="scannerLaser" style="display: none; position: absolute; left: 0; right: 0; height: 3px; background: #ef4444; box-shadow: 0 0 8px #ef4444; animation: laserSweep 2s infinite linear; z-index: 1;"></div>
                    </div>
                    <input type="file" id="qrFileInput" accept="image/*" style="display: none;" onchange="handleQrUpload(event)">
                    <button type="button" class="btn btn-secondary btn-block" onclick="document.getElementById('qrFileInput').click()">Upload Citizen QR Image</button>
                </div>
                
                <div class="qr-simulator" style="border-top: 1px solid var(--border-color); padding-top: 15px; text-align: left;">
                    <label style="font-weight: 500; font-size: 0.85rem; color: var(--text-light);">Quick Test (Simulate Scan):</label>
                    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 5px;">
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs2 = null;
                        int count = 0;
                        try {
                            conn = DBConnection.getConnection();
                            if (conn != null) {
                                stmt = conn.createStatement();
                                rs2 = stmt.executeQuery("SELECT name, qr_code FROM users WHERE role = 'CITIZEN' AND qr_code IS NOT NULL LIMIT 3");
                                while (rs2.next()) {
                                    String cName = rs2.getString("name");
                                    String cQr = rs2.getString("qr_code");
                                    count++;
                    %>
                                    <button type="button" class="btn btn-small btn-secondary" style="font-size: 0.75rem; padding: 4px 8px;" onclick="simulateQrScan('<%= cQr %>')"><%= cName %> (<%= cQr %>)</button>
                    <%
                                }
                            }
                        } catch (Exception e) {
                            // ignore
                        } finally {
                            if (rs2 != null) try { rs2.close(); } catch(Exception e){}
                            if (stmt != null) try { stmt.close(); } catch(Exception e){}
                            if (conn != null) try { DBConnection.closeConnection(conn); } catch(Exception e){}
                        }
                        if (count == 0) {
                    %>
                            <button type="button" class="btn btn-small btn-secondary" onclick="simulateQrScan('CITIZEN-001')">Demo Citizen (CITIZEN-001)</button>
                    <%
                        }
                    %>
                    </div>
                </div>

                <form id="qrSubmitForm" action="login" method="POST" style="display: none;">
                    <input type="hidden" name="qrCode" id="hiddenQrInput">
                </form>
            </div>
            
            <p class="auth-link" style="margin-top: 20px;">Don't have an account? <a href="register.jsp">Register here</a></p>
            <p class="auth-link"><a href="index.jsp">Back to Home</a></p>

            <script>
                function switchLoginMode(mode) {
                    var standardForm = document.getElementById("standardForm");
                    var qrForm = document.getElementById("qrForm");
                    var tabStandard = document.getElementById("tabStandard");
                    var tabQr = document.getElementById("tabQr");
                    
                    if (mode === 'standard') {
                        standardForm.style.display = "block";
                        qrForm.style.display = "none";
                        tabStandard.className = "btn btn-small btn-primary";
                        tabQr.className = "btn btn-small btn-secondary";
                    } else {
                        standardForm.style.display = "none";
                        qrForm.style.display = "block";
                        tabStandard.className = "btn btn-small btn-secondary";
                        tabQr.className = "btn btn-small btn-primary";
                    }
                }

                function handleQrUpload(event) {
                    var file = event.target.files[0];
                    if (!file) return;
                    runScannerAnimation(file.name);
                }

                function simulateQrScan(qrValue) {
                    runScannerAnimation(qrValue);
                }

                function runScannerAnimation(qrText) {
                    var laser = document.getElementById("scannerLaser");
                    var status = document.getElementById("scanStatus");
                    
                    laser.style.display = "block";
                    status.innerText = "Analyzing QR Image...";
                    status.style.color = "var(--primary)";
                    
                    setTimeout(function() {
                        status.innerText = "Decoding metadata...";
                    }, 1000);
                    
                    setTimeout(function() {
                        var match = qrText.match(/CITIZEN-[A-Z0-9-]+/i);
                        var finalQr = match ? match[0].toUpperCase() : qrText.toUpperCase();
                        
                        laser.style.display = "none";
                        status.innerText = "Success! ID: " + finalQr;
                        status.style.color = "var(--success)";
                        
                        document.getElementById("hiddenQrInput").value = finalQr;
                        
                        setTimeout(function() {
                            document.getElementById("qrSubmitForm").submit();
                        }, 800);
                    }, 2000);
                }
            </script>
        </div>
    </div>
</body>
</html>
