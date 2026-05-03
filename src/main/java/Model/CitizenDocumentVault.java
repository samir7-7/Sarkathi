package Model;

import java.time.LocalDateTime;

/**
 * A document that a citizen has saved into their personal "vault" so it can
 * be reused across multiple applications without re-uploading.
 * <p>
 * Items typically end up here because the citizen uploaded them with
 * {@link ApplicationDocument#isReusable()} set to {@code true}, but the vault
 * can also be populated directly from the citizen's documents page.
 *
 * @author SarkarSathi
 */
public class CitizenDocumentVault {
    private int vaultDocId;
    private int citizenId;
    private String documentType;
    private String filePath;
    private LocalDateTime uploadedAt;

    /**
     * Creates an empty vault document.
     */
    public CitizenDocumentVault() {
    }

    /**
     * Creates a fully-populated vault document.
     *
     * @param vaultDocId    database primary key
     * @param citizenId     citizen this document belongs to
     * @param documentType  type of document (e.g. {@code citizenship})
     * @param filePath      server-relative path to the file
     * @param uploadedAt    when it was added to the vault
     */
    public CitizenDocumentVault(int vaultDocId, int citizenId, String documentType,
                                String filePath, LocalDateTime uploadedAt) {
        this.vaultDocId = vaultDocId;
        this.citizenId = citizenId;
        this.documentType = documentType;
        this.filePath = filePath;
        this.uploadedAt = uploadedAt;
    }

    /** @return database id of this vault entry */
    public int getVaultDocId() {
        return vaultDocId;
    }

    /** @param vaultDocId new database id */
    public void setVaultDocId(int vaultDocId) {
        this.vaultDocId = vaultDocId;
    }

    /** @return id of the owning citizen */
    public int getCitizenId() {
        return citizenId;
    }

    /** @param citizenId id of the owning citizen */
    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    /** @return document type string */
    public String getDocumentType() {
        return documentType;
    }

    /** @param documentType document type string */
    public void setDocumentType(String documentType) {
        this.documentType = documentType;
    }

    /** @return server-relative path to the stored file */
    public String getFilePath() {
        return filePath;
    }

    /** @param filePath path where the file is stored */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    /** @return when this document was added to the vault */
    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    /** @param uploadedAt vault upload timestamp */
    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
