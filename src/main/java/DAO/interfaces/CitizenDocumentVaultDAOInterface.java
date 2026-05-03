package DAO.interfaces;

import Model.CitizenDocumentVault;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link CitizenDocumentVault} records — the
 * citizen's personal stash of reusable documents.
 *
 * @author SarkarSathi
 */
public interface CitizenDocumentVaultDAOInterface {
    /**
     * Saves a document into the citizen's vault.
     *
     * @param doc the vault document to save
     * @return the saved record with its id populated
     * @throws SQLException if the insert fails
     */
    CitizenDocumentVault create(CitizenDocumentVault doc) throws SQLException;

    /**
     * Returns everything in a citizen's vault.
     *
     * @param citizenId owning citizen
     * @return the citizen's vault contents, possibly empty
     * @throws SQLException if the query fails
     */
    List<CitizenDocumentVault> findByCitizenId(int citizenId) throws SQLException;

    /**
     * Looks up a specific subset of vault documents owned by a citizen — used
     * when the citizen picks reusable docs to attach to a new application.
     * The {@code citizenId} guard makes sure no one can attach someone else's
     * documents.
     *
     * @param citizenId    owning citizen (ownership check)
     * @param vaultDocIds  ids of the vault documents to fetch
     * @return matching vault documents owned by that citizen
     * @throws SQLException if the query fails
     */
    List<CitizenDocumentVault> findByCitizenIdAndIds(int citizenId, List<Integer> vaultDocIds) throws SQLException;
}
