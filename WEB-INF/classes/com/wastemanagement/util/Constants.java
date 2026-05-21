package com.wastemanagement.util;

/**
 * Application constants and messages
 */
public class Constants {
    
    // Messages
    public static final String SUCCESS = "success";
    public static final String ERROR = "error";
    public static final String INVALID_INPUT = "Invalid input parameters";
    public static final String DB_ERROR = "Database error occurred";
    public static final String USER_EXISTS = "User already exists";
    public static final String INVALID_CREDENTIALS = "Invalid email or password";
    public static final String LOGIN_REQUIRED = "Please login first";
    
    // Waste Types
    public static final String[] WASTE_TYPES = {
        "Plastic",
        "Paper",
        "Glass",
        "Metal",
        "Organic",
        "E-Waste",
        "Other"
    };
    
    // Session Attributes
    public static final String SESSION_USER = "user";
    public static final String SESSION_EMAIL = "email";
    public static final String SESSION_ID = "userId";
    public static final String SESSION_ROLE = "role";
    public static final String SESSION_QR = "qrCode";
    public static final String SESSION_POINTS = "points";

    // Roles
    public static final String ROLE_CITIZEN = "CITIZEN";
    public static final String ROLE_WORKER = "WORKER";
    public static final String ROLE_ADMIN = "ADMIN";

    // Redemption statuses
    public static final String REDEMPTION_PENDING = "PENDING";
    public static final String REDEMPTION_APPROVED = "APPROVED";
    public static final String REDEMPTION_REJECTED = "REJECTED";
}
