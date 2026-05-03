package Model;

import java.time.LocalDateTime;

/**
 * A certificate that an admin has issued to a citizen as the result of an
 * approved {@link Application}.
 * <p>
 * Each certificate is tied 1:1 to an application and carries a unique
 * {@link #certificateNo}. The {@link #pdfFilePath} is meant to point at the
 * generated PDF — note that PDF generation itself is not yet implemented in
 * this codebase, so for now the field may be null or a placeholder.
 *
 * @author SarkarSathi
 */
public class IssuedCertificate {
    private int certificateId;
    private int applicationId;
    private String certificateNo;
    private LocalDateTime issuedAt;
    private String pdfFilePath;
    private int issuedByAdminId;

    /**
     * Creates an empty certificate record.
     */
    public IssuedCertificate() {
    }

    /**
     * Creates a fully-populated certificate record.
     *
     * @param certificateId   database primary key
     * @param applicationId   application this certificate was issued for
     * @param certificateNo   human-readable certificate number printed on the PDF
     * @param issuedAt        when the certificate was issued
     * @param pdfFilePath     server path to the generated PDF (may be null
     *                        until PDF generation is wired up)
     * @param issuedByAdminId id of the admin who issued it
     */
    public IssuedCertificate(int certificateId, int applicationId, String certificateNo,
                             LocalDateTime issuedAt, String pdfFilePath, int issuedByAdminId) {
        this.certificateId = certificateId;
        this.applicationId = applicationId;
        this.certificateNo = certificateNo;
        this.issuedAt = issuedAt;
        this.pdfFilePath = pdfFilePath;
        this.issuedByAdminId = issuedByAdminId;
    }

    /** @return the certificate's database id */
    public int getCertificateId() {
        return certificateId;
    }

    /** @param certificateId new database id */
    public void setCertificateId(int certificateId) {
        this.certificateId = certificateId;
    }

    /** @return id of the application this certificate was issued for */
    public int getApplicationId() {
        return applicationId;
    }

    /** @param applicationId application this certificate is for */
    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    /** @return the human-readable certificate number */
    public String getCertificateNo() {
        return certificateNo;
    }

    /** @param certificateNo the certificate number */
    public void setCertificateNo(String certificateNo) {
        this.certificateNo = certificateNo;
    }

    /** @return when the certificate was issued */
    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    /** @param issuedAt issue timestamp */
    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    /** @return server path to the PDF, or {@code null} if not yet generated */
    public String getPdfFilePath() {
        return pdfFilePath;
    }

    /** @param pdfFilePath server path to the generated PDF */
    public void setPdfFilePath(String pdfFilePath) {
        this.pdfFilePath = pdfFilePath;
    }

    /** @return id of the admin who issued the certificate */
    public int getIssuedByAdminId() {
        return issuedByAdminId;
    }

    /** @param issuedByAdminId id of the issuing admin */
    public void setIssuedByAdminId(int issuedByAdminId) {
        this.issuedByAdminId = issuedByAdminId;
    }
}
