package DAO.impl;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Common superclass for every DAO implementation.
 * <p>
 * Right now it just hosts a couple of small helpers for pulling
 * {@code java.time} values out of a {@link ResultSet} without each DAO having
 * to repeat the null-check boilerplate. If we ever need shared connection
 * handling, transaction helpers, or row-mapping infrastructure, this is the
 * place to put it.
 *
 * @author SarkarSathi
 */
public abstract class BaseDAO {
    /**
     * Reads a {@code TIMESTAMP} column out of a result set as a
     * {@link LocalDateTime}, returning {@code null} if the column was SQL NULL.
     *
     * @param resultSet the result set to read from
     * @param column    column name to read
     * @return the value as a LocalDateTime, or {@code null} if the column was null
     * @throws SQLException if the underlying JDBC call fails
     */
    protected LocalDateTime getLocalDateTime(ResultSet resultSet, String column) throws SQLException {
        Timestamp timestamp = resultSet.getTimestamp(column);
        return timestamp == null ? null : timestamp.toLocalDateTime();
    }

    /**
     * Reads a {@code DATE} column out of a result set as a {@link LocalDate},
     * returning {@code null} if the column was SQL NULL.
     *
     * @param resultSet the result set to read from
     * @param column    column name to read
     * @return the value as a LocalDate, or {@code null} if the column was null
     * @throws SQLException if the underlying JDBC call fails
     */
    protected LocalDate getLocalDate(ResultSet resultSet, String column) throws SQLException {
        java.sql.Date date = resultSet.getDate(column);
        return date == null ? null : date.toLocalDate();
    }
}
