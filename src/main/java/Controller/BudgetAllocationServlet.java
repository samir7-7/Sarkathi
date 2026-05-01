package Controller;

import DAO.impl.BudgetAllocationDAO;
import Model.BudgetAllocation;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "budgetAllocationServlet", urlPatterns = "/api/budgets")
public class BudgetAllocationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            List<BudgetAllocation> items = new BudgetAllocationDAO(conn).findAll();
            List<String> json = new ArrayList<>();
            for (BudgetAllocation b : items) {
                json.add(toJson(b));
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(json));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try {
            requireAdmin(request);
            if ("delete".equalsIgnoreCase(getOptionalParameter(request, "action"))) {
                boolean ok = deleteBudget(request);
                redirectOrWriteJson(request, response, redirectTo,
                        ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND,
                        "{\"success\":" + ok + "}");
                return;
            }

            BudgetAllocation b = new BudgetAllocation();
            b.setWardId(Integer.parseInt(getRequiredParameter(request, "wardId")));
            b.setDepartment(getRequiredParameter(request, "department"));
            BigDecimal allocatedAmount = new BigDecimal(getRequiredParameter(request, "allocatedAmount"));
            if (allocatedAmount.signum() <= 0) {
                throw new IllegalArgumentException("Allocated amount must be greater than zero");
            }
            b.setAllocatedAmount(allocatedAmount);
            b.setFiscalYear(getRequiredParameter(request, "fiscalYear"));
            b.setDescription(getOptionalParameter(request, "description"));
            try (Connection conn = DatabaseConnection.getConnection()) {
                new BudgetAllocationDAO(conn).create(b);
                redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                        "{\"success\":true,\"budget\":" + toJson(b) + "}");
            }
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (Exception e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            requireAdmin(request);
            boolean ok = deleteBudget(request);
            writeJson(response, ok ? HttpServletResponse.SC_OK : HttpServletResponse.SC_NOT_FOUND, "{\"success\":" + ok + "}");
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    private boolean deleteBudget(HttpServletRequest request) throws SQLException {
        int id = Integer.parseInt(getRequiredParameter(request, "budgetId"));
        try (Connection conn = DatabaseConnection.getConnection()) {
            return new BudgetAllocationDAO(conn).delete(id);
        }
    }

    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/admin/budgets";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    private String toJson(BudgetAllocation b) {
        return "{\"budgetId\":" + b.getBudgetId()
                + ",\"wardId\":" + b.getWardId()
                + ",\"department\":" + quote(b.getDepartment())
                + ",\"allocatedAmount\":" + b.getAllocatedAmount()
                + ",\"fiscalYear\":" + quote(b.getFiscalYear())
                + ",\"description\":" + quote(b.getDescription()) + "}";
    }
}
