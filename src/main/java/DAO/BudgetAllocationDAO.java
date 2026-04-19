package DAO;

import Model.BudgetAllocation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BudgetAllocationDAO {
    private final Connection connection;

    public BudgetAllocationDAO(Connection connection) {
        this.connection = connection;
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
