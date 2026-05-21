package com.wastemanagement.controller;

import com.wastemanagement.dao.CollectionDAO;
import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.dao.ComplaintsDAO;
import com.wastemanagement.model.CollectionSession;
import com.wastemanagement.model.Complaint;
import com.wastemanagement.model.User;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.time.LocalDate;

/**
 * Servlet for worker-managed waste collection sessions.
 */
@WebServlet("/collect")
public class CollectionServlet extends HttpServlet {

    private CollectionDAO collectionDAO = new CollectionDAO();
    private UserDAO userDAO = new UserDAO();
    private ComplaintsDAO complaintsDAO = new ComplaintsDAO();
    private String escapeJson(String val) {
        if (val == null) return "";
        return val.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\b", "\\b")
                  .replace("\f", "\\f")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String lookup = request.getParameter("lookup");
        if (lookup == null || lookup.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"error\":\"No lookup parameter provided\"}");
            return;
        }
        
        User citizen = userDAO.findByQrOrId(lookup.trim());
        if (citizen != null && Constants.ROLE_CITIZEN.equals(citizen.getRole())) {
            String json = String.format(
                "{\"success\":true,\"name\":\"%s\",\"ward\":\"%s\",\"address\":\"%s\",\"points\":%d}",
                escapeJson(citizen.getName()),
                escapeJson(citizen.getWard()),
                escapeJson(citizen.getAddress()),
                citizen.getPoints()
            );
            response.getWriter().write(json);
        } else {
            response.getWriter().write("{\"success\":false,\"error\":\"Citizen not found for provided QR/ID\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_WORKER.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int workerId = (Integer) session.getAttribute(Constants.SESSION_ID);
        String lookup = request.getParameter("citizenLookup");
        String organicStr = request.getParameter("organicWeight");
        String dryStr = request.getParameter("dryWeight");
        String rejectStr = request.getParameter("rejectWeight");
        String rewardType = request.getParameter("rewardType");
        String notes = request.getParameter("notes");

        if (lookup == null || lookup.isEmpty()) {
            request.setAttribute("error", "Enter citizen QR code or ID.");
            request.getRequestDispatcher("collectionForm.jsp").forward(request, response);
            return;
        }

        User citizen = userDAO.findByQrOrId(lookup);
        if (citizen == null || !Constants.ROLE_CITIZEN.equals(citizen.getRole())) {
            request.setAttribute("error", "Citizen not found for provided QR/ID.");
            request.getRequestDispatcher("collectionForm.jsp").forward(request, response);
            return;
        }

        try {
            double organic = Double.parseDouble(organicStr != null ? organicStr : "0");
            double dry = Double.parseDouble(dryStr != null ? dryStr : "0");
            double reject = Double.parseDouble(rejectStr != null ? rejectStr : "0");

            if (organic < 0 || dry < 0 || reject < 0) {
                throw new NumberFormatException("Negative weights are not allowed");
            }

            double total = organic + dry + reject;
            if (total <= 0) {
                request.setAttribute("error", "At least one category must have a positive weight.");
                request.getRequestDispatcher("collectionForm.jsp").forward(request, response);
                return;
            }

            double segregationScore = (organic + dry) / total * 100.0;
            int pointsAwarded = (int) Math.max(1, Math.round((organic + dry) * 2 + segregationScore / 10.0));

            CollectionSession sessionRecord = new CollectionSession();
            sessionRecord.setWorkerId(workerId);
            sessionRecord.setCitizenId(citizen.getId());
            sessionRecord.setQrCode(citizen.getQrCode());
            sessionRecord.setTotalOrganic(organic);
            sessionRecord.setTotalDry(dry);
            sessionRecord.setTotalReject(reject);
            sessionRecord.setTotalCollected(total);
            sessionRecord.setSegregationScore(segregationScore);
            sessionRecord.setPointsAwarded(pointsAwarded);
            sessionRecord.setNotes(notes != null ? notes : "");
            sessionRecord.setSessionDate(LocalDate.now().toString());

            if (collectionDAO.addSession(sessionRecord)) {
                userDAO.updatePoints(citizen.getId(), pointsAwarded);
                
                // Check if segregation score is below threshold and create complaint if needed
                final double SEGREGATION_THRESHOLD = 70.0;
                if (segregationScore < SEGREGATION_THRESHOLD) {
                    Complaint complaint = new Complaint();
                    complaint.setCitizenId(citizen.getId());
                    complaint.setWorkerId(workerId);
                    complaint.setSessionId(sessionRecord.getId());
                    complaint.setComplaintType("LOW_SEGREGATION");
                    complaint.setSegregationScore(segregationScore);
                    complaint.setDescription("Citizen " + citizen.getName() + " had low waste segregation score of " + String.format("%.1f", segregationScore) + "% (threshold: " + SEGREGATION_THRESHOLD + "%)");
                    complaint.setStatus("PENDING");
                    
                    complaintsDAO.createComplaint(complaint);
                    request.setAttribute("warning", "[WARNING] Low segregation score (" + String.format("%.1f", segregationScore) + "%). Complaint logged for admin review.");
                }
                
                request.setAttribute("success", "Collection saved. " + pointsAwarded + " points awarded to " + citizen.getName() + "!");
            } else {
                request.setAttribute("error", "Unable to save collection session.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid weight values. Use numeric values only.");
        }

        request.getRequestDispatcher("collectionForm.jsp").forward(request, response);
    }
}
