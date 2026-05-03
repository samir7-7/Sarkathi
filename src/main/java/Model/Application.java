package Model;

import java.time.LocalDateTime;

/**
 * A service application a citizen has submitted — for a permit, certificate,
 * or any other municipal service. This is the central workhorse entity of
 * SarkarSathi: most of the citizen and admin workflows revolve around it.
 * <p>
 * The lifecycle moves through four statuses:
 * {@code submitted} → {@code review} → {@code approved} or {@code rejected}.
 * Whenever the status changes, a {@link Notification} is created for the
 * citizen. Each application also carries a unique {@link #trackingId} (a UUID)
 * so the public can look up status without logging in.
 * <p>
 * The {@link #formData} field stores the service-specific form fields as a
 * JSON blob — this keeps the schema flexible (different services need
 * different fields) at the cost of having to parse JSON when displaying.
 *
 * @author SarkarSathi
 */
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
    private String serviceTypeName;

    /**
     * Creates an empty application. Used by DAO row mappers and by servlets
     * that build an application up field-by-field from form parameters.
     */
    public Application() {
    }

    /**
     * Creates a fully-populated application.
     *
     * @param applicationId     database primary key
     * @param trackingId        public-facing UUID for status lookup
     * @param citizenId         id of the citizen who submitted it
     * @param serviceTypeId     which service this application is for
     * @param wardId            ward responsible for processing
     * @param status            current status ({@code submitted}, {@code review},
     *                          {@code approved}, {@code rejected})
     * @param submittedAt       timestamp the citizen submitted it
     * @param formData          JSON blob of service-specific form fields
     * @param lastUpdatedAt     timestamp of the last status change or edit
     * @param remarks           admin remarks (often the rejection reason)
     * @param reviewedByAdminId id of the admin currently handling it,
     *                          or 0 if untouched
     */
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

    /**
     * Convenience accessor for the joined service type name. The DAO sets this
     * when it joins {@code applications} against {@code service_types}, so the
     * UI doesn't need to do a second lookup.
     *
     * @return service type name, or {@code null} if it wasn't joined in
     */
    public String getServiceTypeName() {
        return serviceTypeName;
    }

    /** @param serviceTypeName joined-in service type name */
    public void setServiceTypeName(String serviceTypeName) {
        this.serviceTypeName = serviceTypeName;
    }

    /** @return the application's database id */
    public int getApplicationId() {
        return applicationId;
    }

    /** @param applicationId new database id */
    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    /** @return the public tracking id (UUID) */
    public String getTrackingId() {
        return trackingId;
    }

    /** @param trackingId the public tracking id */
    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    /** @return id of the citizen who submitted this application */
    public int getCitizenId() {
        return citizenId;
    }

    /** @param citizenId id of the submitting citizen */
    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    /** @return id of the service type this application is for */
    public int getServiceTypeId() {
        return serviceTypeId;
    }

    /** @param serviceTypeId service type id */
    public void setServiceTypeId(int serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    /** @return id of the ward processing this application */
    public int getWardId() {
        return wardId;
    }

    /** @param wardId processing ward id */
    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    /** @return current status string */
    public String getStatus() {
        return status;
    }

    /**
     * @param status one of {@code submitted}, {@code review}, {@code approved},
     *               {@code rejected}
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /** @return when the citizen first submitted this application */
    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    /** @param submittedAt submission timestamp */
    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    /**
     * @return raw JSON blob of service-specific form fields
     */
    public String getFormData() {
        return formData;
    }

    /** @param formData raw JSON blob */
    public void setFormData(String formData) {
        this.formData = formData;
    }

    /** @return timestamp of the most recent change */
    public LocalDateTime getLastUpdatedAt() {
        return lastUpdatedAt;
    }

    /** @param lastUpdatedAt last-updated timestamp */
    public void setLastUpdatedAt(LocalDateTime lastUpdatedAt) {
        this.lastUpdatedAt = lastUpdatedAt;
    }

    /**
     * @return admin remarks for this application — often a rejection reason
     *         or instructions for the citizen
     */
    public String getRemarks() {
        return remarks;
    }

    /** @param remarks admin remarks shown to the citizen */
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    /**
     * @return id of the admin currently handling this application, or 0 if no
     *         admin has picked it up yet
     */
    public int getReviewedByAdminId() {
        return reviewedByAdminId;
    }

    /** @param reviewedByAdminId id of the reviewing admin */
    public void setReviewedByAdminId(int reviewedByAdminId) {
        this.reviewedByAdminId = reviewedByAdminId;
    }
}
