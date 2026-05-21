package com.wastemanagement.controller;

import com.wastemanagement.dao.RedemptionDAO;
import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.model.Redemption;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/adminRedemptions")
public class AdminRedemptionServlet extends HttpServlet {

    private RedemptionDAO redemptionDAO = new RedemptionDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_ADMIN.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String redemptionIdStr = request.getParameter("redemptionId");
        String action = request.getParameter("action"); // "approve" or "reject"

        if (redemptionIdStr == null || redemptionIdStr.isEmpty() || action == null || action.isEmpty()) {
            request.setAttribute("error", "Missing required parameters.");
            request.getRequestDispatcher("adminRedemptions.jsp").forward(request, response);
            return;
        }

        try {
            int redemptionId = Integer.parseInt(redemptionIdStr);
            Redemption redemption = redemptionDAO.getRedemptionById(redemptionId);
            if (redemption == null) {
                request.setAttribute("error", "Redemption request not found.");
            } else if (!Constants.REDEMPTION_PENDING.equals(redemption.getStatus())) {
                request.setAttribute("error", "Redemption request is already processed.");
            } else {
                if ("approve".equalsIgnoreCase(action)) {
                    if (redemptionDAO.updateRedemptionStatus(redemptionId, Constants.REDEMPTION_APPROVED)) {
                        request.setAttribute("success", "Redemption request approved successfully.");
                    } else {
                        request.setAttribute("error", "Unable to approve redemption request.");
                    }
                } else if ("reject".equalsIgnoreCase(action)) {
                    if (redemptionDAO.updateRedemptionStatus(redemptionId, Constants.REDEMPTION_REJECTED) 
                        && userDAO.updatePoints(redemption.getCitizenId(), redemption.getPointsRequested())) {
                        request.setAttribute("success", "Redemption request rejected and points refunded.");
                    } else {
                        request.setAttribute("error", "Unable to reject/refund redemption request.");
                    }
                } else {
                    request.setAttribute("error", "Invalid action.");
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid redemption ID format.");
        }

        request.getRequestDispatcher("adminRedemptions.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_ADMIN.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("adminRedemptions.jsp").forward(request, response);
    }
}
