package Model;

import java.math.BigDecimal;

/**
 * A type of service the municipality offers — for example "Citizenship
 * verification," "Birth certificate," "Building permit," etc.
 * <p>
 * Each {@link Application} a citizen submits is for exactly one service type.
 * The {@link #baseFee} drives how much the citizen is charged when they
 * apply, and {@link #isActive} lets admins retire a service without deleting
 * historical applications that referenced it.
 *
 * @author SarkarSathi
 */
public class ServiceType {
    private int serviceTypeId;
    private String serviceName;
    private String description;
    private BigDecimal baseFee;
    private boolean isActive;

    /**
     * Creates an empty service type.
     */
    public ServiceType() {
    }

    /**
     * Creates a fully-populated service type.
     *
     * @param serviceTypeId database primary key
     * @param serviceName   service name shown in the UI
     * @param description   longer description shown when applying
     * @param baseFee       fee charged for this service
     * @param isActive      whether citizens can currently apply for it
     */
    public ServiceType(int serviceTypeId, String serviceName, String description, BigDecimal baseFee, boolean isActive) {
        this.serviceTypeId = serviceTypeId;
        this.serviceName = serviceName;
        this.description = description;
        this.baseFee = baseFee;
        this.isActive = isActive;
    }

    /** @return the service type's database id */
    public int getServiceTypeId() {
        return serviceTypeId;
    }

    /** @param serviceTypeId new database id */
    public void setServiceTypeId(int serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    /** @return the service name shown in the UI */
    public String getServiceName() {
        return serviceName;
    }

    /** @param serviceName service name */
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    /** @return longer description of what this service is */
    public String getDescription() {
        return description;
    }

    /** @param description service description */
    public void setDescription(String description) {
        this.description = description;
    }

    /** @return the base fee charged when applying for this service */
    public BigDecimal getBaseFee() {
        return baseFee;
    }

    /** @param baseFee base fee for this service */
    public void setBaseFee(BigDecimal baseFee) {
        this.baseFee = baseFee;
    }

    /** @return {@code true} if this service is currently available */
    public boolean isActive() {
        return isActive;
    }

    /** @param active whether the service is currently available */
    public void setActive(boolean active) {
        isActive = active;
    }
}
