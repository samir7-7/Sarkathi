package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private int paymentId;
    private int applicationId;
    private BigDecimal amount;
    private String paymentType;
    private String status;
    private LocalDateTime paidAt;

    public Payment() {
    }

    public Payment(int paymentId, int applicationId, BigDecimal amount, String paymentType,
                   String status, LocalDateTime paidAt) {
        this.paymentId = paymentId;
        this.applicationId = applicationId;
        this.amount = amount;
        this.paymentType = paymentType;
        this.status = status;
        this.paidAt = paidAt;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }
}