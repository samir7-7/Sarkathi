package DAO.interfaces;

import Model.BudgetAllocation;

import java.sql.SQLException;
import java.util.List;

/**
 * Database access contract for {@link BudgetAllocation} records — the budget
 * line items shown on the public transparency page.
 *
 * @author SarkarSathi
 */
public interface BudgetAllocationDAOInterface {
    /**
     * Inserts a new allocation and returns it with its id populated.
     *
     * @param budget allocation to create
     * @return the saved allocation
     * @throws SQLException if the insert fails
     */
    BudgetAllocation create(BudgetAllocation budget) throws SQLException;

    /**
     * Updates an existing allocation.
     *
     * @param budget allocation to update
     * @return {@code true} if a row was updated
     * @throws SQLException if the update fails
     */
    boolean update(BudgetAllocation budget) throws SQLException;

    /**
     * Deletes an allocation.
     *
     * @param budgetId id of the allocation to delete
     * @return {@code true} if a row was deleted
     * @throws SQLException if the delete fails
     */
    boolean delete(int budgetId) throws SQLException;

    /**
     * @return every allocation across all wards and fiscal years
     * @throws SQLException if the query fails
     */
    List<BudgetAllocation> findAll() throws SQLException;
}
