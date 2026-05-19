package com.wastemanagement.controller;

import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.model.User;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * Servlet for handling user login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        User user = userDAO.authenticateUser(email, password);
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute(Constants.SESSION_USER, user.getName());
            session.setAttribute(Constants.SESSION_EMAIL, user.getEmail());
            session.setAttribute(Constants.SESSION_ID, user.getId());
            
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", Constants.INVALID_CREDENTIALS);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
