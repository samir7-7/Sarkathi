package Controller;

import DAO.ApplicationDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "analyticsServlet", urlPatterns = "/api/analytics")
public class AnalyticsServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            ApplicationDAO appDAO = new ApplicationDAO(conn);
            long total = appDAO.countAll();
            long approved = appDAO.countByStatus("approved");
            long rejected = appDAO.countByStatus("rejected");
            long submitted = appDAO.countByStatus("submitted");
            long review = appDAO.countByStatus("review");

            // Approval ratio
            double approvalRate = total > 0 ? (approved * 100.0 / total) : 0;
            double rejectionRate = total > 0 ? (rejected * 100.0 / total) : 0;

            // Average processing time (approved apps)
            double avgProcessingHours = 0;
            String avgSql = "SELECT AVG(TIMESTAMPDIFF(HOUR, SubmittedAt, LastUpdatedAt)) as avgHours FROM APPLICATION WHERE Status IN ('approved','rejected') AND LastUpdatedAt IS NOT NULL";
            try (PreparedStatement s = conn.prepareStatement(avgSql); ResultSet rs = s.executeQuery()) {
                if (rs.next()) avgProcessingHours = rs.getDouble("avgHours");
            }

            // Total citizens
            long totalCitizens = 0;
            try (PreparedStatement s = conn.prepareStatement("SELECT COUNT(*) FROM CITIZEN"); ResultSet rs = s.executeQuery()) {
                if (rs.next()) totalCitizens = rs.getLong(1);
            }

            // Monthly trend (last 6 months)
            StringBuilder monthlyTrend = new StringBuilder("[");
            String trendSql = "SELECT DATE_FORMAT(SubmittedAt, '%Y-%m') as month, COUNT(*) as cnt FROM APPLICATION WHERE SubmittedAt >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) GROUP BY month ORDER BY month";
            try (PreparedStatement s = conn.prepareStatement(trendSql); ResultSet rs = s.executeQuery()) {
                boolean first = true;
                while (rs.next()) {
                    if (!first) monthlyTrend.append(",");
                    monthlyTrend.append("{\"month\":").append(quote(rs.getString("month")))
                        .append(",\"count\":").append(rs.getInt("cnt")).append("}");
                    first = false;
                }
            }
            monthlyTrend.append("]");

            writeJson(response, HttpServletResponse.SC_OK,
                "{\"totalApplications\":" + total
                + ",\"approved\":" + approved
                + ",\"rejected\":" + rejected
                + ",\"submitted\":" + submitted
                + ",\"review\":" + review
                + ",\"approvalRate\":" + String.format("%.1f", approvalRate)
                + ",\"rejectionRate\":" + String.format("%.1f", rejectionRate)
                + ",\"avgProcessingHours\":" + String.format("%.1f", avgProcessingHours)
                + ",\"totalCitizens\":" + totalCitizens
                + ",\"monthlyTrend\":" + monthlyTrend
                + "}");
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
