package com.wastemanagement.controller;

import com.wastemanagement.dao.WasteDAO;
import com.wastemanagement.model.WasteRecord;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Servlet for handling waste collection records
 */
@WebServlet("/waste")
public class WasteServlet extends HttpServlet {
    
    private WasteDAO wasteDAO = new WasteDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_ID) == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute(Constants.SESSION_ID);
        
        String wasteType = request.getParameter("wasteType");
        String quantityStr = request.getParameter("quantity");
        String location = request.getParameter("location");
        String notes = request.getParameter("notes");
        
        // Validate input
        if (wasteType == null || wasteType.isEmpty() || quantityStr == null || 
            quantityStr.isEmpty() || location == null || location.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("waste-collection.jsp").forward(request, response);
            return;
        }
        
        try {
            double quantity = Double.parseDouble(quantityStr);
            
            WasteRecord record = new WasteRecord(
                userId,
                wasteType,
                quantity,
                location,
                LocalDate.now().toString()
            );
            record.setNotes(notes != null ? notes : "");
            
            if (wasteDAO.addWasteRecord(record)) {
                request.setAttribute("success", "Waste record added successfully!");
                request.getRequestDispatcher("waste-collection.jsp").forward(request, response);
            } else {
                request.setAttribute("error", Constants.DB_ERROR);
                request.getRequestDispatcher("waste-collection.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid quantity format");
            request.getRequestDispatcher("waste-collection.jsp").forward(request, response);
        }
    }
}
