package Model;

import java.time.LocalDateTime;

public class ApplicationDocument {
    private int docId;
    private int applicationId;
    private String documentType;
    private String filePath;
    private LocalDateTime uploadedAt;
    private boolean isReusable;

    public ApplicationDocument() {
    }

    public ApplicationDocument(int docId, int applicationId, String documentType,
                               String filePath, LocalDateTime uploadedAt, boolean isReusable) {
        this.docId = docId;
        this.applicationId = applicationId;
        this.documentType = documentType;
        this.filePath = filePath;
        this.uploadedAt = uploadedAt;
        this.isReusable = isReusable;
    }

    public int getDocId() {
        return docId;
    }

    public void setDocId(int docId) {
        this.docId = docId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
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

    public boolean isReusable() {
        return isReusable;
    }

    public void setReusable(boolean reusable) {
        isReusable = reusable;
    }
}