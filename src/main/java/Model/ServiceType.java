package Model;

import java.math.BigDecimal;

public class ServiceType {
    private int serviceTypeId;
    private String serviceName;
    private String description;
    private BigDecimal baseFee;
    private boolean isActive;

    public ServiceType() {
    }

    public ServiceType(int serviceTypeId, String serviceName, String description, BigDecimal baseFee, boolean isActive) {
        this.serviceTypeId = serviceTypeId;
        this.serviceName = serviceName;
        this.description = description;
        this.baseFee = baseFee;
        this.isActive = isActive;
    }

    public int getServiceTypeId() {
        return serviceTypeId;
    }

    public void setServiceTypeId(int serviceTypeId) {
        this.serviceTypeId = serviceTypeId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBaseFee() {
        return baseFee;
    }

    public void setBaseFee(BigDecimal baseFee) {
        this.baseFee = baseFee;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}