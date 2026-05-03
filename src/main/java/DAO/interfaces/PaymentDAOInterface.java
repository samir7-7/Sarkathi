package DAO.interfaces;

import Model.Payment;

import java.sql.SQLException;
import java.util.List;

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
     * Returns every payment recorded against a given application — service
     * fee plus any tax payments tied to it.
     *
     * @param applicationId application to look up
     * @return the application's payments, possibly empty
     * @throws SQLException if the query fails
     */
    List<Payment> findByApplicationId(int applicationId) throws SQLException;
}
