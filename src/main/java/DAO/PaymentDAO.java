package DAO;

import Model.Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO extends BaseDAO {
    private final Connection connection;

    public PaymentDAO(Connection connection) {
        this.connection = connection;
    }

    public Payment create(Payment payment) throws SQLException {
        String sql = """
                INSERT INTO PAYMENT (ApplicationID, Amount, PaymentType, Status, PaidAt)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (payment.getApplicationId() > 0) {
                statement.setInt(1, payment.getApplicationId());
            } else {
                statement.setNull(1, java.sql.Types.INTEGER);
            }
            statement.setBigDecimal(2, payment.getAmount());
            statement.setString(3, payment.getPaymentType());
            statement.setString(4, payment.getStatus());
            statement.setTimestamp(5, payment.getPaidAt() == null ? null : Timestamp.valueOf(payment.getPaidAt()));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    payment.setPaymentId(keys.getInt(1));
                }
            }
            return payment;
        }
    }

    public List<Payment> findByApplicationId(int applicationId) throws SQLException {
        String sql = "SELECT * FROM PAYMENT WHERE ApplicationID = ? ORDER BY PaidAt DESC";
        List<Payment> payments = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, applicationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    payments.add(map(resultSet));
                }
            }
        }
        return payments;
    }

    private Payment map(ResultSet resultSet) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(resultSet.getInt("PaymentID"));
        payment.setApplicationId(resultSet.getInt("ApplicationID"));
        payment.setAmount(resultSet.getBigDecimal("Amount"));
        payment.setPaymentType(resultSet.getString("PaymentType"));
        payment.setStatus(resultSet.getString("Status"));
        payment.setPaidAt(getLocalDateTime(resultSet, "PaidAt"));
        return payment;
    }
}
