package DAO;

import Model.AgricultureNotice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AgricultureNoticeDAO extends BaseDAO {
    private final Connection connection;

    public AgricultureNoticeDAO(Connection connection) {
        this.connection = connection;
    }

    public AgricultureNotice create(AgricultureNotice notice) throws SQLException {
        String sql = """
                INSERT INTO AGRICULTURE_NOTICE (PostedByAdminID, Title, Content, Category, PublishedAt)
                VALUES (?, ?, ?, ?, ?)
                """;
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, notice.getPostedByAdminId());
            statement.setString(2, notice.getTitle());
            statement.setString(3, notice.getContent());
            statement.setString(4, notice.getCategory());
            statement.setTimestamp(5, Timestamp.valueOf(
                    notice.getPublishedAt() != null ? notice.getPublishedAt() : LocalDateTime.now()));
            statement.executeUpdate();
            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    notice.setNoticeId(keys.getInt(1));
                }
            }
            return notice;
        }
    }

    public boolean update(AgricultureNotice notice) throws SQLException {
        String sql = "UPDATE AGRICULTURE_NOTICE SET Title = ?, Content = ?, Category = ? WHERE NoticeID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, notice.getTitle());
            statement.setString(2, notice.getContent());
            statement.setString(3, notice.getCategory());
            statement.setInt(4, notice.getNoticeId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean delete(int noticeId) throws SQLException {
        String sql = "DELETE FROM AGRICULTURE_NOTICE WHERE NoticeID = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, noticeId);
            return statement.executeUpdate() > 0;
        }
    }

    public List<AgricultureNotice> findAll() throws SQLException {
        String sql = "SELECT * FROM AGRICULTURE_NOTICE ORDER BY PublishedAt DESC";
        List<AgricultureNotice> notices = new ArrayList<>();
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                notices.add(map(resultSet));
            }
        }
        return notices;
    }

    private AgricultureNotice map(ResultSet resultSet) throws SQLException {
        AgricultureNotice notice = new AgricultureNotice();
        notice.setNoticeId(resultSet.getInt("NoticeID"));
        notice.setPostedByAdminId(resultSet.getInt("PostedByAdminID"));
        notice.setTitle(resultSet.getString("Title"));
        notice.setContent(resultSet.getString("Content"));
        notice.setCategory(resultSet.getString("Category"));
        notice.setPublishedAt(getLocalDateTime(resultSet, "PublishedAt"));
        return notice;
    }
}