<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
    <div class="container auth-container">
        <div class="auth-box">
            <h2>Create Account</h2>
            
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
            
            <form action="register" method="POST">
                <div class="form-group">
                    <label for="name">Full Name:</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="role">Role:</label>
                    <select id="role" name="role" onchange="toggleCitizenFields()" required>
                        <option value="CITIZEN" selected>Citizen</option>
                        <option value="WORKER">Sanitation Worker</option>
                        <option value="ADMIN">Municipal Officer (Admin)</option>
                    </select>
                </div>

                <div id="citizenFields">
                    <div class="form-group">
                        <label for="ward">Ward:</label>
                        <select id="ward" name="ward">
                            <option value="">-- Select Ward --</option>
                            <option value="Ward 1">Ward 1 - Green Glen</option>
                            <option value="Ward 2">Ward 2 - Sunnyvale</option>
                            <option value="Ward 3">Ward 3 - Riverside</option>
                            <option value="Ward 4">Ward 4 - Metro Center</option>
                            <option value="Ward 5">Ward 5 - Industrial Park</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address:</label>
                        <textarea id="address" name="address" rows="2" placeholder="Enter your full street address"></textarea>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Register</button>
            </form>
            
            <p class="auth-link">Already have an account? <a href="login.jsp">Login here</a></p>
            <p class="auth-link"><a href="index.jsp">Back to Home</a></p>
        </div>
    </div>

    <script>
        function toggleCitizenFields() {
            var roleSelect = document.getElementById("role");
            var citizenFields = document.getElementById("citizenFields");
            var wardInput = document.getElementById("ward");
            var addressInput = document.getElementById("address");
            
            if (roleSelect.value === "CITIZEN") {
                citizenFields.style.display = "block";
                wardInput.required = true;
                addressInput.required = true;
            } else {
                citizenFields.style.display = "none";
                wardInput.required = false;
                addressInput.required = false;
            }
        }
        document.addEventListener("DOMContentLoaded", toggleCitizenFields);
    </script>
</body>
</html>
