package DAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

public abstract class BaseDAO {
    protected LocalDateTime getLocalDateTime(ResultSet resultSet, String column) throws SQLException {
        Timestamp timestamp = resultSet.getTimestamp(column);
        return timestamp == null ? null : timestamp.toLocalDateTime();
    }

    protected LocalDate getLocalDate(ResultSet resultSet, String column) throws SQLException {
        java.sql.Date date = resultSet.getDate(column);
        return date == null ? null : date.toLocalDate();
    }
}
