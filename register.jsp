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
                
                <button type="submit" class="btn btn-primary btn-block">Register</button>
            </form>
            
            <p class="auth-link">Already have an account? <a href="login.jsp">Login here</a></p>
            <p class="auth-link"><a href="index.jsp">Back to Home</a></p>
        </div>
    </div>
</body>
</html>
