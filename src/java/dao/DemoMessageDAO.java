package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DemoMessage;
import util.DBContext;

public class DemoMessageDAO extends DBContext {

    public List<DemoMessage> getAll() throws ClassNotFoundException, SQLException {
        List<DemoMessage> messages = new ArrayList<DemoMessage>();
        String sql = "SELECT id, content, created_at FROM dbo.DemoMessages ORDER BY id DESC";

        try (Connection connection = getConnection();
                PreparedStatement statement = connection.prepareStatement(sql);
                ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                messages.add(new DemoMessage(
                        resultSet.getInt("id"),
                        resultSet.getString("content"),
                        resultSet.getTimestamp("created_at")));
            }
        }
        return messages;
    }

    public void add(String content) throws ClassNotFoundException, SQLException {
        String sql = "INSERT INTO dbo.DemoMessages (content) VALUES (?)";
        try (Connection connection = getConnection();
                PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, content);
            statement.executeUpdate();
        }
    }
}
