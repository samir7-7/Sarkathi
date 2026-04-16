package Model;

import java.time.LocalDateTime;

public class IssuedCertificate {
    private int certificateId;
    private int applicationId;
    private String certificateNo;
    private LocalDateTime issuedAt;
    private String pdfFilePath;
    private int issuedByAdminId;

    public IssuedCertificate() {
    }

    public IssuedCertificate(int certificateId, int applicationId, String certificateNo,
                             LocalDateTime issuedAt, String pdfFilePath, int issuedByAdminId) {
        this.certificateId = certificateId;
        this.applicationId = applicationId;
        this.certificateNo = certificateNo;
        this.issuedAt = issuedAt;
        this.pdfFilePath = pdfFilePath;
        this.issuedByAdminId = issuedByAdminId;
    }

    public int getCertificateId() {
        return certificateId;
    }

    public void setCertificateId(int certificateId) {
        this.certificateId = certificateId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getCertificateNo() {
        return certificateNo;
    }

    public void setCertificateNo(String certificateNo) {
        this.certificateNo = certificateNo;
    }

    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    public String getPdfFilePath() {
        return pdfFilePath;
    }

    public void setPdfFilePath(String pdfFilePath) {
        this.pdfFilePath = pdfFilePath;
    }

    public int getIssuedByAdminId() {
        return issuedByAdminId;
    }

    public void setIssuedByAdminId(int issuedByAdminId) {
        this.issuedByAdminId = issuedByAdminId;
    }
}