package com.wastemanagement.model;

/**
 * WasteRecord model class for waste collection entries
 */
public class WasteRecord {
    
    private int id;
    private int userId;
    private String wasteType;
    private double quantity;
    private String unit;
    private String location;
    private String date;
    private String notes;
    
    // Constructors
    public WasteRecord() {
    }
    
    public WasteRecord(int userId, String wasteType, double quantity, String location, String date) {
        this.userId = userId;
        this.wasteType = wasteType;
        this.quantity = quantity;
        this.location = location;
        this.date = date;
        this.unit = "kg";
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getWasteType() {
        return wasteType;
    }
    
    public void setWasteType(String wasteType) {
        this.wasteType = wasteType;
    }
    
    public double getQuantity() {
        return quantity;
    }
    
    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getDate() {
        return date;
    }
    
    public void setDate(String date) {
        this.date = date;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
}
