package com.wastemanagement.controller;

import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.model.User;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.UUID;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String ward = request.getParameter("ward");
        String address = request.getParameter("address");
        
        // Validate input
        if (name == null || name.isEmpty() || email == null || email.isEmpty() || 
            password == null || password.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (role == null || role.isEmpty()) {
            role = Constants.ROLE_CITIZEN;
        }
        
        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", Constants.USER_EXISTS);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Create new user with optional QR identity
        String qrCode = null;
        if (Constants.ROLE_CITIZEN.equals(role)) {
            qrCode = "CITIZEN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        }
        
        User user = new User(name, email, password, role, qrCode);
        user.setWard(ward);
        user.setAddress(address);
        user.setPoints(0);
        
        if (userDAO.registerUser(user)) {
            String successMsg = "Registration successful! ";
            if (qrCode != null) {
                successMsg += "Your citizen ID/QR is " + qrCode + ". ";
            }
            successMsg += "Please log in.";
            request.setAttribute("success", successMsg);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", Constants.DB_ERROR);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
