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
        String role = request.getParameter("role");
        String qrCode = request.getParameter("qrCode");
        
        User user = null;
        
        if (qrCode != null && !qrCode.isEmpty()) {
            user = userDAO.findByQrOrId(qrCode);
            if (user != null && !Constants.ROLE_CITIZEN.equals(user.getRole())) {
                request.setAttribute("error", "QR login is only available for Citizens");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        } else {
            // Validate input
            if (email == null || email.isEmpty() || password == null || password.isEmpty() || role == null || role.isEmpty()) {
                request.setAttribute("error", "Email, password and role are required");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Authenticate user
            user = userDAO.authenticateUser(email, password);
            
            if (user != null) {
                // Validate selected role
                if (!role.equalsIgnoreCase(user.getRole())) {
                    request.setAttribute("error", "Incorrect role selected for this account");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }
        }
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute(Constants.SESSION_USER, user.getName());
            session.setAttribute(Constants.SESSION_EMAIL, user.getEmail());
            session.setAttribute(Constants.SESSION_ID, user.getId());
            session.setAttribute(Constants.SESSION_ROLE, user.getRole());
            session.setAttribute(Constants.SESSION_QR, user.getQrCode());
            session.setAttribute(Constants.SESSION_POINTS, user.getPoints());
            
            if (Constants.ROLE_ADMIN.equals(user.getRole())) {
                response.sendRedirect("adminDashboard.jsp");
            } else if (Constants.ROLE_WORKER.equals(user.getRole())) {
                response.sendRedirect("workerDashboard.jsp");
            } else {
                response.sendRedirect("citizenDashboard.jsp");
            }
        } else {
            request.setAttribute("error", qrCode != null ? "Invalid QR Code" : Constants.INVALID_CREDENTIALS);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
