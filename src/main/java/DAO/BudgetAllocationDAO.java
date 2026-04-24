package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import Model.BudgetAllocation;

public class BudgetAllocationDAO extends BaseDAO {
    private final Connection connection;

    public BudgetAllocationDAO(Connection connection) {
        this.connection = connection;
    }

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

    public boolean delete(int budgetId) throws SQLException {
        String sql = "DELETE FROM BUDGET_ALLOCATION WHERE BudgetID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, budgetId);
            return statement.executeUpdate() > 0;
        }
    }

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
