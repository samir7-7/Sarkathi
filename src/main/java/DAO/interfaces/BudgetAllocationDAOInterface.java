package DAO.interfaces;

import Model.BudgetAllocation;

import java.sql.SQLException;
import java.util.List;

public interface BudgetAllocationDAOInterface {
    BudgetAllocation create(BudgetAllocation budget) throws SQLException;

    boolean update(BudgetAllocation budget) throws SQLException;

    boolean delete(int budgetId) throws SQLException;

    List<BudgetAllocation> findAll() throws SQLException;
}
