package DAO;

import Model.TaxRecord;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TaxRecordDAO {
    private final Connection connection;

    public TaxRecordDAO(Connection connection) {
        this.connection = connection;
    }

    public List<TaxRecord> findByCitizenId(int citizenId) throws SQLException {
        String sql = "SELECT * FROM TAX_RECORD WHERE CitizenID = ? ORDER BY FiscalYear DESC";
        List<TaxRecord> taxRecords = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, citizenId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    taxRecords.add(map(resultSet));
                }
            }
        }
        return taxRecords;
    }

    private TaxRecord map(ResultSet resultSet) throws SQLException {
        TaxRecord taxRecord = new TaxRecord();
        taxRecord.setTaxId(resultSet.getInt("TaxID"));
        taxRecord.setCitizenId(resultSet.getInt("CitizenID"));
        taxRecord.setTaxType(resultSet.getString("TaxType"));
        taxRecord.setFiscalYear(resultSet.getString("FiscalYear"));
        taxRecord.setDueAmount(resultSet.getBigDecimal("DueAmount"));
        taxRecord.setPaymentId(resultSet.getInt("PaymentID"));
        taxRecord.setPaid(resultSet.getBoolean("IsPaid"));
        return taxRecord;
    }
}
