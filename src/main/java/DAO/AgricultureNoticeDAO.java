package DAO;

import Model.AgricultureNotice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AgricultureNoticeDAO extends BaseDAO {
    private final Connection connection;

    public AgricultureNoticeDAO(Connection connection) {
        this.connection = connection;
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
