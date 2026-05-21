package com.wastemanagement.controller;

import com.wastemanagement.dao.ComplaintsDAO;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * Servlet for resolving complaints
 */
@WebServlet("/resolveComplaint")
public class ComplaintsServlet extends HttpServlet {

    private ComplaintsDAO complaintsDAO = new ComplaintsDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_ADMIN.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String complaintIdStr = request.getParameter("complaintId");
        String status = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");

        if (complaintIdStr == null || complaintIdStr.isEmpty() || status == null || status.isEmpty()) {
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("complaints.jsp").forward(request, response);
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            if (complaintsDAO.updateComplaintStatus(complaintId, status, adminNotes != null ? adminNotes : "")) {
                request.setAttribute("success", "Complaint resolved successfully.");
            } else {
                request.setAttribute("error", "Unable to update complaint.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid complaint ID.");
        }

        request.getRequestDispatcher("complaints.jsp").forward(request, response);
    }
}
