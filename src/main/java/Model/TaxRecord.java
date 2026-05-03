package Model;

import java.math.BigDecimal;

/**
 * A tax record owed by a single citizen for a single fiscal year — either a
 * house tax or a land tax.
 * <p>
 * When the citizen pays it, {@link #paymentId} is filled in with the
 * resulting {@link Payment#getPaymentId()} and {@link #isPaid} flips to true.
 *
 * @author SarkarSathi
 */
public class TaxRecord {
    private int taxId;
    private int citizenId;
    private String taxType;
    private String fiscalYear;
    private BigDecimal dueAmount;
    private int paymentId;
    private boolean isPaid;

    /**
     * Creates an empty tax record.
     */
    public TaxRecord() {
    }

    /**
     * Creates a fully-populated tax record.
     *
     * @param taxId       database primary key
     * @param citizenId   citizen who owes the tax
     * @param taxType     {@code house} or {@code land}
     * @param fiscalYear  fiscal year string
     * @param dueAmount   amount due
     * @param paymentId   id of the linked payment once paid, otherwise 0
     * @param isPaid      whether the tax has been paid
     */
    public TaxRecord(int taxId, int citizenId, String taxType, String fiscalYear,
                     BigDecimal dueAmount, int paymentId, boolean isPaid) {
        this.taxId = taxId;
        this.citizenId = citizenId;
        this.taxType = taxType;
        this.fiscalYear = fiscalYear;
        this.dueAmount = dueAmount;
        this.paymentId = paymentId;
        this.isPaid = isPaid;
    }

    /** @return the tax record's database id */
    public int getTaxId() {
        return taxId;
    }

    /** @param taxId new database id */
    public void setTaxId(int taxId) {
        this.taxId = taxId;
    }

    /** @return id of the citizen who owes the tax */
    public int getCitizenId() {
        return citizenId;
    }

    /** @param citizenId citizen who owes the tax */
    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    /** @return tax type string ({@code house} or {@code land}) */
    public String getTaxType() {
        return taxType;
    }

    /** @param taxType tax type string */
    public void setTaxType(String taxType) {
        this.taxType = taxType;
    }

    /** @return fiscal year string */
    public String getFiscalYear() {
        return fiscalYear;
    }

    /** @param fiscalYear fiscal year string */
    public void setFiscalYear(String fiscalYear) {
        this.fiscalYear = fiscalYear;
    }

    /** @return amount due */
    public BigDecimal getDueAmount() {
        return dueAmount;
    }

    /** @param dueAmount amount due */
    public void setDueAmount(BigDecimal dueAmount) {
        this.dueAmount = dueAmount;
    }

    /** @return id of the linked payment once paid, otherwise 0 */
    public int getPaymentId() {
        return paymentId;
    }

    /** @param paymentId id of the linked payment record */
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    /** @return {@code true} if this tax has been paid */
    public boolean isPaid() {
        return isPaid;
    }

    /** @param paid whether the tax has been paid */
    public void setPaid(boolean paid) {
        isPaid = paid;
    }
}
