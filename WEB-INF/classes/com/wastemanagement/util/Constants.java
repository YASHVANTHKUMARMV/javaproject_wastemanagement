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
}
