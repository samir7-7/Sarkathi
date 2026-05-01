package DAO.interfaces;

import Model.TaxRecord;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface TaxRecordDAOInterface {
    TaxRecord create(TaxRecord taxRecord) throws SQLException;

    boolean markAsPaid(int taxId, int paymentId) throws SQLException;

    TaxRecord update(TaxRecord taxRecord) throws SQLException;

    TaxRecord markAsPaidAndUpdateAmount(int taxId, int paymentId, BigDecimal amount) throws SQLException;

    Optional<TaxRecord> findById(int taxId) throws SQLException;

    Optional<TaxRecord> findByCitizenTypeAndFiscalYear(int citizenId, String taxType, String fiscalYear)
            throws SQLException;

    List<TaxRecord> findByCitizenId(int citizenId) throws SQLException;
}
