package DAO.impl;

import DAO.interfaces.BudgetAllocationDAOInterface;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Model.BudgetAllocation;

/**
 * JDBC implementation of {@link BudgetAllocationDAOInterface}.
 *
 * @author SarkarSathi
 */
public class BudgetAllocationDAO extends BaseDAO implements BudgetAllocationDAOInterface {
    private final Connection connection;

    /**
     * @param connection an open JDBC connection — caller owns its lifecycle
     */
    public BudgetAllocationDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * {@inheritDoc}
     */
    public BudgetAllocation create(BudgetAllocation budget) throws SQLException {
        String sql = """
                INSERT INTO BUDGET_ALLOCATION (WardID, Department, AllocatedAmount, FiscalYear, Description)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, budget.getWardId());
            statement.setString(2, budget.getDepartment());
            statement.setBigDecimal(3, budget.getAllocatedAmount());
            statement.setString(4, budget.getFiscalYear());
            statement.setString(5, budget.getDescription());
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    budget.setBudgetId(keys.getInt(1));
                }
            }
            return budget;
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Note: the ward this allocation belongs to isn't editable — to change
     * wards, delete and recreate the allocation.
     */
    public boolean update(BudgetAllocation budget) throws SQLException {
        String sql = "UPDATE BUDGET_ALLOCATION SET Department = ?, AllocatedAmount = ?, FiscalYear = ?, Description = ? WHERE BudgetID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, budget.getDepartment());
            statement.setBigDecimal(2, budget.getAllocatedAmount());
            statement.setString(3, budget.getFiscalYear());
            statement.setString(4, budget.getDescription());
            statement.setInt(5, budget.getBudgetId());
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     */
    public boolean delete(int budgetId) throws SQLException {
        String sql = "DELETE FROM BUDGET_ALLOCATION WHERE BudgetID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, budgetId);
            return statement.executeUpdate() > 0;
        }
    }

    /**
     * {@inheritDoc}
     * <p>
     * Sorted by fiscal year (newest first) and then department name, so
     * recent allocations float to the top of the transparency page.
     */
    public List<BudgetAllocation> findAll() throws SQLException {
        String sql = "SELECT * FROM BUDGET_ALLOCATION ORDER BY FiscalYear DESC, Department";
        List<BudgetAllocation> budgets = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                budgets.add(map(resultSet));
            }
        }
        return budgets;
    }

    /**
     * Maps the current row into a {@link BudgetAllocation}.
     *
     * @param resultSet result set positioned on a {@code BUDGET_ALLOCATION} row
     * @return the row as a budget allocation object
     * @throws SQLException if a column read fails
     */
    private BudgetAllocation map(ResultSet resultSet) throws SQLException {
        BudgetAllocation budget = new BudgetAllocation();
        budget.setBudgetId(resultSet.getInt("BudgetID"));
        budget.setWardId(resultSet.getInt("WardID"));
        budget.setDepartment(resultSet.getString("Department"));
        budget.setAllocatedAmount(resultSet.getBigDecimal("AllocatedAmount"));
        budget.setFiscalYear(resultSet.getString("FiscalYear"));
        budget.setDescription(resultSet.getString("Description"));
        return budget;
    }
}
