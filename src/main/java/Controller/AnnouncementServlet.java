package Controller;

import DAO.AnnouncementDAO;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Announcement;

@WebServlet(name = "announcementServlet", urlPatterns = "/api/announcements")
public class AnnouncementServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try (Connection connection = DatabaseConnection.getConnection()) {
            AnnouncementDAO announcementDAO = new AnnouncementDAO(connection);
            List<Announcement> announcements = announcementDAO.findAll();
            List<String> items = new ArrayList<>();
            for (Announcement announcement : announcements) {
                items.add("{"
                        + "\"announcementId\":" + announcement.getAnnouncementId() + ","
                        + "\"postedByAdminId\":" + announcement.getPostedByAdminId() + ","
                        + "\"title\":" + quote(announcement.getTitle()) + ","
                        + "\"content\":" + quote(announcement.getContent()) + ","
                        + "\"eventDate\":" + quote(announcement.getEventDate() == null ? null : announcement.getEventDate().toString()) + ","
                        + "\"publishedAt\":" + quote(announcement.getPublishedAt() == null ? null : announcement.getPublishedAt().toString())
                        + "}");
            }
            writeJson(response, HttpServletResponse.SC_OK, jsonArray(items));
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
