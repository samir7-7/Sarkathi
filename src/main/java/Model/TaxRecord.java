package Model;

import java.math.BigDecimal;

public class TaxRecord {
    private int taxId;
    private int citizenId;
    private String taxType;
    private String fiscalYear;
    private BigDecimal dueAmount;
    private int paymentId;
    private boolean isPaid;

    public TaxRecord() {
    }

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

    public int getTaxId() {
        return taxId;
    }

    public void setTaxId(int taxId) {
        this.taxId = taxId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public String getTaxType() {
        return taxType;
    }

    public void setTaxType(String taxType) {
        this.taxType = taxType;
    }

    public String getFiscalYear() {
        return fiscalYear;
    }

    public void setFiscalYear(String fiscalYear) {
        this.fiscalYear = fiscalYear;
    }

    public BigDecimal getDueAmount() {
        return dueAmount;
    }

    public void setDueAmount(BigDecimal dueAmount) {
        this.dueAmount = dueAmount;
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public boolean isPaid() {
        return isPaid;
    }

    public void setPaid(boolean paid) {
        isPaid = paid;
    }
}