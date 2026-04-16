package Model;

import java.time.LocalDateTime;

public class CitizenDocumentVault {
    private int vaultDocId;
    private int citizenId;
    private String documentType;
    private String filePath;
    private LocalDateTime uploadedAt;

    public CitizenDocumentVault() {
    }

    public CitizenDocumentVault(int vaultDocId, int citizenId, String documentType,
                                String filePath, LocalDateTime uploadedAt) {
        this.vaultDocId = vaultDocId;
        this.citizenId = citizenId;
        this.documentType = documentType;
        this.filePath = filePath;
        this.uploadedAt = uploadedAt;
    }

    public int getVaultDocId() {
        return vaultDocId;
    }

    public void setVaultDocId(int vaultDocId) {
        this.vaultDocId = vaultDocId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public String getDocumentType() {
        return documentType;
    }

    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}