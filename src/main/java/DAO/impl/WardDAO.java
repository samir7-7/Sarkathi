package DAO.impl;

import DAO.interfaces.WardDAOInterface;

import Model.Ward;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class WardDAO implements WardDAOInterface {
    private final Connection connection;

    public WardDAO(Connection connection) {
        this.connection = connection;
    }

    public List<Ward> findAll() throws SQLException {
        String sql = "SELECT * FROM WARD ORDER BY WardNumber";
        List<Ward> wards = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                wards.add(map(resultSet));
            }
        }
        return wards;
    }

    public Optional<Ward> findById(int wardId) throws SQLException {
        String sql = "SELECT * FROM WARD WHERE WardID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, wardId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? Optional.of(map(resultSet)) : Optional.empty();
            }
        }
    }

    private Ward map(ResultSet resultSet) throws SQLException {
        Ward ward = new Ward();
        ward.setWardId(resultSet.getInt("WardID"));
        ward.setWardNumber(resultSet.getInt("WardNumber"));
        ward.setMunicipalityName(resultSet.getString("MunicipalityName"));
        ward.setProvince(resultSet.getString("Province"));
        ward.setWardStampImage(resultSet.getString("WardStampImage"));
        return ward;
    }
}
