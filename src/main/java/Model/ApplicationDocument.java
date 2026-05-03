package Model;

import java.time.LocalDateTime;

/**
 * A supporting document a citizen attached to a specific {@link Application}
 * — citizenship copy, passport-size photo, land deed, etc.
 * <p>
 * If {@link #isReusable} is {@code true}, the file is also linked into the
 * citizen's {@link CitizenDocumentVault} so it can be reused for future
 * applications without re-uploading.
 *
 * @author SarkarSathi
 */
public class ApplicationDocument {
    private int docId;
    private int applicationId;
    private String documentType;
    private String filePath;
    private LocalDateTime uploadedAt;
    private boolean isReusable;

    /**
     * Creates an empty document record.
     */
    public ApplicationDocument() {
    }

    /**
     * Creates a fully-populated document record.
     *
     * @param docId         database primary key
     * @param applicationId application this document is attached to
     * @param documentType  type of document (e.g. {@code citizenship},
     *                      {@code photo}, {@code land_deed})
     * @param filePath      server-relative path to the uploaded file
     * @param uploadedAt    upload timestamp
     * @param isReusable    whether this document should also be saved to the
     *                      citizen's reusable document vault
     */
    public ApplicationDocument(int docId, int applicationId, String documentType,
                               String filePath, LocalDateTime uploadedAt, boolean isReusable) {
        this.docId = docId;
        this.applicationId = applicationId;
        this.documentType = documentType;
        this.filePath = filePath;
        this.uploadedAt = uploadedAt;
        this.isReusable = isReusable;
    }

    /** @return the document's database id */
    public int getDocId() {
        return docId;
    }

    /** @param docId new database id */
    public void setDocId(int docId) {
        this.docId = docId;
    }

    /** @return id of the application this document is attached to */
    public int getApplicationId() {
        return applicationId;
    }

    /** @param applicationId application this document belongs to */
    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    /** @return the document type string */
    public String getDocumentType() {
        return documentType;
    }

    /** @param documentType document type string */
    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    /** @return server-relative path to the uploaded file */
    public String getFilePath() {
        return filePath;
    }

    /** @param filePath path where the file was saved */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    /** @return upload timestamp */
    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    /** @param uploadedAt upload timestamp */
    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    /**
     * @return {@code true} if this document is also linked into the citizen's
     *         reusable document vault
     */
    public boolean isReusable() {
        return isReusable;
    }

    /**
     * @param reusable whether to save this document into the citizen's
     *                 reusable document vault
     */
    public void setReusable(boolean reusable) {
        isReusable = reusable;
    }
}
