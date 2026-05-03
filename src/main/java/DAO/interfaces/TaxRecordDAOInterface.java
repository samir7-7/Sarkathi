package DAO.interfaces;

import Model.TaxRecord;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link TaxRecord} entries.
 * <p>
 * Tax records are looked up per citizen and per fiscal year, and flipped to
 * paid once a corresponding {@link Model.Payment} record has been created.
 *
 * @author SarkarSathi
 */
public interface TaxRecordDAOInterface {
    /**
     * Creates a new tax record (typically when a fiscal year rolls over).
     *
     * @param taxRecord tax record to save
     * @return the saved record with its id populated
     * @throws SQLException if the insert fails
     */
    TaxRecord create(TaxRecord taxRecord) throws SQLException;

    /**
     * Marks a tax record as paid and links it to the payment that settled it.
     *
     * @param taxId      id of the tax record
     * @param paymentId  id of the payment that paid it
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean markAsPaid(int taxId, int paymentId) throws SQLException;

    /**
     * Updates a tax record's editable fields (typically the due amount).
     *
     * @param taxRecord record to update
     * @return the updated record
     * @throws SQLException if the update fails
     */
    TaxRecord update(TaxRecord taxRecord) throws SQLException;

    /**
     * Atomically updates the due amount, marks the record as paid, and links
     * it to a payment — used when the citizen pays a tax that may have been
     * pro-rated or otherwise recalculated at payment time.
     *
     * @param taxId     id of the tax record
     * @param paymentId id of the payment that settled it
     * @param amount    final amount that was actually paid
     * @return the updated record
     * @throws SQLException if the update fails
     */
    TaxRecord markAsPaidAndUpdateAmount(int taxId, int paymentId, BigDecimal amount) throws SQLException;

    /**
     * Looks up a tax record by id.
     *
     * @param taxId database id
     * @return matching record if any
     * @throws SQLException if the query fails
     */
    Optional<TaxRecord> findById(int taxId) throws SQLException;

    /**
     * Looks up a citizen's record for a specific tax type and fiscal year —
     * used to avoid creating duplicates when applying to pay a tax.
     *
     * @param citizenId   citizen to look up
     * @param taxType     {@code house} or {@code land}
     * @param fiscalYear  fiscal year string
     * @return matching record if any
     * @throws SQLException if the query fails
     */
    Optional<TaxRecord> findByCitizenTypeAndFiscalYear(int citizenId, String taxType, String fiscalYear)
            throws SQLException;

    /**
     * Returns every tax record on a citizen's account.
     *
     * @param citizenId citizen to look up
     * @return that citizen's tax records, possibly empty
     * @throws SQLException if the query fails
     */
    List<TaxRecord> findByCitizenId(int citizenId) throws SQLException;
}
