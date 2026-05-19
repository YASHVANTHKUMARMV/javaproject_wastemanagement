<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="error-page">
    <div class="container error-container">
        <div class="error-box">
            <h1>Oops! Something went wrong</h1>
            <p>Error Code: <%= response.getStatus() %></p>
            
            <p>
                <% 
                    Object message = request.getAttribute("jakarta.servlet.error.message");
                    if (message != null) {
                %>
                        <%= message %>
                <% 
                    }
                %>
            </p>
            
            <div class="button-group">
                <a href="index.jsp" class="btn btn-primary">Go to Home</a>
                <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
            </div>
        </div>
    </div>
</body>
</html>
