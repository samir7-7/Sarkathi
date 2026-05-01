package DAO.interfaces;

import Model.Citizen;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public interface CitizenDAOInterface {
    Citizen create(Citizen citizen) throws SQLException;

    Optional<Citizen> findById(int citizenId) throws SQLException;

    Optional<Citizen> findByEmail(String email) throws SQLException;

    List<Citizen> findAll() throws SQLException;

    Citizen update(Citizen citizen) throws SQLException;

    boolean deleteById(int citizenId) throws SQLException;
}
