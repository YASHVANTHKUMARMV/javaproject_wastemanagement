package com.wastemanagement.controller;

import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.model.User;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

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
        
        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", Constants.USER_EXISTS);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User user = new User(name, email, password);
        
        if (userDAO.registerUser(user)) {
            request.setAttribute("success", "Registration successful! Please log in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", Constants.DB_ERROR);
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
