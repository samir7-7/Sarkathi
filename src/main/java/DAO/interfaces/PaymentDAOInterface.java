package DAO.interfaces;

import Model.Payment;

import java.sql.SQLException;
import java.util.List;

public interface PaymentDAOInterface {
    Payment create(Payment payment) throws SQLException;

    List<Payment> findByApplicationId(int applicationId) throws SQLException;
}
