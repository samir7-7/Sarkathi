package Controller;

import DAO.AgricultureNoticeDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.AgricultureNotice;

@WebServlet(name = "agricultureNoticeServlet", urlPatterns = "/api/agriculture-notices")
public class AgricultureNoticeServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            AgricultureNoticeDAO agricultureNoticeDAO = new AgricultureNoticeDAO(connection);
            List<AgricultureNotice> notices = agricultureNoticeDAO.findAll();
            List<String> items = new ArrayList<>();
            for (AgricultureNotice notice : notices) {
                items.add("{"
                        + "\"noticeId\":" + notice.getNoticeId() + ","
                        + "\"postedByAdminId\":" + notice.getPostedByAdminId() + ","
                        + "\"title\":" + quote(notice.getTitle()) + ","
                        + "\"content\":" + quote(notice.getContent()) + ","
                        + "\"category\":" + quote(notice.getCategory()) + ","
                        + "\"publishedAt\":" + quote(notice.getPublishedAt() == null ? null : notice.getPublishedAt().toString())
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
