package DAO.interfaces;

import Model.CitizenDocumentVault;

import java.sql.SQLException;
import java.util.List;

public interface CitizenDocumentVaultDAOInterface {
    CitizenDocumentVault create(CitizenDocumentVault doc) throws SQLException;

    List<CitizenDocumentVault> findByCitizenId(int citizenId) throws SQLException;

    List<CitizenDocumentVault> findByCitizenIdAndIds(int citizenId, List<Integer> vaultDocIds) throws SQLException;
}
