package Model;

import java.time.LocalDateTime;

public class Application {
    private int applicationId;
    private String trackingId;
    private int citizenId;
    private int serviceTypeId;
    private int wardId;
    private String status;
    private LocalDateTime submittedAt;
    private String formData;
    private LocalDateTime lastUpdatedAt;
    private String remarks;
    private int reviewedByAdminId;

    public Application() {
    }

    public Application(int applicationId, String trackingId, int citizenId, int serviceTypeId, int wardId,
                       String status, LocalDateTime submittedAt, String formData, LocalDateTime lastUpdatedAt,
                       String remarks, int reviewedByAdminId) {
        this.applicationId = applicationId;
        this.trackingId = trackingId;
        this.citizenId = citizenId;
        this.serviceTypeId = serviceTypeId;
        this.wardId = wardId;
        this.status = status;
        this.submittedAt = submittedAt;
        this.formData = formData;
        this.lastUpdatedAt = lastUpdatedAt;
        this.remarks = remarks;
        this.reviewedByAdminId = reviewedByAdminId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public int getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(int serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    public int getWardId() {
        return wardId;
    }

    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public String getFormData() {
        return formData;
    }

    public void setFormData(String formData) {
        this.formData = formData;
    }

    public LocalDateTime getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    public void setLastUpdatedAt(LocalDateTime lastUpdatedAt) {
        this.lastUpdatedAt = lastUpdatedAt;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public int getReviewedByAdminId() {
        return reviewedByAdminId;
    }

    public void setReviewedByAdminId(int reviewedByAdminId) {
        this.reviewedByAdminId = reviewedByAdminId;
    }
}