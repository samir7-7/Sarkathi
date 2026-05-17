package DAO.interfaces;

import Model.Payment;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * Database access contract for {@link Payment} records.
 *
 * @author SarkarSathi
 */
public interface PaymentDAOInterface {
    /**
     * Records a new payment.
     *
     * @param payment the payment to save
     * @return the saved payment with its id populated
     * @throws SQLException if the insert fails
     */
    Payment create(Payment payment) throws SQLException;

    /**
     * Looks up a payment by id.
     *
     * @param paymentId payment to look up
     * @return matching payment if any
     * @throws SQLException if the query fails
     */
    Optional<Payment> findById(int paymentId) throws SQLException;

    /**
     * Returns every payment recorded against a given application — service
     * fee plus any tax payments tied to it.
     *
     * @param applicationId application to look up
     * @return the application's payments, possibly empty
     * @throws SQLException if the query fails
     */
    List<Payment> findByApplicationId(int applicationId) throws SQLException;
}
