package DAO.interfaces;

import Model.AgricultureNotice;

import java.sql.SQLException;
import java.util.List;

public interface AgricultureNoticeDAOInterface {
    AgricultureNotice create(AgricultureNotice notice) throws SQLException;

    boolean update(AgricultureNotice notice) throws SQLException;

    boolean delete(int noticeId) throws SQLException;

    List<AgricultureNotice> findAll() throws SQLException;
}
