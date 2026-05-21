package com.wastemanagement.model;

/**
 * User model class representing a user in the system
 */
public class User {
    
    private int id;
    private String name;
    private String email;
    private String password;
    private String role;
    private String ward;
    private String address;
    private String qrCode;
    private int points;
    private String createdAt;
    
    // Constructors
    public User() {
    }
    
    public User(String name, String email, String password) {
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    public User(int id, String name, String email, String password) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    public User(String name, String email, String password, String role, String qrCode) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
        this.qrCode = qrCode;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getQrCode() {
        return qrCode;
    }
    
    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }
    
    public int getPoints() {
        return points;
    }
    
    public void setPoints(int points) {
        this.points = points;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getWard() {
        return ward;
    }
    
    public void setWard(String ward) {
        this.ward = ward;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
}
