package com.wastemanagement.model;

/**
 * Model class for a worker collection session.
 */
public class CollectionSession {
    private int id;
    private int workerId;
    private int citizenId;
    private String qrCode;
    private double totalOrganic;
    private double totalDry;
    private double totalReject;
    private double totalCollected;
    private double segregationScore;
    private int pointsAwarded;
    private String notes;
    private String sessionDate;
    private String createdAt;

    public CollectionSession() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getWorkerId() {
        return workerId;
    }

    public void setWorkerId(int workerId) {
        this.workerId = workerId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public String getQrCode() {
        return qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }

    public double getTotalOrganic() {
        return totalOrganic;
    }

    public void setTotalOrganic(double totalOrganic) {
        this.totalOrganic = totalOrganic;
    }

    public double getTotalDry() {
        return totalDry;
    }

    public void setTotalDry(double totalDry) {
        this.totalDry = totalDry;
    }

    public double getTotalReject() {
        return totalReject;
    }

    public void setTotalReject(double totalReject) {
        this.totalReject = totalReject;
    }

    public double getTotalCollected() {
        return totalCollected;
    }

    public void setTotalCollected(double totalCollected) {
        this.totalCollected = totalCollected;
    }

    public double getSegregationScore() {
        return segregationScore;
    }

    public void setSegregationScore(double segregationScore) {
        this.segregationScore = segregationScore;
    }

    public int getPointsAwarded() {
        return pointsAwarded;
    }

    public void setPointsAwarded(int pointsAwarded) {
        this.pointsAwarded = pointsAwarded;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getSessionDate() {
        return sessionDate;
    }

    public void setSessionDate(String sessionDate) {
        this.sessionDate = sessionDate;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
