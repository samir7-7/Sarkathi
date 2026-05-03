package Model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * A payment record — covers application/service fees as well as house and
 * land taxes. Linked to an {@link Application} via {@link #applicationId}.
 * <p>
 * Note: the platform tracks payments only as internal state; there is no
 * payment gateway integration (Khalti/eSewa) yet, so {@code completed} here
 * means "marked complete by an admin," not "money actually moved."
 *
 * @author SarkarSathi
 */
public class Payment {
    private int paymentId;
    private int applicationId;
    private BigDecimal amount;
    private String paymentType;
    private String status;
    private LocalDateTime paidAt;

    /**
     * Creates an empty payment.
     */
    public Payment() {
    }

    /**
     * Creates a fully-populated payment.
     *
     * @param paymentId      database primary key
     * @param applicationId  application this payment is for
     * @param amount         amount paid (or due)
     * @param paymentType    one of {@code service}, {@code housetax},
     *                       {@code landtax}
     * @param status         {@code pending} or {@code completed}
     * @param paidAt         when the payment was completed (null while pending)
     */
    public Payment(int paymentId, int applicationId, BigDecimal amount, String paymentType,
                   String status, LocalDateTime paidAt) {
        this.paymentId = paymentId;
        this.applicationId = applicationId;
        this.amount = amount;
        this.paymentType = paymentType;
        this.status = status;
        this.paidAt = paidAt;
    }

    /** @return the payment's database id */
    public int getPaymentId() {
        return paymentId;
    }

    /** @param paymentId new database id */
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    /** @return id of the application this payment is for */
    public int getApplicationId() {
        return applicationId;
    }

    /** @param applicationId application this payment is tied to */
    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    /** @return amount of the payment */
    public BigDecimal getAmount() {
        return amount;
    }

    /** @param amount payment amount */
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    /** @return type string ({@code service}, {@code housetax}, {@code landtax}) */
    public String getPaymentType() {
        return paymentType;
    }

    /** @param paymentType type of payment */
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    /** @return status string ({@code pending} or {@code completed}) */
    public String getStatus() {
        return status;
    }

    /** @param status payment status */
    public void setStatus(String status) {
        this.status = status;
    }

    /** @return when payment was completed, or {@code null} if still pending */
    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    /** @param paidAt completion timestamp */
    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }
}
