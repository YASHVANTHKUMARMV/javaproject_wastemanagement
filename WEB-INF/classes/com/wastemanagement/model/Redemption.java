package com.wastemanagement.model;

/**
 * Model class for a citizen redemption request.
 */
public class Redemption {
    private int id;
    private int citizenId;
    private int pointsRequested;
    private String rewardType;
    private String status;
    private String createdAt;
    private String updatedAt;

    public Redemption() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public int getPointsRequested() {
        return pointsRequested;
    }

    public void setPointsRequested(int pointsRequested) {
        this.pointsRequested = pointsRequested;
    }

    public String getRewardType() {
        return rewardType;
    }

    public void setRewardType(String rewardType) {
        this.rewardType = rewardType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
}
