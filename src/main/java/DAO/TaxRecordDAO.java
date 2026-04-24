package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import Model.TaxRecord;

public class TaxRecordDAO extends BaseDAO {
    private final Connection connection;

    public TaxRecordDAO(Connection connection) { this.connection = connection; }

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

    public boolean markAsPaid(int taxId, int paymentId) throws SQLException {
        String sql = "UPDATE TAX_RECORD SET IsPaid = TRUE, PaymentID = ? WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, paymentId); s.setInt(2, taxId); return s.executeUpdate() > 0;
        }
    }

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

    public java.util.Optional<TaxRecord> findById(int taxId) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE TaxID = ?";
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, taxId);
            try (ResultSet rs = s.executeQuery()) {
                return rs.next() ? java.util.Optional.of(map(rs)) : java.util.Optional.empty();
            }
        }
    }

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

    public List<TaxRecord> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE CitizenID = ? ORDER BY FiscalYear DESC";
        List<TaxRecord> records = new ArrayList<>();
        try (PreparedStatement s = connection.prepareStatement(sql)) {
            s.setInt(1, citizenId);
            try (ResultSet rs = s.executeQuery()) { while (rs.next()) records.add(map(rs)); }
        }
        return records;
    }

    private TaxRecord map(ResultSet rs) throws SQLException {
        TaxRecord t = new TaxRecord();
        t.setTaxId(rs.getInt("TaxID")); t.setCitizenId(rs.getInt("CitizenID"));
        t.setTaxType(rs.getString("TaxType")); t.setFiscalYear(rs.getString("FiscalYear"));
        t.setDueAmount(rs.getBigDecimal("DueAmount")); t.setPaymentId(rs.getInt("PaymentID"));
        t.setPaid(rs.getBoolean("IsPaid")); return t;
    }
}
