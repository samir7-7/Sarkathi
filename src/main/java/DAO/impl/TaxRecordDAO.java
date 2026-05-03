package DAO.impl;

import DAO.interfaces.TaxRecordDAOInterface;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import Model.TaxRecord;

/**
 * JDBC implementation of {@link TaxRecordDAOInterface}.
 *
 * @author SarkarSathi
 */
public class TaxRecordDAO extends BaseDAO implements TaxRecordDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public TaxRecordDAO(Connection connection) { this.connection = connection; }

    /**
     * {@inheritDoc}
     * <p>
     * A {@code paymentId} of 0 (or less) is stored as SQL NULL since the
     * record hasn't been paid yet.
     */
    public TaxRecord create(TaxRecord t) throws SQLException {
        String sql = "INSERT INTO TAX_RECORD (CitizenID, TaxType, FiscalYear, DueAmount, PaymentID, IsPaid) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement s = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            s.setInt(1, t.getCitizenId()); s.setString(2, t.getTaxType()); s.setString(3, t.getFiscalYear());
            s.setBigDecimal(4, t.getDueAmount());
            if (t.getPaymentId() > 0) s.setInt(5, t.getPaymentId()); else s.setNull(5, Types.INTEGER);
            s.setBoolean(6, t.isPaid()); s.executeUpdate();
            try (ResultSet k = s.getGeneratedKeys()) { if (k.next()) t.setTaxId(k.getInt(1)); }
            return t;
        }
    }

    /**
     * {@inheritDoc}
     */
    public boolean markAsPaid(int taxId, int paymentId) throws SQLException {
        String sql = "UPDATE TAX_RECORD SET IsPaid = TRUE, PaymentID = ? WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, paymentId); s.setInt(2, taxId); return s.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     */
    public TaxRecord update(TaxRecord t) throws SQLException {
        String sql = "UPDATE TAX_RECORD SET FiscalYear = ?, DueAmount = ?, PaymentID = ?, IsPaid = ? WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setString(1, t.getFiscalYear());
            s.setBigDecimal(2, t.getDueAmount());
            if (t.getPaymentId() > 0) {
                s.setInt(3, t.getPaymentId());
            } else {
                s.setNull(3, Types.INTEGER);
            }
            s.setBoolean(4, t.isPaid());
            s.setInt(5, t.getTaxId());
            s.executeUpdate();
        }
        return t;
    }

    /**
     * {@inheritDoc}
     * <p>
     * Re-reads the row after the update so the caller gets the canonical
     * values (e.g. timestamps the database may have applied).
     */
    public TaxRecord markAsPaidAndUpdateAmount(int taxId, int paymentId, java.math.BigDecimal amount) throws SQLException {
        String sql = "UPDATE TAX_RECORD SET IsPaid = TRUE, PaymentID = ?, DueAmount = ? WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, paymentId);
            s.setBigDecimal(2, amount);
            s.setInt(3, taxId);
            s.executeUpdate();
        }
        return findById(taxId).orElse(null);
    }

    /**
     * {@inheritDoc}
     */
    public java.util.Optional<TaxRecord> findById(int taxId) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, taxId);
            try (ResultSet rs = s.executeQuery()) {
                return rs.next() ? java.util.Optional.of(map(rs)) : java.util.Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * The {@code LIMIT 1} guards against duplicates in case the data
     * accidentally got into a state with more than one row per
     * (citizen, tax type, fiscal year) combination.
     */
    public java.util.Optional<TaxRecord> findByCitizenTypeAndFiscalYear(int citizenId, String taxType, String fiscalYear) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE CitizenID = ? AND TaxType = ? AND FiscalYear = ? LIMIT 1";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            s.setString(2, taxType);
            s.setString(3, fiscalYear);
            try (ResultSet rs = s.executeQuery()) {
                return rs.next() ? java.util.Optional.of(map(rs)) : java.util.Optional.empty();
            }
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted newest fiscal year first.
     */
    public List<TaxRecord> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE CitizenID = ? ORDER BY FiscalYear DESC";
        List<TaxRecord> records = new ArrayList<>();
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            try (ResultSet rs = s.executeQuery()) { while (rs.next()) records.add(map(rs)); }
        }
        return records;
    }

    /**
     * Maps the current row into a {@link TaxRecord}.
     *
     * @param rs result set positioned on a {@code TAX_RECORD} row
     * @return the row as a tax record object
     * @throws SQLException if a column read fails
     */
    private TaxRecord map(ResultSet rs) throws SQLException {
        TaxRecord t = new TaxRecord();
        t.setTaxId(rs.getInt("TaxID")); t.setCitizenId(rs.getInt("CitizenID"));
        t.setTaxType(rs.getString("TaxType")); t.setFiscalYear(rs.getString("FiscalYear"));
        t.setDueAmount(rs.getBigDecimal("DueAmount")); t.setPaymentId(rs.getInt("PaymentID"));
        t.setPaid(rs.getBoolean("IsPaid")); return t;
    }
}
