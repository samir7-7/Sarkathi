package Controller;

import DAO.BudgetAllocationDAO;
import Util.DatabaseConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.BudgetAllocation;

@WebServlet(name = "budgetAllocationServlet", urlPatterns = "/api/budgets")
public class BudgetAllocationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            BudgetAllocationDAO budgetAllocationDAO = new BudgetAllocationDAO(connection);
            List<BudgetAllocation> budgets = budgetAllocationDAO.findAll();
            List<String> items = new ArrayList<>();
            for (BudgetAllocation budget : budgets) {
                items.add("{"
                        + "\"budgetId\":" + budget.getBudgetId() + ","
                        + "\"wardId\":" + budget.getWardId() + ","
                        + "\"department\":" + quote(budget.getDepartment()) + ","
                        + "\"allocatedAmount\":" + budget.getAllocatedAmount() + ","
                        + "\"fiscalYear\":" + quote(budget.getFiscalYear()) + ","
                        + "\"description\":" + quote(budget.getDescription())
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
