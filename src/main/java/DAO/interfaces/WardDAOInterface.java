package DAO.interfaces;

import Model.Ward;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface WardDAOInterface {
    List<Ward> findAll() throws SQLException;

    Optional<Ward> findById(int wardId) throws SQLException;
}
