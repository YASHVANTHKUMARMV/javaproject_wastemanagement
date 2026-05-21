package com.wastemanagement.controller;

import com.wastemanagement.dao.RedemptionDAO;
import com.wastemanagement.dao.UserDAO;
import com.wastemanagement.model.Redemption;
import com.wastemanagement.model.User;
import com.wastemanagement.util.Constants;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * Servlet for citizen reward redemption requests.
 */
@WebServlet("/redeem")
public class RedemptionServlet extends HttpServlet {

    private RedemptionDAO redemptionDAO = new RedemptionDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_CITIZEN.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int citizenId = (Integer) session.getAttribute(Constants.SESSION_ID);
        int currentPoints = (Integer) session.getAttribute(Constants.SESSION_POINTS);
        String rewardType = request.getParameter("rewardType");
        String pointsStr = request.getParameter("pointsRequested");

        if (rewardType == null || rewardType.isEmpty() || pointsStr == null || pointsStr.isEmpty()) {
            request.setAttribute("error", "Please select a reward type and points amount.");
            request.getRequestDispatcher("redemption.jsp").forward(request, response);
            return;
        }

        try {
            int pointsRequested = Integer.parseInt(pointsStr);
            if (pointsRequested <= 0) {
                throw new NumberFormatException();
            }
            if (pointsRequested > currentPoints) {
                request.setAttribute("error", "Not enough points available for redemption.");
                request.getRequestDispatcher("redemption.jsp").forward(request, response);
                return;
            }

            Redemption redemption = new Redemption();
            redemption.setCitizenId(citizenId);
            redemption.setPointsRequested(pointsRequested);
            redemption.setRewardType(rewardType);
            redemption.setStatus(Constants.REDEMPTION_PENDING);

            if (redemptionDAO.createRedemption(redemption) && userDAO.updatePoints(citizenId, -pointsRequested)) {
                session.setAttribute(Constants.SESSION_POINTS, currentPoints - pointsRequested);
                request.setAttribute("success", "Redemption request submitted successfully.");
            } else {
                request.setAttribute("error", "Unable to complete redemption. Please try again.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Enter a valid points number.");
        }

        request.getRequestDispatcher("redemption.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !Constants.ROLE_CITIZEN.equals(session.getAttribute(Constants.SESSION_ROLE))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("redemption.jsp").forward(request, response);
    }
}
